<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ConsultationDAO" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        out.print("{\"success\":false,\"message\":\"인증이 필요합니다.\"}");
        return;
    }
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    try {
        // JSON 요청 본문 읽기
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        
        String jsonBody = sb.toString();
        
        // ID 파싱
        int id = -1;
        Pattern idPattern = Pattern.compile("\"id\"\\s*:\\s*(\\d+)");
        Matcher idMatcher = idPattern.matcher(jsonBody);
        if (idMatcher.find()) {
            id = Integer.parseInt(idMatcher.group(1));
        }
        
        if (id == -1) {
            out.print("{\"success\":false,\"message\":\"ID 정보가 필요합니다.\"}");
        } else {
            ConsultationDAO dao = new ConsultationDAO();
            boolean success = dao.deleteConsultation(id);
            
            if (success) {
                out.print("{\"success\":true,\"message\":\"삭제되었습니다.\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"삭제에 실패했습니다.\"}");
            }
        }
    } catch (Exception e) {
        out.print("{\"success\":false,\"message\":\"오류가 발생했습니다: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        e.printStackTrace();
    }
%>


