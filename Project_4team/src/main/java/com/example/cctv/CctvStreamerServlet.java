// 이 파일은 Servlet 기반 웹 애플리케이션을 위한 컨트롤러 파일입니다.
// 프로젝트의 `src/main/java/com/example/cctv/` 폴더에 `CctvStreamerServlet.java`라는 이름으로 저장하세요.

package com.example.cctv;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

@WebServlet("/api/cctv/*")
public class CctvStreamerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String BASE_HLS_DIR = "hls_stream/";
    private static final ConcurrentHashMap<String, Process> ffmpegProcesses = new ConcurrentHashMap<>();

    // FFMPEG.exe 파일의 전체 경로를 지정해야 합니다.
    private static final String FFMPEG_PATH = "C:/ffmpeg-7.0.2-essentials_build/ffmpeg-7.0.2-essentials_build/bin/ffmpeg.exe";

    private static final ExecutorService executorService = Executors.newCachedThreadPool();

    /**
     * GET 요청을 처리하는 메서드. API 요청을 분석하여 스트리밍을 시작하거나 중지합니다.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String[] pathParts = pathInfo != null ? pathInfo.split("/") : new String[0];

        // JSON 응답을 위한 설정
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (pathParts.length >= 3) {
            String action = pathParts[1]; // 'start' 또는 'stop'
            String cctvId = pathParts[2]; // CCTV ID
            Map<String, String> result;

            if ("start".equals(action)) {
                result = startStreamApi(cctvId);
            } else if ("stop".equals(action)) {
                result = stopStreamApi(cctvId);
            } else {
                result = Map.of("status", "error", "message", "잘못된 API 경로입니다.");
            }
            out.print(mapToJson(result));
        } else {
            out.print(mapToJson(Map.of("status", "error", "message", "잘못된 API 경로입니다.")));
        }
    }

    private String mapToJson(Map<String, String> map) {
        return "{" +
                map.entrySet().stream()
                        .map(entry -> "\"" + entry.getKey() + "\": \"" + entry.getValue() + "\"")
                        .collect(Collectors.joining(", ")) +
                "}";
    }

    private Map<String, String> startStreamApi(String cctvId) {
        System.out.println("API 호출 - CCTV 스트림 시작 요청: " + cctvId);

        // 실제 API에서 CCTV URL을 가져오는 로직
        String cctvUrl = fetchStreamUrlFromCctvApi(cctvId);

        if (cctvUrl != null && !cctvUrl.isEmpty()) {
            String hlsUrl = startStream(cctvUrl, cctvId);
            return Map.of("status", "success", "hlsUrl", hlsUrl);
        } else {
            return Map.of("status", "error", "message", "CCTV URL을 가져오지 못했습니다.");
        }
    }

    private Map<String, String> stopStreamApi(String cctvId) {
        String message = stopStream(cctvId);
        return Map.of("status", "success", "message", message);
    }

    private String startStream(String cctvUrl, String cctvId) {
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

        System.out.println("FFmpeg 명령어: " + command.stream().collect(Collectors.joining(" ")));

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

    private String stopStream(String cctvId) {
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

    private String fetchStreamUrlFromCctvApi(String cctvId) {
        System.out.println("CCTV API를 호출하여 스트림 URL을 가져오는 중...");
        try {
            // 이전에 사용자가 제공한 API 키를 직접 입력하세요.
            // FIXME: YOUR_API_KEY 부분을 발급받은 실제 인증키로 교체해야 합니다!
            String apiKey = "3750a19970194cbc81d5fed6da710088\n";

            StringBuilder urlBuilder = new StringBuilder("https://openapi.its.go.kr:9443/cctvInfo");
            urlBuilder.append("?" + URLEncoder.encode("apiKey", "UTF-8") + "=" + URLEncoder.encode(apiKey, "UTF-8"));
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
                    String xmlResponse = rd.lines().collect(Collectors.joining());

                    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                    DocumentBuilder builder = factory.newDocumentBuilder();
                    Document doc = builder.parse(new ByteArrayInputStream(xmlResponse.getBytes("UTF-8")));

                    NodeList cctvUrls = doc.getElementsByTagName("cctvurl");
                    if (cctvUrls.getLength() > 0) {
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
