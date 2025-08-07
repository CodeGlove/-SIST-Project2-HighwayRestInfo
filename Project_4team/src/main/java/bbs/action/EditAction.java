package bbs.action;

import bbs.dao.BbsDAO;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import mybatis.vo.BbsVO;
import mybatis.vo.UserVO;
import restinfo.action.Action;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;

public class EditAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {

        //******** 권한 확인 *********
        HttpSession session = request.getSession();
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");

        //관리자 유효성 검사
        //로그인을 하지 않거나 관리자가 아닌 경우 공지사항 목록으로 이동
        if (loginUser == null || !(loginUser.getAuthority().equals("1"))) {
            try {
                response.sendRedirect("Controller?type=notice");
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null; //권한이 없다면 forward 막기
        }

        // 먼저 요청시 contentType을 얻어낸다.(여기로 오는 곳이 두군데가 있는데 둘다 post 방식이다!)
        String enc_type = request.getContentType(); //get방식은 contentType이 없다.(post는 form)
        String viewPath = null;

        if(enc_type.startsWith("application")){ //ff에서 넘어오는애(view.jsp)
            // view.jsp에서 [수정]버튼을 클릭한 경우 이때는
            // 수정화면으로 이동해야 함!
            // 그럼 먼저 수정하고자 하는 게시물을 얻어내야 한다.
            String PostNum = request.getParameter("PostNum"); //파라미터 얻기!

            String cPage = request.getParameter("cPage");
            request.setAttribute("PostNum", PostNum);
            request.setAttribute("cPage", cPage);

            BbsVO vo = BbsDAO.getPostNum(PostNum);
            request.setAttribute("vo", vo);
            viewPath = "/bbs/edit.jsp"; //여기서 forward 되므로 이쪽으로 넘어오는
            // 파라미터들은(PostNum, cPage)은 그대로 유지되어 edit.jsp로 간다.

        } else if(enc_type.startsWith("multipart")){
            //edit.jsp에서 값을 수정한 후 DB에 UPDATE를 수정하길 원하는 경우
            //첨부파일을 처리하기 위해 bbs_upload폴더의 절대경로가 필요하다.
            try {
                ServletContext application = request.getServletContext(); //절대경로 얻기 위해 선언
                String realPath = application.getRealPath("/bbs_upload"); //절대경로 얻음
                //첨부파일과 다른 파라미터들을 받기위해 MultipartRequest생성(cos 라이브러리 필요함)
                MultipartRequest mr = new MultipartRequest(request, realPath,
                        1024*1024*5, "utf-8",
                        new DefaultFileRenamePolicy()); //동일한 이름이 있다면 바꿔라
                //이때 첨부파일이 있다면 realPath경로에 저장된 상태다.

                //나머지 파라미터들 얻기 -> (edit.jsp에서 name 확인 얻어내야 한다)
                String PostNum = mr.getParameter("PostNum");
                String subject = mr.getParameter("subject");
                String content = mr.getParameter("content");
                String cPage = mr.getParameter("cPage");

                //첨부파일이 있다면 FileName을 얻어내야 한다.
                File f = mr.getFile("file");
                String FileName = null;
                if( f != null ){
                    FileName = f.getName(); // 현재 저장된 파일명
                }

                //DB에 수정
                BbsDAO.edit(PostNum, subject, content, FileName);

                String redirectPath = "Controller?type=view&PostNum="+PostNum+"&cPage="+cPage;
                //이전에 보던 상세보기(view.jsp) 페이지로 리다이렉트
                response.sendRedirect(redirectPath);

                return null;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return viewPath;
    }
}
