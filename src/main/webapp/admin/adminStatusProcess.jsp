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
    String isActiveStr = request.getParameter("isActive");
    
    // 입력값 검증
    if (adminId == null || isActiveStr == null ||
        adminId.trim().isEmpty()) {
        out.print("error");
        return;
    }
    
    try {
        boolean isActive = Boolean.parseBoolean(isActiveStr);
        AdminDAO adminDAO = new AdminDAO();
        
        // 디버깅 정보 출력
        System.out.println("Admin Status Change - AdminId: " + adminId + ", IsActive: " + isActive);
        
        // 관리자 상태 변경
        if (adminDAO.setAdminStatus(adminId.trim(), isActive)) {
            System.out.println("Admin status change successful");
            out.clear();
            out.print("success");
        } else {
            System.out.println("Admin status change failed - no rows affected");
            out.clear();
            out.print("error");
        }
    } catch (Exception e) {
        System.out.println("Admin status change exception: " + e.getMessage());
        e.printStackTrace();
        out.print("error");
    }
%>
