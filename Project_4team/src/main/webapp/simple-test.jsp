<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>간단한 테스트</title>
</head>
<body>
    <h1>테스트 페이지</h1>
    <p>현재 시간: <%= new java.util.Date() %></p>
    
    <h2>방향 계산 테스트</h2>
    <div>
        <label>IC X 좌표:</label>
        <input type="text" id="icX" value="127.04053864962543"><br>
        <label>IC Y 좌표:</label>
        <input type="text" id="icY" value="37.46266222311534"><br>
        <label>휴게소 X 좌표:</label>
        <input type="text" id="restAreaX" value="127.04218831748021"><br>
        <label>휴게소 Y 좌표:</label>
        <input type="text" id="restAreaY" value="37.46094556751398"><br>
        <button onclick="calculate()">계산하기</button>
    </div>
    
    <div id="result"></div>
    
    <script>
        function calculate() {
            const icX = parseFloat(document.getElementById('icX').value);
            const icY = parseFloat(document.getElementById('icY').value);
            const restAreaX = parseFloat(document.getElementById('restAreaX').value);
            const restAreaY = parseFloat(document.getElementById('restAreaY').value);
            
            // 서울역 좌표
            const SEOUL_X = 37.553452224808936;
            const SEOUL_Y = 126.97288438634867;
            
            // 벡터 계산
            const vectorX = restAreaX - icX;
            const vectorY = restAreaY - icY;
            const seoulToICX = icX - SEOUL_X;
            const seoulToICY = icY - SEOUL_Y;
            
            // 내적 계산
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
            
            document.getElementById('result').innerHTML = 
                '<h3>결과</h3>' +
                '<p>방향: ' + direction + '</p>' +
                '<p>내적값: ' + dotProduct.toFixed(6) + '</p>';
        }
    </script>
</body>
</html>
