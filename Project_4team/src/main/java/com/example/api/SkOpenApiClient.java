// src/main/java/com/example/api/SkOpenApiClient.java
package com.example.api;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class SkOpenApiClient {
    // 여기에 발급받은 **TMAP API용 App Key**를 입력하세요!
    private static final String TMAP_APP_KEY = "v2aCdkhLeAsPgaeZy0ov8Ao8KpkU0WW2kKRwuIo5";
    // 여기에 발급받은 **Puzzle POI API용 App Key**를 입력하세요!
    private static final String PUZZLE_APP_KEY = "v2aCdkhLeAsPgaeZy0ov8Ao8KpkU0WW2kKRwuIo5";

    private final OkHttpClient httpClient = new OkHttpClient();

    public String searchPoi(String keyword) throws IOException {
        String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8.toString());
        String url = String.format(
                "https://apis.openapi.sk.com/tmap/pois?version=1&searchKeyword=%s&resCoordType=WGS84GEO&reqCoordType=WGS84GEO&count=10",
                encodedKeyword
        );
        Request request = new Request.Builder()
                .url(url)
                .header("Accept", "application/json")
                .header("appKey", TMAP_APP_KEY)
                .build();
        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) { /* 에러 처리 */ }
            return response.body().string();
        }
    }

    public String getPlaceCongestion(String poiId, String date) throws IOException {
        String url = String.format("https://apis.sktelecom.com/v1/puzzle/place/stat/%s?date=%s", poiId, date);
        Request request = new Request.Builder()
                .url(url)
                .header("Accept", "application/json")
                .header("appKey", PUZZLE_APP_KEY)
                .build();
        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) { /* 에러 처리 */ }
            return response.body().string();
        }
    }
}