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

    public static int updateXY(String idx, double lat, double lng) {
        int cnt = 0;
        SqlSession ss = FactoryService.getFactory().openSession();
        Map<String, Object> m = new HashMap<>();

        m.put("idx", idx);   // String 타입
        m.put("lat", lat);  // double 타입
        m.put("lng", lng);  // double 타입

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
}
