package restinfo.action;

import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 카카오 맵 API를 이용한 경로 검색 및 휴게소 정보 추출 액션
 * <p>
 * 주요 기능:
 * 1. 출발지/목적지 주소를 좌표로 변환
 * 2. 카카오 모빌리티 API 호출하여 경로 데이터 획득
 * 3. 경로상의 휴게소/졸음쉼터 정보 추출
 * 4. 각 휴게소 간 소요시간 계산
 * 5. 처리된 데이터를 request에 저장 후 적절한 페이지로 전달
 * <p>
 * API 의존성:
 * - 카카오 주소 검색 API (좌표 변환용)
 * - 카카오 모빌리티 내비게이션 API (경로 검색용)
 *
 * @author Team4
 * @since 2025-01-11
 */
public class KakaoMapAction implements Action {
	
	// === API 연동 설정 ===
	private static final String KAKAO_API_KEY = "2bb9195b03b5b17418309109544a85c4"; // 카카오 개발자 계정 API 키
	private static final String GEOCODING_BASE_URL = "https://dapi.kakao.com/v2/local/search/address.json"; // 주소→좌표 변환
	// API
	private static final String MOBILITY_BASE_URL = "https://apis-navi.kakaomobility.com/v1/directions"; // 경로 검색 API
	private static final String MOBILITY_PARAMS = "&summary=false&car_fuel=GASOLINE&car_hipass=false&alternatives=false&road_details=false"; // 경로
	// === 페이지 포워딩 결과값 ===
	private static final String FORWARD_TO_RESTAREA = "FORWARD_TO_RESTAREA"; // RestAreaAction으로 포워딩 신호
	private static final String CONTROLLER_RESULT = "Controller"; // 메인 컨트롤러로 이동
	private static final String INDEX_RESULT = "index.jsp"; // 에러 시 메인 페이지로 복귀
	// === HTTP 통신 관련 ===
	private static final String JSON_CONTENT_TYPE = "application/json; charset=UTF-8"; // JSON 응답 Content-Type
	private static final String KAKAO_AUTH_HEADER = "KakaoAK "; // 카카오 API 인증 헤더 접두사
	// === 휴게시설 분류 키워드 ===
	private static final String[] REST_AREA_KEYWORDS = {"휴게소", "서비스", "REST", "SERVICE"}; // 휴게소 식별 키워드
	private static final String REST_STOP_KEYWORD = "졸음쉼터"; // 졸음쉼터 식별 키워드
	// === HTTP 상태 코드 범위 ===
	private static final int HTTP_OK_MIN = 200; // HTTP 성공 응답 시작 범위
	private static final int HTTP_OK_MAX = 300; // HTTP 성공 응답 종료 범위
	private static final int HTTP_SERVER_ERROR = 500; // 서버 에러 응답 코드
	// === 요청 파라미터 값 ===
	private static final String REST_AREA_FORWARD = "restArea"; // 휴게소 페이지로 포워딩 요청값
	
	// ============================================================================
	// 상수 정의부 - 설정값과 키워드들을 중앙 관리
	// ============================================================================
	
