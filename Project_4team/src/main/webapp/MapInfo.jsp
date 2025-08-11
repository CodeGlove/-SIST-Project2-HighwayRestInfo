<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>나만의 대한민국 지도</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.css"/>
    <link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.Default.css"/>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet.markercluster@1.4.1/dist/leaflet.markercluster.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        /* style 태그 내용은 기존과 동일 */
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
        .leaflet-popup-content-wrapper:hover {
            background-color: #f1f1f1; /* 연한 회색 */
        }

        .leaflet-popup-content a {
            color: #0056b3; /* 기존보다 약간 진한 파란색 (원하는 색상으로 변경 가능) */
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
</div>

<div id="map"></div>

<script>
    const koreaBounds = [ [32, 122], [40, 134] ];
    const map = L.map('map', { minZoom: 7, maxBounds: koreaBounds, maxBoundsViscosity: 1 }).setView([36.5, 127.5], 7);

    L.tileLayer('https://api.maptiler.com/maps/bright-v2/{z}/{x}/{y}.png?key=TwDY4NtQJzt1inxOs8qP', {
        attribution: '<a href="https://www.maptiler.com/copyright/" target="_blank">&copy; MapTiler</a> <a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap</a> contributors'
    }).addTo(map);

    const markers = L.markerClusterGroup();
    map.addLayer(markers);

    let provinceData = null;
    let currentBoundaryLayer = null;
    let isMarkerClickZoom = false;

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

    // (수정된 부분) 지역 선택 기능 추가
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

    function addMarkersToMap(data) {
        markers.clearLayers();
        if (!data || data.length === 0) return;
        data.forEach(ra => {
            const marker = L.marker([ra.Lat, ra.Lng]);
            const popupContent = `<a href="${pageContext.request.contextPath}/Controller?type=restAreaDetail&idx=\${ra.Idx}"><b>\${ra.SAName}</b><br>\${ra.Address}</a>`;
            marker.bindPopup(popupContent);
            marker.on('click', function(e) {
                isMarkerClickZoom = true;
                const currentZoom = map.getZoom(); // 현재 줌 레벨을 가져옴
                const targetZoom = 14;
                // 현재 줌 레벨과 목표 줌 레벨 중 더 큰 값을 사용
                const newZoom = Math.max(currentZoom, targetZoom);

                map.setView(e.latlng, newZoom); // 계산된 줌 레벨로 설정
                map.once('zoomend', function() {
                    e.target.openPopup();
                });
            });
            markers.addLayer(marker);
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
            addMarkersToMap(data);
        });
    }

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
                    addMarkersToMap(data);
                    const firstResult = data[0];
                    const position = [firstResult.Lat, firstResult.Lng];

                    const currentZoom = map.getZoom();
                    const targetZoom = 15;
                    const newZoom = Math.max(currentZoom, targetZoom);

                    map.setView(position, newZoom); // 계산된 줌 레벨로 설정

                    map.once('zoomend', function() {
                        const popupContent = `<a href="${pageContext.request.contextPath}/Controller?type=restAreaDetail&idx=\${firstResult.Idx}" target="_blank" style="text-decoration: none; color: inherit;"><b>\${firstResult.SAName}</b><br>\${firstResult.Address}</a>`;
                        L.popup().setLatLng(position).setContent(popupContent).openOn(map);
                    });
                } else {
                    alert("검색 결과가 없습니다.");
                }
            });
    });

    // (수정된 부분) 초기 로딩 로직 변경
    map.on('moveend', loadRestAreas);
    map.once('load', function(){
        loadRestAreas();
    });
</script>

</body>
</html>