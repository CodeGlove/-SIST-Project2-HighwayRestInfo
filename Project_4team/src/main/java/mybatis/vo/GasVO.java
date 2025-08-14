package mybatis.vo;

public class GasVO {
    private int SAKey, Gasoline, Disel, LPG;

    public int getSAKey() {
        return SAKey;
    }

    public void setSAKey(int SAKey) {
        this.SAKey = SAKey;
    }

    public int getGasoline() {
        return Gasoline;
    }

    public void setGasoline(int gasoline) {
        Gasoline = gasoline;
    }

    public int getDisel() {
        return Disel;
    }

    public void setDisel(int disel) {
        Disel = disel;
    }

    public int getLPG() {
        return LPG;
    }

    public void setLPG(int LPG) {
        this.LPG = LPG;
    }
}
