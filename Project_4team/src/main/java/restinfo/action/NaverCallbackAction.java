package restinfo.action;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import jakarta.mail.Session;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import restinfo.util.ConfigLoader;

import static java.lang.System.out;

public class NaverCallbackAction implements Action {

    private static final Logger log = LoggerFactory.getLogger(NaverCallbackAction.class);

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {

        log.info("네이버 로그인 완료: {}", response.toString());

        String clientId = ConfigLoader.getProperty("NAVER_CLIENT_ID");
        String clientSecret = ConfigLoader.getProperty("NAVER_CLIENT_SECRET");;//애플리케이션 클라이언트 시크릿값";
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        log.info("Code: {}, State: {}", code, state);
        String redirectURI = URLEncoder.encode("http://127.0.0.1:8080/Project_4team_war_exploded/Controller?type=naverCallback", StandardCharsets.UTF_8);
        String apiURL;
        apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
        apiURL += "client_id=" + clientId;
        apiURL += "&client_secret=" + clientSecret;
        apiURL += "&redirect_uri=" + redirectURI;
        apiURL += "&code=" + code;
        apiURL += "&state=" + state;
        String access_token = "";
        String refresh_token = "";
        out.println("apiURL="+apiURL);
        try {
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("GET");
            int responseCode = con.getResponseCode();
            BufferedReader br;
            out.print("responseCode="+responseCode);
            if(responseCode==200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {  // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            String inputLine;
            StringBuffer res = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                res.append(inputLine);
            }
            br.close();
            if(responseCode == 200) {
                out.println(res);

                // 1. JSON 파서 객체 생성
                JSONParser parser = new JSONParser();
                // 2. 응답 문자열(res)을 JSON 객체로 변환
                JSONObject jsonObj = (JSONObject) parser.parse(res.toString());

                access_token = (String) jsonObj.get("access_token");
                refresh_token = (String) jsonObj.get("refresh_token");
                log.info("Access Token: {}", access_token);
                log.info("Refresh Token: {}", refresh_token);

                String header = "Bearer " + access_token; // Bearer 다음에 공백 추가

                String profileApiURL = "https://openapi.naver.com/v1/nid/me";

                Map<String, String> requestHeaders = new HashMap<>();
                requestHeaders.put("Authorization", header);

                String responseBody = get(profileApiURL, requestHeaders);

                jsonObj = (JSONObject) parser.parse(responseBody);
                String profileResponse = (String) jsonObj.get("response");
                jsonObj = (JSONObject) parser.parse(profileResponse);
                String userIdentifier = (String) jsonObj.get("id");
                String email = (String) jsonObj.get("email");

                log.info("사용자 식별값: {}, 이메일: {}", userIdentifier, email);

                request.getSession().setAttribute("id", userIdentifier);
                request.getSession().setAttribute("email", email);
                System.out.println(responseBody);
            }
        } catch (Exception e) {
            out.println(e);
        }

        return "Controller?type=mainpage";
    }


    private static String get(String apiUrl, Map<String, String> requestHeaders){
        HttpURLConnection con = connect(apiUrl);
        try {
            con.setRequestMethod("GET");
            for(Map.Entry<String, String> header : requestHeaders.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }

            int responseCode = con.getResponseCode(); // statusCode
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
                return readBody(con.getInputStream());
            } else { // 에러 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
    }


    private static HttpURLConnection connect(String apiUrl){
        try {
            URL url = new URL(apiUrl);
            return (HttpURLConnection)url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
        }
    }


    private static String readBody(InputStream body){
        InputStreamReader streamReader = new InputStreamReader(body);


        try (BufferedReader lineReader = new BufferedReader(streamReader)) {
            StringBuilder responseBody = new StringBuilder();


            String line;
            while ((line = lineReader.readLine()) != null) {
                responseBody.append(line);
            }


            return responseBody.toString();
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
        }
    }
}
