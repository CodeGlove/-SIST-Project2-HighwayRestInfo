package restinfo.action;

import mybatis.vo.UserVO;
import org.mindrot.jbcrypt.BCrypt;
import restinfo.dao.LoginDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {

		String id = request.getParameter("username");
		String pwd = request.getParameter("password");

		UserVO vo = LoginDAO.login(id);

		boolean loginSuccess = false;
		String message = "아이디 또는 비밀번호가 일치하지 않습니다.";

		if(vo!=null){
			if(BCrypt.checkpw())
		}

		// 사용자가 로그인 시 입력한 비밀번호
		String plainLoginPassword = "user_input_password";

		// DB에서 사용자의 이메일로 조회해 온 해시된 비밀번호
		String hashedPasswordFromDB = "db_stored_hash_value";

		// checkpw가 알아서 해시값의 솔트를 사용해 비밀번호가 맞는지 확인해 줍니다.
		if (BCrypt.checkpw(plainLoginPassword, hashedPasswordFromDB)) {
			// 비밀번호 일치 (로그인 성공)
		} else {
			// 비밀번호 불일치 (로그인 실패)
		}

		return null;
	}
}
