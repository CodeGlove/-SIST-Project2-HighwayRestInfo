package restinfo.action;

import restinfo.dao.ManageDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class ForgotPasswordAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 이메일 주소를 받아 db에 있는 이메일인지 확인하고 있다면 해당 이메일로 비밀번호 재설정 링크를 보내야 됨
        String email = request.getParameter("email");
        System.out.println("email: " + email);
        int cnt = ManageDAO.checkAccount(email);
        System.out.println("cnt: " + cnt);
        // JSON 응답을 위한 설정
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (cnt > 0) {
            // 이메일로 검색한 계정이 있을때 수행되는 영역 여기서 이제 해당 이메일로 비밀번호 변경 jsp 보내야 됨
            out.print("{\"success\":true,\"message\":\"비밀번호 재설정 이메일이 발송되었습니다.\"}");

        } else {
            // 검색한 이메일이 db에 없는 경우 수행되는 영역 즉, 가입한적 없는 사용자임
            out.print("{\"success\":false,\"message\":\"가입되지 않은 이메일 주소입니다.\"}");
        }

        out.flush();
        out.close();
        return null; // JSON 응답이므로 페이지 이동 없음    
    }
}
