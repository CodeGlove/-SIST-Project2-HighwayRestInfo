package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import restinfo.dao.ManageDAO;

public class getStatusAction implements Action{

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 구분자(chartType)는 같은 액션에서 여러 유형을 처리할 때 사용
        // 현재는 사용하지 않지만, 확장을 고려해 파라미터만 읽어둔다.
        // String chartType = request.getParameter("chartType");

        // JSON 응답 설정
        response.setContentType("application/json; charset=UTF-8");

        // DB에서 [kakao, naver, local] 순으로 개수 조회
        int[] counts = ManageDAO.getPlatformCount();

        // JSON 배열로 응답
        try (PrintWriter out = response.getWriter()) {
            out.print("[" + counts[0] + "," + counts[1] + "," + counts[2] + "]");
            out.flush();
        }
        // 포워딩 없음 (AJAX 응답 완료)
        return null;
    }
}