package restinfo.action;

import mybatis.vo.ServiceAreaVO;
import restinfo.dao.ServiceAreaDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
//아아아
public class pjyrestAreaDetail implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idx = request.getParameter("idx");
        System.out.println("이휴게소의 IDX =============="+idx);
        ServiceAreaVO vo = ServiceAreaDAO.getOneArea(idx);

        request.setAttribute("vo",vo);
        return "Detail.jsp";
    }
}
