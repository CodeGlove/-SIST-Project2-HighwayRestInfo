package com.example.cctv;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import java.io.ByteArrayInputStream;

public class CctvStreamer {

    private static final String BASE_HLS_DIR = "hls_stream/";
    private static final ConcurrentHashMap<String, Process> ffmpegProcesses = new ConcurrentHashMap<>();

    // FFMPEG.exe 파일의 전체 경로를 지정해야 합니다.
    private static final String FFMPEG_PATH = "C:/ffmpeg-7.0.2-essentials_build/ffmpeg-7.0.2-essentials_build/bin/ffmpeg.exe";

    private static final ExecutorService executorService = Executors.newCachedThreadPool();

    public static void main(String[] args) {
        // CCTV ID를 실제 프로젝트에 맞게 정의하세요.
        String cctvId = "cctv001";

        System.out.println("CCTV 스트림 시작 테스트...");

        // API 호출을 통해 실제 스트림 URL을 얻어옵니다.
        String cctvUrl = fetchStreamUrlFromCctvApi();

        if (cctvUrl != null && !cctvUrl.isEmpty()) {
            System.out.println("API로부터 얻은 CCTV URL: " + cctvUrl);
            startStream(cctvUrl, cctvId);
        } else {
            System.err.println("CCTV API로부터 스트림 URL을 가져오지 못했습니다.");
        }

        // 실제 애플리케이션 로직...
        // 5초 후에 스트림을 중지하는 예시
        try {
            Thread.sleep(5000);
            stopStream(cctvId);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    /**
     * HLS 스트리밍을 시작하는 메서드입니다.
     * @param cctvUrl - API로부터 얻은 RTSP/RTMP 주소
     * @param cctvId - CCTV를 식별하는 고유 ID
     * @return - HLS 스트림 URL 또는 오류 메시지
     */
    public static String startStream(String cctvUrl, String cctvId) {
        System.out.println("CCTV 스트림 시작 요청: cctvId=" + cctvId + ", cctvUrl=" + cctvUrl);

        if (ffmpegProcesses.containsKey(cctvId)) {
            System.out.println("CCTV 스트림이 이미 실행 중입니다: " + cctvId);
            return BASE_HLS_DIR + cctvId + "/stream.m3u8";
        }

        File hlsDir = new File(BASE_HLS_DIR + cctvId);
        if (!hlsDir.exists()) {
            hlsDir.mkdirs();
        }

        List<String> command = new ArrayList<>();
        command.add(FFMPEG_PATH);
        command.addAll(Arrays.asList(
                "-i", cctvUrl,
                "-codec", "copy",
                "-hls_list_size", "10",
                "-hls_time", "2",
                "-hls_segment_filename", hlsDir.getPath() + "/stream_%03d.ts",
                "-y",
                hlsDir.getPath() + "/stream.m3u8"
        ));

        System.out.println("FFmpeg 명령어: " + String.join(" ", command));

        try {
            ProcessBuilder pb = new ProcessBuilder(command);
            pb.redirectErrorStream(true);
            Process process = pb.start();

            executorService.submit(() -> {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        System.out.println("[FFmpeg]: " + line);
                    }
                } catch (Exception e) {
                    System.err.println("FFmpeg 스트림 읽기 중 오류 발생: " + e.getMessage());
                }
            });

            process.onExit().thenAccept(p -> {
                ffmpegProcesses.remove(cctvId);
                System.out.println("FFmpeg 프로세스 종료: " + cctvId);
            });

            ffmpegProcesses.put(cctvId, process);
            System.out.println("FFmpeg 프로세스가 성공적으로 시작되었습니다: " + cctvId);

            return BASE_HLS_DIR + cctvId + "/stream.m3u8";

        } catch (Exception e) {
            System.err.println("FFmpeg 프로세스 시작 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            ffmpegProcesses.remove(cctvId);
            return "FFmpeg 프로세스 시작 실패: " + e.getMessage();
        }
    }

    /**
     * HLS 스트리밍을 중지하는 메서드입니다.
     * @param cctvId - 중지할 CCTV ID
     * @return - 중지 상태 메시지
     */
    public static String stopStream(String cctvId) {
        Process process = ffmpegProcesses.remove(cctvId);
        if (process != null) {
            process.destroy();
            System.out.println("FFmpeg 프로세스 중지 요청: " + cctvId);
            return "CCTV 스트림이 중지되었습니다: " + cctvId;
        } else {
            System.out.println("실행 중인 CCTV 스트림이 없습니다: " + cctvId);
            return "실행 중인 CCTV 스트림이 없습니다: " + cctvId;
        }
    }

    /**
     * ITS 국가교통정보센터 API를 호출하여 CCTV 스트림 URL을 가져오는 메서드입니다.
     * TODO: 이 코드를 실제 API 호출 로직으로 교체해야 합니다.
     * @return - API로부터 얻은 CCTV 스트림 URL
     */
    private static String fetchStreamUrlFromCctvApi() {
        System.out.println("CCTV API를 호출하여 스트림 URL을 가져오는 중...");

        try {
            StringBuilder urlBuilder = new StringBuilder("https://openapi.its.go.kr:9443/cctvInfo");

            // FIXME: YOUR_API_KEY 부분을 발급받은 실제 인증키로 교체해야 합니다!
            urlBuilder.append("?" + URLEncoder.encode("apiKey", "UTF-8") + "=" + URLEncoder.encode("3750a19970194cbc81d5fed6da710088", "UTF-8"));

            urlBuilder.append("&" + URLEncoder.encode("type", "UTF-8") + "=" + URLEncoder.encode("all", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("cctvType", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); // HLS 스트림
            urlBuilder.append("&" + URLEncoder.encode("minX", "UTF-8") + "=" + URLEncoder.encode("126.800000", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("maxX", "UTF-8") + "=" + URLEncoder.encode("127.890000", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("minY", "UTF-8") + "=" + URLEncoder.encode("34.900000", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("maxY", "UTF-8") + "=" + URLEncoder.encode("35.100000", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("getType", "UTF-8") + "=" + URLEncoder.encode("xml", "UTF-8"));

            URL url = new URL(urlBuilder.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-type", "text/xml;charset=UTF-8");

            System.out.println("API 응답 코드: " + conn.getResponseCode());

            if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                try (BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = rd.readLine()) != null) {
                        sb.append(line);
                    }
                    String xmlResponse = sb.toString();

                    // XML 응답 파싱
                    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                    DocumentBuilder builder = factory.newDocumentBuilder();
                    Document doc = builder.parse(new ByteArrayInputStream(xmlResponse.getBytes("UTF-8")));

                    NodeList cctvUrls = doc.getElementsByTagName("cctvurl");
                    if (cctvUrls.getLength() > 0) {
                        // 첫 번째 CCTV의 URL을 반환
                        return cctvUrls.item(0).getTextContent();
                    }
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
