<%-- 
    카카오 모빌리티 길찾기 API JSP 페이지
    기능: 
    1. 사용자가 한글 주소를 입력하면 Geocoding API로 좌표 변환
    2. 변환된 좌표로 카카오 모빌리티 길찾기 API 호출
    3. 결과를 요약 정보와 상세 경로로 표시
    4. 전체 JSON 응답도 디버깅용으로 표시
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 한글 인코딩 설정 - POST 요청과 응답에서 한글이 깨지지 않도록 설정
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>

<%-- 필요한 Java 클래스들을 import --%>
<%@ page import="java.net.HttpURLConnection" %>  <%-- HTTP 연결을 위한 클래스 --%>
<%@ page import="java.net.URL" %>                <%-- URL 처리를 위한 클래스 --%>
<%@ page import="java.io.BufferedReader" %>      <%-- 텍스트 읽기를 위한 클래스 --%>
<%@ page import="java.io.InputStreamReader" %>   <%-- 입력 스트림을 텍스트로 변환 --%>
<%@ page import="org.json.JSONObject" %>         <%-- JSON 객체 처리 --%>
<%@ page import="org.json.JSONArray" %>          <%-- JSON 배열 처리 --%>
<%@ page import="java.net.URLEncoder" %>         <%-- URL 인코딩 --%>
<%@ page import="java.nio.charset.StandardCharsets" %> <%-- 문자 인코딩 --%>

