package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class LogoutAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        // 현재 사용중인 세션을 얻기
        HttpSession session = request.getSession(false); //세션이 있을경우 세션을 새로 생성하지 않는다.

        String message = "";

        // 세션이 존재할 경우 삭제
        if (session != null) {
            session.invalidate(); //세션 무효화
            message = "정상적으로 로그아웃 되었습니다.";
            return "login.jsp";
        }

        //JSON 응답 생성
        /*try {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();

            String jsonResponse = String.format("{\"status\":\"success\"}", message);

            //클라이언트로 응답 전송
            out.print(jsonResponse);
            out.flush();
        } catch (Exception e){
            e.printStackTrace();
        }*/

        //로그인 페이지로 이동
        return "login.jsp";
    }
}
