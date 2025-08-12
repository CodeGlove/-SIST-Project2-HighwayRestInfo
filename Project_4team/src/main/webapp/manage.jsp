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
    <link href="css/indexStyle.css" rel="stylesheet">
    <link href="css/footerStyle.css" rel="stylesheet">
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
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
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
        // 도넛 차트 그리기 함수
        function drawDonutChart(canvasId, data, colors) {
            const canvas = document.getElementById(canvasId);
            const ctx = canvas.getContext('2d');
            const total = data.reduce((a, b) => a + b, 0); // 전체 합계
            const centerX = canvas.width / 2;
            const centerY = canvas.height / 2;
            const radius = 100; // 바깥 반지름
            const innerRadius = 60; // 안쪽 반지름

            let startAngle = -Math.PI / 2; // 12시 방향에서 시작

            // 각 아이템별로 도넛의 부분을 그림
            data.forEach((value, i) => {
                const sliceAngle = (value / total) * 2 * Math.PI; // 해당 아이템의 각도
                ctx.beginPath();
                ctx.arc(centerX, centerY, radius, startAngle, startAngle + sliceAngle);
                ctx.arc(centerX, centerY, innerRadius, startAngle + sliceAngle, startAngle, true);
                ctx.closePath();
                
                // 그라데이션 효과 - 3번째 아이템
                if (i === 2) {
                    // 수직 선형 그라데이션 생성 - 20단계 보라색 그라데이션
                    const grad = ctx.createLinearGradient(centerX, centerY - radius, centerX, centerY + radius);
                    
                    // 시작 색상 (밝은 보라색)
                    const startColor = { r: 139, g: 92, b: 246 }; // #8B5CF6
                    // 끝 색상 (파란색)
                    const endColor = { r: 102, g: 126, b: 234 }; // #667eea
                    
                    // 20단계 그라데이션 생성
                    for (let step = 0; step <= 20; step++) {
                        const ratio = step / 20;
                        const r = Math.round(startColor.r + (endColor.r - startColor.r) * ratio);
                        const g = Math.round(startColor.g + (endColor.g - startColor.g) * ratio);
                        const b = Math.round(startColor.b + (endColor.b - startColor.b) * ratio);
                        
                        // 디버깅용 콘솔 로그
                        console.log(`Step ${step}: r=${r}, g=${g}, b=${b}`);
                        
                        // 변수 스코프 문제 해결을 위해 직접 문자열 생성
                        const color = 'rgb(' + r + ', ' + g + ', ' + b + ')';
                        grad.addColorStop(ratio, color);
                    }
                    
                    ctx.fillStyle = grad;
                } else {
                    ctx.fillStyle = colors[i];
                }

                ctx.fill();
                startAngle += sliceAngle;
            });
        }

        // AJAX로 회원 데이터 가져오기
        async function fetchMemberData() {
            try {
                const response = await fetch('Controller?type=getStatus', {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                });
                
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                
                const data = await response.json();
                console.log('가져온 회원 데이터:', data);
                return data;
                
            } catch (error) {
                console.error('데이터 가져오기 실패:', error);
                // 에러 발생 시 기본 데이터 반환
                return [1, 1, 1];
            }
        }

        // 페이지 로드 시 도넛 차트 그리기
        document.addEventListener('DOMContentLoaded', async function() {
            // AJAX로 실제 데이터 가져오기
            const memberData = await fetchMemberData();
            const colors = ['#FEE500', '#03C75A', '#8B5CF6']; // 카카오, 네이버, 보라색

            // 도넛 차트 그리기 호출
            drawDonutChart('donutChart', memberData, colors);
        });
    </script>

    <!-- Footer Include -->
    <jsp:include page="footer.jsp" />
</body>
</html>
