<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 마이페이지</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/indexStyle.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/footerStyle.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/restareaStyle.css">


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

        .edit-mode { display: none; }
        .edit-active .view-mode { display: none; }
        .edit-active .edit-mode { display: inline-block; }

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

        .bookmark-section {
            margin-top: 3rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e9ecef;
        }

        .bookmark-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .bookmark-header h2 {
            font-size: 1.8rem;
            font-weight: 600;
            color: #333;
            margin: 0;
        }

        .bookmark-header .fa-star {
            font-size: 1.6rem;
            color: #ffc107;
        }

        .bookmark-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .bookmark-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            background-color: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            transition: box-shadow 0.2s, transform 0.2s;
        }

        .bookmark-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .bookmark-name {
            font-size: 1.1rem;
            font-weight: 500;
            color: #212529;
            margin-right: 1rem;
        }

        .btn-delete-bookmark {
            background-color: transparent;
            border: none;
            color: #aaa;
            font-size: 1.2rem;
            cursor: pointer;
            padding: 0.5rem;
            line-height: 1;
            transition: color 0.2s;
            flex-shrink: 0;
        }

        .btn-delete-bookmark:hover {
            color: #dc3545;
        }

        .no-bookmarks {
            text-align: center;
            color: #6c757d;
            padding: 2rem;
            font-size: 1.1rem;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

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
        .bookmark-item.clickable:hover {
            cursor: pointer;
            background-color: #e9ecef; /* 마우스를 올렸을 때 배경색 변경 */
        }


        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<%-- 헤더 --%>
<jsp:include page="header.jsp"/>


<main>
    <div class="mypage-container">
        <div class="mypage-header">
            <i class="fas fa-user-circle"></i>
            <h1>마이페이지</h1>
        </div>

        <form id="profile-form" action="${pageContext.request.contextPath}/Controller?type=updateProfile" method="post">
            <div class="user-info-card" id="userInfoCard">
                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-user"></i>이름</span>
                        <span class="info-value">${sessionScope.loginUser.name}</span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-envelope"></i>아이디 (이메일)</span>
                        <span class="info-value">${sessionScope.loginUser.ID}</span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-sign-in-alt"></i>가입 경로</span>
                        <span class="info-value">${sessionScope.loginUser.platform}</span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-user-tag"></i>닉네임</span>
                        <span id="viewNickName" class="info-value view-mode">${sessionScope.loginUser.nickName}</span>
                        <input type="text" name="nickName" class="info-input edit-mode" value="${sessionScope.loginUser.nickName}" disabled required>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-leaf"></i>좋아하는 계절</span>
                        <span id="viewFavoriteSeason" class="info-value view-mode">
                            <c:choose>
                                <c:when test="${not empty sessionScope.loginUser.interest}">${sessionScope.loginUser.interest}</c:when>
                                <c:otherwise>선택 안 함</c:otherwise>
                            </c:choose>
                        </span>
                        <select name="favoriteSeason" class="info-select edit-mode" disabled>
                            <option value="봄" ${sessionScope.loginUser.interest == '봄' ? 'selected' : ''}>봄</option>
                            <option value="여름" ${sessionScope.loginUser.interest == '여름' ? 'selected' : ''}>여름</option>
                            <option value="가을" ${sessionScope.loginUser.interest == '가을' ? 'selected' : ''}>가을</option>
                            <option value="겨울" ${sessionScope.loginUser.interest == '겨울' ? 'selected' : ''}>겨울</option>
                        </select>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label"><i class="fas fa-map-marker-alt"></i>집주소</span>
                        <span id="home" class="info-value view-mode">
                            <c:choose>
                                <c:when test="${not empty sessionScope.loginUser.home}">${sessionScope.loginUser.home}</c:when>
                                <c:otherwise>입력 안 함</c:otherwise>
                            </c:choose>
                        </span>
                        <input type="text" name="home" class="info-input edit-mode" value="${sessionScope.loginUser.home}" disabled>
                    </div>
                </div>

            </div>

            <div class="button-group" id="buttonGroup">
                <button type="button" id="edit-btn" class="btn-primary view-mode">정보 수정</button>
                <button type="submit" id="save-btn" class="btn-primary edit-mode">수정 완료</button>
                <button type="button" id="cancel-btn" class="btn-secondary edit-mode">취소</button>
            </div>
        </form>

        <div class="bookmark-section">
            <div class="bookmark-header">
                <i class="fas fa-star"></i>
                <h2>즐겨찾는 휴게소</h2>
            </div>
            <div class="bookmark-list">
                <c:choose>
                    <c:when test="${not empty bookmarkedServiceAreas}">
                        <c:forEach var="serviceArea" items="${bookmarkedServiceAreas}">
                            <div class="bookmark-item clickable" data-sakey="${serviceArea.idx}">
                                <span class="bookmark-name">${serviceArea.SAName} ${serviceArea.SADirection} 방면</span>
                                <button type="button" class="btn-delete-bookmark" title="즐겨찾기 삭제">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="no-bookmarks">즐겨찾기한 휴게소가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="withdrawal-section">
            <button type="button" id="withdrawal-btn" class="btn-danger">회원 탈퇴</button>
        </div>
    </div>
</main>
<jsp:include page="/restAreaModal.jsp" />
<%-- 푸터 --%>
<jsp:include page="footer.jsp"/>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    $(document).ready(function() {
        const $userInfoCard = $('#userInfoCard');
        const $buttonGroup = $('#buttonGroup');
        const $editableFields = $userInfoCard.find('.edit-mode');

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

        $('#edit-btn').on('click', function() { setEditMode(true); });
        $('#cancel-btn').on('click', function() { setEditMode(false); $('#profile-form')[0].reset(); });

        $('#profile-form').on('submit', function(e) {
            e.preventDefault();
            const nickName = $('input[name="nickName"]').val().trim();
            if (nickName === '') {
                alert('닉네임은 비워둘 수 없습니다.');
                $('input[name="nickName"]').focus();
                return;
            }
            const formData = $(this).serialize();

            $.ajax({
                type: 'POST',
                url: $(this).attr('action'),
                data: formData,
                dataType: 'json',
                success: function(data) {
                    if (data.success) {
                        alert(data.message || '성공적으로 수정되었습니다.');
                        const newNickName = $('input[name="nickName"]').val();
                        const newSeason = $('select[name="favoriteSeason"]').val();
                        const newHome = $('input[name="home"]').val();
                        $('#viewNickName').text(newNickName);
                        $('#viewFavoriteSeason').text(newSeason);
                        $('#home').text(newHome || '입력 안 함');
                        setEditMode(false);
                    } else {
                        alert(data.message || '정보 수정에 실패했습니다.');
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error("AJAX Error:", textStatus, errorThrown);
                    alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                }
            });
        });

        $('#withdrawal-btn').on('click', function() {
            if (confirm('정말로 회원 탈퇴를 진행하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                window.location.href = '${pageContext.request.contextPath}/Controller?type=deleteAccount';
            }
        });

        // ==========================================================즐겨찾기 삭제========================================
        $('.btn-delete-bookmark').on('click', function() {
            // 삭제할 대상 div 요소 찾기
            const itemToRemove = $(this).closest('.bookmark-item');
            // 삭제 확인 창
            if (confirm('이 즐겨찾기를 삭제하시겠습니까?')) {

                // AJAX 요청 시작
                $.ajax({
                    type: 'POST',
                    url: '${pageContext.request.contextPath}/Controller',
                    data: {
                        type: 'bookmarkdelete',
                        // div에 추가한 data-sakey 속성에서 휴게소 Idx를 가져옴
                        saKey: itemToRemove.data('sakey')
                    },
                    dataType: 'json', // 서버로부터는 json 형태로 응답을 기대

                    // 서버 요청이 성공했을 때
                    success: function(response) {
                        // 서버가 success:true 응답을 주면
                        if (response.success) {
                            // 화면에서 해당 항목을 사라지게 한 후 완전히 제거
                            itemToRemove.fadeOut(400, function() {
                                $(this).remove();

                                // 만약 즐겨찾기 항목이 하나도 남지 않았다면
                                if ($('.bookmark-list .bookmark-item').length === 0) {
                                    $('.bookmark-list').html('<p class="no-bookmarks">즐겨찾기한 휴게소가 없습니다.</p>');
                                }
                            });
                        } else {
                            // 서버가 success:false 응답을 주면
                            alert('삭제에 실패했습니다.');
                        }
                    },
                    // 서버 요청이 실패했을 때
                    error: function() {
                        alert('삭제 중 오류가 발생했습니다. 다시 시도해주세요.');
                    }
                });
            }
        });
        // ==========================================================
        // mypage에서 휴게소 정보 클릭하면 나오게끔=============================================================================

        $('.bookmark-item.clickable').on('click', function(e) {
            // 만약 클릭된 부분이 X 버튼이라면, 모달을 열지 않고 함수를 종료합니다.
            if ($(e.target).closest('.btn-delete-bookmark').length > 0) {
                return;
            }

            const saKey = $(this).data('sakey');

            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/Controller',
                data: {
                    type: 'getRestAreaDetails',
                    saKey: saKey
                },
                dataType: 'json',
                success: function(response) {
                    // [수정됨] 성공/실패 구분 방법
                    // 성공 응답(vo)은 'idx' 같은 속성을 가지고 있고,
                    // 실패 응답({})은 속성이 없는 점을 이용해 구분합니다.
                    if (response && response.Idx) {
                        // response 객체가 비어있지 않고 idx 속성을 가지고 있으면 성공으로 간주
                        populateAndShowModal(response);
                    } else {
                        // response 객체가 비어있으면 실패로 간주
                        alert('휴게소 정보를 찾을 수 없습니다.');
                    }
                },
                error: function() {
                    alert('상세 정보를 불러오는 중 오류가 발생했습니다.');
                }
            });
        });

        // 서버에서 받은 데이터로 모달 창의 내용을 채우고 화면에 표시하는 함수
        function populateAndShowModal(data) {
            // 이제 data가 바로 ServiceAreaVO 객체이므로 .data를 붙이지 않습니다.
            $('#modalTitle').text(data.SAName || '정보 없음');
            $('#modalLocation').text(data.Address || '정보 없음');
            $('#modalPhone').text(data.Tel || '정보 없음');

            $('#restAreaModal').show();
        }

        // 모달의 'X' 버튼이나 바깥 영역을 클릭했을 때 모달을 닫는 함수
        function closeModal() {
            $('.modal').hide();
        }

        /* ===== [추가된 코드 시작] ===== */
        // 모달의 닫기(X) 버튼 클릭 시 이벤트 처리
        $('.modal .close').on('click', function() {
            closeModal();
        });

        // 모달 창 바깥의 어두운 영역을 클릭했을 때도 모달이 닫히도록 합니다.
        $(window).on('click', function(e) {
            if ($(e.target).hasClass('modal')) {
                closeModal();
            }
        });

    });
</script>
</body>
</html>