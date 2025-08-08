package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

public class CctvStreamAction implements Action {

    // 각 CCTV URL에 대한 FFmpeg 프로세스를 저장하는 정적 맵
    // 서버가 재시작될 때까지 프로세스 상태를 유지
    private static final ConcurrentHashMap<String, Process> activeCctvProcesses = new ConcurrentHashMap<>();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        String rtmpUrl = request.getParameter("cctvUrl");
        if (rtmpUrl == null || rtmpUrl.isEmpty()) {
            try {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "CCTV URL is missing.");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return null;
        }

        try {
            String decodedRtmpUrl = URLDecoder.decode(rtmpUrl, "UTF-8");
            String cctvId = String.valueOf(decodedRtmpUrl.hashCode()); // URL을 기반으로 고유 ID 생성

            // FFmpeg 실행 파일 경로 (환경 변수에 있다면 "ffmpeg"만 입력)
            String ffmpegPath = "ffmpeg";

            // HLS 파일을 저장할 디렉토리 설정
            String tempDir = request.getServletContext().getRealPath("/hls_stream/");
            File tempFolder = new File(tempDir);
            if (!tempFolder.exists()) {
                tempFolder.mkdirs();
            }

            // 각 CCTV 스트림마다 고유한 폴더 사용
            String cctvStreamDir = tempDir + File.separator + cctvId + File.separator;
            File cctvStreamFolder = new File(cctvStreamDir);
            if (!cctvStreamFolder.exists()) {
                cctvStreamFolder.mkdirs();
            }

            String m3u8Filename = "stream.m3u8";
            String m3u8Path = cctvStreamDir + m3u8Filename;

            // 이미 해당 CCTV에 대한 FFmpeg 프로세스가 실행 중인지 확인
            Process existingProcess = activeCctvProcesses.get(cctvId);
            if (existingProcess == null || !existingProcess.isAlive()) {
                // 실행 중인 프로세스가 없으면 새로운 프로세스 시작
                ProcessBuilder pb = new ProcessBuilder(
                        ffmpegPath,
                        "-i", decodedRtmpUrl,
                        "-c", "copy",
                        "-f", "hls",
                        "-hls_flags", "delete_segments",
                        "-hls_list_size", "5",
                        "-hls_time", "1",
                        "-hls_segment_filename", cctvStreamDir + "stream_%03d.ts",
                        m3u8Path
                );
                pb.redirectErrorStream(true);

                Process process = pb.start();
                activeCctvProcesses.put(cctvId, process);

                // HLS 매니페스트 파일이 생성될 때까지 잠시 대기
                long startTime = System.currentTimeMillis();
                File m3u8File = new File(m3u8Path);
                while (!m3u8File.exists() && System.currentTimeMillis() - startTime < 5000) {
                    TimeUnit.MILLISECONDS.sleep(200);
                }
            }

            // HLS URL을 클라이언트에 반환
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            String hlsUrl = request.getContextPath() + "/hls_stream/" + cctvId + "/" + m3u8Filename;
            response.getWriter().write(hlsUrl);

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "FFmpeg processing failed.");
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        }
        return null;
    }
}
