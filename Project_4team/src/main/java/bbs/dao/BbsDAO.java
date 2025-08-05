package bbs.dao;

import mybatis.service.FactoryService;
import mybatis.vo.BbsVO;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class BbsDAO {
    //총 게시물의 수를 반환
    public static int getTotalCount() {
        SqlSession ss = FactoryService.getFactory().openSession();
        int cnt = ss.selectOne("Board.totalCount");
        ss.close();
        return cnt;
    }

    public static List<BbsVO> getList(Map<String, Object> map){
        SqlSession ss = FactoryService.getFactory().openSession(); //DAO 세션 열기
        List<BbsVO> list = ss.selectList("Board.list", map); //category, begin, numPerPage를 Map에 담아 전달
        ss.close();
        return list;
    }

    //저장
    public static int add(String subject, String writer,
                          String content, String FileName, String category){
        int cnt = 0;

        Map<String, String> map = new HashMap<>();
        map.put("subject", subject);
        map.put("writer", writer);
        map.put("content", content);
        map.put("FileName", FileName);
        map.put("category", category);
        map.put("Pwd", "");

        //DAO 호출을 위한 세션 열기
        SqlSession ss = FactoryService.getFactory().openSession();
        cnt = ss.insert("Board.add", map); //인자는 map으로!
        if(cnt > 0)
            ss.commit();
        else
            ss.rollback();
        ss.close();

        return cnt;
    }
    // 기본키를 인자로 하여 게시물 가져오기
    public static BbsVO getId(String PostNum){
        SqlSession ss = FactoryService.getFactory().openSession();
        BbsVO vo = ss.selectOne("Board.getBbs", PostNum);
        ss.close();
        return vo;
    }

}
