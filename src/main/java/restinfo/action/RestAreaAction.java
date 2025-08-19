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
		List<Integer> allRestAreaDurations = (List<Integer>) request.getAttribute("allRestAreaDurations");

		// 문자열 데이터 가져오기
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
		if (allRestAreaDurations == null)
			allRestAreaDurations = new ArrayList<>();

		// serviceAreaOnlyDurations 계산 (휴게소만 필터링)
		List<Integer> serviceAreaOnlyDurations = new ArrayList<>();
		List<String> serviceAreasOnly = new ArrayList<>();
		int cumulativeDuration = 0; // 누적 시간

		for (int i = 0; i < allRestAreas.size(); i++) {
			String restArea = allRestAreas.get(i);
			if (restArea.contains("휴게소") || restArea.contains("서비스") ||
					restArea.contains("REST") || restArea.contains("SERVICE")) {
				serviceAreasOnly.add(restArea);
				if (i < allRestAreaDurations.size()) {
					// 휴게소끼리의 시간 계산 (이전 휴게소부터의 시간)
					cumulativeDuration += allRestAreaDurations.get(i);
					serviceAreaOnlyDurations.add(cumulativeDuration);
				}
			} else {
				// 졸음쉼터인 경우 누적 시간에 추가 (휴게소 시간 계산에 포함)
				if (i < allRestAreaDurations.size()) {
					cumulativeDuration += allRestAreaDurations.get(i);
				}
			}
		}

		// request에 데이터 다시 저장 (JSP에서 사용하기 위해)
		request.setAttribute("allRestAreas", allRestAreas);
		request.setAttribute("allRestAreaDurations", allRestAreaDurations);
		request.setAttribute("serviceAreaOnlyDurations", serviceAreaOnlyDurations);
		request.setAttribute("serviceAreasOnly", serviceAreasOnly);
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