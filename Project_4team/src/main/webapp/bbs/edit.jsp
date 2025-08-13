<%@ page import="mybatis.vo.BbsVO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
    <script type="text/javascript">
        function sendData(){
            // ******** 에디터의 최신 내용을 <textarea>에 적용한다.
            myEditor.updateSourceElement();

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

            document.forms[0].submit(); //submit이 발생하면 editAction이 실행됨.
        }
    </script>
</head>
<body>
<%
    Object obj = request.getAttribute("vo"); //여기서 vo값 받기
    if(obj != null) {
        BbsVO vo = (BbsVO) obj;
%>
<div id="bbs">
    <form action="Controller?type=edit" method="post"
          encType="multipart/form-data">
        <%--<input type="hidden" name="bname" value="BBS"/>--%>
        <%-- (중요) '취소'와 '완료' 모두에 필요한 정보들을 hidden input으로 저장 --%>
        <input type="hidden" id="hidden_postNum" value="${vo.postNum}"/>
        <input type="hidden" id="hidden_cPage" value="${param.cPage}"/>

        <%-- '완료' 버튼(폼 전송)을 위한 name 속성을 가진 input --%>
        <input type="hidden" name="PostNum" value="${vo.postNum}"/> <%--b_idx는 보이지 않게 처리!!!--%>
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
                <td><input type="text" name="writer" id="writer" size="12" value="${vo.writer}">
                           readonly/></td>
            </tr>
            <tr>
                <th>내용:</th>
                <td><textarea name="content" cols="50"
                              id="content" rows="8"><%=vo.getContent()%></textarea></td>
            </tr>
            <tr>
                <th>첨부파일:</th>
                <td><input type="file" id="file" name="file"/>
                    <%
                        if(vo.getFileName() != null){
                    %>
                    <p class="t_bold">(<%=vo.getFileName()%></p> <%--//첨부된 파일 명시!--%>
                    <%
                        }
                    %>
                </td> <%--여기에는 보안문제로 value를 사용하지 못함!!--%>
            </tr>
            <!--
                            <tr>
                                <th>비밀번호:</th>
                                <td><input type="password" name="pwd" size="12"/></td>
                            </tr>
            -->
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
<script src="${pageContext.request.contextPath}/ckeditor/ckeditor.js"></script> <%--ckEditor 파일 추가--%>
<!-- 실제로 textarea에 에디터를 적용시키는 코드 -->
<script>
    let myEditor;

    ClassicEditor
        .create(document.querySelector('#content'), { // #editor에서 #content로 수정
            ckfinder: {
                // Summernote의 이미지 업로드 Controller 경로를 그대로 사용함
                uploadUrl: 'Controller?type=saveImg'
            }
        })
        .then(editor => {
            console.log('CKEditor가 성공적으로 로드되었습니다.', editor);
            myEditor = editor; // 생성된 에디터 인스턴스를 변수에 저장
        })
        .catch(error => {
            console.error('CKEditor 로드 중 에러 발생:', error);
        });

    function goBack() {
        const postNum = document.getElementById('hidden_postNum').value;
        const cPage = document.getElementById('hidden_cPage').value;
        //location.href = `Controller?type=view&PostNum=${postNum}&cPage=${cPage}`; 템플릿리터럴 인식 불가
        location.href = "Controller?type=view&PostNum=" + postNum + "&cPage=" + cPage;
    }
</script>
<%
    } //if문의 끝
%>
</body>
</html>