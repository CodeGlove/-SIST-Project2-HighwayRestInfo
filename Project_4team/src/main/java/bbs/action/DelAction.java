package bbs.action;

import bbs.dao.BbsDAO;
import mybatis.vo.BbsVO;
import mybatis.vo.UserVO;
import restinfo.action.Action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DelAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        // 세션에서 로그인 사용자 정보 가져오기
        HttpSession session = request.getSession();
        UserVO loginUser = (UserVO)session.getAttribute("loginUser");

        // 파라미터로 넘어온 게시물 번호와 페이지 번호 받기
        String postNum = request.getParameter("PostNum");
        String cPage = request.getParameter("cPage");
        System.out.println("-------------------------------------");
        System.out.println(postNum+"check");
        System.out.println(cPage);
        // 삭제할 게시물의 정보 가져오기(작성자 확인용)
        BbsVO vo = BbsDAO.getPostNum(postNum);
        System.out.println(vo);
        System.out.println("vo가져왔는가");

        // 권한 확인(로그인x || 관리자x || 본인작성x 일경우)
        if (loginUser == null || (!loginUser.getAuthority().equals("1")
                && !loginUser.getID().equals(vo.getWriter()))) {
            try {
                response.sendRedirect("Controller?type=notice&cPage=" + cPage); // 권한 없으면 목록으로
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null; // 작업 중단
        }

        // 모든 권한 확인 통과 시 DB에서 게시물 삭제
        BbsDAO.delBbs(postNum);

        // 삭제 후, 목록 페이지로 리다이렉트
        try {
            String redirectURL = "Controller?type=notice&cPage=" + cPage;
            System.out.println("2. DelAction이 보낼 redirect URL: " + redirectURL);
            System.out.println("----------------------");

            response.sendRedirect("Controller?type=notice&cPage=" + cPage);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
