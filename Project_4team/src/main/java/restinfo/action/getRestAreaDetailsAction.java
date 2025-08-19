package restinfo.action;

import com.google.gson.Gson;
import mybatis.vo.ServiceAreaVO;
import restinfo.dao.ServiceAreaDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class getRestAreaDetailsAction implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String saKey = request.getParameter("saKey");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        ServiceAreaVO vo = ServiceAreaDAO.getOneArea(saKey);
        System.out.println(vo.getSAName());
        String jsonResponse;
        if (vo != null) {
            // 성공 시: VO 객체를 직접 JSON 문자열로 변환
            jsonResponse = new Gson().toJson(vo);
        } else {
            // 실패 시: 빈 JSON 객체를 보냄
            jsonResponse = "{}";
        }

        response.getWriter().write(jsonResponse);

        return null;
    }
}
