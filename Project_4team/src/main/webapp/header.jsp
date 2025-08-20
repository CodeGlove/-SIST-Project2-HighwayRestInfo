<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Header -->
<header class="header">
    <div class="nav-container">
        <a href="Controller" class="logo">
            <div class="logo-icon">
                <i class="fas fa-road"></i>
            </div>
            HighwayGuide
        </a>
        <nav class="main-nav">
            <ul class="nav-links">
                <li><a href="Controller?type=notice" class="nav-link">공지사항</a></li>
                <li><a href="#" class="nav-link">휴게소 정보</a></li>
                <li><a href="#" class="nav-link">교통정보</a></li>
                <li><a href="#" class="nav-link">고객센터</a></li>
                <li><a href="#" class="nav-link">도움말</a></li>
            </ul>
        </nav>
        <div class="auth-buttons">
            <%--***** 로그인 되지 않은 경우 --%>
            <c:if test="${empty sessionScope.loginUser}">
                <a href="Controller?type=login" class="btn btn-login">로그인</a>
                <a href="Controller?type=register" class="btn btn-register">회원가입</a>
            </c:if>

            <%--***** 로그인된 경우 --%>
            <c:if test="${not empty sessionScope.loginUser}">
                <a href="Controller?type=logout" class="btn btn-logout">로그아웃</a>
                <a href="Controller?type=#" class="btn btn-register">마이페이지</a>
            </c:if>
        </div>
    </div>
</header>
