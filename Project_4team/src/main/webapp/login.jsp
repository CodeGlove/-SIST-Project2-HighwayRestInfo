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
            <div class="language-selector">
                <i class="fas fa-globe"></i>
            </div>
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

        <!-- Authentication Tabs -->
        <div class="auth-tabs">
            <button class="tab-btn active" data-tab="password">Password</button>
            <button class="tab-btn" data-tab="webauthn">WebAuthn</button>
        </div>

        <!-- Login Form -->
        <form class="login-form" id="loginForm">
            <div class="form-group">
                <div class="input-container">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" id="username" name="username" class="form-input" placeholder="username, Email or phone" required>
                </div>
            </div>

            <div class="form-group">
                <div class="input-container">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Password" required>
                    <button type="button" class="password-toggle" id="passwordToggle">
                        <i class="fas fa-eye-slash"></i>
                    </button>
                </div>
            </div>

            <div class="login-options">
                <label class="auto-signin">
                    <input type="checkbox" name="autoSignin" id="autoSignin">
                    <span class="checkmark"></span>
                    Auto sign in
                </label>
                <a href="#" class="forgot-link">Forgot password?</a>
            </div>

            <button type="submit" class="login-btn">
                Sign In
            </button>
        </form>

        <!-- Sign Up Link -->
        <div class="signup-link">
            No account? <a href="Controller?type=register" id="signupLink">sign up now</a>
        </div>

        <!-- Social Login -->
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
        document.addEventListener('DOMContentLoaded', function() {
            const loginForm = document.getElementById('loginForm');
            const usernameInput = document.getElementById('username');
            const passwordInput = document.getElementById('password');
            const passwordToggle = document.getElementById('passwordToggle');
            const autoSignin = document.getElementById('autoSignin');
            const googleLogin = document.getElementById('googleLogin');
            const githubLogin = document.getElementById('githubLogin');
            const signupLink = document.getElementById('signupLink');
            const tabBtns = document.querySelectorAll('.tab-btn');

            // Tab switching
            tabBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    tabBtns.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Password toggle
            passwordToggle.addEventListener('click', function() {
                const type = passwordInput.type === 'password' ? 'text' : 'password';
                passwordInput.type = type;
                this.innerHTML = type === 'password' ? '<i class="fas fa-eye-slash"></i>' : '<i class="fas fa-eye"></i>';
            });

            // Form validation and submission
            loginForm.addEventListener('submit', function(e) {
                e.preventDefault();
                
                const username = usernameInput.value.trim();
                const password = passwordInput.value.trim();
                
                // Basic validation
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

            githubLogin.addEventListener('click', function(e) {
                e.preventDefault();
                alert('GitHub 로그인 기능이 구현될 예정입니다.');
            });




            // Auto sign in checkbox
            autoSignin.addEventListener('change', function() {
                if (this.checked) {
                    console.log('자동 로그인이 활성화되었습니다.');
                }
            });
        });
    </script>
</body>
</html>
