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

    function showRestAreaDetailModal(ra) {
        if (!ra) return;

        console.log("모달에 표시할 데이터:", ra);

        document.getElementById('modalTitle').textContent = ra.SAName || '정보 없음';
        document.getElementById('modalLocation').textContent = ra.Address || '정보 없음';

        let formattedPhone = '제공되지 않음';
        if (ra.Tel) {
            formattedPhone = ra.Tel.replace(/(\d{2,3})(\d{3,4})(\d{4})/, '$1-$2-$3');
        }
        document.getElementById('modalPhone').textContent = formattedPhone;

        document.getElementById('modalCompactParking').textContent = (ra.CompactParking || 0) + "대";
        document.getElementById('modalLargeParking').textContent = (ra.LargeParking || 0) + "대";
        document.getElementById('modalDisabledParking').textContent = (ra.DisabledParking || 0) + "대";

        // 편의시설 정보 동적으로 채우기
        const facilitiesListElement = document.getElementById('modalFacilities');
        facilitiesListElement.innerHTML = ''; // 기존 내용을 비웁니다.

        if (ra.Convenience) {
            const facilities = ra.Convenience.split(',');
            if (facilities.length > 0) {
                facilities.forEach(facility => {
                    const tag = document.createElement('span');
                    tag.className = 'facility-tag';
                    tag.textContent = facility.trim();
                    facilitiesListElement.appendChild(tag);
                });
            } else {
                facilitiesListElement.innerHTML = '<span class="info-value">제공되는 편의시설 정보가 없습니다.</span>';
            }
        } else {
            facilitiesListElement.innerHTML = '<span class="info-value">제공되는 편의시설 정보가 없습니다.</span>';
        }

        document.getElementById('restAreaModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('restAreaModal').style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('restAreaModal')) {
            closeModal();
        }
    }
</script>

</body>
</html>