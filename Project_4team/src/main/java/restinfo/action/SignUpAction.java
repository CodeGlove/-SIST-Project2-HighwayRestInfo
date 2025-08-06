package restinfo.action;

import mybatis.vo.UserVO;
import org.mindrot.jbcrypt.BCrypt;
import restinfo.dao.SignUpDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

public class SignUpAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        request.setCharacterEncoding("utf-8");
        String email = request.getParameter("email");
        String pwd = request.getParameter("password");
        String name = request.getParameter("name");

        //해쉬 값 으로 넣기
        String hashpwd = BCrypt.hashpw(pwd, BCrypt.gensalt());
        System.out.println(hashpwd);
        System.out.println(email);
        System.out.println(name);

        try {
            UserVO CheckVO = SignUpDAO.check(email,"SOCIAL");
            if(CheckVO==null) {
                int cnt = SignUpDAO.add(email, hashpwd, name, "SOCIAL");
                if (cnt > 0) {
                    System.out.println("완료");
                } else {
                    System.out.println("안댐 (cnt=0)");
                }
            }
        } catch (Exception e) {
           e.printStackTrace();

        }

        return null;
    }
}
