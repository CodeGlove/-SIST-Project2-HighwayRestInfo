package bbs.action;

import bbs.dao.BbsDAO;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import mybatis.vo.UserVO;
import restinfo.action.Action;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;

public class WriteAction implements Action {
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) {

        //******** 권한 확인 *********
        HttpSession session = request.getSession();
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");

        //관리자 유효성 검사
        //로그인을 하지 않거나 관리자가 아닌 경우 공지사항 목록으로 이동
        if(loginUser == null || !loginUser.getAuthority().equals("1")){
            try{
                response.sendRedirect("Controller?type=notice");
            } catch(Exception e){
                e.printStackTrace();
            }
            return null; //forward 막기
        }

        String viewPath = null;

        //list.jsp에 있는 [글쓰기]버튼을 클릭하면 get방식으로
        //현재 객체를 수행한다. 이때 요청시 contentType을 얻어낸다. 분명
        // get방식 null값을 받게된다.
        String enc_type = request.getContentType(); //get방식은 contentType이 없다.(post는 form)
        //System.out.println(enc_type);

        if(enc_type == null)
            viewPath = "write.jsp";
        else if(enc_type.startsWith("multipart")){
            //여기는 write.jsp에서 내용을 입력한 후 [보내기] 버튼을
            // 클릭했을 때 수행하는 곳!
            // 첨부파일을 받아서 bbs_upload라는 폴더에 저장해야 합니다.
            try {
                ServletContext application = request.getServletContext(); //절대경로 얻기 위해 선언
                String realPath = application.getRealPath("/bbs_upload"); //절대경로 얻음

                //첨부파일과 다른 파라미터들을 받기위해 MultipartRequest생성(cos 라이브러리 필요함)
                MultipartRequest mr = new MultipartRequest(request, realPath,
                        1024*1024*5, "utf-8",
                        new DefaultFileRenamePolicy()); //동일한 이름이 있다면 바꿔라
                //이때 첨부파일이 있다면 realPath경로에 저장된 상태다.
                //나머지 파라미터들 얻기(title, writer, content) -> (write.jsp에서 name 확인 얻어내야 한다)
                String title = mr.getParameter("title");
                String writer = mr.getParameter("writer");
                String content = mr.getParameter("content");
                String category = mr.getParameter("category");

                //첨부파일이 있다면 fname과 oname을 얻어내야 한다.
                File f = mr.getFile("file");
                String fname = null;
                String oname = null;
                if( f != null ){
                    fname = f.getName(); // 현재 저장된 파일명
                    oname = mr.getOriginalFileName("file"); // 원래 파일명
                }
                String ip = request.getRemoteAddr(); // 요청자의 IP

                //DB에 저장
                BbsDAO.add(title, writer, content, fname, oname, category);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return viewPath;
        return "write.jsp"; //write로 forward
    }
}
