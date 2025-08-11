package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class VideoProxyAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String temporaryUrl = request.getParameter("temporaryUrl");

        if (temporaryUrl == null || temporaryUrl.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("temporaryUrl parameter is missing.");
            return null;
        }

        try {
            System.out.println("프록시 요청 시작: " + temporaryUrl); // 요청 시작 로그

            URL url = new URL(temporaryUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader rd;
            int responseCode = conn.getResponseCode();

            if (responseCode >= 200 && responseCode <= 300) {
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                System.err.println("프록시 요청 실패! 응답 코드: " + responseCode); // 실패 로그
            }

            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
            rd.close();
            conn.disconnect();

            // 서버 콘솔에 반환되는 실제 URL을 출력합니다.
            System.out.println("프록시 응답: " + sb.toString());

            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write(sb.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error fetching video stream URL.");
        }

        return null;
    }
}
