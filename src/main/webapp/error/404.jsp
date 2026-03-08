<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>페이지를 찾을 수 없습니다 - Consulting</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .error-box { text-align: center; padding: 4rem 2rem; min-height: 60vh; display: flex; flex-direction: column; justify-content: center; }
        .error-code { font-size: 4rem; color: #3182ce; font-weight: 700; margin-bottom: 1rem; }
        .error-msg { font-size: 1.25rem; color: #555; margin-bottom: 2rem; }
        .error-box a { color: #3182ce; text-decoration: none; font-weight: 500; }
        .error-box a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-box">
            <div class="error-code">404</div>
            <p class="error-msg">요청하신 페이지를 찾을 수 없습니다.</p>
            <a href="${pageContext.request.contextPath}/">홈으로 돌아가기</a>
        </div>
    </div>
</body>
</html>
