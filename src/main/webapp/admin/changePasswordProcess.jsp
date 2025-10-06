<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 폼 데이터 받기
    String adminId = request.getParameter("adminId");
    String newPassword = request.getParameter("newPassword");
    
    // 디버깅 정보 출력
    System.out.println("Password Change Request - AdminId: " + adminId + ", NewPassword: " + (newPassword != null ? "***" : "null"));
    
    // 입력값 검증
    if (adminId == null || newPassword == null ||
        adminId.trim().isEmpty() || newPassword.trim().isEmpty()) {
        System.out.println("Password change validation failed - AdminId: " + adminId + ", NewPassword: " + (newPassword != null ? "empty" : "null"));
        out.print("error");
        return;
    }
    
    // 비밀번호 길이 검증
    if (newPassword.length() < 6) {
        out.print("error");
        return;
    }
    
    try {
        AdminDAO adminDAO = new AdminDAO();
        
        // 디버깅 정보 출력
        System.out.println("Password Change - AdminId: " + adminId + ", NewPassword length: " + newPassword.length());
        
        // 비밀번호 변경
        boolean result = adminDAO.changePassword(adminId.trim(), newPassword);
        System.out.println("Password change result: " + result);
        
        if (result) {
            System.out.println("Password change successful");
            out.clear();
            out.print("success");
        } else {
            System.out.println("Password change failed - no rows affected");
            out.clear();
            out.print("error");
        }
    } catch (Exception e) {
        System.out.println("Password change exception: " + e.getMessage());
        e.printStackTrace();
        out.clear();
        out.print("error");
    }
%>
