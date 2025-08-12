<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>나만의 대한민국 지도</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Leaflet 라이브러리 (최신 안정 버전) -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

    <!-- Leaflet.markercluster 라이브러리 -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.css"/>
    <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.Default.css"/>
    <script src="https://unpkg.com/leaflet.markercluster@1.4.1/dist/leaflet.markercluster.js"></script>

    <!-- jQuery: AJAX 요청을 위해 필요 -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!--
        [중요] video.js와 HLS 관련 라이브러리 버전 통일 및 정리
        - video.js는 최신 안정 버전인 8.6.1 사용
        - HLS 플러그인은 videojs-contrib-hls 대신
          videojs/http-streaming을 사용 (video.js 7.x 이상부터 권장됨)
    -->
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
    </style>
</head>
<body>

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
    const koreaBounds = [ [32, 122], [40, 134] ];
    const map = L.map('map', { minZoom: 7, maxBounds: koreaBounds, maxBoundsViscosity: 1 }).setView([36.5, 127.5], 7);

    L.tileLayer('https://api.maptiler.com/maps/bright-v2/{z}/{x}/{y}.png?key=TwDY4NtQJzt1inxOs8qP', {
        attribution: '<a href="https://www.maptiler.com/copyright/" target="_blank">&copy; MapTiler</a> <a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap</a> contributors'
    }).addTo(map);

    $(window).on('load', function () {
        console.log("window.load 이벤트 발생! 페이지의 모든 리소스(이미지 등) 로딩 완료.");
        // window.load 이벤트가 발생했더라도, 아주 짧은 지연(0.1초)을 주어
        // Leaflet이 내부적으로 좌표 등을 계산할 시간을 확실히 보장해줍니다.
        setTimeout(function () {
            console.log("초기 휴게소 데이터를 로드합니다.");
            loadRestAreas();
        }, 100);
    });

    const restAreaMarkers = L.markerClusterGroup();
    map.addLayer(restAreaMarkers);

    const cctvMarkers = L.markerClusterGroup();

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
        if (currentBoundaryLayer) { map.removeLayer(currentBoundaryLayer); }
        if (selectedRegion && regionLocations[selectedRegion]) {
            const loc = regionLocations[selectedRegion];
            map.setView([loc.lat, loc.lng], loc.zoom);
            if(provinceData) {
                const regionFeatures = provinceData.features.filter(feature => {
                    if (feature && feature.properties && feature.properties.name) { return loc.names.includes(feature.properties.name); }
                    return false;
                });
                if (regionFeatures.length > 0) {
                    currentBoundaryLayer = L.geoJSON(regionFeatures, {
                        style: { color: "#007bff", weight: 1, opacity: 0.5, fillColor: "#007bff", fillOpacity: 0.1 }
                    }).addTo(map);
                }
            }
        }
    });

    //휴게소 아이콘 정의
    const restIcon = L.icon({
        iconUrl: '${pageContext.request.contextPath}/image/rest_icon2.png',
        iconSize: [40, 40],
        iconAnchor: [19, 38],
        popupAnchor: [0, -38]
    });

    function addRestAreaMarkersToMap(data) {
        restAreaMarkers.clearLayers();
        if (!data || data.length === 0) return;
        data.forEach(ra => {
            const marker = L.marker([ra.Lat, ra.Lng], { icon: restIcon });

            // JSP EL과 JavaScript 템플릿 리터럴 충돌 방지를 위해 문자열 결합 방식으로 변경
            const popupContent = '<a href="${pageContext.request.contextPath}/Controller?type=restAreaDetail&idx=' + ra.Idx + '" target="_blank" style="text-decoration: none; color: inherit;"><b>' + ra.SAName + '</b><br>' + ra.Address + '</a>';
            marker.bindPopup(popupContent);
            marker.on('click', function(e) {
                isMarkerClickZoom = true;
                const currentZoom = map.getZoom();
                const targetZoom = 14;
                const newZoom = Math.max(currentZoom, targetZoom);
                map.setView(e.latlng, newZoom);
                map.once('zoomend', function() {
                    e.target.openPopup();
                });
            });
            restAreaMarkers.addLayer(marker);
        });
    }



    // CCTV 아이콘 정의
    const cctvIcon = L.icon({
        iconUrl: '${pageContext.request.contextPath}/image/cctv_icon.png',
        iconSize: [38, 38],
        iconAnchor: [19, 38],
        popupAnchor: [0, -38]
    });


    // JSP 파일의 addCctvMarkersToMap 함수 (전체 교체)
    function addCctvMarkersToMap(data) {
        // 기존 마커 레이어를 모두 지웁니다.
        cctvMarkers.clearLayers();

        // 데이터가 없거나 형식이 올바르지 않으면 함수를 종료합니다.
        if (!data || !data.response || !data.response.data) {
            console.log("CCTV 데이터가 없거나 형식이 올바르지 않습니다.");
            return;
        }

        // 데이터를 배열로 정규화합니다.
        const cctvList = Array.isArray(data.response.data) ? data.response.data : [data.response.data];

        // 각 CCTV 데이터에 대해 마커를 생성하고 맵에 추가합니다.
        cctvList.forEach(cctv => {
            const lat = parseFloat(cctv.coordy);
            const lng = parseFloat(cctv.coordx);
            if (isNaN(lat) || isNaN(lng)) return;

            // CCTV 이름에서 `;` 제거
            const name = cctv.cctvname.replace(/;/g, '');

            // CSS 선택자에 유효하지 않은 모든 문자를 제거하여 videoId 생성
            const sanitizedName = name.replace(/[^a-zA-Z0-9-]/g, '-');
            const videoId = "cctv-video-" + sanitizedName;

            const temporaryUrl = cctv.cctvurl;
            const marker = L.marker([lat, lng], { icon: cctvIcon });

            const popupContent =
                '<div style="width: 320px;">' +
                '<b>' + name + '</b><br>' +
                '<video id="' + videoId + '" class="video-js vjs-default-skin" controls preload="auto" width="320" height="240" data-setup=\'{}\'>' +
                '<source type="application/x-mpegURL" />' +
                '</video>' +
                '</div>';
            marker.bindPopup(popupContent, { minWidth: 320 });
            cctvMarkers.addLayer(marker);

            // 팝업이 열릴 때마다 새로운 AJAX 요청을 보내서 진짜 영상 URL을 가져옵니다.
            marker.on('popupopen', function() {
                const videoElement = document.getElementById(videoId);
                if (videoElement) {


                    $.ajax({
                        url: '${pageContext.request.contextPath}/Controller?type=getVideoUrl',
                        type: 'GET',
                        data: { temporaryUrl: temporaryUrl },
                        dataType: 'text'
                    }).done(function(realUrl) {
                        if (realUrl && realUrl.length > 0) {
                            console.log("서버로부터 받은 실제 영상 URL:", realUrl);
                            videojs(videoElement.id).src({
                                src: realUrl,
                                type: 'application/x-mpegURL'
                            });
                        } else {
                            console.error("영상 URL이 유효하지 않습니다.");
                            videoElement.poster = '${pageContext.request.contextPath}/image/error.png';
                        }
                    }).fail(function(jqXHR, textStatus, errorThrown) {
                        console.error("영상 URL 가져오기 실패:", textStatus, errorThrown);
                        videoElement.poster = '${pageContext.request.contextPath}/image/error.png';
                    });
                } else {
                    console.error('Video element not found:', videoId);
                }
            });

            // 팝업이 닫힐 때 video.js 플레이어를 종료합니다.
            marker.on('popupclose', function() {
                const videoElement = document.getElementById(videoId);
                if (videoElement) {
                    const player = videojs(videoElement.id);
                    if (player) {
                        player.dispose();
                        console.log('Video.js player disposed for:', videoId);
                    }
                }
            });
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
            url: '${pageContext.request.contextPath}/Controller?type=pjyrest',
            type: 'GET',
            data: { swLat: sw.lat, swLng: sw.lng, neLat: ne.lat, neLng: ne.lng },
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
            url: '${pageContext.request.contextPath}/Controller?type=Cctv',
            type: 'GET',
            data: {
                minX: sw.lng,
                minY: sw.lat,
                maxX: ne.lng,
                maxY: ne.lat
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
            map.removeLayer(cctvMarkers);
            isCctvVisible = false;
            $(this).text('CCTV 켜기').css('background-color', '#6c757d').css('border-color', '#6c757d');
        } else {
            map.addLayer(cctvMarkers);
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
            url: '${pageContext.request.contextPath}/Controller?type=pjyrest',
            type: 'POST',
            data: { searchText: searchText },
            dataType: 'json'
        })
            .done(function(data) {
                if (data && data.length > 0) {
                    addRestAreaMarkersToMap(data);
                    const firstResult = data[0];
                    const position = [firstResult.Lat, firstResult.Lng];
                    const currentZoom = map.getZoom();
                    const targetZoom = 15;
                    const newZoom = Math.max(currentZoom, targetZoom);
                    map.setView(position, newZoom);
                    map.once('zoomend', function() {
                        const popupContent = '<a href="${pageContext.request.contextPath}/Controller?type=restAreaDetail&idx=' + firstResult.Idx + '" target="_blank" style="text-decoration: none; color: inherit;"><b>' + firstResult.SAName + '</b><br>' + firstResult.Address + '</a>';
                        L.popup().setLatLng(position).setContent(popupContent).openOn(map);
                    });
                } else {
                    alert("검색 결과가 없습니다.");
                }
            });
    });

    map.on('moveend', function() {
        loadRestAreas();
        if (isCctvVisible) {
            loadCctvData();
        }
    });

    map.once('load', function(){
        loadRestAreas();
    });
</script>

</body>
</html>
