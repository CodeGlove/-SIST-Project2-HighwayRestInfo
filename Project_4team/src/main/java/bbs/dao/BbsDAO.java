package bbs.dao;

import mybatis.service.FactoryService;
import mybatis.vo.BbsVO;
import org.apache.ibatis.session.SqlSession;

import java.util.List;
import java.util.Map;


public class BbsDAO {
    //총 게시물의 수를 반환
    public static int getTotalCount(String category) {
        SqlSession ss = FactoryService.getFactory().openSession();
        int cnt = ss.selectOne("Board.totalCount", category);
        ss.close();
        return cnt;
    }

    public static List<BbsVO> getList(Map<String, String> map){
        SqlSession ss = FactoryService.getFactory().openSession(); //DAO 세션 열기
        List<BbsVO> list = ss.selectList("Board.getList", map); //category, begin, numPerPage를 Map에 담아 전달
        ss.close();
        return list;
    }

    //저장
    public static int add(BbsVO vo){
        SqlSession ss = FactoryService.getFactory().openSession();
        int cnt = ss.insert("Board.add", vo);
        if(cnt > 0){
            ss.commit();
        }
        ss.close();
        return cnt;
    }

}
