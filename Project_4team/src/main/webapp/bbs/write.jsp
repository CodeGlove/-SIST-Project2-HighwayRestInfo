<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 작성</title>
    <style type="text/css">
        #bbs table {
            width:80%;
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
        /*CK에디터 크기 지정*/
        .ck-editor {
            width: 100%;
        }

        .no {width:15%}
        .subject {width:30%}
        .writer {width:20%}
        .reg {width:20%}
        .hit {width:15%}
        .title{background:lightsteelblue}

        .odd {background:silver}
    </style>
</head>
<body>
<div id="bbs">
    <form action="Controller?type=write" method="post"
          encType="multipart/form-data">
        <table summary="공지사항 작성하기">
            <caption>공지사항 작성하기</caption>
            <tbody>
            <tr>
                <th>제목:</th>
                <td><input type="text" name="subject" id="subject" size="45"/></td>
            </tr>
            <tr>
                <th>작성자:</th>
                <td><input type="text" name="writer" id="writer" size="12"/></td>
            </tr>
            <tr>
                <th>내용:</th>
                <td><textarea name="content" cols="80" id="content" rows="12"></textarea></td>
            </tr>
            <tr>
                <th>첨부파일:</th>
                <td><input type="file" id="file" name="file"/></td>
            </tr>
            <tr>
                <th>카테고리:</th>
                <td>
                    <select id="category" name="category">
                        <option value="">::: 카테고리를 선택하세요 :::</option>
                        <option value="HighWay">고속도로</option>
                        <option value="RestArea">졸음쉼터</option>
                        <option value="ServiceArea">휴게소</option>
                        <option value="Shop">매장</option>
                        <option value="Guide">이용안내</option>
                        <option value="Other">기타</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="button" value="완료" onclick="sendData()"/>
                    <input type="button" value="목록" onclick="location.href='Controller?type=notice'"/>
                </td>
            </tr>
            </tbody>
        </table>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/ckeditor/ckeditor.js"></script>
<script>
    let myEditor;

    ClassicEditor
        .create(document.querySelector('#content'), {
            ckfinder: {
                uploadUrl: '${pageContext.request.contextPath}/Controller?type=saveImg' // 올바른 이미지 업로드 URL로 수정
            }
        })
        .then(editor => {
            console.log('CKEditor가 성공적으로 로드되었습니다.', editor);
            myEditor = editor;
        })
        .catch(error => {
            console.error('CKEditor 로드 중 에러 발생:', error);
        });

    function sendData() {
        // CKEditor 5는 .updateSourceElement()를 사용하지 않음.
        // 대신 .getData()로 내용을 가져와 textarea에 직접 할당해야 함.
        const contentData = myEditor.getData();
        document.getElementById('content').value = contentData;

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
            alert("이름을 입력하세요");
            $("#writer").val("");
            $("#writer").focus();
            return;
        }

        // 카테고리 유효성 검사 수정
        let category = $("#category").val();
        if(category === ""){
            alert("카테고리를 선택하세요");
            $("#category").focus();
            return;
        }

        // CKEditor에서 가져온 내용으로 유효성 검사
        if(contentData.trim().length < 1){
            alert("내용을 입력하세요:");
            return;
        }

        document.forms[0].submit();
    }
</script>
</body>
</html>