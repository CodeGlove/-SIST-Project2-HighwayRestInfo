package restinfo.action;

import mybatis.vo.UserVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MainpageAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		String redirectUrl = null;

		HttpSession session = request.getSession();
		UserVO vo = (UserVO) session.getAttribute("loginUser");
		// 목적지 화면
		String page = request.getParameter("goto");

		// 관리자인 동시에 관리자 페이지로 가고자 한다면
		if (vo != null && page != null && vo.getAuthority().equals("1") && page.equals("manage"))
			redirectUrl = "manage.jsp";
		else
			redirectUrl = "index.jsp";

		return redirectUrl;
	}
}	
