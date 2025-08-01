package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LogoutAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        // 현재 사용중인 세션을 얻기
        HttpSession session = request.getSession(false); //세션이 있을경우 세션을 새로 생성하지 않는다.

        // 세션이 존재할 경우 삭제
        if (session != null) {
            session.invalidate(); //세션안에 있는 데이터 삭제후 세션 무효화
        }

        try {
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }

        //Controller 한테 view 처리를 맡기지 않음
        return null;
    }
}
