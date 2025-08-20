<%@ page import="mybatis.vo.BbsVO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정</title>
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

        #bbs table th {
            text-align:center;
            border:1px solid black;
            padding:4px 10px;
        }

        #bbs table td {
            text-align:left;
            border:1px solid black;
            padding:4px 10px;
        }


        .no {width:15%}
        .subject {width:30%}
        .writer {width:20%}
        .reg {width:20%}
        .hit {width:15%}
        .title{background:lightsteelblue}

        .odd {background:silver}
        .t_bold{ font-weight: bold; color: #007bff; }


    </style>
</head>
<body>
<%
    Object obj = request.getAttribute("vo");
    if(obj != null) {
        BbsVO vo = (BbsVO) obj;
%>
<div id="bbs">
    <form action="Controller?type=edit" method="post"
          encType="multipart/form-data">
        <input type="hidden" id="hidden_postNum" value="${vo.postNum}"/>
        <input type="hidden" id="hidden_cPage" value="${param.cPage}"/>

        <input type="hidden" name="PostNum" value="${vo.postNum}"/>
        <input type="hidden" name="cPage" value="${param.cPage}"/>
        <table summary="공지사항 수정">
            <caption>공지사항 수정</caption>
            <tbody>
            <tr>
                <th>제목:</th>
                <td><input type="text" name="subject" id="subject" size="45" value="${vo.subject}"/></td>
            </tr>
            <tr>
                <th>이름:</th>
                <%-- writer 입력란 readonly 문법 수정 --%>
                <td><input type="text" name="writer" id="writer" size="12" value="${vo.writer}" readonly/></td>
            </tr>
            <tr>
                <th>내용:</th>
                <%-- 내용이 태그로 보이는 문제 해결 --%>
                <td><textarea name="content" cols="50" id="content" rows="8">${vo.content}</textarea></td>
            </tr>
            <tr>
                <th>첨부파일:</th>
                <td><input type="file" id="file" name="file"/>
                    <%
                        if(vo.getFileName() != null){
                    %>
                    <p class="t_bold">(<%=vo.getFileName()%>)</p>
                    <%
                        }
                    %>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="button" value="완료" onclick="sendData()"/>
                    <input type="button" value="취소" onclick="goBack()"/>
                </td>
            </tr>
            </tbody>
        </table>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script src="<%=request.getContextPath()%>/ckeditor/ckeditor.js"></script>
<script>
    // CKEditor 인스턴스 초기화
    let myEditor = CKEDITOR.replace('content', {
        filebrowserUploadUrl: 'http://localhost:8080/image/upload'
    });

    function sendData(){
        // 에디터의 최신 내용을 <textarea>에 적용
        myEditor.updateElement();

        //유효성 검사
        let subject = $("#subject").val();
        if(subject.trim().length < 1){
            alert("제목을 입력하세요");
            $("#subject").val("");
            $("#subject").focus();
            return;
        }

        let writer = $("#writer").val();
        if(writer.trim().length < 1){
            alert("이름을 입력하세요:");
            $("#writer").val("");
            $("#writer").focus();
            return;
        }

        let content = $("#content").val();
        if(content.trim().length < 1){
            alert("내용을 입력하세요:");
            $("#content").val("");
            $("#content").focus();
            return;
        }

        // 폼 전송
        document.forms[0].submit();
    }

    function goBack() {
        const postNum = document.getElementById('hidden_postNum').value;
        const cPage = document.getElementById('hidden_cPage').value;
        location.href = "Controller?type=view&PostNum=" + postNum + "&cPage=" + cPage;
    }
</script>
<%
    }
%>
</body>
</html>