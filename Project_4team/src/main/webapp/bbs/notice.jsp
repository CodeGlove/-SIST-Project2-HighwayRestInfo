<%@ page import="mybatis.vo.BbsVO" %>
<%@ page import="bbs.util.Paging" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Insert title here</title>
  <style type="text/css">
    #bbs table {
      width:580px;
      margin-left:10px;
      border:1px solid black;
      border-collapse:collapse;
      font-size:14px;

    }

    #bbs table caption {
      font-size:20px;
      font-weight:bold;
      margin-bottom:10px;
    }

    #bbs table th,#bbs table td {
      text-align:center;
      border:1px solid black;
      padding:4px 10px;
    }

    .no {width:15%}
    .subject {width:30%}
    .writer {width:20%}
    .writeDate {width:20%}
    .modDate {width:20%}
    .del {width:15%}
    .title{background:#667eea}

    .odd {background:silver}

    /* paging */

    table tfoot ol.paging {
      list-style:none;
    }

    table tfoot ol.paging li {
      float:left;
      margin-right:8px;
    }

    table tfoot ol.paging li a {
      display:block;
      padding:3px 7px;
      border:1px solid #00B3DC;
      color:#2f313e;
      font-weight:bold;
    }

    table tfoot ol.paging li a:hover {
      background:#00B3DC;
      color:white;
      font-weight:bold;
    }

    .disable {
      padding:3px 7px;
      border:1px solid silver;
      color:silver;
    }

    .now {
      padding:3px 7px;
      border:1px solid #ff4aa5;
      background:#ff4aa5;
      color:white;
      font-weight:bold;
    }

  </style>
</head>
<body>
<!-- Back to Home Link -->
<a href="Controller?" class="back-home">
  <i class="fas fa-arrow-left"></i>
  홈으로 돌아가기
</a>

<div id="bbs">
  <table summary="공지사항 목록">
    <caption>공지사항</caption>
    <thead>
    <tr class="title">
      <th class="no">번호</th>
      <th class="subject">제목</th>
      <th class="writer">글쓴이</th>
      <th class="writeDate">작성일</th>
      <th class="modDate">수정일</th>
      <th class="del"></th>
    </tr>
    </thead>

    <tfoot>
    <tr>
      <td colspan="5">
        <ol class="paging">
          <c:set var="p" value="${requestScope.page}" scope="page"/>

          <c:if test="${p.startPage < p.pagePerBlock}">
            <li class="disable">&lt;</li>
          </c:if>
          <c:if test="${p.startPage >= p.pagePerBlock}">
            <li><a href="Controller?type=notice&cPage=${p.nowPage-p.pagePerBlock}">&lt;</a></li>
          </c:if>
          <c:forEach begin="${p.startPage}" end="${p.endPage}" var="pageNum">
            <c:if test="${p.nowPage == pageNum}">
              <li class="now">${pageNum}</li>
            </c:if>
            <c:if test="${p.nowPage != pageNum}">
              <li><a href="Controller?type=notice&cPage=${pageNum}">${pageNum}</a></li>
            </c:if>
          </c:forEach>

          <c:if test="${p.endPage < p.totalPage}">
            <li><a href="Controller?type=notice&cPage=${p.nowPage+p.pagePerBlock}">&gt;</a></li>
          </c:if>
          <c:if test="${p.endPage >= p.totalPage}">
            <li class="disable">&gt;</li>
          </c:if>
        </ol>
      </td>
      <td>
        <%--관리자일 경우에만 글쓰기 버튼 표시--%>
        <c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.authority
                      ne null and sessionScope.loginUser.authority == 1}">
          <input type="button" value="글쓰기"
                 onclick="javascript:location.href='Controller?type=write'"/>
        </c:if>
      </td>
    </tr>
    </tfoot>
    <tbody>
    <c:set var="ar" value="${requestScope.ar}"/>
    <c:set var="i" value="0"/>
    <c:forEach items="${ar}" var="vo" varStatus="vs">
      <c:set var="num" value="${p.totalCount -((p.nowPage-1)*p.numPerPage+vs.index)}"/>
      <tr>
        <td>${num}</td>
        <td style="text-align: left">
          <a href="Controller?type=view&PostNum=${vo.postNum}&cPage=${p.nowPage}">
              ${vo.subject}
          </a>
        </td>
        <td>${vo.writer}</td>
        <td>${vo.writeDate}</td>
        <td>${vo.modDate}</td>
        <td>
          <%--관리자일 경우 삭제 버튼 추가--%>
          <c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.authority
                        ne null and sessionScope.loginUser.authority == 1}">
            <input type="button" value="삭제"
                   onclick="delPost('${vo.postNum}', '${p.nowPage}')"/>
                           <%--location.href='Controller?type=del&PostNum=${vo.postNum}'"/>--%>
          </c:if>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>
<script>
  function delPost(postNum, cPage) {
    // 삭제할건지 물어봄
    //alert(`삭제할 글 번호: ${postNum}\n현재 페이지: ${cPage}`);
    if(confirm("정말로 삭제하시겠습니까?")){
      //"type=del"과 함께 PostNum, cPage를 전달하여 Controller 호출
      console.log(postNum, cPage)
      location.href = "Controller?type=del&PostNum=" + postNum + "&cPage=" + cPage;
    }
  }
</script>
</body>
</html>

