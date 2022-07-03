package pojo;

public class User {
    private String username;
    private String password;
    private String email;
    private boolean isAdmin;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setIsAdmin(boolean isAdmin) {
        this.isAdmin = isAdmin;
    }

    public Boolean getIsAdmin() {
        return isAdmin;
    }

    public User(String username, String password, String email, boolean isAdmin) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.isAdmin = isAdmin;
    }

    public User() {
    }
}
