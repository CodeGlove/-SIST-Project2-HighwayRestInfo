<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 시작하기</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="css/register_1.css" rel="stylesheet">
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
    <!-- Back to Home Link -->
    <a href="mainpage.jsp" class="back-home">
        <i class="fas fa-arrow-left"></i>
        홈으로 돌아가기
    </a>

    <!-- Main Container -->
    <div class="container fade-in-up">
        <!-- Header -->
        <div class="header">
            <div class="logo-container">
                <div class="logo-icon">
                    <i class="fas fa-cube"></i>
                </div>
                <h1>HighWayGuide</h1>
                <div class="star-icon">
                    <i class="fas fa-star"></i>
                </div>
            </div>
        </div>

        <!-- Content -->
        <div class="content">
            <h2 class="heading">전국휴게소<br>정보를 얻어보세요</h2>
            <p class="subheading">매력있는 휴게소를 <br>쉽고 편리하게 확인하세요</p>

            <!-- Main Buttons -->
            <div class="main-buttons">
                <a href="#" class="btn btn-kakao" id="kakaoBtn">
                    <i class="fas fa-comment"></i>
                    카카오로 시작하기
                </a>
                <a href="#" class="btn btn-naver" id="naverBtn">
                    <i class="fas fa-n"></i>
                    네이버로 시작하기
                </a>
                <a href="register.jsp" class="btn btn-email" id="emailBtn">
                    이메일로 시작하기
                </a>
            </div>

            <!-- Social Icons -->
            <div class="social-icons">
                <a href="#" class="social-icon google" id="googleIcon">
                    <i class="fab fa-google"></i>
                </a>
                <a href="#" class="social-icon apple" id="appleIcon">
                    <i class="fab fa-apple"></i>
                </a>
                <a href="#" class="social-icon facebook" id="facebookIcon">
                    <i class="fab fa-facebook-f"></i>
                </a>
            </div>

            <!-- Business Link -->
            <div class="business-link">
                사업자 회원 <a href="#" id="businessLink">HighwayGuide Biz로 시작하기</a>
            </div>

            <!-- Login Link -->
            <div class="login-link">
                이미 HighwayGuide 회원이신가요? <a href="Controller?type=login" id="loginLink">로그인</a>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const kakaoBtn = document.getElementById('kakaoBtn');
            const naverBtn = document.getElementById('naverBtn');
            const emailBtn = document.getElementById('emailBtn');
            const googleIcon = document.getElementById('googleIcon');
            const appleIcon = document.getElementById('appleIcon');
            const facebookIcon = document.getElementById('facebookIcon');
            const businessLink = document.getElementById('businessLink');
            const loginLink = document.getElementById('loginLink');

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
            document.querySelectorAll('.header, .content, .heading, .subheading, .main-buttons, .social-icons, .business-link, .login-link').forEach(element => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(30px)';
                element.style.transition = 'all 0.6s ease-out';
                observer.observe(element);
            });

            // 카카오 로그인
            kakaoBtn.addEventListener('click', function(e) {
                e.preventDefault();
                alert('카카오 로그인 기능이 구현될 예정입니다.');
            });

            // 네이버 로그인
            naverBtn.addEventListener('click', function(e) {
                e.preventDefault();
                alert('네이버 로그인 기능이 구현될 예정입니다.');
            });

            // 이메일 로그인
            emailBtn.addEventListener('click', function(e) {
                // 회원가입 페이지로 이동
                // e.preventDefault() 제거하여 링크가 작동하도록 함
            });

            // 소셜 아이콘 클릭 이벤트
            googleIcon.addEventListener('click', function(e) {
                e.preventDefault();
                alert('Google 로그인 기능이 구현될 예정입니다.');
            });

            appleIcon.addEventListener('click', function(e) {
                e.preventDefault();
                alert('Apple 로그인 기능이 구현될 예정입니다.');
            });

            facebookIcon.addEventListener('click', function(e) {
                e.preventDefault();
                alert('Facebook 로그인 기능이 구현될 예정입니다.');
            });

            // 사업자 회원 링크
            businessLink.addEventListener('click', function(e) {
                e.preventDefault();
                alert('HighwayGuide Biz 기능이 구현될 예정입니다.');
            });

            // 로그인 링크
            loginLink.addEventListener('click', function(e) {
                // 로그인 페이지로 이동
                // e.preventDefault() 제거하여 링크가 작동하도록 함
            });
        });
    </script>
</body>
</html>
