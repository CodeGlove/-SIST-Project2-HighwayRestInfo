<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <link href="css/kakaoStyle.css" rel="stylesheet">
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
            
            <form action="Controller?type=kakaoMap" method="post" id="routeForm">
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
                               value="<c:out value='${param.search != null ? param.search : "서울특별시 서초구 서초대로 396"}' />" required>
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

            <!-- 에러 메시지 표시 -->
            <c:if test="${not empty error}">
                <div class="error-message">
                    <h3><i class="fas fa-exclamation-triangle"></i> <c:out value="${error}" /></h3>
                    <p><c:out value="${errorMessage}" /></p>
                    <c:if test="${not empty responseCode}">
                        <p><strong>응답 코드:</strong> <c:out value="${responseCode}" /></p>
                    </c:if>
                    <c:if test="${not empty errorResponse}">
                        <div class="json-display"><c:out value="${errorResponse}" /></div>
                    </c:if>
                    <c:if test="${not empty responseLength}">
                        <p><strong>응답 길이:</strong> <c:out value="${responseLength}" /></p>
                    </c:if>
                </div>
            </c:if>

            <!-- 좌표 정보 표시 -->
            <c:if test="${not empty originCoords}">
                <div class="coordinate-info">
                    <h3><i class="fas fa-map-marked-alt"></i> 주소 변환 결과</h3>
                    <div class="coordinate-item">
                        <span class="coordinate-label">출발지</span>
                        <span class="coordinate-value"><c:out value="${origin}" /> → <c:out value="${originCoords}" /></span>
                    </div>
                    <div class="coordinate-item">
                        <span class="coordinate-label">목적지</span>
                        <span class="coordinate-value"><c:out value="${destination}" /> → <c:out value="${destinationCoords}" /></span>
                    </div>
                    <c:if test="${not empty waypointsCoords}">
                        <div class="coordinate-item">
                            <span class="coordinate-label">경유지</span>
                            <span class="coordinate-value"><c:out value="${waypoints}" /> → <c:out value="${waypointsCoords}" /></span>
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
                                <c:out value="${distance}" />m 
                                (<fmt:formatNumber value="${distance / 1000.0}" pattern="#.#" />km)
                            </div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">⏱️ 예상 소요시간</div>
                            <div class="summary-value">
                                <fmt:formatNumber value="${duration / 60}" pattern="#" />분 
                                <c:out value="${duration % 60}" />초
                            </div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">🚕 택시 요금</div>
                            <div class="summary-value">
                                <c:out value="${taxiFare}" />원
                            </div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">🛣️ 통행료</div>
                            <div class="summary-value">
                                <c:out value="${tollFare}" />원
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
                                            <span><c:out value="${section.distance}" />m</span>
                                            <span><c:out value="${section.duration}" />초</span>
                                        </div>
                                    </div>
                                    <c:if test="${not empty section.roads}">
                                        <c:forEach var="road" items="${section.roads}" varStatus="roadStatus">
                                            <c:if test="${roadStatus.index < 3}">
                                                <div class="road-item">
                                                    <span class="road-name">
                                                        <c:out value="${road.name}" />
                                                    </span>
                                                    <span class="road-distance">
                                                        <c:out value="${road.distance}" />m
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

            <!-- 전체 JSON 응답 표시 (디버깅용) -->
            <c:if test="${not empty jsonResponse}">
                <details style="margin-top: 1.5rem;">
                    <summary style="cursor: pointer; color: #667eea; font-weight: 600;">
                        <i class="fas fa-code"></i> API 응답 상세보기
                    </summary>
                    <div class="json-display"><c:out value="${jsonResponse}" /></div>
                </details>
            </c:if>
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
