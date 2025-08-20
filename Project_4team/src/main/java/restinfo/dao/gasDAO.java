package restinfo.dao;

import mybatis.service.FactoryService;
import mybatis.vo.gasVO;
import org.apache.ibatis.session.SqlSession;

public class gasDAO {
    public static gasVO getgas(String idx){
        SqlSession ss = FactoryService.getFactory().openSession();
        gasVO vo = ss.selectOne("GAS.getGas",idx);
        ss.close();

        return vo;

    }
}
