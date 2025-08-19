package restinfo.action;

import mybatis.vo.ServiceAreaVO;
import mybatis.vo.UserVO;
import restinfo.dao.ServiceAreaDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class MypageAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();
        UserVO vo = (UserVO) session.getAttribute("loginUser");

        // 1. 가장 먼저 로그인 유무를 확인해서 NullPointerException을 방지합니다.
        if (vo == null) {
            response.sendRedirect("Controller?type=login");
            return null;
        }

        // 2. 로그인이 확인된 후에만 안전하게 DAO를 호출합니다.
        //    (DAO 파라미터는 int 타입이 더 좋지만, 현재 코드에 맞춰 String.valueOf()를 유지합니다.)
        List<ServiceAreaVO> list = ServiceAreaDAO.bookmarkedArea(String.valueOf(vo.getIdx()));

        request.setAttribute("bookmarkedServiceAreas", list);
        

        return "mypage.jsp";
    }
}