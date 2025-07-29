package restinfo.dao;

import mybatis.service.FactoryService;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.Map;

public class SignUpDAO {
    public static int add(String id, String pwd, String name, String home, String interest) {
        Map<String, String> m = new HashMap<>();
        m.put("ID", id);
        m.put("Pwd", pwd);
        m.put("Name", name);
        m.put("Home", home);
        m.put("Interest", interest);

        SqlSession ss = FactoryService.getFactory().openSession();
        int cnt = ss.insert("restinfo.singUp", m);

        if (cnt > 0)
            ss.commit();
        else
            ss.rollback();
        ss.close();
        return cnt;

    }

}
