package bbs.action;

import bbs.dao.BbsDAO;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import mybatis.vo.BbsVO;
import mybatis.vo.UserVO;
import restinfo.action.Action;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Properties;
import java.util.UUID;

// AWS S3 related imports
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.SdkClientException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;

public class EditAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {

        //******** 권한 확인 *********
        HttpSession session = request.getSession();
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");

        // 관리자 유효성 검사
        if (loginUser == null || !(loginUser.getAuthority().equals("1"))) {
            try {
                response.sendRedirect("Controller?type=notice");
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null; //권한이 없다면 forward 막기
        }

        // 요청 방식(GET, POST)을 확인
        String enc_type = request.getContentType();
        String viewPath = null;

        // **수정 페이지로 이동하는 GET 요청 처리**
        if (request.getMethod().equalsIgnoreCase("get")) {
            String PostNum = request.getParameter("PostNum");
            String cPage = request.getParameter("cPage");

            BbsVO vo = BbsDAO.getPostNum(PostNum);

            request.setAttribute("vo", vo);
            request.setAttribute("cPage", cPage);
            viewPath = "/bbs/edit.jsp";
            return viewPath;
        }

        // **수정된 데이터를 저장하는 POST 요청 처리**
        if (enc_type != null && enc_type.startsWith("multipart")) {
            try {
                // S3 설정 정보를 application.properties에서 읽어옴
                Properties prop = new Properties();
                InputStream is = getClass().getClassLoader().getResourceAsStream("application.properties");
                if (is == null) {
                    throw new IOException("application.properties 파일을 찾을 수 없습니다.");
                }
                prop.load(is);

                final String accessKey = prop.getProperty("aws.accessKeyId");
                final String secretKey = prop.getProperty("aws.secretAccessKey");
                final String bucketName = prop.getProperty("aws.s3.bucketName");
                final Regions region = Regions.fromName(prop.getProperty("aws.s3.region"));

                // 파일 업로드를 위한 임시 로컬 경로 설정
                ServletContext application = request.getServletContext();
                String realPath = application.getRealPath("/bbs_upload");
                File saveDir = new File(realPath);
                if (!saveDir.exists()) {
                    saveDir.mkdirs();
                }

                // MultipartRequest를 사용하여 파일 및 폼 데이터 파싱
                MultipartRequest mr = new MultipartRequest(request, realPath, 1024 * 1024 * 5, "utf-8", new DefaultFileRenamePolicy());

                // 폼 데이터 얻기
                String postNum = mr.getParameter("PostNum");
                String subject = mr.getParameter("subject");
                String content = mr.getParameter("content");
                String cPage = mr.getParameter("cPage");
                String oldFileName = mr.getParameter("oldFileName"); // 기존 파일명 (edit.jsp 폼에 hidden으로 추가해야 함)

                // 파일 첨부 관련 변수
                File newFile = mr.getFile("file");
                String s3FileKey = oldFileName; // 기본값은 기존 파일명

                // S3 클라이언트 생성
                AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
                AmazonS3 s3client = AmazonS3ClientBuilder.standard()
                        .withCredentials(new AWSStaticCredentialsProvider(credentials))
                        .withRegion(region)
                        .build();

                // 1. 새로운 파일이 첨부되었는지 확인
                if (newFile != null) {
                    // a. 기존 파일이 있으면 S3에서 삭제
                    if (oldFileName != null && !oldFileName.isEmpty()) {
                        s3client.deleteObject(new DeleteObjectRequest(bucketName, oldFileName));
                    }

                    // b. 새 파일을 S3에 업로드
                    String originalFileName = mr.getFilesystemName("file");
                    String fileExtension = "";
                    int dotIndex = originalFileName.lastIndexOf('.');
                    if (dotIndex > 0) {
                        fileExtension = originalFileName.substring(dotIndex);
                    }
                    s3FileKey = UUID.randomUUID().toString() + fileExtension;

                    s3client.putObject(new PutObjectRequest(bucketName, s3FileKey, newFile));

                    // 로컬 임시 파일 삭제
                    newFile.delete();

                } else {
                    // 2. 새로운 파일이 첨부되지 않은 경우
                    // 만약 '파일 삭제' 체크박스를 폼에 추가했다면 해당 로직을 여기에 구현
                    // 현재는 파일 변경이 없으면 기존 파일을 유지
                    s3FileKey = oldFileName;
                }

                // 3. 데이터베이스 업데이트
                BbsDAO.edit(postNum, subject, content, s3FileKey); // BbsDAO의 edit 메서드에 파일명 전달

                // 4. 수정 후 상세 페이지로 리다이렉션
                response.sendRedirect("Controller?type=view&PostNum=" + postNum + "&cPage=" + cPage);

            } catch (Exception e) {
                e.printStackTrace();
                // 오류 처리
                try {
                    response.setContentType("text/html; charset=UTF-8");
                    PrintWriter out = response.getWriter();
                    out.println("<script>alert('게시글 수정 중 오류가 발생했습니다.'); history.back();</script>");
                    out.flush();
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return null;
    }
}