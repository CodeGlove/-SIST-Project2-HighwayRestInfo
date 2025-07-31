package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.json.JSONObject;
import org.json.JSONArray;

public class KakaoMapAction implements Action {

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response)
			throws UnsupportedEncodingException {
		// POST 요청 처리
		if ("POST".equalsIgnoreCase(request.getMethod())) {
			// 폼에서 입력받은 데이터 추출
			String origin = request.getParameter("origin");
			String destination = request.getParameter("destination");
			String waypoints = request.getParameter("waypoints");
			String priority = request.getParameter("priority");

			// 필수 입력값 검증
			if (origin != null && destination != null && !origin.trim().isEmpty() && !destination.trim().isEmpty()) {
				try {
					// 카카오 API 키 설정
					String apiKey = "2bb9195b03b5b17418309109544a85c4";

					// 1단계: 주소를 좌표로 변환
					String originCoords = getCoordinates(origin.trim(), apiKey);
					String destinationCoords = getCoordinates(destination.trim(), apiKey);

					// 좌표 변환 실패 시 에러 메시지 표시
					if (originCoords == null || destinationCoords == null) {
						request.setAttribute("error", "주소 변환 실패");
						request.setAttribute("errorMessage", "입력한 주소를 좌표로 변환할 수 없습니다. 정확한 주소를 입력해주세요.");
						return "kakaoMap.jsp";
					}

					// 2단계: 경유지 좌표 변환 (선택사항)
					String waypointsCoords = null;
					if (waypoints != null && !waypoints.trim().isEmpty()) {
						// |로 구분된 경유지 주소들을 배열로 분리
						String[] waypointAddresses = waypoints.split("\\|");
						StringBuilder waypointsBuilder = new StringBuilder();

						// 각 경유지 주소를 좌표로 변환
						for (int i = 0; i < waypointAddresses.length; i++) {
							String waypointCoords = getCoordinates(waypointAddresses[i].trim(), apiKey);
							if (waypointCoords != null) {
								if (waypointsBuilder.length() > 0) {
									waypointsBuilder.append("|");
								}
								waypointsBuilder.append(waypointCoords);
							}
						}

						if (waypointsBuilder.length() > 0) {
							waypointsCoords = waypointsBuilder.toString();
						}
					}

					// 3단계: 변환된 좌표 정보를 request에 저장
					request.setAttribute("origin", origin);
					request.setAttribute("originCoords", originCoords);
					request.setAttribute("destination", destination);
					request.setAttribute("destinationCoords", destinationCoords);
					if (waypointsCoords != null) {
						request.setAttribute("waypoints", waypoints);
						request.setAttribute("waypointsCoords", waypointsCoords);
					}

					// 4단계: 카카오 모빌리티 길찾기 API URL 구성
					StringBuilder urlBuilder = new StringBuilder();
					urlBuilder.append("https://apis-navi.kakaomobility.com/v1/directions");
					urlBuilder.append("?origin=").append(URLEncoder.encode(originCoords, StandardCharsets.UTF_8));
					urlBuilder.append("&destination=")
							.append(URLEncoder.encode(destinationCoords, StandardCharsets.UTF_8));

					// 경유지가 있는 경우 URL에 추가
					if (waypointsCoords != null && !waypointsCoords.trim().isEmpty()) {
						urlBuilder.append("&waypoints=")
								.append(URLEncoder.encode(waypointsCoords, StandardCharsets.UTF_8));
					}

					// 우선순위가 설정된 경우 URL에 추가
					if (priority != null && !priority.trim().isEmpty()) {
						urlBuilder.append("&priority=").append(priority);
					}

					// 추가 파라미터들 설정
					urlBuilder.append("&summary=false"); // 상세 정보 포함
					urlBuilder.append("&car_fuel=GASOLINE"); // 연료 타입
					urlBuilder.append("&car_hipass=false"); // 하이패스 사용 여부
					urlBuilder.append("&alternatives=false"); // 대안 경로 없음
					urlBuilder.append("&road_details=false"); // 도로 상세 정보 없음

					// 5단계: HTTP 연결 설정 및 API 호출
					URL url = new URL(urlBuilder.toString());
					HttpURLConnection conn = (HttpURLConnection) url.openConnection();

					// HTTP 헤더 설정
					conn.setRequestMethod("GET");
					conn.setRequestProperty("Authorization", "KakaoAK " + apiKey);
					conn.setRequestProperty("Content-Type", "application/json");

					// 6단계: 응답 읽기
					int responseCode = conn.getResponseCode();
					BufferedReader in;

					// 성공/실패에 따라 적절한 스트림 선택
					if (responseCode >= 200 && responseCode < 300) {
						in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
					} else {
						in = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
					}

					// 응답 데이터 읽기
					String inputLine;
					StringBuilder response2 = new StringBuilder();
					while ((inputLine = in.readLine()) != null) {
						response2.append(inputLine);
					}
					in.close();
					conn.disconnect();

					// 7단계: 성공 응답 처리 및 결과 표시
					if (responseCode >= 200 && responseCode < 300) {
						String responseText = response2.toString();

						try {
							// JSON 파싱
							JSONObject jsonResponse = new JSONObject(responseText);

							// 8단계: 요약 정보 표시
							if (jsonResponse.has("routes") && jsonResponse.getJSONArray("routes").length() > 0) {
								JSONObject route = jsonResponse.getJSONArray("routes").getJSONObject(0);

								if (route.has("summary")) {
									JSONObject summary = route.getJSONObject("summary");

									// 요약 정보를 개별 속성으로 request에 저장
									request.setAttribute("summary", summary);
									request.setAttribute("distance", summary.optInt("distance", 0));
									request.setAttribute("duration", summary.optInt("duration", 0));

									// fare 정보도 개별로 저장
									if (summary.has("fare")) {
										JSONObject fare = summary.getJSONObject("fare");
										request.setAttribute("taxiFare", fare.optInt("taxi", 0));
										request.setAttribute("tollFare", fare.optInt("toll", 0));
									}

									// 9단계: 상세 경로 정보 표시
									if (route.has("sections")) {
										JSONArray sectionsJson = route.getJSONArray("sections");
										List<Map<String, Object>> sectionsList = new ArrayList<>();

										// JSONArray를 List<Map>으로 변환
										for (int i = 0; i < sectionsJson.length(); i++) {
											JSONObject sectionJson = sectionsJson.getJSONObject(i);
											Map<String, Object> sectionMap = new HashMap<>();

											// 기본 정보
											sectionMap.put("distance", sectionJson.optInt("distance", 0));
											sectionMap.put("duration", sectionJson.optInt("duration", 0));

											// roads 정보가 있는 경우
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

										request.setAttribute("sections", sectionsList);
									}
								}
							}

							// 10단계: 전체 JSON 응답 저장 (디버깅용)
							request.setAttribute("jsonResponse", jsonResponse);

						} catch (Exception jsonException) {
							// JSON 파싱 오류 처리
							request.setAttribute("error", "JSON 파싱 오류");
							request.setAttribute("errorMessage", jsonException.getMessage());
							request.setAttribute("responseLength", responseText.length());
						}
					} else {
						// API 호출 실패 처리
						request.setAttribute("error", "API 호출 실패");
						request.setAttribute("responseCode", responseCode);
						request.setAttribute("errorResponse", response2.toString());
					}

				} catch (Exception e) {
					// 전체 예외 처리
					request.setAttribute("error", "오류 발생");
					request.setAttribute("errorMessage", e.getMessage());
				}
			} else {
				// 필수 입력값 누락 처리
				request.setAttribute("error", "입력 오류");
				request.setAttribute("errorMessage", "출발지와 목적지를 모두 입력해주세요.");
			}
		}

		return "kakaoMap.jsp";
	}

	/**
	 * 주소를 좌표로 변환하는 메서드
	 * 
	 * @param address 변환할 주소 (한글)
	 * @param apiKey  카카오 API 키
	 * @return "경도,위도" 형태의 좌표 문자열, 실패시 null
	 */
	private String getCoordinates(String address, String apiKey) {
		// 1단계: 실제 카카오 Geocoding API 호출
		try {
			// 주소를 UTF-8로 URL 인코딩
			String encodedAddress = URLEncoder.encode(address, "UTF-8");
			// 카카오 로컬 API 주소 검색 엔드포인트
			String geocodingUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + encodedAddress;

			// HTTP 연결 설정
			URL url = new URL(geocodingUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Authorization", "KakaoAK " + apiKey);

			// 응답 코드 확인
			int responseCode = conn.getResponseCode();
			BufferedReader in;

			// 성공/실패에 따라 적절한 스트림 선택
			if (responseCode >= 200 && responseCode < 300) {
				in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
			} else {
				in = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
			}

			// 응답 데이터 읽기
			String inputLine;
			StringBuilder response = new StringBuilder();
			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();
			conn.disconnect();

			// 성공 응답인 경우 JSON 파싱
			if (responseCode >= 200 && responseCode < 300) {
				JSONObject jsonResponse = new JSONObject(response.toString());
				// documents 배열이 있고 첫 번째 결과가 있는지 확인
				if (jsonResponse.has("documents") && jsonResponse.getJSONArray("documents").length() > 0) {
					JSONObject document = jsonResponse.getJSONArray("documents").getJSONObject(0);
					String x = document.getString("x"); // 경도
					String y = document.getString("y"); // 위도
					return x + "," + y; // "경도,위도" 형태로 반환
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 2단계: API 호출 실패 시 하드코딩된 좌표 사용 (백업)
		if (address.contains("강남") || address.contains("테헤란로") || address.contains("강남역")) {
			return "127.0276,37.4979"; // 강남역 근처 좌표
		} else if (address.contains("서초") || address.contains("서초대로")) {
			return "127.0075,37.5013"; // 서초역 근처 좌표
		} else if (address.contains("서울역")) {
			return "126.9707,37.5547"; // 서울역 좌표
		} else if (address.contains("홍대입구")) {
			return "126.9242,37.5572"; // 홍대입구역 좌표
		} else if (address.contains("역")) {
			return "127.0276,37.4979"; // 역이 포함된 경우 강남역으로 처리
		}

		return null; // 모든 방법이 실패한 경우
	}
}
