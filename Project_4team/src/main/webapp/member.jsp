<%--
  Created by IntelliJ IDEA.
  User: js
  Date: 25. 8. 19.
  Time: 오전 11:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Main Content -->
<div class="manage-container">
    <div class="manage-header">
        <h1 class="manage-title">회원 관리</h1>
        <p class="manage-subtitle">전체 회원 목록을 확인하고 관리하세요</p>
    </div>
    
    <div class="manage-content">
        <!-- 검색 및 필터 섹션 -->
        <div class="search-section">
            <div class="search-container">
                <div class="search-input-group">
                    <input type="text" id="searchInput" placeholder="이름, 이메일, ID로 검색..." class="search-input">
                    <button type="button" id="searchBtn" class="search-button">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
                
                <div class="filter-group">
                    <select id="platformFilter" class="filter-select">
                        <option value="">전체 플랫폼</option>
                        <option value="KAKAO">카카오</option>
                        <option value="NAVER">네이버</option>
                        <option value="ORIGIN">자사계정</option>
                    </select>
                    
                    <select id="sortFilter" class="filter-select">
                        <option value="joinDate">가입일순</option>
                        <option value="name">이름순</option>
                        <option value="platform">플랫폼순</option>
                    </select>
                </div>
            </div>
        </div>
        
        <!-- 회원 목록 테이블 -->
        <div class="member-table-section">
            <div class="member-stats">
                <span class="stats-item">
                    <i class="fas fa-users"></i>
                    전체 회원: <span id="totalMembers">6</span>명
                </span>
                <span class="stats-item">
                    <i class="fas fa-user-check"></i>
                    활성 회원: <span id="activeMembers">6</span>명
                </span>
            </div>
            
            <div class="member-grid" id="memberGrid">
                <!-- 회원 카드들이 정적으로 생성됩니다 -->
            </div>
        </div>
        
        <!-- 페이지네이션 -->
        <div class="pagination-section">
            <div class="pagination" id="pagination">
                <!-- 페이지 번호들이 정적으로 생성됩니다 -->
            </div>
        </div>
    </div>
</div>

<!-- 회원 탈퇴 확인 모달 -->
<div id="deleteModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>회원 탈퇴 확인</h3>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <p>정말로 <strong id="deleteMemberName"></strong> 회원을 탈퇴 처리하시겠습니까?</p>
            <p class="warning-text">이 작업은 되돌릴 수 없습니다.</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-cancel" id="cancelDelete">취소</button>
            <button type="button" class="btn btn-delete" id="confirmDelete">탈퇴 처리</button>
        </div>
    </div>
</div>

