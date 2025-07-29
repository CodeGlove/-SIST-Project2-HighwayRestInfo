<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 로그인</title>
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
    <!-- Back to Home Link -->
    <a href="mainpage.jsp" class="back-home">
        <i class="fas fa-arrow-left"></i>
        홈으로 돌아가기
    </a>

    <!-- Login Container -->
    <div class="login-container fade-in-up">
        <!-- Header -->
        <div class="login-header">
            <div class="logo-container">
                <div class="logo-icon">
                    <i class="fas fa-road"></i>
                </div>
                <h1>HighwayGuide</h1>
            </div>
            <h2 class="login-title">로그인</h2>
            <p class="login-subtitle">고속도로 정보 서비스를 이용하려면 로그인하세요</p>
        </div>

        <!-- Login Form -->
        <form class="login-form" id="loginForm">
            <div class="form-group">
                <label for="email" class="form-label">이메일</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="이메일을 입력하세요" required>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" id="password" name="password" class="form-input" placeholder="비밀번호를 입력하세요" required>
            </div>

            <div class="remember-forgot">
                <label class="remember-me">
                    <input type="checkbox" name="remember" id="remember">
                    <span>로그인 상태 유지</span>
                </label>
                <a href="#" class="forgot-link">비밀번호 찾기</a>
            </div>

            <button type="submit" class="login-btn">
                <i class="fas fa-sign-in-alt"></i>
                로그인
            </button>
        </form>

        <!-- Divider -->
        <div class="divider">
            <span>또는</span>
        </div>

        <!-- Social Login -->
        <div class="social-login">
            <a href="#" class="social-btn" id="googleLogin">
                <i class="fab fa-google"></i>
                Google
            </a>
            <a href="#" class="social-btn" id="kakaoLogin">
                <i class="fas fa-comment"></i>
                Kakao
            </a>
        </div>

        <!-- Sign Up Link -->
        <div class="signup-link">
            계정이 없으신가요? <a href="Controller?type=register" id="signupLink">회원가입</a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const loginForm = document.getElementById('loginForm');
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const googleLogin = document.getElementById('googleLogin');
            const kakaoLogin = document.getElementById('kakaoLogin');
            const signupLink = document.getElementById('signupLink');

            // Form validation and submission
            loginForm.addEventListener('submit', function(e) {
                e.preventDefault();
                
                const email = emailInput.value.trim();
                const password = passwordInput.value.trim();
                
                // Basic validation
                if (!email) {
                    showError(emailInput, '이메일을 입력해주세요.');
                    return;
                }
                
                if (!isValidEmail(email)) {
                    showError(emailInput, '올바른 이메일 형식을 입력해주세요.');
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
                
                // Success - simulate login
                showSuccess('로그인 중입니다...');
                setTimeout(() => {
                    alert('로그인이 완료되었습니다!');
                    window.location.href = 'mainpage.jsp';
                }, 1500);
            });

            // Email validation
            function isValidEmail(email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }

            // Show error message
            function showError(input, message) {
                // Remove existing error
                const existingError = input.parentNode.querySelector('.error-message');
                if (existingError) {
                    existingError.remove();
                }
                
                // Add error message
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.style.color = '#e74c3c';
                errorDiv.style.fontSize = '0.8rem';
                errorDiv.style.marginTop = '0.5rem';
                errorDiv.textContent = message;
                
                input.parentNode.appendChild(errorDiv);
                input.style.borderColor = '#e74c3c';
                
                // Remove error after 3 seconds
                setTimeout(() => {
                    if (errorDiv.parentNode) {
                        errorDiv.remove();
                        input.style.borderColor = '#bdc3c7';
                    }
                }, 3000);
            }

            // Show success message
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
                
                setTimeout(() => {
                    successDiv.remove();
                }, 2000);
            }

            // Social login handlers
            googleLogin.addEventListener('click', function(e) {
                e.preventDefault();
                alert('Google 로그인 기능이 구현될 예정입니다.');
            });

            kakaoLogin.addEventListener('click', function(e) {
                e.preventDefault();
                alert('Kakao 로그인 기능이 구현될 예정입니다.');
            });




            // Remember me checkbox
            const rememberCheckbox = document.getElementById('remember');
            rememberCheckbox.addEventListener('change', function() {
                if (this.checked) {
                    console.log('로그인 상태 유지가 활성화되었습니다.');
                }
            });
        });
    </script>
</body>
</html>
