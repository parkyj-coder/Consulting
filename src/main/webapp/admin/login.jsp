<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 로그인 - 한국미래 중소기업 경영컨설팅</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 40px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-header h1 {
            color: #3182ce;
            margin: 0 0 10px 0;
            font-size: 1.8rem;
        }
        
        .login-header p {
            color: #718096;
            margin: 0;
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
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #3182ce;
        }
        
        .login-btn {
            width: 100%;
            padding: 12px;
            background: #3182ce;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .login-btn:hover {
            background: #2c5aa0;
        }
        
        .error-message {
            background: #fed7d7;
            color: #c53030;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
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
        
        @media (max-width: 480px) {
            .login-container {
                margin: 50px 20px;
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>관리자 로그인</h1>
            <p>관리자 권한이 필요합니다</p>
        </div>
        
        <% 
            String error = request.getParameter("error");
            if (error != null) {
                String errorMessage = "";
                switch (error) {
                    case "1":
                        errorMessage = "아이디 또는 비밀번호가 올바르지 않습니다.";
                        break;
                    case "2":
                        errorMessage = "아이디와 비밀번호를 모두 입력해주세요.";
                        break;
                    case "3":
                        errorMessage = "시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
                        break;
                    default:
                        errorMessage = "로그인 중 오류가 발생했습니다.";
                }
        %>
            <div class="error-message">
                <%= errorMessage %>
            </div>
        <% } %>
        
        <form action="loginProcess.jsp" method="post">
            <div class="form-group">
                <label for="adminId">관리자 ID</label>
                <input type="text" id="adminId" name="adminId" required>
            </div>
            
            <div class="form-group">
                <label for="adminPassword">비밀번호</label>
                <input type="password" id="adminPassword" name="adminPassword" required>
            </div>
            
            <button type="submit" class="login-btn">로그인</button>
        </form>
        
        <div class="back-link">
            <a href="../index.html">← 메인 페이지로 돌아가기</a>
        </div>
    </div>
    
    <script>
        // 폼 제출 시 로딩 상태 표시
        document.querySelector('form').addEventListener('submit', function() {
            const btn = document.querySelector('.login-btn');
            btn.textContent = '로그인 중...';
            btn.disabled = true;
        });
        
        // 엔터키로 폼 제출
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                document.querySelector('form').submit();
            }
        });
    </script>
</body>
</html>
