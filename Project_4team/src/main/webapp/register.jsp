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
    <a href="mainpage.jsp" class="back-home">
        <i class="fas fa-arrow-left"></i>
        홈으로 돌아가기
    </a>
    <div class="register-container fade-in-up">
        <!-- Header -->
        <div class="register-header">
            <div class="logo">highwayguide</div>
            <h1 class="heading">회원가입하고<br>비즈니스 성공을 시작해 보세요!</h1>
            <div class="login-link-top">
                이미 계정이 있으신가요? <a href="login.jsp">로그인하기</a>
            </div>
        </div>

        <!-- Form -->
        <form class="register-form" id="registerForm">
            <div class="form-group">
                <label for="email" class="form-label">이메일</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="이메일을 입력해 주세요" required>
            </div>
            
            <div class="form-group">
                <label for="password" class="form-label">비밀번호</label>
                <div class="password-input-container">
                    <input type="password" id="password" name="password" class="form-input" placeholder="영문, 숫자, 특수문자가 모두 들어간 8자 이상" required>
                    <button type="button" class="password-toggle" id="passwordToggle">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>
            
            <div class="form-group">
                <label for="password2" class="form-label">비밀번호 확인</label>
                <div class="password-input-container">
                    <input type="password" id="password2" name="password2" class="form-input" placeholder="비밀번호를 한번 더 입력해 주세요" required>
                    <button type="button" class="password-toggle" id="password2Toggle">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>

            <!-- Terms Agreement -->
            <div class="terms-container">
                <div class="terms-header">
                    <label class="checkbox-container">
                        <input type="checkbox" id="allAgree" class="checkbox-input">
                        <span class="checkmark"></span>
                        모두 동의합니다.
                    </label>
                </div>
                <div class="terms-list">
                    <label class="checkbox-container">
                        <input type="checkbox" id="ageAgree" class="checkbox-input" required>
                        <span class="checkmark"></span>
                        만 14세 이상입니다.
                    </label>
                    <label class="checkbox-container">
                        <input type="checkbox" id="serviceAgree" class="checkbox-input" required>
                        <span class="checkmark"></span>
                        서비스 이용약관에 동의합니다.
                    </label>
                    <label class="checkbox-container">
                        <input type="checkbox" id="privacyAgree" class="checkbox-input" required>
                        <span class="checkmark"></span>
                        개인정보 수집 이용에 동의합니다.
                    </label>
                    <label class="checkbox-container">
                        <input type="checkbox" id="marketingAgree" class="checkbox-input">
                        <span class="checkmark"></span>
                        마케팅 수신 홍보목적의 개인정보 수집 및 이용에 동의합니다.(선택)
                    </label>
                </div>
            </div>

            <button type="submit" class="register-btn">
                가입완료
            </button>
        </form>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const registerForm = document.getElementById('registerForm');
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const password2Input = document.getElementById('password2');
            const passwordToggle = document.getElementById('passwordToggle');
            const password2Toggle = document.getElementById('password2Toggle');
            const allAgree = document.getElementById('allAgree');
            const ageAgree = document.getElementById('ageAgree');
            const serviceAgree = document.getElementById('serviceAgree');
            const privacyAgree = document.getElementById('privacyAgree');
            const marketingAgree = document.getElementById('marketingAgree');

            registerForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const email = emailInput.value.trim();
                const password = passwordInput.value.trim();
                const password2 = password2Input.value.trim();
                
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
                if (password.length < 8) {
                    showError(passwordInput, '비밀번호는 8자 이상이어야 합니다.');
                    return;
                }
                if (!isValidPassword(password)) {
                    showError(passwordInput, '영문, 숫자, 특수문자가 모두 포함되어야 합니다.');
                    return;
                }
                if (password !== password2) {
                    showError(password2Input, '비밀번호가 일치하지 않습니다.');
                    return;
                }
                if (!ageAgree.checked || !serviceAgree.checked || !privacyAgree.checked) {
                    alert('필수 약관에 동의해주세요.');
                    return;
                }
                showSuccess('회원가입 중입니다...');
                setTimeout(() => {
                    alert('회원가입이 완료되었습니다!');
                    window.location.href = 'Controller?type=login';
                }, 1500);
            });
            function isValidEmail(email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }

            function isValidPassword(password) {
                const hasLetter = /[a-zA-Z]/.test(password);
                const hasNumber = /\d/.test(password);
                const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
                return hasLetter && hasNumber && hasSpecial;
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
            // 비밀번호 토글 기능
            passwordToggle.addEventListener('click', function() {
                const type = passwordInput.type === 'password' ? 'text' : 'password';
                passwordInput.type = type;
                this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
            });

            password2Toggle.addEventListener('click', function() {
                const type = password2Input.type === 'password' ? 'text' : 'password';
                password2Input.type = type;
                this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
            });

            // 모두 동의하기 기능
            allAgree.addEventListener('change', function() {
                const checkboxes = [ageAgree, serviceAgree, privacyAgree, marketingAgree];
                checkboxes.forEach(checkbox => {
                    checkbox.checked = this.checked;
                });
            });

            // 개별 체크박스 변경 시 모두 동의 상태 업데이트
            [ageAgree, serviceAgree, privacyAgree, marketingAgree].forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const requiredCheckboxes = [ageAgree, serviceAgree, privacyAgree];
                    const allChecked = requiredCheckboxes.every(cb => cb.checked) && marketingAgree.checked;
                    allAgree.checked = allChecked;
                });
            });

        });
    </script>
</body>
</html>
