package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

public class RestAreaAction implements Action {
	
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		// KakaoMapAction에서 setAttribute로 전달받은 데이터 처리
		
		// Attribute에서 직접 List 객체 가져오기
		@SuppressWarnings("unchecked")
		List<String> allRestAreas = (List<String>) request.getAttribute("allRestAreas");
		@SuppressWarnings("unchecked")
		List<String> restAreas = (List<String>) request.getAttribute("restAreas");
		@SuppressWarnings("unchecked")
		List<String> restStops = (List<String>) request.getAttribute("restStops");
		@SuppressWarnings("unchecked")
		List<Integer> allRestAreaDurations = (List<Integer>) request.getAttribute("allRestAreaDurations");
		@SuppressWarnings("unchecked")
		List<Integer> restAreaDurations = (List<Integer>) request.getAttribute("restAreaDurations");
		@SuppressWarnings("unchecked")
		List<Integer> restStopDurations = (List<Integer>) request.getAttribute("restStopDurations");
		
		// 문자열 데이터 가져오기
		String allRestAreasStr = (String) request.getAttribute("allRestAreasStr");
		String restAreasStr = (String) request.getAttribute("restAreasStr");
		String restStopsStr = (String) request.getAttribute("restStopsStr");
		String origin = (String) request.getAttribute("origin");
		String destination = (String) request.getAttribute("destination");
		
		// 숫자 데이터 가져오기
		Integer distance = (Integer) request.getAttribute("distance");
		Integer duration = (Integer) request.getAttribute("duration");
		Integer taxiFare = (Integer) request.getAttribute("taxiFare");
		Integer tollFare = (Integer) request.getAttribute("tollFare");
		
		// 기본값 설정
		if (allRestAreas == null)
			allRestAreas = new ArrayList<>();
		if (restAreas == null)
			restAreas = new ArrayList<>();
		if (restStops == null)
			restStops = new ArrayList<>();
		if (allRestAreaDurations == null)
			allRestAreaDurations = new ArrayList<>();
		if (restAreaDurations == null)
			restAreaDurations = new ArrayList<>();
		if (restStopDurations == null)
			restStopDurations = new ArrayList<>();
		
		// 통합 방식인지 확인 (allRestAreas가 있으면 통합 방식)
		boolean isUnifiedMode = (allRestAreas != null && !allRestAreas.isEmpty());
		
		// serviceAreaOnlyDurations 계산
		List<Integer> serviceAreaOnlyDurations = new ArrayList<>();
		if (!restAreas.isEmpty() && !restAreaDurations.isEmpty()) {
			// 첫 번째 휴게소는 출발지부터의 시간
			if (!restAreaDurations.isEmpty()) {
				serviceAreaOnlyDurations.add(restAreaDurations.get(0));
			}
			
			// 나머지 휴게소들은 이전 휴게소와의 간격
			for (int i = 1; i < restAreaDurations.size(); i++) {
				serviceAreaOnlyDurations.add(restAreaDurations.get(i));
			}
		}
		
		// request에 데이터 다시 저장 (JSP에서 사용하기 위해)
		request.setAttribute("isUnifiedMode", isUnifiedMode);
		request.setAttribute("allRestAreas", allRestAreas);
		request.setAttribute("restAreas", restAreas);
		request.setAttribute("restStops", restStops);
		request.setAttribute("allRestAreasStr", allRestAreasStr);
		request.setAttribute("restAreasStr", restAreasStr);
		request.setAttribute("restStopsStr", restStopsStr);
		request.setAttribute("allRestAreaDurations", allRestAreaDurations);
		request.setAttribute("restAreaDurations", restAreaDurations);
		request.setAttribute("restStopDurations", restStopDurations);
		request.setAttribute("serviceAreaOnlyDurations", serviceAreaOnlyDurations);
		request.setAttribute("origin", origin);
		request.setAttribute("destination", destination);
		request.setAttribute("distance", distance);
		request.setAttribute("duration", duration);
		request.setAttribute("taxiFare", taxiFare);
		request.setAttribute("tollFare", tollFare);
		
		// 디버깅 로그
		
		return "restArea.jsp";
	}
}