package restinfo.dao;

import mybatis.service.FactoryService;
import mybatis.vo.ServiceAreaVO;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class ManageDAO {

    public static void initSA(List<ServiceAreaVO> list) {
        int cnt = 0;


        SqlSession ss = null;
        try {

            ss = FactoryService.getFactory().openSession();
        cnt = ss.insert("SA.load", list);
        if (cnt > 0) {
            ss.commit();
            System.out.println("목록 저장완료");
        } else {
            ss.rollback();
            System.out.println("목록 저장실패");
        }
        }  finally {
            if (ss != null)
                ss.close();
        }

    }

}
