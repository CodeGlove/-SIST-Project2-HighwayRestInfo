package bbs.action;

import bbs.dao.BbsDAO;
import mybatis.vo.BbsVO;
import restinfo.action.Action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Set;

public class ViewAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        //파라미터 받기
        String postNum = request.getParameter("PostNum"); //기본키
        //String cPage = request.getParameter("cPage"); //목록보기에 사용할 페이지 값

        //한번이라도 읽은 게시물들은 list에 담아서 HttpSession에 저장해 둔다.
        //그럼 우선 HttpSession으로 부터 list를 얻어내자
        HttpSession session = request.getSession();

        //session에 "read_list"라는 이름으로 저장된 객체를 얻어내자
        Object obj = session.getAttribute("read_list");
        if(obj == null){ //세션 얻어내서 세션에 read_list라는 놈이 있다면 list에 저장하고 없다면 세션에 저장
            session.setAttribute("read_list", new ArrayList<BbsVO>());
        }

        // 이전에 좋아요, 싫어요를 눌렀는지 확인
        boolean hasReacted = false; //기본값: 반응 안함
        Set<String> votedPosts = (Set<String>) session.getAttribute("votedPosts"); //사용자가 투표한
                                                                                    //게시물번호

        //Set구조가 존재하고, 현재 게시물번호(PostNum)을 포함할경우
        if(votedPosts != null && votedPosts.contains(postNum)){
            hasReacted = true; //게시물번호를 담고 있다면 눌렀다는 것으로 간주
        }
        //게시물 정보를 가져와서 view로 전달
        BbsVO vo = BbsDAO.getPostNum(postNum); //사용자가 선택한 게시물을 검색해 온다.
        request.setAttribute("vo", vo);
        request.setAttribute("hasReacted", hasReacted);

        return "bbs/view.jsp";
    }
}
