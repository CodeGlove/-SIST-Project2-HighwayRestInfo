<%-- src/main/webapp/searchForm.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>휴게소 검색</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; text-align: center; }
    .container { background-color: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 500px; margin: 30px auto; }
    h1 { color: #0056b3; }
    input[type="text"] { width: 70%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; }
    input[type="submit"] { background-color: #0056b3; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
  </style>
</head>
<body>
<div class="container">
  <h1>휴게소 검색</h1>
  <form action="Controller" method="post">
    <input type="hidden" name="type" value="searchPoi">
    <input type="text" name="restAreaName" placeholder="휴게소 이름을 입력하세요" required>
    <input type="submit" value="검색">
  </form>
</div>
</body>
</html>