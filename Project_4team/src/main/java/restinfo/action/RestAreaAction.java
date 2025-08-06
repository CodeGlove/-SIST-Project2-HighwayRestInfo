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
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String distanceStr = request.getParameter("distance");
        String durationStr = request.getParameter("duration");
        String taxiFareStr = request.getParameter("taxiFare");
        String tollFareStr = request.getParameter("tollFare");
        String restAreaDurationsStr = request.getParameter("restAreaDurations");
        String restStopDurationsStr = request.getParameter("restStopDurations");

        List<String> restAreas = new ArrayList<>();
        List<String> restStops = new ArrayList<>();
        List<Integer> restAreaDurations = new ArrayList<>();
        List<Integer> restStopDurations = new ArrayList<>();

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

        // 휴게소 소요시간 문자열을 리스트로 변환
        if (restAreaDurationsStr != null && !restAreaDurationsStr.trim().isEmpty()) {
            // 배열 형태 제거 (예: "[18185]" -> "18185")
            String cleanStr = restAreaDurationsStr.replaceAll("[\\[\\]]", "");
            String[] durations = cleanStr.split(", ");
            for (String duration : durations) {
                if (!duration.trim().isEmpty()) {
                    try {
                        restAreaDurations.add(Integer.parseInt(duration.trim()));
                    } catch (NumberFormatException e) {
                        System.out.println("휴게소 소요시간 변환 오류: " + e.getMessage() + " (값: " + duration.trim() + ")");
                    }
                }
            }
        }

        // 졸음쉼터 소요시간 문자열을 리스트로 변환
        if (restStopDurationsStr != null && !restStopDurationsStr.trim().isEmpty()) {
            // 배열 형태 제거 (예: "[18185]" -> "18185")
            String cleanStr = restStopDurationsStr.replaceAll("[\\[\\]]", "");
            String[] durations = cleanStr.split(", ");
            for (String duration : durations) {
                if (!duration.trim().isEmpty()) {
                    try {
                        restStopDurations.add(Integer.parseInt(duration.trim()));
                    } catch (NumberFormatException e) {
                        System.out.println("졸음쉼터 소요시간 변환 오류: " + e.getMessage() + " (값: " + duration.trim() + ")");
                    }
                }
            }
        }

        // request에 저장
        request.setAttribute("restAreas", restAreas);
        request.setAttribute("restStops", restStops);
        request.setAttribute("restAreasStr", restAreasStr);
        request.setAttribute("restStopsStr", restStopsStr);
        request.setAttribute("restAreaDurations", restAreaDurations);
        request.setAttribute("restStopDurations", restStopDurations);
        request.setAttribute("origin", origin);
        request.setAttribute("destination", destination);

        // 거리, 시간, 통행료 정보 처리 및 저장
        try {
            if (distanceStr != null && !distanceStr.trim().isEmpty()) {
                int distance = Integer.parseInt(distanceStr);
                request.setAttribute("distance", distance);
            }
            if (durationStr != null && !durationStr.trim().isEmpty()) {
                int duration = Integer.parseInt(durationStr);
                request.setAttribute("duration", duration);
            }
            if (taxiFareStr != null && !taxiFareStr.trim().isEmpty()) {
                int taxiFare = Integer.parseInt(taxiFareStr);
                request.setAttribute("taxiFare", taxiFare);
            }
            if (tollFareStr != null && !tollFareStr.trim().isEmpty()) {
                int tollFare = Integer.parseInt(tollFareStr);
                request.setAttribute("tollFare", tollFare);
            }
        } catch (NumberFormatException e) {
            // 숫자 변환 실패 시 기본값 사용
            System.out.println("숫자 변환 오류: " + e.getMessage());
        }

        return "restArea.jsp";
    }
}