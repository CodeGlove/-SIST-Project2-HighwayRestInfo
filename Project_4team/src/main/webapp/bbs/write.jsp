<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
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

            /*let file = $("#file").val();
            if(file.trim().length < 1){
              alert("첨부파일 없음");
              $("#file").val("");
              $("#file").focus();
              return;
            }*/
            document.forms[0].submit(); //submit이 발생하면 writeAction이 실행됨.
        }
    </script>
</head>
<body>
<div id="bbs">
    <form action="Controller?type=write" method="post"
          encType="multipart/form-data">
        <%--<input type="hidden" name="category" value="BBS"/>--%>
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
                <%--ckeditor를 사용하면 textarea태그는 숨겨짐.(에디터UI가 여기에 동적으로 생성되기 때문)--%>
                <th>내용:</th>
                <td><textarea name="content" cols="80"
                              id="content" rows="12"></textarea></td>
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
                    <input type="button" value="완료"
                           onclick="sendData()"/>
                    <input type="button" value="수정"/>
                    <input type="button" value="목록"/>
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
                uploadUrl: 'http://localhost:8080/image/upload'
            }
        })
        .then(editor => {
            console.log('CKEditor가 성공적으로 로드되었습니다.', editor);
            myEditor = editor; // 생성된 에디터 인스턴스를 변수에 저장
        })
        .catch(error => {
            console.error('CKEditor 로드 중 에러 발생:', error);
        });
</script>
</body>
</html>












