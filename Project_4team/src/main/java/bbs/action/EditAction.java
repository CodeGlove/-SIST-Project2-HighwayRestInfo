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

        // 관리자 유효성 검사
        if (loginUser == null || !(loginUser.getAuthority().equals("1"))) {
            try {
                response.sendRedirect("Controller?type=notice");
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null; //권한이 없다면 forward 막기
        }

        // 요청 방식(GET, POST)을 확인
        String enc_type = request.getContentType();
        String viewPath = null;

        // **수정 페이지로 이동하는 GET 요청 처리**
        // location.href로 요청을 보내면 enc_type이 null이 되므로 이 조건을 먼저 검사합니다.
        if (request.getMethod().equalsIgnoreCase("get")) {
            String PostNum = request.getParameter("PostNum");
            String cPage = request.getParameter("cPage");

            BbsVO vo = BbsDAO.getPostNum(PostNum);

            request.setAttribute("vo", vo);
            request.setAttribute("cPage", cPage);
            viewPath = "/bbs/edit.jsp";

            // **수정된 데이터를 저장하는 POST 요청 처리**
        } else if (enc_type != null && enc_type.startsWith("multipart")) {
            try {
                ServletContext application = request.getServletContext();
                String realPath = application.getRealPath("/bbs_upload");

                MultipartRequest mr = new MultipartRequest(request, realPath,
                        1024*1024*5, "utf-8",
                        new DefaultFileRenamePolicy());

                String PostNum = mr.getParameter("PostNum");
                String subject = mr.getParameter("subject");
                String content = mr.getParameter("content");
                String cPage = mr.getParameter("cPage");

                File f = mr.getFile("file");
                String FileName = null;
                if (f != null) {
                    FileName = f.getName();
                }

                BbsDAO.edit(PostNum, subject, content, FileName);

                String redirectPath = "Controller?type=view&PostNum="+PostNum+"&cPage="+cPage;
                response.sendRedirect(redirectPath);

                return null;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return viewPath;
    }
}