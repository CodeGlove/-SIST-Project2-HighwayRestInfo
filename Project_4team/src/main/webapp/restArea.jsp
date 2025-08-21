<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--한글 인코딩 삭제했는데 이상이 다음 버전까지 이상없으면 삭제한 상태 유지--%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>휴게소 정보</title>

    <!-- 폰트 및 아이콘 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- CSS 파일 링크 -->
    <link href="${pageContext.request.contextPath}/css/restareaStyle.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/indexStyle.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/footerStyle.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>
<div class="main-container"> <%-- 메인 --%>
    <div class="page-title fade-in"> <%-- 제목  --%>
        <h1><i class="fas fa-map-marked-alt"></i> 경로상 휴게시설 정보</h1>
        <p>휴게소와 졸음쉼터 정보를 확인하세요</p>
    </div>



    <!-- 경로 정보 표시 -->
    <c:if test="${not empty origin and not empty destination}">
        <div class="route-info">
            <div class="route-item">
                <i class="fas fa-map-marker-alt start-icon"></i>
                <span class="route-label">출발지:</span>
                <span class="route-value">${origin}</span>
            </div>
            <div class="route-item">
                <i class="fas fa-map-marker-alt end-icon"></i>
                <span class="route-label">목적지:</span>
                <span class="route-value">${destination}</span>
            </div>
            <div class="route-item">
                <i class="fas fa-road detail-icon"></i>
                <span class="route-label">전체거리:</span>
                <span class="route-value">
                        <c:choose>
                            <c:when test="${not empty distance}">
                                <fmt:formatNumber value="${distance / 1000}" pattern="#,##0.0"/>km
                            </c:when>
                            <c:otherwise>정보 없음</c:otherwise>
                        </c:choose>
                    </span>
            </div>
            <div class="route-item">
                <i class="fas fa-clock detail-icon"></i>
                <span class="route-label">소요시간:</span>
                <span class="route-value">
                        <c:choose>
                            <c:when test="${not empty duration}">
                                <c:set var="totalHours" value="${duration / 3600}"/>
                                <c:set var="hours" value="${totalHours.intValue()}"/>
                                <c:set var="totalMinutes" value="${(duration % 3600) / 60}"/>
                                <c:set var="minutes" value="${totalMinutes.intValue()}"/>
                                <c:if test="${hours > 0}">${hours}시간</c:if>
                                <c:if test="${minutes > 0}">${minutes}분</c:if>
                            </c:when>
                            <c:otherwise>정보 없음</c:otherwise>
                        </c:choose>
                    </span>
            </div>
            <div class="route-item">
                <i class="fas fa-money-bill-wave detail-icon"></i>
                <span class="route-label">통행료:</span>
                <span class="route-value">
                        <c:choose>
                            <c:when test="${not empty tollFare and tollFare > 0}">
                                <fmt:formatNumber value="${tollFare}" pattern="#,##0"/>원
                            </c:when>
                            <c:otherwise>무료</c:otherwise>
                        </c:choose>
                    </span>
            </div>
        </div> <%--  요약정보  --%>
    </c:if>
    <!-- 휴게시설 목록 -->
    <div class="info-card slide-up">
        <div class="card-header">
            <div class="card-icon">
                <i class="fas fa-route"></i>
            </div>
            <div class="card-title">휴게시설</div>
            <button class="only-sa" onclick="toggleRestStops(this)">
                <i class="fas fa-bed button-icon"></i>
                <span class="button-text">졸음쉼터 표시</span>
            </button>
        </div> <!-- 카드헤더 -->
        <c:choose>
            <c:when test="${not empty allRestAreas}">
                <div class="rest-areas-list">
                    <c:forEach var="restArea" items="${allRestAreas}" varStatus="status">
                        <div class="rest-area-card clickable ${restArea.contains('휴게소') ? 'service-area' : 'rest-stop'}"
                             onclick="showRestAreaInfo('${restArea}', ${status.index})">
                            <div class="rest-area-info-row">
                                <!-- 휴게시설명 섹션 -->
                                <div class="rest-area-name-section">
                                    <div class="rest-area-name">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <span class="facility-name"><c:out value="${restArea}"/></span>
                                    </div>
                                    <div class="rest-area-rating">
                                        <span class="rating-label">별점</span>
                                        <div class="stars">
                                            <c:set var="serviceAreaVO" value="${serviceAreaVOs[restArea]}" />
                                            <c:choose>
                                                <c:when test="${not empty serviceAreaVO and not empty serviceAreaVO.star and serviceAreaVO.star != '0' and serviceAreaVO.star != '0.0'}">
                                                    <!-- 노란별 하나만 표시 -->
                                                    <i class="fas fa-star star filled"></i>
                                                    <!-- 소수점 2자리까지 점수 표시 -->
                                                    <span class="rating-score"><fmt:formatNumber value="${serviceAreaVO.star}" pattern="#.##" /></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- 평가 없을 때는 회색 별 -->
                                                    <i class="fas fa-star star"></i>
                                                    <span class="rating-score">평가 없음</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>


                                    <!-- 소요시간 표시 -->
                                    <c:if test="${restArea.contains('휴게소')}">
                                        <c:set var="serviceAreaIndex" value="0"/>
                                        <c:forEach var="restAreaItem" items="${allRestAreas}" varStatus="itemStatus">
                                            <c:if test="${restAreaItem.contains('휴게소') and restAreaItem eq restArea}">
                                                <c:if test="${not empty serviceAreaOnlyDurations and serviceAreaIndex < serviceAreaOnlyDurations.size()}">
                                                    <div class="duration-info">
                                                        <i class="fas fa-clock duration-icon"></i>
                                                        <span class="duration-text">
                                                            <c:set var="duration"
                                                                   value="${serviceAreaOnlyDurations[serviceAreaIndex]}"/>
                                                            <c:set var="totalHours" value="${duration / 3600}"/>
                                                            <c:set var="hours" value="${totalHours.intValue()}"/>
                                                            <c:set var="totalMinutes"
                                                                   value="${(duration % 3600) / 60}"/>
                                                            <c:set var="minutes"
                                                                   value="${totalMinutes.intValue()}"/>
                                                            <c:choose>
                                                                <c:when test="${serviceAreaIndex == 0}">
                                                                    출발지부터 <c:if
                                                                        test="${hours > 0}">${hours}시간</c:if><c:if
                                                                        test="${minutes > 0}">${minutes}분</c:if>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    이전 휴게소부터 <c:if
                                                                        test="${hours > 0}">${hours}시간</c:if><c:if
                                                                        test="${minutes > 0}">${minutes}분</c:if>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                            <c:if test="${restAreaItem.contains('휴게소')}">
                                                <c:set var="serviceAreaIndex" value="${serviceAreaIndex + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>

                                    <!-- 졸음쉼터 소요시간 표시 -->
                                    <c:if test="${restArea.contains('졸음쉼터')}">
                                        <c:if test="${not empty allRestAreaDurations and status.index < allRestAreaDurations.size()}">
                                            <div class="duration-info">
                                                <i class="fas fa-clock duration-icon"></i>
                                                <span class="duration-text">
                                                    <c:set var="duration"
                                                           value="${allRestAreaDurations[status.index]}"/>
                                                    <c:set var="totalHours" value="${duration / 3600}"/>
                                                    <c:set var="hours" value="${totalHours.intValue()}"/>
                                                    <c:set var="totalMinutes"
                                                           value="${(duration % 3600) / 60}"/>
                                                    <c:set var="minutes"
                                                           value="${totalMinutes.intValue()}"/>
                                                    <c:choose>
                                                        <c:when test="${status.index == 0}">
                                                            출발지부터 <c:if
                                                                test="${hours > 0}">${hours}시간</c:if><c:if
                                                                test="${minutes > 0}">${minutes}분</c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            이전 휴게시설부터 <c:if
                                                                test="${hours > 0}">${hours}시간</c:if><c:if
                                                                test="${minutes > 0}">${minutes}분</c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </c:if>
                                    </c:if>
                                </div>

                                <!-- 정보 섹션들 -->
                                <div class="info-sections-row">
                                    <!-- 편의시설 섹션 -->
                                    <div class="content-section">
                                        <c:choose>
                                            <c:when test="${restArea.contains('휴게소')}">
                                                <div class="section-title">
                                                    <i class="fas fa-list"></i>
                                                    편의시설
                                                </div>
                                                <div class="facilities-grid">
                                                    <c:set var="serviceAreaVO" value="${serviceAreaVOs[restArea]}" />
                                                    <c:if test="${not empty serviceAreaVO and not empty serviceAreaVO.convenience}">
                                                        <c:forEach var="facility" items="${serviceAreaVO.convenience.split(',')}" varStatus="facilityStatus">
                                                            <c:choose>
                                                                <c:when test="${facility.contains('수유실')}">
                                                                    <div class="facility-item">
                                                                        <i class="fas fa-baby facility-icon"></i>
                                                                        <span>수유실</span>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${facility.contains('약국')}">
                                                                    <div class="facility-item">
                                                                        <i class="fas fa-first-aid facility-icon"></i>
                                                                        <span>약국</span>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${facility.contains('버스')}">
                                                                    <div class="facility-item">
                                                                        <i class="fas fa-bus facility-icon"></i>
                                                                        <span>버스환승</span>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${facility.contains('ATM')}">
                                                                    <div class="facility-item">
                                                                        <i class="fas fa-credit-card facility-icon"></i>
                                                                        <span>ATM</span>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${facility.contains('주유소')}">
                                                                    <div class="facility-item">
                                                                        <i class="fas fa-gas-pump facility-icon"></i>
                                                                        <span>주유소</span>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${facility.contains('충전소')}">
                                                                    <div class="facility-item">
                                                                        <i class="fas fa-charging-station facility-icon"></i>
                                                                        <span>충전소</span>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${facility.contains('음식점')}">
                                                                    <div class="facility-item">
                                                                        <i class="fas fa-utensils facility-icon"></i>
                                                                        <span>음식점</span>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${facility.contains('편의점')}">
                                                                    <div class="facility-item">
                                                                        <i class="fas fa-store facility-icon"></i>
                                                                        <span>편의점</span>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="facility-item">
                                                                        <i class="fas fa-check facility-icon"></i>
                                                                        <span>${facility.trim()}</span>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </c:if>
                                                    <c:if test="${empty serviceAreaVO or empty serviceAreaVO.convenience}">
                                                        <div class="facility-item">
                                                            <i class="fas fa-info-circle facility-icon"></i>
                                                            <span>편의시설 정보 없음</span>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:when>
                                        </c:choose>
                                    </div>

                                    <!-- 주유비/운영시간 섹션 -->
                                    <div class="content-section">
                                        <c:choose>
                                            <c:when test="${restArea.contains('휴게소')}">
                                                <c:set var="serviceAreaVO" value="${serviceAreaVOs[restArea]}" />
                                                
                                                <div class="section-title-with-date">
                                                    <div class="section-title-left">
                                                        <i class="fas fa-gas-pump"></i>
                                                        주유비
                                                    </div>
                                                    <div class="section-title-date">
                                                        <jsp:useBean id="now" class="java.util.Date" />
                                                        <fmt:formatDate value="${now}" pattern="yyyy.MM.dd" />
                                                    </div>
                                                </div>
                                                <div class="fuel-info">
                                                    <c:if test="${not empty serviceAreaVO and not empty serviceAreaVO.gasInfo}">
                                                        <c:if test="${not empty serviceAreaVO.gasInfo.gasoline}">
                                                            <div class="fuel-price">휘발유: ${serviceAreaVO.gasInfo.gasoline}</div>
                                                        </c:if>
                                                        <c:if test="${not empty serviceAreaVO.gasInfo.disel}">
                                                            <div class="fuel-price">경유: ${serviceAreaVO.gasInfo.disel}</div>
                                                        </c:if>
                                                        <c:if test="${not empty serviceAreaVO.gasInfo.LPG}">
                                                            <div class="fuel-price">LPG: ${serviceAreaVO.gasInfo.LPG}</div>
                                                        </c:if>
                                                        <c:if test="${empty serviceAreaVO.gasInfo.gasoline and empty serviceAreaVO.gasInfo.disel and empty serviceAreaVO.gasInfo.LPG}">
                                                            <div class="fuel-price">주유소 정보 없음</div>
                                                        </c:if>
                                                    </c:if>
                                                    <c:if test="${empty serviceAreaVO or empty serviceAreaVO.gasInfo}">
                                                        <div class="fuel-price">주유소 정보 없음</div>
                                                    </c:if>
                                                </div>
                                            </c:when>
                                        </c:choose>
                                    </div>

                                    <!-- 대표메뉴/안전수칙 섹션 -->
                                    <div class="content-section">
                                        <c:choose>
                                            <c:when test="${restArea.contains('휴게소')}">
                                                <div class="section-title">
                                                    <i class="fas fa-utensils"></i>
                                                    대표메뉴
                                                </div>
                                                <div class="menu-item">
                                                    참치김치찌개
                                                </div>
                                            </c:when>
                                        </c:choose>
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
                    <p>경로상 휴게시설이 발견되지 않았습니다.</p>
                    <p style="font-size: 0.9rem; color: #999; margin-top: 0.5rem;">
                        다른 경로를 시도해보세요.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- 추가 정보 섹션 -->
