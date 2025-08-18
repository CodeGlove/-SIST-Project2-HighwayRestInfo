<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 마이페이지</title>
    <%-- 메인 페이지와 동일한 UI를 위해 폰트, 아이콘, CSS 파일을 그대로 가져옵니다. --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="css/indexStyle.css" rel="stylesheet">
    <link href="css/footerStyle.css" rel="stylesheet">


    <%-- 마이페이지 전용 스타일 추가 --%>
    <style>
        .mypage-container {
            max-width: 800px;
            margin: 4rem auto;
            padding: 2rem;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.8s ease-out;
        }

        .mypage-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid #e9ecef;
        }

        .mypage-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin: 0;
        }

        .mypage-header .fa-user-circle {
            font-size: 2.8rem;
            color: #007bff;
        }

        .user-info-card {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            background-color: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            min-height: 60px;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            width: 100%;
        }

        .info-label {
            font-weight: 600;
            color: #555;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            width: 150px;
            flex-shrink: 0;
        }

        .info-label i {
            color: #888;
        }

        .info-value {
            font-size: 1.1rem;
            color: #212529;
            font-weight: 500;
        }

        /* 수정 모드를 위한 입력 필드 스타일 */
        .info-input, .info-select {
            font-size: 1rem;
            padding: 0.5rem 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 4px;
            width: 200px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .info-input:focus, .info-select:focus {
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }

        /* 수정/보기 모드 전환을 위한 스타일 */
        .edit-mode { display: none; } /* 수정 모드 요소는 기본적으로 숨김 */

        .edit-active .view-mode { display: none; } /* 수정 활성화 시 보기 모드 요소 숨김 */
        .edit-active .edit-mode { display: inline-block; } /* 수정 활성화 시 수정 모드 요소 보임 */


        /* 버튼 그룹 스타일 */
        .button-group {
            margin-top: 2.5rem;
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
        }

        .btn-primary, .btn-secondary {
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-primary { color: #fff; background-color: #007bff; }
        .btn-primary:hover { background-color: #0056b3; }
        .btn-secondary { color: #fff; background-color: #6c757d; }
        .btn-secondary:hover { background-color: #5a6268; }

        /* 회원 탈퇴 섹션 스타일 */
        .withdrawal-section {
            margin-top: 3rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e9ecef;
            text-align: right;
        }
        .btn-danger {
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            color: #dc3545;
            background-color: transparent;
            border: 1px solid #dc3545;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-danger:hover {
            color: #fff;
            background-color: #dc3545;
        }


        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<%-- 메인 페이지와 동일한 헤더를 포함합니다. --%>
<header class="header">
    <div class="nav-container">
        <a href="Controller" class="logo">
            <div class="logo-icon">
                <i class="fas fa-road"></i>
            </div>
            HighwayGuide
        </a>
        <nav>
            <ul class="nav-links">
                <li><a href="#">회사 소개</a></li>
                <li><a href="Controller?type=notice" class="btn btn-notice">공지사항</a></li>
                <li><a href="#">고객센터</a></li>
                <li><a href="#">자주 묻는 질문</a></li>
                <li><a href="#">채용</a></li>
            </ul>
        </nav>
        <div class="auth-buttons">
            <a href="#" class="btn btn-login">KOR</a>
            <a href="#" class="btn btn-login">ENG</a>
            <c:if test="${empty sessionScope.loginUser}">
                <a href="Controller?type=login" class="btn btn-login">로그인</a>
                <a href="Controller?type=register" class="btn btn-register">회원가입</a>
            </c:if>
            <c:if test="${not empty sessionScope.loginUser}">
                <a href="Controller?type=logout" class="btn btn-logout">로그아웃</a>
                <a href="Controller?type=mypage" class="btn btn-register">마이페이지</a>
            </c:if>
        </div>
    </div>
</header>


<main>
    <div class="mypage-container">
        <div class="mypage-header">
            <i class="fas fa-user-circle"></i>
            <h1>마이페이지</h1>
        </div>

        <%-- 수정 정보를 서버로 보내기 위한 form 태그 --%>
        <form id="profile-form" action="Controller?type=updateProfile" method="post">
            <div class="user-info-card" id="userInfoCard">
                <%-- 이름 정보 (수정 불가) --%>
                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-user"></i>이름</span>
                        <span class="info-value">${user.name}</span>
                    </div>
                </div>

                <%-- 아이디(이메일) 정보 (수정 불가) --%>
                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-envelope"></i>아이디 (이메일)</span>
                        <span class="info-value">${user.ID}</span>
                    </div>
                </div>

                <%-- [추가됨] 가입 플랫폼 정보 (수정 불가) --%>
                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-sign-in-alt"></i>가입 경로</span>
                        <span class="info-value">${user.platform}</span>
                    </div>
                </div>

                <%-- 닉네임 정보 (수정 가능) --%>
                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-user-tag"></i>닉네임</span>
                        <%-- 보기 모드 --%>
                        <span id =viewNickName class="info-value view-mode">${user.nickName}</span>
                        <%-- 수정 모드 --%>
                        <input type="text" name="nickName" class="info-input edit-mode" value="${user.nickName}" disabled required>
                    </div>
                </div>

                <%-- 좋아하는 계절 정보 (수정 가능) --%>
                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-leaf"></i>좋아하는 계절</span>
                        <%-- 보기 모드 --%>
                        <span id="favoriteSeason" class="info-value view-mode">
                            <c:choose>
                                <c:when test="${not empty user.interest}">${user.interest}</c:when>
                                <c:otherwise>선택 안 함</c:otherwise>
                            </c:choose>
                        </span>
                        <%-- 수정 모드 --%>
                        <select name="favoriteSeason" class="info-select edit-mode" disabled>
                            <option value="봄" ${user.interest == '봄' ? 'selected' : ''}>봄</option>
                            <option value="여름" ${user.interest == '여름' ? 'selected' : ''}>여름</option>
                            <option value="가을" ${user.interest == '가을' ? 'selected' : ''}>가을</option>
                            <option value="겨울" ${user.interest == '겨울' ? 'selected' : ''}>겨울</option>
                        </select>
                    </div>
                </div>
            </div>

            <%-- 수정/저장/취소 버튼 그룹 --%>
            <div class="button-group" id="buttonGroup">
                <button type="button" id="edit-btn" class="btn-primary view-mode">정보 수정</button>
                <button type="submit" id="save-btn" class="btn-primary edit-mode">수정 완료</button>
                <button type="button" id="cancel-btn" class="btn-secondary edit-mode">취소</button>
            </div>
        </form>

        <%-- 회원 탈퇴 섹션 --%>
        <div class="withdrawal-section">
            <button type="button" id="withdrawal-btn" class="btn-danger">회원 탈퇴</button>
        </div>
    </div>
</main>


<%-- 메인 페이지와 동일한 푸터를 포함합니다. --%>
<jsp:include page="footer.jsp"/>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    $(document).ready(function() {
    // DOM 요소 가져오기 (jQuery 방식)
    const $userInfoCard = $('#userInfoCard');
    const $buttonGroup = $('#buttonGroup');
    const $editableFields = $userInfoCard.find('.edit-mode');

    // 보기/수정 모드 전환 함수
    function setEditMode(isEdit) {
    if (isEdit) {
    $userInfoCard.addClass('edit-active');
    $buttonGroup.addClass('edit-active');
    $editableFields.prop('disabled', false);
} else {
    $userInfoCard.removeClass('edit-active');
    $buttonGroup.removeClass('edit-active');
    $editableFields.prop('disabled', true);
}
}

    // '정보 수정' 버튼 클릭 이벤트
    $('#edit-btn').on('click', function() {
    setEditMode(true); // 수정 모드로 전환
});

    // '취소' 버튼 클릭 이벤트
    $('#cancel-btn').on('click', function() {
    setEditMode(false); // 보기 모드로 전환
    $('#profile-form')[0].reset(); // 폼 리셋
});

    // '수정 완료'를 위한 form의 'submit' 이벤트 처리 (jQuery AJAX)
    $('#profile-form').on('submit', function(e) {
    // 1. 기본 폼 전송(새로고침) 방지
    e.preventDefault();

    // 2. 유효성 검사
    const nickName = $('input[name="nickName"]').val().trim();
    if (nickName === '') {
    alert('닉네임은 비워둘 수 없습니다.');
    $('input[name="nickName"]').focus();
    return;
}

    // 3. 폼 데이터 직렬화 (URL 인코딩된 문자열로 변환)
    const formData = $(this).serialize();

    // 4. jQuery AJAX 요청
    $.ajax({
    type: 'POST',                 // 전송 방식
    url: $(this).attr('action'),  // form의 action 속성 값 (Controller?type=updateProfile)
    data: formData,               // 서버로 보낼 데이터
    dataType: 'json',             // 서버로부터 JSON 타입의 응답을 받을 것임을 명시

    // 5. 성공 시 실행될 함수
    success: function(data) {
    if (data.success) {
    alert(data.message || '성공적으로 수정되었습니다.');

    // 화면의 텍스트를 새로운 값으로 직접 업데이트
    const newNickName = $('input[name="nickName"]').val();
    const newSeason = $('select[name="favoriteSeason"]').val();

    $('#viewNickName').text(newNickName);
    $('#viewFavoriteSeason').text(newSeason);

    // 보기 모드로 전환
    setEditMode(false);
} else {
    // 서버가 {success: false} 응답을 보냈을 경우
    alert(data.message || '정보 수정에 실패했습니다.');
}
},

    // 6. 실패 시 실행될 함수
    error: function(jqXHR, textStatus, errorThrown) {
    console.error("AJAX Error:", textStatus, errorThrown);
    alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
}
});
});

    // '회원 탈퇴' 버튼 클릭 이벤트
    $('#withdrawal-btn').on('click', function() {
    if (confirm('정말로 회원 탈퇴를 진행하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
    window.location.href = 'Controller?type=deleteAccount';
}
});
});
</script>
</body>
</html>







