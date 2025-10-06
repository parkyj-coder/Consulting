package dao;

import model.Admin;
import util.DBUtil;
import util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    
    /**
     * 관리자 로그인 검증
     * @param adminId 관리자 ID
     * @param password 비밀번호
     * @return 로그인 성공 시 Admin 객체, 실패 시 null
     */
    public Admin authenticate(String adminId, String password) {
        String sql = "SELECT * FROM admins WHERE admin_id = ? AND is_active = TRUE";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                
                // 비밀번호 검증 (SHA-256 해시)
                if (PasswordUtil.verifyPassword(password, storedPassword)) {
                    return new Admin(
                        rs.getInt("id"),
                        rs.getString("admin_id"),
                        rs.getString("password"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getBoolean("is_active")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * 모든 관리자 목록 조회
     * @return 관리자 목록
     */
    public List<Admin> getAllAdmins() {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT * FROM admins ORDER BY created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Admin admin = new Admin(
                    rs.getInt("id"),
                    rs.getString("admin_id"),
                    rs.getString("password"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"),
                    rs.getBoolean("is_active")
                );
                admins.add(admin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return admins;
    }
    
    /**
     * 관리자 ID로 조회
     * @param adminId 관리자 ID
     * @return Admin 객체
     */
    public Admin getAdminById(String adminId) {
        String sql = "SELECT * FROM admins WHERE admin_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return new Admin(
                    rs.getInt("id"),
                    rs.getString("admin_id"),
                    rs.getString("password"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"),
                    rs.getBoolean("is_active")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * 새 관리자 추가
     * @param admin Admin 객체
     * @return 추가 성공 여부
     */
    public boolean addAdmin(Admin admin) {
        String sql = "INSERT INTO admins (admin_id, password, name, email) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, admin.getAdminId());
            pstmt.setString(2, PasswordUtil.hashPassword(admin.getPassword()));
            pstmt.setString(3, admin.getName());
            pstmt.setString(4, admin.getEmail());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 관리자 정보 수정
     * @param admin Admin 객체
     * @return 수정 성공 여부
     */
    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE admins SET name = ?, email = ?, updated_at = CURRENT_TIMESTAMP WHERE admin_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, admin.getName());
            pstmt.setString(2, admin.getEmail());
            pstmt.setString(3, admin.getAdminId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 관리자 비밀번호 변경
     * @param adminId 관리자 ID
     * @param newPassword 새 비밀번호
     * @return 변경 성공 여부
     */
    public boolean changePassword(String adminId, String newPassword) {
        String sql = "UPDATE admins SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE admin_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, PasswordUtil.hashPassword(newPassword));
            pstmt.setString(2, adminId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 관리자 계정 활성화/비활성화
     * @param adminId 관리자 ID
     * @param isActive 활성화 여부
     * @return 변경 성공 여부
     */
    public boolean setAdminStatus(String adminId, boolean isActive) {
        String sql = "UPDATE admins SET is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE admin_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBoolean(1, isActive);
            pstmt.setString(2, adminId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 관리자 삭제
     * @param adminId 관리자 ID
     * @return 삭제 성공 여부
     */
    public boolean deleteAdmin(String adminId) {
        String sql = "DELETE FROM admins WHERE admin_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, adminId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 관리자 ID 중복 체크
     * @param adminId 관리자 ID
     * @return 중복 여부
     */
    public boolean isAdminIdExists(String adminId) {
        String sql = "SELECT COUNT(*) FROM admins WHERE admin_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * 모든 활성 관리자의 전화번호 조회
     * @return 관리자 전화번호 목록
     */
    public List<String> getActiveAdminPhones() {
        List<String> phones = new ArrayList<>();
        String sql = "SELECT phone FROM admins WHERE is_active = TRUE AND phone IS NOT NULL AND phone != ''";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                String phone = rs.getString("phone");
                if (phone != null && !phone.trim().isEmpty()) {
                    phones.add(phone.trim());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return phones;
    }
}
