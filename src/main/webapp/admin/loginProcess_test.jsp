<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 임시 테스트용 - 데이터베이스 연결 없이 하드코딩된 인증
    String inputId = request.getParameter("adminId");
    String inputPassword = request.getParameter("adminPassword");
    
    // 임시 관리자 계정
    String adminId = "admin";
    String adminPassword = "admin123";
    
    if (adminId.equals(inputId) && adminPassword.equals(inputPassword)) {
        session.setAttribute("adminLoggedIn", "true");
        session.setAttribute("adminId", adminId);
        session.setAttribute("adminName", "시스템 관리자");
        response.sendRedirect("consultationList.jsp");
    } else {
        response.sendRedirect("login.jsp?error=1");
    }
%>
