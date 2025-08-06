package restinfo;

import restinfo.model.TmapCongestionService;
import restinfo.model.TmapSearchService;
import java.util.List;
import java.util.Map;

public class MainApp {
    public static void main(String[] args) {
        // 1. "죽전" 키워드로 휴게소 목록 검색
        List<Map<String, String>> restAreas = TmapSearchService.searchRestAreas("서울만남의광장");

        if (restAreas.isEmpty()) {
            System.out.println("검색 결과가 없습니다.");
            return;
        }

        System.out.println("====== 죽전 휴게소 목록 ======");
        for (int i = 0; i < restAreas.size(); i++) {
            Map<String, String> area = restAreas.get(i);
            System.out.printf("%d. %s (%s)\n", i + 1, area.get("name"), area.get("roadName"));
        }
        System.out.println("============================");

        // --- 여기서부터 수정된 로직입니다 ---
        Map<String, String> selectedArea = null;

        // 검색된 휴게소 리스트에서 '죽전휴게소'의 '서울방향'을 찾습니다.
        for (Map<String, String> area : restAreas) {
            String name = area.get("name");
            if (name.contains("죽전휴게소") && name.contains("서울방향")) {
                selectedArea = area;
                break;
            }
        }

        if (selectedArea == null) {
            System.out.println("\n원하는 휴게소를 찾을 수 없습니다.");
            return;
        }

        String selectedPoiId = selectedArea.get("id");
        String selectedName = selectedArea.get("name");

        // 2. 선택된 휴게소의 혼잡도 조회
        int congestionLevel = TmapCongestionService.getCongestionLevel(selectedPoiId);

        if (congestionLevel != -1) {
            String status = "";
            if (congestionLevel == 1) status = "여유";
            else if (congestionLevel == 2) status = "보통";
            else if (congestionLevel == 3) status = "혼잡";
            else if (congestionLevel == 4) status = "매우 혼잡";

            System.out.printf("\n[ %s ]의 현재 혼잡도는 [ %s ]입니다.\n", selectedName, status);
        } else {
            System.out.println("\n혼잡도 정보를 가져오는 데 실패했습니다.");
        }
    }
}