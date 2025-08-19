package restinfo.dao;

import mybatis.service.FactoryService;
import mybatis.vo.ServiceAreaVO;
import mybatis.vo.ShopVO;
import org.apache.ibatis.session.SqlSession;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ManageDAO {

    public static int[] getPlatformCount(){

        SqlSession ss = null;

        int[] counts = new int[3];

        try {

            ss = FactoryService.getFactory().openSession();

            counts[0] = ss.selectOne("User.getPlatformCount", "KAKAO");
            counts[1] = ss.selectOne("User.getPlatformCount", "NAVER");
            counts[2] = ss.selectOne("User.getPlatformCount", "ORIGIN");
        } catch (Exception e) {
            e.printStackTrace();
        }  finally {
            ss.close();
        }
        return counts;
    }

    public static List<Map<String, Object>> getSARank(){
        SqlSession ss = FactoryService.getFactory().openSession();
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            list = ss.selectList("SA.getRanking");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            ss.close();
        }
        return  list;
    }

    public static void initSA(List<ServiceAreaVO> list) {
        int cnt = 0;
        SqlSession ss = null;
        try {
            ss = FactoryService.getFactory().openSession();

            for (ServiceAreaVO svo : list) {
                ServiceAreaVO vo = ss.selectOne("SA.search", svo);
                if (vo != null) {
                    ss.update("SA.update", svo);
                    svo.setIdx(vo.getIdx());
                } else
                    ss.insert("SA.insert", svo);
                ss.commit();
            }
        }  finally {
            if (ss != null)
                ss.close();
        }
        for(ServiceAreaVO svo : list) {
            System.out.println(svo.getIdx()+":::::::::::::::::;");
        }
        initShop(list);
    }

    public static void initShop(List<ServiceAreaVO> list) {
        int cnt = 0;
        SqlSession ss = null;
        try {
            ss = FactoryService.getFactory().openSession();
            ss.delete("Shop.delete");
            ss.commit();
            for (ServiceAreaVO svo : list) {
                List<ShopVO> shops = svo.getShoplist();
                for (ShopVO shop : shops){
                    shop.setSAKey(svo.getIdx());
                    System.out.println(shop.getSAKey()+"\\\\\\\\\\\\\\");
                    System.out.println(shop.getShopName());
                }
                if (!shops.isEmpty())
                    ss.insert("Shop.insert", shops);
            }
                ss.commit();
        }  finally {
            if (ss != null)
                ss.close();
        }
    }

}