<style>
    /* 회원 관리 전용 스타일 */
    .member-content {
        max-width: 1200px;
        margin: 0 auto;
    }
    
    /* manage-content 스타일 오버라이드 - 1열 레이아웃으로 변경 */
    .manage-content {
        display: block !important;
        grid-template-columns: 1fr !important;
        gap: 2rem !important;
        margin-bottom: 3rem !important;
    }
    
    /* 검색 및 필터 섹션 */
    .search-section {
        background: white;
        border-radius: 16px;
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    }
    
    .search-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 2rem;
    }
    
    .search-input-group {
        display: flex;
        flex: 1;
        max-width: 400px;
    }
    
    .search-input {
        flex: 1;
        padding: 0.75rem 1rem;
        border: 2px solid #e1e5e9;
        border-radius: 8px 0 0 8px;
        font-size: 1rem;
        transition: border-color 0.3s ease;
    }
    
    .search-input:focus {
        outline: none;
        border-color: #667eea;
    }
    
    .search-button {
        padding: 0.75rem 1.5rem;
        background: #667eea;
        color: white;
        border: none;
        border-radius: 0 8px 8px 0;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }
    
    .search-button:hover {
        background: #5a6fd8;
    }
    
    .filter-group {
        display: flex;
        gap: 1rem;
    }
    
    .filter-select {
        padding: 0.75rem 1rem;
        border: 2px solid #e1e5e9;
        border-radius: 8px;
        font-size: 1rem;
        background: white;
        cursor: pointer;
        transition: border-color 0.3s ease;
    }
    
    .filter-select:focus {
        outline: none;
        border-color: #667eea;
    }
    
    /* 회원 통계 */
    .member-stats {
        display: flex;
        gap: 2rem;
        margin-bottom: 1.5rem;
        padding: 1rem 0;
    }
    
    .stats-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 1rem;
        color: #666;
    }
    
    .stats-item i {
        color: #667eea;
    }
    
    /* 회원 그리드 */
    .member-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }
    
    .member-card {
        background: white;
        border-radius: 12px;
        padding: 1.5rem;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        transition: all 0.3s ease;
        cursor: pointer;
        border: 2px solid transparent;
    }
    
    .member-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        border-color: #667eea;
    }
    
    .member-header {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-bottom: 1rem;
    }
    
    .member-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        color: white;
        font-weight: bold;
    }
    
    .avatar-kakao {
        background: #FEE500;
        color: #333;
    }
    
    .avatar-naver {
        background: #03C75A;
    }
    
    .avatar-origin {
        background: linear-gradient(135deg, #8B5CF6, #667eea);
    }
    
    .member-info {
        flex: 1;
    }
    
    .member-name {
        font-size: 1.1rem;
        font-weight: 600;
        color: #222;
        margin-bottom: 0.25rem;
    }
    
    .member-email {
        font-size: 0.9rem;
        color: #666;
        margin-bottom: 0.25rem;
    }
    
    .member-platform {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: 500;
        color: white;
    }
    
    .platform-kakao {
        background: #FEE500;
        color: #333;
    }
    
    .platform-naver {
        background: #03C75A;
    }
    
    .platform-origin {
        background: linear-gradient(135deg, #8B5CF6, #667eea);
    }
    
    .member-details {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
        margin-top: 1rem;
        padding-top: 1rem;
        border-top: 1px solid #f0f0f0;
    }
    
    .detail-item {
        text-align: center;
    }
    
    .detail-label {
        font-size: 0.8rem;
        color: #999;
        margin-bottom: 0.25rem;
    }
    
    .detail-value {
        font-size: 0.9rem;
        color: #333;
        font-weight: 500;
    }
    
    /* 페이지네이션 */
    .pagination-section {
        display: flex;
        justify-content: center;
        margin-top: 2rem;
    }
    
    .pagination {
        display: flex;
        gap: 0.5rem;
    }
    
    .page-btn {
        padding: 0.5rem 1rem;
        border: 2px solid #e1e5e9;
        background: white;
        color: #666;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
        font-size: 0.9rem;
    }
    
    .page-btn:hover {
        border-color: #667eea;
        color: #667eea;
    }
    
    .page-btn.active {
        background: #667eea;
        border-color: #667eea;
        color: white;
    }
    
    .page-btn:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }
    
    /* 모달 스타일 */
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
    }
    
    .modal-content {
        background-color: white;
        margin: 15% auto;
        padding: 0;
        border-radius: 12px;
        width: 90%;
        max-width: 500px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    }
    
    .modal-header {
        padding: 1.5rem 1.5rem 1rem;
        border-bottom: 1px solid #f0f0f0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .modal-header h3 {
        margin: 0;
        color: #222;
        font-size: 1.3rem;
    }
    
    .close {
        color: #aaa;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        line-height: 1;
    }
    
    .close:hover {
        color: #000;
    }
    
    .modal-body {
        padding: 1.5rem;
        color: #666;
        line-height: 1.6;
    }
    
    .warning-text {
        color: #e74c3c;
        font-weight: 500;
        margin-top: 1rem;
        padding: 0.75rem;
        background: #fdf2f2;
        border-radius: 6px;
        border-left: 4px solid #e74c3c;
    }
    
    .modal-footer {
        padding: 1rem 1.5rem 1.5rem;
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
    }
    
    .btn {
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: 8px;
        font-size: 1rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    
    .btn-cancel {
        background: #f8f9fa;
        color: #666;
        border: 2px solid #e1e5e9;
    }
    
    .btn-cancel:hover {
        background: #e9ecef;
        border-color: #adb5bd;
    }
    
    .btn-delete {
        background: #e74c3c;
        color: white;
    }
    
    .btn-delete:hover {
        background: #c0392b;
    }
    
    /* 반응형 디자인 */
    @media (max-width: 768px) {
        .search-container {
            flex-direction: column;
            align-items: stretch;
        }
        
        .filter-group {
            justify-content: center;
        }
        
        .member-grid {
            grid-template-columns: 1fr;
        }
        
        .member-details {
            grid-template-columns: 1fr;
        }
    }
</style>

<script>
    // ========================================
    // 회원 관리 페이지 JavaScript (간단 버전)
    // ========================================
    
    // 전역 변수
    let selectedMemberId = null;
    
    // ========================================
    // 1. 페이지 로드 시 초기화
    // ========================================
    document.addEventListener('DOMContentLoaded', function() {
        createMemberCards();
        createPagination();
        setupEventListeners();
    });
    
    // ========================================
    // 2. 회원 카드 생성 (정적 데이터)
    // ========================================
    function createMemberCards() {
        const memberGrid = document.getElementById('memberGrid');
        if (!memberGrid) return;
        
        const members = [
            {
                id: 1,
                name: '김철수',
                email: 'kim@example.com',
                platform: 'KAKAO',
                joinDate: '2024-01-15',
                lastLogin: '2024-08-19'
            },
            {
                id: 2,
                name: '이영희',
                email: 'lee@example.com',
                platform: 'NAVER',
                joinDate: '2024-02-20',
                lastLogin: '2024-08-18'
            },
            {
                id: 3,
                name: '박민수',
                email: 'park@example.com',
                platform: 'ORIGIN',
                joinDate: '2024-03-10',
                lastLogin: '2024-08-17'
            },
            {
                id: 4,
                name: '정수진',
                email: 'jung@example.com',
                platform: 'KAKAO',
                joinDate: '2024-04-05',
                lastLogin: '2024-08-16'
            },
            {
                id: 5,
                name: '최동현',
                email: 'choi@example.com',
                platform: 'NAVER',
                joinDate: '2024-05-12',
                lastLogin: '2024-08-15'
            },
            {
                id: 6,
                name: '한지민',
                email: 'han@example.com',
                platform: 'ORIGIN',
                joinDate: '2024-06-08',
                lastLogin: '2024-08-14'
            }
        ];
        
        memberGrid.innerHTML = '';
        
        members.forEach(member => {
            const memberCard = document.createElement('div');
            memberCard.className = 'member-card';
            memberCard.onclick = () => showDeleteModal(member);
            
            const platformClass = getPlatformClass(member.platform);
            const platformLabel = getPlatformLabel(member.platform);
            const avatarIcon = getAvatarIcon(member.platform);
            
            memberCard.innerHTML = `
                <div class="member-header">
                    <div class="member-avatar ${platformClass}">
                        ${avatarIcon}
                    </div>
                    <div class="member-info">
                        <div class="member-name">${member.name}</div>
                        <div class="member-email">${member.email}</div>
                        <span class="member-platform ${platformClass}">${platformLabel}</span>
                    </div>
                </div>
                <div class="member-details">
                    <div class="detail-item">
                        <div class="detail-label">가입일</div>
                        <div class="detail-value">${formatDate(member.joinDate)}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">최근 로그인</div>
                        <div class="detail-value">${formatDate(member.lastLogin)}</div>
                    </div>
                </div>
            `;
            
            memberGrid.appendChild(memberCard);
        });
    }
    
    // ========================================
    // 3. 페이지네이션 생성
    // ========================================
    function createPagination() {
        const pagination = document.getElementById('pagination');
        if (!pagination) return;
        
        pagination.innerHTML = `
            <button class="page-btn" disabled>이전</button>
            <button class="page-btn active">1</button>
            <button class="page-btn" disabled>다음</button>
        `;
    }
    
    // ========================================
    // 4. 플랫폼별 스타일 클래스 반환
    // ========================================
    function getPlatformClass(platform) {
        switch(platform) {
            case 'KAKAO': return 'avatar-kakao';
            case 'NAVER': return 'avatar-naver';
            case 'ORIGIN': return 'avatar-origin';
            default: return 'avatar-origin';
        }
    }
    
    function getPlatformLabel(platform) {
        switch(platform) {
            case 'KAKAO': return '카카오';
            case 'NAVER': return '네이버';
            case 'ORIGIN': return '자사계정';
            default: return '자사계정';
        }
    }
    
    function getAvatarIcon(platform) {
        switch(platform) {
            case 'KAKAO': return 'K';
            case 'NAVER': return 'N';
            case 'ORIGIN': return 'H';
            default: return 'H';
        }
    }
    
    // ========================================
    // 5. 날짜 포맷팅
    // ========================================
    function formatDate(dateString) {
        if (!dateString) return '-';
        const date = new Date(dateString);
        return date.toLocaleDateString('ko-KR', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit'
        });
    }
    
    // ========================================
    // 6. 이벤트 리스너 설정
    // ========================================
    function setupEventListeners() {
        // 모달 닫기
        const closeBtn = document.querySelector('.close');
        const cancelBtn = document.getElementById('cancelDelete');
        const confirmBtn = document.getElementById('confirmDelete');
        
        if (closeBtn) {
            closeBtn.addEventListener('click', closeModal);
        }
        
        if (cancelBtn) {
            cancelBtn.addEventListener('click', closeModal);
        }
        
        if (confirmBtn) {
            confirmBtn.addEventListener('click', confirmDeleteMember);
        }
        
        // 모달 외부 클릭 시 닫기
        window.addEventListener('click', function(e) {
            if (e.target === document.getElementById('deleteModal')) {
                closeModal();
            }
        });
    }
    
    // ========================================
    // 7. 탈퇴 모달 표시
    // ========================================
    function showDeleteModal(member) {
        selectedMemberId = member.id;
        const deleteMemberName = document.getElementById('deleteMemberName');
        if (deleteMemberName) {
            deleteMemberName.textContent = member.name;
        }
        
        const modal = document.getElementById('deleteModal');
        if (modal) {
            modal.style.display = 'block';
        }
    }
    
    // ========================================
    // 8. 모달 닫기
    // ========================================
    function closeModal() {
        const modal = document.getElementById('deleteModal');
        if (modal) {
            modal.style.display = 'none';
        }
        selectedMemberId = null;
    }
    
    // ========================================
    // 9. 회원 탈퇴 확인
    // ========================================
    function confirmDeleteMember() {
        if (!selectedMemberId) return;
        
        alert('회원 탈퇴 처리가 완료되었습니다. (실제 구현 시 서버 요청 필요)');
        closeModal();
        
        // 실제 구현 시에는 여기서 AJAX 요청을 보내고
        // 성공 시 해당 회원 카드를 DOM에서 제거
    }
</script>
