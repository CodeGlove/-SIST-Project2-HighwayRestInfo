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

    <style>
        /* body와 html의 여백을 없애고, 지도가 화면에 꽉 차게 합니다 */
        html, body {
            height: 100%;
            margin: 0;
        }

        /* 지도가 표시될 div의 크기를 정합니다 */
        #map {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>

<div id="map"></div>

<script>
    const koreaBounds = [
        [32, 122], // 남서쪽 꼭짓점 (South-West)
        [40, 134]  // 북동쪽 꼭짓점 (North-East)
    ];

    // 1. 지도 객체 생성 및 초기 설정
    const map = L.map('map', {
        minZoom: 7,
        maxBounds: koreaBounds,
        maxBoundsViscosity: 1
    }).setView([36.5, 127.5], 7);

    L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
    }).addTo(map);
    /*============================================여기까지는 단순 화면 보여주기 ============================================================*/


    // 1. 마커 클러스터 그룹 생성
    const markers = L.markerClusterGroup();
    map.addLayer(markers); // 지도에 클러스터 그룹 추가

    // 2. 보이는 영역의 휴게소를 불러오는 함수
    function loadRestAreas() {
        const bounds = map.getBounds();
        const sw = bounds.getSouthWest();
        const ne = bounds.getNorthEast();

        // 3. 서버에 현재 보이는 영역의 좌표를 보내 데이터 요청
        fetch('/Controller?type=pjyrest &swLat=' + sw.lat + '&swLng=' + sw.lng + '&neLat=' + ne.lat + '&neLng=' + ne.lng)
            console.log("sw lat="+sw.lat)
            console.log("sw lng="+sw.lng)
            console.log("ne lat="+ne.lat)
            console.log("ne lng="+ne.lng)

            .then(response => response.json())
            .then(data => {
                markers.clearLayers(); // 4. 기존 마커 모두 제거

                // 5. 받아온 데이터로 마커 생성 후 클러스터 그룹에 추가
                data.forEach(ra => {
                    const marker = L.marker([ra.lat, ra.lng]);
                    marker.bindPopup(`<b>${ra.name}</b><br>${ra.address}`);
                    markers.addLayer(marker); // 클러스터 그룹에 마커 추가
                });
            });
    }

    // 6. 지도의 움직임이 멈추면 휴게소 데이터를 새로 불러옴
    map.on('moveend', loadRestAreas);

    // 7. 첫 로딩 시 한 번 실행
    loadRestAreas();
</script>

</body>
</html>