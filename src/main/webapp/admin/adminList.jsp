<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Admin" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    Boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");
    
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 최고 관리자 권한 체크
    if (isSuperAdmin == null || !isSuperAdmin) {
        response.sendRedirect("consultationList.jsp?error=permission");
        return;
    }
    
    AdminDAO adminDAO = new AdminDAO();
    List<Admin> admins = adminDAO.getAllAdmins();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    
    // 메시지 처리
    String message = "";
    String messageType = "";
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    
    if (success != null) {
        switch (success) {
            case "add":
                message = "관리자가 성공적으로 추가되었습니다.";
                messageType = "success";
                break;
            case "edit":
                message = "관리자 정보가 성공적으로 수정되었습니다.";
                messageType = "success";
                break;
            case "delete":
                message = "관리자가 성공적으로 삭제되었습니다.";
                messageType = "success";
                break;
            case "toggleStatus":
                message = "관리자 상태가 성공적으로 변경되었습니다.";
                messageType = "success";
                break;
        }
    }
    
    if (error != null) {
        switch (error) {
            case "add":
                message = "관리자 추가에 실패했습니다.";
                messageType = "error";
                break;
            case "edit":
                message = "관리자 수정에 실패했습니다.";
                messageType = "error";
                break;
            case "delete":
                message = "관리자 삭제에 실패했습니다.";
                messageType = "error";
                break;
            case "toggleStatus":
                message = "관리자 상태 변경에 실패했습니다.";
                messageType = "error";
                break;
            case "duplicate":
                message = "이미 존재하는 사용자명입니다.";
                messageType = "error";
                break;
            case "exception":
                message = "오류가 발생했습니다.";
                messageType = "error";
                break;
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 관리 - 한국미래 중소기업 경영컨설팅</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f7fafc;
            color: #2d3748;
            line-height: 1.6;
        }
        
        .admin-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .admin-navigation {
            display: flex;
            gap: 8px;
            margin-bottom: 15px;
            flex-wrap: nowrap;
            overflow-x: auto;
        }
        
        .nav-button {
            padding: 6px 10px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.7rem;
            white-space: nowrap;
            transition: background 0.3s;
            flex-shrink: 0;
        }
        
        .nav-button:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        
        .nav-button i {
            margin-right: 5px;
            font-size: 0.8rem;
        }
        
        .admin-header h1 {
            margin: 10px 0 5px 0;
            font-size: 2rem;
        }
        
        .admin-header p {
            opacity: 0.9;
            margin: 0;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: white;
            color: #3182ce;
        }
        
        .btn-primary:hover {
            background: #f7fafc;
        }
        
        .btn-secondary {
            background: #2c5aa0;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #2647a0;
        }
        
        .btn-success {
            background: #48bb78;
            color: white;
        }
        
        .btn-success:hover {
            background: #38a169;
        }
        
        .btn-danger {
            background: #f56565;
            color: white;
        }
        
        .btn-danger:hover {
            background: #e53e3e;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.85rem;
        }
        
        .btn-warning {
            background: #ed8936;
            color: white;
        }
        
        .btn-warning:hover {
            background: #dd6b20;
        }
        
        /* 검색 필터 스타일 */
        .compact-filter {
            display: block;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #e2e8f0;
        }
        
        .compact-filter-row {
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: nowrap;
        }
        
        .compact-search {
            flex: 1;
            min-width: 200px;
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 0.875rem;
            background: white;
        }
        
        .compact-select {
            min-width: 100px;
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 0.875rem;
            background: white;
        }
        
        .compact-buttons {
            display: flex;
            gap: 8px;
        }
        
        .compact-buttons .btn {
            padding: 8px 16px;
            font-size: 0.875rem;
            border-radius: 6px;
            min-width: 60px;
        }
        
        .btn-filter {
            background: #667eea;
            color: white;
        }
        
        .btn-filter:hover {
            background: #5a67d8;
        }
        
        .btn-reset {
            background: #718096;
            color: white;
        }
        
        .btn-reset:hover {
            background: #4a5568;
        }
        
        /* 결과 정보 */
        .results-info {
            padding: 10px 15px;
            background: #edf2f7;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 0.9rem;
            color: #4a5568;
        }
        
        .results-info strong {
            color: #667eea;
            font-size: 1.1rem;
        }
        
        .admin-table-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow-x: auto;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        .admin-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .admin-table thead {
            background: #f7fafc;
        }
        
        .admin-table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #2d3748;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .admin-table td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .admin-table tbody tr:hover {
            background: #f7fafc;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .status-active {
            background: #c6f6d5;
            color: #22543d;
        }
        
        .status-inactive {
            background: #fed7d7;
            color: #742a2a;
        }
        
        .role-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .role-super {
            background: #feebc8;
            color: #7c2d12;
        }
        
        .role-admin {
            background: #bee3f8;
            color: #2c5282;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        
        .modal-header {
            margin-bottom: 20px;
        }
        
        .modal-header h2 {
            margin: 0;
            color: #2d3748;
        }
        
        .close {
            float: right;
            font-size: 28px;
            font-weight: bold;
            color: #a0aec0;
            cursor: pointer;
        }
        
        .close:hover {
            color: #2d3748;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2d3748;
            font-weight: 500;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 1rem;
            box-sizing: border-box;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #3182ce;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 30px;
        }
        
        .message {
            padding: 15px;
            margin: 20px 0;
            border-radius: 6px;
            font-weight: 500;
        }
        
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        @media (max-width: 768px) {
            .admin-navigation {
                gap: 3px;
            }
            
            .nav-button {
                padding: 5px 8px;
                font-size: 0.65rem;
            }
            
            .compact-filter {
                padding: 10px;
                margin-bottom: 15px;
            }
            
            .compact-filter-row {
                display: flex;
                flex-direction: row;
                gap: 8px;
                align-items: center;
                flex-wrap: wrap;
            }
            
            .compact-search {
                flex: 1 1 100%;
                min-width: 0;
                padding: 8px 12px;
                font-size: 0.85rem;
                margin-bottom: 8px;
            }
            
            .compact-select {
                flex: 1;
                min-width: 70px;
                padding: 8px 10px;
                font-size: 0.8rem;
            }
            
            .compact-buttons {
                display: flex;
                gap: 6px;
            }
            
            .compact-buttons .btn {
                padding: 8px 12px;
                font-size: 0.8rem;
                min-width: 55px;
            }
            
            .admin-table {
                font-size: 0.85rem;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 10px;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 4px;
            }
            
            .btn-sm {
                padding: 5px 10px;
                font-size: 0.75rem;
            }
        }
        
        @media (max-width: 480px) {
            .admin-navigation {
                gap: 3px;
            }
            
            .nav-button {
                padding: 4px 6px;
                font-size: 0.6rem;
            }
            
            .compact-filter-row {
                gap: 6px;
            }
            
            .compact-search {
                flex: 1 1 100%;
                padding: 6px 10px;
                font-size: 0.8rem;
                margin-bottom: 6px;
            }
            
            .compact-select {
                flex: 1;
                min-width: 65px;
                padding: 6px 8px;
                font-size: 0.75rem;
            }
            
            .compact-buttons {
                gap: 4px;
            }
            
            .compact-buttons .btn {
                padding: 6px 10px;
                font-size: 0.75rem;
                min-width: 50px;
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
                <a href="javascript:history.back()" class="nav-button">
                    <i>←</i>이전 페이지
                </a>
                <a href="consultationList.jsp" class="nav-button">
                    <i>📋</i>상담 목록
                </a>
                <a href="logout.jsp" class="nav-button">
                    <i>🚪</i>로그아웃
                </a>
            </div>
            <h1>관리자 관리</h1>
            <p>관리자 계정을 관리할 수 있습니다.</p>
        </div>
        
        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        
        <!-- 검색 필터 -->
        <div class="compact-filter">
            <div class="compact-filter-row">
                <input type="text" id="compactSearchInput" class="compact-search" placeholder="사용자명, 이름, 이메일로 검색...">
                <select id="compactStatusFilter" class="compact-select">
                    <option value="">전체 상태</option>
                    <option value="active">활성</option>
                    <option value="inactive">비활성</option>
                </select>
                <select id="compactRoleFilter" class="compact-select">
                    <option value="">전체 권한</option>
                    <option value="super">최고 관리자</option>
                    <option value="admin">일반 관리자</option>
                </select>
                <div class="compact-buttons">
                    <% if (isSuperAdmin) { %>
                        <button class="btn btn-secondary" onclick="openAddModal()">+ 추가</button>
                    <% } %>
                    <button class="btn btn-filter" onclick="applyFilters()">검색</button>
                    <button class="btn btn-reset" onclick="resetFilters()">초기화</button>
                </div>
            </div>
        </div>
        
        <!-- 결과 정보 표시 -->
        <div id="resultsInfo" class="results-info" style="display: block;">
            <strong id="resultsCount">0</strong>개의 결과가 표시됩니다.
        </div>
        
        <div class="admin-table-container">
            <div class="table-container">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>사용자명</th>
                        <th>이름</th>
                        <th>이메일</th>
                        <th>권한</th>
                        <th>상태</th>
                        <th>작업</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Admin admin : admins) { %>
                    <tr>
                        <td><%= admin.getId() %></td>
                        <td><strong><%= admin.getUsername() %></strong></td>
                        <td><%= admin.getName() %></td>
                        <td><%= admin.getEmail() != null ? admin.getEmail() : "-" %></td>
                        <td>
                            <span class="role-badge <%= admin.isSuperAdmin() ? "role-super" : "role-admin" %>">
                                <%= admin.isSuperAdmin() ? "최고 관리자" : "일반 관리자" %>
                            </span>
                        </td>
                        <td>
                            <span class="status-badge <%= admin.isActive() ? "status-active" : "status-inactive" %>">
                                <%= admin.isActive() ? "활성" : "비활성" %>
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <% if (isSuperAdmin) { %>
                                    <button onclick="openEditModal(<%= admin.getId() %>, '<%= admin.getUsername() %>', '<%= admin.getName() %>', '<%= admin.getEmail() != null ? admin.getEmail() : "" %>', '<%= admin.getRole() %>', <%= admin.isActive() %>)" class="btn btn-sm btn-primary">수정</button>
                                    <% if (admin.isActive()) { %>
                                        <button onclick="toggleStatus(<%= admin.getId() %>, '<%= admin.getName() %>', false)" class="btn btn-sm btn-warning">비활성화</button>
                                    <% } else { %>
                                        <button onclick="toggleStatus(<%= admin.getId() %>, '<%= admin.getName() %>', true)" class="btn btn-sm btn-success">활성화</button>
                                    <% } %>
                                    <% if (!admin.getUsername().equals(session.getAttribute("adminUsername"))) { %>
                                    <button onclick="deleteAdmin(<%= admin.getId() %>, '<%= admin.getName() %>')" class="btn btn-sm btn-danger">삭제</button>
                                    <% } %>
                                <% } else { %>
                                    <span style="color: #718096; font-size: 0.85rem;">조회만 가능</span>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            </div>
        </div>
    
    <!-- 관리자 추가 모달 -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <span class="close" onclick="closeAddModal()">&times;</span>
                <h2>관리자 추가</h2>
            </div>
            <form id="addAdminForm" action="adminProcess.jsp" method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="username">사용자명 *</label>
                    <input type="text" id="username" name="username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">비밀번호 *</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div class="form-group">
                    <label for="name">이름 *</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email">
                </div>
                
                <div class="form-group">
                    <label for="role">권한 *</label>
                    <select id="role" name="role" required>
                        <option value="normal">일반 관리자</option>
                        <option value="super">최고 관리자</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="button" onclick="closeAddModal()" class="btn btn-secondary">취소</button>
                    <button type="submit" class="btn btn-success">추가</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- 관리자 수정 모달 -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <span class="close" onclick="closeEditModal()">&times;</span>
                <h2>관리자 수정</h2>
            </div>
            <form id="editAdminForm" action="adminProcess.jsp" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" id="editAdminId" name="adminId">
                
                <div class="form-group">
                    <label>사용자명</label>
                    <input type="text" id="editUsername" disabled>
                </div>
                
                <div class="form-group">
                    <label for="editName">이름 *</label>
                    <input type="text" id="editName" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="editEmail">이메일</label>
                    <input type="email" id="editEmail" name="email">
                </div>
                
                <div class="form-group">
                    <label for="editRole">권한 *</label>
                    <select id="editRole" name="role" required>
                        <option value="normal">일반 관리자</option>
                        <option value="super">최고 관리자</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="editActive">상태 *</label>
                    <select id="editActive" name="isActive" required>
                        <option value="true">활성</option>
                        <option value="false">비활성</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="button" onclick="closeEditModal()" class="btn btn-secondary">취소</button>
                    <button type="submit" class="btn btn-success">수정</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // ===== 검색 및 필터링 기능 =====
        function applyFilters() {
            const searchTerm = document.getElementById('compactSearchInput').value.toLowerCase();
            const statusFilter = document.getElementById('compactStatusFilter').value;
            const roleFilter = document.getElementById('compactRoleFilter').value;
            
            const rows = document.querySelectorAll('.admin-table tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const username = row.cells[1].textContent.toLowerCase();
                const name = row.cells[2].textContent.toLowerCase();
                const email = row.cells[3].textContent.toLowerCase();
                const roleText = row.cells[4].textContent.trim();
                const statusBadge = row.cells[5].querySelector('.status-badge');
                const statusText = statusBadge ? statusBadge.textContent.trim() : '';
                
                // 검색 조건 확인
                const matchesSearch = searchTerm === '' || 
                    username.includes(searchTerm) || 
                    name.includes(searchTerm) || 
                    email.includes(searchTerm);
                
                // 상태 필터 확인
                const matchesStatus = statusFilter === '' || 
                    (statusFilter === 'active' && statusText === '활성') ||
                    (statusFilter === 'inactive' && statusText === '비활성');
                
                // 권한 필터 확인
                const matchesRole = roleFilter === '' || 
                    (roleFilter === 'super' && roleText === '최고 관리자') ||
                    (roleFilter === 'admin' && roleText === '일반 관리자');
                
                if (matchesSearch && matchesStatus && matchesRole) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            updateResultsInfo(visibleCount);
        }
        
        function resetFilters() {
            document.getElementById('compactSearchInput').value = '';
            document.getElementById('compactStatusFilter').value = '';
            document.getElementById('compactRoleFilter').value = '';
            
            const rows = document.querySelectorAll('.admin-table tbody tr');
            rows.forEach(row => {
                row.style.display = '';
            });
            
            updateResultsInfo(rows.length);
        }
        
        function updateResultsInfo(count) {
            const resultsInfo = document.getElementById('resultsInfo');
            const resultsCount = document.getElementById('resultsCount');
            
            if (resultsCount) {
                resultsCount.textContent = count;
            }
            
            if (resultsInfo) {
                if (count === 0) {
                    resultsInfo.style.display = 'none';
                } else {
                    resultsInfo.style.display = 'block';
                }
            }
        }
        
        // 디바운스 함수
        function debounce(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }
        
        // 검색 입력 시 실시간 필터링
        document.addEventListener('DOMContentLoaded', function() {
            const compactSearchInput = document.getElementById('compactSearchInput');
            const compactStatusFilter = document.getElementById('compactStatusFilter');
            const compactRoleFilter = document.getElementById('compactRoleFilter');
            
            if (compactSearchInput) {
                const debouncedApplyFilters = debounce(applyFilters, 300);
                compactSearchInput.addEventListener('input', debouncedApplyFilters);
                compactSearchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        applyFilters();
                    }
                });
            }
            
            if (compactStatusFilter) {
                compactStatusFilter.addEventListener('change', applyFilters);
            }
            
            if (compactRoleFilter) {
                compactRoleFilter.addEventListener('change', applyFilters);
            }
            
            // 초기 결과 정보 표시
            setTimeout(function() {
                const rows = document.querySelectorAll('.admin-table tbody tr');
                updateResultsInfo(rows.length);
            }, 100);
        });
        
        // ===== 모달 및 CRUD 기능 =====
        function openAddModal() {
            document.getElementById('addModal').style.display = 'block';
        }
        
        function closeAddModal() {
            document.getElementById('addModal').style.display = 'none';
            document.getElementById('addAdminForm').reset();
        }
        
        function openEditModal(id, username, name, email, role, isActive) {
            document.getElementById('editAdminId').value = id;
            document.getElementById('editUsername').value = username;
            document.getElementById('editName').value = name;
            document.getElementById('editEmail').value = email;
            document.getElementById('editRole').value = role;
            document.getElementById('editActive').value = isActive;
            
            document.getElementById('editModal').style.display = 'block';
        }
        
        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }
        
        function deleteAdmin(id, name) {
            if (confirm(name + ' 관리자를 완전히 삭제하시겠습니까?\n\n※ 삭제된 데이터는 복구할 수 없습니다.')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'adminProcess.jsp';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'adminId';
                idInput.value = id;
                form.appendChild(idInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function toggleStatus(id, name, isActive) {
            const status = isActive ? '활성화' : '비활성화';
            if (confirm(name + ' 관리자를 ' + status + '하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'adminProcess.jsp';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'toggleStatus';
                form.appendChild(actionInput);
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'adminId';
                idInput.value = id;
                form.appendChild(idInput);
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'isActive';
                statusInput.value = isActive;
                form.appendChild(statusInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            const addModal = document.getElementById('addModal');
            const editModal = document.getElementById('editModal');
            
            if (event.target == addModal) {
                closeAddModal();
            }
            if (event.target == editModal) {
                closeEditModal();
            }
        }
    </script>
</body>
</html>

