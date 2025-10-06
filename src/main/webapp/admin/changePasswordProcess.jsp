<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 폼 데이터 받기
    String adminId = request.getParameter("adminId");
    String newPassword = request.getParameter("newPassword");
    
    // 입력값 검증
    if (adminId == null || newPassword == null ||
        adminId.trim().isEmpty() || newPassword.trim().isEmpty()) {
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
        
        // 비밀번호 변경
        if (adminDAO.changePassword(adminId.trim(), newPassword)) {
            out.print("success");
        } else {
            out.print("error");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("error");
    }
%>
