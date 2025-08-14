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
        <nav>
            <ul class="nav-links">
                <li><a href="#">회사 소개</a></li>
                <li><a href="Controller?type=notice" class="btn btn-notice">공지사항</a></li>
                <%--08.04-한결 수정--%>
                <li><a href="#">고객센터</a></li>
                <li><a href="#">자주 묻는 질문</a></li>
                <li><a href="#">채용</a></li>
            </ul>
        </nav>
        <div class="auth-buttons">
            <a href="#" class="btn btn-login">KOR</a>
            <a href="#" class="btn btn-login">ENG</a>
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
