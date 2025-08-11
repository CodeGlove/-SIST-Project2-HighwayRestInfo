<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- JSTL 코어 태그 라이브러리 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- JSTL 포맷 태그 라이브러리 -->
<%
    // 한글 인코딩 설정 - POST 요청과 응답에서 한글이 깨지지 않도록 설정
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"> <!-- 문자 인코딩 설정 -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- 반응형 뷰포트 설정 -->
    <title>🚗 HighwayGuide - 실시간 길찾기</title>

    <!-- 폰트 및 아이콘 -->
    <link rel="preconnect" href="https://fonts.googleapis.com"> <!-- 폰트 사전 연결 -->
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin> <!-- 폰트 사전 연결 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Inter 폰트 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Font Awesome 아이콘 -->
    <link href="css/kakaoStyle.css" rel="stylesheet"> <!-- 커스텀 CSS 파일 -->
</head>
<body>
<!-- 헤더 -->
<header class="header"> <!-- 상단 네비게이션 헤더 -->
    <div class="nav-container"> <!-- 네비게이션 컨테이너 -->
        <a href="index.jsp" class="logo"> <!-- 로고 링크 -->
            <div class="logo-icon"> <!-- 로고 아이콘 -->
                <i class="fas fa-road"></i> <!-- 도로 아이콘 -->
            </div>
            HighwayGuide <!-- 로고 텍스트 -->
        </a>
        <a href="index.jsp" class="back-btn"> <!-- 뒤로가기 버튼 -->
            <i class="fas fa-arrow-left"></i> <!-- 왼쪽 화살표 아이콘 -->
            메인으로 돌아가기 <!-- 버튼 텍스트 -->
        </a>
    </div>
</header>

