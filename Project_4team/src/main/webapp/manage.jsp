<%--
  Created by IntelliJ IDEA.
  User: js
  Date: 25. 7. 31.
  Time: 오전 9:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        .chart {
            position: relative;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            transition: 0.3s;
            background:lightgray;
            display:inline-block;
        }

        .chart:after{ /* 가상선택자는 도넛 모양을 만들기 위함이다.*/
            content:'';
            background: #fff;  /* 백그라운드 컬러로 중앙가리기 */
            position: absolute;
            top:50%; left:50%;
            width:200px; height:200px; /* 도넛의 너비 설정 */
            border-radius: 50%;
            transform: translate(-50%, -50%);
        }
        .chart-bar{
            width: inherit;
            height: inherit;
            border-radius: 50%;
            background: conic-gradient(#9986dd 50deg, #fbb871 50deg); /* 차트 설정 */
        }
    </style>
</head>
<body>
  <form method="post"  action="Controller">
    <input type="hidden" name="type" value="initSARA">
    <button type="submit">휴게소, 입점업체 목록 업데이트</button>
  </form>
  <div class="chart">
      <div class="chart-bar" data-deg="50"></div>
  </div>
</body>
</html>
