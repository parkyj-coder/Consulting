package dao;

import model.ConsultationRequest;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsultationDAO {
    
    // 상담신청 저장
    public boolean saveConsultation(ConsultationRequest request) {
        System.out.println("=== ConsultationDAO.saveConsultation 시작 ===");
        String sql = "INSERT INTO consultation_requests " +
                    "(company_name, business_number, applicant_name, relationship, relationship_other, " +
                    "phone, address, detail_address, ownership, industry, sales, sales_unit, loan_amount, loan_unit, " +
                    "fund_type, message, privacy_agreement, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        System.out.println("SQL: " + sql);
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            System.out.println("DB 연결 성공");
            
            pstmt.setString(1, request.getCompanyName());
            pstmt.setString(2, request.getBusinessNumber());
            pstmt.setString(3, request.getApplicantName());
            pstmt.setString(4, request.getRelationship());
            pstmt.setString(5, request.getRelationshipOther());
            pstmt.setString(6, request.getPhone());
            pstmt.setString(7, request.getAddress());
            pstmt.setString(8, request.getDetailAddress());
            pstmt.setString(9, request.getOwnership());
            pstmt.setString(10, request.getIndustry());
            pstmt.setString(11, request.getSales());
            pstmt.setString(12, request.getSalesUnit());
            pstmt.setString(13, request.getLoanAmount());
            pstmt.setString(14, request.getLoanUnit());
            pstmt.setString(15, request.getFundType());
            pstmt.setString(16, request.getMessage());
            pstmt.setBoolean(17, request.isPrivacyAgreement());
            pstmt.setString(18, request.getStatus());
            
            int result = pstmt.executeUpdate();
            System.out.println("INSERT 실행 결과: " + result + "행 영향받음");
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("DB 저장 중 SQLException 발생:");
            e.printStackTrace();
            return false;
        }
    }
    
    // 모든 상담신청 조회
    public List<ConsultationRequest> getAllConsultations() {
        List<ConsultationRequest> consultations = new ArrayList<>();
        String sql = "SELECT * FROM consultation_requests ORDER BY created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                ConsultationRequest request = new ConsultationRequest();
                request.setId(rs.getInt("id"));
                request.setCompanyName(rs.getString("company_name"));
                request.setBusinessNumber(rs.getString("business_number"));
                request.setApplicantName(rs.getString("applicant_name"));
                request.setRelationship(rs.getString("relationship"));
                request.setRelationshipOther(rs.getString("relationship_other"));
                request.setPhone(rs.getString("phone"));
                request.setAddress(rs.getString("address"));
                request.setDetailAddress(rs.getString("detail_address"));
                request.setOwnership(rs.getString("ownership"));
                request.setIndustry(rs.getString("industry"));
                request.setSales(rs.getString("sales"));
                request.setSalesUnit(rs.getString("sales_unit"));
                request.setLoanAmount(rs.getString("loan_amount"));
                request.setLoanUnit(rs.getString("loan_unit"));
                request.setFundType(rs.getString("fund_type"));
                request.setMessage(rs.getString("message"));
                request.setPrivacyAgreement(rs.getBoolean("privacy_agreement"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
                request.setStatus(rs.getString("status"));
                
                consultations.add(request);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return consultations;
    }
    
    // ID로 상담신청 조회
    public ConsultationRequest getConsultationById(int id) {
        String sql = "SELECT * FROM consultation_requests WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                ConsultationRequest request = new ConsultationRequest();
                request.setId(rs.getInt("id"));
                request.setCompanyName(rs.getString("company_name"));
                request.setBusinessNumber(rs.getString("business_number"));
                request.setApplicantName(rs.getString("applicant_name"));
                request.setRelationship(rs.getString("relationship"));
                request.setRelationshipOther(rs.getString("relationship_other"));
                request.setPhone(rs.getString("phone"));
                request.setAddress(rs.getString("address"));
                request.setDetailAddress(rs.getString("detail_address"));
                request.setOwnership(rs.getString("ownership"));
                request.setIndustry(rs.getString("industry"));
                request.setSales(rs.getString("sales"));
                request.setSalesUnit(rs.getString("sales_unit"));
                request.setLoanAmount(rs.getString("loan_amount"));
                request.setLoanUnit(rs.getString("loan_unit"));
                request.setFundType(rs.getString("fund_type"));
                request.setMessage(rs.getString("message"));
                request.setPrivacyAgreement(rs.getBoolean("privacy_agreement"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
                request.setStatus(rs.getString("status"));
                
                return request;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // 상담신청 상태 업데이트
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE consultation_requests SET status = ? WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 상담신청 삭제
    public boolean deleteConsultation(int id) {
        String sql = "DELETE FROM consultation_requests WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
