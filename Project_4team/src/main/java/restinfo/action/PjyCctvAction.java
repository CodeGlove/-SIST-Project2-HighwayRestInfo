// 이 파일은 API 응답을 처리하는 PjyCctvAction.java의 수정된 전체 코드입니다.
// 기존 파일의 내용을 이 코드로 완전히 대체하면 됩니다.

package restinfo.action;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
// CctvVO를 사용하지 않으므로 임포트에서 제거합니다.

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
// import java.util.ArrayList; // ArrayList도 사용하지 않습니다.
// import java.util.List; // List도 사용하지 않습니다.

/**
 * CCTV 정보를 조회하고 JSON 형식으로 응답하는 Action 클래스입니다.
 * 외부 API에서 CCTV 데이터를 가져와서 클라이언트에 전달하는 역할을 합니다.
 */
public class PjyCctvAction implements Action {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("GET 요청 처리 중: PjyCctvAction");

        // 응답 타입을 JSON으로 설정하고 한글 인코딩을 지정합니다.
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // CCTV API에서 데이터를 가져오는 메서드 호출
        String jsonResponse = fetchCctvData();

        if (jsonResponse != null) {
            try {
                // 가져온 JSON 문자열을 Gson 라이브러리를 사용해 파싱합니다.
                JsonElement jsonElement = JsonParser.parseString(jsonResponse);

                // JSON 응답이 'data' 키를 가진 객체 형태인지 확인
                if (jsonElement.isJsonObject()) {
                    JsonObject jsonObject = jsonElement.getAsJsonObject();

                    // 'data' 키를 가진 JsonArray를 가져옵니다.
                    // 만약 응답이 'data' 키가 없는 배열이라면 아래 조건문은 실패할 것입니다.
                    if (jsonObject.has("data") && jsonObject.get("data").isJsonArray()) {
                        JsonArray jsonArray = jsonObject.getAsJsonArray("data");
                        // JsonArray를 문자열로 변환하여 바로 출력
                        out.print(jsonArray.toString());
                        System.out.println("CCTV 데이터 전송 완료. 총 CCTV 수: " + jsonArray.size());
                    } else {
                        // 'data' 키가 없거나 배열이 아닌 경우
                        System.err.println("경고: JSON 응답 구조가 예상과 다릅니다. 'data' 키가 없거나 배열이 아닙니다.");
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Invalid JSON structure.");
                    }
                } else if (jsonElement.isJsonArray()) {
                    // JSON 응답의 루트가 바로 배열인 경우
                    JsonArray jsonArray = jsonElement.getAsJsonArray();
                    out.print(jsonArray.toString());
                    System.out.println("CCTV 데이터 전송 완료. 총 CCTV 수: " + jsonArray.size());
                } else {
                    System.err.println("경고: JSON 응답이 예상된 객체나 배열이 아닙니다.");
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Invalid JSON response type.");
                }

            } catch (Exception e) {
                // JSON 파싱 중 오류가 발생하면 에러 메시지를 출력합니다.
                System.err.println("JSON 파싱 중 오류 발생: " + e.getMessage());
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "JSON parsing error.");
            }
        } else {
            // API 호출 실패 시 에러 응답
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to fetch data from API.");
        }
    }

    /**
     * 외부 CCTV API를 호출하여 데이터를 가져오는 메서드입니다.
     * @return API 응답을 담은 JSON 문자열, 실패 시 null
     */
    private String fetchCctvData() throws IOException {
        System.out.println("CCTV API를 호출하여 스트림 URL을 가져오는 중...");
        try {
            // TODO: YOUR_API_KEY 부분을 실제 발급받은 인증키로 교체해야 합니다!
            String apiKey = "YOUR_API_KEY";

            StringBuilder urlBuilder = new StringBuilder("https://openapi.its.go.kr:9443/cctvInfo");
            urlBuilder.append("?" + URLEncoder.encode("apiKey", "UTF-8") + "=" + URLEncoder.encode(apiKey, "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("type", "UTF-8") + "=" + URLEncoder.encode("all", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("cctvType", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); // HLS 스트림
            urlBuilder.append("&" + URLEncoder.encode("minX", "UTF-8") + "=" + URLEncoder.encode("126.800000", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("maxX", "UTF-8") + "=" + URLEncoder.encode("127.890000", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("minY", "UTF-8") + "=" + URLEncoder.encode("34.900000", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("maxY", "UTF-8") + "=" + URLEncoder.encode("35.100000", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("getType", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));

            URL url = new URL(urlBuilder.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-type", "application/json;charset=UTF-8");

            System.out.println("API 응답 코드: " + conn.getResponseCode());

            if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                try (BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                    return rd.lines().collect(java.util.stream.Collectors.joining());
                }
            } else {
                try (BufferedReader errorRd = new BufferedReader(new InputStreamReader(conn.getErrorStream()))) {
                    System.err.println("API 에러 응답: " + errorRd.lines().collect(java.util.stream.Collectors.joining()));
                }
            }
            conn.disconnect();
        } catch (Exception e) {
            System.err.println("API 호출 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
