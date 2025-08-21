<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>휴게소 방향 계산 테스트</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .test-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #fafafa;
        }
        .test-title {
            font-size: 1.5em;
            color: #333;
            margin-bottom: 15px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .result-section {
            margin-top: 20px;
            padding: 15px;
            background-color: #e8f4fd;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
        .error {
            background-color: #f8d7da;
            border-left-color: #dc3545;
            color: #721c24;
        }
        .success {
            background-color: #d4edda;
            border-left-color: #28a745;
            color: #155724;
        }
        .info-box {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .coordinate-display {
            font-family: monospace;
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #dee2e6;
            margin: 10px 0;
        }
        .direction-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
            margin: 5px;
        }
        .direction-upbound {
            background-color: #28a745;
            color: white;
        }
        .direction-downbound {
            background-color: #dc3545;
            color: white;
        }
        .direction-unknown {
            background-color: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>휴게소 방향 계산 테스트</h1>
        
        <div class="info-box">
            <h3>📋 테스트 설명</h3>
            <p>이 페이지는 휴게소의 상행/하행 방향을 계산하는 기능을 테스트합니다.</p>
            <ul>
                <li><strong>상행</strong>: IC에서 휴게소로 가는 방향이 서울에 가까워지는 방향</li>
                <li><strong>하행</strong>: IC에서 휴게소로 가는 방향이 서울에서 멀어지는 방향</li>
                <li><strong>기준점</strong>: 서울역 (37.553452224808936, 126.97288438634867)</li>
            </ul>
        </div>

        <!-- 테스트 1: 수동 좌표 입력 테스트 -->
        <div class="test-section">
            <div class="test-title">🧮 수동 좌표 입력 테스트</div>
            <form id="manualTestForm">
                <div class="form-group">
                    <label for="icName">IC 이름:</label>
                    <input type="text" id="icName" name="icName" value="양재IC" placeholder="IC 이름을 입력하세요">
                </div>
                <div class="form-group">
                    <label for="icX">IC X 좌표 (경도):</label>
                    <input type="text" id="icX" name="icX" value="127.04053864962543" placeholder="경도를 입력하세요">
                </div>
                <div class="form-group">
                    <label for="icY">IC Y 좌표 (위도):</label>
                    <input type="text" id="icY" name="icY" value="37.46266222311534" placeholder="위도를 입력하세요">
                </div>
                <div class="form-group">
                    <label for="restAreaName">휴게소 이름:</label>
                    <input type="text" id="restAreaName" name="restAreaName" value="서울만남의광장휴게소" placeholder="휴게소 이름을 입력하세요">
                </div>
                <div class="form-group">
                    <label for="restAreaX">휴게소 X 좌표 (경도):</label>
                    <input type="text" id="restAreaX" name="restAreaX" value="127.04218831748021" placeholder="경도를 입력하세요">
                </div>
                <div class="form-group">
                    <label for="restAreaY">휴게소 Y 좌표 (위도):</label>
                    <input type="text" id="restAreaY" name="restAreaY" value="37.46094556751398" placeholder="위도를 입력하세요">
                </div>
                <button type="button" onclick="calculateDirection()">방향 계산하기</button>
                <button type="button" onclick="resetForm()">초기화</button>
            </form>
            
            <div id="manualResult" class="result-section" style="display: none;"></div>
        </div>

        <!-- 테스트 2: 실제 데이터 테스트 -->
        <div class="test-section">
            <div class="test-title">🔍 실제 데이터 테스트</div>
            <p>KaKaoMapV2에서 계산된 실제 휴게소 방향 정보를 확인합니다.</p>
            
            <c:if test="${not empty restAreaDirections}">
                <div class="result-section success">
                    <h4>✅ 방향 계산 완료</h4>
                    <c:forEach var="entry" items="${restAreaDirections}">
                        <c:set var="restAreaName" value="${entry.key}" />
                        <c:set var="direction" value="${entry.value}" />
                        <c:set var="prevIC" value="${restAreaToPrevIC[restAreaName]}" />
                        
                        <div style="margin: 15px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; background: white;">
                            <h5>🏪 ${restAreaName}</h5>
                            <p><strong>이전 IC:</strong> ${prevIC.name}</p>
                            <p><strong>IC 좌표:</strong> (${prevIC.x}, ${prevIC.y})</p>
                            <p><strong>방향:</strong> 
                                <span class="direction-badge 
                                    <c:choose>
                                        <c:when test="${direction == '상행'}">direction-upbound</c:when>
                                        <c:when test="${direction == '하행'}">direction-downbound</c:when>
                                        <c:otherwise>direction-unknown</c:otherwise>
                                    </c:choose>">
                                    ${direction}
                                </span>
                            </p>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <c:if test="${empty restAreaDirections}">
                <div class="result-section">
                    <p>아직 방향 계산 데이터가 없습니다. KaKaoMapV2를 먼저 실행해주세요.</p>
                </div>
            </c:if>
        </div>

        <!-- 테스트 3: 서울역 기준점 정보 -->
        <div class="test-section">
            <div class="test-title">📍 서울역 기준점 정보</div>
            <div class="coordinate-display">
                <strong>서울역 좌표:</strong><br>
                X (경도): 126.97288438634867<br>
                Y (위도): 37.553452224808936
            </div>
            <p>이 좌표를 기준으로 상행/하행이 결정됩니다.</p>
        </div>
    </div>

    <script>
        // 방향 계산 함수
        function calculateDirection() {
            const icX = parseFloat(document.getElementById('icX').value);
            const icY = parseFloat(document.getElementById('icY').value);
            const restAreaX = parseFloat(document.getElementById('restAreaX').value);
            const restAreaY = parseFloat(document.getElementById('restAreaY').value);
            
            // 서울역 좌표 (상수)
            const SEOUL_STATION_X = 37.553452224808936;
            const SEOUL_STATION_Y = 126.97288438634867;
            
            // 입력값 검증
            if (isNaN(icX) || isNaN(icY) || isNaN(restAreaX) || isNaN(restAreaY)) {
                showResult('모든 좌표값을 숫자로 입력해주세요.', 'error');
                return;
            }
            
            // IC에서 휴게소로의 벡터 계산
            const vectorX = restAreaX - icX;
            const vectorY = restAreaY - icY;
            
            // 서울역에서 IC로의 벡터
            const seoulToICX = icX - SEOUL_STATION_X;
            const seoulToICY = icY - SEOUL_STATION_Y;
            
            // 두 벡터의 내적 계산 (방향 일치도 확인)
            const dotProduct = vectorX * seoulToICX + vectorY * seoulToICY;
            
            // 방향 결정
            let direction;
            if (dotProduct > 0) {
                direction = '하행';
            } else if (dotProduct < 0) {
                direction = '상행';
            } else {
                direction = '방향불명';
            }
            
            // 거리 계산
            const icDistanceToSeoul = Math.sqrt(
                Math.pow(icX - SEOUL_STATION_X, 2) + 
                Math.pow(icY - SEOUL_STATION_Y, 2)
            );
            const restAreaDistanceToSeoul = Math.sqrt(
                Math.pow(restAreaX - SEOUL_STATION_X, 2) + 
                Math.pow(restAreaY - SEOUL_STATION_Y, 2)
            );
            
            // 결과 표시
            const resultHtml = 
                '<h4>📊 계산 결과</h4>' +
                '<p><strong>IC → 휴게소 벡터:</strong> (' + vectorX.toFixed(6) + ', ' + vectorY.toFixed(6) + ')</p>' +
                '<p><strong>서울역 → IC 벡터:</strong> (' + seoulToICX.toFixed(6) + ', ' + seoulToICY.toFixed(6) + ')</p>' +
                '<p><strong>내적 값:</strong> ' + dotProduct.toFixed(6) + '</p>' +
                '<p><strong>방향:</strong> ' +
                '<span class="direction-badge ' + 
                (direction === '상행' ? 'direction-upbound' : 
                 direction === '하행' ? 'direction-downbound' : 'direction-unknown') + '">' +
                direction + '</span></p>' +
                '<p><strong>IC-서울역 거리:</strong> ' + icDistanceToSeoul.toFixed(6) + '</p>' +
                '<p><strong>휴게소-서울역 거리:</strong> ' + restAreaDistanceToSeoul.toFixed(6) + '</p>' +
                '<p><strong>설명:</strong> ' +
                (direction === '하행' ? 'IC에서 휴게소로 가는 방향이 서울에서 멀어지는 방향입니다.' : 
                 direction === '상행' ? 'IC에서 휴게소로 가는 방향이 서울에 가까워지는 방향입니다.' : 
                 '방향을 결정할 수 없습니다.') + '</p>';
            
            showResult(resultHtml, 'success');
        }
        
        // 결과 표시 함수
        function showResult(content, type) {
            const resultDiv = document.getElementById('manualResult');
            resultDiv.innerHTML = content;
            resultDiv.className = 'result-section ' + type;
            resultDiv.style.display = 'block';
        }
        
        // 폼 초기화 함수
        function resetForm() {
            document.getElementById('manualTestForm').reset();
            document.getElementById('manualResult').style.display = 'none';
        }
        
        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            console.log('휴게소 방향 계산 테스트 페이지가 로드되었습니다.');
        });
    </script>
</body>
</html>
