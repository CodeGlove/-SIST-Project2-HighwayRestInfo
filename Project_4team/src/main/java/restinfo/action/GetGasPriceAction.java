package restinfo.action;

import org.json.JSONArray;
import org.json.JSONObject;
import restinfo.util.ConfigLoader;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class GetGasPriceAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String EXPRESSWAY_API_KEY = ConfigLoader.getProperty("EXPRESSWAY_ID");

        String SAUrl = "https://data.ex.co.kr/openapi/restinfo/hiwaySvarInfoList?key="
                + EXPRESSWAY_API_KEY
                + "&type=json&svarCd=000315"; //휴게소번호(idx)에 해당하는 휴게소

        try {
            // 📡 URL 객체 생성 + 연결 설정
            URL url = new URL(SAUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection(); // URL 연결 객체
            conn.setRequestMethod("GET"); // GET 방식 요청

            // 📥 응답 데이터를 읽어오기 위한 스트림
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8")
            );

            // 📚 응답 결과 문자열로 읽기
            String inputLine;
            StringBuilder sb = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                sb.append(inputLine); // 줄 단위로 이어붙이기
            }
            in.close(); // 스트림 닫기

            // 📦 전체 JSON 객체 파싱
            JSONObject json = new JSONObject(sb.toString());

            // 📑 "list" 배열 추출 (실제 데이터들이 들어 있는 배열)
            JSONArray SAitems = json.getJSONArray("list"); //api에서 주는 key

            // 🔁 각 항목을 반복하면서 VO 객체로 변환
            for (int i = 0; i < SAitems.length(); i++) {
                JSONObject SAitem = SAitems.getJSONObject(i); // 각 객체 추출
            }







        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
}
