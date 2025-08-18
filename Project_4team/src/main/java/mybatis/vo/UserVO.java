package mybatis.vo;

public class UserVO {
    private String ID;
    private String NickName;
    private String Pwd;
    private String Name;
    private String Home;
    private String Authority;
    private String Interest;

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    private String platform;
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

    public String getInterest() {
        return Interest;
    }

    public void setInterest(String interset) {
        Interest = interset;
    }
}
