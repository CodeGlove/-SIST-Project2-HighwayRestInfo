package restinfo.action;

import mybatis.vo.ServiceAreaVO;
import restinfo.dao.ServiceAreaDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class pjyrestAreaDetail implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idx = request.getParameter("idx");
        ServiceAreaVO vo = ServiceAreaDAO.getOneArea(idx);

        return "Detail.jsp";
    }
}
