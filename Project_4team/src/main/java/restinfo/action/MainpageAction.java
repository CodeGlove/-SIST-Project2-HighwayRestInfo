package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MainpageAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		
		return "index.jsp";
	}
}
