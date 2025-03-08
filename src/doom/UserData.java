package doom;

import java.util.Objects;

public final class UserData {
    private final String name;
    private final String email;
    private final long starttime;
    private int score;

    public UserData(String name, String email, long starttime, int score) {
        this.name = name;
        this.email = email;
        this.starttime = starttime;
        this.score = score;
    }

    public long getStarttime() {
        return starttime;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public int getScore() {
        return score;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (UserData) obj;
        return Objects.equals(this.name, that.name) &&
                Objects.equals(this.email, that.email) &&
                this.starttime == that.starttime &&
                this.score == that.score;
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, email, starttime, score);
    }

    @Override
    public String toString() {
        return "UserData[" +
                "name=" + name + ", " +
                "email=" + email + ", " +
                "starttime=" + starttime + ", " +
                "score=" + score + ']';
    }
}
