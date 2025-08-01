package restinfo.action;

import mybatis.vo.ServiceAreaVO;
import org.json.JSONArray;
import org.json.JSONObject;
import restinfo.dao.ManageDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class InitAreaAction implements Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {

        String SAUrl = "https://data.ex.co.kr/openapi/restinfo/hiwaySvarInfoList"
                + "?key=0597292231"
                + "&type=json&numOfRows=1000&svarNm=%ED%9C%B4%EA%B2%8C%EC%86%8C&svarGsstClssCd=0";
        // 휴게소의 입점업체 불러오기
        String ShopUrl = "https://data.ex.co.kr/openapi/restinfo/restBrandList"
                + "?key=0597292231";

        List<ServiceAreaVO> list = new ArrayList<>();
        //https://data.ex.co.kr/openapi/business/serviceAreaRoute?key=0597292231&type=json&numOfRows=1000&svarNm=휴게소&svarGsstClssCd=0
        try {
            // 📡 URL 객체 생성 + 연결 설정
            URL url = new URL(SAUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection(); // URL 연결 객체
            conn.setRequestMethod("GET"); // GET 방식 요청

            // 📥 응답 데이터를 읽어오기 위한 스트림
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8")
            );

            // 📚 응답 결과 문자열로 읽기
            String inputLine;
            StringBuilder sb = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                sb.append(inputLine); // 줄 단위로 이어붙이기
            }
            in.close(); // 스트림 닫기

            // 📦 전체 JSON 객체 파싱
            JSONObject json = new JSONObject(sb.toString());

            // 📑 "list" 배열 추출 (실제 데이터들이 들어 있는 배열)
            JSONArray items = json.getJSONArray("list");

            // 🔁 각 항목을 반복하면서 VO 객체로 변환
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i); // 각 객체 추출

                // "홍성(서울)휴게소" 에서 괄호 안 내용 빼기
                String text = item.getString("svarNm");

                int start = text.indexOf('(');
                int end = text.indexOf(')');

                String inside = "";   // 괄호 안
                String outside = text; // 괄호 제거된 전체

                if (start != -1 && end != -1 && end > start) {
                    inside = text.substring(start, end + 1); // (와 ) 사이
                    outside = text.substring(0, start) + text.substring(end + 1); // 앞 + 뒤
                }

                // 0150 에서 15 뽑아내기
                String routeNum = item.getString("routeCd");
                start = 0;

                while (routeNum.charAt(start) == '0') {
                    start++;
                }
                String wayNum = routeNum.substring(start, routeNum.length() - 1);

                // 🧱 VO 생성 및 값 설정
                ServiceAreaVO savo = new ServiceAreaVO();
                savo.setSAName(outside);           // 휴게소명
                if (inside.equals(""))
                    savo.setSADirection("양방향");
                else
                    savo.setSADirection(item.getString("gudClssNm") + inside);     // 방향
                System.out.println(wayNum);
                savo.setWayNum(wayNum);     // 도로명
                savo.setCompactParking(item.getString("cocrPrkgTrcn"));
                savo.setLargeParking(item.optString("fscarPrkgTrcn", "0"));
                savo.setDisabledParking(item.optString("dspnPrkgTrcn", "0"));
                savo.setAddress(item.getString("svarAddr"));       // 주소
                savo.setTel(item.getString("rprsTelNo"));         // 전화번호
                savo.setShopCode(item.getString("bsopAdtnlFcltCd"));     //영업점포코드

                list.add(savo); // 리스트에 VO 추가
            }

            ManageDAO.initSA(list);


        } catch (Exception e) {
            e.printStackTrace();
        }
        return "manage.jsp";
    }
}
