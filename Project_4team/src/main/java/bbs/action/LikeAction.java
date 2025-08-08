package bbs.action;

import bbs.dao.BbsDAO;
import restinfo.action.Action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

public class LikeAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        String postNum = request.getParameter("PostNum");
        //System.out.println("----likeAction OK!!");
        //System.out.println("1. receive PostNum: " + postNum);
        HttpSession session = request.getSession(); //세션에 좋아요 기록을 추가하는 내용

        Set<String> votedPosts = (Set<String>) session.getAttribute("votedPosts");

        if (votedPosts == null) {
            votedPosts = new HashSet<>();
        }
        votedPosts.add(postNum);
        session.setAttribute("votedPosts", votedPosts);

        //session.getAttribute("liked");
        BbsDAO.addLike(postNum); //DB에 좋아요 +1

        //System.out.println("4. LikeAction Ok2!!!");
        //System.out.println("-----------------------");
        return null; //비동기식이어서 페이지 이동 안함
    }
}
