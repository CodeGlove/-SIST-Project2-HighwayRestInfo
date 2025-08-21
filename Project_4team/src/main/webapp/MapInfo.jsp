<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>나만의 대한민국 지도</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cee36ddcb7d177d7bdcafa84bed65182&libraries=clusterer"></script>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/restareaStyle.css">

    <link href="https://vjs.zencdn.net/8.6.1/video-js.css" rel="stylesheet" />
    <script src="https://vjs.zencdn.net/8.6.1/video.min.js"></script>
    <script src="https://unpkg.com/@videojs/http-streaming/dist/videojs-http-streaming.min.js"></script>

    <style>
        html, body { height: 100%; margin: 0; }
        #map { width: 100%; height: 100%; }
        .search-container {
            position: absolute; top: 10px; left: 50px; z-index: 1000; background-color: white;
            padding: 8px; border-radius: 5px; box-shadow: 0 2px 6px rgba(0,0,0,0.3);
            display: flex; gap: 8px; align-items: center;
        }
        .select-wrapper { position: relative; display: inline-block; }
        .select-wrapper::after {
            content: '▼'; font-size: 14px; color: #555; position: absolute;
            top: 50%; right: 12px; transform: translateY(-50%); pointer-events: none;
        }
        .search-container select {
            -webkit-appearance: none; -moz-appearance: none; appearance: none;
            padding: 10px 35px 10px 15px; border: 1px solid #ccc; border-radius: 3px;
            font-size: 16px; background-color: white; cursor: pointer;
        }
        .search-container input, .search-container button {
            padding: 10px; border: 1px solid #ccc; border-radius: 3px; font-size: 16px;
        }
        .search-container input { width: 200px; }
        .search-container button {
            background-color: #007bff; color: white; cursor: pointer; border-color: #007bff;
        }
        #cctv-toggle-button {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        @media (max-width: 768px) {
            .search-container {
                flex-direction: column;
                align-items: stretch;
                width: 90%;
                left: 5%;
                gap: 5px;
            }
            .search-container input, .search-container select, .search-container button {
                width: 100%;
                box-sizing: border-box;
            }
        }

        /* 카카오 지도 InfoWindow 스타일 */
        .kakao_infowindow {
            position: relative;
            z-index: 9999;
            border-bottom: 2px solid #ccc;
            background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            border-radius: 5px;
            overflow: hidden;
        }
        .kakao_infowindow .title {
            font-size: 16px;
            font-weight: bold;
            padding: 10px;
            text-align: center;
            background-color: #f8f9fa;
        }
        .kakao_infowindow .body {
            padding: 5px;
        }
        .kakao_infowindow .body video {
            width: 100%;
            height: 100%;
            display: block;
        }
        .kakao_infowindow .cctv-close {
            position: absolute;
            top: 5px;
            right: 10px;
            cursor: pointer;
            color: #888;
            font-size: 18px;
            font-weight: bold;
        }
        .kakao_infowindow .cctv-close:hover {
            color: #333;
        }
        .kakao_infowindow:after {
            content: '';
            position: absolute;
            margin-left: -12px;
            left: 50%;
            bottom: -12px;
            width: 22px;
            height: 12px;
            background: url('https://t1.daumcdn.net/localimg/localimages/07/mapjsapi/2x/round_triangle.png') no-repeat;
        }

        /* 💡 마우스오버 시 표시될 커스텀 오버레이 스타일 */
        .custom-overlay {
            position: relative;
            background: #ffffff;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 8px 12px;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            white-space: nowrap;
            text-align: center;
        }
        .custom-overlay .overlay-name {
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 3px;
        }
        .custom-overlay .overlay-address {
            font-size: 12px;
            font-weight: normal;
            color: #666;
        }
        .custom-overlay::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            border-width: 5px;
            border-style: solid;
            border-color: #ccc transparent transparent transparent;
        }

        .star-rating {
            display: flex;
            align-items: center;
            gap: 5px; /* 별점 아이콘과 텍스트 사이의 간격 */
        }

        .star-rating i {
            font-size: 1.2rem; /* 별 아이콘 크기 */
        }

        .star-rating .fas {
            color: #ffc107; /* 채워진 별 색상 */
        }

        .star-rating .far {
            color: #e9ecef; /* 빈 별 색상 */
        }

        #starText {
            font-size: 1.1rem;
            font-weight: 500;
            color: #333; /* 텍스트 색상 */
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
            text-align: center; /* 버튼을 중앙에 배치 */
            width: 100%;
        }

        .modal-btn {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            color: #495057;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            display: inline-flex; /* 아이콘과 텍스트 정렬 */
            align-items: center;
            justify-content: center;
        }

        .modal-btn:hover {
            background-color: #e9ecef;
            color: #212529;
            border-color: #ced4da;
        }

        .modal-btn i {
            margin-right: 8px;
            font-size: 1.1rem;
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
            padding: 2rem;
            box-sizing: border-box;
        }
        .modal-content {
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.5);
            max-width: 550px;
            width: 100%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
        }
        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid #e9ecef;
            flex-shrink: 0;
        }

        .modal-body {
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
            background-color: #f8f9fa; /* 연한 회색 배경 */
            border: 1px solid #e9ecef;   /* 옅은 테두리 */
            border-radius: 8px;        /* 둥근 모서리 */
            padding: 1rem;             /* 내부 여백 */
            min-height: 200px;         /* 최소 높이 설정으로 안정감 부여 */
            text-align: center;
            line-height: 2;
            font-size: 1.1rem;
        }

        .ai-comment-section {
            flex-direction: column;
            align-items: flex-start;
        }

        .ai-comment-box {
            width: 100%;
            margin-top: 0.75rem;
            padding: 1rem;
            background-color: #f0f7ff;
            border-radius: 8px;
            border-left: 4px solid #007bff;
            color: #333;
            font-size: 1rem;
            line-height: 1.6;
            box-sizing: border-box;
        }

        /* 두 번째 모달 (매장 정보) 관련 스타일 */
        .store-search-container {
            display: flex;
            gap: 8px;
            margin-bottom: 1rem;
        }
        #storeSearchInput {
            flex-grow: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        #storeSearchBtn {
            padding: 8px 12px;
            border: none;
            background-color: #007bff;
            color: white;
            border-radius: 4px;
            cursor: pointer;
        }

    </style>
