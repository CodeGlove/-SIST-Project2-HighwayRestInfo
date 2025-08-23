<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>휴게소 정보</title>

    <!-- 폰트 및 아이콘 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- video.js 라이브러리 추가 -->
    <link href="https://vjs.zencdn.net/8.6.1/video-js.css" rel="stylesheet" />
    <script src="https://vjs.zencdn.net/8.6.1/video.min.js"></script>
    <!-- HLS 재생을 위한 video.js 플러그인 추가 -->
    <script src="https://unpkg.com/@videojs/http-streaming@3.5.0/dist/videojs-http-streaming.min.js"></script>

    <!-- CSS 파일 링크 -->
    <link href="${pageContext.request.contextPath}/css/restareaStyle.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/indexStyle.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/footerStyle.css" rel="stylesheet">

    <style>
        /* 모달 창을 위한 CSS */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0,0,0);
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            /* 모달 가로 크기를 30% 더 확장 */
            max-width: 1170px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        .cctv-grid {
            /* 가로 4열 레이아웃, 자동 채움 및 반응형 */
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        @media (min-width: 1170px) {
            .cctv-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }
        .video-container {
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            background-color: #000;
            position: relative;
            /* 영상 높이 30% 감소 */
            height: 300px;
        }
        .video-container video, .video-container .video-error {
            width: 100%;
            height: 100%;
            object-fit: cover; /* 컨테이너에 맞게 영상 채우기 */
        }
        .video-container span {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            background: rgba(0, 0, 0, 0.5);
            color: white;
            padding: 5px;
            text-align: center;
            font-size: 0.8em;
            word-break: break-all;
        }
        .video-error {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            background-color: #333;
            text-align: center;
        }
        .no-rest-areas {
            text-align: center;
            margin-top: 50px;
            color: #666;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>
<main>
    <div class="rest-area-container">
        <!-- 상단 헤더 섹션: 출발지와 도착지, 총 거리 및 예상 시간을 표시합니다. -->
        <div class="header-section">
            <div class="route-info">
                <h1>${origin} <i class="fas fa-arrow-right"></i> ${destination}</h1>
                <p>총 거리: <fmt:formatNumber value="${distance / 1000}" pattern="#,###.0" /> km</p>
                <p>총 예상 시간: <i class="fas fa-clock"></i>
                    <c:set var="totalHours" value="${duration / 3600}" />
                    <c:set var="totalMinutes" value="${(duration % 3600) / 60}" />
                    <c:if test="${totalHours >= 1}">
                        <fmt:formatNumber value="${totalHours}" pattern="0" />시간
                    </c:if>
                    <fmt:formatNumber value="${totalMinutes}" pattern="0" />분
                </p>
            </div>
            <div class="fare-info">
                <p>통행료: <fmt:formatNumber value="${tollFare}" pattern="#,###" />원</p>
                <p>택시비: <fmt:formatNumber value="${taxiFare}" pattern="#,###" />원</p>
            </div>
        </div>

        <!-- 휴게소 카드 섹션 -->
        <div class="rest-area-list">
            <c:choose>
                <c:when test="${empty serviceAreaVOs}">
                    <p class="no-rest-areas">현재 경로에 휴게소 정보가 없습니다.</p>
                </c:when>
                <c:otherwise>
                    <!-- 맵을 루프 돌릴 때는 key와 value를 사용해야 합니다.
                    restArea는 Map.Entry 객체이며, value에 ServiceAreaVO 객체가 들어있습니다. -->
                    <c:forEach var="restArea" items="${serviceAreaVOs}" varStatus="loop">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="facility-name">${restArea.value.SAName}</h3>
                                <div class="card-icons">
                                    <c:if test="${not empty restArea.value.convenience}">
                                        <div class="icon-item" title="편의시설">
                                            <i class="fas fa-store"></i>
                                            <span>${restArea.value.convenience}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty restArea.value.gasInfo.gasoline or not empty restArea.value.gasInfo.lPG or not empty restArea.value.gasInfo.disel}">
                                        <div class="icon-item" title="주유소">
                                            <i class="fas fa-gas-pump"></i>
                                            <span>주유</span>
                                        </div>
                                    </c:if>
                                    <!-- CCTV 아이콘 클릭 시 모달을 엽니다. -->
                                    <div class="icon-item cctv-icon" onclick="openCctvModal('${restArea.value.lat}', '${restArea.value.lng}')" title="CCTV">
                                        <i class="fas fa-video"></i>
                                        <span>CCTV</span>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="detail-info">
                                    <p class="road-name">${restArea.value.SADirection}</p>
                                    <p class="distance-info">
                                        <!-- allRestAreas 리스트에서 현재 휴게소의 인덱스를 찾습니다. -->
                                        <c:set var="durationIndex" value="-1" />
                                        <c:forEach var="allArea" items="${allRestAreas}" varStatus="durLoop">
                                            <c:if test="${allArea eq restArea.value.SAName}">
                                                <c:set var="durationIndex" value="${durLoop.index}" />
                                            </c:if>
                                        </c:forEach>
                                        <span class="duration" data-duration-index="${durationIndex}">
                                            <!-- JavaScript가 이 공간에 예상 시간을 표시할 것입니다. -->
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- CCTV 영상을 보여줄 모달 창 -->
<div id="cctvModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal('cctvModal')">&times;</span>
        <h2>주변 CCTV 영상</h2>
        <!-- 로딩/에러 메시지는 항상 존재하고 표시 여부만 바뀝니다. -->
        <p id="cctv-loading">CCTV 정보를 불러오는 중...</p>
        <p id="cctv-error" style="display: none;"></p>
        <!-- 실제 CCTV 영상은 이 div 안에 동적으로 추가됩니다. -->
        <div id="cctv-grid" class="cctv-grid"></div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 페이지 로드 후 실행
    window.onload = function() {
        // 백엔드에서 전달받은 모든 휴게소까지의 소요 시간 데이터
        const allRestAreaDurations = ${allRestAreaDurations};
        const cards = document.querySelectorAll('.rest-area-list .card');

        cards.forEach((card, cardIndex) => {
            const durationElement = card.querySelector('.duration');
            const allRestAreaIndex = parseInt(durationElement.dataset.durationIndex, 10);

            if (allRestAreaIndex !== -1 && allRestAreaDurations[allRestAreaIndex] !== undefined) {
                const duration = allRestAreaDurations[allRestAreaIndex];
                const hours = Math.floor(duration / 3600);
                const minutes = Math.floor((duration % 3600) / 60);

                let newTimeText = '';
                if (allRestAreaIndex === 0) {
                    newTimeText = '출발지부터 ';
                } else {
                    newTimeText = '이전 휴게시설부터 ';
                }

                if (hours > 0) newTimeText += hours + '시간';
                if (minutes > 0) newTimeText += minutes + '분';

                durationElement.innerHTML = newTimeText;
            }
        });
    };

    /**
     * @description CCTV 모달을 열고, 해당 휴게소 주변의 CCTV 데이터를 가져옵니다.
     * @param {string} lat - 휴게소 위도
     * @param {string} lng - 휴게소 경도
     */
    function openCctvModal(lat, lng) {
        document.getElementById('cctvModal').style.display = 'block';
        fetchCctvData(lat, lng);
    }

    /**
     * @description 주어진 위/경도 주변의 CCTV 데이터를 서버에서 가져옵니다.
     * @param {string} lat - 중심 위도
     * @param {string} lng - 중심 경도
     */
    function fetchCctvData(lat, lng) {
        const loading = document.getElementById('cctv-loading');
        const errorMsg = document.getElementById('cctv-error');
        const cctvGrid = document.getElementById('cctv-grid');

        loading.style.display = 'block';
        errorMsg.style.display = 'none';
        cctvGrid.innerHTML = '';

        const minX = parseFloat(lng) - 0.005;
        const minY = parseFloat(lat) - 0.005;
        const maxX = parseFloat(lng) + 0.005;
        const maxY = parseFloat(lat) + 0.005;

        fetch('${pageContext.request.contextPath}/Controller?type=Cctv&minX=' + minX + '&minY=' + minY + '&maxX=' + maxX + '&maxY=' + maxY)
            .then(response => {
                if (!response.ok) {
                    throw new Error('서버 오류: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                loading.style.display = 'none';

                let cctvList = [];
                if (data.response && data.response.data) {
                    if (!Array.isArray(data.response.data)) {
                        cctvList.push(data.response.data);
                    } else {
                        cctvList = data.response.data;
                    }
                }

                if (cctvList.length > 0) {
                    cctvList.forEach((cctv, index) => {
                        const videoContainer = document.createElement('div');
                        videoContainer.className = 'video-container';
                        cctvGrid.appendChild(videoContainer);

                        // cctvid가 없으면 임시 고유 ID를 생성합니다.
                        const videoId = cctv.cctvid || 'fallback-cctv-' + index;

                        fetch('${pageContext.request.contextPath}/Controller?type=getVideoUrl&temporaryUrl=' + encodeURIComponent(cctv.cctvurl))
                            .then(res => res.text())
                            .then(finalUrl => {
                                if (finalUrl) {
                                    const videoElement = document.createElement('video');
                                    videoElement.id = videoId;
                                    videoElement.className = 'video-js vjs-default-skin';
                                    videoElement.controls = true;
                                    videoElement.autoplay = true;
                                    videoElement.muted = true;
                                    videoElement.playsinline = true;

                                    const titleSpan = document.createElement('span');
                                    titleSpan.textContent = cctv.cctvname || '이름 없음';

                                    videoContainer.appendChild(videoElement);
                                    videoContainer.appendChild(titleSpan);

                                    // video.js 초기화 및 HLS 소스 설정
                                    videojs(videoId, {
                                        autoplay: true,
                                        controls: true,
                                        muted: true
                                    }).src({
                                        src: finalUrl,
                                        type: 'application/x-mpegURL'
                                    });

                                } else {
                                    videoContainer.innerHTML = `<div class="video-error">영상 로드 실패</div><span>${cctv.cctvname || '이름 없음'}</span>`;
                                }
                            })
                            .catch(error => {
                                videoContainer.innerHTML = `<div class="video-error">프록시 로드 오류</div><span>${cctv.cctvname || '이름 없음'}</span>`;
                                console.error('프록시 로드 오류:', error);
                            });
                    });
                } else {
                    errorMsg.style.display = 'block';
                    errorMsg.textContent = '주변에 CCTV가 없습니다.';
                }
            })
            .catch(error => {
                loading.style.display = 'none';
                errorMsg.style.display = 'block';
                errorMsg.textContent = 'CCTV 정보를 불러오는 중 오류가 발생했습니다.';
                console.error('CCTV 데이터 불러오기 오류:', error);
            });
    }

    /**
     * @description 모달 창을 닫습니다. 닫기 전에 video.js 플레이어를 정리합니다.
     * @param {string} modalId - 닫을 모달의 ID
     */
    function closeModal(modalId) {
        // 모달 내 모든 video.js 플레이어를 찾아서 dispose 합니다.
        const players = videojs.getPlayers();
        for (const playerId in players) {
            if (players.hasOwnProperty(playerId)) {
                const player = players[playerId];
                // 플레이어가 유효한지 확인하고 dispose 합니다.
                if (player) {
                    player.dispose(); // 플레이어 인스턴스 제거
                }
            }
        }

        // CCTV 영상 컨테이너의 내용을 비워줍니다.
        const cctvGrid = document.getElementById('cctv-grid');
        cctvGrid.innerHTML = '';

        // 모달을 숨깁니다.
        document.getElementById(modalId).style.display = 'none';
    }

    // 모달 외부 클릭 시 닫기
    window.onclick = function (event) {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            if (event.target === modal) {
                closeModal(modal.id); // closeModal 함수를 사용하여 정리 로직 실행
            }
        });
    }
</script>
</body>
</html>
