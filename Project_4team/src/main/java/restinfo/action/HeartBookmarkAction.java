package restinfo.action;

import mybatis.vo.UserVO;
import org.json.JSONObject;
import restinfo.dao.BookmarkDAO;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class HeartBookmarkAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        UserVO user = (UserVO) session.getAttribute("loginUser");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        JSONObject json = new JSONObject();
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401: 권한 없음
            json.put("success", false);
            json.put("message", "로그인이 필요합니다.");
            out.print(json.toString());
            out.flush();
            return null; // 여기 컨트롤로에 로그인.jsp를 전달해도 되지 않을까>?
        }

        String saKey = request.getParameter("saKey");
        String action = request.getParameter("action"); // "add" 또는 "delete"??@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        String userKey = String.valueOf(user.getIdx());

        boolean success = false;
        try {
            if ("add".equals(action)) {
                success = BookmarkDAO.addBookmark(userKey, saKey) > 0;
            } else if ("delete".equals(action)) {
                success = BookmarkDAO.deleteBookmark(userKey, saKey) > 0;
            }

            // 북마크 처리 성공 시 세션의 북마크 리스트 업데이트
            if (success) {
                try {
                    List<String> updatedBookmarks = BookmarkDAO.getBookmarkedSaKeys(userKey);
                    session.setAttribute("bookmarkedSaKeys", updatedBookmarks);
                    System.out.println("세션 북마크 리스트 업데이트 완료: " + updatedBookmarks.size() + "개");
                } catch (Exception e) {
                    System.out.println("세션 북마크 리스트 업데이트 실패: " + e.getMessage());
                }
            }

            json.put("success", success);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500: 서버 오류
            json.put("success", false);
            json.put("message", "처리 중 오류가 발생했습니다.");
        }

        out.print(json.toString());
        out.flush();
        return null;
    }
}
