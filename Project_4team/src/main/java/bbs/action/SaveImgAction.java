package bbs.action;

import com.google.gson.JsonObject; //Gson 라이브러리 추가해야됨
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import restinfo.action.Action;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.PrintWriter;

public class SaveImgAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        // 이미지들이 저장될 위치(/editor_img)를 절대경로로 만들자
        ServletContext application = request.getServletContext(); //절대경로 얻기
        String realPath = application.getRealPath("/editor_img");

        //만약 폴더가 없다면 생성
        File dir = new File(realPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        //첨부되어 오는 이미지 파일을 위에서 준비한 절대경로에 업로드 시키기 위해서다.
        //그렇게 하기 위해서는 cos라이브러리의 MultipartRequest객체가 필요함!
        try{
            // 파일 업로드 실행
            MultipartRequest mr = new MultipartRequest(request, realPath,
                    1024*1024*5, "utf-8",
                    new DefaultFileRenamePolicy());
            // 업로드된 파일 정보 가져오기
            String fname = null;
            File f = mr.getFile("upload"); // CKEditor는 'upload' 이름으로 파일을 보냄
            if (f != null) {
                fname = f.getName();
            }

            // ********** 직접 JSON 응답 생성(중요!!!!) ************
            response.setContentType("application/json; charset=UTF-8"); //json 형식 선언

            //JSP를 거치지 않고 Action에서 직접 응답 데이터를 생성
            PrintWriter out = response.getWriter();
            JsonObject json = new JsonObject();
            json.addProperty("uploaded", 1); // 성공 여부
            json.addProperty("fileName", fname);

            //웹에서 접근 가능한 URL 경로 생성
            String url = request.getContextPath() + "/editor_img/" + fname;
            json.addProperty("url", url);

            out.print(json.toString()); // 생성된 JSON 객체를 응답으로 전송
            out.flush();
            out.close();

        } catch (Exception e) {
            e.printStackTrace();

            try {
                response.setContentType("application/json; charset=UTF-8");
                PrintWriter out = response.getWriter();
                JsonObject json = new JsonObject();
                json.addProperty("uploaded", 0);
                JsonObject error = new JsonObject();
                error.addProperty("message", "파일 업로드 중 오류 발생: " + e.getMessage());
                json.add("error", error);
                out.print(json.toString());
                out.flush();
                out.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        // Controller에게 JSP forward 안함!!! 명령
        return null;
    }
}
