package restinfo.model;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Properties;

public class TmapCongestionService {
    private static final String APP_KEY;
    private static final String CONGESTION_URL = "https://apis.openapi.sk.com/tmap/puzzle/pois/";

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
            throw new RuntimeException("Failed to load application.properties");
        }
    }

    public static int getCongestionLevel(String poiId) {
        if (APP_KEY == null) {
            System.err.println("API 키가 설정되지 않았습니다.");
            return -1;
        }

        HttpClient client = HttpClient.newHttpClient();
        String urlWithParams = String.format("%s%s?appKey=%s", CONGESTION_URL, poiId, APP_KEY);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(urlWithParams))
                .header("Accept", "application/json")
                .GET()
                .build();

        try {
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            Gson gson = new Gson();
            JsonObject jsonObject = gson.fromJson(response.body(), JsonObject.class);

            if (jsonObject != null && jsonObject.has("contents")) {
                return jsonObject.getAsJsonObject("contents")
                        .getAsJsonArray("rltm")
                        .get(0)
                        .getAsJsonObject()
                        .get("congestionLevel")
                        .getAsInt();
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("API 호출 또는 JSON 파싱 중 오류가 발생했습니다: " + e.getMessage());
        }
        return -1;
    }
}