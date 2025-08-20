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
import java.io.PrintWriter;

public class WriteAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {



        //******** 권한 확인 *********
        /*HttpSession session = request.getSession();
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");

        //관리자 유효성 검사
        //로그인을 하지 않거나 관리자가 아닌 경우 공지사항 목록으로 이동
        if (loginUser == null || !(loginUser.getAuthority().equals("1"))) {
            try {
                response.sendRedirect("Controller?type=notice");
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null; //권한이 없다면 forward 막기
        }*/

        String viewPath = null;

        //list.jsp에 있는 [글쓰기]버튼을 클릭하면 get방식으로
        //현재 객체를 수행한다. 이때 요청시 contentType을 얻어낸다. 분명
        // get방식 null값을 받게된다.
        String enc_type = request.getContentType(); //get방식은 contentType이 없다.(post는 form)
        //System.out.println(enc_type);

        if (enc_type == null)
            viewPath = "/bbs/write.jsp";
        else if (enc_type.startsWith("multipart")) {
            //여기는 write.jsp에서 내용을 입력한 후 [완료] 버튼을
            // 클릭했을 때 수행하는 곳!
            // 첨부파일을 받아서 bbs_upload라는 폴더에 저장해야 합니다.
            try {
                ServletContext application = request.getServletContext(); //절대경로 얻기 위해 선언
                String realPath = application.getRealPath("/bbs_upload"); //절대경로 얻음
                // --- 추가된 코드 ---
                File saveDir = new File(realPath);
                if (!saveDir.exists()) {
                    saveDir.mkdirs(); // 디렉터리가 없으면 생성합니다.
                }
                // --- 추가된 코드 끝 ---

                //첨부파일과 다른 파라미터들을 받기위해 MultipartRequest생성(cos 라이브러리 필요함)
                MultipartRequest mr = new MultipartRequest(request, realPath,
                        1024 * 1024 * 5, "utf-8",
                        new DefaultFileRenamePolicy()); //동일한 이름이 있다면 바꿔라
                //이때 첨부파일이 있다면 realPath경로에 저장된 상태다.
                //나머지 파라미터들 얻기(title, writer, content) -> (write.jsp에서 name 확인 얻어내야 한다)
                String subject = mr.getParameter("subject");
                String writer = mr.getParameter("writer");
                String content = mr.getParameter("content");
                String category = mr.getParameter("category");
                String writeDate = mr.getParameter("writeDate");
                String ThumbsUp = mr.getParameter("ThumbsUp");
                String ThumbsDown = mr.getParameter("ThumbsDown");
                String Delete = mr.getParameter("Delete");
                String Pwd = mr.getParameter("Pwd");
                if(Pwd == null){
                    Pwd = "";
                }


                //첨부파일이 있다면 fname과 oname을 얻어내야 한다.
                File f = mr.getFile("file");
                String FileName = null;
                if (f != null) {
                    FileName = f.getName(); // 현재 저장된 파일명
                }
                //DB에 저장
                int result = BbsDAO.add(subject, writer, content, FileName, category,
                                        writeDate, ThumbsUp, ThumbsDown, Delete, Pwd);
                //DB에 저장이 완료되면 페이지 이동
                if(result > 0) {
                    response.sendRedirect("Controller?type=notice"); //저장 완료되면 공지사항 목록 페이지로 리다이렉트
                } else {
                    response.setContentType("text/html;charset=utf-8");
                    PrintWriter out = response.getWriter();
                    out.println("<script>alert('게시글 등록에 실패했습니다.'); history.back();</script>");
                    out.flush();
                }
            } catch (Exception e) {
                e.printStackTrace();
                try {
                    // 예외 발생 시 사용자에게 알림창을 띄우고 이전 페이지로 이동
                    response.setContentType("text/html; charset=UTF-8");
                    PrintWriter out = response.getWriter();
                    out.println("<script>alert('게시글 등록 중 오류가 발생했습니다.'); history.back();</script>");
                    out.flush();
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
            return null; //직접 response 처리해서 null 반환
        }
        return viewPath;
    }
}
