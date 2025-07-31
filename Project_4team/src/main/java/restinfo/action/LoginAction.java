package restinfo.action;

import mybatis.vo.UserVO;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		//ID/PW 추출
		String pwd = request.getParameter("password");
		String id = request.getParameter("id");
		//DAO 호출

		//패스워드 검증

		//세션 생성


		UserVO vo = new UserVO();
		String hashedPasswordFromDB = vo.getPwd();

		boolean loginSuccess = false;
		if(BCrypt.checkpw(pwd, hashedPasswordFromDB)) {
			loginSuccess = true; //로그인 성공
			HttpSession session = request.getSession();
			session.setAttribute("loginUser", vo);
			//JSON 응답 생성
			
		} else {
			loginSuccess = false; //로그인 실패
		}

		return null; //비동기 요청에 대한 응답(페이지 이동x)
	}
}
