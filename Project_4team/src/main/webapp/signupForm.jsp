<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 사용자 정보 입력 회원가입 페이지 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 회원가입</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
          rel="stylesheet">
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

        .email-verification-container {
            position: relative;
        }

        .email-input-group {
            display: flex;
            gap: 0.5rem;
            align-items: stretch;
        }

        .email-input-group .form-input {
            flex: 1;
            height: 48px;
        }

        .verify-btn {
            padding: 1rem 1.5rem;
            background: #667eea;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'PretendardVariable', 'Roboto', sans-serif;
            white-space: nowrap;
            height: 48px;
            min-width: 100px;
        }

        .verify-btn:hover {
            background: #5a67d8;
            transform: translateY(-1px);
        }

        .verify-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .verification-code-container {
            display: none;
            margin-top: 1rem;
            padding: 1rem;
            background: #f8fafc;
            border: 1.5px solid #e5e8eb;
            border-radius: 8px;
        }

        .verification-code-container.show {
            display: block;
            animation: fadeIn 0.3s ease-out;
        }

        .verification-input-group {
            display: flex;
            gap: 0.5rem;
            align-items: flex-end;
        }

        .verification-input-group .form-input {
            flex: 1;
        }

        .confirm-btn {
            padding: 1rem 1.5rem;
            background: #03C75A;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'PretendardVariable', 'Roboto', sans-serif;
            white-space: nowrap;
        }

        .confirm-btn:hover {
            background: #02B351;
            transform: translateY(-1px);
        }

        .confirm-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .verification-message {
            margin-top: 0.5rem;
            font-size: 0.8rem;
            color: #666;
        }

        .verification-success {
            color: #03C75A;
        }

        .verification-error {
            color: #e74c3c;
        }

        /* 이메일 오류 메시지 스타일 */
        .email-error-message {
            color: #e74c3c;
            font-size: 0.8rem;
            margin-top: 0.5rem;
            font-family: 'PretendardVariable', 'Roboto', sans-serif;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
<!-- Back to Home Link -->
<a href="index.jsp" class="back-home">
    <i class="fas fa-arrow-left"></i>
    홈으로 돌아가기
</a>

<!-- Register Container -->
<div class="register-container fade-in-up">
    <!-- Header -->
    <div class="register-header">
        <div class="logo-container">
            <div class="logo-icon">
                <i class="fas fa-cube"></i>
            </div>
            <h1>HighWayGuide</h1>
            <div class="star-icon">
                <i class="fas fa-star"></i>
            </div>
        </div>
        <div class="login-link-top">
            이미 계정이 있으신가요? <a href="login.jsp">로그인하기</a>
        </div>
    </div>

    <!-- Register Form -->
    <form class="register-form" id="registerForm">
        <div class="form-group">
            <label for="email" class="form-label">이메일</label>
            <div class="email-verification-container">
                <div class="email-input-group">
                    <input type="email" id="email" name="email" class="form-input" placeholder="이메일을 입력해 주세요" required>
                    <button type="button" class="verify-btn" id="verifyBtn">
                        인증하기
                    </button>
                </div>
                <div class="verification-code-container" id="verificationContainer">
                    <div class="verification-input-group">
                        <input type="text" id="verificationCode" name="verificationCode" class="form-input"
                               placeholder="인증번호 6자리를 입력하세요" maxlength="6">
                        <button type="button" class="confirm-btn" id="confirmBtn">
                            확인
                        </button>
                    </div>
                    <div class="verification-message" id="verificationMessage"></div>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label for="password" class="form-label">비밀번호</label>
            <div class="password-input-container">
                <input type="password" id="password" name="password" class="form-input"
                       placeholder="영문, 숫자, 특수문자가 모두 들어간 8자 이상" required>
                <button type="button" class="password-toggle" id="passwordToggle">
                    <i class="fas fa-eye"></i>
                </button>
            </div>
        </div>

        <div class="form-group">
            <label for="password2" class="form-label">비밀번호 확인</label>
            <div class="password-input-container">
                <input type="password" id="password2" name="password2" class="form-input"
                       placeholder="비밀번호를 한번 더 입력해 주세요" required>
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
    document.addEventListener('DOMContentLoaded', function () {
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

        // 이메일 인증 관련 요소들
        const verifyBtn = document.getElementById('verifyBtn');
        const verificationContainer = document.getElementById('verificationContainer');
        const verificationCode = document.getElementById('verificationCode');
        const confirmBtn = document.getElementById('confirmBtn');
        const verificationMessage = document.getElementById('verificationMessage');

        let isEmailVerified = false;

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
        document.querySelectorAll('.form-group, .terms-container, .register-btn').forEach(element => {
            element.style.opacity = '0';
            element.style.transform = 'translateY(30px)';
            element.style.transition = 'all 0.6s ease-out';
            observer.observe(element);
        });

        // 이메일 인증 버튼 클릭 이벤트
        verifyBtn.addEventListener('click', function () {
            const email = emailInput.value.trim();

            if (!email) {
                showError(emailInput, '이메일을 입력해주세요.');
                return;
            }

            if (!isValidEmail(email)) {
                showError(emailInput, '올바른 이메일 형식을 입력해주세요.');
                return;
            }

            // 인증 버튼 비활성화
            verifyBtn.disabled = true;
            verifyBtn.textContent = '인증번호 발송 중...';

            // 인증번호 입력 컨테이너 표시
            verificationContainer.classList.add('show');
            verificationCode.focus();

            // 시뮬레이션: 2초 후 인증번호 발송 완료
            setTimeout(() => {
                verifyBtn.textContent = '재발송';
                verifyBtn.disabled = false;
                showVerificationMessage('인증번호가 발송되었습니다. 이메일을 확인해주세요.', 'success');
            }, 2000);
        });

        // 인증번호 확인 버튼 클릭 이벤트
        confirmBtn.addEventListener('click', function () {
            const code = verificationCode.value.trim();

            if (!code) {
                showVerificationMessage('인증번호를 입력해주세요.', 'error');
                return;
            }

            if (code.length !== 6) {
                showVerificationMessage('인증번호는 6자리입니다.', 'error');
                return;
            }

            // 확인 버튼 비활성화
            confirmBtn.disabled = true;
            confirmBtn.textContent = '확인 중...';

            // 시뮬레이션: 1초 후 인증 완료
            setTimeout(() => {
                isEmailVerified = true;
                confirmBtn.textContent = '인증완료';
                confirmBtn.style.background = '#03C75A';
                showVerificationMessage('이메일 인증이 완료되었습니다.', 'success');

                // 인증 완료 후 입력 필드 비활성화
                emailInput.disabled = true;
                verificationCode.disabled = true;

                // 재발송 버튼 비활성화
                verifyBtn.disabled = true;
                verifyBtn.textContent = '인증완료';
                verifyBtn.style.background = '#03C75A';
            }, 1000);
        });

        // 인증번호 입력 필드에서 엔터 키 이벤트
        verificationCode.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                confirmBtn.click();
            }
        });

        // 이메일 입력 필드 변경 시 오류 메시지 제거
        emailInput.addEventListener('input', function () {
            const emailContainer = this.closest('.email-verification-container');
            const existingError = emailContainer.querySelector('.error-message');
            if (existingError) {
                existingError.remove();
            }
            this.style.borderColor = '#e5e8eb';
        });

        // 인증번호 입력 필드 변경 시 오류 메시지 제거
        verificationCode.addEventListener('input', function () {
            const existingMessage = verificationMessage.textContent;
            if (existingMessage && !existingMessage.includes('완료')) {
                verificationMessage.textContent = '';
                verificationMessage.className = 'verification-message';
            }
        });

        // 인증 메시지 표시 함수
        function showVerificationMessage(message, type) {
            verificationMessage.textContent = message;
            verificationMessage.className = `verification-message verification-${type}`;

            // 3초 후 메시지 제거
            setTimeout(() => {
                verificationMessage.textContent = '';
                verificationMessage.className = 'verification-message';
            }, 3000);
        }

        registerForm.addEventListener('submit', function (e) {
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
            if (!isEmailVerified) {
                showError(emailInput, '이메일 인증을 완료해주세요.');
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
            const emailRegex = /^[^
            @]+@[^
            @]+\.[^
            @]+$/;
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
            errorDiv.className = 'error-message email-error-message';
            errorDiv.textContent = message;

            // 이메일 입력 필드인 경우 부모 컨테이너에 추가
            if (input.id === 'email') {
                const emailContainer = input.closest('.email-verification-container');
                emailContainer.appendChild(errorDiv);
            } else {
                input.parentNode.appendChild(errorDiv);
            }

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
            successDiv.style.background = '#667eea';
            successDiv.style.color = '#fff';
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

        // 비밀번호 토글 기능
        passwordToggle.addEventListener('click', function () {
            const type = passwordInput.type === 'password' ? 'text' : 'password';
            passwordInput.type = type;
            this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
        });

        password2Toggle.addEventListener('click', function () {
            const type = password2Input.type === 'password' ? 'text' : 'password';
            password2Input.type = type;
            this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
        });

        // 모두 동의하기 기능
        allAgree.addEventListener('change', function () {
            const checkboxes = [ageAgree, serviceAgree, privacyAgree, marketingAgree];
            checkboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });

        // 개별 체크박스 변경 시 모두 동의 상태 업데이트
        [ageAgree, serviceAgree, privacyAgree, marketingAgree].forEach(checkbox => {
            checkbox.addEventListener('change', function () {
                const requiredCheckboxes = [ageAgree, serviceAgree, privacyAgree];
                const allChecked = requiredCheckboxes.every(cb => cb.checked) && marketingAgree.checked;
                allAgree.checked = allChecked;
            });
        });

    });
</script>
</body>
</html>