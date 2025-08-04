package restinfo.action;

import mybatis.vo.ServiceAreaVO;
import restinfo.dao.ServiceAreaDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.List;

public class PjyRestAreaAction implements Action{
    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        // 1. 요청 파라미터 받기
        String swLatStr = request.getParameter("swLat");
        String swLngStr = request.getParameter("swLng");
        String neLatStr = request.getParameter("neLat");
        String neLngStr = request.getParameter("neLng");

        // 2. 파라미터를 double 타입으로 변환
        double swLat = Double.parseDouble(swLatStr);
        double swLng = Double.parseDouble(swLngStr);
        double neLat = Double.parseDouble(neLatStr);
        double neLng = Double.parseDouble(neLngStr);




        return null;
    }
}
