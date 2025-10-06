<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Admin" %>
<%@ page import="java.util.List" %>
<%
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
    
    // 최고 관리자 권한 체크 - 최고 관리자가 아니면 접근 거부
    if (!isSuperAdmin) {
        response.sendRedirect("consultationList.jsp");
        return;
    }
    
    List<Admin> admins = adminDAO.getAllAdmins();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 계정 관리 - 중소벤처정책자금센터</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .admin-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .admin-header {
            background: #3182ce;
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .admin-header h1 {
            margin: 0;
            font-size: 2rem;
        }
        
        .admin-navigation {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .nav-button {
            display: inline-block;
            padding: 6px 12px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.3);
            font-size: 0.875rem;
            white-space: nowrap;
            flex-shrink: 0;
        }
        
        /* 햄버거 메뉴 스타일 */
        .hamburger-menu {
            position: relative;
            display: inline-block;
        }
        
        .hamburger-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1.2rem;
            transition: background-color 0.3s;
        }
        
        .hamburger-btn:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        
        .hamburger-content {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            background: white;
            min-width: 200px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            border-radius: 4px;
            z-index: 1000;
            margin-top: 5px;
        }
        
        .hamburger-content.show {
            display: block;
        }
        
        .hamburger-content a {
            color: #333;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            border-bottom: 1px solid #f0f0f0;
            transition: background-color 0.3s;
        }
        
        .hamburger-content a:hover {
            background-color: #f5f5f5;
        }
        
        .hamburger-content a:last-child {
            border-bottom: none;
        }
        
        .hamburger-content a i {
            margin-right: 8px;
            width: 16px;
            text-align: center;
        }
        
        .nav-button:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            text-decoration: none;
        }
        
        .nav-button i {
            margin-right: 5px;
        }
        
        .table-container {
            overflow-x: auto;
            margin-bottom: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .admin-table {
            width: 100%;
            min-width: 600px;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }
        
        .admin-table th,
        .admin-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .admin-table th {
            background: #f7fafc;
            font-weight: 600;
            color: #2d3748;
        }
        
        .admin-table tr:hover {
            background: #f7fafc;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .status-active {
            background: #c6f6d5;
            color: #2f855a;
        }
        
        .status-inactive {
            background: #fed7d7;
            color: #c53030;
        }
        
        .btn {
            padding: 4px 8px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8rem;
            margin: 1px;
            white-space: nowrap;
        }
        
        .btn-primary {
            background: #3182ce;
            color: white;
        }
        
        .btn-success {
            background: #38a169;
            color: white;
        }
        
        .btn-danger {
            background: #e53e3e;
            color: white;
        }
        
        .btn-warning {
            background: #d69e2e;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
        
        /* 관리자 액션 드롭다운 스타일 */
        .admin-actions {
            position: relative;
            display: inline-block;
        }
        
        .action-toggle-btn {
            background: #f7fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 8px 12px;
            cursor: pointer;
            font-size: 0.875rem;
            color: #4a5568;
            transition: all 0.2s;
            min-width: 40px;
            text-align: center;
        }
        
        .action-toggle-btn:hover {
            background: #edf2f7;
            border-color: #cbd5e0;
        }
        
        .action-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            z-index: 1000;
            min-width: 180px;
            display: none;
            margin-top: 4px;
        }
        
        .action-menu.show {
            display: block;
        }
        
        .action-btn {
            width: 100%;
            padding: 10px 16px;
            border: none;
            background: none;
            text-align: left;
            cursor: pointer;
            font-size: 0.875rem;
            color: #4a5568;
            transition: background-color 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .action-btn:first-child {
            border-radius: 8px 8px 0 0;
        }
        
        .action-btn:last-child {
            border-radius: 0 0 8px 8px;
        }
        
        .action-btn:hover {
            background: #f7fafc;
        }
        
        .action-btn.danger {
            color: #e53e3e;
        }
        
        .action-btn.danger:hover {
            background: #fed7d7;
        }
        
        .action-btn i {
            width: 16px;
            text-align: center;
        }
        
        .add-admin-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #2d3748;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            font-size: 0.875rem;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        .form-row {
            display: flex;
            gap: 15px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 20px;
            border-radius: 8px;
            width: 80%;
            max-width: 500px;
        }
        
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: black;
        }
        
        @media (max-width: 768px) {
            .admin-header {
                padding: 15px;
            }
            
            .admin-header h1 {
                font-size: 1.5rem;
                margin-bottom: 10px;
            }
            
            .nav-button {
                padding: 5px 10px;
                font-size: 0.8rem;
            }
            
            .hamburger-btn {
                padding: 6px 10px;
                font-size: 1rem;
            }
            
            .hamburger-content {
                min-width: 180px;
            }
            
            .form-row {
                flex-direction: column;
            }
            
            .table-container {
                margin: 0 -10px;
                border-radius: 0;
                box-shadow: none;
            }
            
            .admin-table {
                font-size: 0.875rem;
                min-width: 500px;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 8px 6px;
                white-space: nowrap;
            }
            
            /* 관리 컬럼 스타일 */
            .admin-table td:last-child {
                white-space: normal;
                min-width: 60px;
                text-align: center;
            }
            
            .action-toggle-btn {
                padding: 6px 10px;
                font-size: 0.8rem;
            }
            
            .action-menu {
                min-width: 160px;
                right: -10px;
            }
            
            .action-btn {
                padding: 8px 12px;
                font-size: 0.8rem;
            }
            
            .btn {
                padding: 3px 6px;
                font-size: 0.75rem;
                margin: 1px;
            }
            
            .admin-table th:first-child,
            .admin-table td:first-child {
                position: sticky;
                left: 0;
                background: #f7fafc;
                z-index: 1;
            }
            
            .admin-table td:first-child {
                background: white;
            }
        }
        
        @media (max-width: 480px) {
            .nav-button {
                padding: 4px 8px;
                font-size: 0.75rem;
            }
            
            .hamburger-btn {
                padding: 5px 8px;
                font-size: 0.9rem;
            }
            
            .hamburger-content {
                min-width: 160px;
            }
            
            .hamburger-content a {
                padding: 10px 12px;
                font-size: 0.9rem;
            }
            
            .table-container {
                margin: 0 -15px;
            }
            
            .admin-table {
                font-size: 0.8rem;
                min-width: 450px;
            }
            
            /* 관리 컬럼 스타일 */
            .admin-table td:last-child {
                white-space: normal;
                min-width: 50px;
                text-align: center;
            }
            
            .action-toggle-btn {
                padding: 5px 8px;
                font-size: 0.75rem;
            }
            
            .action-menu {
                min-width: 140px;
                right: -15px;
            }
            
            .action-btn {
                padding: 6px 10px;
                font-size: 0.75rem;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 6px 4px;
            }
            
            .btn {
                padding: 2px 4px;
                font-size: 0.7rem;
                margin: 1px;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <div class="admin-header">
            <div class="admin-navigation">
                <a href="../index.html" class="nav-button">
                    <i>🏠</i>홈으로
                </a>
                <div class="hamburger-menu">
                    <button class="hamburger-btn" onclick="toggleHamburgerMenu()">☰</button>
                    <div class="hamburger-content" id="hamburgerContent">
                        <a href="consultationList.jsp">
                            <i>📋</i>상담관리
                        </a>
                        <a href="logout.jsp">
                            <i>🚪</i>로그아웃
                        </a>
                    </div>
                </div>
            </div>
            <h1>관리자 계정 관리</h1>
            <p>시스템 관리자 계정을 관리할 수 있습니다.</p>
        </div>
        
        <!-- 새 관리자 추가 섹션 (최고 상위 관리자만) -->
        <% if (isSuperAdmin) { %>
        <div class="add-admin-section">
            <h3>새 관리자 추가</h3>
            <form action="addAdminProcess.jsp" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label for="adminId">관리자 ID</label>
                        <input type="text" id="adminId" name="adminId" required>
                    </div>
                    <div class="form-group">
                        <label for="password">비밀번호</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">이름</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="email">이메일</label>
                        <input type="email" id="email" name="email">
                    </div>
                </div>
                <button type="submit" class="btn btn-success">관리자 추가</button>
            </form>
        </div>
        <% } %>
        
        <!-- 관리자 목록 -->
        <div class="table-container">
            <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>관리자 ID</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>상태</th>
                    <th>권한</th>
                    <th>생성일</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <% if (admins.isEmpty()) { %>
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 40px; color: #718096;">
                            등록된 관리자가 없습니다.
                        </td>
                    </tr>
                <% } else { %>
                    <% for (Admin admin : admins) { %>
                        <tr>
                            <td><%= admin.getId() %></td>
                            <td><%= admin.getAdminId() %></td>
                            <td><%= admin.getName() %></td>
                            <td><%= admin.getEmail() != null ? admin.getEmail() : "-" %></td>
                            <td>
                                <span class="status-badge status-<%= admin.isActive() ? "active" : "inactive" %>">
                                    <%= admin.isActive() ? "활성" : "비활성" %>
                                </span>
                            </td>
                            <td>
                                <% 
                                    boolean isAdminSuper = false;
                                    if (admin.getAdminLevel() != null) {
                                        isAdminSuper = "super".equals(admin.getAdminLevel());
                                    } else {
                                        isAdminSuper = "admin".equals(admin.getAdminId()) || "superadmin".equals(admin.getAdminId());
                                    }
                                %>
                                <% if (isAdminSuper) { %>
                                    <span class="status-badge" style="background: #fef5e7; color: #d69e2e; border: 1px solid #f6e05e;">
                                        최고관리자
                                    </span>
                                <% } else { %>
                                    <span class="status-badge" style="background: #e6fffa; color: #319795; border: 1px solid #81e6d9;">
                                        일반관리자
                                    </span>
                                <% } %>
                            </td>
                            <td><%= admin.getCreatedAt() %></td>
                            <td>
                                <button class="btn btn-primary" onclick="selectAdmin('<%= admin.getAdminId() %>', '<%= admin.getName() %>', '<%= admin.getEmail() != null ? admin.getEmail() : "" %>', <%= admin.isActive() %>, '<%= isAdminSuper ? "super" : "normal" %>')">
                                    <i class="fas fa-edit"></i> 선택
                                </button>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>
        </div>
    </div>
    
    <!-- 비밀번호 변경 모달 (최고 상위 관리자만) -->
    <% if (isSuperAdmin) { %>
    <div id="passwordModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closePasswordModal()">&times;</span>
            <h3>비밀번호 변경</h3>
            <form id="passwordForm">
                <input type="hidden" id="targetAdminId" name="adminId">
                <div class="form-group">
                    <label for="newPassword">새 비밀번호</label>
                    <input type="password" id="newPassword" name="newPassword" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">비밀번호 확인</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                <button type="submit" class="btn btn-primary">변경</button>
            </form>
        </div>
    </div>
    <% } %>
    
    <!-- 관리자 편집 모달 -->
    <div id="adminEditModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeAdminEditModal()">&times;</span>
            <h3>관리자 정보 편집</h3>
            <form id="adminEditForm">
                <input type="hidden" id="editAdminId" name="adminId">
                
                <div class="form-group">
                    <label for="editAdminIdDisplay">관리자 ID</label>
                    <input type="text" id="editAdminIdDisplay" readonly style="background: #f7fafc;">
                </div>
                
                <div class="form-group">
                    <label for="editName">이름</label>
                    <input type="text" id="editName" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="editEmail">이메일</label>
                    <input type="email" id="editEmail" name="email">
                </div>
                
                <div class="form-group">
                    <label for="editStatus">상태</label>
                    <select id="editStatus" name="status">
                        <option value="true">활성</option>
                        <option value="false">비활성</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="editAdminLevel">권한</label>
                    <select id="editAdminLevel" name="adminLevel">
                        <option value="normal">일반관리자</option>
                        <option value="super">최고관리자</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="editNewPassword">새 비밀번호 (변경시에만 입력)</label>
                    <input type="password" id="editNewPassword" name="newPassword" placeholder="비밀번호를 변경하려면 입력하세요">
                </div>
                
                <div class="form-group">
                    <label for="editConfirmPassword">비밀번호 확인</label>
                    <input type="password" id="editConfirmPassword" name="confirmPassword" placeholder="새 비밀번호 확인">
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeAdminEditModal()">취소</button>
                    <button type="submit" class="btn btn-primary">저장</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // 햄버거 메뉴 토글
        function toggleHamburgerMenu() {
            const content = document.getElementById('hamburgerContent');
            content.classList.toggle('show');
        }
        
        // 햄버거 메뉴 외부 클릭시 닫기
        window.onclick = function(event) {
            const hamburgerContent = document.getElementById('hamburgerContent');
            
            if (!event.target.closest('.hamburger-menu') && hamburgerContent.classList.contains('show')) {
                hamburgerContent.classList.remove('show');
            }
            
            // 액션 메뉴 외부 클릭시 닫기
            if (!event.target.closest('.admin-actions')) {
                const actionMenus = document.querySelectorAll('.action-menu');
                actionMenus.forEach(menu => {
                    menu.classList.remove('show');
                });
            }
        }
        
        // 관리자 선택 함수
        function selectAdmin(adminId, name, email, isActive, adminLevel) {
            document.getElementById('editAdminId').value = adminId;
            document.getElementById('editAdminIdDisplay').value = adminId;
            document.getElementById('editName').value = name;
            document.getElementById('editEmail').value = email;
            document.getElementById('editStatus').value = isActive ? 'true' : 'false';
            document.getElementById('editAdminLevel').value = adminLevel;
            document.getElementById('editNewPassword').value = '';
            document.getElementById('editConfirmPassword').value = '';
            
            document.getElementById('adminEditModal').style.display = 'block';
        }
        
        // 관리자 편집 모달 닫기
        function closeAdminEditModal() {
            document.getElementById('adminEditModal').style.display = 'none';
            document.getElementById('adminEditForm').reset();
        }
        
        function changePassword(adminId) {
            // 최고 상위 관리자 권한 체크
            <% if (!isSuperAdmin) { %>
                alert('비밀번호 변경 권한이 없습니다. 최고 상위 관리자만 가능합니다.');
                return;
            <% } %>
            
            document.getElementById('targetAdminId').value = adminId;
            document.getElementById('passwordModal').style.display = 'block';
        }
        
        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
            document.getElementById('passwordForm').reset();
        }
        
        function grantSuperAdmin(adminId) {
            if (confirm('정말로 ' + adminId + '에게 최고관리자 권한을 부여하시겠습니까?')) {
                fetch('adminPermissionProcess.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'adminId=' + adminId + '&action=grant'
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('success')) {
                        alert('최고관리자 권한이 성공적으로 부여되었습니다.');
                        location.reload();
                    } else {
                        alert('권한 부여에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다.');
                });
            }
        }
        
        function removeSuperAdmin(adminId) {
            if (confirm('정말로 ' + adminId + '의 최고관리자 권한을 제거하시겠습니까?')) {
                fetch('adminPermissionProcess.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'adminId=' + adminId + '&action=remove'
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('success')) {
                        alert('최고관리자 권한이 성공적으로 제거되었습니다.');
                        location.reload();
                    } else {
                        alert('권한 제거에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다.');
                });
            }
        }
        
        function setStatus(adminId, isActive) {
            const action = isActive ? '활성화' : '비활성화';
            if (confirm('정말로 ' + action + '하시겠습니까?')) {
                fetch('adminStatusProcess.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'adminId=' + adminId + '&isActive=' + isActive
                })
                .then(response => response.text())
                .then(data => {
                    // 응답 데이터 정리 (공백, 개행 제거)
                    data = data.trim();
                    console.log('Status change response:', data);
                    
                    if (data === 'success') {
                        alert(action + '되었습니다.');
                        location.reload();
                    } else {
                        alert(action + '에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다.');
                });
            }
        }
        
        function deleteAdmin(adminId) {
            if (confirm('정말로 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                fetch('deleteAdminProcess.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'adminId=' + adminId
                })
                .then(response => response.text())
                .then(data => {
                    // 응답 데이터 정리 (공백, 개행 제거)
                    data = data.trim();
                    console.log('Delete response:', data);
                    
                    if (data === 'success') {
                        alert('삭제되었습니다.');
                        location.reload();
                    } else {
                        alert('삭제에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다.');
                });
            }
        }
        
        // 관리자 편집 폼 제출
        document.getElementById('adminEditForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const adminId = document.getElementById('editAdminId').value;
            const name = document.getElementById('editName').value;
            const email = document.getElementById('editEmail').value;
            const status = document.getElementById('editStatus').value;
            const adminLevel = document.getElementById('editAdminLevel').value;
            const newPassword = document.getElementById('editNewPassword').value;
            const confirmPassword = document.getElementById('editConfirmPassword').value;
            
            // 비밀번호 변경 시 확인
            if (newPassword && newPassword !== confirmPassword) {
                alert('비밀번호가 일치하지 않습니다.');
                return;
            }
            
            if (newPassword && newPassword.length < 6) {
                alert('비밀번호는 최소 6자 이상이어야 합니다.');
                return;
            }
            
            const params = new URLSearchParams();
            params.append('adminId', adminId);
            params.append('name', name);
            params.append('email', email);
            params.append('status', status);
            params.append('adminLevel', adminLevel);
            if (newPassword) {
                params.append('newPassword', newPassword);
            }
            
            fetch('editAdminProcess.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params
            })
            .then(response => response.text())
            .then(data => {
                data = data.trim();
                console.log('Admin edit response:', data);
                
                if (data === 'success') {
                    alert('관리자 정보가 수정되었습니다.');
                    closeAdminEditModal();
                    location.reload();
                } else {
                    alert('관리자 정보 수정에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            });
        });
        
        // 비밀번호 변경 폼 제출
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                alert('비밀번호가 일치하지 않습니다.');
                return;
            }
            
            if (newPassword.length < 6) {
                alert('비밀번호는 최소 6자 이상이어야 합니다.');
                return;
            }
            
            // FormData 대신 URLSearchParams 사용
            const params = new URLSearchParams();
            params.append('adminId', document.getElementById('targetAdminId').value);
            params.append('newPassword', newPassword);
            
            // 디버깅 정보 출력
            console.log('Password change form data:');
            console.log('adminId: ' + document.getElementById('targetAdminId').value);
            console.log('newPassword: ***');
            
            fetch('changePasswordProcess.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params
            })
            .then(response => response.text())
            .then(data => {
                // 응답 데이터 정리 (공백, 개행 제거)
                data = data.trim();
                console.log('Password change response:', data);
                
                if (data === 'success') {
                    alert('비밀번호가 변경되었습니다.');
                    closePasswordModal();
                } else {
                    alert('비밀번호 변경에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('오류가 발생했습니다.');
            });
        });
        
        // 모달 외부 클릭시 닫기
        window.onclick = function(event) {
            const modal = document.getElementById('passwordModal');
            if (event.target == modal) {
                closePasswordModal();
            }
        }
    </script>
</body>
</html>
