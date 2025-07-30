<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 회원가입 옵션 선택 페이지 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 시작하기</title>
    <%-- 폰트 및 아이콘 라이브러리 로드 --%>
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
    <!-- 메인 페이지로 돌아가는 링크 -->
    <a href="index.jsp" class="back-home">
        <i class="fas fa-arrow-left"></i>
        홈으로 돌아가기
    </a>

    <!-- 회원가입 옵션 전체를 감싸는 컨테이너 -->
    <div class="container fade-in-up">
        <!-- 페이지 상단 헤더 -->
        <div class="header">
            <!-- 로고와 애플리케이션 이름 -->
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

        <!-- 메인 콘텐츠 영역 -->
        <div class="content">
            <h2 class="heading">전국휴게소<br>정보를 얻어보세요</h2>
            <p class="subheading">매력있는 휴게소를 <br>쉽고 편리하게 확인하세요</p>

            <!-- 회원가입 방법 선택 버튼 그룹 -->
            <div class="main-buttons">
                <!-- 카카오로 시작하기 버튼 -->
                <a href="#" class="btn btn-kakao" id="kakaoBtn">
                    <i class="fas fa-comment"></i>
                    카카오로 시작하기
                </a>
                <!-- 네이버로 시작하기 버튼 -->
                <a href="#" class="btn btn-naver" id="naverBtn">
                    <i class="fas fa-n"></i>
                    네이버로 시작하기
                </a>
                <!-- 이메일로 시작하기 버튼 (클릭 시 signupForm.jsp로 이동) -->
                <a href="signupForm.jsp" class="btn btn-email" id="emailBtn">
                    이메일로 시작하기
                </a>
            </div>

            <!-- 다른 소셜 로그인 옵션 아이콘 -->
            <div class="social-icons">
                <a href="#" class="social-icon google" id="googleIcon"><i class="fab fa-google"></i></a>
                <a href="#" class="social-icon apple" id="appleIcon"><i class="fab fa-apple"></i></a>
                <a href="#" class="social-icon facebook" id="facebookIcon"><i class="fab fa-facebook-f"></i></a>
            </div>

            <!-- 사업자 회원 전용 링크 -->
            <div class="business-link">
                사업자 회원 <a href="#" id="businessLink">HighwayGuide Biz로 시작하기</a>
            </div>

            <!-- 이미 계정이 있는 사용자를 위한 로그인 페이지 이동 링크 -->
            <div class="login-link">
                이미 HighwayGuide 회원이신가요? <a href="Controller?type=login" id="loginLink">로그인</a>
            </div>
        </div>
    </div>

    <script>
        // DOM이 완전히 로드된 후에 스크립트 실행
        document.addEventListener('DOMContentLoaded', function() {
            // 각 버튼과 링크 요소들 가져오기
            const kakaoBtn = document.getElementById('kakaoBtn');
            const naverBtn = document.getElementById('naverBtn');
            const emailBtn = document.getElementById('emailBtn');
            const googleIcon = document.getElementById('googleIcon');
            const appleIcon = document.getElementById('appleIcon');
            const facebookIcon = document.getElementById('facebookIcon');
            const businessLink = document.getElementById('businessLink');
            const loginLink = document.getElementById('loginLink');

            // 스크롤에 따른 애니메이션 효과를 위한 Intersection Observer 설정
            const observerOptions = {
                threshold: 0.1, // 요소가 10% 보일 때 콜백 실행
                rootMargin: '0px 0px -50px 0px' // 하단에서 50px 위에서부터 감지 시작
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) { // 요소가 화면에 보이면
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            // 애니메이션을 적용할 요소들 선택 및 관찰 시작
            document.querySelectorAll('.header, .content, .heading, .subheading, .main-buttons, .social-icons, .business-link, .login-link').forEach(element => {
                element.style.opacity = '0'; // 초기 투명도
                element.style.transform = 'translateY(30px)'; // 초기 위치
                element.style.transition = 'all 0.6s ease-out'; // 애니메이션 효과
                observer.observe(element); // 요소 관찰 시작
            });

            // 카카오 로그인 버튼 클릭 이벤트 (현재는 알림만 표시)
            kakaoBtn.addEventListener('click', function(e) {
                e.preventDefault();
                alert('카카오 로그인 기능이 구현될 예정입니다.');
            });

            // 네이버 로그인 버튼 클릭 이벤트 (현재는 알림만 표시)
            naverBtn.addEventListener('click', function(e) {
                e.preventDefault();
                alert('네이버 로그인 기능이 구현될 예정입니다.');
            });

            // 이메일로 시작하기 버튼은 기본 a 태그의 동작(페이지 이동)을 그대로 사용합니다.

            // 다른 소셜 로그인 아이콘 클릭 이벤트 (현재는 알림만 표시)
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

            // 사업자 회원 링크 클릭 이벤트 (현재는 알림만 표시)
            businessLink.addEventListener('click', function(e) {
                e.preventDefault();
                alert('HighwayGuide Biz 기능이 구현될 예정입니다.');
            });

            // 로그인 링크는 기본 a 태그의 동작(페이지 이동)을 그대로 사용합니다.
        });
    </script>
</body>
</html>
