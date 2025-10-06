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
    
    AdminDAO adminDAO = new AdminDAO();
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
        }
        
        .nav-button {
            display: inline-block;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 10px;
            transition: background-color 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .nav-button:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            text-decoration: none;
        }
        
        .nav-button i {
            margin-right: 5px;
        }
        
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
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
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.875rem;
            margin: 2px;
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
        
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 4px;
            font-size: 0.875rem;
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
            .form-row {
                flex-direction: column;
            }
            
            .admin-table {
                font-size: 0.875rem;
            }
            
            .admin-table th,
            .admin-table td {
                padding: 8px;
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
                <a href="consultationList.jsp" class="nav-button">
                    <i>←</i>상담관리
                </a>
                <a href="logout.jsp" class="nav-button" style="background: rgba(229, 62, 62, 0.8);">
                    <i>🚪</i>로그아웃
                </a>
            </div>
            <h1>관리자 계정 관리</h1>
            <p>시스템 관리자 계정을 관리할 수 있습니다.</p>
        </div>
        
        <!-- 새 관리자 추가 섹션 -->
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
        
        <!-- 관리자 목록 -->
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>관리자 ID</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>상태</th>
                    <th>생성일</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <% if (admins.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 40px; color: #718096;">
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
                            <td><%= admin.getCreatedAt() %></td>
                            <td>
                                <button class="btn btn-warning" onclick="changePassword('<%= admin.getAdminId() %>')">비밀번호 변경</button>
                                <% if (admin.isActive()) { %>
                                    <button class="btn btn-danger" onclick="setStatus('<%= admin.getAdminId() %>', false)">비활성화</button>
                                <% } else { %>
                                    <button class="btn btn-success" onclick="setStatus('<%= admin.getAdminId() %>', true)">활성화</button>
                                <% } %>
                                <% if (!admin.getAdminId().equals(session.getAttribute("adminId"))) { %>
                                    <button class="btn btn-danger" onclick="deleteAdmin('<%= admin.getAdminId() %>')">삭제</button>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>
    </div>
    
    <!-- 비밀번호 변경 모달 -->
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
    
    <script>
        function changePassword(adminId) {
            document.getElementById('targetAdminId').value = adminId;
            document.getElementById('passwordModal').style.display = 'block';
        }
        
        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
            document.getElementById('passwordForm').reset();
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
            
            const formData = new FormData(this);
            
            fetch('changePasswordProcess.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
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
