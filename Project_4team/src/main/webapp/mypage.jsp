

    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HighwayGuide - 마이페이지</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
              rel="stylesheet">
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
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, .25);
            }

            .edit-mode {
                display: none;
            }

            .edit-active .view-mode {
                display: none;
            }

            .edit-active .edit-mode {
                display: inline-block;
            }

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

            .btn-primary {
                color: #fff;
                background-color: #007bff;
            }

            .btn-primary:hover {
                background-color: #0056b3;
            }

            .btn-secondary {
                color: #fff;
                background-color: #6c757d;
            }

            .btn-secondary:hover {
                background-color: #5a6268;
            }

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
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
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

            .restarea-name {
                font-weight: 600;
                color: #212529;
                margin-right: 0.5rem;
            }

            .restarea-direction {
                font-size: 0.9rem;
                font-weight: 400;
                color: #6c757d;
                padding-left: 0.5rem;
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .star-rating {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .star-rating i {
                font-size: 1.2rem;
            }

            .star-rating .fas {
                color: #ffc107;
            }

            .star-rating .far {
                color: #e9ecef;
            }

            #starText {
                font-size: 1.1rem;
                font-weight: 500;
                color: #333;
            }

            .modal-button-container {
                margin-top: 20px;
                text-align: center;
            }

            .modal-btn {
                background-color: transparent;
                border: 1px solid #c0c0c0;
                color: #666;
                font-weight: bold;
                padding: 8px 16px;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.2s ease-in-out;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .modal-btn:hover {
                background-color: #f0f0f0;
                color: #333;
            }

            .modal-btn i {
                margin-right: 8px;
                font-size: 1.1rem;
                color: #666;
            }

            .modal-btn:hover i {
                color: #333;
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.4);

                justify-content: center;
                align-items: center;
                padding: 2rem; /* 화면 가장자리와의 여백 */
                box-sizing: border-box;
            }
            .modal-content {
                background-color: #ffffff;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.5);
                max-width: 550px;
                width: 100%;

                /* [핵심] 모달의 최대 높이를 화면의 90%로 제한 */
                max-height: 90vh;

                /* [핵심] 내부 요소를 위(header)와 아래(body)로 나누기 위함 */
                display: flex;
                flex-direction: column;
            }
            .modal-header {
                padding: 1.5rem;
                border-bottom: 1px solid #e9ecef;
                /* 헤더는 스크롤되지 않도록 고정 */
                flex-shrink: 0;
            }

            .modal-body {
                /* [핵심] 내용이 길어지면 이 부분만 스크롤됩니다. */
                overflow-y: auto;
                padding: 1.5rem;
            }

            .gas-info-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 1rem;
                width: 100%;
                text-align: center;
            }
            .gas-item {
                display: flex;
                flex-direction: column;
                padding: 0.75rem;
                background-color: #f8f9fa;
                border-radius: 8px;
            }
            .gas-label {
                font-size: 0.9rem;
                color: #6c757d;
                margin-bottom: 0.25rem;
            }
            .gas-value {
                font-size: 1.1rem;
                font-weight: 600;
                color: #007bff;
            }

            #storeList {
                padding: 10px;
                text-align: center;
                line-height: 1.8;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
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
                            <input type="text" name="nickName" class="info-input edit-mode"
                                   value="${sessionScope.loginUser.nickName}" disabled required>
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
                            <input type="text" name="home" class="info-input edit-mode"
                                   value="${sessionScope.loginUser.home}" disabled>
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
                               <span class="bookmark-name">
                               <span class="restarea-name">${serviceArea.SAName}</span>
                               <span class="restarea-direction">${serviceArea.SADirection} 방면</span>
                               </span>
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
    <jsp:include page="/restAreaModal.jsp"/>
    <%-- 푸터 --%>
    <jsp:include page="footer.jsp"/>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>

        let currentRestAreaId = null;

        //  매장 정보를 서버에서 불러와서 화면에 표시하는 함수
        function loadAndRenderStores(saKey, searchText = '') {
            const $storeList = $('#storeList');
            $storeList.empty();
            $storeList.html('<p class="store-empty">매장 정보를 불러오는 중...</p>');

            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/Controller',
                data: {
                    type: 'getStores',
                    saKey: saKey,
                    searchText: searchText
                },
                dataType: 'json',
                success: function (response) {
                    $storeList.empty();
                    if (response && response.length > 0) {
                        response.forEach(store => {
                            const storeNameValue = store.ShopName;
                            // 가장 확실하게 작동했던 b 태그와 br 태그를 사용하는 방식
                            $storeList.append("<b>" + storeNameValue + "</b><br>");
                        });
                    } else {
                        if (searchText) {
                            $storeList.html('<p class="store-empty">검색 결과가 없습니다.</p>');
                        } else {
                            $storeList.html('<p class="store-empty">등록된 매장 정보가 없습니다.</p>');
                        }
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    console.error("매장 정보 로딩 실패:", textStatus, errorThrown, jqXHR);
                    $storeList.html('<p class="store-empty">매장 정보를 불러오는 중 오류가 발생했습니다.</p>');
                }
            });
        }

        $(document).ready(function () {
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

            $('#edit-btn').on('click', function () {
                setEditMode(true);
            });
            $('#cancel-btn').on('click', function () {
                setEditMode(false);
                $('#profile-form')[0].reset();
            });

            $('#profile-form').on('submit', function (e) {
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
                    success: function (data) {
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
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.error("AJAX Error:", textStatus, errorThrown);
                        alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                    }
                });
            });

            $('#withdrawal-btn').on('click', function () {
                if (confirm('정말로 회원 탈퇴를 진행하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                    window.location.href = '${pageContext.request.contextPath}/Controller?type=deleteAccount';
                }
            });

            // 즐겨찾기 삭제
            $('.btn-delete-bookmark').on('click', function (e) {
                e.stopPropagation();
                const itemToRemove = $(this).closest('.bookmark-item');
                if (confirm('이 즐겨찾기를 삭제하시겠습니까?')) {
                    $.ajax({
                        type: 'POST',
                        url: '${pageContext.request.contextPath}/Controller',
                        data: {
                            type: 'bookmarkdelete',
                            saKey: itemToRemove.data('sakey')
                        },
                        dataType: 'json',
                        success: function (response) {
                            if (response.success) {
                                itemToRemove.fadeOut(400, function () {
                                    $(this).remove();
                                    if ($('.bookmark-list .bookmark-item').length === 0) {
                                        $('.bookmark-list').html('<p class="no-bookmarks">즐겨찾기한 휴게소가 없습니다.</p>');
                                    }
                                });
                            } else {
                                alert('삭제에 실패했습니다: ' + (response.message || ''));
                            }
                        },
                        error: function () {
                            alert('삭제 중 오류가 발생했습니다.');
                        }
                    });
                }
            });

            // mypage에서 휴게소 정보 클릭
            $('.bookmark-item.clickable').on('click', function (e) {
                const saKey = $(this).data('sakey');
                currentRestAreaId = saKey;

                $.ajax({
                    type: 'POST',
                    url: '${pageContext.request.contextPath}/Controller',
                    data: {
                        type: 'getRestAreaDetails',
                        saKey: saKey
                    },
                    dataType: 'json',
                    success: function (response) {
                        if (response && response.Idx) {
                            populateAndShowModal(response);
                        } else {
                            alert('휴게소 정보를 찾을 수 없습니다.');
                        }
                    },
                    error: function () {
                        alert('상세 정보를 불러오는 중 오류가 발생했습니다.');
                    }
                });
            });

            // 모달창 채우기
            function populateAndShowModal(data) {
                if (!data) return;
                $('#modalTitle').text(data.SAName || '정보 없음');
                $('#modalLocation').text(data.Address || '정보 없음');
                let formattedPhone = '정보 없음';
                if (data.Tel) {
                    formattedPhone = data.Tel.replace(/(\d{2,3})(\d{3,4})(\d{4})/, '$1-$2-$3');
                }
                $('#modalPhone').text(formattedPhone);
                $('#modalCompactParking').text((data.CompactParking || 0) + '대');
                $('#modalLargeParking').text((data.LargeParking || 0) + '대');
                $('#modalDisabledParking').text((data.DisabledParking || 0) + '대');
                const gasInfo = data.gasInfo;
                if (gasInfo) {
                    $('#modalGasoline').text((gasInfo.Gasoline && gasInfo.Gasoline !== 'X') ? gasInfo.Gasoline : '없음');
                    $('#modalDiesel').text((gasInfo.Disel && gasInfo.Disel !== 'X') ? gasInfo.Disel : '없음');
                    $('#modalLpg').text((gasInfo.LPG && gasInfo.LPG !== 'X') ? gasInfo.LPG : '없음');
                } else {
                    $('#modalGasoline').text('없음');
                    $('#modalDiesel').text('없음');
                    $('#modalLpg').text('없음');
                }
                const facilitiesList = $('#modalFacilities');
                facilitiesList.empty();
                if (data.Convenience) {
                    const facilities = data.Convenience.split(',');
                    facilities.forEach(facility => {
                        if(facility.trim()) {
                            const tag = $('<span>').addClass('facility-tag').text(facility.trim());
                            facilitiesList.append(tag);
                        }
                    });
                } else {
                    facilitiesList.html('<span class="info-value">제공되는 편의시설 정보가 없습니다.</span>');
                }
                const starValue = parseFloat(data.Star);
                const starIconContainer = $('#starIconContainer');
                const starText = $('#starText');
                starIconContainer.empty();
                starText.empty();
                if (isNaN(starValue) || !data.Star) {
                    starText.text('평점 없음');
                } else {
                    const fullStars = Math.floor(starValue);
                    const halfStar = (starValue % 1) >= 0.25 && (starValue % 1) <= 0.75;
                    const emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                    let starsHtml = '';
                    for (let i = 0; i < fullStars; i++) { starsHtml += '<i class="fas fa-star"></i>'; }
                    if (halfStar) { starsHtml += '<i class="fas fa-star-half-alt"></i>'; }
                    for (let i = 0; i < emptyStars; i++) { starsHtml += '<i class="far fa-star"></i>'; }
                    starIconContainer.html(starsHtml);
                    starText.text(starValue.toFixed(1));
                }
                $('#restAreaModal').css('display', 'flex');
            }

            // --- [수정] 새롭고 명확한 모달 닫기 로직 ---

            // 첫 번째 모달(#restAreaModal)의 닫기('X') 버튼 클릭
            $('#restAreaModal .close').on('click', function() {
                $('#restAreaModal').hide();
            });

            // 두 번째 모달(#storesModal)의 닫기('X') 버튼 클릭
            $('#storesModal .close').on('click', function() {
                $('#storesModal').hide();
                $('#restAreaModal').css('display', 'flex'); // 첫 번째 모달 다시 보여주기
            });

            // 배경 클릭하여 닫기
            $('.modal').on('click', function(e) {
                // 클릭된 대상이 배경 자체일 때만 닫기
                if (e.target === this) {
                    if ($(this).is('#storesModal')) {
                        // 두 번째 모달의 배경이면, 첫 번째 모달을 다시 보여줌
                        $(this).hide();
                        $('#restAreaModal').css('display', 'flex');
                    } else {
                        // 첫 번째 모달의 배경이면 그냥 닫기
                        $(this).hide();
                    }
                }
            });

            // 이벤트 전파 방지: 모달 내용(content) 클릭 시 배경 클릭 이벤트가 실행되지 않도록 함
            $('.modal-content').on('click', function(e) {
                e.stopPropagation();
            });

            // --- 여기까지 수정 ---

            // 매장 정보 버튼 클릭
            $('#showStoresBtn').on('click', function () {
                $('#restAreaModal').hide();
                $('#storesModal').css('display', 'flex');
                const restAreaName = $('#modalTitle').text();
                $('#storesModalTitle').text(restAreaName + ' 매장 정보');
                $('#storeSearchInput').val('');
                if (currentRestAreaId) {
                    loadAndRenderStores(currentRestAreaId, '');
                }
            });

            // 매장 검색 기능 구현
            $('#storeSearchBtn').on('click', function() {
                const searchText = $('#storeSearchInput').val();
                if (currentRestAreaId) {
                    loadAndRenderStores(currentRestAreaId, searchText);
                }
            });

            // 검색창에서 Enter 키
            $('#storeSearchInput').on('keypress', function(e) {
                if (e.which === 13) {
                    $('#storeSearchBtn').click();
                }
            });
        });
    </script>
    </body>
    </html>