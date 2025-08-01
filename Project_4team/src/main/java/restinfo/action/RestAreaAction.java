package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

public class RestAreaAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        // kakaoMap.jsp에서 전달받은 데이터 처리
        String restAreasStr = request.getParameter("restAreasStr");
        String restStopsStr = request.getParameter("restStopsStr");

        List<String> restAreas = new ArrayList<>();
        List<String> restStops = new ArrayList<>();

        // 휴게소 문자열을 리스트로 변환
        if (restAreasStr != null && !restAreasStr.trim().isEmpty()) {
            String[] areas = restAreasStr.split(", ");
            for (String area : areas) {
                if (!area.trim().isEmpty()) {
                    restAreas.add(area.trim());
                }
            }
        }

        // 졸음쉼터 문자열을 리스트로 변환
        if (restStopsStr != null && !restStopsStr.trim().isEmpty()) {
            String[] stops = restStopsStr.split(", ");
            for (String stop : stops) {
                if (!stop.trim().isEmpty()) {
                    restStops.add(stop.trim());
                }
            }
        }

        // request에 저장
        request.setAttribute("restAreas", restAreas);
        request.setAttribute("restStops", restStops);
        request.setAttribute("restAreasStr", restAreasStr);
        request.setAttribute("restStopsStr", restStopsStr);

        return "restArea.jsp";
    }
}