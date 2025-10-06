package model;

import java.sql.Timestamp;

public class Admin {
    private int id;
    private String adminId;
    private String password;
    private String name;
    private String email;
    private String phone;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isActive;
    
    // 기본 생성자
    public Admin() {}
    
    // 전체 생성자
    public Admin(int id, String adminId, String password, String name, String email, String phone,
                 Timestamp createdAt, Timestamp updatedAt, boolean isActive) {
        this.id = id;
        this.adminId = adminId;
        this.password = password;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.isActive = isActive;
    }
    
    // 로그인용 생성자
    public Admin(String adminId, String password) {
        this.adminId = adminId;
        this.password = password;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getAdminId() {
        return adminId;
    }
    
    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
}
