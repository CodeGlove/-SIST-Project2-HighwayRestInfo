package bbs.action;

import bbs.dao.BbsDAO;
import restinfo.action.Action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DelAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {
        String viewPath = null;

        //파라미터 받기
        String PostNum = request.getParameter("PostNum");
        String cPage = request.getParameter("cPage");

        int cnt = BbsDAO.delBbs(PostNum);
        viewPath = "Controller?type=notice&cPage="+cPage;

        return viewPath;
    }
}
