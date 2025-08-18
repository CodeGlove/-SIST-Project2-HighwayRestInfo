package restinfo.action;

import mybatis.vo.UserVO;
import restinfo.dao.updateUserDAO; // DAO 경로에 맞게 import

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class deleteAccountAction implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {

        // 1. 세션에서 현재 로그인된 사용자 정보 가져오기
        HttpSession session = request.getSession();
        UserVO vo = (UserVO) session.getAttribute("loginUser");

        // 세션이 만료되었거나 비정상적인 접근일 경우를 대비한 방어 코드
        if (vo == null) {
            // 이미 로그아웃된 상태이므로 그냥 메인으로 보냄
            response.sendRedirect("index.jsp");
            return null;
        }

        // 2. DB 업데이트를 위해 사용자의 ID와 플랫폼 정보 추출
        String id = vo.getID();
        String platform = vo.getPlatform();

        // 3. DAO를 호출하여 Cancel 컬럼을 1로 업데이트
        int cnt = updateUserDAO.deactivateAccount(id, platform);

        // (선택) DB 업데이트 성공 여부를 로그로 남기거나 확인할 수 있습니다.
        if (cnt > 0) {
            System.out.println(id + " 계정 비활성화 성공");
        } else {
            System.out.println(id + " 계정 비활성화 실패");
        }

        // 4. 세션 무효화 (가장 중요)
        // session.removeAttribute("loginUser") 보다 invalidate()가 더 확실하게 모든 세션 정보를 제거
        session.invalidate();


        response.sendRedirect("index.jsp");

        return null;
    }
}