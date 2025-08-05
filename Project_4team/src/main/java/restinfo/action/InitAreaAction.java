package restinfo.action;

import mybatis.vo.ServiceAreaVO;
import mybatis.vo.ShopVO;
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
        // 휴게소 리스트, 여기에 입점업체 리스트도 있음
        List<ServiceAreaVO> SAlist = new ArrayList<>();

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
            JSONArray SAitems = json.getJSONArray("list");

            // 🔁 각 항목을 반복하면서 VO 객체로 변환
            for (int i = 0; i < SAitems.length(); i++) {
                JSONObject SAitem = SAitems.getJSONObject(i); // 각 객체 추출

                // "홍성(서울)휴게소" 에서 괄호 안 내용 빼기
                String text = SAitem.getString("svarNm");

                int start = text.indexOf('(');
                int end = text.indexOf(')');

                String inside = "";   // 괄호 안
                String outside = text; // 괄호 제거된 전체

                if (start != -1 && end != -1 && end > start) {
                    inside = text.substring(start, end + 1); // (와 ) 사이
                    outside = text.substring(0, start) + text.substring(end + 1); // 앞 + 뒤
                }

                // 고속도로 코드 0150 에서 15만 뽑아내기
                String routeNum = SAitem.getString("routeCd");
                start = 0;

                while (routeNum.charAt(start) == '0') {
                    start++;
                }
                String wayNum = routeNum.substring(start, routeNum.length() - 1);

                // 🧱 휴게소VO 생성 및 값 설정
                ServiceAreaVO savo = new ServiceAreaVO();
                savo.setSAName(outside);           // 휴게소명
                if (inside.equals(""))
                    savo.setSADirection("양방향");
                else
                    savo.setSADirection(SAitem.getString("gudClssNm") + inside);     // 방향

                System.out.println(wayNum);
                savo.setWayNum(wayNum);     // 도로명
                savo.setCompactParking(SAitem.getString("cocrPrkgTrcn"));
                savo.setLargeParking(SAitem.optString("fscarPrkgTrcn", "0"));
                savo.setDisabledParking(SAitem.optString("dspnPrkgTrcn", "0"));
                savo.setAddress(SAitem.getString("svarAddr"));       // 주소
                savo.setTel(SAitem.getString("rprsTelNo"));         // 전화번호
                savo.setShopCode(SAitem.getString("bsopAdtnlFcltCd"));     //영업점포코드


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                // 각 휴게소의 입점업체 불러오기
                String ShopUrl = "https://data.ex.co.kr/openapi/restinfo/restBrandList"
                        + "?key=0597292231"
                        +"&type=json&numOfRows=100&pageNo=1&stdRestNm="+
                        SAitem.getString("svarNm");

                url = new URL(ShopUrl);
                conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");

                // 연결(API요청)
                in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

                // 응답결과 받기
                sb = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    sb.append(inputLine);
                }
                in.close(); // 스트림 닫기

                // 📦 전체 JSON 객체 파싱
                json = new JSONObject(sb.toString());

                // 📑 "list" 배열 추출 (실제 데이터들이 들어 있는 배열)
                JSONArray Shopitems = json.getJSONArray("list");

                for (int k = 0; k < Shopitems.length(); k++) {
                    JSONObject Shopitem = Shopitems.getJSONObject(k); // 각 객체 추출
                    ShopVO shop = new ShopVO();
//                    shop.setSAName(outside);
//                    if (inside.equals(""))
//                        shop.setSADirection("양방향");
//                    else
//                        shop.setSADirection(SAitem.getString("gudClssNm") + inside);// 방향

                    // 입점 업체명 : 외부 데이터셋의 데이터가 일관성이 없어 정제작업 해야함
                    if (Shopitem.getString("brdName").equals("기타")) { // 받아온 문자열이 "기타"라면 다른 컬럼을 받아야함
                        String str = Shopitem.getString("brdDesc").trim(); // 다른 컬럼 받기
                        String[] ar = null;
                         if (str.contains("는") || str.contains("은") || str.contains(" ")) { // 해당 문자열은 문장식으로 점포를 설명되는 레코드도 있다 점포명만 추출
                            if (str.contains(("는")))
                                shop.setShopName(str.substring(0, str.indexOf("는")));
                            if (str.contains(("은")))
                                shop.setShopName(str.substring(0, str.indexOf("은")));
                            if (str.contains((" ")))
                                shop.setShopName(str.substring(0, str.indexOf(" ")));
                            continue;
                        } else if (str.contains(",") || str.contains("/")) { // 해당 컬럼의 값은 ,나 /로 묶여있을 수 있음
                            if (str.contains(","))
                                ar = str.split(",");
                            if (str.contains("/")){
                                if (ar != null){ // 이 문자열은 ,도 있고 /도 있는 문자열이다
                                    ar = str.split(",/");
                                } else // "/"만 가진 문자열일 경우
                                    ar = str.split("/");
                            }
                            for (String s : ar) { // 구분자로 나눈 문자열배열 각각 레코드들로 넣기
                                ShopVO splitValue = new ShopVO();
                                splitValue.setShopName(s);
                                savo.getShoplist().add(splitValue);
                            }
                            continue;
                        } else if (str.contains("/")) {
                            ar = str.split("/");
                            for (String s : ar) {
                                ShopVO splitValue = new ShopVO();
                                splitValue.setShopName(s);
                                savo.getShoplist().add(splitValue);
                            }
                            continue;
                        } else
                            shop.setShopName(str);
                    }
                    else // 정상적으로 컬럼을 받은 경우
                        shop.setShopName(Shopitem.getString("brdName"));

                    // 받아온 점포 정보 vo에 넣어두기
                    savo.getShoplist().add(shop);
                }

                SAlist.add(savo); // 리스트에 VO 추가
            }

            ManageDAO.initSA(SAlist);


        } catch (Exception e) {
            e.printStackTrace();
        }
        return "manage.jsp";
    }

    private
}
