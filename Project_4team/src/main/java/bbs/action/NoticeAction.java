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
        String subject = null; // request.getParameter("Subject");

        //총 게시물 수 얻어낸다.
        int totalCount = BbsDAO.getTotalCount(subject);

        //페이징 처리 객체 생성
        Paging page = new Paging(5, 3);

        //현재 페이지값을 파라미터로 받는다.
        String cPage = request.getParameter("cPage");

        int nowPage = 1; // nowPage의 기본값을 1로 먼저 설정합니다.

        // (핵심) cPage 값이 유효한지 검사합니다. (null도 아니고, 비어있지도 않아야 함)
        if (cPage != null && !cPage.isEmpty()) {
            nowPage = Integer.parseInt(cPage);
        }

        // (핵심) Paging 객체에 값을 설정하는 순서가 중요합니다.
        page.setTotalCount(totalCount); // 1. 총 게시물 수를 먼저 설정하여 전체 페이지 수를 계산하게 합니다.
        page.setNowPage(nowPage);       // 2. 그 다음, 현재 페이지를 설정하여 나머지 값들을 계산하게 합니다.

        //DAO(DB)를 호출하여 원하는 게시물들 목록을 받아야 한다.
        BbsVO[] ar = BbsDAO.getList(subject, page.getBegin(), page.getEnd());

        // JSP에서 표현하기 위해 request에 저장!
        request.setAttribute("ar", ar);
        request.setAttribute("page", page);

        return "bbs/notice.jsp"; //공지사항 페이지로 forward


        //파라미터 받기
        /*String subject = request.getParameter("Subject");
        if(subject==null) {
            subject="sbj";
        }

        //총 게시물 수 얻어낸다.
        //int totalCount = BbsDAO.getTotalCount(null);
        int totalCount = BbsDAO.getTotalCount(subject);

        //페이징 처리
        Paging page = new Paging(5, 3); //한 페이지당 5개씩, 3페이지 생성
        page.setTotalCount(totalCount); //총 페이지 수까지 구했다.

        //현재 페이지값을 파라미터로 받는다.
        String cPage = request.getParameter("cPage");

        int nowPage = 1;

        if (cPage != null && !cPage.isEmpty()) {
            nowPage = Integer.parseInt(cPage);
        }

        *//*if(cPage != null && !cPage.isEmpty()) //받은 페이지 없으면 첫페이지(1)로 가라.
            page.setNowPage(1);
        else{
            nowPage = Integer.parseInt(cPage);
            page.setNowPage(nowPage);
        }*//*

        page.setNowPage(nowPage);

        //총게시물 구한것들을 페이징 객체에 설정
        page.setTotalCount(totalCount);

        //DAO(DB)를 호출하여 원하는 게시물들 목록을 받아야 한다.
        //BbsVO[] ar = BbsDAO.getList(null, page.getBegin(), page.getEnd());
        BbsVO[] ar = BbsDAO.getList(subject, page.getBegin(), page.getEnd());

        // JSP에서 표현하기 위해 request에 저장!
        request.setAttribute("ar", ar);
        request.setAttribute("page", page);
        request.setAttribute("nowPage", page.getNowPage());

        return "bbs/notice.jsp"; //공지사항 페이지로 forward*/
    }
}