</head>
<body>
<%-- 모달창을 restAreaModal.jsp에서 인클루드합니다. --%>
<jsp:include page="/restAreaModal.jsp"/>


<div class="search-container">
    <div class="select-wrapper">
        <select id="region-select">
            <option value="">-- 지역 선택 --</option>
            <option value="seoul">서울/경기</option>
            <option value="gangwon">강원도</option>
            <option value="chungcheong">충청도</option>
            <option value="jeolla">전라도</option>
            <option value="gyeongsang">경상도</option>
        </select>
    </div>
    <input type="text" id="search-input" placeholder="휴게소 이름 검색">
    <button id="search-button">검색</button>
    <button id="cctv-toggle-button">CCTV 켜기</button>
</div>

<div id="map"></div>

<script>
    var mapContainer = document.getElementById('map'),
        mapOption = {
            center: new kakao.maps.LatLng(36.5, 127.5),
            level: 13
        };
    var map = new kakao.maps.Map(mapContainer, mapOption);

    const restAreaDataStore = new Map();
    let currentInfoWindow = null;
    let currentVideoPlayer = null;

    let currentRestAreaId = null;

    // 매장 정보를 서버에서 불러와서 화면에 표시하는 함수
    function loadAndRenderStores(saKey, searchText = '') {
        const $storeList = $('#storeList');
        $storeList.empty();
        $storeList.html('<p class="store-empty">매장 정보를 불러오는 중...</p>');

        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/Controller',
            data: { type: 'getStores', saKey: saKey, searchText: searchText },
            dataType: 'json',
            success: function (response) {
                $storeList.empty();
                if (response && response.length > 0) {
                    response.forEach(store => {
                        $storeList.append("<b>" + store.ShopName + "</b><br>");
                    });
                } else {
                    $storeList.html('<p class="store-empty">' + (searchText ? '검색 결과가 없습니다.' : '등록된 매장 정보가 없습니다.') + '</p>');
                }
            },
            error: function () {
                $storeList.html('<p class="store-empty">매장 정보를 불러오는 중 오류가 발생했습니다.</p>');
            }
        });
    }

    function showModalForRestArea(restAreaId) {
        const restArea = restAreaDataStore.get(restAreaId.toString());
        if (restArea) {
            showRestAreaDetailModal(restArea);
        }
    }

    $(window).on('load', function () {
        console.log("window.load 이벤트 발생! 페이지의 모든 리소스(이미지 등) 로딩 완료.");
        console.log("초기 휴게소 데이터를 로드합니다.");
        loadRestAreas();
    });

    const restAreaMarkers = new kakao.maps.MarkerClusterer({
        map: map,
        averageCenter: true,
        minLevel: 10
    });

    const cctvMarkers = new kakao.maps.MarkerClusterer({
        map: map,
        averageCenter: true,
        minLevel: 10
    });

    let provinceData = null;
    let currentBoundaryLayer = null;
    let isMarkerClickZoom = false;
    let isCctvVisible = false;

    $.getJSON('https://raw.githubusercontent.com/southkorea/southkorea-maps/master/kostat/2018/json/skorea-provinces-2018-geo.json', function(data) {
        provinceData = data;
    });

    const regionLocations = {
        'seoul': { lat: 37.5665, lng: 126.9780, zoom: 9, names: ["경기도", "서울특별시", "인천광역시"] },
        'gangwon': { lat: 37.8854, lng: 128.4018, zoom: 9, names: ["강원도"] },
        'chungcheong': { lat: 36.6359, lng: 127.4913, zoom: 9, names: ["충청북도", "충청남도", "대전광역시", "세종특별자치시"] },
        'jeolla': { lat: 35.1601, lng: 126.8517, zoom: 8, names: ["전라북도", "전라남도", "광주광역시"] },
        'gyeongsang': { lat: 35.8714, lng: 128.6014, zoom: 8, names: ["경상북도", "경상남도", "대구광역시", "울산광역시", "부산광역시"] }
    };

    $('#region-select').on('change', function() {
        const selectedRegion = $(this).val();
        if (selectedRegion && regionLocations[selectedRegion]) {
            const loc = regionLocations[selectedRegion];
            map.setCenter(new kakao.maps.LatLng(loc.lat, loc.lng));
            map.setLevel(loc.zoom);
        }
    });

    const restIconImage = new kakao.maps.MarkerImage(
        'image/rest_icon1.png',
        new kakao.maps.Size(30, 30),
        { offset: new kakao.maps.Point(15, 30) }
    );

    function addRestAreaMarkersToMap(data) {
        restAreaMarkers.clear();

        if (!data || data.length === 0) return;

        const newMarkers = [];
        data.forEach(ra => {
            restAreaDataStore.set(ra.Idx.toString(), ra);

            const marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(ra.Lat, ra.Lng),
                image: restIconImage
            });

            const content = '<div class="custom-overlay">' +
                '<div class="overlay-name">' + ra.SAName + '</div>' +
                '<div class="overlay-address">' + ra.Address + '</div>' +
                '</div>';
            const customOverlay = new kakao.maps.CustomOverlay({
                position: marker.getPosition(),
                content: content,
                yAnchor: 2.2
            });

            kakao.maps.event.addListener(marker, 'mouseover', function() {
                customOverlay.setMap(map);
            });

            kakao.maps.event.addListener(marker, 'mouseout', function() {
                customOverlay.setMap(null);
            });

            kakao.maps.event.addListener(marker, 'click', function() {
                const currentLevel = map.getLevel();
                const targetLevel = 3;
                const newLevel = Math.min(currentLevel, targetLevel);

                map.setLevel(newLevel, {
                    anchor: marker.getPosition(),
                    animate: { duration: 350 }
                });

                showModalForRestArea(ra.Idx.toString());
            });

            newMarkers.push(marker);
        });

        restAreaMarkers.addMarkers(newMarkers);
    }

    const cctvIconImage = new kakao.maps.MarkerImage(
        'image/cctv_icon.png',
        new kakao.maps.Size(20, 20),
        { offset: new kakao.maps.Point(10, 20) }
    );

    function addCctvMarkersToMap(data) {
        cctvMarkers.clear();

        if (!data || !data.response || !data.response.data) {
            console.log("CCTV 데이터가 없거나 형식이 올바르지 않습니다.");
            return;
        }

        const cctvList = Array.isArray(data.response.data) ? data.response.data : [data.response.data];
        const newCctvMarkers = [];

        cctvList.forEach(cctv => {
            const lat = parseFloat(cctv.coordy);
            const lng = parseFloat(cctv.coordx);
            if (isNaN(lat) || isNaN(lng)) return;

            const name = cctv.cctvname.replace(/;/g, '');
            const sanitizedName = name.replace(/[^a-zA-Z0-9-]/g, '-');
            const videoId = "cctv-video-" + sanitizedName;
            const temporaryUrl = cctv.cctvurl;

            const marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(lat, lng),
                image: cctvIconImage
            });

            kakao.maps.event.addListener(marker, 'click', function() {
                if (currentVideoPlayer) {
                    currentVideoPlayer.dispose();
                    currentVideoPlayer = null;
                    console.log('이전 Video.js 플레이어 파기 완료');
                }
                if (currentInfoWindow) {
                    currentInfoWindow.close();
                    console.log('이전 infowindow 닫기 완료');
                }

                const popupContent =
                    '<div class="kakao_infowindow">' +
                    '    <div class="title">' + name + '</div>' +
                    '    <div class="body">' +
                    '        <video id="' + videoId + '" class="video-js vjs-default-skin" controls preload="auto" width="320" height="240"></video>' +
                    '    </div>' +
                    '    <div class="cctv-close">X</div>' +
                    '</div>';

                const infowindow = new kakao.maps.InfoWindow({
                    content: popupContent
                });

                infowindow.open(map, marker);
                currentInfoWindow = infowindow;

                $(document).on('click', '.cctv-close', function() {
                    console.log('cctv-close 버튼이 클릭되었습니다.');
                    if (currentVideoPlayer) {
                        currentVideoPlayer.dispose();
                        currentVideoPlayer = null;
                        console.log('Video.js player disposed on cctv-close.');
                    }
                    if (currentInfoWindow) {
                        currentInfoWindow.close();
                        currentInfoWindow = null;
                        console.log('인포윈도우가 닫혔습니다.');
                    }
                });

                loadVideoJsPlayer(videoId, temporaryUrl);
            });

            newCctvMarkers.push(marker);
        });
        cctvMarkers.addMarkers(newCctvMarkers);
    }

    function loadVideoJsPlayer(videoId, temporaryUrl) {
        const videoElement = document.getElementById(videoId);
        if (!videoElement) {
            console.error('Error: Video element not found:', videoId);
            return;
        }

        const player = videojs(videoElement, {
            controls: true,
            autoplay: true,
            preload: 'auto',
            fluid: false,
            fullscreen: {
                options: {
                    navigationUI: 'hide'
                }
            }
        });
        currentVideoPlayer = player;

        player.on('error', function() {
            const error = player.error();
            console.error('video.js 플레이어 오류 발생:', error);
            player.poster('image/error.png');
            if (error.code === 4) {
                console.error('영상 재생 실패: 소스(URL)가 유효하지 않거나 재생할 수 없는 형식입니다.');
            }
        });

        console.log("영상 URL 가져오기 시작:", temporaryUrl);

        $.ajax({
            url: 'Controller?type=getVideoUrl',
            type: 'GET',
            data: { temporaryUrl: temporaryUrl },
            dataType: 'text'
        }).done(function(realUrl) {
            if (realUrl && realUrl.length > 0) {
                console.log("서버로부터 받은 실제 영상 URL:", realUrl);
                player.src({
                    src: realUrl,
                    type: 'application/x-mpegURL'
                });
                player.play();
            } else {
                console.error("영상 URL이 유효하지 않습니다. 서버 응답이 비어있습니다.");
                player.poster('image/error.png');
            }
        }).fail(function(jqXHR, textStatus, errorThrown) {
            console.error("영상 URL 가져오기 실패:", textStatus, errorThrown);
            console.log("서버 응답:", jqXHR.responseText);
            player.poster('image/error.png');
        });
    }

    function loadRestAreas() {
        if (isMarkerClickZoom) {
            isMarkerClickZoom = false;
            return;
        }
        const bounds = map.getBounds();
        const sw = bounds.getSouthWest();
        const ne = bounds.getNorthEast();
        $.ajax({
            url: 'Controller?type=pjyrest',
            type: 'GET',
            data: { swLat: sw.getLat(), swLng: sw.getLng(), neLat: ne.getLat(), neLng: ne.getLng() },
            dataType: 'json'
        }).done(function(data) {
            addRestAreaMarkersToMap(data);
        });
    }

    function loadCctvData() {
        const bounds = map.getBounds();
        const sw = bounds.getSouthWest();
        const ne = bounds.getNorthEast();
        $.ajax({
            url: 'Controller?type=Cctv',
            type: 'GET',
            data: {
                minX: sw.getLng(),
                minY: sw.getLat(),
                maxX: ne.getLng(),
                maxY: ne.getLat()
            },
            dataType: 'json'
        }).done(function(data) {
            console.log("CCTV 데이터 로드 성공:", data);
            addCctvMarkersToMap(data);
        }).fail(function(jqXHR, textStatus, errorThrown) {
            console.error("CCTV 데이터 로딩 실패:", textStatus, errorThrown);
            console.log("서버 응답:", jqXHR.responseText);
        });
    }

    $('#cctv-toggle-button').on('click', function() {
        if (isCctvVisible) {
            cctvMarkers.setMap(null);
            isCctvVisible = false;
            $(this).text('CCTV 켜기').css('background-color', '#6c757d').css('border-color', '#6c757d');

            if(currentInfoWindow) {
                currentInfoWindow.close();
            }
            if(currentVideoPlayer) {
                currentVideoPlayer.dispose();
                currentVideoPlayer = null;
            }
        } else {
            cctvMarkers.setMap(map);
            isCctvVisible = true;
            $(this).text('CCTV 끄기').css('background-color', '#007bff').css('border-color', '#007bff');
            loadCctvData();
        }
    });

    $('#search-button').on('click', function() {
        const searchText = $('#search-input').val();
        if (!searchText) {
            alert("휴게소 이름을 입력해주세요.");
            return;
        }
        $.ajax({
            url: 'Controller?type=pjyrest',
            type: 'POST',
            data: { searchText: searchText },
            dataType: 'json'
        })
            .done(function(data) {
                if (data && data.length > 0) {
                    addRestAreaMarkersToMap(data);
                    const firstResult = data[0];
                    const position = new kakao.maps.LatLng(firstResult.Lat, firstResult.Lng);
                    const currentLevel = map.getLevel();
                    const targetLevel = 3;
                    const newLevel = Math.max(currentLevel, targetLevel);

                    map.setCenter(position);
                    map.setLevel(newLevel, { animate: true });

                } else {
                    alert("검색 결과가 없습니다.");
                }
            });
    });

    kakao.maps.event.addListener(map, 'dragend', function() {
        loadRestAreas();
        if (isCctvVisible) {
            loadCctvData();
        }
    });
    kakao.maps.event.addListener(map, 'zoom_changed', function() {
        loadRestAreas();
        if (isCctvVisible) {
            loadCctvData();
        }
    });

    function showModalForRestArea(restAreaId) {
        currentRestAreaId = restAreaId; // 현재 휴게소 ID 저장
        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/Controller',
            data: { type: 'getRestAreaDetails', saKey: restAreaId },
            dataType: 'json',
            success: function (response) {
                if (response && response.Idx) {
                    showRestAreaDetailModal(response);
                } else {
                    alert('휴게소의 상세 정보를 불러오는 데 실패했습니다.');
                }
            },
            error: function () {
                alert('서버와 통신 중 오류가 발생했습니다.');
            }
        });
    }

    // 기존 showRestAreaDetailModal 함수를 mypage.jsp 버전 기반의 아래 코드로 교체
    function showRestAreaDetailModal(data) {
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

        // DB의 컬럼명이 AiComment 또는 AIComment 일 수 있으니 두 경우 모두 처리
        $('#modalAiComment').text(data.AIComment || data.AiComment || '제공되는 추천 코멘트가 없습니다.');

        const gasInfo = data.gasInfo;
        if (gasInfo) {
            $('#modalGasoline').text((gasInfo.Gasoline && gasInfo.Gasoline !== 'X') ? gasInfo.Gasoline + '원' : '주유불가');
            $('#modalDiesel').text((gasInfo.Disel && gasInfo.Disel !== 'X') ? gasInfo.Disel + '원' : '주유불가');
            $('#modalLpg').text((gasInfo.LPG && gasInfo.LPG !== 'X') ? gasInfo.LPG + '원' : '주유불가');
        } else {
            $('#modalGasoline, #modalDiesel, #modalLpg').text('조회 불가');
        }

        const facilitiesList = $('#modalFacilities');
        facilitiesList.empty();
        if (data.Convenience) {
            data.Convenience.split(',').forEach(facility => {
                if(facility.trim()) {
                    facilitiesList.append($('<span>').addClass('facility-tag').text(facility.trim()));
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
            const halfStar = (starValue % 1) >= 0.5;
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

    // 첫 번째 모달(#restAreaModal)의 닫기('X') 버튼 클릭
    $('#restAreaModal .close').on('click', function() {
        $('#restAreaModal').hide();
    });

    // 두 번째 모달(#storesModal)의 닫기('X') 버튼 클릭
    $('#storesModal .close').on('click', function() {
        $('#storesModal').hide();
        // [핵심] 첫 번째 모달을 다시 보여줍니다.
        $('#restAreaModal').css('display', 'flex');
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

    // 모달 내용 클릭 시 배경 클릭 이벤트가 실행되지 않도록 함
    $('.modal-content').on('click', function(e) {
        e.stopPropagation();
    });

    // 매장 정보 버튼 클릭
    $('#showStoresBtn').on('click', function () {
        $('#restAreaModal').hide(); // 첫 모달 숨김
        $('#storesModal').css('display', 'flex'); // 두 번째 모달 표시
        const restAreaName = $('#modalTitle').text();
        $('#storesModalTitle').text(restAreaName + ' 매장 정보');
        $('#storeSearchInput').val('');
        if (currentRestAreaId) {
            loadAndRenderStores(currentRestAreaId, '');
        }
    });

    // 매장 검색 버튼 클릭
    $('#storeSearchBtn').on('click', function() {
        const searchText = $('#storeSearchInput').val();
        if (currentRestAreaId) {
            loadAndRenderStores(currentRestAreaId, searchText);
        }
    });

    // 검색창에서 Enter 키 입력
    $('#storeSearchInput').on('keypress', function(e) {
        if (e.which === 13) {
            $('#storeSearchBtn').click();
        }
    });
</script>

</body>
</html>