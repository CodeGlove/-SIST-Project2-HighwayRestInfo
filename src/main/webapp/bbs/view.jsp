<%@ page import="mybatis.vo.BbsVO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 상세 - HighwayGuide</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
          rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/indexStyle.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/footerStyle.css" rel="stylesheet">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.14.1/themes/base/jquery-ui.css">
    <style>
        /* Toss 스타일 공지사항 상세 */
        body {
            font-family: 'PretendardVariable', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #ffffff;
            color: #191f28;
            line-height: 1.6;
            margin: 0;
            padding-top: 80px;
        }

        .view-container {
            max-width: 768px;
            margin: 0 auto;
            padding: 0 20px;
        }



        .article-header {
            padding: 40px 0 32px 0;
            border-bottom: 1px solid #f2f4f6;
        }

        .article-title {
            font-size: 28px;
            font-weight: 700;
            color: #191f28;
            line-height: 1.3;
            margin: 0 0 20px 0;
            letter-spacing: -0.6px;
        }

        .article-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 14px;
            color: #8b95a1;
        }

        .article-content {
            padding: 40px 0;
            border-bottom: 1px solid #f2f4f6;
        }

        .content-text {
            font-size: 16px;
            line-height: 1.7;
            color: #191f28;
            word-break: break-word;
        }

        .attachment-section {
            padding: 24px 0;
            border-bottom: 1px solid #f2f4f6;
        }

        .attachment-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 20px;
            background: #f8fafc;
            border-radius: 12px;
            transition: background-color 0.2s;
        }

        .attachment-item:hover {
            background: #f1f5f9;
        }

        .attachment-icon {
            width: 24px;
            height: 24px;
            color: #4e5968;
        }

        .attachment-link {
            color: #3182f6;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
        }

        .attachment-link:hover {
            text-decoration: underline;
        }

        .reaction-section {
            padding: 32px 0;
            text-align: center;
            border-bottom: 1px solid #f2f4f6;
        }

        .reaction-buttons {
            display: flex;
            justify-content: center;
            gap: 16px;
        }

        .reaction-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            background: #ffffff;
            border: 1px solid #e5e8eb;
            border-radius: 24px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .reaction-btn:hover:not(:disabled) {
            background: #f8fafc;
            border-color: #d0d5dd;
        }

        .reaction-btn:disabled {
            background: #f8fafc;
            color: #8b95a1;
            cursor: not-allowed;
        }

        .reaction-btn.like:not(:disabled):hover {
            background: #e6f3ff;
            border-color: #3182f6;
            color: #3182f6;
        }

        .reaction-btn.hate:not(:disabled):hover {
            background: #fef2f2;
            border-color: #f04452;
            color: #f04452;
        }

        .action-buttons {
            padding: 32px 0;
            display: flex;
            justify-content: center;
            gap: 12px;
            border-bottom: 1px solid #f2f4f6;
        }

        .action-btn {
            padding: 12px 20px;
            border: 1px solid #e5e8eb;
            border-radius: 8px;
            background: #ffffff;
            color: #4e5968;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .action-btn:hover {
            background: #f8fafc;
            border-color: #d0d5dd;
        }

        .action-btn.primary {
            background: #3182f6;
            color: #ffffff;
            border-color: #3182f6;
        }

        .action-btn.primary:hover {
            background: #1b64da;
            border-color: #1b64da;
        }

        .action-btn.danger {
            color: #f04452;
            border-color: #f04452;
        }

        .action-btn.danger:hover {
            background: #fef2f2;
        }

        .comment-section {
            padding: 40px 0;
        }

        .comment-form {
            background: #f8fafc;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 32px;
        }

        .comment-form h3 {
            font-size: 16px;
            font-weight: 600;
            color: #191f28;
            margin: 0 0 20px 0;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #4e5968;
            margin-bottom: 8px;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #e5e8eb;
            border-radius: 8px;
            font-size: 14px;
            background: #ffffff;
            transition: border-color 0.2s;
        }

        .form-input:focus {
            outline: none;
            border-color: #3182f6;
        }

        .form-textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #e5e8eb;
            border-radius: 8px;
            font-size: 14px;
            background: #ffffff;
            resize: vertical;
            min-height: 100px;
            transition: border-color 0.2s;
        }

        .form-textarea:focus {
            outline: none;
            border-color: #3182f6;
        }

        .submit-btn {
            padding: 12px 24px;
            background: #3182f6;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .submit-btn:hover {
            background: #1b64da;
        }

        /* 삭제 다이얼로그 스타일 */
        .ui-dialog {
            border-radius: 12px !important;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3) !important;
        }

        .ui-dialog-titlebar {
            background: #f04452 !important;
            color: #ffffff !important;
            border: none !important;
            border-radius: 12px 12px 0 0 !important;
            padding: 16px 20px !important;
        }

        .ui-dialog-content {
            padding: 24px !important;
            font-size: 16px !important;
            color: #191f28 !important;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .view-container {
                padding: 0 16px;
            }

            .article-title {
                font-size: 24px;
            }

            .reaction-buttons {
                flex-direction: column;
                align-items: center;
            }

            .action-buttons {
                flex-wrap: wrap;
                gap: 8px;
            }

            .action-btn {
                flex: 1;
                min-width: 0;
            }
        }

        /* 헤더 스타일 오버라이드 */
        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #f2f4f6;
        }
    </style>
