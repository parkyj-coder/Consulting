<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Admin" %>
<%
    // 폼에서 전송된 데이터 받기
    String inputId = request.getParameter("adminId");
    String inputPassword = request.getParameter("adminPassword");
    
    // 입력값 검증
    if (inputId == null || inputPassword == null || 
        inputId.trim().isEmpty() || inputPassword.trim().isEmpty()) {
        response.sendRedirect("login.jsp?error=2");
        return;
    }
    
    try {
        // 데이터베이스에서 관리자 인증
        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.authenticate(inputId.trim(), inputPassword);
        
        if (admin != null) {
            // 세션에 관리자 정보 저장
            session.setAttribute("adminLoggedIn", "true");
            session.setAttribute("adminId", admin.getAdminId());
            session.setAttribute("adminName", admin.getName());
            session.setAttribute("adminEmail", admin.getEmail());
            
            // 관리자 메인 페이지로 리다이렉트
            response.sendRedirect("consultationList.jsp");
        } else {
            // 로그인 실패 시 에러와 함께 로그인 페이지로 리다이렉트
            response.sendRedirect("login.jsp?error=1");
        }
    } catch (Exception e) {
        e.printStackTrace();
        // 시스템 오류 시 에러 페이지로 리다이렉트
        response.sendRedirect("login.jsp?error=3");
    }
%>
