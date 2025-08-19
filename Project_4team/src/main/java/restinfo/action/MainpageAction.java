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

		if(vo==null	|| vo.getAuthority().equals("0"))
			redirectUrl = "index.jsp";
		else if (vo.getAuthority().equals("1"))
			redirectUrl = "manage.jsp";

		return redirectUrl;
	}
}	
