<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // 한글 인코딩 설정
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚗 HighwayGuide - 휴게소 정보</title>

    <!-- 폰트 및 아이콘 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- CSS 파일 링크 -->
    <link rel="stylesheet" href="css/restareaStyle.css">
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
            <a href="kakaoMap.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                길찾기로 돌아가기
            </a>
        </div>
    </header>

    <!-- 메인 컨테이너 -->
    <div class="main-container">
        <!-- 페이지 제목 -->
        <div class="page-title fade-in">
            <h1><i class="fas fa-map-marked-alt"></i> 경로상 휴게시설 정보</h1>
            <p>발견된 휴게소와 졸음쉼터 정보를 확인하세요</p>
        </div>

        <!-- 탭 컨테이너 -->
        <div class="tab-container slide-up">
            <!-- 탭 버튼들 -->
            <div class="tab-buttons">
                <button class="tab-btn active" data-tab="rest-areas">
                    <i class="fas fa-utensils"></i>
                    휴게소
                    <span class="tab-count">
                        <c:choose>
                            <c:when test="${not empty restAreas}">${restAreas.size()}개</c:when>
                            <c:otherwise>0개</c:otherwise>
                        </c:choose>
                    </span>
                </button>
                <button class="tab-btn" data-tab="rest-stops">
                    <i class="fas fa-bed"></i>
                    졸음쉼터
                    <span class="tab-count">
                        <c:choose>
                            <c:when test="${not empty restStops}">${restStops.size()}개</c:when>
                            <c:otherwise>0개</c:otherwise>
                        </c:choose>
                    </span>
                </button>
            </div>

            <!-- 탭 콘텐츠 -->
            <div class="tab-content">
                <!-- 휴게소 탭 -->
                <div id="rest-areas" class="tab-pane active">
                    <div class="info-card">
                        <div class="card-header">
                            <div class="card-icon">
                                <i class="fas fa-utensils"></i>
                            </div>
                            <div class="card-title">휴게소 목록</div>
                        </div>
                        
                        <c:choose>
                            <c:when test="${not empty restAreas}">
                                <div class="rest-areas-list">
                                    <c:forEach var="restArea" items="${restAreas}" varStatus="status">
                                        <div class="rest-area-card clickable" onclick="showRestAreaInfo('${restArea}', ${status.index})">
                                            <div class="card-header">
                                                <div class="card-icon">
                                                    <i class="fas fa-utensils"></i>
                                                </div>
                                                <div class="card-info">
                                                    <div class="card-title">
                                                        <i class="fas fa-map-marker-alt"></i>
                                                        <c:out value="${restArea}"/>
                                                    </div>
                                                    <div class="rating-section">
                                                        <span class="rating-label">별점</span>
                                                        <div class="stars">
                                                            <i class="fas fa-star star"></i>
                                                            <i class="fas fa-star star"></i>
                                                            <i class="fas fa-star star"></i>
                                                            <i class="fas fa-star star"></i>
                                                            <i class="fas fa-star star empty"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card-content">
                                                <!-- 편의시설 섹션 -->
                                                <div class="content-section">
                                                    <div class="section-title">
                                                        <i class="fas fa-list"></i>
                                                        편의시설
                                                    </div>
                                                    <div class="facilities-grid">
                                                        <div class="facility-item">
                                                            <i class="fas fa-baby facility-icon"></i>
                                                            <span>수유실</span>
                                                        </div>
                                                        <div class="facility-item">
                                                            <i class="fas fa-first-aid facility-icon"></i>
                                                            <span>약국</span>
                                                        </div>
                                                        <div class="facility-item">
                                                            <i class="fas fa-bus facility-icon"></i>
                                                            <span>버스환승</span>
                                                        </div>
                                                        <div class="facility-item">
                                                            <i class="fas fa-credit-card facility-icon"></i>
                                                            <span>ATM</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- 주유비 섹션 -->
                                                <div class="content-section">
                                                    <div class="section-title">
                                                        <i class="fas fa-gas-pump"></i>
                                                        주유비
                                                    </div>
                                                    <div class="fuel-info">
                                                        <div class="fuel-price">휘발유: 1,618원</div>
                                                        <div class="fuel-price">경유: 1,474원</div>
                                                        <div class="fuel-price">LPG: 1,074원</div>
                                                        <div class="fuel-date">2025.08.05</div>
                                                    </div>
                                                </div>
                                                
                                                <!-- 대표메뉴 섹션 -->
                                                <div class="content-section">
                                                    <div class="section-title">
                                                        <i class="fas fa-utensils"></i>
                                                        대표메뉴
                                                    </div>
                                                    <div class="menu-item">
                                                        참치김치찌개
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-message">
                                    <div class="empty-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <p>경로상 휴게소가 발견되지 않았습니다.</p>
                                    <p style="font-size: 0.9rem; color: #999; margin-top: 0.5rem;">
                                        다른 경로를 시도해보세요.
                                    </p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 졸음쉼터 탭 -->
                <div id="rest-stops" class="tab-pane">
                    <div class="info-card">
                        <div class="card-header">
                            <div class="card-icon">
                                <i class="fas fa-bed"></i>
                            </div>
                            <div class="card-title">졸음쉼터 목록</div>
                        </div>
                        
                        <c:choose>
                            <c:when test="${not empty restStops}">
                                <div class="rest-areas-list">
                                    <c:forEach var="restStop" items="${restStops}" varStatus="status">
                                        <div class="rest-area-card clickable" onclick="showRestStopInfo('${restStop}', ${status.index})">
                                            <div class="card-header">
                                                <div class="card-icon">
                                                    <i class="fas fa-bed"></i>
                                                </div>
                                                <div class="card-info">
                                                    <div class="card-title">
                                                        <i class="fas fa-map-marker-alt"></i>
                                                        <c:out value="${restStop}"/>
                                                    </div>
                                                    <div class="rating-section">
                                                        <span class="rating-label">별점</span>
                                                        <div class="stars">
                                                            <i class="fas fa-star star"></i>
                                                            <i class="fas fa-star star"></i>
                                                            <i class="fas fa-star star"></i>
                                                            <i class="fas fa-star star empty"></i>
                                                            <i class="fas fa-star star empty"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card-content">
                                                <!-- 편의시설 섹션 -->
                                                <div class="content-section">
                                                    <div class="section-title">
                                                        <i class="fas fa-list"></i>
                                                        편의시설
                                                    </div>
                                                    <div class="facilities-grid">
                                                        <div class="facility-item">
                                                            <i class="fas fa-parking facility-icon"></i>
                                                            <span>주차장</span>
                                                        </div>
                                                        <div class="facility-item">
                                                            <i class="fas fa-restroom facility-icon"></i>
                                                            <span>화장실</span>
                                                        </div>
                                                        <div class="facility-item">
                                                            <i class="fas fa-couch facility-icon"></i>
                                                            <span>휴식공간</span>
                                                        </div>
                                                        <div class="facility-item">
                                                            <i class="fas fa-shield-alt facility-icon"></i>
                                                            <span>안전시설</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- 운영시간 섹션 -->
                                                <div class="content-section">
                                                    <div class="section-title">
                                                        <i class="fas fa-clock"></i>
                                                        운영시간
                                                    </div>
                                                    <div class="fuel-info">
                                                        <div class="fuel-price">24시간 운영</div>
                                                        <div class="fuel-date">무료 이용</div>
                                                    </div>
                                                </div>
                                                
                                                <!-- 안전수칙 섹션 -->
                                                <div class="content-section">
                                                    <div class="section-title">
                                                        <i class="fas fa-exclamation-triangle"></i>
                                                        안전수칙
                                                    </div>
                                                    <div class="menu-item">
                                                        15-20분 휴식 권장
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-message">
                                    <div class="empty-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <p>경로상 졸음쉼터가 발견되지 않았습니다.</p>
                                    <p style="font-size: 0.9rem; color: #999; margin-top: 0.5rem;">
                                        다른 경로를 시도해보세요.
                                    </p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- 추가 정보 섹션 -->
        <c:if test="${not empty restAreas or not empty restStops}">
            <div class="info-card slide-up" style="margin-top: 2rem;">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-info-circle"></i>
                    </div>
                    <div class="card-title">정보 안내</div>
                </div>
                <div style="color: #666; line-height: 1.6;">
                    <p><strong>휴게소:</strong> 주유소, 충전소, 음식점, 화장실 등 편의시설이 구비된 휴게공간</p>
                    <p><strong>졸음쉼터:</strong> 운전 중 졸음 방지를 위한 임시 휴식 공간</p>
                    <p style="margin-top: 1rem; font-size: 0.9rem; color: #999;">
                        <i class="fas fa-lightbulb"></i> 안전한 운전을 위해 정기적인 휴식을 취하세요.
                    </p>
                </div>
            </div>
        </c:if>
    </div>

    <!-- 휴게소 상세정보 모달 -->
    <div id="restAreaModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">
                    <i class="fas fa-utensils"></i>
                    <span id="modalTitle">휴게소 정보</span>
                </div>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="info-section">
                    <div class="info-label">
                        <i class="fas fa-map-marker-alt"></i>
                        위치
                    </div>
                    <div class="info-value" id="modalLocation">
                        정보를 불러오는 중...
                    </div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">
                        <i class="fas fa-phone"></i>
                        연락처
                    </div>
                    <div class="info-value" id="modalPhone">
                        정보를 불러오는 중...
                    </div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">
                        <i class="fas fa-clock"></i>
                        운영시간
                    </div>
                    <div class="info-value" id="modalHours">
                        24시간 운영
                    </div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">
                        <i class="fas fa-list"></i>
                        편의시설
                    </div>
                    <div class="facilities-list" id="modalFacilities">
                        <span class="facility-tag">주유소</span>
                        <span class="facility-tag">충전소</span>
                        <span class="facility-tag">음식점</span>
                        <span class="facility-tag">화장실</span>
                        <span class="facility-tag">편의점</span>
                        <span class="facility-tag">휴식공간</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">
                        <i class="fas fa-info-circle"></i>
                        안내사항
                    </div>
                    <div class="info-value">
                        • 안전한 운전을 위해 충분한 휴식을 취하세요<br>
                        • 긴급상황 시 1588-2504로 연락하세요<br>
                        • 휴게소 내에서는 안전수칙을 준수해주세요
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 졸음쉼터 상세정보 모달 -->
    <div id="restStopModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">
                    <i class="fas fa-bed"></i>
                    <span id="modalTitle2">졸음쉼터 정보</span>
                </div>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="info-section">
                    <div class="info-label">
                        <i class="fas fa-map-marker-alt"></i>
                        위치
                    </div>
                    <div class="info-value" id="modalLocation2">
                        정보를 불러오는 중...
                    </div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">
                        <i class="fas fa-clock"></i>
                        운영시간
                    </div>
                    <div class="info-value">
                        24시간 운영
                    </div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">
                        <i class="fas fa-list"></i>
                        편의시설
                    </div>
                    <div class="facilities-list">
                        <span class="facility-tag">주차장</span>
                        <span class="facility-tag">화장실</span>
                        <span class="facility-tag">휴식공간</span>
                        <span class="facility-tag">안전시설</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <div class="info-label">
                        <i class="fas fa-exclamation-triangle"></i>
                        안전수칙
                    </div>
                    <div class="info-value">
                        • 졸음이 느껴지면 즉시 휴식을 취하세요<br>
                        • 15-20분 정도의 짧은 휴식이 효과적입니다<br>
                        • 졸음쉼터는 임시 휴식용이므로 장시간 이용을 피하세요<br>
                        • 긴급상황 시 1588-2504로 연락하세요
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // DOM이 완전히 로드된 후에 스크립트 실행
        document.addEventListener('DOMContentLoaded', function() {
            // 탭 기능 구현
            const tabButtons = document.querySelectorAll('.tab-btn');
            const tabPanes = document.querySelectorAll('.tab-pane');

            tabButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const targetTab = this.getAttribute('data-tab');
                    
                    // 모든 탭 버튼에서 active 클래스 제거
                    tabButtons.forEach(btn => btn.classList.remove('active'));
                    
                    // 모든 탭 패널에서 active 클래스 제거
                    tabPanes.forEach(pane => pane.classList.remove('active'));
                    
                    // 클릭된 버튼에 active 클래스 추가
                    this.classList.add('active');
                    
                    // 해당 탭 패널에 active 클래스 추가
                    const targetPane = document.getElementById(targetTab);
                    if (targetPane) {
                        targetPane.classList.add('active');
                    }
                });
            });

            // 카드 애니메이션 효과
            const cards = document.querySelectorAll('.info-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });

            // 리스트 아이템 호버 효과
            const listItems = document.querySelectorAll('.info-item');
            listItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(5px)';
                });
                
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0)';
                });
            });
        });

        // 휴게소 정보 모달 표시
        function showRestAreaInfo(name, index) {
            const modal = document.getElementById('restAreaModal');
            const title = document.getElementById('modalTitle');
            const location = document.getElementById('modalLocation');
            const phone = document.getElementById('modalPhone');
            
            title.textContent = name;
            location.textContent = `휴게소 #${index + 1} - ${name}`;
            phone.textContent = '031-XXX-XXXX';
            
            modal.style.display = 'block';
        }

        // 졸음쉼터 정보 모달 표시
        function showRestStopInfo(name, index) {
            const modal = document.getElementById('restStopModal');
            const title = document.getElementById('modalTitle2');
            const location = document.getElementById('modalLocation2');
            
            title.textContent = name;
            location.textContent = `졸음쉼터 #${index + 1} - ${name}`;
            
            modal.style.display = 'block';
        }

        // 모달 닫기
        function closeModal() {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                modal.style.display = 'none';
            });
        }

        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
