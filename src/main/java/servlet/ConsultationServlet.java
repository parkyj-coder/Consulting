package servlet;

import dao.ConsultationDAO;
import model.ConsultationRequest;
import service.KakaoNotificationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/consultation/api/*")
public class ConsultationServlet extends HttpServlet {
    private ConsultationDAO consultationDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        consultationDAO = new ConsultationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            sendErrorResponse(response, "잘못된 요청입니다.");
            return;
        }
        
        switch (pathInfo) {
            case "/list":
                handleGetConsultationList(request, response);
                break;
            case "/detail":
                handleGetConsultationDetail(request, response);
                break;
            case "/stats":
                handleGetConsultationStats(request, response);
                break;
            default:
                sendErrorResponse(response, "지원하지 않는 API입니다.");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            sendErrorResponse(response, "잘못된 요청입니다.");
            return;
        }
        
        switch (pathInfo) {
            case "/submit":
                handleSubmitConsultation(request, response);
                break;
            case "/update-status":
                handleUpdateStatus(request, response);
                break;
            case "/delete":
                handleDeleteConsultation(request, response);
                break;
            default:
                sendErrorResponse(response, "지원하지 않는 API입니다.");
        }
    }
    
    private void handleSubmitConsultation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // 폼 데이터 받기
            String companyName = request.getParameter("companyName");
            String businessNumber = request.getParameter("businessNumber");
            String applicantName = request.getParameter("contactName");
            String relationship = request.getParameter("relationship");
            String relationshipOther = request.getParameter("relationshipOther");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String detailAddress = request.getParameter("detailAddress");
            String[] ownershipArray = request.getParameterValues("ownership");
            String industry = request.getParameter("industry");
            String sales = request.getParameter("sales");
            String loanAmount = request.getParameter("loanAmount");
            String[] fundTypeArray = request.getParameterValues("fundType");
            String message = request.getParameter("message");
            String privacyAgreement = request.getParameter("privacyAgreement");
            
            // 유효성 검사
            if (companyName == null || companyName.trim().isEmpty() ||
                businessNumber == null || businessNumber.trim().isEmpty() ||
                applicantName == null || applicantName.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                detailAddress == null || detailAddress.trim().isEmpty() ||
                industry == null || industry.trim().isEmpty() ||
                privacyAgreement == null) {
                
                out.print("{\"success\": false, \"message\": \"필수 항목을 모두 입력해주세요.\"}");
                return;
            }
            
            // 배열 데이터 처리
            String ownership = (ownershipArray != null) ? String.join(",", ownershipArray) : "";
            String fundType = (fundTypeArray != null) ? String.join(",", fundTypeArray) : "";
            
            // ConsultationRequest 객체 생성
            ConsultationRequest consultationRequest = new ConsultationRequest(
                companyName.trim(),
                businessNumber.trim(),
                applicantName.trim(),
                relationship,
                relationshipOther != null ? relationshipOther.trim() : "",
                phone.trim(),
                address.trim(),
                detailAddress.trim(),
                ownership,
                industry,
                sales != null ? sales.trim() : "",
                loanAmount != null ? loanAmount.trim() : "",
                fundType,
                message != null ? message.trim() : "",
                true
            );
            
            // DB에 저장
            boolean success = consultationDAO.saveConsultation(consultationRequest);
            
            if (success) {
                // 카카오톡 알림 전송
                try {
                    int sentCount = KakaoNotificationService.sendConsultationNotificationToAllAdmins(
                        companyName.trim(), 
                        applicantName.trim(), 
                        phone.trim()
                    );
                    System.out.println("관리자 " + sentCount + "명에게 알림 전송 완료");
                } catch (Exception e) {
                    // 카카오톡 알림 실패해도 상담신청은 성공으로 처리
                    System.err.println("카카오톡 알림 전송 실패: " + e.getMessage());
                }
                
                out.print("{\"success\": true, \"message\": \"상담신청이 정상적으로 접수되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"상담신청 처리 중 오류가 발생했습니다.\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
        }
    }
    
    private void handleGetConsultationList(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        if (!isAdminLoggedIn(request)) {
            sendErrorResponse(response, "인증이 필요합니다.");
            return;
        }
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            List<ConsultationRequest> consultations = consultationDAO.getAllConsultations();
            StringBuilder json = new StringBuilder("{\"success\": true, \"data\": [");
            
            for (int i = 0; i < consultations.size(); i++) {
                ConsultationRequest consultation = consultations.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"id\": ").append(consultation.getId()).append(",")
                    .append("\"companyName\": \"").append(consultation.getCompanyName()).append("\",")
                    .append("\"contactName\": \"").append(consultation.getContactName()).append("\",")
                    .append("\"phone\": \"").append(consultation.getPhone()).append("\",")
                    .append("\"industry\": \"").append(consultation.getIndustry()).append("\",")
                    .append("\"status\": \"").append(consultation.getStatus()).append("\",")
                    .append("\"createdAt\": \"").append(consultation.getCreatedAt()).append("\"")
                    .append("}");
            }
            
            json.append("]}");
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"상담 목록 조회 중 오류가 발생했습니다.\"}");
        }
    }
    
    private void handleGetConsultationDetail(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        if (!isAdminLoggedIn(request)) {
            sendErrorResponse(response, "인증이 필요합니다.");
            return;
        }
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"ID가 필요합니다.\"}");
                return;
            }
            
            int id = Integer.parseInt(idParam);
            ConsultationRequest consultation = consultationDAO.getConsultationById(id);
            
            if (consultation != null) {
                StringBuilder json = new StringBuilder("{\"success\": true, \"data\": {");
                json.append("\"id\": ").append(consultation.getId()).append(",")
                    .append("\"companyName\": \"").append(consultation.getCompanyName()).append("\",")
                    .append("\"businessNumber\": \"").append(consultation.getBusinessNumber()).append("\",")
                    .append("\"contactName\": \"").append(consultation.getContactName()).append("\",")
                    .append("\"relationship\": \"").append(consultation.getRelationship()).append("\",")
                    .append("\"relationshipOther\": \"").append(consultation.getRelationshipOther() != null ? consultation.getRelationshipOther() : "").append("\",")
                    .append("\"phone\": \"").append(consultation.getPhone()).append("\",")
                    .append("\"address\": \"").append(consultation.getAddress()).append("\",")
                    .append("\"detailAddress\": \"").append(consultation.getDetailAddress()).append("\",")
                    .append("\"ownership\": \"").append(consultation.getOwnership() != null ? consultation.getOwnership() : "").append("\",")
                    .append("\"industry\": \"").append(consultation.getIndustry()).append("\",")
                    .append("\"sales\": \"").append(consultation.getSales() != null ? consultation.getSales() : "").append("\",")
                    .append("\"loanAmount\": \"").append(consultation.getLoanAmount() != null ? consultation.getLoanAmount() : "").append("\",")
                    .append("\"fundType\": \"").append(consultation.getFundType() != null ? consultation.getFundType() : "").append("\",")
                    .append("\"message\": \"").append(consultation.getMessage() != null ? consultation.getMessage() : "").append("\",")
                    .append("\"status\": \"").append(consultation.getStatus()).append("\",")
                    .append("\"createdAt\": \"").append(consultation.getCreatedAt()).append("\",")
                    .append("\"updatedAt\": \"").append(consultation.getUpdatedAt()).append("\"")
                    .append("}}");
                out.print(json.toString());
            } else {
                out.print("{\"success\": false, \"message\": \"상담 신청을 찾을 수 없습니다.\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"잘못된 ID 형식입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"상담 신청 조회 중 오류가 발생했습니다.\"}");
        }
    }
    
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        if (!isAdminLoggedIn(request)) {
            sendErrorResponse(response, "인증이 필요합니다.");
            return;
        }
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String idParam = request.getParameter("id");
            String status = request.getParameter("status");
            
            if (idParam == null || status == null || idParam.trim().isEmpty() || status.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"ID와 상태가 필요합니다.\"}");
                return;
            }
            
            int id = Integer.parseInt(idParam);
            boolean success = consultationDAO.updateStatus(id, status.trim());
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"상태가 성공적으로 업데이트되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"상태 업데이트에 실패했습니다.\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"잘못된 ID 형식입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"상태 업데이트 중 오류가 발생했습니다.\"}");
        }
    }
    
    private void handleDeleteConsultation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        if (!isAdminLoggedIn(request)) {
            sendErrorResponse(response, "인증이 필요합니다.");
            return;
        }
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String idParam = request.getParameter("id");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"ID가 필요합니다.\"}");
                return;
            }
            
            int id = Integer.parseInt(idParam);
            boolean success = consultationDAO.deleteConsultation(id);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"상담 신청이 성공적으로 삭제되었습니다.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"삭제에 실패했습니다.\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"잘못된 ID 형식입니다.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"삭제 중 오류가 발생했습니다.\"}");
        }
    }
    
    private void handleGetConsultationStats(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        if (!isAdminLoggedIn(request)) {
            sendErrorResponse(response, "인증이 필요합니다.");
            return;
        }
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int pendingCount = consultationDAO.getConsultationCountByStatus("대기");
            int inProgressCount = consultationDAO.getConsultationCountByStatus("진행중");
            int completedCount = consultationDAO.getConsultationCountByStatus("완료");
            int cancelledCount = consultationDAO.getConsultationCountByStatus("취소");
            
            out.print("{\"success\": true, \"data\": {" +
                     "\"pending\": " + pendingCount + "," +
                     "\"inProgress\": " + inProgressCount + "," +
                     "\"completed\": " + completedCount + "," +
                     "\"cancelled\": " + cancelledCount + "," +
                     "\"total\": " + (pendingCount + inProgressCount + completedCount + cancelledCount) +
                     "}}");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"통계 조회 중 오류가 발생했습니다.\"}");
        }
    }
    
    private boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
        return "true".equals(adminLoggedIn);
    }
    
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        PrintWriter out = response.getWriter();
        out.print("{\"success\": false, \"message\": \"" + message + "\"}");
    }
}