<!-- 메인 컨테이너 -->
<div class="main-container"> <!-- 메인 레이아웃 컨테이너 -->
    <!-- 입력 폼 섹션 -->
    <div class="form-section"> <!-- 입력 폼 영역 -->
        <h2> <!-- 섹션 제목 -->
            <i class="fas fa-route"></i> <!-- 경로 아이콘 -->
            실시간 길찾기 <!-- 제목 텍스트 -->
        </h2>

        <form action="Controller?type=kakaoMap" method="post" id="routeForm"> <!-- 길찾기 폼 -->
            <div class="form-group"> <!-- 출발지 입력 그룹 -->
                <label for="origin">출발지</label> <!-- 출발지 라벨 -->
                <div class="input-wrapper"> <!-- 입력 필드 래퍼 -->
                    <i class="fas fa-map-marker-alt"></i> <!-- 위치 아이콘 -->
                    <input type="text" id="origin" name="origin" class="form-input" <!-- 출발지 입력 필드 -->
                    placeholder="출발지를 입력하세요 (예: 서울특별시 강남구 테헤란로 152)" <!-- 플레이스홀더 -->
                    value='서울특별시 강남구 테헤란로 152'> <!-- 기본값 및 필수 입력 -->
                </div>
            </div>

            <div class="form-group"> <!-- 목적지 입력 그룹 -->
                <label for="destination">목적지</label> <!-- 목적지 라벨 -->
                <div class="input-wrapper"> <!-- 입력 필드 래퍼 -->
                    <i class="fas fa-flag-checkered"></i> <!-- 깃발 아이콘 -->
                    <input type="text" id="destination" name="destination" class="form-input" <!-- 목적지 입력 필드 -->
                    placeholder="목적지를 입력하세요 (예: 서울특별시 서초구 서초대로 396)" <!-- 플레이스홀더 -->
                    value="<c:out value='${param.search != null ? param.search : "서울특별시 서초구 서초대로 396"}'/>"
                    <!-- URL 파라미터 또는 기본값 -->
                    required> <!-- 필수 입력 -->
                </div>
            </div>

            <div class="form-group"> <!-- 경유지 입력 그룹 -->
                <label for="waypoints">경유지 (선택사항)</label> <!-- 경유지 라벨 -->
                <div class="input-wrapper"> <!-- 입력 필드 래퍼 -->
                    <i class="fas fa-map-pin"></i> <!-- 핀 아이콘 -->
                    <input type="text" id="waypoints" name="waypoints" class="form-input" <!-- 경유지 입력 필드 -->
                    placeholder="경유지를 |로 구분하여 입력하세요"> <!-- 플레이스홀더 -->
                </div>
            </div>

            <div class="form-group"> <!-- 우선순위 선택 그룹 -->
                <label for="priority">경로 우선순위</label> <!-- 우선순위 라벨 -->
                <select id="priority" name="priority" class="priority-select"> <!-- 우선순위 선택 드롭다운 -->
                    <option value="RECOMMEND">추천 경로</option> <!-- 추천 경로 옵션 -->
                    <option value="TIME">최단 시간</option> <!-- 최단 시간 옵션 -->
                    <option value="DISTANCE">최단 경로</option> <!-- 최단 경로 옵션 -->
                </select>
            </div>

            <button type="submit" class="submit-btn" id="submitBtn"> <!-- 제출 버튼 -->
                <span id="btnText"> <!-- 버튼 텍스트 -->
                        <i class="fas fa-search"></i> <!-- 검색 아이콘 -->
                        길찾기 시작 <!-- 버튼 텍스트 -->
                    </span>
                <span id="btnLoading" style="display: none;"> <!-- 로딩 상태 (기본 숨김) -->
                        <div class="loading"></div> <!-- 로딩 스피너 -->
                        경로 탐색 중... <!-- 로딩 텍스트 -->
                    </span>
            </button>
        </form>
    </div>

    <!-- 결과 섹션 -->
    <div class="result-section" id="resultSection"> <!-- 결과 표시 영역 -->
        <h2> <!-- 결과 섹션 제목 -->
            <i class="fas fa-chart-line"></i> <!-- 차트 아이콘 -->
            길찾기 결과 <!-- 제목 텍스트 -->
        </h2>

        <div id="initialMessage" style="text-align: center; color: #666; padding: 2rem;"> <!-- 초기 안내 메시지 -->
            <i class="fas fa-info-circle" style="font-size: 3rem; margin-bottom: 1rem; color: #667eea;"></i>
            <!-- 정보 아이콘 -->
            <p>출발지와 목적지를 입력하고 길찾기를 시작하세요.</p> <!-- 안내 텍스트 1 -->
            <p>실시간 교통정보를 반영한 최적 경로를 제공합니다.</p> <!-- 안내 텍스트 2 -->
        </div>

        <!-- 에러 메시지 표시 -->
        <c:if test="${not empty error}"> <!-- 에러가 있을 때만 표시 -->
            <div class="error-message"> <!-- 에러 메시지 컨테이너 -->
                <h3><i class="fas fa-exclamation-triangle"></i> <c:out value="${error}"/></h3> <!-- 에러 제목 -->
                <p><c:out value="${errorMessage}"/></p> <!-- 에러 상세 메시지 -->
                <c:if test="${not empty responseCode}"> <!-- 응답 코드가 있을 때 -->
                    <p><strong>응답 코드:</strong> <c:out value="${responseCode}"/></p> <!-- 응답 코드 표시 -->
                </c:if>
                <c:if test="${not empty errorResponse}"> <!-- 에러 응답이 있을 때 -->
                    <div class="json-display"><c:out value="${errorResponse}"/></div>
                    <!-- 에러 응답 JSON 표시 -->
                </c:if>
                <c:if test="${not empty responseLength}"> <!-- 응답 길이가 있을 때 -->
                    <p><strong>응답 길이:</strong> <c:out value="${responseLength}"/></p> <!-- 응답 길이 표시 -->
                </c:if>
            </div>
        </c:if>

        <!-- 좌표 정보 표시 -->
        <c:if test="${not empty originCoords}"> <!-- 좌표 정보가 있을 때만 표시 -->
            <div class="coordinate-info"> <!-- 좌표 정보 컨테이너 -->
                <h3><i class="fas fa-map-marked-alt"></i> 주소 변환 결과</h3> <!-- 좌표 정보 제목 -->
                <div class="coordinate-item"> <!-- 출발지 좌표 항목 -->
                    <span class="coordinate-label">출발지</span> <!-- 출발지 라벨 -->
                    <span class="coordinate-value"><c:out value="${origin}"/> → <c:out value="${originCoords}"/></span>
                    <!-- 주소 → 좌표 -->
                </div>
                <div class="coordinate-item"> <!-- 목적지 좌표 항목 -->
                    <span class="coordinate-label">목적지</span> <!-- 목적지 라벨 -->
                    <span class="coordinate-value"><c:out value="${destination}"/> → <c:out
                            value="${destinationCoords}"/></span> <!-- 주소 → 좌표 -->
                </div>
                <c:if test="${not empty waypointsCoords}"> <!-- 경유지 좌표가 있을 때 -->
                    <div class="coordinate-item"> <!-- 경유지 좌표 항목 -->
                        <span class="coordinate-label">경유지</span> <!-- 경유지 라벨 -->
                        <span class="coordinate-value"><c:out value="${waypoints}"/> → <c:out
                                value="${waypointsCoords}"/></span> <!-- 주소 → 좌표 -->
                    </div>
                </c:if>
            </div>
        </c:if>

        <!-- 요약 정보 표시 -->
        <c:if test="${not empty summary}">
            <div class="summary-info">
                <h3><i class="fas fa-chart-bar"></i> 길찾기 결과 요약</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="summary-label">📏 전체 거리</div>
                        <div class="summary-value">
                            <c:out value="${distance}"/>m
                            (<fmt:formatNumber value="${distance / 1000.0}" pattern="#.#"/>km)
                        </div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">⏱️ 예상 소요시간</div>
                        <div class="summary-value">
                            <fmt:formatNumber value="${duration / 60}" pattern="#"/>분
                            <c:out value="${duration % 60}"/>초
                        </div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">🚕 택시 요금</div>
                        <div class="summary-value">
                            <c:out value="${taxiFare}"/>원
                        </div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">🛣️ 통행료</div>
                        <div class="summary-value">
                            <c:out value="${tollFare}"/>원
                        </div>
                    </div>
                </div>

                <!-- 상세 경로 정보 표시 -->
                <c:if test="${not empty sections}">
                    <div class="route-details">
                        <h4><i class="fas fa-route"></i> 상세 경로</h4>
                        <c:forEach var="section" items="${sections}" varStatus="status">
                            <div class="section-item">
                                <div class="section-header">
                                    <span class="section-number">구간 ${status.index + 1}</span>
                                    <div class="section-info">
                                        <span><c:out value="${section.distance}"/>m</span>
                                        <span><c:out value="${section.duration}"/>초</span>
                                    </div>
                                </div>
                                <c:if test="${not empty section.roads}">
                                    <c:forEach var="road" items="${section.roads}" varStatus="roadStatus">
                                        <c:if test="${roadStatus.index < 3}">
                                            <div class="road-item">
                                                    <span class="road-name">
                                                        <c:out value="${road.name}"/>
                                                    </span>
                                                <span class="road-distance">
                                                        <c:out value="${road.distance}"/>m
                                                    </span>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </c:if>


        <!-- 휴게소 정보 표시 -->
        <c:if test="${not empty restAreasStr or not empty restStopsStr}">
            <div class="summary-info">
                <h3><i class="fas fa-map-marked-alt"></i> 경로상 휴게시설</h3>
                <div class="name-display">
                    <c:if test="${not empty restAreasStr}">
                        <div class="name-item">
                            <span class="name-label">휴게소:</span>
                            <span class="name-value"><c:out value="${restAreasStr}"/></span>
                        </div>
                    </c:if>
                    <c:if test="${not empty restStopsStr}">
                        <div class="name-item">
                            <span class="name-label">졸음쉼터:</span>
                            <span class="name-value"><c:out value="${restStopsStr}"/></span>
                        </div>
                    </c:if>
                    <div style="margin-top: 1rem; text-align: center;">
                        <!-- 통합 방식 (휴게소/졸음쉼터 통합) -->
                        <form action="Controller?type=restArea" method="post" style="display: inline;">
                            <input type="hidden" name="allRestAreasStr" value="${allRestAreasStr}">
                            <input type="hidden" name="restAreasStr" value="${restAreasStr}">
                            <input type="hidden" name="restStopsStr" value="${restStopsStr}">
                            <input type="hidden" name="origin" value="${origin}">
                            <input type="hidden" name="destination" value="${destination}">
                            <input type="hidden" name="distance" value="${distance}">
                            <input type="hidden" name="duration" value="${duration}">
                            <input type="hidden" name="taxiFare" value="${taxiFare}">
                            <input type="hidden" name="tollFare" value="${tollFare}">
                            <input type="hidden" name="allRestAreaDurations" value="${allRestAreaDurations}">
                            <input type="hidden" name="restAreaDurations" value="${restAreaDurations}">
                            <input type="hidden" name="restStopDurations" value="${restStopDurations}">
                            <button type="submit" class="detail-link" style="
                                display: inline-flex;
                                align-items: center;
                                gap: 0.5rem;
                                padding: 0.8rem 1.5rem;
                                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                                color: white;
                                text-decoration: none;
                                border-radius: 8px;
                                font-weight: 600;
                                transition: all 0.2s;
                                box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
                                border: none;
                                cursor: pointer;
                            ">
                                <i class="fas fa-route"></i>
                                상세 목록 보기
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- 전체 JSON 응답 표시 (디버깅용) -->
        <c:if test="${not empty jsonResponse}">
            <details style="margin-top: 1.5rem;">
                <summary style="cursor: pointer; color: #667eea; font-weight: 600;">
                    <i class="fas fa-code"></i> API 응답 상세보기
                </summary>
                <div class="json-display"><c:out value="${jsonResponse}"/></div>
            </details>
        </c:if>
    </div>
