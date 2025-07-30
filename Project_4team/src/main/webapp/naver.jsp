<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*, java.io.*, javax.crypto.*, javax.crypto.spec.*, java.util.Base64, java.util.Properties" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>네이버 클라우드 API 테스트</title>
</head>
<body>
    <h1>네이버 클라우드 API 테스트</h1>
    
    <%
    // 설정 파일에서 API 키 읽기
    Properties props = new Properties();
    try {
        props.load(application.getResourceAsStream("/WEB-INF/naver-config.properties"));
    } catch (Exception e) {
        out.println("<p style='color: red;'>설정 파일을 읽을 수 없습니다: " + e.getMessage() + "</p>");
    }
    
    String accessKeyId = props.getProperty("naver.access.key.id", "your_access_key_id");
    String secretAccessKey = props.getProperty("naver.secret.access.key", "your_secret_access_key");
    String baseUrl = props.getProperty("naver.api.base.url", "https://ncloud.apigw.ntruss.com");
    
    // POST 요청을 위한 함수
    public String callNaverCloudAPI(String url, String method, String requestBody) throws Exception {
        String timestamp = String.valueOf(System.currentTimeMillis());
        
        // 서명 생성
        String message = method + " " + url + "\n" + timestamp + "\n" + accessKeyId;
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec signingKey = new SecretKeySpec(secretAccessKey.getBytes(), "HmacSHA256");
        mac.init(signingKey);
        byte[] rawHmac = mac.doFinal(message.getBytes());
        String signature = Base64.getEncoder().encodeToString(rawHmac);
        
        // API 호출
        HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
        connection.setRequestMethod(method);
        connection.setRequestProperty("x-ncp-apigw-timestamp", timestamp);
        connection.setRequestProperty("x-ncp-iam-access-key", accessKeyId);
        connection.setRequestProperty("x-ncp-apigw-signature-v2", signature);
        connection.setRequestProperty("Content-Type", "application/json");
        
        // POST 요청인 경우 body 전송
        if ("POST".equals(method) && requestBody != null) {
            connection.setDoOutput(true);
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = requestBody.getBytes("utf-8");
                os.write(input, 0, input.length);
            }
        }
        
        // 응답 읽기
        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();
        
        return response.toString();
    }
    
    // 설정 확인
    if ("your_access_key_id".equals(accessKeyId)) {
        out.println("<div style='background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; margin: 10px 0;'>");
        out.println("<strong>⚠️ 설정 필요:</strong> WEB-INF/naver-config.properties 파일에서 실제 API 키를 설정해주세요.");
        out.println("</div>");
    }
    
    try {
        // GET 요청 예시 - 서버 인스턴스 목록 조회
        String getUrl = baseUrl + "/vserver/v2/getServerInstanceList";
        String getResponse = callNaverCloudAPI(getUrl, "GET", null);
        
        out.println("<h2>GET 요청 결과 (서버 목록):</h2>");
        out.println("<pre>" + getResponse + "</pre>");
        
        // POST 요청 예시 - 서버 생성 (실제 사용시 파라미터 수정 필요)
        /*
        String postUrl = baseUrl + "/vserver/v2/createServerInstances";
        String postBody = "{\"serverImageProductCode\":\"SPSW0LINUX000046\",\"serverProductCode\":\"SPSVRSTAND000004\"}";
        String postResponse = callNaverCloudAPI(postUrl, "POST", postBody);
        
        out.println("<h2>POST 요청 결과 (서버 생성):</h2>");
        out.println("<pre>" + postResponse + "</pre>");
        */
        
    } catch (Exception e) {
        out.println("<h2>에러 발생:</h2>");
        out.println("<p style='color: red;'>" + e.getMessage() + "</p>");
    }
    %>
    
    <h2>사용 가능한 API 예시</h2>
    <ul>
        <li><strong>서버 관리:</strong> getServerInstanceList, createServerInstances, deleteServerInstances</li>
        <li><strong>네트워크:</strong> getVpcList, getSubnetList, getNetworkAclList</li>
        <li><strong>스토리지:</strong> getBlockStorageInstanceList, createBlockStorageInstance</li>
        <li><strong>로드밸런서:</strong> getLoadBalancerInstanceList, createLoadBalancerInstance</li>
    </ul>
    
    <h2>설정 방법</h2>
    <ol>
        <li>네이버 클라우드 콘솔에서 Access Key 생성</li>
        <li>WEB-INF/naver-config.properties 파일에서 실제 API 키 입력</li>
        <li>원하는 API 엔드포인트로 URL 변경</li>
        <li>HTTP 메서드(GET, POST, PUT, DELETE)에 맞게 수정</li>
    </ol>
</body>
</html>
