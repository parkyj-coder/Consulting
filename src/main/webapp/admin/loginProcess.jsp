<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Admin" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    String adminId = request.getParameter("adminId");
    String adminPassword = request.getParameter("adminPassword");
    
    // 입력 값 검증
    if (adminId == null || adminId.trim().isEmpty() || 
        adminPassword == null || adminPassword.trim().isEmpty()) {
        response.sendRedirect("login.jsp?error=2");
        return;
    }
    
    try {
        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.login(adminId.trim(), adminPassword.trim());
        
        if (admin != null && admin.isActive()) {
            // 로그인 성공
            session.setAttribute("adminLoggedIn", "true");
            session.setAttribute("adminId", String.valueOf(admin.getId()));
            session.setAttribute("adminUsername", admin.getUsername());
            session.setAttribute("adminName", admin.getName());
            session.setAttribute("adminRole", admin.getRole());
            session.setAttribute("isSuperAdmin", admin.isSuperAdmin());
            
            // 세션 타임아웃 설정 (30분)
            session.setMaxInactiveInterval(1800);
            
            response.sendRedirect("consultationList.jsp");
        } else {
            // 로그인 실패
            response.sendRedirect("login.jsp?error=1");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=3");
    }
%>
