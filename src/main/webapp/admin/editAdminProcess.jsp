<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Admin" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 현재 로그인한 관리자 정보 확인
    String currentAdminId = (String) session.getAttribute("adminId");
    boolean isSuperAdmin = false;
    
    AdminDAO adminDAO = new AdminDAO();
    
    if (currentAdminId != null) {
        // 현재 로그인한 관리자의 권한 레벨 확인
        Admin currentAdmin = adminDAO.getAdminById(currentAdminId);
        if (currentAdmin != null) {
            // admin_level이 null이거나 없으면 기존 방식으로 확인
            if (currentAdmin.getAdminLevel() == null) {
                isSuperAdmin = "admin".equals(currentAdminId) || "superadmin".equals(currentAdminId);
            } else {
                isSuperAdmin = "super".equals(currentAdmin.getAdminLevel());
            }
        }
    }
    
    // 최고 관리자 권한 체크
    if (!isSuperAdmin) {
        out.print("error: 최고 관리자 권한이 필요합니다.");
        return;
    }
    
    // 폼 데이터 받기
    String adminId = request.getParameter("adminId");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String status = request.getParameter("status");
    String adminLevel = request.getParameter("adminLevel");
    String newPassword = request.getParameter("newPassword");
    
    // 디버깅 정보 출력
    System.out.println("Admin Edit Request - AdminId: " + adminId + ", Name: " + name + ", Email: " + email + ", Status: " + status + ", AdminLevel: " + adminLevel);
    
    // 입력값 검증
    if (adminId == null || name == null || adminId.trim().isEmpty() || name.trim().isEmpty()) {
        System.out.println("Admin edit validation failed - AdminId: " + adminId + ", Name: " + name);
        out.print("error");
        return;
    }
    
    // 자기 자신의 권한을 변경하는 것 방지
    if (currentAdminId.equals(adminId)) {
        out.print("error: 자기 자신의 정보는 수정할 수 없습니다.");
        return;
    }
    
    try {
        // 관리자 정보 업데이트
        boolean result = adminDAO.updateAdminInfo(adminId.trim(), name.trim(), email, 
                                                 "true".equals(status), adminLevel, newPassword);
        
        if (result) {
            System.out.println("Admin edit successful");
            out.clear();
            out.print("success");
        } else {
            System.out.println("Admin edit failed - no rows affected");
            out.clear();
            out.print("error");
        }
    } catch (Exception e) {
        System.out.println("Admin edit exception: " + e.getMessage());
        e.printStackTrace();
        out.clear();
        out.print("error");
    }
%>
