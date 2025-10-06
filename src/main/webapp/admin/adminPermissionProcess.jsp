<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Admin" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="util.DBUtil" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        out.print("error: 인증되지 않은 사용자입니다.");
        return;
    }
    
    // 현재 로그인한 관리자 정보 확인
    String currentAdminId = (String) session.getAttribute("adminId");
    boolean isSuperAdmin = false;
    
    if (currentAdminId != null) {
        // 현재 로그인한 관리자의 권한 레벨 확인
        AdminDAO adminDAO = new AdminDAO();
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
    
    // 파라미터 받기
    String targetAdminId = request.getParameter("adminId");
    String action = request.getParameter("action");
    
    if (targetAdminId == null || targetAdminId.trim().isEmpty()) {
        out.print("error: 관리자 ID가 지정되지 않았습니다.");
        return;
    }
    
    if (action == null || (!action.equals("grant") && !action.equals("remove"))) {
        out.print("error: 잘못된 액션입니다.");
        return;
    }
    
    // 자기 자신의 권한을 변경하는 것 방지
    if (currentAdminId.equals(targetAdminId)) {
        out.print("error: 자기 자신의 권한을 변경할 수 없습니다.");
        return;
    }
    
    // 대상 관리자 정보 확인
    AdminDAO adminDAO = new AdminDAO();
    Admin targetAdmin = adminDAO.getAdminById(targetAdminId);
    
    if (targetAdmin == null) {
        out.print("error: 관리자를 찾을 수 없습니다.");
        return;
    }
    
    if (action.equals("grant")) {
        // 최고관리자 권한 부여
        System.out.println("Grant Permission - TargetAdminId: " + targetAdminId + ", CurrentLevel: " + targetAdmin.getAdminLevel());
        
        if ("super".equals(targetAdmin.getAdminLevel())) {
            out.print("error: 이미 최고관리자 권한을 가지고 있습니다.");
            return;
        }
        
        boolean result = adminDAO.changeAdminLevel(targetAdminId, "super");
        if (result) {
            System.out.println("Permission grant successful");
            out.print("success: 최고관리자 권한이 성공적으로 부여되었습니다.");
        } else {
            System.out.println("Permission grant failed - no rows affected");
            out.print("error: 권한 부여에 실패했습니다.");
        }
        
    } else if (action.equals("remove")) {
        // 최고관리자 권한 제거
        System.out.println("Remove Permission - TargetAdminId: " + targetAdminId + ", CurrentLevel: " + targetAdmin.getAdminLevel());
        
        if (!"super".equals(targetAdmin.getAdminLevel())) {
            out.print("error: 최고관리자 권한을 가지고 있지 않습니다.");
            return;
        }
        
        boolean result = adminDAO.changeAdminLevel(targetAdminId, "normal");
        if (result) {
            System.out.println("Permission remove successful");
            out.print("success: 최고관리자 권한이 성공적으로 제거되었습니다.");
        } else {
            System.out.println("Permission remove failed - no rows affected");
            out.print("error: 권한 제거에 실패했습니다.");
        }
    }
%>
