<%--
  Created by IntelliJ IDEA.
  User: js
  Date: 25. 7. 31.
  Time: 오전 9:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HighwayGuide - 관리 페이지</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
          rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/indexStyle.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/footerStyle.css" rel="stylesheet">
    <style>
        /* 관리 페이지 전용 스타일 */
        .manage-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 120px 2rem 4rem;
        }
        
        .manage-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .manage-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #222;
            margin-bottom: 1rem;
        }
        
        .manage-subtitle {
            font-size: 1.1rem;
            color: #666;
            margin-bottom: 2rem;
        }
        
        .manage-content {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }
        
        .chart-section {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            text-align: center;
        }
        
        .chart-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #222;
            margin-bottom: 1.5rem;
        }
        
        .chart-container {
            display: flex;
            justify-content: center;
            margin-bottom: 1rem;
        }
        
        .chart-legend {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            flex-wrap: wrap;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            color: #666;
        }
        
        .legend-color {
            width: 16px;
            height: 16px;
            border-radius: 50%;
        }
        
        .button-section {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .button-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #222;
            margin-bottom: 1.5rem;
        }
        
        .update-button {
            width: 100%;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        
        .update-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .update-button:active {
            transform: translateY(0);
        }
        
        .button-description {
            margin-top: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            color: #666;
            font-size: 0.9rem;
            line-height: 1.5;
        }
        
        @media (max-width: 768px) {
            .manage-content {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .manage-container {
                padding: 100px 1rem 2rem;
            }
        }
        
        @media (max-width: 1200px) {
            .manage-content {
                grid-template-columns: 1fr 1fr;
                gap: 2rem;
            }
        }
        
        /* 도넛 차트 텍스트 스타일 */
        .chart-text {
            font-family: 'Arial', sans-serif;
            text-align: center;
            text-baseline: middle;
        }
        
        .chart-percentage {
            font-weight: bold;
            font-size: 12px;
            color: #333;
        }
        
        .chart-total {
            font-weight: bold;
            font-size: 20px;
            color: #333;
        }
        
        /* 막대그래프 범례 스타일 */
        .chart-legend {
            margin-top: 1rem;
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            justify-content: center;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.25rem 0.5rem;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 4px;
            font-size: 0.875rem;
            color: #333;
        }
        
        .legend-color {
            width: 16px;
            height: 16px;
            border-radius: 2px;
            border: 1px solid #ddd;
        }
        
        .legend-text {
            font-weight: 500;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="nav-container">
            <a href="Controller" class="logo">
                <div class="logo-icon">
                    <i class="fas fa-road"></i>
                </div>
                HighwayGuide
            </a>
            <nav>
                <ul class="nav-links">
                    <li><a href="#">회사 소개</a></li>
                    <li><a href="#">공지사항</a></li>
                    <li><a href="#">고객센터</a></li>
                    <li><a href="#">자주 묻는 질문</a></li>
                    <li><a href="#">채용</a></li>
                </ul>
            </nav>
            <div class="auth-buttons">
                <a href="#" class="btn btn-login">KOR</a>
                <a href="#" class="btn btn-login">ENG</a>
                <a href="Controller?type=login" class="btn btn-login">로그인</a>
                <a href="Controller?type=register" class="btn btn-register">회원가입</a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="manage-container">
        <div class="manage-header">
            <h1 class="manage-title">관리 페이지</h1>
            <p class="manage-subtitle">시스템 현황을 한눈에 확인하고 관리하세요</p>
        </div>
        
        <div class="manage-content">
            <!-- 도넛 차트 섹션 -->
            <div class="chart-section">
                <h2 class="chart-title">회원 가입 플랫폼 현황</h2>
                <div class="chart-container">
                    <canvas id="donutChart" width="250" height="250"></canvas>
                </div>
                <div class="chart-legend">
                    <div class="legend-item">
                        <div class="legend-color" style="background: #FEE500;"></div>
                        <span>카카오 회원</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color" style="background: #03C75A;"></div>
                        <span>네이버 회원</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color" style="background: linear-gradient(to bottom, #8B5CF6, #667eea);"></div>
                        <span>자사 계정 회원</span>
                    </div>
                </div>
            </div>
            
            <!-- 즐겨찾기 휴게소 TOP 5 막대그래프 섹션 -->
            <div class="chart-section">
                <h2 class="chart-title">즐겨찾기 휴게소 TOP 5</h2>
                <div class="chart-container">
                    <canvas id="barChart" width="250" height="250"></canvas>
                </div>
                <div class="chart-legend" id="barChartLegend">
                    <!-- 범례가 동적으로 생성됩니다 -->
                </div>
                <div class="chart-description">
                    <i class="fas fa-heart"></i>
                    사용자들이 가장 많이 즐겨찾기한 휴게소 순위입니다.
                </div>
            </div>
            
            <!-- 버튼 섹션 -->
            <div class="button-section">
                <h2 class="button-title">데이터 업데이트</h2>
                <form method="post" action="Controller">
                    <input type="hidden" name="type" value="initSARA">
                    <button type="submit" class="update-button">
                        <i class="fas fa-sync-alt"></i>
                        휴게소, 입점업체 목록 업데이트
                    </button>
                </form>
                <div class="button-description">
                    <i class="fas fa-info-circle"></i>
                    최신 휴게소 정보와 입점업체 정보를 데이터베이스에 반영합니다.
                    업데이트는 수 분 정도 소요될 수 있습니다.
                </div>
            </div>
        </div>
    </main>

    <script>
        // ========================================
        // 도넛 차트 그리기 함수 (순차적 애니메이션)
        // ========================================
        // 
        // 호출 경로: 
        // 1. 페이지 로드 → DOMContentLoaded 이벤트
        // 2. fetchMemberData() → AJAX로 데이터 가져옴
        // 3. drawDonutChartWithAnimation() → 차트 그리기 시작
        //
        // 매개변수:
        // - canvasId: HTML의 canvas 요소 ID ('donutChart')
        // - data: 서버에서 받아온 배열 [카카오수, 네이버수, 자사계정수]
        // - colors: 각 조각별 색상 배열 ['#FEE500', '#03C75A', '#8B5CF6']
        function drawDonutChartWithAnimation(canvasId, data, colors) {
            // ========================================
            // 1. 캔버스 초기화 및 기본 설정
            // ========================================
            const canvas = document.getElementById(canvasId);  // HTML의 canvas 요소 가져오기
            const ctx = canvas.getContext('2d');             // 2D 그리기 컨텍스트 생성
            const total = data.reduce((a, b) => a + b, 0);  // 전체 회원 수 계산 (예: 156)
            
            // 캔버스 중심점 계산 (250x250 캔버스 기준)
            const centerX = canvas.width / 2;   // 125
            const centerY = canvas.height / 2;  // 125
            
            // 도넛 차트 크기 설정
            const radius = 100;       // 바깥쪽 반지름 (도넛 두께의 바깥 경계)
            const innerRadius = 50;   // 안쪽 반지름 (도넛 두께의 안쪽 경계)

            // ========================================
            // 2. 애니메이션 타이밍 설정
            // ========================================
            const durationPerSlice = 800;                    // 각 조각당 애니메이션 시간 (밀리초)
            const startTime = performance.now();             // 애니메이션 시작 시점 (타임스탬프)
            
            // ========================================
            // 3. 각 조각의 각도 정보 미리 계산
            // ========================================
            const sliceAngles = [];                          // 각 조각의 시작/끝 각도를 저장할 배열
            let currentAngle = -Math.PI / 2;                 // 12시 방향에서 시작 (-90도)
            
            // 각 데이터 값에 따라 도넛 조각의 각도 계산
            for (let i = 0; i < data.length; i++) {
                // 현재 조각이 차지할 각도 계산 (라디안 단위)
                const sliceAngle = (data[i] / total) * 2 * Math.PI;
                
                // 조각 정보를 객체로 저장
                sliceAngles.push({
                    start: currentAngle,                     // 조각 시작 각도
                    end: currentAngle + sliceAngle           // 조각 끝 각도
                });
                
                currentAngle += sliceAngle;                  // 다음 조각 시작 각도로 이동
            }

            // 애니메이션 프레임 그리기
            function drawFrame() {
                const elapsed = performance.now() - startTime;
                
                // 캔버스 지우기
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                
                // 각 조각 그리기
                for (let i = 0; i < sliceAngles.length; i++) {
                    const slice = sliceAngles[i];
                    
                    // 현재 조각의 시작 시간과 진행률
                    const sliceStartTime = i * durationPerSlice;
                    const sliceElapsed = elapsed - sliceStartTime;
                    const progress = Math.max(0, Math.min(sliceElapsed / durationPerSlice, 1));
                    
                    // 현재 그려야 할 끝 각도
                    const currentEnd = slice.start + (slice.end - slice.start) * progress;
                    
                    // 도넛 조각 그리기
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, slice.start, currentEnd);
                    ctx.arc(centerX, centerY, innerRadius, currentEnd, slice.start, true);
                    ctx.closePath();
                    
                    // 색상 설정 (3번째 아이템만 그라데이션)
                    if (i === 2) {
                        const grad = ctx.createLinearGradient(centerX, centerY - radius, centerX, centerY + radius);
                        grad.addColorStop(0, '#8B5CF6');   // 보라색
                        grad.addColorStop(1, '#667eea');   // 파란색
                        ctx.fillStyle = grad;
                    } else {
                        ctx.fillStyle = colors[i];
                    }
                    
                    ctx.fill();
                    
                    // 각 조각 안에 퍼센티지 텍스트 표시 (애니메이션 완료 후에만)
                    if (progress >= 1) {
                        const sliceCenterAngle = slice.start + (slice.end - slice.start) / 2;
                        const textRadius = (radius + innerRadius) / 2; // 텍스트 위치 (중간 반지름)
                        const textX = centerX + textRadius * Math.cos(sliceCenterAngle);
                        const textY = centerY + textRadius * Math.sin(sliceCenterAngle);

                        // 텍스트 스타일 설정
                        ctx.fillStyle = '#333'; // 텍스트 색상
                        ctx.font = 'bold 12px Arial'; // 폰트
                        ctx.textAlign = 'center'; // 가운데 정렬
                        ctx.textBaseline = 'middle'; // 세로 가운데 정렬
                        
                        // 퍼센티지 계산 및 표시
                        const percentage = Math.round((slice.end - slice.start) / (2 * Math.PI) * 100);
                        ctx.fillText(percentage + '%', textX, textY);
                    }
                }
                
                // ========================================
                // 4-4. 애니메이션 완료 후 추가 요소 표시
                // ========================================
                
                // 전체 애니메이션 지속 시간 계산
                const totalDuration = sliceAngles.length * durationPerSlice;  // 3 * 800 = 2400ms
                
                // ========================================
                // 4-4-1. 가운데 빈 공간에 총 합계 표시
                // ========================================
                // 모든 조각의 애니메이션이 완료되었는지 확인
                const allCompleted = elapsed >= totalDuration;
                if (allCompleted) {
                    console.log('애니메이션 완료! Total 표시:', total);
                    
                    // CSS 클래스 스타일 적용
                    ctx.fillStyle = '#333';              // 텍스트 색상
                    ctx.font = 'bold 20px Arial';       // 폰트 설정
                    ctx.textAlign = 'center';           // 가로 가운데 정렬
                    ctx.textBaseline = 'middle';        // 세로 가운데 정렬
                    
                    // "Total" 라벨과 총 회원 수를 가운데 표시
                    ctx.fillText('Total', centerX, centerY - 10);      // 위쪽에 "Total"
                    ctx.fillText(total.toString(), centerX, centerY + 10);  // 아래쪽에 숫자
                }
                
                // ========================================
                // 4-5. 다음 프레임 요청 여부 결정
                // ========================================
                // 애니메이션이 끝나지 않았다면 다음 프레임 요청
                if (elapsed < totalDuration) {
                    requestAnimationFrame(drawFrame);  // 60fps로 부드러운 애니메이션
                }
            }
            
            // ========================================
            // 5. 애니메이션 시작
            // ========================================
            // requestAnimationFrame으로 첫 프레임 요청
            // 이후 drawFrame 함수 내에서 연쇄적으로 다음 프레임 요청
            requestAnimationFrame(drawFrame);
        }

        // ========================================
        // 6. AJAX로 서버에서 회원 데이터 가져오기
        // ========================================
        // 
        // 호출 경로:
        // 1. DOMContentLoaded 이벤트 발생
        // 2. fetchMemberData() 함수 호출
        // 3. POST /Controller?type=getStatus 요청
        // 4. getStatusAction에서 DB 조회 후 JSON 응답
        // 5. 응답 데이터를 배열로 반환
        async function fetchMemberData() {
            try {
                // ========================================
                // 6-1. 서버에 HTTP POST 요청
                // ========================================
                const response = await fetch('Controller', {
                    method: 'POST',
                    // Content-Type은 기본값 application/x-www-form-urlencoded 사용
                    // 별도 headers 설정 불필요
                    
                    // POST 데이터: type과 chartType을 URLSearchParams로 전송
                    body: new URLSearchParams({
                        type: 'getStatus',        // Controller에서 getStatusAction 호출
                        chartType: 'donut'        // 향후 확장을 위한 구분자 (현재 미사용)
                    })
                });
                
                // ========================================
                // 6-2. HTTP 응답 상태 확인
                // ========================================
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                
                // ========================================
                // 6-3. JSON 응답 데이터 파싱
                // ========================================
                const data = await response.json();  // [카카오수, 네이버수, 자사계정수]
                console.log('가져온 회원 데이터:', data);
                return data;
                
            } catch (error) {
                // ========================================
                // 6-4. 에러 처리 및 기본값 반환
                // ========================================
                console.error('데이터 가져오기 실패:', error);
                // 네트워크 오류 시 기본 데이터로 차트 표시
                return [1, 1, 1];
            }
        }

        // ========================================
        // 7. 막대그래프 그리기 함수 (즐겨찾기 휴게소 TOP 5)
        // ========================================
        // 
        // 매개변수:
        // - canvasId: HTML의 canvas 요소 ID ('barChart')
        // - data: 서버에서 받아온 배열 [{name: '휴게소A', count: 45}, {name: '휴게소B', count: 45}, ...]
        // - colors: 각 휴게소별 색상 배열
        function drawBarChart(canvasId, data, colors) {
            const canvas = document.getElementById(canvasId);
            const ctx = canvas.getContext('2d');
            
            // ========================================
            // 7-1. 캔버스 설정 및 기본 변수
            // ========================================
            const canvasWidth = canvas.width;
            const canvasHeight = canvas.height;
            const padding = 40;  // 여백
            const chartWidth = canvasWidth - (padding * 2);
            const chartHeight = canvasHeight - (padding * 2);
            
            // ========================================
            // 7-2. 데이터 그룹화 (같은 즐겨찾기 수끼리 묶기)
            // ========================================
            const groupedData = [];
            const uniqueCounts = [...new Set(data.map(item => item.count))].sort((a, b) => b - a).slice(0, 5);
            
            uniqueCounts.forEach(count => {
                const itemsWithSameCount = data.filter(item => item.count === count);
                groupedData.push({
                    count: count,
                    items: itemsWithSameCount
                });
            });
            
            // ========================================
            // 7-3. 막대그래프 크기 계산
            // ========================================
            const maxValue = Math.max(...uniqueCounts);  // 최대값
            const barWidth = chartWidth / groupedData.length;  // 막대 너비
            const barSpacing = 10;  // 막대 간격
            
            // ========================================
            // 7-4. 막대그래프 그리기
            // ========================================
            ctx.clearRect(0, 0, canvasWidth, canvasHeight);
            
            // 각 막대 그리기
            groupedData.forEach((group, groupIndex) => {
                const barHeight = (group.count / maxValue) * chartHeight;
                const x = padding + (groupIndex * barWidth) + (barSpacing / 2);
                const y = canvasHeight - padding - barHeight;
                
                // 같은 즐겨찾기 수를 가진 휴게소들을 사선으로 분할
                if (group.items.length > 1) {
                    // 여러 휴게소가 있는 경우 사선으로 분할
                    group.items.forEach((item, itemIndex) => {
                        const colorIndex = data.findIndex(d => d.name === item.name) % colors.length;
                        
                        // 사선 패턴으로 분할된 막대 그리기
                        ctx.save(); // 현재 상태 저장
                        ctx.beginPath();
                        
                        // 사선 패턴 생성
                        const segmentWidth = (barWidth - barSpacing) / group.items.length;
                        const segmentX = x + (itemIndex * segmentWidth);
                        
                        // 사선 경로 그리기
                        ctx.moveTo(segmentX, y);
                        ctx.lineTo(segmentX + segmentWidth, y);
                        ctx.lineTo(segmentX + segmentWidth, y + barHeight);
                        ctx.lineTo(segmentX, y + barHeight);
                        ctx.closePath();
                        
                        // 색상 적용
                        ctx.fillStyle = colors[colorIndex];
                        ctx.fill();
                        
                        // 사선 구분선 그리기 (선택사항)
                        if (itemIndex > 0) {
                            ctx.strokeStyle = '#fff';
                            ctx.lineWidth = 2;
                            ctx.beginPath();
                            ctx.moveTo(segmentX, y);
                            ctx.lineTo(segmentX, y + barHeight);
                            ctx.stroke();
                        }
                        
                        ctx.restore(); // 상태 복원
                    });
                } else {
                    // 단일 휴게소인 경우 일반 막대
                    const colorIndex = data.findIndex(d => d.name === group.items[0].name) % colors.length;
                    ctx.fillStyle = colors[colorIndex];
                    ctx.fillRect(x, y, barWidth - barSpacing, barHeight);
                }
                
                // 막대 위에 수치 표시
                ctx.fillStyle = '#333';
                ctx.font = 'bold 12px Arial';
                ctx.textAlign = 'center';
                ctx.fillText(group.count.toString(), x + (barWidth - barSpacing) / 2, y - 5);
            });
            
            // Y축 눈금 그리기
            ctx.strokeStyle = '#ddd';
            ctx.lineWidth = 1;
            for (let i = 0; i <= 5; i++) {
                const y = padding + (i * chartHeight / 5);
                ctx.beginPath();
                ctx.moveTo(padding, y);
                ctx.lineTo(canvasWidth - padding, y);
                ctx.stroke();
                
                // Y축 값 표시
                const value = Math.round((maxValue / 5) * (5 - i));
                ctx.fillStyle = '#999';
                ctx.font = '10px Arial';
                ctx.textAlign = 'right';
                ctx.fillText(value.toString(), padding - 5, y + 3);
            }
        }

        // ========================================
        // 8. 범례 생성 함수
        // ========================================
        function createBarChartLegend(data, colors) {
            const legendContainer = document.getElementById('barChartLegend');
            legendContainer.innerHTML = '';
            
            // 디버깅을 위한 로그
            console.log('범례 생성 데이터:', data);
            console.log('범례 생성 색상:', colors);
            
            data.forEach((item, index) => {
                const colorIndex = index % colors.length;
                console.log(`범례 아이템 ${index}:`, item, '색상 인덱스:', colorIndex);
                
                const legendItem = document.createElement('div');
                legendItem.className = 'legend-item';
                legendItem.innerHTML = `
                    <span class="legend-color" style="background-color: ${colors[colorIndex]}"></span>
                    <span class="legend-text">${item.name}</span>
                `;
                legendContainer.appendChild(legendItem);
            });
        }

        // ========================================
        // 9. 페이지 로드 시 메인 실행 로직
        // ========================================
        // 
        // 실행 흐름:
        // 1. HTML 페이지 로드 완료
        // 2. DOMContentLoaded 이벤트 발생
        // 3. fetchMemberData() 호출하여 서버 데이터 가져오기
        // 4. 받은 데이터로 도넛 차트 애니메이션 시작
        // 5. 막대그래프 그리기 (임시 데이터로)
        // 6. 범례 생성
        document.addEventListener('DOMContentLoaded', async function() {
            // ========================================
            // 9-1. 서버에서 실제 회원 통계 데이터 가져오기
            // ========================================
            const memberData = await fetchMemberData();  // [카카오수, 네이버수, 자사계정수]
            
            // ========================================
            // 9-2. 각 조각별 색상 정의
            // ========================================
            const colors = [
                '#FEE500',  // 카카오 (노란색)
                '#03C75A',  // 네이버 (초록색)
                '#8B5CF6'   // 자사계정 (보라색, 그라데이션으로 처리됨)
            ];

            // ========================================
            // 9-3. 도넛 차트 애니메이션 시작
            // ========================================
            // canvas ID, 데이터 배열, 색상 배열을 전달하여 차트 그리기 시작
            drawDonutChartWithAnimation('donutChart', memberData, colors);
            
            // ========================================
            // 9-4. 막대그래프용 색상 배열 (5개 이상)
            // ========================================
            const barChartColors = [
                '#FF6B6B',  // 빨간색
                '#4ECDC4',  // 청록색
                '#45B7D1',  // 파란색
                '#96CEB4',  // 연두색
                '#FFEAA7',  // 노란색
                '#DDA0DD',  // 연보라색
                '#98D8C8',  // 민트색
                '#F7DC6F',  // 황금색
                '#BB8FCE',  // 보라색
                '#85C1E9'   // 하늘색
            ];
            
            // ========================================
            // 9-5. 막대그래프 그리기 (임시 데이터로)
            // ========================================
            // 나중에 DB에서 실제 데이터를 가져올 예정
            // 같은 즐겨찾기 수를 가진 휴게소들이 있을 수 있음
            const favoriteData = [
                {name: '휴게소A', count: 45},
                {name: '휴게소B', count: 45},  // 같은 즐겨찾기 수
                {name: '휴게소C', count: 38},
                {name: '휴게소D', count: 32},
                {name: '휴게소E', count: 28},
                {name: '휴게소F', count: 25}
            ];
            
            drawBarChart('barChart', favoriteData, barChartColors);
            createBarChartLegend(favoriteData, barChartColors);
        });
    </script>

    <!-- Footer Include -->
    <jsp:include page="footer.jsp" />
</body>
</html>