</head>
<body>

<!-- Header -->
<header class="header">
    <div class="nav-container">
        <a href="../Controller" class="logo">
            <div class="logo-icon">
                <i class="fas fa-road"></i>
            </div>
            HighwayGuide
        </a>
        <nav>
            <ul class="nav-links">
                <li><a href="#">회사 소개</a></li>
                <li><a href="../Controller?type=notice" class="btn btn-notice">공지사항</a></li>
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
                <a href="../Controller?type=login" class="btn btn-login">로그인</a>
                <a href="../Controller?type=register" class="btn btn-register">회원가입</a>
            </c:if>

            <%--***** 로그인된 경우 --%>
            <c:if test="${not empty sessionScope.loginUser}">
                <a href="../Controller?type=logout" class="btn btn-logout">로그아웃</a>
                <a href="../Controller?type=#" class="btn btn-register">마이페이지</a>
            </c:if>
        </div>
    </div>
</header>

<!-- Main Content -->
<main>
    <c:if test="${requestScope.vo ne null}">
        <c:set var="vo" value="${requestScope.vo}"/>
        <div class="view-container">
            <!-- Article Header -->
            <div class="article-header">
                <h1 class="article-title">${vo.subject}</h1>
                <div class="article-meta">
                    <span>작성자: ${vo.writer}</span>
                    <span>작성일: ${vo.writeDate}</span>
                    <c:if test="${vo.modDate ne vo.writeDate}">
                        <span>수정일: ${vo.modDate}</span>
                    </c:if>
                </div>
            </div>

            <!-- Attachment Section -->
            <c:if test="${vo.fileName ne null and vo.fileName.length() > 4}">
                <div class="attachment-section">
                    <div class="attachment-item">
                        <i class="fas fa-paperclip attachment-icon"></i>
                        <a href="javascript:down('${vo.fileName}')" class="attachment-link">
                            ${vo.fileName}
                        </a>
                    </div>
                </div>
            </c:if>

            <!-- Article Content -->
            <div class="article-content">
                <div class="content-text">${vo.content}</div>
            </div>

            <!-- Reaction Section -->
            <div class="reaction-section">
                <div class="reaction-buttons">
                    <button type="button" id="btn-like" class="reaction-btn like" onclick="sendReaction('like')"
                            <c:if test="${hasReacted}">disabled</c:if>>
                        <span>👍</span>
                        <span id="likeCount">${likeCount}</span>
                    </button>
                    <button type="button" id="btn-hate" class="reaction-btn hate" onclick="sendReaction('hate')"
                            <c:if test="${hasReacted}">disabled</c:if>>
                        <span>👎</span>
                        <span id="hateCount">${hateCount}</span>
                    </button>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <button type="button" class="action-btn primary" onclick="goList()">목록</button>
                <button type="button" class="action-btn" onclick="goEdit()">수정</button>
                <button type="button" class="action-btn danger" onclick="goDel()">삭제</button>
            </div>

            <!-- Comment Section -->
            <div class="comment-section">
                <form method="post" action="../Controller" class="comment-form">
                    <h3>댓글 작성</h3>
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input type="text" name="writer" class="form-input" required/>
                    </div>
                    <div class="form-group">
                        <label class="form-label">내용</label>
                        <textarea name="content" class="form-textarea" required></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">비밀번호</label>
                        <input type="password" name="pwd" class="form-input" required/>
                    </div>
                    <input type="hidden" name="PostNum" value="${vo.postNum}">
                    <input type="hidden" name="cPage" value="${param.cPage}"/>
                    <input type="hidden" name="type" value="commadd"/>
                    <button type="submit" class="submit-btn">댓글 등록</button>
                </form>
            </div>

            <!-- Hidden Forms -->
            <form name="ff" method="post">
                <input type="hidden" name="type"/>
                <input type="hidden" name="FileName"/>
                <input type="hidden" name="PostNum" value="${vo.postNum}"/>
                <input type="hidden" name="cPage" value="${param.cPage}"/>
            </form>

            <!-- Delete Dialog -->
            <div id="del_dialog" title="삭제 확인">
                <form action="../Controller" method="post">
                    <p>정말로 이 공지사항을 삭제하시겠습니까?</p>
                    <p style="color: #f04452; font-size: 14px;">삭제된 내용은 복구할 수 없습니다.</p>
                    <input type="hidden" name="type" value="del"/>
                    <input type="hidden" name="PostNum" value="${vo.postNum}"/>
                    <input type="hidden" name="cPage" value="${param.cPage}"/>
                    <button type="button" onclick="del(this.form)" class="action-btn danger">삭제</button>
                </form>
            </div>
        </div>
    </c:if>