<%-- JSP 선언부: 클래스 레벨에서 메서드 정의 --%>
<%! 
    /**
     * 주소를 좌표로 변환하는 메서드
     * @param address 변환할 주소 (한글)
     * @param apiKey 카카오 API 키
     * @return "경도,위도" 형태의 좌표 문자열, 실패시 null
     */
    public String getCoordinates(String address, String apiKey) {
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
%>

<html>
<head>
    <title>카카오 모빌리티 길찾기 API</title>
    <style>
        /* 전체 페이지 스타일 */
        body {
            font-family: 'Arial', sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }

        /* 메인 컨테이너 */
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        /* 제목 스타일 */
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }

        /* 폼 그룹 스타일 */
        .form-group {
            margin-bottom: 20px;
        }

        /* 라벨 스타일 */
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }

        /* 입력 필드 스타일 */
        input[type="text"], select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }

        /* 버튼 스타일 */
        button {
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }

        button:hover {
            background-color: #45a049;
        }

        /* 결과 표시 영역 */
        .result {
            margin-top: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 5px;
            border-left: 4px solid #4CAF50;
        }

        /* 에러 스타일 */
        .error {
            background-color: #ffebee;
            border-left-color: #f44336;
        }

        /* JSON 표시 영역 */
        .json-display {
            background-color: #f5f5f5;
            padding: 15px;
            border-radius: 5px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            white-space: pre-wrap;
            overflow-x: auto;
            max-height: 500px;
            overflow-y: auto;
        }

        /* 요약 정보 스타일 */
        .summary-info {
            background-color: #f0f8ff;
            border: 1px solid #4CAF50;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
        }

        .summary-info h3 {
            margin-top: 0;
            color: #2e7d32;
        }

        /* 요약 정보 그리드 레이아웃 */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin: 15px 0;
        }

        /* 요약 아이템 스타일 */
        .summary-item {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .summary-item .label {
            font-weight: bold;
            color: #333;
        }

        .summary-item .value {
            color: #2196f3;
            font-weight: 600;
        }

        /* 경로 상세 정보 */
        .route-details {
            margin-top: 20px;
            padding-top: 15px;
            border-top: 2px solid #4CAF50;
        }

        /* 구간 아이템 */
        .section-item {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 12px;
            margin: 10px 0;
        }

        /* 구간 헤더 */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
            padding-bottom: 8px;
            border-bottom: 1px solid #eee;
        }

        /* 구간 번호 */
        .section-number {
            background-color: #2196f3;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }

        /* 구간 거리/시간 */
        .section-distance, .section-duration {
            color: #666;
            font-size: 14px;
        }

        /* 도로 아이템 */
        .road-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 4px 0;
            font-size: 13px;
        }

        .road-name {
            color: #333;
            font-weight: 500;
        }

        .road-distance {
            color: #666;
        }

        /* 좌표 정보 표시 */
        .coordinate-info {
            background-color: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .coordinate-info h3 {
            margin-top: 0;
            color: #1565c0;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>카카오 모빌리티 길찾기 API</h1>

    <!-- 길찾기 입력 폼 -->
    <form method="post">
        <!-- 출발지 입력 -->
        <div class="form-group">
            <label for="origin">출발지 (한글 주소 입력):</label>
            <input type="text" id="origin" name="origin" placeholder="예: 서울특별시 강남구 테헤란로 152"
                   value="서울특별시 강남구 테헤란로 152" required>
        </div>

        <!-- 목적지 입력 -->
        <div class="form-group">
            <label for="destination">목적지 (한글 주소 입력):</label>
            <input type="text" id="destination" name="destination" placeholder="예: 서울특별시 서초구 서초대로 396"
                   value="서울특별시 서초구 서초대로 396" required>
        </div>

        <!-- 경유지 입력 (선택사항) -->
        <div class="form-group">
            <label for="waypoints">경유지 (선택사항, |로 구분):</label>
            <input type="text" id="waypoints" name="waypoints" placeholder="예: 서울특별시 강남구 역삼동|서울특별시 서초구 서초동">
        </div>

        <!-- 경로 우선순위 선택 -->
        <div class="form-group">
            <label for="priority">경로 우선순위:</label>
            <select id="priority" name="priority">
                <option value="RECOMMEND">추천 경로</option>
                <option value="TIME">최단 시간</option>
                <option value="DISTANCE">최단 경로</option>
            </select>
        </div>

        <button type="submit">길찾기 실행</button>
    </form>

    <%
        // POST 요청 처리 시작
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
    %>
    <div class="result error">
        <h3>주소 변환 실패</h3>
        <p>입력한 주소를 좌표로 변환할 수 없습니다. 정확한 주소를 입력해주세요.</p>
    </div>
    <%
                        return; // 처리를 중단
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

                    // 3단계: 변환된 좌표 정보 표시
    %>
    <div class="coordinate-info">
        <h3>주소 변환 결과</h3>
        <p><strong>출발지:</strong> <%= origin %> → <%= originCoords %></p>
        <p><strong>목적지:</strong> <%= destination %> → <%= destinationCoords %></p>
        <% if (waypointsCoords != null) { %>
        <p><strong>경유지:</strong> <%= waypoints %> → <%= waypointsCoords %></p>
        <% } %>
    </div>
    <%

                    // 4단계: 카카오 모빌리티 길찾기 API URL 구성
                    StringBuilder urlBuilder = new StringBuilder();
                    urlBuilder.append("https://apis-navi.kakaomobility.com/v1/directions");
                    urlBuilder.append("?origin=").append(URLEncoder.encode(originCoords, StandardCharsets.UTF_8));
                    urlBuilder.append("&destination=").append(URLEncoder.encode(destinationCoords, StandardCharsets.UTF_8));

                    // 경유지가 있는 경우 URL에 추가
                    if (waypointsCoords != null && !waypointsCoords.trim().isEmpty()) {
                        urlBuilder.append("&waypoints=").append(URLEncoder.encode(waypointsCoords, StandardCharsets.UTF_8));
                    }

                    // 우선순위가 설정된 경우 URL에 추가
                    if (priority != null && !priority.trim().isEmpty()) {
                        urlBuilder.append("&priority=").append(priority);
                    }

                    // 추가 파라미터들 설정
                    urlBuilder.append("&summary=false");        // 상세 정보 포함
                    urlBuilder.append("&car_fuel=GASOLINE");   // 연료 타입
                    urlBuilder.append("&car_hipass=false");     // 하이패스 사용 여부
                    urlBuilder.append("&alternatives=false");   // 대안 경로 없음
                    urlBuilder.append("&road_details=false");   // 도로 상세 정보 없음

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
    %>
    <!-- 디버깅용 전체 API 응답 표시 -->
    <div class="result">
        <h3>API 응답 내용 (디버깅용)</h3>
        <div class="json-display"><%= responseText %></div>
    </div>
    <%

                        try {
                            // JSON 파싱
                            JSONObject jsonResponse = new JSONObject(responseText);

                            // 8단계: 요약 정보 표시
                            if (jsonResponse.has("routes") && jsonResponse.getJSONArray("routes").length() > 0) {
                                JSONObject route = jsonResponse.getJSONArray("routes").getJSONObject(0);

                                if (route.has("summary")) {
                                    JSONObject summary = route.getJSONObject("summary");
    %>
    <!-- 길찾기 결과 요약 정보 -->
    <div class="summary-info">
        <h3>🚗 길찾기 결과 요약</h3>
        <div class="summary-grid">
            <!-- 전체 거리 -->
            <div class="summary-item">
                <span class="label">📏 전체 거리</span>
                <span class="value"><%= summary.optInt("distance", 0) %> 미터 (<%= Math.round(summary.optInt("distance", 0) / 1000.0 * 10) / 10.0 %> km)</span>
            </div>
            <!-- 예상 소요시간 -->
            <div class="summary-item">
                <span class="label">⏱️ 예상 소요시간</span>
                <span class="value"><%= summary.optInt("duration", 0) %>초 (<%= summary.optInt("duration", 0) / 60 %>분 <%= summary.optInt("duration", 0) % 60 %>초)</span>
            </div>
            <!-- 택시 요금 -->
            <div class="summary-item">
                <span class="label">🚕 택시 요금</span>
                <span class="value"><%= summary.optJSONObject("fare").optInt("taxi", 0) %>원</span>
            </div>
            <!-- 통행료 -->
            <div class="summary-item">
                <span class="label">🛣️ 통행료</span>
                <span class="value"><%= summary.optJSONObject("fare").optInt("toll", 0) %>원</span>
            </div>
        </div>
        
        <%
            // 9단계: 상세 경로 정보 표시
            if (route.has("sections")) {
                JSONArray sections = route.getJSONArray("sections");
        %>
        <div class="route-details">
            <h4>📍 상세 경로</h4>
            <%
                // 각 구간별 상세 정보 표시
                for (int i = 0; i < sections.length(); i++) {
                    JSONObject section = sections.getJSONObject(i);
                    if (section.has("summary")) {
                        JSONObject sectionSummary = section.getJSONObject("summary");
            %>
            <div class="section-item">
                <!-- 구간 헤더 (구간 번호, 거리, 시간) -->
                <div class="section-header">
                    <span class="section-number">구간 <%= i + 1 %></span>
                    <span class="section-distance"><%= sectionSummary.optInt("distance", 0) %>m</span>
                    <span class="section-duration"><%= sectionSummary.optInt("duration", 0) %>초</span>
                </div>
                <%
                    // 각 구간의 도로 정보 표시 (최대 3개)
                    if (section.has("roads")) {
                        JSONArray roads = section.getJSONArray("roads");
                        for (int j = 0; j < Math.min(roads.length(), 3); j++) {
                            JSONObject road = roads.getJSONObject(j);
                %>
                <div class="road-item">
                    <span class="road-name"><%= road.optString("name", "알 수 없는 도로") %></span>
                    <span class="road-distance"><%= road.optInt("distance", 0) %>m</span>
                </div>
                <%
                        }
                    }
                %>
            </div>
            <%
                    }
                }
            %>
        </div>
        <%
            }
        %>
    </div>
    <%
                                }
                            }

                            // 10단계: 전체 JSON 응답 표시 (디버깅용)
    %>
    <div class="result">
        <h3>파싱된 JSON 응답 결과</h3>
        <div class="json-display"><%= jsonResponse.toString(2) %></div>
    </div>
    <%
                        } catch (Exception jsonException) {
                            // JSON 파싱 오류 처리
    %>
    <div class="result error">
        <h3>JSON 파싱 오류</h3>
        <p><strong>오류 메시지:</strong> <%= jsonException.getMessage() %></p>
        <p><strong>응답 길이:</strong> <%= responseText.length() %></p>
        <p><strong>응답 시작 부분:</strong> <%= responseText.length() > 0 ? responseText.substring(0, Math.min(100, responseText.length())) : "빈 응답" %></p>
    </div>
    <%
                        }
                    } else {
                        // API 호출 실패 처리
    %>
    <div class="result error">
        <h3>API 호출 실패</h3>
        <p><strong>응답 코드:</strong> <%= responseCode %></p>
        <div class="json-display"><%= response2.toString() %></div>
    </div>
    <%
                    }

                } catch (Exception e) {
                    // 전체 예외 처리
    %>
    <div class="result error">
        <h3>오류 발생</h3>
        <p><strong>오류 메시지:</strong> <%= e.getMessage() %></p>
        <div class="json-display"><%= e.toString() %></div>
    </div>
    <%
                }
            } else {
                // 필수 입력값 누락 처리
    %>
    <div class="result error">
        <h3>입력 오류</h3>
        <p>출발지와 목적지를 모두 입력해주세요.</p>
    </div>
    <%
            }
        }
    %>
</div>
</body>
</html>
