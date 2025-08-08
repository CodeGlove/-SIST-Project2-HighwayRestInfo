package bbs.action;

import bbs.dao.BbsDAO;
import restinfo.action.Action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashSet;
import java.util.Set;

public class HateAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        String postNum = request.getParameter("PostNum");
        HttpSession session = request.getSession(); //세션에 싫어요 기록을 추가하는 내용

        Set<String> votedPosts = (Set<String>) session.getAttribute("votedPosts");

        if (votedPosts == null) {
            votedPosts = new HashSet<>();
        }
        votedPosts.add(postNum);
        session.setAttribute("votedPosts", votedPosts);

        //session.getAttribute("hated");
        BbsDAO.addHate(postNum); //DB에 싫어요 +1

        return null; //비동기식이어서 페이지 이동 안함
    }
}
