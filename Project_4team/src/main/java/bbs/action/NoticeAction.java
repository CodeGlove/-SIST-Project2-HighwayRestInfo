package bbs.action;

import bbs.dao.BbsDAO;
import bbs.util.Paging;
import mybatis.vo.BbsVO;
import restinfo.action.Action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NoticeAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        String category = "notice"; //공지사항 카테고리 지정

        //페이징 처리
        Paging p = new Paging(5, 3);
        p.setTotalCount(BbsDAO.getTotalCount(category)); //정체 게시물 수 설정

        String cPage = request.getParameter("cPage");
        if(cPage != null){
            p.setNowPage(Integer.parseInt(cPage));
        }

        //카테고리와 페이징 정보를 Map에 담아 DAO에 전달
        Map<String, String> map = new HashMap<>();
        map.put("category", category);
        map.put("begin", String.valueOf(p.getBegin()));
        map.put("numPerPage", String.valueOf(p.getNumPerPage()));

        List<BbsVO> list = BbsDAO.getList(map);

        request.setAttribute("list", list);
        request.setAttribute("page", p);

        return "bbs/notice.jsp"; //공지사항 페이지로 forward
    }
}