<c:if test="${not empty allRestAreas}">
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

<script>
    // DOM이 완전히 로드된 후에 스크립트 실행
    document.addEventListener('DOMContentLoaded', function () {
        // 기존 탭 기능 구현
        const tabButtons = document.querySelectorAll('.tab-btn');
        const tabPanes = document.querySelectorAll('.tab-pane');

        tabButtons.forEach(button => {
            button.addEventListener('click', function () {
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
            item.addEventListener('mouseenter', function () {
                this.style.transform = 'translateX(5px)';
            });

            item.addEventListener('mouseleave', function () {
                this.style.transform = 'translateX(0)';
            });
        });

        // 페이지 로드 시 졸음쉼터 카드들을 기본적으로 숨김
        const restStopCards = document.querySelectorAll('.rest-area-card.rest-stop');
        restStopCards.forEach(card => {
            card.style.display = 'none';
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

    // 졸음쉼터 표시 토글 기능
    function toggleRestStops(button) {
        const restStopCards = document.querySelectorAll('.rest-area-card.rest-stop');
        const serviceAreaCards = document.querySelectorAll('.rest-area-card.service-area');
        const buttonText = button.querySelector('.button-text');
        const buttonIcon = button.querySelector('.button-icon');
        const isActive = button.classList.contains('active');

        // 서버에서 전달받은 소요시간 데이터
        const allRestAreaDurations = ${allRestAreaDurations != null ? allRestAreaDurations : '[]'};

        // RestAreaAction에서 계산된 휴게소 전용 소요시간 사용
        const serviceAreaOnlyDurations = ${serviceAreaOnlyDurations != null ? serviceAreaOnlyDurations : '[]'};

        if (isActive) {
            // 졸음쉼터 숨기기 - 소요시간 먼저 변경, 그 다음 리스트 변경
            buttonText.textContent = '졸음쉼터 표시';
            buttonIcon.className = 'fas fa-bed button-icon';
            button.classList.remove('active');

            // 1단계: 소요시간 먼저 업데이트 (300ms)
            updateServiceAreaDurations(serviceAreaCards, serviceAreaOnlyDurations);

            // 2단계: 소요시간 업데이트 완료 후 리스트 애니메이션 시작 (600ms 대기)
            setTimeout(() => {
                // 콜랩스 애니메이션으로 사라지기 (빈 공간 채우기)
                restStopCards.forEach((card, index) => {
                    setTimeout(() => {
                        // 1단계: 페이드아웃과 스케일 다운 (더 부드럽게)
                        card.classList.add('animating-out');

                        setTimeout(() => {
                            // 2단계: 콜랩스 (높이와 마진 줄이기) - 더 긴 시간
                            card.classList.remove('animating-out');
                            card.classList.add('collapsing');

                            setTimeout(() => {
                                // 3단계: 완전히 숨기기
                                card.style.display = 'none';
                                card.classList.remove('collapsing');
                                // 스타일 정리
                                card.style.maxHeight = '';
                                card.style.marginBottom = '';
                                card.style.padding = '';
                            }, 800); // 콜랩스 애니메이션 시간 증가
                        }, 300); // 페이드아웃 후 콜랩스 시작 - 더 여유롭게
                    }, index * 120); // 순차적 사라짐 - 더 여유로운 간격
                });
            }, 600); // 소요시간 업데이트 완료 후 대기
        } else {
            // 졸음쉼터 표시 - 소요시간 먼저 복원, 그 다음 리스트 표시
            buttonText.textContent = '졸음쉼터 숨기기';
            buttonIcon.className = 'fas fa-eye-slash button-icon';
            button.classList.add('active');

            // 1단계: 소요시간 먼저 복원
            restoreOriginalDurations(serviceAreaCards, allRestAreaDurations);

            // 2단계: 소요시간 복원 완료 후 리스트 나타나기 애니메이션
            setTimeout(() => {
                // 확장 애니메이션으로 나타나기 (공간 채우며 등장)
                restStopCards.forEach((card, index) => {
                    // 스택드 애니메이션으로 순차적 등장
                    setTimeout(() => {
                        card.style.display = 'block';

                        // 1단계: 확장 시작 (높이 0에서 시작)
                        card.classList.add('expanding');

                        // 더 부드러운 타이밍으로 애니메이션 시작
                        setTimeout(() => {
                            // 2단계: 확장과 페이드인
                            card.classList.remove('expanding');
                            card.classList.add('visible');

                            // 완료 후 클래스 정리
                            setTimeout(() => {
                                card.classList.remove('visible');
                                // 원래 스타일로 복원
                                card.style.maxHeight = '';
                                card.style.marginBottom = '';
                                card.style.padding = '';
                            }, 700); // 더 긴 시간
                        }, 50); // 약간의 딜레이로 더 자연스럽게
                    }, index * 150); // 더 여유로운 순차적 딜레이
                });
            }, 500); // 소요시간 복원 완료 후 대기
        }
    }

    // 휴게소끼리 소요시간으로 업데이트 (부드러운 애니메이션)
    function updateServiceAreaDurations(serviceAreaCards, serviceAreaOnlyDurations) {

        if (!window.originalDurations) {
            // 원본 소요시간 저장
            window.originalDurations = [];
            const allCards = document.querySelectorAll('.rest-area-card');
            allCards.forEach(card => {
                const durationElement = card.querySelector('.duration-text');
                if (durationElement) {
                    window.originalDurations.push({
                        element: durationElement,
                        originalText: durationElement.innerHTML
                    });
                }
            });
        }

        let serviceAreaIndex = 0;
        serviceAreaCards.forEach((card, index) => {
            const durationElement = card.querySelector('.duration-text');
            if (durationElement && serviceAreaIndex < serviceAreaOnlyDurations.length) {
                const duration = serviceAreaOnlyDurations[serviceAreaIndex];
                const hours = Math.floor(duration / 3600);
                const minutes = Math.floor((duration % 3600) / 60);

                let newTimeText = '';
                if (serviceAreaIndex === 0) {
                    newTimeText = '출발지부터 ';
                } else {
                    newTimeText = '이전 휴게소부터 ';
                }

                if (hours > 0) newTimeText += hours + '시간';
                if (minutes > 0) newTimeText += minutes + '분';

                // 부드러운 텍스트 변경 애니메이션 (더 자연스럽게)
                setTimeout(() => {
                    durationElement.classList.add('updating');

                    setTimeout(() => {
                        durationElement.innerHTML = newTimeText;

                        setTimeout(() => {
                            durationElement.classList.remove('updating');
                        }, 250); // 더 긴 시간
                    }, 200); // 더 여유로운 타이밍
                }, index * 150); // 순차적 업데이트 - 더 여유로운 간격

                serviceAreaIndex++;
            }
        });
    }

    // 원래 소요시간으로 복원 (부드러운 애니메이션)
    function restoreOriginalDurations(serviceAreaCards, allRestAreaDurations) {
        // 모든 휴게시설 카드들을 가져와서 휴게소 인덱스 매핑
        const allCards = document.querySelectorAll('.rest-area-card');
        const serviceAreaIndices = [];

        let serviceAreaIndex = 0;
        allCards.forEach((card, index) => {
            if (card.classList.contains('service-area')) {
                serviceAreaIndices.push(index);
            }
        });

        serviceAreaCards.forEach((card, cardIndex) => {
            const durationElement = card.querySelector('.duration-text');
            if (durationElement) {
                // 해당 휴게소의 전체 휴게시설 인덱스 찾기
                const allRestAreaIndex = serviceAreaIndices[cardIndex];

                if (allRestAreaIndex !== undefined && allRestAreaIndex < allRestAreaDurations.length) {
                    const duration = allRestAreaDurations[allRestAreaIndex];
                    const hours = Math.floor(duration / 3600);
                    const minutes = Math.floor((duration % 3600) / 60);

                    let newTimeText = '';
                    if (allRestAreaIndex === 0) {
                        newTimeText = '출발지부터 ';
                    } else {
                        newTimeText = '이전 휴게시설부터 ';
                    }

                    if (hours > 0) newTimeText += hours + '시간';
                    if (minutes > 0) newTimeText += minutes + '분';

                    setTimeout(() => {
                        durationElement.classList.add('updating');

                        setTimeout(() => {
                            durationElement.innerHTML = newTimeText;

                            setTimeout(() => {
                                durationElement.classList.remove('updating');
                            }, 250);
                        }, 200);
                    }, cardIndex * 120);
                }
            }
        });
    }


    // 모달 닫기
    function closeModal() {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            modal.style.display = 'none';
        });
    }

    // 모달 외부 클릭 시 닫기
    window.onclick = function (event) {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    }


</script>

<!-- Footer Include -->
<jsp:include page="footer.jsp"/>

</body>
</html>
