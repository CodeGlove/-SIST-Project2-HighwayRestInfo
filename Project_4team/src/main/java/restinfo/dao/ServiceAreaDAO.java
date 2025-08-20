package restinfo.dao;

import mybatis.service.FactoryService;
import mybatis.vo.ServiceAreaVO;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ServiceAreaDAO {
    public static List<ServiceAreaVO> getAll() {
        SqlSession ss = FactoryService.getFactory().openSession();
        List<ServiceAreaVO> list = ss.selectList("SA.all");
        ss.close();

        return list;
    }

    public static ServiceAreaVO getOneArea(String idx) {
        // idx는 클릭한 휴게소의 값임 그걸로 찾아서 휴게소 정보 갖고온 후
        // pjyrestAReaDEtail에 전달해준다음에 Detail jsp(아직만들지 않음)에 표현하자.
        SqlSession ss = FactoryService.getFactory().openSession();
        ServiceAreaVO vo = ss.selectOne("SA.getOne", idx);
        ss.close();

        return vo;
    }

    public static int updateXY(String idx, double lat, double lng) {
        int cnt = 0;
        SqlSession ss = FactoryService.getFactory().openSession();
        Map<String, Object> m = new HashMap<>();

        m.put("idx", idx); // String 타입
        m.put("lat", lat); // double 타입
        m.put("lng", lng); // double 타입

        cnt = ss.update("SA.xY", m);
        if (cnt > 0) {
            ss.commit();
        } else {
            ss.rollback();
        }
        ss.close();
        return cnt;
    }

    public static List<ServiceAreaVO> inBounds(double swLat, double swLng, double neLat, double neLng) {
        Map<String, Double> m = new HashMap<>();
        m.put("swLat", swLat);
        m.put("swLng", swLng);
        m.put("neLat", neLat);
        m.put("neLng", neLng);

        SqlSession ss = FactoryService.getFactory().openSession();
        List<ServiceAreaVO> list = ss.selectList("SA.inBounds", m);
        ss.close();

        return list;
    }

    public static List<ServiceAreaVO> Search(String text) {
        SqlSession ss = FactoryService.getFactory().openSession();
        List<ServiceAreaVO> list = ss.selectList("SA.searchInsert", text);
        ss.close();
        return list;

    }

    /**
     * Excel 데이터로 별점과 편의시설을 업데이트합니다.
     * 
     * @param idx         휴게소 인덱스
     * @param rating      별점
     * @param convenience 편의시설
     * @return 업데이트된 행 수
     */
    public static int updateStarAndConvenience(String idx, String rating, String convenience) {
        // null 값 체크
        if (rating == null || rating.trim().isEmpty() || rating.equals("null")) {
            System.out.println("⚠️ 별점이 null이므로 업데이트하지 않습니다: idx=" + idx);
            return 0;
        }

        if (convenience == null || convenience.trim().isEmpty() || convenience.equals("null")) {
            System.out.println("⚠️ 편의시설이 null이므로 업데이트하지 않습니다: idx=" + idx);
            return 0;
        }

        int cnt = 0;
        SqlSession ss = FactoryService.getFactory().openSession();

        try {
            ServiceAreaVO serviceArea = new ServiceAreaVO();
            serviceArea.setIdx(idx);
            serviceArea.setStar(rating);
            serviceArea.setConvenience(convenience);

            cnt = ss.update("SA.updateStarAndConvenience", serviceArea);

            if (cnt > 0) {
                ss.commit();
            } else {
                ss.rollback();
            }
        } catch (Exception e) {
            ss.rollback();
            throw e;
        } finally {
            ss.close();
        }

        return cnt;
    }

    /**
     * Excel 데이터로 별점, 편의시설, AI 코멘트를 업데이트합니다.
     * 
     * @param idx         휴게소 인덱스
     * @param rating      별점
     * @param convenience 편의시설
     * @param aiComment   AI 코멘트
     * @return 업데이트된 행 수
     */
    public static int updateStarConvenienceAndAiComment(String idx, String rating, String convenience,
            String aiComment) {
        // null 값 체크
        if (rating == null || rating.trim().isEmpty() || rating.equals("null")) {
            System.out.println("⚠️ 별점이 null이므로 업데이트하지 않습니다: idx=" + idx);
            return 0;
        }

        if (convenience == null || convenience.trim().isEmpty() || convenience.equals("null")) {
            System.out.println("⚠️ 편의시설이 null이므로 업데이트하지 않습니다: idx=" + idx);
            return 0;
        }

        int cnt = 0;
        SqlSession ss = FactoryService.getFactory().openSession();

        try {
            ServiceAreaVO serviceArea = new ServiceAreaVO();
            serviceArea.setIdx(idx);
            serviceArea.setStar(rating);
            serviceArea.setConvenience(convenience);
            serviceArea.setAiComment(aiComment);

            cnt = ss.update("SA.updateStarConvenienceAndAiComment", serviceArea);

            if (cnt > 0) {
                ss.commit();
            } else {
                ss.rollback();
            }
        } catch (Exception e) {
            ss.rollback();
            throw e;
        } finally {
            ss.close();
        }

        return cnt;
    }

    /**
     * Excel 데이터로 AI 코멘트를 업데이트합니다.
     * 
     * @param idx       휴게소 인덱스
     * @param aiComment AI 코멘트
     * @return 업데이트된 행 수
     */
    public static int updateAiComment(String idx, String aiComment) {
        // null 값 체크
        if (aiComment == null || aiComment.trim().isEmpty() || aiComment.equals("null")) {
            System.out.println("⚠️ AI 코멘트가 null이므로 업데이트하지 않습니다: idx=" + idx);
            return 0;
        }

        int cnt = 0;
        SqlSession ss = FactoryService.getFactory().openSession();

        try {
            ServiceAreaVO serviceArea = new ServiceAreaVO();
            serviceArea.setIdx(idx);
            serviceArea.setAiComment(aiComment);

            cnt = ss.update("SA.updateAiComment", serviceArea);

            if (cnt > 0) {
                ss.commit();
            } else {
                ss.rollback();
            }
        } catch (Exception e) {
            ss.rollback();
            throw e;
        } finally {
            ss.close();
        }

        return cnt;
    }

    /**
     * Excel 데이터로 전화번호를 업데이트합니다.
     * 
     * @param idx   휴게소 인덱스
     * @param phone 전화번호
     * @return 업데이트된 행 수
     */
    public static int updateTel(String idx, String phone) {
        // null 값 체크
        if (phone == null || phone.trim().isEmpty() || phone.equals("null")) {
            System.out.println("⚠️ 전화번호가 null이므로 업데이트하지 않습니다: idx=" + idx);
            return 0;
        }

        int cnt = 0;
        SqlSession ss = FactoryService.getFactory().openSession();

        try {
            ServiceAreaVO serviceArea = new ServiceAreaVO();
            serviceArea.setIdx(idx);
            serviceArea.setTel(phone);

            cnt = ss.update("SA.updateTel", serviceArea);

            if (cnt > 0) {
                ss.commit();
            } else {
                ss.rollback();
            }
        } catch (Exception e) {
            ss.rollback();
            throw e;
        } finally {
            ss.close();
        }

        return cnt;
    }

    /**
     * idx로 휴게소 정보를 조회합니다.
     * 
     * @param idx 휴게소 인덱스
     * @return 휴게소 정보
     */
    public static ServiceAreaVO getByIdx(String idx) {
        SqlSession ss = FactoryService.getFactory().openSession();
        ServiceAreaVO serviceArea = ss.selectOne("SA.getByIdx", idx);
        ss.close();
        return serviceArea;
    }
}
