<%--
  Created by IntelliJ IDEA.
  User: js
  Date: 25. 8. 21.
  Time: 오전 11:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
  <link href="${pageContext.request.contextPath}/css/indexStyle.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/css/footerStyle.css" rel="stylesheet">

    <!-- 비밀번호 찾기 전용 스타일 -->
    <style>
        .forgot-pw-container {
            min-height: calc(100vh - 200px);
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem 1rem;
            margin-top: 80px; /* 헤더 높이만큼 여백 추가 */
            margin-bottom: 80px; /* 푸터 높이만큼 여백 추가 */
        }

        .forgot-pw-content {
            background: white;
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            text-align: center;
        }

        .forgot-pw-header h1 {
            color: #333;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            font-family: 'Roboto', sans-serif;
        }

        .forgot-pw-header p {
            color: #666;
            font-size: 1rem;
            margin-bottom: 2rem;
            line-height: 1.5;
        }

        .forgot-pw-form {
            margin-bottom: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }

        .form-group label {
            display: block;
            color: #333;
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .email-input {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .email-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .email-input::placeholder {
            color: #999;
        }

        .submit-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .submit-btn i {
            font-size: 0.9rem;
        }

        .forgot-pw-footer {
            border-top: 1px solid #f0f0f0;
            padding-top: 1.5rem;
        }

        .back-to-login {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-to-login:hover {
            color: #5a6fd8;
            text-decoration: underline;
        }

        .back-to-login i {
            font-size: 0.8rem;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .forgot-pw-content {
                padding: 2rem 1.5rem;
                margin: 1rem;
            }

            .forgot-pw-header h1 {
                font-size: 1.75rem;
            }

            .forgot-pw-header p {
                font-size: 0.9rem;
            }
        }
    </style>


</head>
<body>
<%@ include file="../../header.jsp" %>

<!-- 비밀번호 찾기 섹션 -->
<div class="forgot-pw-container">
    <div class="forgot-pw-content">
        <div class="forgot-pw-header">
            <h1>비밀번호 찾기</h1>
            <p>가입 시 등록한 이메일 주소를 입력해주세요.</p>
        </div>
        
        <form class="forgot-pw-form" id="forgotPwForm">
            <div class="form-group">
                <label for="email">이메일 주소</label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    placeholder="example@email.com" 
                    required
                    class="email-input"
                >
            </div>
            
            <button type="submit" class="submit-btn">
                <i class="fas fa-paper-plane"></i>
                비밀번호 재설정 이메일 발송
            </button>
        </form>
        
        <div class="forgot-pw-footer">
            <a href="Controller?type=Login" class="back-to-login">
                <i class="fas fa-arrow-left"></i>
                로그인으로 돌아가기
            </a>
        </div>
    </div>
</div>

<!-- 비밀번호 찾기 JavaScript -->
<script>
    // ========================================
    // 비밀번호 찾기 페이지 JavaScript
    // ========================================
    
    // ========================================
    // 1. 페이지 로드 시 초기화 및 이벤트 리스너 설정
    // ========================================
    document.addEventListener('DOMContentLoaded', function() {
        // 비밀번호 찾기 폼 요소 가져오기
        const forgotPwForm = document.getElementById('forgotPwForm');
        
        // 폼 제출 이벤트 리스너 추가
        forgotPwForm.addEventListener('submit', function(e) {
            e.preventDefault(); // 기본 폼 제출 동작 방지 (페이지 새로고침 방지)
            
            // 사용자가 입력한 이메일 주소 가져오기 (앞뒤 공백 제거)
            const email = document.getElementById('email').value.trim();
            
            // ========================================
            // 1-1. 입력값 검증 (빈 값 체크)
            // ========================================
            if (!email) {
                alert('이메일 주소를 입력해주세요.');
                return; // 검증 실패 시 함수 종료
            }
            
            // ========================================
            // 1-2. 이메일 형식 검증 (정규식 사용)
            // ========================================
            // 이메일 형식: local@domain.tld
            // - local: @ 기호 앞부분 (공백, @ 제외)
            // - domain: @ 기호 뒷부분 (공백 제외)
            // - tld: 최상위 도메인 (.com, .kr 등)
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('올바른 이메일 형식을 입력해주세요.');
                return; // 형식 검증 실패 시 함수 종료
            }
            
            // ========================================
            // 1-3. 검증 통과 시 비밀번호 재설정 요청 함수 호출
            // ========================================
            submitForgotPassword(email);
        });
    });
    
    // ========================================
    // 2. 비밀번호 재설정 이메일 발송 요청 함수
    // ========================================
    //
    // 매개변수:
    // - email: 사용자가 입력한 이메일 주소
    //
    // 기능:
    // 1. 로딩 상태 표시 (버튼 비활성화 및 스피너 표시)
    // 2. 서버에 비밀번호 재설정 이메일 발송 요청
    // 3. 응답에 따른 성공/실패 메시지 표시
    // 4. 요청 완료 후 버튼 상태 복원
    //
    function submitForgotPassword(email) {
        // ========================================
        // 2-1. 로딩 상태 표시 (사용자 경험 향상)
        // ========================================
        const submitBtn = document.querySelector('.submit-btn'); // 제출 버튼 요소 가져오기
        const originalText = submitBtn.innerHTML; // 원래 버튼 텍스트 저장 (복원용)
        
        // 버튼을 로딩 상태로 변경
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 처리 중...'; // 스피너 아이콘 + 텍스트
        submitBtn.disabled = true; // 버튼 비활성화 (중복 클릭 방지)
        
        // ========================================
        // 2-2. 서버에 비밀번호 재설정 요청 전송 (AJAX)
        // ========================================
        fetch('Controller', {
            method: 'POST', // POST 방식으로 요청
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded', // 폼 데이터 형식 지정
            },
            body: new URLSearchParams({ // 요청 파라미터 설정
                type: 'forgotPassword', // 요청 타입: 비밀번호 찾기
                email: email             // 사용자 입력 이메일 주소
            })
        })
        // ========================================
        // 2-3. 응답 처리 (Promise 체이닝)
        // ========================================
        .then(response => response.json()) // 응답을 JSON 형태로 파싱
        .then(data => {
            // ========================================
            // 2-3-1. 성공 응답 처리
            // ========================================
            if (data.success) {
                // 이메일 발송 성공 시
                alert('비밀번호 재설정 이메일이 발송되었습니다.\n이메일을 확인해주세요.');
                
                // 폼 초기화 (사용자 편의성)
                document.getElementById('email').value = '';
                
            } else {
                // ========================================
                // 2-3-2. 실패 응답 처리
                // ========================================
                // 서버에서 전달한 오류 메시지가 있으면 표시, 없으면 기본 메시지
                alert('이메일 발송에 실패했습니다: ' + (data.message || '알 수 없는 오류'));
            }
        })
        // ========================================
        // 2-4. 네트워크 오류 처리
        // ========================================
        .catch(error => {
            console.error('비밀번호 찾기 오류:', error); // 개발자 콘솔에 오류 로그 출력
            alert('비밀번호 찾기 중 오류가 발생했습니다. 다시 시도해주세요.'); // 사용자에게 친화적인 오류 메시지
        })
        // ========================================
        // 2-5. 요청 완료 후 정리 작업 (성공/실패 상관없이 실행)
        // ========================================
        .finally(() => {
            // 버튼 상태를 원래대로 복원
            submitBtn.innerHTML = originalText; // 원래 텍스트로 복원
            submitBtn.disabled = false;         // 버튼 다시 활성화
        });
    }
</script>

<%@ include file="../../footer.jsp" %>
</body>
</html>
