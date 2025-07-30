<%@ page import="restinfo.dao.RestDAO" %>
<%@ page import="mybatis.vo.UserVO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  //파라미터 받기
  String Id = request.getParameter("userId");
  String Pw = request.getParameter("userPw");

  if(Id != null && Pw != null){
    UserVO loginVO = RestDAO.login(Id, Pw);
    if(loginVO != null){
      //로그인 성공 시
      session.setAttribute("loginVO", loginVO); //HttpSession에 vo를 RestinfoVO를 저장한다.
    }
    response.sendRedirect("index.jsp?type=login_true");
  } else {
    // 로그인 실패 시
    response.sendRedirect("index.jsp");
  }
%>
