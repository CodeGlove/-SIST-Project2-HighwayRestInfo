package restinfo.action;

import com.google.gson.Gson;
import mybatis.vo.ServiceAreaVO;
import restinfo.dao.ServiceAreaDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;


public class pjyrestAreaDetail implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idx = request.getParameter("idx");
        System.out.println("이휴게소의 IDX =============="+idx);
        ServiceAreaVO vo = ServiceAreaDAO.getOneArea(idx);

        // 응답 json
        response.setContentType("application/json");
        response.setCharacterEncoding("utf-8");

        String json = new Gson().toJson(vo);

        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
        return null;
    }
}
