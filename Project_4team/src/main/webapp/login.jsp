<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 사용자 로그인 페이지 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 로그인</title>
    <%-- 폰트 및 아이콘 라이브러리 로드 --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="css/LoginStyle.css" rel="stylesheet">
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

    <!-- 로그인 전체를 감싸는 컨테이너 -->
    <div class="login-container fade-in-up">
        <!-- 로그인 폼 상단 헤더 -->
        <div class="login-header">
            <!-- 언어 선택 드롭다운 (구현 예정) -->
            <div class="language-selector">
                <i class="fas fa-globe"></i>
            </div>
            <!-- 로고와 애플리케이션 이름 -->
            <div class="logo-container">
                <div class="logo-icon">
                    <i class="fas fa-cube"></i>
                </div>
                <h1>HighwayGuide</h1>
                <div class="star-icon">
                    <i class="fas fa-star"></i>
                </div>
            </div>
        </div>

        <!-- 인증 방식 선택 탭 (패스워드, WebAuthn) -->
        <div class="auth-tabs">
            <button class="tab-btn active" data-tab="password">Password</button>
            <button class="tab-btn" data-tab="webauthn">WebAuthn</button>
        </div>

        <!-- 로그인 정보를 입력하는 폼 -->
        <form class="login-form" id="loginForm">
            <!-- 사용자 이름(이메일 또는 전화번호) 입력 그룹 -->
            <div class="form-group">
                <div class="input-container">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" id="username" name="username" class="form-input" placeholder="username, Email or phone" required>
                </div>
            </div>

            <!-- 비밀번호 입력 그룹 -->
            <div class="form-group">
                <div class="input-container">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Password" required>
                    <!-- 비밀번호 보이기/숨기기 토글 버튼 -->
                    <button type="button" class="password-toggle" id="passwordToggle">
                        <i class="fas fa-eye-slash"></i>
                    </button>
                </div>
            </div>

            <!-- 로그인 옵션 (자동 로그인, 비밀번호 찾기) -->
            <div class="login-options">
                <label class="auto-signin">
                    <input type="checkbox" name="autoSignin" id="autoSignin">
                    <span class="checkmark"></span>
                    Auto sign in
                </label>
                <a href="#" class="forgot-link">Forgot password?</a>
            </div>

            <!-- 로그인 실행 버튼 -->
            <button type="submit" class="login-btn">
                Sign In
            </button>
        </form>

        <!-- 회원가입 페이지로 이동하는 링크 -->
        <div class="signup-link">
            No account? <a href="Controller?type=register" id="signupLink">sign up now</a>
        </div>

        <!-- 소셜 로그인 버튼 그룹 -->
        <div class="social-login">
            <a href="#" class="social-icon" id="googleLogin">
                <i class="fab fa-google"></i>
            </a>
            <a href="#" class="social-icon" id="githubLogin">
                <i class="fab fa-github"></i>
            </a>
        </div>
    </div>

    <script>
        // DOM이 완전히 로드된 후에 스크립트 실행
        document.addEventListener('DOMContentLoaded', function() {
            // 로그인 폼과 관련된 DOM 요소들 가져오기
            const loginForm = document.getElementById('loginForm');
            const usernameInput = document.getElementById('username');
            const passwordInput = document.getElementById('password');
            const passwordToggle = document.getElementById('passwordToggle');
            const autoSignin = document.getElementById('autoSignin');
            const googleLogin = document.getElementById('googleLogin');
            const githubLogin = document.getElementById('githubLogin');
            const signupLink = document.getElementById('signupLink');
            const tabBtns = document.querySelectorAll('.tab-btn');

            // 인증 탭 전환 기능
            tabBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    tabBtns.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    // 여기에 각 탭에 맞는 UI 변경 로직 추가 가능 (예: WebAuthn UI 표시)
                });
            });

            // 비밀번호 보이기/숨기기 토글 기능
            passwordToggle.addEventListener('click', function() {
                const type = passwordInput.type === 'password' ? 'text' : 'password';
                passwordInput.type = type;
                this.innerHTML = type === 'password' ? '<i class="fas fa-eye-slash"></i>' : '<i class="fas fa-eye"></i>';
            });

            // 로그인 폼 제출 이벤트 리스너
            loginForm.addEventListener('submit', function(e) {
                e.preventDefault(); // 폼의 기본 제출 동작 방지
                
                const username = usernameInput.value.trim();
                const password = passwordInput.value.trim();
                
                // 기본적인 유효성 검사
                if (!username) {
                    showError(usernameInput, '사용자명, 이메일 또는 전화번호를 입력해주세요.');
                    return;
                }
                
                if (!password) {
                    showError(passwordInput, '비밀번호를 입력해주세요.');
                    return;
                }
                
                if (password.length < 6) {
                    showError(passwordInput, '비밀번호는 6자 이상이어야 합니다.');
                    return;
                }
                
                // 로그인 성공 시 (현재는 시뮬레이션)
                showSuccess('로그인 중입니다...');
                setTimeout(() => {
                    alert('로그인이 완료되었습니다!');
                    window.location.href = 'index.jsp'; // 메인 페이지로 이동
                }, 1500);
            });

            // 이메일 형식 유효성 검사 함수
            function isValidEmail(email) {
                const emailRegex = /^[\S@]+@[\S@]+\.[\S@]+$/;
                return emailRegex.test(email);
            }

            // 에러 메시지 표시 함수
            function showError(input, message) {
                // 기존 에러 메시지 제거
                const existingError = input.parentNode.querySelector('.error-message');
                if (existingError) {
                    existingError.remove();
                }
                
                // 새로운 에러 메시지 생성 및 추가
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.style.color = '#e74c3c';
                errorDiv.style.fontSize = '0.8rem';
                errorDiv.style.marginTop = '0.5rem';
                errorDiv.textContent = message;
                
                input.parentNode.appendChild(errorDiv);
                input.style.borderColor = '#e74c3c'; // 입력창 테두리 색 변경
                
                // 3초 후 에러 메시지 자동 제거
                setTimeout(() => {
                    if (errorDiv.parentNode) {
                        errorDiv.remove();
                        input.style.borderColor = '#bdc3c7'; // 테두리 색 원래대로 복원
                    }
                }, 3000);
            }

            // 성공 메시지 표시 함수
            function showSuccess(message) {
                const successDiv = document.createElement('div');
                successDiv.style.position = 'fixed';
                successDiv.style.top = '20px';
                successDiv.style.right = '20px';
                successDiv.style.background = '#f39c12';
                successDiv.style.color = '#2c3e50';
                successDiv.style.padding = '1rem 2rem';
                successDiv.style.borderRadius = '8px';
                successDiv.style.zIndex = '1000';
                successDiv.style.fontWeight = '600';
                successDiv.textContent = message;
                
                document.body.appendChild(successDiv);
                
                // 2초 후 성공 메시지 자동 제거
                setTimeout(() => {
                    successDiv.remove();
                }, 2000);
            }

            // 소셜 로그인 버튼 클릭 이벤트 핸들러 (현재는 알림만 표시)
            googleLogin.addEventListener('click', function(e) {
                e.preventDefault();
                alert('Google 로그인 기능이 구현될 예정입니다.');
            });

            githubLogin.addEventListener('click', function(e) {
                e.preventDefault();
                alert('GitHub 로그인 기능이 구현될 예정입니다.');
            });

            // 자동 로그인 체크박스 변경 이벤트 리스너
            autoSignin.addEventListener('change', function() {
                if (this.checked) {
                    console.log('자동 로그인이 활성화되었습니다.');
                }
            });
        });
    </script>
</body>
</html>
