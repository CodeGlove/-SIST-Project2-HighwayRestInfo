package com.example.cctv;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CctvProxyServlet")
public class CctvProxyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cctvUrl = request.getParameter("cctvUrl");

        if (cctvUrl == null || cctvUrl.isEmpty()) {
            System.err.println("Error: cctvUrl parameter is missing.");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "cctvUrl parameter is missing.");
            return;
        }
        HttpURLConnection connection = null;
        InputStream input = null;
        OutputStream output = null;

        try {
            // 실제 CCTV HLS 스트림 URL에 연결
            URL url = new URL(cctvUrl);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setInstanceFollowRedirects(true);
            connection.connect();

            int responseCode = connection.getResponseCode();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                System.err.println("Error: Failed to fetch CCTV stream. Response code: " + responseCode);
                response.sendError(responseCode, "Failed to fetch CCTV stream.");
                return;
            }

            // HLS Mime Type 설정 (Video.js와 Hls.js가 인식하도록)
            response.setContentType("application/vnd.apple.mpegurl");
            response.setStatus(HttpServletResponse.SC_OK);

            // 실제 스트림 데이터를 클라이언트로 전달
            input = connection.getInputStream();
            output = response.getOutputStream();

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
            output.flush();

        } catch (IOException e) {
            System.err.println("Error proxying CCTV stream: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Proxying failed.");
        } finally {
            if (input != null) try { input.close(); } catch (IOException e) {}
            if (output != null) try { output.close(); } catch (IOException e) {}
            if (connection != null) connection.disconnect();
        }
    }
}