</div>

<script>
    // DOM이 완전히 로드된 후에 스크립트 실행
    document.addEventListener('DOMContentLoaded', function () { // 페이지 로드 완료 시 실행
        // URL 파라미터에서 검색어 가져오기
        const urlParams = new URLSearchParams(window.location.search); // URL 파라미터 파싱
        const searchTerm = urlParams.get('search'); // 검색어 추출

        if (searchTerm) { // 검색어가 있으면
            // 검색어를 목적지 입력창에 자동으로 설정
            document.getElementById('destination').value = decodeURIComponent(searchTerm); // 목적지 입력창에 설정
            // 폼 자동 제출
            setTimeout(() => { // 0.5초 후 자동 제출
                document.getElementById('routeForm').submit();
            }, 500);
        }

        // 폼 제출 시 로딩 상태 표시
        document.getElementById('routeForm').addEventListener('submit', function () { // 폼 제출 이벤트 리스너
            const submitBtn = document.getElementById('submitBtn'); // 제출 버튼 요소
            const btnText = document.getElementById('btnText'); // 버튼 텍스트 요소
            const btnLoading = document.getElementById('btnLoading'); // 로딩 요소

            // 로딩 상태로 변경
            submitBtn.disabled = true; // 버튼 비활성화
            btnText.style.display = 'none'; // 텍스트 숨기기
            btnLoading.style.display = 'inline-flex'; // 로딩 표시
            btnLoading.style.alignItems = 'center'; // 세로 중앙 정렬
            btnLoading.style.gap = '0.5rem'; // 요소 간격 설정
        });

        // 결과가 있을 때 초기 메시지 숨기기
        const resultSection = document.getElementById('resultSection'); // 결과 섹션 요소
        const initialMessage = document.getElementById('initialMessage'); // 초기 메시지 요소

        if (resultSection.children.length > 2) { // 헤더와 초기 메시지 외에 다른 내용이 있으면
            initialMessage.style.display = 'none'; // 초기 메시지 숨기기
        }
    });
</script>
</body>
</html>
