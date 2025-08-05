package restinfo.dao;

import mybatis.service.FactoryService;
import mybatis.vo.ServiceAreaVO;
import mybatis.vo.ShopVO;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class ManageDAO {

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
