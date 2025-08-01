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
    <style>
        @font-face {
            font-family: 'PretendardVariable';
            src: url('fonts/PretendardVariable.woff2') format('woff2-variations');
            font-weight: 45 920;
            font-style: normal;
            font-display: swap;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'PretendardVariable', 'Roboto', sans-serif;
            background: linear-gradient(180deg, #f0f8ff 0%, #ffffff 100%);
            color: #222;
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Header */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            z-index: 1000;
            padding: 1rem 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
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
            color: #222;
            font-weight: 700;
            font-size: 1.5rem;
        }

        .logo-icon {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1rem;
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 2rem;
        }

        .nav-links a {
            text-decoration: none;
            color: #666;
            font-weight: 500;
            transition: color 0.2s;
        }

        .nav-links a:hover {
            color: #222;
        }

        .auth-buttons {
            display: flex;
            gap: 1rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
            font-size: 0.9rem;
        }

        .btn-login {
            color: #666;
            background: none;
        }

        .btn-login:hover {
            color: #222;
        }

        .btn-register {
            color: #fff;
            background: #667eea;
        }

        .btn-register:hover {
            background: #5a67d8;
        }

        /* Hero Section */
        .hero {
            padding: 8rem 2rem 4rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="dots" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="%23e0e7ff" opacity="0.3"/></pattern></defs><rect width="100" height="100" fill="url(%23dots)"/></svg>');
            pointer-events: none;
        }

        .hero-content {
            max-width: 800px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .hero h1 {
            font-size: 3.5rem;
            font-weight: 700;
            color: #222;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }

        .hero p {
            font-size: 1.2rem;
            color: #666;
            margin-bottom: 3rem;
            line-height: 1.6;
        }

        /* 3D Icons */
        .floating-icons {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            pointer-events: none;
        }

        .floating-icon {
            position: absolute;
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: #667eea;
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.1);
            animation: float 6s ease-in-out infinite;
        }

        .floating-icon:nth-child(1) {
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }

        .floating-icon:nth-child(2) {
            top: 30%;
            right: 15%;
            animation-delay: 1s;
        }

        .floating-icon:nth-child(3) {
            top: 60%;
            left: 5%;
            animation-delay: 2s;
        }

        .floating-icon:nth-child(4) {
            top: 70%;
            right: 10%;
            animation-delay: 3s;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-20px);
            }
        }

        /* Search Section */
        .search-section {
            background: #fff;
            padding: 4rem 2rem;
            margin: 2rem 0;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: 2rem auto;
        }

        .search-container {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .search-input {
            flex: 1;
            padding: 1rem 1.5rem;
            border: 2px solid #e5e8eb;
            border-radius: 12px;
            font-size: 1rem;
            outline: none;
            transition: all 0.2s;
        }

        .search-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-btn {
            padding: 1rem 2rem;
            background: #667eea;
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .search-btn:hover {
            background: #5a67d8;
            transform: translateY(-1px);
        }

        .search-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            justify-content: center;
        }

        .search-tag {
            padding: 0.5rem 1rem;
            background: #f8fafc;
            border: 1px solid #e5e8eb;
            border-radius: 20px;
            text-decoration: none;
            color: #666;
            font-size: 0.9rem;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .search-tag:hover {
            background: #667eea;
            color: #fff;
            border-color: #667eea;
        }

        /* Features Section */
        .features {
            padding: 4rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .feature-card {
            background: #fff;
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .feature-card h3 {
            font-size: 1.3rem;
            font-weight: 600;
            color: #222;
            margin-bottom: 0.5rem;
        }

        .feature-card p {
            color: #666;
            line-height: 1.6;
        }

        /* CTA Buttons */
        .cta-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .cta-btn {
            padding: 1rem 2rem;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
            font-size: 1rem;
        }

        .cta-btn.primary {
            background: #667eea;
            color: #fff;
        }

        .cta-btn.primary:hover {
            background: #5a67d8;
            transform: translateY(-1px);
        }

        .cta-btn.secondary {
            background: #fff;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .cta-btn.secondary:hover {
            background: #667eea;
            color: #fff;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2.5rem;
            }

            .nav-links {
                display: none;
            }

            .search-container {
                flex-direction: column;
            }

            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }

            .floating-icons {
                display: none;
            }
        }

        /* Animations */
        .fade-in {
            animation: fadeIn 1s ease-out;
        }

        .slide-up {
            animation: slideUp 0.8s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
<!-- Header -->

<header class="header">
    <div class="nav-container">
        <a href="#" class="logo">
            <div class="logo-icon">
                <i class="fas fa-road"></i>
            </div>
            HighwayGuide
        </a>
        <nav>
            <ul class="nav-links">
                <li><a href="#">회사 소개</a></li>
                <li><a href="#">공지사항</a></li>
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
        </div>
        <div class="hero-content fade-in">
            <h1>고속도로의 모든 것<br>HighwayGuide에서 쉽고 간편하게</h1>
            <p>전국의 고속도로, 휴게소, 주유소, 충전소, 음식점, 호텔 등<br>여행에 필요한 모든 정보를 한 곳에서 확인하세요.</p>
            <div class="cta-buttons">
                <a href="#" class="cta-btn primary">앱 다운로드</a>
                <a href="#" class="cta-btn secondary">서비스 소개</a>
            </div>
        </div>
    </section>

    <!-- Search Section -->
    <section class="search-section slide-up">
        <h2 style="text-align: center; margin-bottom: 2rem; color: #222; font-size: 1.8rem;">고속도로 정보 검색</h2>
        <div class="search-container">
            <input type="text" class="search-input" placeholder="검색어를 입력하세요 (예: 휴게소, 주유소, 음식점)">
            <button class="search-btn">
                <i class="fas fa-search"></i>
                검색
            </button>
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
        <h2 style="text-align: center; margin-bottom: 1rem; color: #222; font-size: 2.5rem;">고속도로 관리</h2>
        <p style="text-align: center; color: #666; font-size: 1.1rem; margin-bottom: 3rem;">지출부터 똑똑하게 똑똑하게</p>
        <div class="feature-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-route"></i>
                </div>
                <h3>실시간 교통정보</h3>
                <p>고속도로의 실시간 교통상황을 확인하고 최적의 경로를 찾아보세요.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-gas-pump"></i>
                </div>
                <h3>휴게소 정보</h3>
                <p>주유소, 충전소, 음식점, 화장실 등 휴게소의 모든 정보를 한눈에 확인하세요.</p>
            </div>
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
        // 검색 기능
        const searchBtn = document.querySelector('.search-btn');
        const searchInput = document.querySelector('.search-input');

        searchBtn.addEventListener('click', function () {
            const searchTerm = searchInput.value;
            if (searchTerm) {
                alert(`검색어: ${searchTerm}\n검색 기능이 구현될 예정입니다.`);
            } else {
                alert('검색어를 입력하세요.');
            }
        });

        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                searchBtn.click();
            }
        });

        // 검색 태그 클릭 이벤트
        document.querySelectorAll('.search-tag').forEach(tag => {
            tag.addEventListener('click', function (e) {
                e.preventDefault();
                searchInput.value = this.textContent.trim();
                searchInput.focus();
            });
        });

        // 스크롤 애니메이션
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

        <c:if test="${not empty sessionScope.name}">
        // EL(Expression Language)을 사용해 세션 값을 JavaScript 변수에 저장합니다.
        // 서버에서 JSP가 처리될 때 '${sessionScope.name}' 부분이 실제 이름(예: "홍길동")으로 바뀝니다.
        const userName = '${sessionScope.name}';

        // 브라우저의 개발자 도구 콘솔에 환영 메시지를 출력합니다.
        alert(userName + '님 환영합니다. 👋');
        </c:if>

    });
</script>
</body>
</html>