package bbs.action;

import bbs.dao.BbsDAO;
import mybatis.vo.BbsVO;
import restinfo.action.Action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

public class ViewAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        //파라미터 받기
        String PostNum = request.getParameter("PostNum"); //기본키
        //String cPage = request.getParameter("cPage"); //목록보기에 사용할 페이지 값

        //한번이라도 읽은 게시물들은 list에 담아서 HttpSession에 저장해 둔다.
        //그럼 우선 HttpSession으로 부터 list를 얻어내자
        HttpSession session = request.getSession();

        //session에 "read_list"라는 이름으로 저장된 객체를 얻어내자
        Object obj = session.getAttribute("read_list");
        ArrayList<BbsVO> list = null;
        if(obj == null){ //세션 얻어내서 세션에 read_list라는 놈이 있다면 list에 저장하고 없다면 세션에 저장
            list = new ArrayList<>();
            session.setAttribute("read_list", list);
        }else
            list = (ArrayList<BbsVO>) obj;

        BbsVO vo = BbsDAO.getPostNum(PostNum); //사용자가 선택한 게시물을 검색해 온다.

        request.setAttribute("vo", vo);
        return "bbs/view.jsp";
    }
}
