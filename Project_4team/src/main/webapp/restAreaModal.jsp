<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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