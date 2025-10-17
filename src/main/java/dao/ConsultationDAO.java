package dao;

import model.ConsultationRequest;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsultationDAO {
    
    /**
     * 새로운 상담 신청을 데이터베이스에 저장합니다. (JSP에서 호출하는 메서드)
     * @param consultation 상담 신청 정보
     * @return 저장 성공시 true, 실패시 false
     */
    public boolean saveConsultation(ConsultationRequest consultation) {
        int result = insertConsultation(consultation);
        return result > 0;
    }
    
    /**
     * 새로운 상담 신청을 데이터베이스에 저장합니다.
     * @param consultation 상담 신청 정보
     * @return 저장된 상담 신청의 ID, 실패시 -1
     */
    public int insertConsultation(ConsultationRequest consultation) {
        String sql = "INSERT INTO consultation_requests " +
                    "(company_name, business_number, contact_name, relationship, relationship_other, " +
                    "phone, address, detail_address, ownership, industry, sales, loan_amount, " +
                    "fund_type, message, status, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '대기', NOW(), NOW())";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            pstmt.setString(1, consultation.getCompanyName());
            pstmt.setString(2, consultation.getBusinessNumber());
            pstmt.setString(3, consultation.getContactName());
            pstmt.setString(4, consultation.getRelationship());
            pstmt.setString(5, consultation.getRelationshipOther());
            pstmt.setString(6, consultation.getPhone());
            pstmt.setString(7, consultation.getAddress());
            pstmt.setString(8, consultation.getDetailAddress());
            pstmt.setString(9, consultation.getOwnership());
            pstmt.setString(10, consultation.getIndustry());
            pstmt.setString(11, consultation.getSales());
            pstmt.setString(12, consultation.getLoanAmount());
            pstmt.setString(13, consultation.getFundType());
            pstmt.setString(14, consultation.getMessage());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
            return -1;
        } catch (SQLException e) {
            System.err.println("상담 신청 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }
    
    /**
     * 모든 상담 신청 목록을 조회합니다.
     * @return 상담 신청 목록
     */
    public List<ConsultationRequest> getAllConsultations() {
        String sql = "SELECT * FROM consultation_requests ORDER BY created_at DESC";
        List<ConsultationRequest> consultations = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                consultations.add(mapResultSetToConsultation(rs));
            }
        } catch (SQLException e) {
            System.err.println("상담 목록 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return consultations;
    }
    
    /**
     * ID로 특정 상담 신청을 조회합니다.
     * @param id 상담 신청 ID
     * @return 상담 신청 정보, 없으면 null
     */
    public ConsultationRequest getConsultationById(int id) {
        String sql = "SELECT * FROM consultation_requests WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToConsultation(rs);
            }
        } catch (SQLException e) {
            System.err.println("상담 신청 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * 상담 신청의 상태를 업데이트합니다.
     * @param id 상담 신청 ID
     * @param status 새로운 상태
     * @return 업데이트 성공시 true, 실패시 false
     */
    public boolean updateConsultationStatus(int id, String status) {
        String sql = "UPDATE consultation_requests SET status = ?, updated_at = NOW() WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("상담 상태 업데이트 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * 상담 신청의 상태를 업데이트합니다. (JSP에서 사용하는 메서드명)
     * @param id 상담 신청 ID
     * @param status 새로운 상태
     * @return 업데이트 성공시 true, 실패시 false
     */
    public boolean updateStatus(int id, String status) {
        return updateConsultationStatus(id, status);
    }
    
    /**
     * 상담 신청을 삭제합니다.
     * @param id 상담 신청 ID
     * @return 삭제 성공시 true, 실패시 false
     */
    public boolean deleteConsultation(int id) {
        String sql = "DELETE FROM consultation_requests WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("상담 신청 삭제 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }
    
    /**
     * 상태별 상담 신청 수를 조회합니다.
     * @return 상태별 상담 신청 수
     */
    public int getConsultationCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM consultation_requests WHERE status = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("상태별 상담 수 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return 0;
    }
    
    /**
     * ResultSet을 ConsultationRequest 객체로 변환합니다.
     */
    private ConsultationRequest mapResultSetToConsultation(ResultSet rs) throws SQLException {
        ConsultationRequest consultation = new ConsultationRequest();
        consultation.setId(rs.getInt("id"));
        consultation.setCompanyName(rs.getString("company_name"));
        consultation.setBusinessNumber(rs.getString("business_number"));
        consultation.setContactName(rs.getString("contact_name"));
        consultation.setRelationship(rs.getString("relationship"));
        consultation.setRelationshipOther(rs.getString("relationship_other"));
        consultation.setPhone(rs.getString("phone"));
        consultation.setAddress(rs.getString("address"));
        consultation.setDetailAddress(rs.getString("detail_address"));
        consultation.setOwnership(rs.getString("ownership"));
        consultation.setIndustry(rs.getString("industry"));
        consultation.setSales(rs.getString("sales"));
        consultation.setLoanAmount(rs.getString("loan_amount"));
        consultation.setFundType(rs.getString("fund_type"));
        consultation.setMessage(rs.getString("message"));
        consultation.setStatus(rs.getString("status"));
        consultation.setCreatedAt(rs.getTimestamp("created_at"));
        consultation.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return consultation;
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
