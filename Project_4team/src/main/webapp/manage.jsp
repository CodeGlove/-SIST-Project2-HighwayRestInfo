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
</head>
<body>
  <form method="post"  action="Controller">
    <input type="hidden" name="type" value="initSARA">
    <button type="submit">휴게소, 입점업체 목록 업데이트</button>
  </form>
  <canvas id="donutChart" width="300" height="300"></canvas>
  <script>
    // 도넛 차트 그리기 함수
    function drawDonutChart(canvasId, data, colors, metallicIndex) {
      const canvas = document.getElementById(canvasId);
      const ctx = canvas.getContext('2d');
      const total = data.reduce((a, b) => a + b, 0); // 전체 합계
      const centerX = canvas.width / 2;
      const centerY = canvas.height / 2;
      const radius = 120; // 바깥 반지름
      const innerRadius = 70; // 안쪽 반지름

      let startAngle = -Math.PI / 2; // 12시 방향에서 시작

      // 각 아이템별로 도넛의 부분을 그림
      data.forEach((value, i) => {
        const sliceAngle = (value / total) * 2 * Math.PI; // 해당 아이템의 각도
        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, startAngle, startAngle + sliceAngle);
        ctx.arc(centerX, centerY, innerRadius, startAngle + sliceAngle, startAngle, true);
        ctx.closePath();
        
        // 티타늄(메탈릭) 효과
        if (i === metallicIndex) {
          // 원형 그라데이션 생성
          const grad = ctx.createRadialGradient(centerX, centerY, innerRadius, centerX, centerY, radius);
          grad.addColorStop(0, "#e0e0e0");
          grad.addColorStop(0.3, "#b0b0b0");
          grad.addColorStop(0.7, "#888");
          grad.addColorStop(1, "#f5f5f5");
          ctx.fillStyle = grad;
        } else {
          ctx.fillStyle = colors[i];
        }

        ctx.fill();
        ctx.restore();

        startAngle += sliceAngle;
      });
    }

    // 데이터와 색상 정의
    const data = [2, 5, 9]; // 2:5:9 비율
    const colors = ['#FEE500', '#03C75A', '#888']; // 각 아이템별 색상

    const metallicIndex = 2; // 3번째 아이템(티타늄)

    // 도넛 차트 그리기 호출
    drawDonutChart('donutChart', data, colors);
  </script>
</body>
</html>
