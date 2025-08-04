package bbs.action;

import restinfo.action.Action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EditAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {

        return "edit.jsp"; //edit 화면으로 foward
    }
}