</main>

<!-- Footer Include -->
<jsp:include page="../footer.jsp"/>

<%-- 표현할 vo객체가 존재하지 않는다면 원래 있던 목록 페이지로 이동한다.--%>
<c:if test="${requestScope.vo eq null}"> <%--eq는 '==' 와 같다--%>
  <c:redirect url="../Controller">
    <c:param name="type" value="notice"/>
    <c:param name="cPage" value="${param.cPage}"/>
  </c:redirect>
</c:if>

<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/ui/1.14.1/jquery-ui.js"></script>

<script>
  $(function () {
    let option = {
      modal: true,
      autoOpen: false, //호출되는 즉시 대화상자 표시(기본값: true)
      resizable: false,
    };

    $("#del_dialog").dialog(option);
  });

  function goList() {
    document.ff.action = "../Controller";
    document.ff.type.value = "notice";
    document.ff.submit();
  }
  
  function goDel() {
    $("#del_dialog").dialog("open");
  }
  
  function del(frm) {
    frm.submit();
  }
  
  function goEdit() {
    document.ff.action = "../Controller";
    document.ff.type.value = "edit";
    document.ff.submit();
  }
  
  function down(FileName) {
    document.ff.action = "../download.jsp";
    document.ff.FileName.value = FileName;
    document.ff.submit();
  }

  //리액션 실행 코드
  function sendReaction(type) {
    // 1. 함수가 시작되자마자 두 버튼을 '즉시' 비활성화 (가장 중요!)
    //    - 서버 응답을 기다리지 않고 바로 UI를 잠가서 중복 클릭을 원천 차단합니다.
    $("#btn-like").prop("disabled", true);
    $("#btn-hate").prop("disabled", true);

    // 2. 화면의 숫자 업데이트
    //    - 서버가 성공할 것을 '미리 가정'하고 사용자에게 즉각적인 피드백을 줍니다.
    if (type === 'like') {
      const countSpan = $("#likeCount");
      const currentCount = parseInt(countSpan.text(), 10);
      countSpan.text(currentCount + 1);
    } else { // 'hate'일 경우
      const countSpan = $("#hateCount");
      const currentCount = parseInt(countSpan.text(), 10);
      countSpan.text(currentCount + 1);
    }

    // 3. 서버에 조용히 요청 보내기
    //    - 이제 이 AJAX 호출은 백그라운드에서 DB에 데이터를 기록하는 역할만 합니다.
    $.ajax({
      url: '${pageContext.request.contextPath}/Controller',
      type: 'POST',
      data: {
        type: type,
        PostNum: '${vo.postNum}'
      }
    })
      .fail(function() {
        // 혹시라도 서버 요청이 실패하면 사용자에게 알리고, 새로고침을 유도합니다.
        alert("데이터 저장 중 오류가 발생했습니다. 페이지를 새로고침합니다.");
        location.reload(); // 페이지를 새로고침하여 정확한 상태를 다시 불러옴
      });
  }

  /*function sendReaction(type) {
    console.log("1. sendReaction 함수 시작. 타입:", type);

    // 버튼이 이미 비활성화 상태이면 아무것도 하지 않음 (중복 클릭 방지)
    if ($("#btn-like").prop("disabled")) {
      console.log("already btn disabled, close this method.");
      return;
    }

    $.ajax({
      url: '${pageContext.request.contextPath}/Controller',
      type: 'POST',
      data: {
        type: type,
        PostNum: '${vo.postNum}'
      }
    })
      .done(function() {
        // 서버와 통신이 '성공'했을 때 이 부분이 실행됩니다.
        console.log("2. AJAX Request Success!!! (.done ). UI will updated.");

        // 화면의 숫자 업데이트
        if (type === 'like') {
          const countSpan = $("#likeCount");
          const currentCount = parseInt(countSpan.text(), 10);
          countSpan.text(currentCount + 1);
        } else { // 'hate'일 경우
          const countSpan = $("#hateCount");
          const currentCount = parseInt(countSpan.text(), 10);
          countSpan.text(currentCount + 1);
        }

        // 두 버튼 모두 즉시 비활성화
        $("#btn-like").prop("disabled", true);
        $("#btn-hate").prop("disabled", true);
        console.log("3. btn disabled success!!!.");
      })
      .fail(function(jqXHR, textStatus, errorThrown) {
        // 서버와 통신이 '실패'했을 때 이 부분이 실행됩니다.
        console.error("AJAX 요청 실패:", textStatus, errorThrown);
        alert("request ~ing error");
      });
  }*/

  //********* 기존 코드 **********
  /*function sendReaction(type) {
    //서버에 보낼 데이터 준비
    $.ajax({
      url: '${pageContext.request.contextPath}/Controller', // 요청을 보낼 URL
      type: 'POST', // 데이터 변경을 유발하므로 POST 방식 사용
      data: {
        type: type, PostNum: '${vo.postNum}'} // type: 'like' 또는 'hate' PostNum: 현재 게시물 번호
    }).done(function () {
      // ajax 요청 완료시 함수 실행
      if(type === 'like'){
        // 화면에 좋아요 숫자1 증가
        const countSpan = $("#likeCount");
        const currentCount = parseInt(countSpan.text());
        countSpan.text(currentCount+1);
      }else{
        // 화면에 싫어요 숫자1 증가
        const countSpan = $("#hateCount");
        const currentCount = parseInt(countSpan.text());
        countSpan.text(currentCount+1);
      }
      // 누르기 중복 안됨(버튼 비활성화)
      $("#btn-like").prop("disabled", true);
      $("#btn-hate").prop("disabled", true);
    }).fail(function(){
      //요청 실패시
      alert("오류가 발생했습니다. 다시 시도해주세요");
    });
  }*/
</script>
</body>
</html>













