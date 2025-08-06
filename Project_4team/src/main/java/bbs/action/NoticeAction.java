package bbs.action;

import bbs.dao.BbsDAO;
import bbs.util.Paging;
import mybatis.vo.BbsVO;
import restinfo.action.Action;

import javax.security.auth.Subject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NoticeAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        //파라미터 받기
        /*
        String subject = request.getParameter("Subject");
        if(subject==null) {
            subject="sbj";
        }
        */

        //총 게시물 수 얻어낸다.
        //int totalCount = BbsDAO.getTotalCount(subject);
        int totalCount = BbsDAO.getTotalCount(null);

        //페이징 처리
        Paging page = new Paging(5, 3); //한 페이지당 5개씩, 3페이지 생성
        page.setTotalCount(totalCount); //총 페이지 수까지 구했다.

        //현재 페이지값을 파라미터로 받는다.
        String cPage = request.getParameter("cPage");

        if(cPage == null) //받은 페이지 없으면 첫페이지(1)로 가라.
            page.setNowPage(1);
        else{
            int nowPage = Integer.parseInt(cPage);
            page.setNowPage(nowPage);
        }

        //DAO(DB)를 호출하여 원하는 게시물들 목록을 받아야 한다.
        BbsVO[] ar = BbsDAO.getList(null, page.getBegin(), page.getEnd());

        //페이징 정보를 Map에 담아 DAO에 전달
        /*
        Map<String, Object> map = new HashMap<>();
        map.put("subject", subject);
        map.put("begin", page.getBegin());
        map.put("numPerPage", page.getNumPerPage());
        */

        // JSP에서 표현하기 위해 request에 저장!
        request.setAttribute("ar", ar);
        request.setAttribute("page", page);
        //request.setAttribute("nowPage", page.getNowPage()); //notice.jsp에서 값으로 사용가능

        return "bbs/notice.jsp"; //공지사항 페이지로 forward
    }
}
