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
            border-bottom: 2px solid #ccc;
            background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            border-radius: 5px;
            overflow: hidden; /* 모서리를 둥글게 */
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
            width: 320px;
            height: 240px;
            display: block; /* 비디오 하단 공백 제거 */
        }
        .kakao_infowindow .close {
            position: absolute;
            top: 5px;
            right: 10px;
            cursor: pointer;
            color: #888;
            font-size: 18px;
            font-weight: bold;
        }
        .kakao_infowindow .close:hover {
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
    </style>
</head>
<body>
<%--모달창 ***************************************************************--%>
<div id="restAreaModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <div class="modal-title">
                <i class="fas fa-utensils"></i>
                <span id="modalTitle">휴게소 정보</span>
            </div>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <div class="info-section">
                <div class="info-label">
                    <i class="fas fa-map-marker-alt"></i>
                    위치
                </div>
                <div class="info-value" id="modalLocation">
                    정보를 불러오는 중...
                </div>
            </div>

            <div class="info-section">
                <div class="info-label">
                    <i class="fas fa-phone"></i>
                    연락처
                </div>
                <div class="info-value" id="modalPhone">
                    정보를 불러오는 중...
                </div>
            </div>

            <div class="info-section">
                <div class="info-label">
                    <i class="fas fa-parking"></i>
                    주차 정보
                </div>
                <div class="parking-info-grid">
                    <div class="parking-item">
                        <span class="parking-label">소형차</span>
                        <span class="parking-value" id="modalCompactParking">-</span>
                    </div>
                    <div class="parking-item">
                        <span class="parking-label">대형차</span>
                        <span class="parking-value" id="modalLargeParking">-</span>
                    </div>
                    <div class="parking-item">
                        <span class="parking-label">장애인</span>
                        <span class="parking-value" id="modalDisabledParking">-</span>
                    </div>
                </div>
            </div>
            <div class="info-section">
                <div class="info-label">
                    <i class="fas fa-clock"></i>
                    운영시간
                </div>
                <div class="info-value" id="modalHours">
                    24시간 운영
                </div>
            </div>

            <div class="info-section">
                <div class="info-label">
                    <i class="fas fa-list"></i>
                    편의시설
                </div>
                <div class="facilities-list" id="modalFacilities">
                    <span class="facility-tag">주유소</span>
                    <span class="facility-tag">충전소</span>
                    <span class="facility-tag">음식점</span>
                    <span class="facility-tag">화장실</span>
                    <span class="facility-tag">편의점</span>
                    <span class="facility-tag">휴식공간</span>
                </div>
            </div>

            <div class="info-section">
                <div class="info-label">
                    <i class="fas fa-info-circle"></i>
                    안내사항
                </div>
                <div class="info-value">
                    • 안전한 운전을 위해 충분한 휴식을 취하세요<br>
                    • 긴급상황 시 1588-2504로 연락하세요<br>
                    • 휴게소 내에서는 안전수칙을 준수해주세요
                </div>
            </div>
        </div>
    </div>
</div>


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
    // 카카오 지도로 변경된 부분
    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(36.5, 127.5), // 지도의 중심좌표
            level: 13 // 지도의 확대 레벨 (더 줌아웃)
        };
    // 지도를 생성
    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 휴게소 데이터를 ID와 함께 저장할 공간
    const restAreaDataStore = new Map();
    // 현재 열려있는 InfoWindow를 추적하는 변수
    let currentInfoWindow = null;

    // 팝업 클릭 시 ID로 휴게소 정보를 찾아 모달을 띄워주는 함수
    function showModalForRestArea(restAreaId) {
        const restArea = restAreaDataStore.get(restAreaId.toString());
        if (restArea) {
            showRestAreaDetailModal(restArea);
        }
    }

    $(window).on('load', function () {
        console.log("window.load 이벤트 발생! 페이지의 모든 리소스(이미지 등) 로딩 완료.");
        // Leaflet과 달리 카카오 지도는 로드 이벤트 처리 방식이 달라 setTimeout 필요 없음
        console.log("초기 휴게소 데이터를 로드합니다.");
        loadRestAreas();
    });

    // Leaflet의 L.markerClusterGroup() -> 카카오의 MarkerClusterer로 변경
    const restAreaMarkers = new kakao.maps.MarkerClusterer({
        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
        averageCenter: true, // 클러스터 마커의 위치를 평균 위치로 설정
        minLevel: 10 // 클러스터 할 최소 지도 레벨
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

    // 카카오 지도에는 GeoJSON 레이어 기능이 기본 내장되어 있지 않으므로, 이 부분은 Leaflet 코드와 동일하게 작동하지 않을 수 있습니다.
    // 하지만, JQuery를 통해 데이터를 가져오는 로직은 그대로 사용할 수 있습니다.
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
            // Leaflet의 setView -> 카카오의 setCenter로 변경
            map.setCenter(new kakao.maps.LatLng(loc.lat, loc.lng));
            map.setLevel(loc.zoom);
        }
        // 카카오 지도에는 GeoJSON 레이어 기능이 없으므로 Leaflet 관련 코드는 제거
        // if (currentBoundaryLayer) { map.removeLayer(currentBoundaryLayer); }
    });

    // 휴게소 아이콘 정의 (카카오 지도는 별도 Image 객체 필요)
    const restIconImage = new kakao.maps.MarkerImage(
        '${pageContext.request.contextPath}/image/rest_icon.png',
        new kakao.maps.Size(40, 40),
        { offset: new kakao.maps.Point(19, 38) }
    );

    function addRestAreaMarkersToMap(data) {
        // 기존 마커 클러스터의 모든 마커를 제거
        restAreaMarkers.clear();
        if (!data || data.length === 0) return;

        const newMarkers = [];
        data.forEach(ra => {
            restAreaDataStore.set(ra.Idx.toString(), ra);

            const marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(ra.Lat, ra.Lng),
                image: restIconImage
            });

            // 마커 클릭 이벤트 리스너 추가
            kakao.maps.event.addListener(marker, 'click', function() {
                // 클릭 시 줌 레벨을 변경하고 모달 함수를 호출
                map.setLevel(14, {
                    anchor: marker.getPosition(),
                    animate: {
                        duration: 350
                    }
                });
                // 팝업 대신 모달을 띄우므로 팝업 관련 로직은 제거
                showModalForRestArea(ra.Idx.toString());
            });
            newMarkers.push(marker);
        });

        // 클러스터러에 마커 추가
        restAreaMarkers.addMarkers(newMarkers);
    }


    // CCTV 아이콘 정의 (카카오 지도는 별도 Image 객체 필요)
    const cctvIconImage = new kakao.maps.MarkerImage(
        '${pageContext.request.contextPath}/image/cctv_icon.png',
        new kakao.maps.Size(38, 38),
        { offset: new kakao.maps.Point(19, 38) }
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

            // 팝업 내용
            const popupContent =
                '<div class="kakao_infowindow">' +
                '    <div class="title">' + name + '</div>' +
                '    <div class="body">' +
                '        <video id="' + videoId + '" class="video-js vjs-default-skin" controls preload="auto" width="320" height="240" data-setup=\'{}\'>' +
                '            <source type="application/x-mpegURL" />' +
                '        </video>' +
                '    </div>' +
                '    <div class="close" onclick="currentInfoWindow.close();">X</div>' +
                '</div>';

            const infowindow = new kakao.maps.InfoWindow({
                content: popupContent
            });

            kakao.maps.event.addListener(marker, 'click', function() {
                if (currentInfoWindow) {
                    currentInfoWindow.close();
                }
                infowindow.open(map, marker);
                currentInfoWindow = infowindow;
                loadRealVideoUrl(videoId, temporaryUrl);
            });

            // InfoWindow가 닫힐 때 Video.js 플레이어 리소스 해제
            kakao.maps.event.addListener(infowindow, 'closeclick', function() {
                const videoElement = document.getElementById(videoId);
                if (videoElement) {
                    const player = videojs(videoElement.id);
                    if (player) {
                        player.dispose();
                        console.log('Video.js player disposed for:', videoId);
                    }
                }
            });

            newCctvMarkers.push(marker);
        });
        cctvMarkers.addMarkers(newCctvMarkers);
    }

    function loadRealVideoUrl(videoId, temporaryUrl) {
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
    }


    function loadRestAreas() {
        if (isMarkerClickZoom) {
            isMarkerClickZoom = false;
            return;
        }
        // Leaflet의 getBounds -> 카카오의 getBounds로 변경
        const bounds = map.getBounds();
        const sw = bounds.getSouthWest();
        const ne = bounds.getNorthEast();
        $.ajax({
            url: '${pageContext.request.contextPath}/Controller?type=pjyrest',
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
            url: '${pageContext.request.contextPath}/Controller?type=Cctv',
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
            url: '${pageContext.request.contextPath}/Controller?type=pjyrest',
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

                    showModalForRestArea(firstResult.Idx.toString());

                } else {
                    alert("검색 결과가 없습니다.");
                }
            });
    });

    // Leaflet의 moveend 이벤트 -> 카카오의 dragend, zoom_changed 이벤트로 변경
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


    // [추가] 모달창의 내용을 채우고, 창을 보여주는 함수
    function showRestAreaDetailModal(ra) {
        if (!ra) return; // 데이터가 없으면 실행 중지

        console.log("모달에 표시할 데이터:", ra);

        document.getElementById('modalTitle').textContent = ra.SAName || '정보 없음';
        document.getElementById('modalLocation').textContent = ra.Address || '정보 없음';
        let formattedPhone = '제공되지 않음';
        if (ra.Tel) {
            formattedPhone = ra.Tel.replace(/(\d{2,3})(\d{3,4})(\d{4})/, '$1-$2-$3');
        }
        document.getElementById('modalPhone').textContent = formattedPhone;
        document.getElementById('modalCompactParking').textContent = ra.CompactParking+"대";
        document.getElementById('modalLargeParking').textContent = ra.LargeParking+"대";
        document.getElementById('modalDisabledParking').textContent = ra.DisabledParking+"대";
        document.getElementById('restAreaModal').style.display = 'block';
    }

    // [추가] 모달의 X 버튼을 누르거나,
    function closeModal() {
        document.getElementById('restAreaModal').style.display = 'none';
    }

    // [추가] 모달 바깥의 어두운 영역을 눌렀을 때 창을 닫는 함수
    window.onclick = function(event) {
        if (event.target == document.getElementById('restAreaModal')) {
            closeModal();
        }
    }
</script>

</body>
</html>