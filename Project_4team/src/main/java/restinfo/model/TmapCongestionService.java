package restinfo.model;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.Random;

public class TmapCongestionService {
    private static final String APP_KEY;
    private static final String CONGESTION_API_URL = "https://apis.openapi.sk.com/tmap/traffic/rest-area-congestion";

    static {
        Properties properties = new Properties();
        try (InputStream input = TmapCongestionService.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (input == null) {
                APP_KEY = null;
            } else {
                properties.load(input);
                APP_KEY = properties.getProperty("tmap.appkey");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load action.properties");
        }
    }

    // 반환 타입을 String으로 변경
    public static String getCongestionLevel(String restAreaId) {
        if (APP_KEY == null) {
            System.err.println("API 키가 설정되지 않았습니다.");
            return "미지원";
        }

        HttpClient client = HttpClient.newHttpClient();
        String urlWithParams = String.format("%s?version=1&restAreaId=%s", CONGESTION_API_URL, restAreaId);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(urlWithParams))
                .header("appKey", APP_KEY)
                .header("Accept", "application/json")
                .GET()
                .build();

        try {
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            Gson gson = new Gson();
            JsonObject jsonObject = gson.fromJson(response.body(), JsonObject.class);

            if (jsonObject != null && jsonObject.has("result")) {
                JsonObject result = jsonObject.getAsJsonObject("result");
                if (result.has("congestionStatus")) {
                    String status = result.get("congestionStatus").getAsString();
                    switch (status) {
                        case "NORMAL": return "1"; // 원활
                        case "BUSY": return "2";   // 보통
                        case "CONGESTED": return "3"; // 혼잡
                        case "VERY_CONGESTED": return "4"; // 매우 혼잡
                        default: return "미지원";
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Tmap 교통 API 호출 또는 JSON 파싱 중 오류가 발생했습니다: " + e.getMessage());
        }

        // 호출 실패 시 "미지원" 반환
        return "미지원";
    }
}