<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>경로 고속도로 정보 조회</title>
    <style>
        body {
            font-family: Pretendard, sans-serif;
            padding: 20px;
        }

        input {
            padding: 6px;
            margin: 5px;
            width: 250px;
        }

        button {
            padding: 8px 16px;
            margin-top: 10px;
        }

        .result {
            margin-top: 20px;
            font-weight: bold;
        }
    </style>
</head>
<body>
<h2>출발지와 도착지를 입력하세요</h2>
<input type="text" id="start" placeholder="출발지 주소 (예: 강남역)">
<br>
<input type="text" id="goal" placeholder="도착지 주소 (예: 서울역)">
<br>
<button onclick="getRoute()">경로 조회</button>

<div class="result" id="resultBox"></div>

<script src="./js/getRoute.js"></script>
</body>
</html>