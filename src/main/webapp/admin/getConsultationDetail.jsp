<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ConsultationDAO" %>
<%@ page import="model.ConsultationRequest" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        out.print("{\"success\":false,\"message\":\"인증이 필요합니다.\"}");
        return;
    }
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    String idParam = request.getParameter("id");
    
    try {
        if (idParam == null || idParam.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"ID가 제공되지 않았습니다.\"}");
        } else {
            int id = Integer.parseInt(idParam);
            ConsultationDAO dao = new ConsultationDAO();
            ConsultationRequest consultation = dao.getConsultationById(id);
            
            if (consultation != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String createdAt = consultation.getCreatedAt() != null ? sdf.format(consultation.getCreatedAt()) : "";
                
                // JSON 생성
                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"data\":{");
                json.append("\"id\":").append(consultation.getId()).append(",");
                json.append("\"companyName\":\"").append(escapeJson(consultation.getCompanyName())).append("\",");
                json.append("\"businessNumber\":\"").append(escapeJson(consultation.getBusinessNumber())).append("\",");
                json.append("\"applicantName\":\"").append(escapeJson(consultation.getContactName())).append("\",");
                json.append("\"relationship\":\"").append(escapeJson(consultation.getRelationship())).append("\",");
                json.append("\"relationshipOther\":\"").append(escapeJson(consultation.getRelationshipOther())).append("\",");
                json.append("\"phone\":\"").append(escapeJson(consultation.getPhone())).append("\",");
                json.append("\"address\":\"").append(escapeJson(consultation.getAddress())).append("\",");
                json.append("\"detailAddress\":\"").append(escapeJson(consultation.getDetailAddress())).append("\",");
                json.append("\"ownership\":\"").append(escapeJson(consultation.getOwnership())).append("\",");
                json.append("\"industry\":\"").append(escapeJson(consultation.getIndustry())).append("\",");
                json.append("\"sales\":\"").append(escapeJson(consultation.getSales())).append("\",");
                json.append("\"loanAmount\":\"").append(escapeJson(consultation.getLoanAmount())).append("\",");
                json.append("\"fundType\":\"").append(escapeJson(consultation.getFundType())).append("\",");
                json.append("\"message\":\"").append(escapeJson(consultation.getMessage())).append("\",");
                json.append("\"status\":\"").append(escapeJson(consultation.getStatus())).append("\",");
                json.append("\"createdAt\":\"").append(createdAt).append("\"");
                json.append("}}");
                
                out.print(json.toString());
            } else {
                out.print("{\"success\":false,\"message\":\"상담신청을 찾을 수 없습니다.\"}");
            }
        }
    } catch (NumberFormatException e) {
        out.print("{\"success\":false,\"message\":\"잘못된 ID 형식입니다.\"}");
    } catch (Exception e) {
        out.print("{\"success\":false,\"message\":\"오류가 발생했습니다: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        e.printStackTrace();
    }
%>
<%!
    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
%>


