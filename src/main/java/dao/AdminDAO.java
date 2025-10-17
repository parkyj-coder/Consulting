package dao;

import model.Admin;
import util.DBUtil;
import util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    
    /**
     * 관리자 로그인을 처리합니다.
     * @param username 사용자명
     * @param password 비밀번호
     * @return 로그인 성공시 Admin 객체, 실패시 null
     */
    public Admin login(String username, String password) {
        String sql = "SELECT * FROM admins WHERE username = ? AND active = true";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                
                // 비밀번호 검증
                if (PasswordUtil.verifyPassword(password, storedPassword)) {
                    return mapResultSetToAdmin(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("관리자 로그인 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * 새로운 관리자를 추가합니다. (JSP에서 호출하는 메서드)
     * @param admin 관리자 정보
     * @return 추가 성공시 true, 실패시 false
     */
    public boolean addAdmin(Admin admin) {
        return insertAdmin(admin);
    }
    
    /**
     * 새로운 관리자를 추가합니다.
     * @param admin 관리자 정보
     * @return 추가 성공시 true, 실패시 false
     */
    public boolean insertAdmin(Admin admin) {
        String sql = "INSERT INTO admins (username, password, name, email, role, active) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, admin.getUsername());
            pstmt.setString(2, PasswordUtil.hashPassword(admin.getPassword()));
            pstmt.setString(3, admin.getName());
            pstmt.setString(4, admin.getEmail());
            pstmt.setString(5, admin.getRole());
            pstmt.setBoolean(6, admin.isActive());
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("관리자 추가 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * 모든 관리자 목록을 조회합니다.
     * @return 관리자 목록
     */
    public List<Admin> getAllAdmins() {
        String sql = "SELECT * FROM admins ORDER BY created_at DESC";
        List<Admin> admins = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                admins.add(mapResultSetToAdmin(rs));
            }
        } catch (SQLException e) {
            System.err.println("관리자 목록 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return admins;
    }
    
    /**
     * ID로 특정 관리자를 조회합니다.
     * @param id 관리자 ID
     * @return 관리자 정보, 없으면 null
     */
    public Admin getAdminById(int id) {
        String sql = "SELECT * FROM admins WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
        } catch (SQLException e) {
            System.err.println("관리자 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * 관리자 정보를 업데이트합니다.
     * @param admin 관리자 정보
     * @return 업데이트 성공시 true, 실패시 false
     */
    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE admins SET name = ?, email = ?, role = ?, active = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, admin.getName());
            pstmt.setString(2, admin.getEmail());
            pstmt.setString(3, admin.getRole());
            pstmt.setBoolean(4, admin.isActive());
            pstmt.setInt(5, admin.getId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("관리자 정보 업데이트 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * 관리자 비밀번호를 변경합니다.
     * @param id 관리자 ID
     * @param newPassword 새로운 비밀번호
     * @return 변경 성공시 true, 실패시 false
     */
    public boolean changePassword(int id, String newPassword) {
        String sql = "UPDATE admins SET password = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, PasswordUtil.hashPassword(newPassword));
            pstmt.setInt(2, id);
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("비밀번호 변경 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * 관리자를 삭제합니다.
     * @param id 관리자 ID
     * @return 삭제 성공시 true, 실패시 false
     */
    public boolean deleteAdmin(int id) {
        String sql = "DELETE FROM admins WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("관리자 삭제 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * 관리자의 활성 상태를 변경합니다.
     * @param id 관리자 ID
     * @param isActive 활성 상태
     * @return 변경 성공시 true, 실패시 false
     */
    public boolean setAdminStatus(int id, boolean isActive) {
        String sql = "UPDATE admins SET active = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setBoolean(1, isActive);
            pstmt.setInt(2, id);
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("관리자 상태 변경 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * 사용자명 중복을 확인합니다.
     * @param username 확인할 사용자명
     * @return 중복시 true, 사용 가능시 false
     */
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM admins WHERE username = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("사용자명 중복 확인 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return false;
    }
    
    /**
     * ResultSet을 Admin 객체로 변환합니다.
     */
    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setId(rs.getInt("id"));
        admin.setUsername(rs.getString("username"));
        admin.setPassword(rs.getString("password")); // 해시된 비밀번호
        admin.setName(rs.getString("name"));
        admin.setEmail(rs.getString("email"));
        admin.setRole(rs.getString("role"));
        admin.setActive(rs.getBoolean("active"));
        
        return admin;
    }
    
    /**
     * 데이터베이스 리소스를 닫습니다.
     */
    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (pstmt != null) {
            try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
