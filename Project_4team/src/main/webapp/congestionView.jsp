<%-- src/main/webapp/view/congestionView.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.JsonObject" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>휴게소 혼잡도 정보</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; color: #333; }
    .container { background-color: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 600px; margin: 30px auto; }
    h1, h2 { color: #0056b3; }
    pre { background-color: #e9e9e9; padding: 15px; border-radius: 5px; overflow-x: auto; }
    .level-1 { color: green; font-weight: bold; }
    .level-2 { color: orange; font-weight: bold; }
    .level-3 { color: red; font-weight: bold; }
    .level-4 { color: darkred; font-weight: bold; }
    .error { color: #d9534f; font-weight: bold; }
    .info-box { border: 1px solid #ccc; padding: 15px; border-radius: 5px; margin-top: 20px; background-color: #f9f9f9; }
  </style>
</head>
<body>
<div class="container">
  <h1>휴게소 혼잡도 정보</h1>

  <%
    String congestionDataJson = (String) request.getAttribute("congestionData");

    // Null 체크: 데이터가 유효한지 확인합니다.
    if (congestionDataJson != null && !congestionDataJson.trim().isEmpty()) {

      Gson gson = new Gson();
      JsonObject data = gson.fromJson(congestionDataJson, JsonObject.class);

      // JSON 파싱 후, 다시 한번 Null 체크
      if (data != null && data.has("status")) {
        String status_code = data.getAsJsonObject("status").get("code").getAsString();
        String status_message = data.getAsJsonObject("status").get("message").getAsString();
  %>

  <c:choose>
    <c:when test="<%= status_code.equals(\"00\") %>">
      <%
        JsonObject contents = data.getAsJsonObject("contents");
        String poiName = contents.get("poiName").getAsString();
        JsonObject rltm = contents.getAsJsonArray("rltm").get(0).getAsJsonObject();
        int congestionLevel = rltm.get("congestionLevel").getAsInt();
        String datetime = rltm.get("datetime").getAsString();

        String levelText = "";
        String levelClass = "";
        switch (congestionLevel) {
          case 1: levelText = "여유"; levelClass = "level-1"; break;
          case 2: levelText = "보통"; levelClass = "level-2"; break;
          case 3: levelText = "혼잡"; levelClass = "level-3"; break;
          case 4: levelText = "매우 혼잡"; levelClass = "level-4"; break;
          default: levelText = "알 수 없음"; levelClass = ""; break;
        }
      %>
      <h2>장소 이름: <%= poiName %></h2>
      <p>현재 혼잡도 레벨: <span class="<%= levelClass %>"><%= congestionLevel %> (<%= levelText %>)</span></p>
      <p>업데이트 시각: <%= datetime %></p>
      <div class="info-box">
        <p><strong>참고:</strong> 이 데이터는 TMAP API에서 제공하는 정보입니다.</p>
        <p>API 응답 원본:</p>
        <pre><%= congestionDataJson %></pre>
      </div>
    </c:when>
    <c:otherwise>
      <h2 class="error">API 호출에 실패했습니다.</h2>
      <p class="error">오류 코드: <%= status_code %></p>
      <p class="error">메시지: <%= status_message %></p>
      <div class="info-box">
        <p><strong>참고:</strong> TMAP API에서 혼잡도 정보를 제공하지 않거나, 요청에 오류가 발생했습니다.</p>
        <p>API 응답 원본:</p>
        <pre><%= congestionDataJson %></pre>
      </div>
    </c:otherwise>
  </c:choose>
  <%
  } else {
  %>
  <h2 class="error">받아온 데이터의 형식이 올바르지 않습니다.</h2>
  <p>오류 원본: <pre><%= congestionDataJson %></pre></p>
  <%
    }
  } else {
  %>
  <h2 class="error">Controller에서 전달받은 데이터가 없습니다.</h2>
  <%
    }
  %>
</div>
</body>
</html>