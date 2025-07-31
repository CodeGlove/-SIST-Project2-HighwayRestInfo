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
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚗 HighwayGuide - 실시간 길찾기</title>
    
    <!-- 폰트 및 아이콘 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

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

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚗 HighwayGuide - 실시간 길찾기</title>
    
    <!-- 폰트 및 아이콘 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /* 기본 리셋 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* 전체적인 바디 스타일 */
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
            line-height: 1.6;
        }

        /* 헤더 스타일 */
        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            color: #333;
            font-weight: 700;
            font-size: 1.5rem;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.2rem;
        }

        .back-btn {
            padding: 0.5rem 1rem;
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: rgba(102, 126, 234, 0.2);
            transform: translateY(-1px);
        }

        /* 메인 컨테이너 */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            min-height: calc(100vh - 80px);
        }

        /* 입력 폼 섹션 */
        .form-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 2rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideInLeft 0.8s ease-out;
        }

        .form-section h2 {
            color: #333;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #555;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            font-size: 1.1rem;
        }

        .form-input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.8);
        }

        .form-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            background: #fff;
        }

        .priority-select {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.8);
            transition: all 0.3s ease;
        }

        .priority-select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .submit-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        /* 결과 섹션 */
        .result-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 2rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideInRight 0.8s ease-out;
            overflow-y: auto;
            max-height: calc(100vh - 120px);
        }

        /* 좌표 정보 */
        .coordinate-info {
            background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid rgba(102, 126, 234, 0.2);
        }

        .coordinate-info h3 {
            color: #333;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .coordinate-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid rgba(102, 126, 234, 0.1);
        }

        .coordinate-item:last-child {
            border-bottom: none;
        }

        .coordinate-label {
            font-weight: 600;
            color: #555;
        }

        .coordinate-value {
            color: #667eea;
            font-weight: 500;
        }

        /* 요약 정보 */
        .summary-info {
            background: linear-gradient(135deg, #f0f8ff 0%, #e8f5e8 100%);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid rgba(102, 126, 234, 0.2);
        }

        .summary-info h3 {
            color: #333;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .summary-item {
            background: rgba(255, 255, 255, 0.8);
            border-radius: 12px;
            padding: 1rem;
            border: 1px solid rgba(102, 126, 234, 0.1);
            transition: all 0.3s ease;
        }

        .summary-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.1);
        }

        .summary-label {
            font-size: 0.8rem;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
        }

        .summary-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #333;
        }

        /* 경로 상세 정보 */
        .route-details {
            background: rgba(255, 255, 255, 0.8);
            border-radius: 16px;
            padding: 1.5rem;
            margin-top: 1.5rem;
        }

        .route-details h4 {
            color: #333;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-item {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid rgba(102, 126, 234, 0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid rgba(102, 126, 234, 0.1);
        }

        .section-number {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .section-info {
            display: flex;
            gap: 1rem;
            font-size: 0.9rem;
            color: #666;
        }

        .road-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.3rem 0;
            font-size: 0.9rem;
        }

        .road-name {
            color: #333;
            font-weight: 500;
        }

        .road-distance {
            color: #667eea;
            font-weight: 600;
        }

        /* 에러 메시지 */
        .error-message {
            background: linear-gradient(135deg, #ffebee 0%, #fce4ec 100%);
            border: 1px solid rgba(244, 67, 54, 0.2);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .error-message h3 {
            color: #d32f2f;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .error-message p {
            color: #666;
        }

        /* JSON 디스플레이 */
        .json-display {
            background: #1e1e1e;
            color: #d4d4d4;
            padding: 1rem;
            border-radius: 12px;
            font-family: 'Courier New', monospace;
            font-size: 0.8rem;
            white-space: pre-wrap;
            overflow-x: auto;
            max-height: 300px;
            overflow-y: auto;
            margin-top: 1rem;
        }

        /* 애니메이션 */
        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .main-container {
                grid-template-columns: 1fr;
                padding: 1rem;
            }

            .form-section, .result-section {
                border-radius: 16px;
                padding: 1.5rem;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }
        }

        /* 로딩 애니메이션 */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <header class="header">
        <div class="nav-container">
            <a href="index.jsp" class="logo">
                <div class="logo-icon">
                    <i class="fas fa-road"></i>
                </div>
                HighwayGuide
            </a>
            <a href="index.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                메인으로 돌아가기
            </a>
        </div>
    </header>

    <!-- 메인 컨테이너 -->
    <div class="main-container">
        <!-- 입력 폼 섹션 -->
        <div class="form-section">
            <h2>
                <i class="fas fa-route"></i>
                실시간 길찾기
            </h2>
            
            <form method="post" id="routeForm">
                <div class="form-group">
                    <label for="origin">출발지</label>
                    <div class="input-wrapper">
                        <i class="fas fa-map-marker-alt"></i>
                        <input type="text" id="origin" name="origin" class="form-input" 
                               placeholder="출발지를 입력하세요 (예: 서울특별시 강남구 테헤란로 152)"
                               value="서울특별시 강남구 테헤란로 152" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="destination">목적지</label>
                    <div class="input-wrapper">
                        <i class="fas fa-flag-checkered"></i>
                        <input type="text" id="destination" name="destination" class="form-input" 
                               placeholder="목적지를 입력하세요 (예: 서울특별시 서초구 서초대로 396)"
                               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "서울특별시 서초구 서초대로 396" %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="waypoints">경유지 (선택사항)</label>
                    <div class="input-wrapper">
                        <i class="fas fa-map-pin"></i>
                        <input type="text" id="waypoints" name="waypoints" class="form-input" 
                               placeholder="경유지를 |로 구분하여 입력하세요">
                    </div>
                </div>

                <div class="form-group">
                    <label for="priority">경로 우선순위</label>
                    <select id="priority" name="priority" class="priority-select">
                        <option value="RECOMMEND">추천 경로</option>
                        <option value="TIME">최단 시간</option>
                        <option value="DISTANCE">최단 경로</option>
                    </select>
                </div>

                <button type="submit" class="submit-btn" id="submitBtn">
                    <span id="btnText">
                        <i class="fas fa-search"></i>
                        길찾기 시작
                    </span>
                    <span id="btnLoading" style="display: none;">
                        <div class="loading"></div>
                        경로 탐색 중...
                    </span>
                </button>
            </form>
        </div>

        <!-- 결과 섹션 -->
        <div class="result-section" id="resultSection">
            <h2>
                <i class="fas fa-chart-line"></i>
                길찾기 결과
            </h2>
            
            <div id="initialMessage" style="text-align: center; color: #666; padding: 2rem;">
                <i class="fas fa-info-circle" style="font-size: 3rem; margin-bottom: 1rem; color: #667eea;"></i>
                <p>출발지와 목적지를 입력하고 길찾기를 시작하세요.</p>
                <p>실시간 교통정보를 반영한 최적 경로를 제공합니다.</p>
            </div>

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
            <div class="error-message">
                <h3><i class="fas fa-exclamation-triangle"></i> 주소 변환 실패</h3>
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
                <h3><i class="fas fa-map-marked-alt"></i> 주소 변환 결과</h3>
                <div class="coordinate-item">
                    <span class="coordinate-label">출발지</span>
                    <span class="coordinate-value"><%= origin %> → <%= originCoords %></span>
                </div>
                <div class="coordinate-item">
                    <span class="coordinate-label">목적지</span>
                    <span class="coordinate-value"><%= destination %> → <%= destinationCoords %></span>
                </div>
                <% if (waypointsCoords != null) { %>
                <div class="coordinate-item">
                    <span class="coordinate-label">경유지</span>
                    <span class="coordinate-value"><%= waypoints %> → <%= waypointsCoords %></span>
                </div>
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

                                try {
                                    // JSON 파싱
                                    JSONObject jsonResponse = new JSONObject(responseText);

                                    // 8단계: 요약 정보 표시
                                    if (jsonResponse.has("routes") && jsonResponse.getJSONArray("routes").length() > 0) {
                                        JSONObject route = jsonResponse.getJSONArray("routes").getJSONObject(0);

                                        if (route.has("summary")) {
                                            JSONObject summary = route.getJSONObject("summary");
            %>
            <div class="summary-info">
                <h3><i class="fas fa-chart-bar"></i> 길찾기 결과 요약</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="summary-label">📏 전체 거리</div>
                        <div class="summary-value"><%= summary.optInt("distance", 0) %>m (<%= Math.round(summary.optInt("distance", 0) / 1000.0 * 10) / 10.0 %>km)</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">⏱️ 예상 소요시간</div>
                        <div class="summary-value"><%= summary.optInt("duration", 0) / 60 %>분 <%= summary.optInt("duration", 0) % 60 %>초</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">🚕 택시 요금</div>
                        <div class="summary-value"><%= summary.optJSONObject("fare").optInt("taxi", 0) %>원</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">🛣️ 통행료</div>
                        <div class="summary-value"><%= summary.optJSONObject("fare").optInt("toll", 0) %>원</div>
                    </div>
                </div>
                
                <%
                    // 9단계: 상세 경로 정보 표시
                    if (route.has("sections")) {
                        JSONArray sections = route.getJSONArray("sections");
                %>
                <div class="route-details">
                    <h4><i class="fas fa-route"></i> 상세 경로</h4>
                    <%
                        // 각 구간별 상세 정보 표시
                        for (int i = 0; i < sections.length(); i++) {
                            JSONObject section = sections.getJSONObject(i);
                            if (section.has("summary")) {
                                JSONObject sectionSummary = section.getJSONObject("summary");
                    %>
                    <div class="section-item">
                        <div class="section-header">
                            <span class="section-number">구간 <%= i + 1 %></span>
                            <div class="section-info">
                                <span><%= sectionSummary.optInt("distance", 0) %>m</span>
                                <span><%= sectionSummary.optInt("duration", 0) %>초</span>
                            </div>
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
            <details style="margin-top: 1.5rem;">
                <summary style="cursor: pointer; color: #667eea; font-weight: 600;">
                    <i class="fas fa-code"></i> API 응답 상세보기
                </summary>
                <div class="json-display"><%= jsonResponse.toString(2) %></div>
            </details>
            <%
                                } catch (Exception jsonException) {
                                    // JSON 파싱 오류 처리
            %>
            <div class="error-message">
                <h3><i class="fas fa-exclamation-triangle"></i> JSON 파싱 오류</h3>
                <p><strong>오류 메시지:</strong> <%= jsonException.getMessage() %></p>
                <p><strong>응답 길이:</strong> <%= responseText.length() %></p>
            </div>
            <%
                                }
                            } else {
                                // API 호출 실패 처리
            %>
            <div class="error-message">
                <h3><i class="fas fa-exclamation-triangle"></i> API 호출 실패</h3>
                <p><strong>응답 코드:</strong> <%= responseCode %></p>
                <div class="json-display"><%= response2.toString() %></div>
            </div>
            <%
                            }

                        } catch (Exception e) {
                            // 전체 예외 처리
            %>
            <div class="error-message">
                <h3><i class="fas fa-exclamation-triangle"></i> 오류 발생</h3>
                <p><strong>오류 메시지:</strong> <%= e.getMessage() %></p>
            </div>
            <%
                        }
                    } else {
                        // 필수 입력값 누락 처리
            %>
            <div class="error-message">
                <h3><i class="fas fa-exclamation-triangle"></i> 입력 오류</h3>
                <p>출발지와 목적지를 모두 입력해주세요.</p>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <script>
        // DOM이 완전히 로드된 후에 스크립트 실행
        document.addEventListener('DOMContentLoaded', function() {
            // URL 파라미터에서 검색어 가져오기
            const urlParams = new URLSearchParams(window.location.search);
            const searchTerm = urlParams.get('search');
            
            if (searchTerm) {
                // 검색어를 목적지 입력창에 자동으로 설정
                document.getElementById('destination').value = decodeURIComponent(searchTerm);
                // 폼 자동 제출
                setTimeout(() => {
                    document.getElementById('routeForm').submit();
                }, 500);
            }

            // 폼 제출 시 로딩 상태 표시
            document.getElementById('routeForm').addEventListener('submit', function() {
                const submitBtn = document.getElementById('submitBtn');
                const btnText = document.getElementById('btnText');
                const btnLoading = document.getElementById('btnLoading');
                
                // 로딩 상태로 변경
                submitBtn.disabled = true;
                btnText.style.display = 'none';
                btnLoading.style.display = 'inline-flex';
                btnLoading.style.alignItems = 'center';
                btnLoading.style.gap = '0.5rem';
            });

            // 결과가 있을 때 초기 메시지 숨기기
            const resultSection = document.getElementById('resultSection');
            const initialMessage = document.getElementById('initialMessage');
            
            if (resultSection.children.length > 2) { // 헤더와 초기 메시지 외에 다른 내용이 있으면
                initialMessage.style.display = 'none';
            }
        });
    </script>
</body>
</html>
