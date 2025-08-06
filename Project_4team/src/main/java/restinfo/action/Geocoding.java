package restinfo.action;

import com.google.gson.Gson;
import mybatis.vo.ServiceAreaVO;
import restinfo.dao.ServiceAreaDAO;
import restinfo.util.ConfigLoader;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class Geocoding {

    static class KakaoResponse { List<Document> documents; }
    static class Document { String x; String y; }

    public static void mapping(List<ServiceAreaVO> list) {

        String KAKAO_API_KEY = ConfigLoader.getProperty("KAKAO_CLIENT_ID");
        Gson gson = new Gson();

        System.out.println("총 " + list.size() + "개의 휴게소 좌표 변환을 시작합니다.");

        for (ServiceAreaVO sa : list) {
            try {
                // 주소가 비어있으면 건너뛰기
                if (sa.getAddress() == null || sa.getAddress().trim().isEmpty()) {
                    System.out.println(sa.getSAName() + " -> 주소 없음, 건너뜁니다.");
                    continue;
                }


                String encodedAddress = URLEncoder.encode(sa.getAddress(), StandardCharsets.UTF_8);
                System.out.println(encodedAddress);
                String apiUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + encodedAddress;

                URL url = new URL(apiUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("Authorization", "KakaoAK " + KAKAO_API_KEY);


                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
                br.close();
                // --- 👇 디버깅 코드 추가 ---
                System.out.println("카카오 서버 원본 응답: " + response.toString());


                Geocoding.KakaoResponse kakaoResponse = gson.fromJson(response.toString(), Geocoding.KakaoResponse.class);
                if (kakaoResponse.documents != null && !kakaoResponse.documents.isEmpty()) {
                    Geocoding.Document doc = kakaoResponse.documents.get(0);
                    String lng = String.valueOf(doc.x); // 경도
                    String lat = String.valueOf(doc.y); // 위도

                    System.out.println(sa.getSAName() + " -> lat: " + lat + ", lng: " + lng);

                    sa.setLat(lat);
                    sa.setLng(lng);

                } else {
                    System.out.println(sa.getSAName() + " -> 좌표를 찾을 수 없음.");
                }

                // 3. 카카오 API 요청 제한을 피하기 위해 잠시 대기
                Thread.sleep(100);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        System.out.println("--- 좌표 변환 작업 완료 ---");
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public static void mapping() {
        // 1. DB에서 모든 휴게소 목록을 불러옴
        List<ServiceAreaVO> list = ServiceAreaDAO.getAll();

        String KAKAO_API_KEY = ConfigLoader.getProperty("KAKAO_CLIENT_ID");
        Gson gson = new Gson();

        System.out.println("총 " + list.size() + "개의 휴게소 좌표 변환을 시작합니다.");

        for (ServiceAreaVO sa : list) {
            try {
                // 주소가 비어있으면 건너뛰기
                if (sa.getAddress() == null || sa.getAddress().trim().isEmpty()) {
                    System.out.println(sa.getSAName() + " -> 주소 없음, 건너뜁니다.");
                    continue;
                }


                String encodedAddress = URLEncoder.encode(sa.getAddress(), StandardCharsets.UTF_8);
                System.out.println(encodedAddress);
                String apiUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + encodedAddress;

                URL url = new URL(apiUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("Authorization", "KakaoAK " + KAKAO_API_KEY);


                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
                br.close();
                // --- 👇 디버깅 코드 추가 ---
                System.out.println("카카오 서버 원본 응답: " + response.toString());


                KakaoResponse kakaoResponse = gson.fromJson(response.toString(), KakaoResponse.class);
                if (kakaoResponse.documents != null && !kakaoResponse.documents.isEmpty()) {
                    Document doc = kakaoResponse.documents.get(0);
                    double lng = Double.parseDouble(doc.x); // 경도
                    double lat = Double.parseDouble(doc.y); // 위도

                    System.out.println(sa.getSAName() + " -> lat: " + lat + ", lng: " + lng);

                    // 2. DB에 UPDATE 쿼리를 실행하는 DAO 메소드 호출
                    ServiceAreaDAO.updateXY(sa.getIdx(), lat, lng);

                } else {
                    System.out.println(sa.getSAName() + " -> 좌표를 찾을 수 없음.");
                }

                // 3. 카카오 API 요청 제한을 피하기 위해 잠시 대기
                Thread.sleep(100);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        System.out.println("--- 좌표 변환 작업 완료 ---");
    }
}