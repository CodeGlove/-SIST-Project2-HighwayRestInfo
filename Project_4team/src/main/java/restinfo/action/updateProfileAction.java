package restinfo.action;

import mybatis.vo.UserVO;
import restinfo.dao.updateUserDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class updateProfileAction implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String newNickName = request.getParameter("nickName"); // 새 닉네임으로 변수명 변경
        String favoriteSeason = request.getParameter("favoriteSeason");

        HttpSession session = request.getSession();
        UserVO vo = (UserVO) session.getAttribute("loginUser");


        String currentNickName = vo.getNickName(); // 현재 세션에 저장된 닉네임
        boolean isNicknameChanged = !newNickName.equals(currentNickName); // 닉네임이 변경되었는지 여부

        // 닉네임이 변경되었을 경우에만 중복 검사를 수행
        if (isNicknameChanged) {
            int count = updateUserDAO.isNicknameTaken(newNickName);
            if (count > 0) {
                // 중복된 닉네임이 존재하면, 여기서 처리를 중단하고 에러 메시지를 보냄
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"이미 사용 중인 닉네임입니다.\"}");
                return null; // 실행 종료
            }
        }




        // 중복이 아닐 경우(또는 닉네임 변경이 없는 경우), 기존 업데이트 로직 수행
        String ID = vo.getID();
        String platform = vo.getPlatform();
        int cnt = updateUserDAO.update(newNickName, favoriteSeason, ID, platform);

        // AJAX 요청에 대한 JSON 응답 생성 (기존과 동일)
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String jsonResponse;

        if (cnt > 0) { // 업데이트 성공
            vo.setNickName(newNickName);
            vo.setInterest(favoriteSeason);
            session.setAttribute("loginUser", vo);

            jsonResponse = "{\"success\": true, \"message\": \"성공적으로 수정되었습니다.\"}";
        } else { // 업데이트 실패
            jsonResponse = "{\"success\": false, \"message\": \"정보 수정에 실패했습니다.\"}";
        }

        response.getWriter().write(jsonResponse);
        return null;
    }
}