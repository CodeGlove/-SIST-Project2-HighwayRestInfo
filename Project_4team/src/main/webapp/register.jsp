<%--
  Created by IntelliJ IDEA.
  User: tak
  Date: 25. 7. 28.
  Time: 오후 3:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 회원가입</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="css/RegisterStyle.css" rel="stylesheet">
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
    <a href="MainPage.jsp" class="back-home">
        <i class="fas fa-arrow-left"></i>
        홈으로 돌아가기
    </a>
    <div class="register-container fade-in-up">
        <div class="register-header">
            <div class="logo-container">
                <div class="logo-icon"><i class="fas fa-road"></i></div>
                <h1>HighwayGuide</h1>
            </div>
            <h2 class="register-title">회원가입</h2>
            <p class="register-subtitle">고속도로 정보 서비스를 이용하려면 회원가입하세요</p>
        </div>
        <form class="register-form" id="registerForm">
            <div class="form-group">
                <label for="name" class="form-label">이름</label>
                <input type="text" id="name" name="name" class="form-input" placeholder="이름을 입력하세요" required>
                <i class="fas fa-user input-icon"></i>
            </div>
            <div class="form-group">
                <label for="email" class="form-label">이메일</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="이메일을 입력하세요" required>
                <i class="fas fa-envelope input-icon"></i>
            </div>
            <div class="form-group">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" id="password" name="password" class="form-input" placeholder="비밀번호를 입력하세요" required>
                <i class="fas fa-lock input-icon"></i>
            </div>
            <div class="form-group">
                <label for="password2" class="form-label">비밀번호 확인</label>
                <input type="password" id="password2" name="password2" class="form-input" placeholder="비밀번호를 다시 입력하세요" required>
                <i class="fas fa-lock input-icon"></i>
            </div>
            <button type="submit" class="register-btn">
                <i class="fas fa-user-plus"></i>
                회원가입
            </button>
        </form>
        <div class="divider"><span>또는</span></div>
        <div class="social-login">
            <a href="#" class="social-btn" id="googleRegister">
                <i class="fab fa-google"></i>
                Google
            </a>
            <a href="#" class="social-btn" id="kakaoRegister">
                <i class="fas fa-comment"></i>
                Kakao
            </a>
        </div>
        <div class="login-link">
            이미 계정이 있으신가요? <a href="Login.jsp">로그인</a>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const registerForm = document.getElementById('registerForm');
            const nameInput = document.getElementById('name');
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const password2Input = document.getElementById('password2');
            const googleRegister = document.getElementById('googleRegister');
            const kakaoRegister = document.getElementById('kakaoRegister');

            registerForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const name = nameInput.value.trim();
                const email = emailInput.value.trim();
                const password = passwordInput.value.trim();
                const password2 = password2Input.value.trim();
                if (!name) {
                    showError(nameInput, '이름을 입력해주세요.');
                    return;
                }
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
                if (password !== password2) {
                    showError(password2Input, '비밀번호가 일치하지 않습니다.');
                    return;
                }
                showSuccess('회원가입 중입니다...');
                setTimeout(() => {
                    alert('회원가입이 완료되었습니다!');
                    window.location.href = 'Login.jsp';
                }, 1500);
            });
            function isValidEmail(email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }
            function showError(input, message) {
                const existingError = input.parentNode.querySelector('.error-message');
                if (existingError) existingError.remove();
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.style.color = '#e74c3c';
                errorDiv.style.fontSize = '0.8rem';
                errorDiv.style.marginTop = '0.5rem';
                errorDiv.textContent = message;
                input.parentNode.appendChild(errorDiv);
                input.style.borderColor = '#e74c3c';
                setTimeout(() => {
                    if (errorDiv.parentNode) {
                        errorDiv.remove();
                        input.style.borderColor = '#e5e8eb';
                    }
                }, 3000);
            }
            function showSuccess(message) {
                const successDiv = document.createElement('div');
                successDiv.style.position = 'fixed';
                successDiv.style.top = '20px';
                successDiv.style.right = '20px';
                successDiv.style.background = '#3182f6';
                successDiv.style.color = '#fff';
                successDiv.style.padding = '1rem 2rem';
                successDiv.style.borderRadius = '8px';
                successDiv.style.zIndex = '1000';
                successDiv.style.fontWeight = '600';
                successDiv.textContent = message;
                document.body.appendChild(successDiv);
                setTimeout(() => { successDiv.remove(); }, 2000);
            }
            googleRegister.addEventListener('click', function(e) {
                e.preventDefault();
                alert('Google 회원가입 기능이 구현될 예정입니다.');
            });
            kakaoRegister.addEventListener('click', function(e) {
                e.preventDefault();
                alert('Kakao 회원가입 기능이 구현될 예정입니다.');
            });
            // Input focus effects
            const inputs = document.querySelectorAll('.form-input');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentNode.querySelector('.input-icon').style.color = '#3182f6';
                });
                input.addEventListener('blur', function() {
                    if (!this.value) {
                        this.parentNode.querySelector('.input-icon').style.color = '#b0b8c1';
                    }
                });
            });
        });
    </script>
</body>
</html>
