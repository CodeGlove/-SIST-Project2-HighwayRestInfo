package restinfo.dao;

import mybatis.service.FactoryService;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.Map;

public class updateUserDAO {
    public  static int update(String nickName,String favoriteSeason,String ID,String platform,String home) {
        SqlSession ss = FactoryService.getFactory().openSession();
        Map<String,String> m = new HashMap<>();
        m.put("nickName",nickName);
        m.put("favoriteSeason",favoriteSeason);
        m.put("ID",ID);
        m.put("platform",platform);
        m.put("home",home);
        int cnt = ss.update("User.update",m);
        if (cnt>0)
        {
            ss.commit();
        }else {
            ss.rollback();
        }
        ss.close();
        return cnt;
    }

    // [추가] 닉네임 중복 확인 메소드
    public static int isNicknameTaken(String nickName) {
        SqlSession ss = FactoryService.getFactory().openSession();
        int count = ss.selectOne("User.isNicknameTaken", nickName);
        ss.close();
        return count;
    }
    // [추가] 회원 비활성화 메소드
    public static int deactivateAccount(String id, String platform) {
        SqlSession ss = FactoryService.getFactory().openSession();
        Map<String, String> map = new HashMap<>();
        map.put("ID", id);
        map.put("platform", platform);

        int cnt = ss.update("User.deactivateAccount", map);
        if (cnt > 0) {
            ss.commit();
        } else {
            ss.rollback();
        }
        ss.close();
        return cnt;
    }
}
