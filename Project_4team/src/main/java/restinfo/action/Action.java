package restinfo.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;

public interface Action {
    String execute(HttpServletRequest request,
                   HttpServletResponse response) throws UnsupportedEncodingException;
}
