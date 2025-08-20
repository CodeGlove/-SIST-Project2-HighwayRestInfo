package restinfo.action;

import com.google.gson.Gson;
import mybatis.vo.ServiceAreaVO;
import mybatis.vo.gasVO;
import restinfo.dao.ServiceAreaDAO;
import restinfo.dao.gasDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class getRestAreaDetailsAction implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String saKey = request.getParameter("saKey");

        ServiceAreaVO vo = ServiceAreaDAO.getOneArea(saKey);

        // [수정] vo가 null이 아닌 것이 확인된 경우에만 주유소 정보를 조회하고 합칩니다.
        if (vo != null) {
            gasVO gvo = gasDAO.getgas(saKey);
            vo.setGasInfo(gvo); // gvo가 null이더라도 set하는 것은 괜찮습니다.
        }

        // vo가 null이면 gson이 "null" 문자열로, 객체가 있으면 객체 모양의 문자열로 변환합니다.
        String jsonResponse = new Gson().toJson(vo);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        // 만약 vo가 null이라 jsonResponse도 "null"이 될 경우를 대비해 안전하게 빈 객체"{}"를 보냄
        response.getWriter().write(vo != null ? jsonResponse : "{}");

        return null;
    }
}