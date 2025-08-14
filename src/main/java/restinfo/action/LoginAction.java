package restinfo.action;

import mybatis.vo.UserVO;
import org.mindrot.jbcrypt.BCrypt;
import restinfo.dao.LoginDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class LoginAction implements Action {
	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) {
		// ID 추출
		String id = request.getParameter("username");

		// 아이디 입력 안됐거나 입력란이 비어있을경우
		if (id == null || id.trim().isEmpty()) {
			return "/login.jsp"; // 로그인창 이동 (자기 자신으로 포워딩 방지)
		}

		// ******** id 파라미터가 있으면, 비동기 로그인 수행 ********
		String pwd = request.getParameter("password");
		UserVO vo = LoginDAO.login(id); // DAO 호출

		boolean loginSuccess = false;
		String message = "";

		// 로그인 처리
		if (vo != null && vo.getPwd() != null && BCrypt.checkpw(pwd, vo.getPwd())) {
			// 로그인 성공
			loginSuccess = true;
			HttpSession session = request.getSession();// 세션 생성
			session.setAttribute("loginUser", vo); // 세션에 vo객체 저장
		} else {
			// 로그인 실패
			loginSuccess = false;
			message = "아이디 또는 비밀번호가 일치하지 않습니다.";
		}

		// JSON 응답 생성
		try {
			// 여기서 응답을 JSON으로 설정
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");

			// 응답 데이터를 작성할 PrintWriter 얻기
			PrintWriter out = response.getWriter();

			// JSON 형식 문자열 생성
			String jsonResponse = String.format("{\"status\": \"%s\", \"message\": \"%s\"}",
					loginSuccess ? "success" : "fail",
					message);

			// 클라이언트로 응답 전송
			out.print(jsonResponse);
			out.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}

		// Controller한테 페이지 이동 안함
		return null; // 비동기 요청에 대한 응답(페이지 이동x)
	}

}
