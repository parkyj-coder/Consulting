package model;

public class Admin {
    private int id;
    private String username;
    private String password;
    private String name;
    private String email;
    private String role;
    private boolean active;
    
    // 기본 생성자
    public Admin() {}
    
    // 5개 매개변수 생성자 (adminProcess.jsp에서 사용)
    public Admin(String username, String password, String name, String email, String role) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.email = email;
        this.role = role;
        this.active = true; // 기본값으로 활성화
    }
    
    // 전체 생성자
    public Admin(int id, String username, String password, String name, 
                String email, String role, boolean active) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.name = name;
        this.email = email;
        this.role = role;
        this.active = active;
    }
    
    // Getter와 Setter 메서드들
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    
    // 슈퍼 관리자 여부 확인
    public boolean isSuperAdmin() {
        return "super_admin".equals(this.role);
    }
    
    @Override
    public String toString() {
        return "Admin{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", active=" + active +
                '}';
    }
}
