<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Admin" %>
<%
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 폼 데이터 받기
    String adminId = request.getParameter("adminId");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    
    // 입력값 검증
    if (adminId == null || password == null || name == null ||
        adminId.trim().isEmpty() || password.trim().isEmpty() || name.trim().isEmpty()) {
        response.sendRedirect("adminManagement.jsp?error=1");
        return;
    }
    
    // 비밀번호 길이 검증
    if (password.length() < 6) {
        response.sendRedirect("adminManagement.jsp?error=2");
        return;
    }
    
    try {
        AdminDAO adminDAO = new AdminDAO();
        
        // 관리자 ID 중복 체크
        if (adminDAO.isAdminIdExists(adminId.trim())) {
            response.sendRedirect("adminManagement.jsp?error=3");
            return;
        }
        
        // 새 관리자 객체 생성
        Admin newAdmin = new Admin();
        newAdmin.setAdminId(adminId.trim());
        newAdmin.setPassword(password);
        newAdmin.setName(name.trim());
        newAdmin.setEmail(email != null ? email.trim() : null);
        
        // 관리자 추가
        if (adminDAO.addAdmin(newAdmin)) {
            response.sendRedirect("adminManagement.jsp?success=1");
        } else {
            response.sendRedirect("adminManagement.jsp?error=4");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("adminManagement.jsp?error=5");
    }
%>
