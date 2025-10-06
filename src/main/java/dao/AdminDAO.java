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
                        rs.getString("admin_level"),
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
                    rs.getString("admin_level"),
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
                    rs.getString("admin_level"),
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
     * 관리자 정보 종합 업데이트 (이름, 이메일, 상태, 권한, 비밀번호)
     * @param adminId 관리자 ID
     * @param name 이름
     * @param email 이메일
     * @param isActive 활성화 여부
     * @param adminLevel 권한 레벨
     * @param newPassword 새 비밀번호 (null이면 변경하지 않음)
     * @return 수정 성공 여부
     */
    public boolean updateAdminInfo(String adminId, String name, String email, boolean isActive, String adminLevel, String newPassword) {
        StringBuilder sql = new StringBuilder("UPDATE admins SET name = ?, email = ?, is_active = ?, admin_level = ?, updated_at = CURRENT_TIMESTAMP");
        
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            sql.append(", password = ?");
        }
        
        sql.append(" WHERE admin_id = ?");
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setBoolean(3, isActive);
            pstmt.setString(4, adminLevel);
            
            int paramIndex = 5;
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                pstmt.setString(paramIndex++, PasswordUtil.hashPassword(newPassword));
            }
            
            pstmt.setString(paramIndex, adminId);
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("AdminDAO.updateAdminInfo - Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("AdminDAO.updateAdminInfo - SQL Exception: " + e.getMessage());
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
            
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            System.out.println("AdminDAO.changePassword - AdminId: " + adminId + ", HashedPassword: " + hashedPassword.substring(0, Math.min(10, hashedPassword.length())) + "...");
            
            pstmt.setString(1, hashedPassword);
            pstmt.setString(2, adminId);
            
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("AdminDAO.changePassword - Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("AdminDAO.changePassword - SQL Exception: " + e.getMessage());
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
    
    /**
     * 관리자 권한 변경
     * @param adminId 관리자 ID
     * @param adminLevel 새로운 권한 레벨 ('super' 또는 'normal')
     * @return 변경 성공 여부
     */
    public boolean changeAdminLevel(String adminId, String adminLevel) {
        String sql = "UPDATE admins SET admin_level = ?, updated_at = CURRENT_TIMESTAMP WHERE admin_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, adminLevel);
            pstmt.setString(2, adminId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
