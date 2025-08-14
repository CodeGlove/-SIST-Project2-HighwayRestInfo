package restinfo.action;

import mybatis.vo.UserVO;
import org.apache.ibatis.session.SqlSession;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import restinfo.dao.SignUpDAO;
import restinfo.util.ConfigLoader;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

public class KakaoCallbackAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {

        String returnedState = request.getParameter("state");
        String storedState = (String) request.getSession().getAttribute("kakao_state");
        System.out.println("returnstateKAKAO:"+returnedState);
        System.out.println("storedStateMY:"+storedState);



//        if (storedState == null || !storedState.equals(returnedState)) {
//            System.out.println("state 값이 일치하지 않습니다.");
//            return "index.jsp"; // 혹은 다른 에러 처리 페이지
//        }

        String code = request.getParameter("code");
        String accessToken = "";
        String tokenUrl = "https://kauth.kakao.com/oauth/token";


        try {
            URL url = new URL(tokenUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            // 카카오에 토큰을 요청하는 것은 POST
            conn.setRequestMethod("POST");
            conn.setDoOutput(true); // POST 요청을 위해 true로 설정

            // POST 요청에 필요한 파라미터들을 스트림으로 전송
            try (BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()))) {
                StringBuilder sb = new StringBuilder();
                sb.append("grant_type=authorization_code");
                sb.append("&client_id=").append(ConfigLoader.getProperty("KAKAO_CLIENT_ID")); // 1단계에서 저장한 REST API 키
                sb.append("&redirect_uri=http://127.0.0.1:8080/Project_4team_war_exploded/Controller?type=kakaoCallback"); // 등록했던 리다이렉트 URI
                sb.append("&code=").append(code); // 카카오로부터 받은 임시 코드
                bw.write(sb.toString());
                bw.flush();
            }

            int responseCode = conn.getResponseCode();
            System.out.println("카카오 토큰 요청 응답 코드: " + responseCode); // 디버깅용 로그

            // 응답 읽기
            StringBuilder responseSb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    responseSb.append(line);
                }
            }

            // JSON 파싱으로 액세스 토큰(access_token)을 얻어냅니다.
            JSONParser parser = new JSONParser();
            JSONObject jsonObj = (JSONObject) parser.parse(responseSb.toString());
            accessToken = (String) jsonObj.get("access_token");


            // 얻어낸 액세스 토큰으로 사용자 정보를 가져옵니다.
            getUserInfo(accessToken, request);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "loginResult.jsp"; // 네이버와 동일한 결과 페이지로 이동시킵니다.
    }

    private void getUserInfo(String accessToken, HttpServletRequest request) {
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
        try {
            URL url = new URL(userInfoUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            // 헤더에 액세스 토큰을 담아 보냅니다.
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            int responseCode = conn.getResponseCode();
            System.out.println("카카오 사용자 정보 요청 응답 코드: " + responseCode); // 디버깅용 로그

            // 응답 읽기
            StringBuilder responseSb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    responseSb.append(line);
                }
            }

            // JSON 파싱으로 사용자 정보를 추출합니다.
            JSONParser parser = new JSONParser();
            JSONObject jsonObj = (JSONObject) parser.parse(responseSb.toString());

            long id = (Long) jsonObj.get("id");
            JSONObject kakaoAccount = (JSONObject) jsonObj.get("kakao_account");
            JSONObject profile = (JSONObject) kakaoAccount.get("profile");

            String name = (String) profile.get("nickname");
            String email = (String) kakaoAccount.get("email");


            System.out.println("카카오 사용자 정보: id=" + id + ", nickname=" + name + ", email=" + email); // 디버깅용 로그
            UserVO CheckVO = SignUpDAO.check(email,"KAKAO");
            if(CheckVO==null) {


                UserVO vo = new UserVO();

                // 세션에 로그인 정보를 저장합니다.
                request.getSession().setAttribute("id", String.valueOf(id)); // ID는 Long 타입이므로 문자열로 변환합니다.
                vo.setID(email);
                vo.setName(name);
                request.getSession().setAttribute("loginUser", vo);
                request.getSession().setAttribute("login_provider", "kakao");
                request.getSession().setAttribute("access_token", accessToken);

                SignUpDAO.add(email, String.valueOf(id), name, "KAKAO");
            }
            else{
                request.getSession().setAttribute("loginUser",CheckVO);
                request.getSession().setAttribute("login_provider", "kakao");
                request.getSession().setAttribute("access_token", accessToken);


            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}