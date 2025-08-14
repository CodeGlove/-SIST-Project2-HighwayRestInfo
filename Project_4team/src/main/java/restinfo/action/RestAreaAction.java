package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

public class RestAreaAction implements Action {

    private static final String RESULT_PAGE = "restArea.jsp";
    private static final int FIRST_INDEX = 0;

    // 내부 데이터 클래스
    private static class RestAreaData {
        List<String> allRestAreas;
        List<String> restAreas;
        List<String> restStops;
        List<Integer> allRestAreaDurations;
        List<Integer> restAreaDurations;
        List<Integer> restStopDurations;
        String allRestAreasStr;
        String restAreasStr;
        String restStopsStr;
        String origin;
        String destination;
        Integer distance;
        Integer duration;
        Integer taxiFare;
        Integer tollFare;

        RestAreaData() {
            // 기본값으로 빈 리스트 초기화
            this.allRestAreas = new ArrayList<>();
            this.restAreas = new ArrayList<>();
            this.restStops = new ArrayList<>();
            this.allRestAreaDurations = new ArrayList<>();
            this.restAreaDurations = new ArrayList<>();
            this.restStopDurations = new ArrayList<>();
        }
    }

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        // 데이터 추출 및 처리
        RestAreaData data = extractDataFromRequest(request);

        // 비즈니스 로직 처리
        boolean isUnifiedMode = isUnifiedMode(data.allRestAreas);
        List<Integer> serviceAreaOnlyDurations = calculateServiceAreaOnlyDurations(data.restAreas,
                data.restAreaDurations);

        // JSP로 전달할 데이터 설정
        setRequestAttributes(request, data, isUnifiedMode, serviceAreaOnlyDurations);

        return RESULT_PAGE;
    }

    /**
     * 요청에서 데이터를 추출하고 기본값을 설정하는 메소드
     */
    @SuppressWarnings("unchecked")
    private RestAreaData extractDataFromRequest(HttpServletRequest request) {
        RestAreaData data = new RestAreaData();

        // List 데이터 추출 및 null 체크
        data.allRestAreas = getListOrDefault((List<String>) request.getAttribute("allRestAreas"), data.allRestAreas);
        data.restAreas = getListOrDefault((List<String>) request.getAttribute("restAreas"), data.restAreas);
        data.restStops = getListOrDefault((List<String>) request.getAttribute("restStops"), data.restStops);
        data.allRestAreaDurations = getListOrDefault((List<Integer>) request.getAttribute("allRestAreaDurations"),
                data.allRestAreaDurations);
        data.restAreaDurations = getListOrDefault((List<Integer>) request.getAttribute("restAreaDurations"),
                data.restAreaDurations);
        data.restStopDurations = getListOrDefault((List<Integer>) request.getAttribute("restStopDurations"),
                data.restStopDurations);

        // 문자열 데이터 추출
        data.allRestAreasStr = (String) request.getAttribute("allRestAreasStr");
        data.restAreasStr = (String) request.getAttribute("restAreasStr");
        data.restStopsStr = (String) request.getAttribute("restStopsStr");
        data.origin = (String) request.getAttribute("origin");
        data.destination = (String) request.getAttribute("destination");

        // 숫자 데이터 추출
        data.distance = (Integer) request.getAttribute("distance");
        data.duration = (Integer) request.getAttribute("duration");
        data.taxiFare = (Integer) request.getAttribute("taxiFare");
        data.tollFare = (Integer) request.getAttribute("tollFare");

        return data;
    }

    /**
     * 통합 모드 여부를 확인하는 메소드
     */
    private boolean isUnifiedMode(List<String> allRestAreas) {
        return allRestAreas != null && !allRestAreas.isEmpty();
    }

    /**
     * 휴게소 간 소요시간을 계산하는 메소드
     */
    private List<Integer> calculateServiceAreaOnlyDurations(List<String> restAreas, List<Integer> restAreaDurations) {
        List<Integer> serviceAreaOnlyDurations = new ArrayList<>();

        if (restAreas.isEmpty() || restAreaDurations.isEmpty()) {
            return serviceAreaOnlyDurations;
        }

        // 첫 번째 휴게소는 출발지부터의 시간
        if (!restAreaDurations.isEmpty()) {
            serviceAreaOnlyDurations.add(restAreaDurations.get(FIRST_INDEX));
        }

        // 나머지 휴게소들은 이전 휴게소와의 간격
        for (int i = 1; i < restAreaDurations.size(); i++) {
            serviceAreaOnlyDurations.add(restAreaDurations.get(i));
        }

        return serviceAreaOnlyDurations;
    }

    /**
     * JSP에서 사용할 데이터를 request에 설정하는 메소드
     */
    private void setRequestAttributes(HttpServletRequest request, RestAreaData data,
            boolean isUnifiedMode, List<Integer> serviceAreaOnlyDurations) {
        request.setAttribute("isUnifiedMode", isUnifiedMode);
        request.setAttribute("allRestAreas", data.allRestAreas);
        request.setAttribute("restAreas", data.restAreas);
        request.setAttribute("restStops", data.restStops);
        request.setAttribute("allRestAreasStr", data.allRestAreasStr);
        request.setAttribute("restAreasStr", data.restAreasStr);
        request.setAttribute("restStopsStr", data.restStopsStr);
        request.setAttribute("allRestAreaDurations", data.allRestAreaDurations);
        request.setAttribute("restAreaDurations", data.restAreaDurations);
        request.setAttribute("restStopDurations", data.restStopDurations);
        request.setAttribute("serviceAreaOnlyDurations", serviceAreaOnlyDurations);
        request.setAttribute("origin", data.origin);
        request.setAttribute("destination", data.destination);
        request.setAttribute("distance", data.distance);
        request.setAttribute("duration", data.duration);
        request.setAttribute("taxiFare", data.taxiFare);
        request.setAttribute("tollFare", data.tollFare);
    }

    /**
     * null 체크 후 기본값을 반환하는 헬퍼 메소드
     */
    private <T> List<T> getListOrDefault(List<T> list, List<T> defaultList) {
        return list != null ? list : defaultList;
    }
}