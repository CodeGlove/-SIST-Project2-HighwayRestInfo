package restinfo.action;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.Random;

public class EmailSendAction implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        String email = request.getParameter("email");
        System.out.println("request.getParameter(\"email\")로 받은 값: [" + email + "]");

        Random ran = new Random();
        int Code=ran.nextInt(899999)+100000;

        HttpSession session =request.getSession();
        session.setAttribute("code",Code);
        session.setAttribute("email",email);

        final String fromEmail="jaeyoon0725.utube@gmail.com";
        final String password="clkxawqcomycsklx";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        };

        Session mailSession = Session.getInstance(props, auth);

        try {
            MimeMessage msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(fromEmail, "HighwayGuide 관리자"));
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
            msg.setSubject("[HighwayGuide] 회원가입 이메일 인증번호입니다.");
            String htmlContent = "<h2>안녕하세요, HighwayGuide 입니다.</h2>"
                    + "<p>회원가입을 위한 인증번호는 다음과 같습니다.</p>"
                    + "<div style='font-size: 100px; font-weight: bold; border: 1px solid #ddd; padding: 10px; display: inline-block;'>"
                    + Code
                    + "</div>"
                    + "<p>인증번호를 회원가입 창에 입력해주세요.</p>";

            // msg.setText(...) 대신 아래 코드로 HTML 내용을 설정합니다.
            msg.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(msg);

            // 성공 신호 전송
            response.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            e.printStackTrace();
            // 실패 신호 전송
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        return null;
    }
}
