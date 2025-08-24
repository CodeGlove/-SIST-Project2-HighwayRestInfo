package restinfo.dao;

import mybatis.service.FactoryService;
import mybatis.vo.MenuVO;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class MenuDAO {
    public static List<MenuVO> selectAllMenu() {
        try (SqlSession ss = FactoryService.getFactory().openSession()) { //DB 세션열기
            return ss.selectList("menu.selectAllMenu"); //모든 메뉴정보 불러오는 쿼리 실행
        }
    }

    // List에 담긴 여러 메뉴들을 한번에 INSERT (Batch작업)
    public static void batchInsert(List<MenuVO> insertList) {
        // 리스트가 비어있으면 작업안하고 종료
        if(insertList == null || insertList.isEmpty())
            return;
        // *** (핵심!) BATCH 모드로 SqlSession 열기 ***
        // 이 모드는 DB에 명령을 바로 보내지 않고 창고에 모아두는 역할
        try (SqlSession ss = FactoryService.getFactory().openSession(ExecutorType.BATCH)) {
            //ExecutorType.BATCH: mybatis에서 DB작업을 모아서 한번에 처리하도록 지정하는 실행모드!!
            for (MenuVO mvo : insertList) {
                ss.insert("menu.insertMenu", mvo); //insert 쿼리 호출 (아직 실행은 안됨)
            }
            ss.flushStatements(); //모아둔 INSERT 쿼리들을 DB에 한번에 보내기
            ss.commit(); //모든 작업 성공하면 최종 저장한다.
        }
    }

    // List에 담긴 여러 메뉴들을 한번에 UPDATE (Batch작업)
    public static void batchUpdate(List<MenuVO> updateList) {
        // 리스트가 비어있으면 작업안하고 종료
        if (updateList == null || updateList.isEmpty()) return;

        try (SqlSession ss = FactoryService.getFactory().openSession(ExecutorType.BATCH)) {
            for (MenuVO mvo : updateList) {
                ss.update("menu.updateMenu", mvo);
            }
            ss.flushStatements(); //모아둔 UPDATE 쿼리들을 DB에 한번에 보내기
            ss.commit();
        }
    }
}
