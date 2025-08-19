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

public class KakaoMapAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response)
            throws UnsupportedEncodingException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String waypoints = request.getParameter("waypoints");
        String priority = request.getParameter("priority");
        // 요청 후 어떤 Action으로 포워딩할지 결정하는 파라미터
        // "restArea"인 경우 RestAreaAction으로 자동 포워딩됨
        String forwardTo = request.getParameter("forwardTo");

        try {
            // 카카오 API 키 설정
            String apiKey = "2bb9195b03b5b17418309109544a85c4";

            // 주소를 좌표로 변환
            String originCoords = getCoordinates(origin.trim(), apiKey);
            String destinationCoords = getCoordinates(destination.trim(), apiKey);

            if (originCoords == null || destinationCoords == null) {
                // 에러 정보를 request에 저장
                request.setAttribute("error", "주소 변환 실패");
                request.setAttribute("errorMessage", "입력한 주소를 좌표로 변환할 수 없습니다. 정확한 주소를 입력해주세요.");
                request.setAttribute("origin", origin);
                request.setAttribute("destination", destination);
                // forwardTo와 관계없이 index.jsp로 돌아가기
                return "index.jsp";
            }
            // 경유지 좌표 변환
            String waypointsCoords = processWaypoints(waypoints, apiKey);
            // 카카오 모빌리티 API 호출
            JSONObject routeData = callKakaoMobilityAPI(originCoords, destinationCoords, waypointsCoords, priority,
                    apiKey);
            // 경로 데이터 처리 및 저장
            processRouteData(request, routeData, origin, destination, waypoints, waypointsCoords);

            // forwardTo가 "restArea"이면 RestAreaAction으로 포워딩
            if ("restArea".equalsIgnoreCase(forwardTo)) {
                // 특별한 문자열을 반환하여 Controller가 RestAreaAction을 실행하도록 함
                // Controller에서 이 문자열을 받으면 RestAreaAction을 실행
                // 데이터는 이미 processRouteData에서 request에 저장됨
                return "FORWARD_TO_RESTAREA";
            }

            // 일반적인 경우 (forwardTo가 없거나 다른 값)에는 Controller로 이동
            return "Controller";

        } catch (Exception e) {
            if ("restArea".equalsIgnoreCase(forwardTo)) {
                sendJsonError(response, 500, "서버 오류", "요청 처리 중 오류가 발생했습니다.");
                return null;
            }
            request.setAttribute("error", "서버 오류");
            request.setAttribute("errorMessage", e.getMessage());
            return "Controller";
        }
    }

    // 입력값 검증
    private boolean isValidInput(String origin, String destination) {
        return origin != null && destination != null &&
                !origin.trim().isEmpty() && !destination.trim().isEmpty();
    }

    // JSON 에러 응답 전송
    private void sendJsonError(HttpServletResponse response, int status, String error, String message) {
        response.setStatus(status);
        response.setContentType("application/json; charset=UTF-8");
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
            StringBuilder urlBuilder = new StringBuilder();
            urlBuilder.append("https://apis-navi.kakaomobility.com/v1/directions");
            urlBuilder.append("?origin=").append(URLEncoder.encode(originCoords, StandardCharsets.UTF_8));
            urlBuilder.append("&destination=").append(URLEncoder.encode(destinationCoords, StandardCharsets.UTF_8));

            if (waypointsCoords != null && !waypointsCoords.trim().isEmpty()) {
                urlBuilder.append("&waypoints=").append(URLEncoder.encode(waypointsCoords, StandardCharsets.UTF_8));
            }

            if (priority != null && !priority.trim().isEmpty()) {
                urlBuilder.append("&priority=").append(priority);
            }

            urlBuilder
                    .append("&summary=false&car_fuel=GASOLINE&car_hipass=false&alternatives=false&road_details=false");

            URL url = new URL(urlBuilder.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "KakaoAK " + apiKey);
            conn.setRequestProperty("Content-Type", "application/json");

            int responseCode = conn.getResponseCode();
            BufferedReader in;

            if (responseCode >= 200 && responseCode < 300) {
                in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            } else {
                in = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
            }

            StringBuilder response = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            conn.disconnect();

            if (responseCode >= 200 && responseCode < 300) {
                return new JSONObject(response.toString());
            } else {
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
            if (routeData.has("routes") && routeData.getJSONArray("routes").length() > 0) {
                JSONObject route = routeData.getJSONArray("routes").getJSONObject(0);
                JSONArray sections = route.getJSONArray("sections");

                // 휴게소 정보 추출 및 시간 계산 (통합 방식)
                List<String> allRestAreas = new ArrayList<>();
                List<Integer> allRestAreaDurations = new ArrayList<>();
                extractRestAreasWithDurations(sections, allRestAreas, allRestAreaDurations);

                // request에 데이터 저장 (통합 방식)
                saveRouteDataToRequest(request, route, sections, allRestAreas, allRestAreaDurations,
                        origin, destination, waypoints, waypointsCoords, routeData);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 휴게소 정보 추출 및 시간 계산 (통합 방식)
    private void extractRestAreasWithDurations(JSONArray sections, List<String> allRestAreas,
            List<Integer> allRestAreaDurations) {
        int currentDuration = 0;
        int previousRestAreaDuration = 0; // 이전 휴게시설의 누적 시간

        for (int i = 0; i < sections.length(); i++) {
            JSONObject section = sections.getJSONObject(i);
            if (section.has("guides")) {
                JSONArray guides = section.getJSONArray("guides");
                for (int j = 0; j < guides.length(); j++) {
                    JSONObject guide = guides.getJSONObject(j);

                    // 누적 시간 계산
                    int guideDuration = guide.optInt("duration", 0);
                    currentDuration += guideDuration;

                    if (guide.has("name") && !guide.getString("name").isEmpty()) {
                        String guideName = guide.getString("name");

                        // 휴게소 또는 졸음쉼터인 경우 순서대로 추가하고 이전 휴게시설부터의 시간 저장
                        if (guideName.contains("휴게소") || guideName.contains("서비스") ||
                                guideName.contains("REST") || guideName.contains("SERVICE") ||
                                guideName.contains("졸음쉼터")) {
                            allRestAreas.add(guideName);
                            // 이전 휴게시설부터의 시간 계산 (첫 번째는 출발지부터)
                            int timeFromPrevious = currentDuration - previousRestAreaDuration;
                            allRestAreaDurations.add(timeFromPrevious);
                            previousRestAreaDuration = currentDuration; // 다음 계산을 위해 저장
                        }
                    }
                }
            }
        }
    }

    // request에 경로 데이터 저장 (통합 방식)
    private void saveRouteDataToRequest(HttpServletRequest request, JSONObject route, JSONArray sections,
            List<String> allRestAreas, List<Integer> allRestAreaDurations,
            String origin, String destination, String waypoints, String waypointsCoords, JSONObject routeData) {

        // 기본 정보
        request.setAttribute("origin", origin);
        request.setAttribute("destination", destination);
        request.setAttribute("waypoints", waypoints);
        request.setAttribute("waypointsCoords", waypointsCoords);

        // 휴게소 정보 (통합)
        request.setAttribute("allRestAreas", allRestAreas);
        request.setAttribute("allRestAreasStr", String.join(", ", allRestAreas));

        // 소요시간 정보 (통합)
        request.setAttribute("allRestAreaDurations", allRestAreaDurations);

        // 요약 정보
        if (route.has("summary")) {
            JSONObject summary = route.getJSONObject("summary");
            request.setAttribute("summary", summary);
            request.setAttribute("distance", summary.optInt("distance", 0));
            request.setAttribute("duration", summary.optInt("duration", 0));

            if (summary.has("fare")) {
                JSONObject fare = summary.getJSONObject("fare");
                request.setAttribute("taxiFare", fare.optInt("taxi", 0));
                request.setAttribute("tollFare", fare.optInt("toll", 0));
            }
        }

        // 상세 경로 정보
        if (route.has("sections")) {
            request.setAttribute("sections", convertSectionsToMap(sections));
        }

        // 전체 JSON 응답 (디버깅용)
        request.setAttribute("jsonResponse", routeData);
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
            String geocodingUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + encodedAddress;

            URL url = new URL(geocodingUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "KakaoAK " + apiKey);

            int responseCode = conn.getResponseCode();
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder response = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            conn.disconnect();

            if (responseCode >= 200 && responseCode < 300) {
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

}
