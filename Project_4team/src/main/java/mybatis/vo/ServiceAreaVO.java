package mybatis.vo;

import java.util.ArrayList;
import java.util.List;

public class ServiceAreaVO {
    private String Idx;
    private String SAName;
    private String SADirection;
    private String WayNum;
    private String CompactParking;
    private String LargeParking;
    private String DisabledParking;
    private String Address;
    private String Tel;
    private String Lat;
    private String Lng;
    private String ShopCode;
    private String Convenience ;
    private List<ShopVO> Shoplist;

    public String getConvenience() {
        return Convenience;
    }

    public void setConvenience(String convenience) {
        Convenience = convenience;
    }


    public ServiceAreaVO() {
        Shoplist = new ArrayList<ShopVO>();
    }

    public List<ShopVO> getShoplist() {
        return Shoplist;
    }
    
    public String getIdx() {
        return Idx;
    }

    public void setIdx(String idx) {
        Idx = idx;
    }

    public void setShoplist(List<ShopVO> shoplist) {
        Shoplist = shoplist;
    }
    
    public String getWayNum() {
        return WayNum;
    }

    public void setWayNum(String wayNum) {
        WayNum = wayNum;
    }

    public String getSAName() {
        return SAName;
    }

    public void setSAName(String SAName) {
        this.SAName = SAName;
    }

    public String getSADirection() {
        return SADirection;
    }

    public void setSADirection(String SADirection) {
        this.SADirection = SADirection;
    }


    public String getCompactParking() {
        return CompactParking;
    }

    public void setCompactParking(String compactParking) {
        CompactParking = compactParking;
    }

    public String getLargeParking() {
        return LargeParking;
    }

    public void setLargeParking(String largeParking) {
        LargeParking = largeParking;
    }

    public String getDisabledParking() {
        return DisabledParking;
    }

    public void setDisabledParking(String disabledParking) {
        DisabledParking = disabledParking;
    }

    public String getAddress() {
        return Address;
    }

    public void setAddress(String address) {
        Address = address;
    }

    public String getLat() {
        return Lat;
    }

    public void setLat(String lat) {
        Lat = lat;
    }

    public String getLng() {
        return Lng;
    }

    public void setLng(String lng) {
        Lng = lng;
    }

    public String getTel() {
        return Tel;
    }

    public void setTel(String tel) {
        Tel = tel;
    }

    public String getShopCode() {
        return ShopCode;
    }

    public void setShopCode(String shopCode) {
        ShopCode = shopCode;
    }
}
