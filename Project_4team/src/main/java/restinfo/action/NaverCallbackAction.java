package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class NaverCallbackAction implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        String clientId = "iSIp9_85FJFKnAphuUp0";
        String clientSecret = "";

        String code = request.getParameter("code");
        String state = request.getParameter("state");


        return "redirect:index.jsp";
    }
}
