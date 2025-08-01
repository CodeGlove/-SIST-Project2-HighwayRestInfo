<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // 한글 인코딩 설정
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚗 HighwayGuide - 휴게소 정보</title>

    <!-- 폰트 및 아이콘 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /* Pretendard 폰트 설정 */
        @font-face {
            font-family: 'PretendardVariable';
            src: url('fonts/PretendardVariable.woff2') format('woff2-variations');
            font-weight: 45 920;
            font-style: normal;
            font-display: swap;
        }

        /* 기본 스타일 리셋 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* 전체적인 바디 스타일 */
        body {
            font-family: 'PretendardVariable', 'Inter', sans-serif;
            background: linear-gradient(180deg, #f0f8ff 0%, #ffffff 100%);
            color: #222;
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* 상단 헤더 스타일 */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            z-index: 1000;
            padding: 1rem 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }

        /* 네비게이션 컨테이너 */
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* 로고 스타일 */
        .logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            color: #222;
            font-weight: 700;
            font-size: 1.5rem;
        }

        .logo-icon {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1rem;
        }

        /* 뒤로가기 버튼 */
        .back-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            color: #666;
            font-weight: 500;
            transition: color 0.2s;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            background: rgba(102, 126, 234, 0.1);
        }

        .back-btn:hover {
            color: #667eea;
            background: rgba(102, 126, 234, 0.15);
        }

        /* 메인 컨테이너 */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 8rem 2rem 4rem;
        }

        /* 페이지 제목 */
        .page-title {
            text-align: center;
            margin-bottom: 3rem;
        }

        .page-title h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #222;
            margin-bottom: 1rem;
        }

        .page-title p {
            font-size: 1.1rem;
            color: #666;
        }

        /* 탭 컨테이너 */
        .tab-container {
            margin-bottom: 3rem;
        }

        /* 탭 버튼들 */
        .tab-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            justify-content: center;
        }

        .tab-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            background: #fff;
            border: 2px solid #e5e8eb;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .tab-btn:hover {
            border-color: #667eea;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(102, 126, 234, 0.2);
        }

        .tab-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border-color: #667eea;
            box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3);
        }

        .tab-count {
            background: rgba(255, 255, 255, 0.2);
            color: inherit;
            padding: 0.2rem 0.6rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 700;
        }

        .tab-btn:not(.active) .tab-count {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
        }

        /* 탭 콘텐츠 */
        .tab-content {
            position: relative;
        }

        .tab-pane {
            display: none;
            animation: fadeIn 0.3s ease-out;
        }

        .tab-pane.active {
            display: block;
        }

        /* 정보 카드 그리드 */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        /* 개별 정보 카드 */
        .info-card {
            background: #fff;
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }

        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .card-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.2rem;
        }

        .card-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #222;
        }

        .card-count {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: auto;
        }

        /* 리스트 스타일 */
        .info-list {
            list-style: none;
        }

        .info-item {
            padding: 1rem;
            border: 1px solid #e5e8eb;
            border-radius: 8px;
            margin-bottom: 0.8rem;
            background: #f8fafc;
            transition: all 0.2s;
        }

        .info-item:hover {
            background: #fff;
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
        }

        .info-item:last-child {
            margin-bottom: 0;
        }

        .item-name {
            font-weight: 600;
            color: #222;
            margin-bottom: 0.3rem;
        }

        .item-details {
            font-size: 0.9rem;
            color: #666;
        }

        /* 빈 상태 메시지 */
        .empty-message {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        .empty-icon {
            font-size: 3rem;
            color: #ccc;
            margin-bottom: 1rem;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .main-container {
                padding: 6rem 1rem 2rem;
            }

            .page-title h1 {
                font-size: 2rem;
            }

            .tab-buttons {
                flex-direction: column;
                align-items: center;
            }

            .tab-btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .nav-container {
                padding: 0 1rem;
            }
        }

        /* 애니메이션 */
        .fade-in {
            animation: fadeIn 1s ease-out;
        }

        .slide-up {
            animation: slideUp 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <header class="header">
        <div class="nav-container">
            <a href="index.jsp" class="logo">
                <div class="logo-icon">
                    <i class="fas fa-road"></i>
                </div>
                HighwayGuide
            </a>
            <a href="kakaoMap.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i>
                길찾기로 돌아가기
            </a>
        </div>
    </header>

    <!-- 메인 컨테이너 -->
    <div class="main-container">
        <!-- 페이지 제목 -->
        <div class="page-title fade-in">
            <h1><i class="fas fa-map-marked-alt"></i> 경로상 휴게시설 정보</h1>
            <p>발견된 휴게소와 졸음쉼터 정보를 확인하세요</p>
        </div>

        <!-- 탭 컨테이너 -->
        <div class="tab-container slide-up">
            <!-- 탭 버튼들 -->
            <div class="tab-buttons">
                <button class="tab-btn active" data-tab="rest-areas">
                    <i class="fas fa-utensils"></i>
                    휴게소
                    <span class="tab-count">
                        <c:choose>
                            <c:when test="${not empty restAreas}">${restAreas.size()}개</c:when>
                            <c:otherwise>0개</c:otherwise>
                        </c:choose>
                    </span>
                </button>
                <button class="tab-btn" data-tab="rest-stops">
                    <i class="fas fa-bed"></i>
                    졸음쉼터
                    <span class="tab-count">
                        <c:choose>
                            <c:when test="${not empty restStops}">${restStops.size()}개</c:when>
                            <c:otherwise>0개</c:otherwise>
                        </c:choose>
                    </span>
                </button>
            </div>

            <!-- 탭 콘텐츠 -->
            <div class="tab-content">
                <!-- 휴게소 탭 -->
                <div id="rest-areas" class="tab-pane active">
                    <div class="info-card">
                        <div class="card-header">
                            <div class="card-icon">
                                <i class="fas fa-utensils"></i>
                            </div>
                            <div class="card-title">휴게소 목록</div>
                        </div>
                        
                        <c:choose>
                            <c:when test="${not empty restAreas}">
                                <ul class="info-list">
                                    <c:forEach var="restArea" items="${restAreas}" varStatus="status">
                                        <li class="info-item">
                                            <div class="item-name">
                                                <i class="fas fa-map-marker-alt" style="color: #667eea; margin-right: 0.5rem;"></i>
                                                <c:out value="${restArea}"/>
                                            </div>
                                            <div class="item-details">
                                                휴게시설 #${status.index + 1}
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-message">
                                    <div class="empty-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <p>경로상 휴게소가 발견되지 않았습니다.</p>
                                    <p style="font-size: 0.9rem; color: #999; margin-top: 0.5rem;">
                                        다른 경로를 시도해보세요.
                                    </p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 졸음쉼터 탭 -->
                <div id="rest-stops" class="tab-pane">
                    <div class="info-card">
                        <div class="card-header">
                            <div class="card-icon">
                                <i class="fas fa-bed"></i>
                            </div>
                            <div class="card-title">졸음쉼터 목록</div>
                        </div>
                        
                        <c:choose>
                            <c:when test="${not empty restStops}">
                                <ul class="info-list">
                                    <c:forEach var="restStop" items="${restStops}" varStatus="status">
                                        <li class="info-item">
                                            <div class="item-name">
                                                <i class="fas fa-map-marker-alt" style="color: #667eea; margin-right: 0.5rem;"></i>
                                                <c:out value="${restStop}"/>
                                            </div>
                                            <div class="item-details">
                                                졸음쉼터 #${status.index + 1}
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-message">
                                    <div class="empty-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <p>경로상 졸음쉼터가 발견되지 않았습니다.</p>
                                    <p style="font-size: 0.9rem; color: #999; margin-top: 0.5rem;">
                                        다른 경로를 시도해보세요.
                                    </p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- 추가 정보 섹션 -->
        <c:if test="${not empty restAreas or not empty restStops}">
            <div class="info-card slide-up" style="margin-top: 2rem;">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-info-circle"></i>
                    </div>
                    <div class="card-title">정보 안내</div>
                </div>
                <div style="color: #666; line-height: 1.6;">
                    <p><strong>휴게소:</strong> 주유소, 충전소, 음식점, 화장실 등 편의시설이 구비된 휴게공간</p>
                    <p><strong>졸음쉼터:</strong> 운전 중 졸음 방지를 위한 임시 휴식 공간</p>
                    <p style="margin-top: 1rem; font-size: 0.9rem; color: #999;">
                        <i class="fas fa-lightbulb"></i> 안전한 운전을 위해 정기적인 휴식을 취하세요.
                    </p>
                </div>
            </div>
        </c:if>
    </div>

    <script>
        // DOM이 완전히 로드된 후에 스크립트 실행
        document.addEventListener('DOMContentLoaded', function() {
            // 탭 기능 구현
            const tabButtons = document.querySelectorAll('.tab-btn');
            const tabPanes = document.querySelectorAll('.tab-pane');

            tabButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const targetTab = this.getAttribute('data-tab');
                    
                    // 모든 탭 버튼에서 active 클래스 제거
                    tabButtons.forEach(btn => btn.classList.remove('active'));
                    
                    // 모든 탭 패널에서 active 클래스 제거
                    tabPanes.forEach(pane => pane.classList.remove('active'));
                    
                    // 클릭된 버튼에 active 클래스 추가
                    this.classList.add('active');
                    
                    // 해당 탭 패널에 active 클래스 추가
                    const targetPane = document.getElementById(targetTab);
                    if (targetPane) {
                        targetPane.classList.add('active');
                    }
                });
            });

            // 카드 애니메이션 효과
            const cards = document.querySelectorAll('.info-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });

            // 리스트 아이템 호버 효과
            const listItems = document.querySelectorAll('.info-item');
            listItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(5px)';
                });
                
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0)';
                });
            });
        });
    </script>
</body>
</html>
