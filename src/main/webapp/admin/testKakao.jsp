<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="service.KakaoNotificationService" %>
<%
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String result = "";
    if (request.getMethod().equals("POST")) {
        String testMessage = request.getParameter("testMessage");
        if (testMessage != null && !testMessage.trim().isEmpty()) {
            boolean success = KakaoNotificationService.sendSimpleMessage(testMessage);
            result = success ? "알림 전송 성공!" : "알림 전송 실패!";
        } else {
            // 테스트 상담신청 알림 (DB 기반으로 변경)
            int sentCount = KakaoNotificationService.sendConsultationNotificationToAllAdmins(
                "테스트 기업", "홍길동", "010-1234-5678"
            );
            result = sentCount > 0 ? "테스트 알림 전송 성공! (" + sentCount + "명에게 전송)" : "테스트 알림 전송 실패!";
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카카오톡 알림 테스트 - 더문D&C그룹</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .test-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .test-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .test-header h1 {
            color: #3182ce;
            margin-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #2d3748;
        }
        
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 1rem;
            resize: vertical;
            min-height: 100px;
            box-sizing: border-box;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        
        .btn-primary {
            background: #3182ce;
            color: white;
        }
        
        .btn-success {
            background: #38a169;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
        
        .result {
            margin-top: 20px;
            padding: 15px;
            border-radius: 6px;
            text-align: center;
            font-weight: 500;
        }
        
        .result.success {
            background: #c6f6d5;
            color: #2f855a;
        }
        
        .result.error {
            background: #fed7d7;
            color: #c53030;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #3182ce;
            text-decoration: none;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="test-header">
            <h1>카카오톡 알림 테스트</h1>
            <p>상담신청 알림 기능을 테스트할 수 있습니다.</p>
        </div>
        
        <% if (!result.isEmpty()) { %>
            <div class="result <%= result.contains("성공") ? "success" : "error" %>">
                <%= result %>
            </div>
        <% } %>
        
        <form method="post">
            <div class="form-group">
                <label for="testMessage">테스트 메시지 (선택사항)</label>
                <textarea id="testMessage" name="testMessage" placeholder="전송할 메시지를 입력하세요. 비워두면 기본 상담신청 알림이 전송됩니다."></textarea>
            </div>
            
            <div style="text-align: center;">
                <button type="submit" class="btn btn-primary">테스트 알림 전송</button>
                <button type="submit" class="btn btn-success" onclick="document.getElementById('testMessage').value=''; return true;">기본 알림 전송</button>
            </div>
        </form>
        
        <div class="back-link">
            <a href="consultationList.jsp">← 상담관리로 돌아가기</a>
        </div>
    </div>
</body>
</html>
