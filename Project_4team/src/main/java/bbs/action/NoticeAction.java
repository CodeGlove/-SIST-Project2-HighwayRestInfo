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
        //페이징 처리
        Paging page = new Paging(5, 3);

        page.setTotalCount(BbsDAO.getTotalCount()); //전체 게시물 수 설정

        //현재 페이지값을 파라미터로 받는다.
        String cPage = request.getParameter("cPage");
        if(cPage != null) { //받은 페이지(cPage)가 없으면 첫 페이지로 가라
            page.setNowPage(1);
        }else{
            int nowPage = Integer.parseInt(cPage);
            //요청된 페이지 값이 1보다 작으면 1로 강제 설정
            if(nowPage < 1){
                nowPage = 1;
            }
            page.setNowPage(nowPage);
        }


        //카테고리와 페이징 정보를 Map에 담아 DAO에 전달
        Map<String, Object> map = new HashMap<>();
        map.put("begin", page.getBegin());
        map.put("numPerPage", page.getNumPerPage());

        List<BbsVO> list = BbsDAO.getList(map);

        request.setAttribute("ar", list);
        request.setAttribute("page", page);

        return "bbs/notice.jsp"; //공지사항 페이지로 forward
    }
}
