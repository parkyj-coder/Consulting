<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Admin" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    Boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");
    
    if (adminLoggedIn == null || !adminLoggedIn.equals("true") || 
        isSuperAdmin == null || !isSuperAdmin) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String action = request.getParameter("action");
    AdminDAO adminDAO = new AdminDAO();
    boolean success = false;
    
    try {
        if ("add".equals(action)) {
            // 관리자 추가
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            
            // 사용자명 중복 체크
            if (adminDAO.isUsernameExists(username)) {
                response.sendRedirect("adminList.jsp?error=duplicate");
                return;
            }
            
            Admin newAdmin = new Admin(username, password, name, email, role);
            success = adminDAO.addAdmin(newAdmin);
            
        } else if ("edit".equals(action)) {
            // 관리자 수정
            int adminId = Integer.parseInt(request.getParameter("adminId"));
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
            
            Admin admin = new Admin();
            admin.setId(adminId);
            admin.setName(name);
            admin.setEmail(email);
            admin.setRole(role);
            admin.setActive(isActive);
            
            success = adminDAO.updateAdmin(admin);
            
        } else if ("delete".equals(action)) {
            // 관리자 삭제 (실제 삭제)
            int adminId = Integer.parseInt(request.getParameter("adminId"));
            System.out.println("관리자 삭제 요청 - ID: " + adminId);
            success = adminDAO.deleteAdmin(adminId);
            System.out.println("관리자 삭제 결과: " + success);
            
        } else if ("toggleStatus".equals(action)) {
            // 관리자 상태 변경 (활성화/비활성화)
            int adminId = Integer.parseInt(request.getParameter("adminId"));
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));
            System.out.println("관리자 상태 변경 요청 - ID: " + adminId + ", 활성상태: " + isActive);
            success = adminDAO.setAdminStatus(adminId, isActive);
            System.out.println("관리자 상태 변경 결과: " + success);
        }
        
        if (success) {
            response.sendRedirect("adminList.jsp?success=" + action);
        } else {
            response.sendRedirect("adminList.jsp?error=" + action);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("adminList.jsp?error=exception");
    }
%>

