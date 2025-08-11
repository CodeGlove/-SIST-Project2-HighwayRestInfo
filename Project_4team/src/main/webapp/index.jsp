<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 고속도로의 모든 것</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
          rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="css/indexStyle.css" rel="stylesheet">
    <link href="css/footerStyle.css" rel="stylesheet">

</head>
<body>
<!-- Header -->

<header class="header">
    <div class="nav-container">
        <a href="Controller" class="logo">
            <div class="logo-icon">
                <i class="fas fa-road"></i>
            </div>
            HighwayGuide
        </a>
        <nav>
            <ul class="nav-links">
                <li><a href="#">회사 소개</a></li>
                <li><a href="Controller?type=notice" class="btn btn-notice">공지사항</a></li> <%--08.04-한결 수정--%>
                <li><a href="#">고객센터</a></li>
                <li><a href="#">자주 묻는 질문</a></li>
                <li><a href="#">채용</a></li>
            </ul>
        </nav>
        <div class="auth-buttons">
            <a href="#" class="btn btn-login">KOR</a>
            <a href="#" class="btn btn-login">ENG</a>
            <a href="Controller?type=login" class="btn btn-login">로그인</a>
            <a href="Controller?type=register" class="btn btn-register">회원가입</a>
        </div>
    </div>
</header>

<!-- Hero Section -->
<main>
    <section class="hero">
        <div class="floating-icons">
            <div class="floating-icon">
                <i class="fas fa-car"></i>
            </div>
            <div class="floating-icon">
                <i class="fas fa-building"></i>
            </div>
            <div class="floating-icon">
                <i class="fas fa-mobile-alt"></i>
            </div>
            <div class="floating-icon">
                <i class="fas fa-gift"></i>
            </div>
    </section>

    <!-- Search Section -->
    <section class="search-section slide-up">
        <h2 class="section-title">경로내 휴게시설 검색</h2>
        <div class="search-container">
            <form action="Controller?type=kakaoMap" method="post" id="routeForm">
                <input type="text" name="origin" id="origin" class="search-input" placeholder="출발지를 입력하세요"
                       value="<c:out value='${origin}'/>" required>
                <input type="text" name="destination" id="destination" class="search-input" placeholder="목적지를 입력하세요"
                       value="<c:out value='${destination}'/>" required>
                <!-- 폼 제출 후 KakaoMapAction에서 경로 계산 완료 후 RestAreaAction으로 자동 포워딩하도록 지시하는 숨겨진 필드 -->
                <input type="hidden" name="forwardTo" value="restArea">
                <button type="submit" class="search-btn" id="searchRouteBtn"><i class="fas fa-search"></i> 길찾기</button>

                <!-- 에러 메시지 표시 -->
                <c:if test="${not empty error}">
                    <div class="error-text">
                        <i class="fas fa-exclamation-circle"></i>
                        올바른 주소를 입력해주세요
                    </div>
                </c:if>
            </form>
        </div>
        <div class="search-tags">
            <a href="#" class="search-tag"><i class="fas fa-gas-pump"></i>주유소</a>
            <a href="#" class="search-tag"><i class="fas fa-charging-station"></i>충전소</a>
            <a href="#" class="search-tag"><i class="fas fa-utensils"></i>음식점</a>
            <a href="#" class="search-tag"><i class="fas fa-hotel"></i>호텔</a>
            <a href="#" class="search-tag"><i class="fas fa-restroom"></i>화장실</a>
            <a href="#" class="search-tag"><i class="fas fa-parking"></i>주차장</a>
            <a href="#" class="search-tag"><i class="fas fa-wifi"></i>WiFi</a>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <h2 class="features-title">고속도로 관리</h2>
        <p class="features-subtitle">지출부터 똑똑하게 똑똑하게</p>
        <div class="feature-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-route"></i>
                </div>
                <h3>실시간 교통정보</h3>
                <p>고속도로의 실시간 교통상황을 확인하고 최적의 경로를 찾아보세요.</p>
            </div>
            <a href="Controller?type=mapinfo" class="card-link">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-gas-pump"></i>
                    </div>
                    <h3>휴게소 정보</h3>
                    <p>주유소, 충전소, 음식점, 화장실 등 휴게소의 모든 정보를 한눈에 확인하세요.</p>
                </div>
            </a>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-map-marked-alt"></i>
                </div>
                <h3>상세 지도</h3>
                <p>고속도로 구간별 상세 지도와 시설물 정보를 제공합니다.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-clock"></i>
                </div>
                <h3>운행시간 관리</h3>
                <p>운전시간과 휴식시간을 체계적으로 관리하여 안전한 운전을 도와드립니다.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h3>긴급상황 알림</h3>
                <p>사고, 공사, 기상상황 등 긴급한 정보를 실시간으로 알려드립니다.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-star"></i>
                </div>
                <h3>즐겨찾기</h3>
                <p>자주 이용하는 휴게소나 경로를 저장하고 빠르게 찾아보세요.</p>
            </div>
        </div>
    </section>
</main>


<script>
    document.addEventListener('DOMContentLoaded', function () {
        // 스크롤 애니메이션 초기화
        initializeScrollAnimation();

        // 길찾기 폼 초기화
        initializeRouteForm();
    });

    // 스크롤 애니메이션 초기화
    function initializeScrollAnimation() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // 관찰할 요소들
        document.querySelectorAll('.feature-card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';
            card.style.transition = 'all 0.6s ease-out';
            observer.observe(card);
        });
    }

    // 길찾기 폼 초기화
    function initializeRouteForm() {
        const routeForm = document.getElementById('routeForm');
        const searchBtn = document.getElementById('searchRouteBtn');

        if (routeForm && searchBtn) {
            // 폼 제출 이벤트 처리
            routeForm.addEventListener('submit', function (e) {
                const originInput = document.getElementById('origin');
                const destinationInput = document.getElementById('destination');

                // 입력값 검증
                if (!originInput.value.trim() || !destinationInput.value.trim()) {
                    e.preventDefault();
                    alert('출발지와 목적지를 모두 입력해주세요.');
                    return false;
                }

                // 로딩 상태 표시
                setLoadingState(searchBtn, true);

                // 폼 제출을 계속 진행
                return true;
            });
        }
    }

    // 로딩 상태 설정
    function setLoadingState(button, isLoading) {
        if (isLoading) {
            button.disabled = true;
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 검색 중...';
            button.style.opacity = '0.7';
        } else {
            button.disabled = false;
            button.innerHTML = '<i class="fas fa-search"></i> 길찾기';
            button.style.opacity = '1';
        }
    }


</script>

<!-- Footer Include -->
<jsp:include page="footer.jsp" />

</body>
</html>