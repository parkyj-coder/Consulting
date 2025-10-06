<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        out.print("error");
        return;
    }
    
    // 폼 데이터 받기
    String adminId = request.getParameter("adminId");
    
    // 입력값 검증
    if (adminId == null || adminId.trim().isEmpty()) {
        out.print("error");
        return;
    }
    
    // 자기 자신 삭제 방지
    String currentAdminId = (String) session.getAttribute("adminId");
    if (adminId.equals(currentAdminId)) {
        out.print("error");
        return;
    }
    
    try {
        AdminDAO adminDAO = new AdminDAO();
        
        // 관리자 삭제
        if (adminDAO.deleteAdmin(adminId.trim())) {
            out.print("success");
        } else {
            out.print("error");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("error");
    }
%>