	/**
	 * 메인 실행 메소드 - 전체 경로 검색 프로세스 제어
	 * <p>
	 * 처리 흐름:
	 * 1. 요청 파라미터 추출 및 검증
	 * 2. 주소 → 좌표 변환
	 * 3. 경로 검색 API 호출
	 * 4. 휴게소 정보 추출 및 소요시간 계산
	 * 5. 결과 데이터 저장 및 포워딩
	 *
	 * @param request  HTTP 요청 객체 (origin, destination, waypoints, priority,
	 *                 forwardTo 파라미터 포함)
	 * @param response HTTP 응답 객체 (에러 시 JSON 응답 전송용)
	 * @return 포워딩할 페이지 또는 액션 (index.jsp, Controller, FORWARD_TO_RESTAREA)
	 * @throws UnsupportedEncodingException URL 인코딩 실패 시
	 */
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response)
			throws UnsupportedEncodingException {
		// === 1단계: 요청 파라미터 추출 ===
		String origin = request.getParameter("origin"); // 출발지 주소
		String destination = request.getParameter("destination"); // 목적지 주소
		String waypoints = request.getParameter("waypoints"); // 경유지 주소들 ("|"로 구분)
		String priority = request.getParameter("priority"); // 경로 우선순위 (RECOMMEND, TIME, DISTANCE)
		String forwardTo = request.getParameter("forwardTo"); // 포워딩 대상 ("restArea" = 휴게소 페이지)
		
		// === 2단계: 입력값 검증 ===
		// 출발지와 목적지는 필수 입력값
		if (origin == null || origin.trim().isEmpty() ||
				destination == null || destination.trim().isEmpty()) {
			return setErrorAndReturn(request, "입력 오류", "출발지와 목적지를 모두 입력해주세요.",
					origin, destination, INDEX_RESULT);
		}
		
		try {
			// === 3단계: 주소 → 좌표 변환 ===
			// 카카오 주소 검색 API를 통해 한글 주소를 위도/경도 좌표로 변환
			String originCoords = getCoordinates(origin.trim(), KAKAO_API_KEY); // "경도,위도" 형태
			
			String destinationCoords = getCoordinates(destination.trim(), KAKAO_API_KEY);
			
			if (originCoords == null || destinationCoords == null) {
				return setErrorAndReturn(request, "주소 변환 실패",
						"입력한 주소를 좌표로 변환할 수 없습니다. 정확한 주소를 입력해주세요.",
						origin, destination, INDEX_RESULT);
			}
			
			// === 4단계: 경유지 처리 ===
			// 경유지가 있다면 각각을 좌표로 변환하여 "|" 구분자로 연결
			String waypointsCoords = processWaypoints(waypoints, KAKAO_API_KEY);
			
			// === 5단계: 경로 검색 API 호출 ===
			// 카카오 모빌리티 API를 통해 최적 경로 및 상세 정보(휴게소, 소요시간 등) 획득
			JSONObject routeData = callKakaoMobilityAPI(originCoords, destinationCoords, waypointsCoords, priority,
					KAKAO_API_KEY);
			
			// === 6단계: 응답 데이터 처리 및 저장 ===
			// 경로 데이터에서 휴게소 정보 추출, 소요시간 계산 후 request에 저장
			processRouteData(request, routeData, origin, destination, waypoints, waypointsCoords);
			
			// === 7단계: 결과 페이지 결정 ===
			if (REST_AREA_FORWARD.equalsIgnoreCase(forwardTo)) {
				// 휴게소 전용 페이지로 포워딩 요청인 경우
				// Controller에서 이 특수 문자열을 인식하여 RestAreaAction 실행
				return FORWARD_TO_RESTAREA;
			}
			
			// 일반적인 경우: 메인 결과 페이지(Controller)로 이동
			return CONTROLLER_RESULT;
			
		} catch (Exception e) {
			// === 디버그: 예외 상세 정보 ===
			System.out.println("=== 예외 발생 디버그 ===");
			System.out.println("❌ 예외 타입: " + e.getClass().getSimpleName());
			System.out.println("❌ 예외 메시지: " + e.getMessage());
			System.out.println("❌ 스택 트레이스:");
			e.printStackTrace();
			
			if (REST_AREA_FORWARD.equalsIgnoreCase(forwardTo)) {
				sendJsonError(response, HTTP_SERVER_ERROR, "서버 오류", "요청 처리 중 오류가 발생했습니다.");
				return null;
			}
			return setErrorAndReturn(request, "서버 오류", e.getMessage(), null, null, CONTROLLER_RESULT);
		}
	}
	
	/**
	 * request에 여러 속성을 한번에 설정하는 헬퍼 메소드
	 * <p>
	 * Map의 각 항목을 request.setAttribute로 일괄 설정하여
	 * 반복적인 setAttribute 호출을 줄이고 코드 가독성 향상
	 *
	 * @param request    HTTP 요청 객체
	 * @param attributes 설정할 속성들 (key=속성명, value=속성값)
	 */
	private void setRequestAttributes(HttpServletRequest request, Map<String, Object> attributes) {
		attributes.forEach(request::setAttribute);
	}
	
	/**
	 * 에러 정보를 request에 설정하고 리턴할 페이지를 반환하는 헬퍼 메소드
	 * <p>
	 * 에러 처리 시 반복되는 setAttribute 패턴을 단순화하여
	 * 코드 중복을 제거하고 일관된 에러 처리 보장
	 *
	 * @param request      HTTP 요청 객체
	 * @param errorType    에러 유형 ("입력 오류", "주소 변환 실패", "서버 오류" 등)
	 * @param errorMessage 사용자에게 표시할 상세 에러 메시지
	 * @param origin       출발지 주소 (복원용, null 가능)
	 * @param destination  목적지 주소 (복원용, null 가능)
	 * @param returnPage   포워딩할 페이지 경로
	 * @return 포워딩할 페이지 경로
	 */
	private String setErrorAndReturn(HttpServletRequest request, String errorType, String errorMessage,
	                                 String origin, String destination, String returnPage) {
		Map<String, Object> errorAttributes = new HashMap<>();
		errorAttributes.put("error", errorType);
		errorAttributes.put("errorMessage", errorMessage);
		if (origin != null)
			errorAttributes.put("origin", origin);
		if (destination != null)
			errorAttributes.put("destination", destination);
		
		setRequestAttributes(request, errorAttributes);
		return returnPage;
	}
	
	// JSON 에러 응답 전송
	private void sendJsonError(HttpServletResponse response, int status, String error, String message) {
		response.setStatus(status);
		response.setContentType(JSON_CONTENT_TYPE);
		try {
			JSONObject errorJson = new JSONObject();
			errorJson.put("error", error);
			errorJson.put("message", message);
			response.getWriter().write(errorJson.toString());
			response.getWriter().flush();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// 검색
	// 옵션
	
	// 경유지 처리
	private String processWaypoints(String waypoints, String apiKey) {
		if (waypoints == null || waypoints.trim().isEmpty()) {
			return null;
		}
		
		String[] waypointAddresses = waypoints.split("\\|");
		StringBuilder waypointsBuilder = new StringBuilder();
		
		for (String waypointAddress : waypointAddresses) {
			String waypointCoords = getCoordinates(waypointAddress.trim(), apiKey);
			if (waypointCoords != null) {
				if (waypointsBuilder.length() > 0) {
					waypointsBuilder.append("|");
				}
				waypointsBuilder.append(waypointCoords);
			}
		}
		
		return waypointsBuilder.length() > 0 ? waypointsBuilder.toString() : null;
	}
	
	// 카카오 모빌리티 API 호출
	private JSONObject callKakaoMobilityAPI(String originCoords, String destinationCoords,
	                                        String waypointsCoords, String priority, String apiKey) {
		try {
			String apiUrl = buildMobilityApiUrl(originCoords, destinationCoords, waypointsCoords, priority);
			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Authorization", KAKAO_AUTH_HEADER + apiKey);
			conn.setRequestProperty("Content-Type", "application/json");
			
			int responseCode = conn.getResponseCode();
			StringBuilder response = new StringBuilder();
			
			try (BufferedReader in = new BufferedReader(new InputStreamReader(
					responseCode >= HTTP_OK_MIN && responseCode < HTTP_OK_MAX
							? conn.getInputStream()
							: conn.getErrorStream(),
					StandardCharsets.UTF_8))) {
				
				String inputLine;
				while ((inputLine = in.readLine()) != null) {
					response.append(inputLine);
				}
			} finally {
				conn.disconnect();
			}
			
			if (responseCode >= HTTP_OK_MIN && responseCode < HTTP_OK_MAX) {
				JSONObject jsonResponse = new JSONObject(response.toString());
				return jsonResponse;
			} else {
				System.out.println("❌ API 호출 실패 - HTTP " + responseCode);
				System.out.println("❌ 에러 응답: " + response);
				return null;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	// 경로 데이터 처리
	private void processRouteData(HttpServletRequest request, JSONObject routeData,
	                              String origin, String destination, String waypoints, String waypointsCoords) {
		try {
			
			JSONArray routes = routeData.getJSONArray("routes");
			if (routes.length() == 0) {
				System.out.println("❌ routes 배열이 비어있습니다!");
				return;
			}
			
			JSONObject route = routes.getJSONObject(0);
			if (!route.has("sections")) {
				System.out.println("❌ route에 'sections' 키가 없습니다!");
				System.out.println("route 상세 내용: " + route.toString(2));
				return;
			}
			
			JSONArray sections = route.getJSONArray("sections");
			// 휴게소 정보 추출
			List<String> allRestAreas = new ArrayList<>();
			List<String> restAreas = new ArrayList<>();
			List<String> restStops = new ArrayList<>();
			
			extractRestAreas(sections, allRestAreas, restAreas, restStops);
			
			// 소요시간 계산
			List<Integer> allRestAreaDurations = calculateDurationsToRestAreas(sections, allRestAreas);
			List<Integer> restAreaDurations = calculateDurationsToRestAreas(sections, restAreas);
			List<Integer> restStopDurations = calculateDurationsToRestAreas(sections, restStops);
			
			// request에 데이터 저장
			saveRouteDataToRequest(request, route, sections, allRestAreas, restAreas, restStops,
					allRestAreaDurations, restAreaDurations, restStopDurations,
					origin, destination, waypoints, waypointsCoords, routeData);
		} catch (Exception e) {
			System.out.println("=== processRouteData 예외 발생 ===");
			System.out.println("❌ 예외 타입: " + e.getClass().getSimpleName());
			System.out.println("❌ 예외 메시지: " + e.getMessage());
			System.out.println("❌ 스택 트레이스:");
			e.printStackTrace();
		}
	}
	
	// 휴게소 여부 확인
	private boolean isRestArea(String name) {
		for (String keyword : REST_AREA_KEYWORDS) {
			if (name.contains(keyword)) {
				return true;
			}
		}
		return false;
	}
	
	// 졸음쉼터 여부 확인
	private boolean isRestStop(String name) {
		return name.contains(REST_STOP_KEYWORD);
	}
	
	// 모빌리티 API URL 생성
	private String buildMobilityApiUrl(String originCoords, String destinationCoords,
	                                   String waypointsCoords, String priority) {
		StringBuilder urlBuilder = new StringBuilder();
		urlBuilder.append(MOBILITY_BASE_URL);
		urlBuilder.append("?origin=").append(URLEncoder.encode(originCoords, StandardCharsets.UTF_8));
		urlBuilder.append("&destination=").append(URLEncoder.encode(destinationCoords, StandardCharsets.UTF_8));
		
		if (waypointsCoords != null && !waypointsCoords.trim().isEmpty()) {
			urlBuilder.append("&waypoints=").append(URLEncoder.encode(waypointsCoords, StandardCharsets.UTF_8));
		}
		
		if (priority != null && !priority.trim().isEmpty()) {
			urlBuilder.append("&priority=").append(priority);
		}
		
		urlBuilder.append(MOBILITY_PARAMS);
		
		return urlBuilder.toString();
	}
	
	// 휴게소 정보 추출
	private void extractRestAreas(JSONArray sections, List<String> allRestAreas,
	                              List<String> restAreas, List<String> restStops) {
		for (int i = 0; i < sections.length(); i++) {
			JSONObject section = sections.getJSONObject(i);
			if (section.has("guides")) {
				JSONArray guides = section.getJSONArray("guides");
				for (int j = 0; j < guides.length(); j++) {
					JSONObject guide = guides.getJSONObject(j);
					if (guide.has("name") && !guide.getString("name").isEmpty()) {
						String guideName = guide.getString("name");
						
						if (isRestArea(guideName)) {
							restAreas.add(guideName);
							allRestAreas.add(guideName);
						} else if (isRestStop(guideName)) {
							restStops.add(guideName);
							allRestAreas.add(guideName);
						}
					}
				}
			}
		}
	}
	
	// request에 경로 데이터 저장
	private void saveRouteDataToRequest(HttpServletRequest request, JSONObject route, JSONArray sections,
	                                    List<String> allRestAreas, List<String> restAreas, List<String> restStops,
	                                    List<Integer> allRestAreaDurations, List<Integer> restAreaDurations,
	                                    List<Integer> restStopDurations, String origin, String destination,
	                                    String waypoints, String waypointsCoords, JSONObject routeData) {
		
		Map<String, Object> routeAttributes = new HashMap<>();
		
		// 기본 정보
		routeAttributes.put("origin", origin);
		routeAttributes.put("destination", destination);
		routeAttributes.put("waypoints", waypoints);
		routeAttributes.put("waypointsCoords", waypointsCoords);
		
		// 휴게소 정보
		routeAttributes.put("allRestAreas", allRestAreas);
		routeAttributes.put("restAreas", restAreas);
		routeAttributes.put("restStops", restStops);
		routeAttributes.put("allRestAreasStr", String.join(", ", allRestAreas));
		routeAttributes.put("restAreasStr", String.join(", ", restAreas));
		routeAttributes.put("restStopsStr", String.join(", ", restStops));
		
		// 소요시간 정보
		routeAttributes.put("allRestAreaDurations", allRestAreaDurations);
		routeAttributes.put("restAreaDurations", restAreaDurations);
		routeAttributes.put("restStopDurations", restStopDurations);
		
		// 요약 정보
		if (route.has("summary")) {
			JSONObject summary = route.getJSONObject("summary");
			routeAttributes.put("summary", summary);
			routeAttributes.put("distance", summary.optInt("distance", 0));
			routeAttributes.put("duration", summary.optInt("duration", 0));
			
			if (summary.has("fare")) {
				JSONObject fare = summary.getJSONObject("fare");
				routeAttributes.put("taxiFare", fare.optInt("taxi", 0));
				routeAttributes.put("tollFare", fare.optInt("toll", 0));
			}
		}
		
		// 상세 경로 정보
		if (route.has("sections")) {
			routeAttributes.put("sections", convertSectionsToMap(sections));
		}
		
		// 전체 JSON 응답 (디버깅용)
		routeAttributes.put("jsonResponse", routeData);
		
		// 한번에 모든 속성 설정
		setRequestAttributes(request, routeAttributes);
	}
	
	// sections를 Map으로 변환
	private List<Map<String, Object>> convertSectionsToMap(JSONArray sections) {
		List<Map<String, Object>> sectionsList = new ArrayList<>();
		
		for (int i = 0; i < sections.length(); i++) {
			JSONObject sectionJson = sections.getJSONObject(i);
			Map<String, Object> sectionMap = new HashMap<>();
			
			sectionMap.put("distance", sectionJson.optInt("distance", 0));
			sectionMap.put("duration", sectionJson.optInt("duration", 0));
			
			if (sectionJson.has("roads")) {
				JSONArray roadsJson = sectionJson.getJSONArray("roads");
				List<Map<String, Object>> roadsList = new ArrayList<>();
				
				for (int j = 0; j < roadsJson.length(); j++) {
					JSONObject roadJson = roadsJson.getJSONObject(j);
					Map<String, Object> roadMap = new HashMap<>();
					roadMap.put("name", roadJson.optString("name", ""));
					roadMap.put("distance", roadJson.optInt("distance", 0));
					roadsList.add(roadMap);
				}
				
				sectionMap.put("roads", roadsList);
			}
			
			sectionsList.add(sectionMap);
		}
		
		return sectionsList;
	}
	
	/**
	 * 주소를 좌표로 변환하는 메서드
	 *
	 * @param address 변환할 주소 (한글)
	 * @param apiKey  카카오 API 키
	 * @return "경도,위도" 형태의 좌표 문자열, 실패시 null
	 */
	private String getCoordinates(String address, String apiKey) {
		try {
			String encodedAddress = URLEncoder.encode(address, StandardCharsets.UTF_8);
			String geocodingUrl = GEOCODING_BASE_URL + "?query=" + encodedAddress;
			
			URL url = new URL(geocodingUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Authorization", KAKAO_AUTH_HEADER + apiKey);
			
			int responseCode = conn.getResponseCode();
			StringBuilder response = new StringBuilder();
			
			try (BufferedReader in = new BufferedReader(
					new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
				
				String inputLine;
				while ((inputLine = in.readLine()) != null) {
					response.append(inputLine);
				}
			} finally {
				conn.disconnect();
			}
			
			if (responseCode >= HTTP_OK_MIN && responseCode < HTTP_OK_MAX) {
				JSONObject jsonResponse = new JSONObject(response.toString());
				if (jsonResponse.has("documents") && jsonResponse.getJSONArray("documents").length() > 0) {
					JSONObject document = jsonResponse.getJSONArray("documents").getJSONObject(0);
					String x = document.getString("x");
					String y = document.getString("y");
					return x + "," + y;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	/**
	 * 휴게소/졸음쉼터 간의 소요시간을 계산하는 메서드
	 *
	 * @param sections  경로의 sections 배열
	 * @param restAreas 휴게소/졸음쉼터 이름 리스트
	 * @return 각 휴게소/졸음쉼터 간의 소요시간 리스트 (초 단위)
	 */
	private List<Integer> calculateDurationsToRestAreas(JSONArray sections, List<String> restAreas) {
		List<Integer> durations = new ArrayList<>();
		Map<String, Integer> restAreaDurations = new HashMap<>();
		List<String> foundRestAreas = new ArrayList<>();
		int currentDuration = 0;
		int lastRestAreaDuration = 0;
		
		for (int i = 0; i < sections.length(); i++) {
			JSONObject section = sections.getJSONObject(i);
			
			if (section.has("guides")) {
				JSONArray guides = section.getJSONArray("guides");
				for (int j = 0; j < guides.length(); j++) {
					JSONObject guide = guides.getJSONObject(j);
					
					int guideDuration = guide.optInt("duration", 0);
					currentDuration += guideDuration;
					
					if (guide.has("name") && !guide.getString("name").isEmpty()) {
						String guideName = guide.getString("name");
						
						boolean isRestAreaFound = restAreas.contains(guideName) ||
								isRestArea(guideName) ||
								isRestStop(guideName);
						
						if (isRestAreaFound && restAreas.contains(guideName)) {
							if (!foundRestAreas.contains(guideName)) {
								foundRestAreas.add(guideName);
								
								if (foundRestAreas.size() == 1) {
									restAreaDurations.put(guideName, currentDuration);
								} else {
									int segmentDuration = currentDuration - lastRestAreaDuration;
									restAreaDurations.put(guideName, segmentDuration);
								}
								
								lastRestAreaDuration = currentDuration;
							}
						}
					}
				}
			}
		}
		
		for (String restArea : restAreas) {
			if (restAreaDurations.containsKey(restArea)) {
				durations.add(restAreaDurations.get(restArea));
			} else {
				durations.add(0);
			}
		}
		
		return durations;
	}
}
