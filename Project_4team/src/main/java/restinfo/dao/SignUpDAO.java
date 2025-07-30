package restinfo.dao;

import mybatis.service.FactoryService;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.Map;

public class SignUpDAO {
    public static int add(String id, String Hpwd, String name) {
        Map<String, String> m = new HashMap<>();
        m.put("ID", id);
        m.put("Pwd", Hpwd);
        m.put("Name", name);



        SqlSession ss = FactoryService.getFactory().openSession();
        int cnt = ss.insert("restinfo.signUp", m);

        if (cnt > 0)
            ss.commit();
        else
            ss.rollback();
        ss.close();

        return cnt;

    }

}
