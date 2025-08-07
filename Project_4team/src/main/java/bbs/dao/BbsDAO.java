package bbs.dao;

import mybatis.service.FactoryService;
import mybatis.vo.BbsVO;
import org.apache.ibatis.session.SqlSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class BbsDAO {
    //총 게시물의 수를 반환
    public static int getTotalCount(String subject) {
        SqlSession ss = FactoryService.getFactory().openSession();
        int cnt = ss.selectOne("Board.totalCount", subject);
        ss.close();
        return cnt;
    }
    //목록 반환
    public static BbsVO[] getList(String subject, int begin, int end){
        BbsVO[] ar = null;

        Map<String, Object> map = new HashMap<>(); //map구조 생성
        map.put("subject", subject); //bbs.xml의 subject 이름과 같아야한다!
        map.put("begin", begin);
        map.put("end", end);

        SqlSession ss = FactoryService.getFactory().openSession();
        List<BbsVO> list = ss.selectList("Board.list", map); //bbs.xml의 parameterType 맞춰야함
        if(list != null && list.size()>0){
            ar = new BbsVO[list.size()];
            list.toArray(ar);
        }
        ss.close();

        return ar;
    }
    /*
    public static List<BbsVO> getList(Map<String, Object> map){
        SqlSession ss = FactoryService.getFactory().openSession(); //DAO 세션 열기
        List<BbsVO> list = ss.selectList("Board.list", map); //category, begin, numPerPage를 Map에 담아 전달
        ss.close();
        return list;
    }*/

    //저장
    public static int add(String subject, String writer,
                          String content, String FileName, String category,
                          String writeDate, String ThumbsUp, String ThumbsDown,
                          String Delete, String Pwd){
        int cnt = 0;

        Map<String, String> map = new HashMap<>();
        map.put("subject", subject);
        map.put("writer", writer);
        map.put("content", content);
        map.put("FileName", FileName);
        map.put("category", category);
        map.put("writeDate", writeDate);
        map.put("ThumbsUp", ThumbsUp);
        map.put("ThumbsDown", ThumbsDown);
        map.put("Delete", Delete);
        map.put("Pwd", Pwd);

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
    public static BbsVO getPostNum(String PostNum){
        SqlSession ss = FactoryService.getFactory().openSession();
        BbsVO vo = ss.selectOne("Board.getBbs", PostNum);
        ss.close();
        return vo;
    }

    //수정
    public static int edit(String PostNum, String subject, String content, String FileName){

        Map<String, String> map = new HashMap<>();
        map.put("PostNum", PostNum);
        map.put("subject", subject);
        map.put("content", content);
        map.put("FileName", FileName);

        if(FileName != null){ //UPDATE절에 구동되지 않게 하기 위해 검사
            map.put("FileName", FileName);
        }

        SqlSession ss = FactoryService.getFactory().openSession();
        int cnt = ss.update("Board.edit", map);
        if(cnt > 0)
            ss.commit();
        else
            ss.rollback();
        ss.close();

        return cnt;
    }

    //삭제
    public static int delBbs(String PostNum) {
        SqlSession ss = FactoryService.getFactory().openSession();
        int cnt = ss.update("Board.del", PostNum);
        if (cnt > 0) {
            ss.commit();
        } else {
            ss.rollback();
        }
        ss.close();
        return cnt;
    }
}
