<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>서버 오류 - Consulting</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .error-box { text-align: center; padding: 4rem 2rem; min-height: 60vh; display: flex; flex-direction: column; justify-content: center; }
        .error-code { font-size: 4rem; color: #c53030; font-weight: 700; margin-bottom: 1rem; }
        .error-msg { font-size: 1.25rem; color: #555; margin-bottom: 2rem; }
        .error-box a { color: #3182ce; text-decoration: none; font-weight: 500; }
        .error-box a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-box">
            <div class="error-code">500</div>
            <p class="error-msg">일시적인 서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.</p>
            <a href="${pageContext.request.contextPath}/">홈으로 돌아가기</a>
        </div>
    </div>
</body>
</html>
