package restinfo.action;

import mybatis.vo.MenuVO;
import mybatis.vo.ServiceAreaVO;
import org.json.JSONArray;
import org.json.JSONObject;
import restinfo.dao.MenuDAO;
import restinfo.dao.ServiceAreaDAO;
import restinfo.util.ConfigLoader;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//여기서 API 호출, 데이터비교, DAO호출을 하는 곳
public class UpdateFoodMenuAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        // 1. AJAX 요청에 대한 기본 응답 설정(JSON)
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject jsonResult = new JSONObject();

        String EXPRESSWAY_API_KEY = ConfigLoader.getProperty("EXPRESSWAY_ID");

        try {
            // 2. API 호출! - 모든휴게소 정보 가져오기
            Map<String, ServiceAreaVO> saMap = new HashMap<>();
            List<ServiceAreaVO> saList = ServiceAreaDAO.getAll();

            // 2-1. 모든 휴게소정보를 가져와서 Map에 저장한다.
            System.out.println("--- [1] DB 기반 Key 목록 (saMap) ---");
            for (ServiceAreaVO svo : saList) {
                String direction = svo.getSADirection();
                // ✨ 방향 문자열에서 괄호 안의 내용만 추출하는 로직 추가
                int start = direction.indexOf('(');
                int end = direction.indexOf(')');
                if (start != -1 && end != -1 && end > start) {
                    direction = direction.substring(start + 1, end); // "부산"만 추출
                }


                // ✨ 디버깅용 로그 추가
                System.out.println("DB NAME: [" + svo.getSAName() + "], DB DIRECTION: [" + svo.getSADirection() + "]");

                String mapKey = svo.getSAName().replace("휴게소", "").trim()
                        + "(" + direction.trim()
                        + ")";

                System.out.println("생성된 DB Key: " + mapKey);
                saMap.put(mapKey, svo);
            }
            System.out.println("------------------------------------");

            //***************** 디버깅 ********************
            System.out.println("--- saMap 저장 확인 ---");
            System.out.println("총 " + saMap.size() + "개의 휴게소 정보가 Map에 저장되었습니다.");

            // Map에 저장된 데이터 중 샘플 Key 하나를 출력해봅니다.
            if (!saMap.isEmpty()) {
                // KeySet에서 첫 번째 Key를 가져와 샘플로 출력
                String sampleKey = saMap.keySet().iterator().next();
                System.out.println("샘플 Key 형식: " + sampleKey);
            }
            System.out.println("-----------------------");

            // 3. API 호출! - 모든 음식메뉴 정보 한번에 가져오기(동적 페이징 사용)
            List<JSONObject> allMenuItems = new ArrayList<>();

            String rowsPerPageStr = ConfigLoader.getProperty("menu.api.numOfRows");
            int numOfRows = (rowsPerPageStr != null) ? Integer.parseInt(rowsPerPageStr) : 100;



            int totalPages = (int) Math.ceil((double) totalCount / numOfRows); //전체페이지수 계산 68
            int pageNo = 1; //페이징을 1로 초기화

            while(true) {
                String menuUrl = "https://data.ex.co.kr/openapi/restinfo/restBestfoodList?key="
                        + EXPRESSWAY_API_KEY
                        + "&type=json&numOfRows=100&pageNo="
                        + pageNo;
                //pageNo++; //페이지를 증가시키면서 allMenuItmes 리스트에 메뉴정보들 채우기
                            // 메뉴가 없을경우 break!

                URL url = new URL(menuUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");

                StringBuilder sb = new StringBuilder();
                try (BufferedReader in = new BufferedReader(new InputStreamReader(
                        conn.getInputStream(), StandardCharsets.UTF_8))) {
                    String line;
                    while((line = in.readLine()) != null) sb.append(line);
                }
                conn.disconnect();
                // --- api 호출 로직 종료 ---

                JSONObject responseJson = new JSONObject(sb.toString());
                // API 응답에 'list'가 없거나 비어있으면 반복을 중단한다.
                if (!responseJson.has("list") || responseJson.getJSONArray("list").isEmpty()) {
                    break;
                }

                JSONArray itemsOnPage = responseJson.getJSONArray("list");
                for (int i = 0; i < itemsOnPage.length(); i++) {
                    allMenuItems.add(itemsOnPage.getJSONObject(i)); //Page 별로 안에 있는 아이템을 페이지에서 뽑아서
                                                                    //리스트에 추가한다.
                }
                pageNo++;
            }

            // 4. DB조회 : 기존 메뉴정보를 비교하기 위해 Map에 로드한다.
            Map<String, MenuVO> existingMenuMap = new HashMap<>(); //비교하기 위해 Map 객체 생성

            List<MenuVO> existingMenuList = MenuDAO.selectAllMenu(); //DAO에서 모든메뉴정보를 조회하여 리스트에 담는다.
            // 4-1 기존 메뉴정보들이 담긴 리스트를 순회하면서 Map에 담는다.
            for (MenuVO mvo : existingMenuList) {
                // Key: "휴게소번호-음식이름
                existingMenuMap.put(mvo.getSAKey() + "-" + mvo.getFoodName(), mvo);
            }

            // 5. 분류 리스트 준비(신규 / 수정)
            List<MenuVO> insertList = new ArrayList<>();
            List<MenuVO> updateList = new ArrayList<>();

            // 6. *** 메인 로직  : JAVA 메모리에서 두 API 데이터 조합 및 비교 ***
            System.out.println("--- [2] API 기반 Key 목록 (apiKey) ---"); //debug
            for (JSONObject apiItem : allMenuItems) {
                String stdRestNm = apiItem.optString("stdRestNm").trim();
                String direction = apiItem.optString("direction").trim();
                String apiKey;

                // ✨ 수정된 Key 생성 로직
                if (direction.isEmpty()) {
                    // CASE 1: direction 필드가 비어있으면, stdRestNm에 이미 '(방향)'이 포함된 경우
                    // "서울만남(부산)휴게소" -> "서울만남(부산)" 으로 만듦
                    apiKey = stdRestNm.replace("휴게소", "");
                } else {
                    // CASE 2: direction 필드에 값이 있으면, 기존 방식대로 조합
                    // stdRestNm: "기흥", direction: "부산" -> "기흥(부산)" 으로 만듦
                    apiKey = stdRestNm.replace("휴게소", "") + "(" + direction + ")";
                }

                // ✨ 여기서 두 Key가 일치하는지 바로 확인 가능!
                System.out.println(apiKey + "  | 일치여부: " + saMap.containsKey(apiKey));

                //모든 휴게소정보를 담은 Map에서 key를 가져온다.
                if (saMap.containsKey(apiKey)) {
                    ServiceAreaVO matchedSA = saMap.get(apiKey);
                    // --- newVO에 API 데이터와 휴게소 Idx 채우기 ---
                    MenuVO newVO = new MenuVO();
                    newVO.setSAKey(Integer.parseInt(matchedSA.getIdx()));
                    newVO.setFoodName(apiItem.getString("foodNm"));
                    newVO.setPrice(apiItem.optString("foodCost", "0"));
                    newVO.setRecommend(apiItem.optString("recommendyn", "N"));
                    newVO.setBest(apiItem.optString("bestfoodyn", "N"));
                    newVO.setPremium(apiItem.optString("premiumyn", "N"));
                    // API에 seasonMenu key가 없으면 null이 저장됨
                    newVO.setSeason((apiItem.optString("seasonMenu", null)));

                    String mapKey = newVO.getSAKey() + "-" + newVO.getFoodName();
                    MenuVO existingVO = existingMenuMap.get(mapKey);

                    if (existingVO == null) {
                        insertList.add(newVO);
                    } else if (!newVO.equals(existingVO)) {
                        updateList.add(newVO);
                    }
                }
                System.out.println("------------------------------------");
            }

            // 7. DB 일괄 처리
            MenuDAO.batchInsert(insertList);
            MenuDAO.batchUpdate(updateList);

            //8. 최종 결과 음답!
            String message = String.format("업데이트 완료: %d개 신규 추가, %d개 정보 수정.",
                    insertList.size(), updateList.size());
            jsonResult.put("status", "success");
            jsonResult.put("message", message);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                jsonResult.put("status", "error");
                jsonResult.put("message", "업데이트 중 오류가 발생했습니다: " + e.getMessage());
            } catch (Exception e1) {
                e1.printStackTrace();
            }
        }

        // 최종 JSON 결과를 클라이언트로 전송
        /*try (PrintWriter out = response.getWriter()) {
            out.print(jsonResult.toString());
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }*/
        return null; //JSON응답으로 비동기식 처리!
    }
}
