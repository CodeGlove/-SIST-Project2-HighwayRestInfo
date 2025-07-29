<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 고속도로 정보 검색</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="css/mainStyle.css" rel="stylesheet">
    <style>
        @font-face {
            font-family: 'PretendardVariable';
            src: url('fonts/PretendardVariable.woff2') format('woff2-variations');
            font-weight: 45 920;
            font-style: normal;
            font-display: swap;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="nav-container">
            <a href="#" class="logo">
                <div class="logo-icon"><i class="fas fa-road"></i></div>
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
                <a href="Login.jsp" class="btn btn-login">로그인</a>
                <a href="#" class="btn btn-register">회원가입</a>
            </div>
        </div>
    </header>
    <main>
        <section class="hero">
            <div class="hero-content fade-in">
                <h1>고속도로의 모든 것<br>HighwayGuide에서 쉽고 간편하게</h1>
                <p>전국의 고속도로, 휴게소, 주유소, 충전소, 음식점, 호텔 등<br>여행에 필요한 모든 정보를 한 곳에서 확인하세요.</p>
                <div class="search-container slide-up">
                    <input type="text" class="search-input" placeholder="검색어를 입력하세요 (예: 휴게소, 주유소, 음식점)">
                    <button class="search-btn">
                        <i class="fas fa-search"></i>
                        검색
                    </button>
                </div>
                <div class="common-searches slide-up">
                    <div class="search-tags">
                        <a href="#" class="search-tag"><i class="fas fa-gas-pump"></i>주유소</a>
                        <a href="#" class="search-tag"><i class="fas fa-charging-station"></i>충전소</a>
                        <a href="#" class="search-tag"><i class="fas fa-utensils"></i>음식점</a>
                        <a href="#" class="search-tag"><i class="fas fa-hotel"></i>호텔</a>
                        <a href="#" class="search-tag"><i class="fas fa-restroom"></i>화장실</a>
                        <a href="#" class="search-tag"><i class="fas fa-parking"></i>주차장</a>
                        <a href="#" class="search-tag"><i class="fas fa-wifi"></i>WiFi</a>
                    </div>
                </div>
            </div>
        </section>
    </main>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 검색 기능
            const searchBtn = document.querySelector('.search-btn');
            const searchInput = document.querySelector('.search-input');
            searchBtn.addEventListener('click', function() {
                const searchTerm = searchInput.value;
                if (searchTerm) {
                    alert(`검색어: ${searchTerm}\n검색 기능이 구현될 예정입니다.`);
                } else {
                    alert('검색어를 입력하세요.');
                }
            });
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchBtn.click();
                }
            });
            // 검색 태그 클릭 이벤트
            document.querySelectorAll('.search-tag').forEach(tag => {
                tag.addEventListener('click', function(e) {
                    e.preventDefault();
                    searchInput.value = this.textContent.trim();
                    searchInput.focus();
                });
            });
        });
    </script>
</body>
</html>