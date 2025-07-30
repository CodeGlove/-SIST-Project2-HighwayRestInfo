package restinfo.action;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
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

        Random ran = new Random();
        int Code=ran.nextInt(899999)+100000;

        HttpSession session =request.getSession();
        session.setAttribute("code",Code);
        session.setAttribute("email",email);

        final String fromEmail="jaeyoon0725.utube@gmail.com";
        final String password="mkphhkrfgvvwhyqk";
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
            msg.setText("인증번호: " + authCode);

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
