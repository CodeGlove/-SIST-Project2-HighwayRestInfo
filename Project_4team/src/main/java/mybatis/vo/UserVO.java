package mybatis.vo;

public class UserVO {
    private String ID, NickName, Pwd, Name, Home, Authority, Interset;
    private int Idx;

    public int getIdx() {
        return Idx;
    }

    public void setIdx(int idx) {
        Idx = idx;
    }

    public String getAuthority() {
        return Authority;
    }

    public void setAuthority(String authority) {
        Authority = authority;
    }

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getNickName() {
        return NickName;
    }

    public void setNickName(String nickName) {
        NickName = nickName;
    }

    public String getPwd() {
        return Pwd;
    }

    public void setPwd(String pwd) {
        Pwd = pwd;
    }

    public String getName() {
        return Name;
    }

    public void setName(String name) {
        Name = name;
    }

    public String getHome() {
        return Home;
    }

    public void setHome(String home) {
        Home = home;
    }

    public String getInterset() {
        return Interset;
    }

    public void setInterset(String interset) {
        Interset = interset;
    }
}
