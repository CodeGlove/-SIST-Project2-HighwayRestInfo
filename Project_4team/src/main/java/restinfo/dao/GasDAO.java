package restinfo.dao;

import mybatis.service.FactoryService;
import mybatis.vo.GasVO;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class GasDAO {
    public static List<GasVO> Search(String text) {
        SqlSession ss = FactoryService.getFactory().openSession();
        List<GasVO> list = ss.selectList()
    }

    public static Object getInstance() {
    }
}
