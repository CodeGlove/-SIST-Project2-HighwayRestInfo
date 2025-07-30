package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.Random;

public class EmailSendAction implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        String email = request.getParameter("email");

        Random ran = new Random();
        int Code=ran.nextInt(899999)+100000;

        HttpSession session =request.getSession();
        session.setAttribute("code",Code);
        session.setAttribute("email",email);

        final String fromEmail="jaeyoon0725.utube@gmail.com";
//        final String password=

        return "";
    }
}
