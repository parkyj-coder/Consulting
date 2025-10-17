<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ page import="dao.ConsultationDAO" %>
<%@ page import="model.ConsultationRequest" %>
<%@ page import="java.util.List" %>
<%
    // 관리자 인증 체크
    String adminLoggedIn = (String) session.getAttribute("adminLoggedIn");
    if (adminLoggedIn == null || !adminLoggedIn.equals("true")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ConsultationDAO dao = new ConsultationDAO();
    List<ConsultationRequest> consultations = dao.getAllConsultations();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상담신청 관리 - 한국미래 중소기업 경영컨설팅</title>
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
        
        .table-container {
            overflow-x: auto;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .consultation-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            min-width: 800px;
        }
        
        .consultation-table th,
        .consultation-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .consultation-table th {
            background: #f7fafc;
            font-weight: 600;
            color: #2d3748;
        }
        
        .consultation-table tr:hover {
            background: #f7fafc;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .status-waiting {
            background: #fed7d7;
            color: #c53030;
        }
        
        .status-processing {
            background: #bee3f8;
            color: #2b6cb0;
        }
        
        .status-completed {
            background: #c6f6d5;
            color: #2f855a;
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
        
        .btn:hover {
            opacity: 0.8;
        }
        
        .btn-group {
            display: flex;
            flex-wrap: wrap;
            gap: 2px;
        }
        
        
        .results-info {
            margin-top: 10px;
            padding: 10px;
            background: #e6fffa;
            border: 1px solid #38b2ac;
            border-radius: 6px;
            color: #234e52;
            font-size: 0.875rem;
        }
        
        
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
        }
        
        .compact-select {
            min-width: 120px;
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
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .compact-buttons .btn-filter {
            background: #3182ce;
            color: white;
        }
        
        .compact-buttons .btn-filter:hover {
            background: #2c5aa0;
        }
        
        .compact-buttons .btn-reset {
            background: #718096;
            color: white;
        }
        
        .compact-buttons .btn-reset:hover {
            background: #4a5568;
        }
        
        .detail-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .detail-content {
            background-color: white;
            margin: 5% auto;
            padding: 20px;
            border-radius: 8px;
            width: 80%;
            max-width: 800px;
            max-height: 80vh;
            overflow-y: auto;
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
        
        .detail-section {
            margin-bottom: 20px;
            padding: 15px;
            background: #f7fafc;
            border-radius: 6px;
        }
        
        .detail-section h3 {
            margin: 0 0 10px 0;
            color: #2d3748;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 8px;
        }
        
        .detail-label {
            font-weight: 600;
            width: 120px;
            color: #4a5568;
        }
        
        .detail-value {
            flex: 1;
            color: #2d3748;
        }
        
        .detail-actions {
            margin-top: 30px;
            padding: 20px;
            background: #fff5f5;
            border-radius: 8px;
            border-left: 4px solid #e53e3e;
        }
        
        .detail-actions h3 {
            color: #e53e3e;
            margin-bottom: 15px;
            font-size: 1.1rem;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .action-buttons .btn {
            padding: 10px 20px;
            font-size: 0.9rem;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .action-buttons .btn-success {
            background: #38a169;
            color: white;
        }
        
        .action-buttons .btn-success:hover {
            background: #2f855a;
        }
        
        .action-buttons .btn-danger {
            background: #e53e3e;
            color: white;
        }
        
        .action-buttons .btn-danger:hover {
            background: #c53030;
        }
        
        .status-completed {
            padding: 10px 20px;
            background: #68d391;
            color: white;
            border-radius: 6px;
            font-weight: 500;
        }
        
        @media (max-width: 768px) {
            .admin-container {
                padding: 10px;
            }
            
            .admin-header {
                padding: 15px;
                margin-bottom: 20px;
            }
            
            .admin-header h1 {
                font-size: 1.5rem;
                margin-bottom: 8px;
            }
            
            .admin-navigation {
                margin-bottom: 10px;
                display: flex;
                flex-wrap: nowrap;
                gap: 4px;
                overflow-x: auto;
            }
            
            .nav-button {
                padding: 5px 8px;
                font-size: 0.65rem;
                margin: 0;
                white-space: nowrap;
                flex-shrink: 0;
                min-width: auto;
            }
            
            .nav-button i {
                margin-right: 2px;
                font-size: 0.8rem;
            }
            
            .table-container {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                background: white;
                margin: 0;
                padding: 0;
            }
            
            .consultation-table {
                font-size: 0.8rem; /* 글자 크기 증가 */
                display: table;
                width: 100%;
                min-width: 800px; /* 최소 너비 조정 */
                border-collapse: collapse;
                background: white;
                table-layout: fixed; /* 고정 레이아웃으로 컬럼 너비 제어 */
            }
            
            .consultation-table {
                display: table !important;
            }
            
            .consultation-table thead {
                display: table-header-group !important;
            }
            
            .consultation-table tbody {
                display: table-row-group !important;
            }
            
            .consultation-table tr {
                display: table-row !important;
            }
            
            .consultation-table th,
            .consultation-table td {
                display: table-cell !important;
                padding: 8px 4px !important;
                border: 1px solid #e2e8f0 !important;
                vertical-align: middle !important;
                white-space: nowrap !important;
                overflow: hidden !important;
                text-overflow: ellipsis !important;
            }
            
            /* 관리 컬럼의 버튼들은 줄바꿈 허용 */
            .consultation-table td:nth-child(8) {
                white-space: normal !important;
                overflow: visible !important;
                text-overflow: unset !important;
            }
            
            .consultation-table th {
                background: #f8f9fa;
                font-weight: 600;
                color: #4a5568;
            }
            
            /* 컬럼 너비 설정 - 모바일 최적화 */
            .consultation-table th:nth-child(1),
            .consultation-table td:nth-child(1) { width: 60px; } /* ID */
            .consultation-table th:nth-child(2),
            .consultation-table td:nth-child(2) { width: 100px; } /* 기업명 */
            .consultation-table th:nth-child(3),
            .consultation-table td:nth-child(3) { width: 80px; } /* 신청자 */
            .consultation-table th:nth-child(4),
            .consultation-table td:nth-child(4) { width: 120px; } /* 연락처 */
            .consultation-table th:nth-child(5),
            .consultation-table td:nth-child(5) { width: 80px; } /* 업종 */
            .consultation-table th:nth-child(6),
            .consultation-table td:nth-child(6) { width: 70px; } /* 상태 */
            .consultation-table th:nth-child(7),
            .consultation-table td:nth-child(7) { width: 100px; } /* 신청일 */
            .consultation-table th:nth-child(8),
            .consultation-table td:nth-child(8) { width: 80px; } /* 관리 - 상세보기 버튼만 */
            
            .btn-group {
                display: flex;
                flex-wrap: nowrap; /* 버튼들이 가로로 한 줄에 배치 */
                gap: 2px;
                justify-content: flex-start;
                align-items: center;
            }
            
            .btn {
                padding: 4px 6px;
                font-size: 0.65rem;
                margin: 0;
                min-width: 45px;
                white-space: nowrap;
                flex-shrink: 0; /* 버튼이 줄어들지 않도록 */
                display: inline-block;
            }
            
            .compact-filter {
                padding: 10px;
                margin-bottom: 15px;
            }
            
            .compact-filter-row {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            
            .compact-search {
                width: 100%;
                padding: 8px 12px;
                font-size: 0.85rem;
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                margin-bottom: 0;
            }
            
            .filter-row {
                display: flex;
                gap: 6px;
                align-items: center;
                flex-wrap: wrap;
            }
            
            .compact-select {
                flex: 1;
                min-width: 70px;
                padding: 8px 10px;
                font-size: 0.8rem;
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                background: white;
            }
            
            .compact-buttons {
                display: flex;
                gap: 4px;
                flex-wrap: wrap;
                margin-top: 5px;
            }
            
            .compact-buttons .btn {
                flex: 1;
                min-width: 0;
                padding: 8px 10px;
                font-size: 0.75rem;
                border-radius: 6px;
                text-align: center;
            }
            
            .detail-content {
                width: 95%;
                margin: 5% auto;
                max-height: 90vh;
                overflow-y: auto;
            }
        }
        
        @media (max-width: 480px) {
            .admin-navigation {
                gap: 3px;
            }
            
            .nav-button {
                padding: 4px 6px;
                font-size: 0.6rem;
                margin: 0;
            }
            
            .nav-button i {
                font-size: 0.7rem;
            }
            
            .btn-group {
                gap: 1px;
                flex-wrap: nowrap;
            }
            
            .btn {
                padding: 3px 4px;
                font-size: 0.6rem;
                margin: 0;
                min-width: 40px;
                white-space: nowrap;
                flex-shrink: 0;
            }
            
            .consultation-table {
                min-width: 800px; /* 작은 화면에서도 충분한 너비 */
                font-size: 0.75rem;
            }
            
            .consultation-table td {
                padding: 6px 4px;
                font-size: 0.75rem;
            }
            
            /* 작은 화면에서 컬럼 너비 재조정 */
            .consultation-table th:nth-child(8),
            .consultation-table td:nth-child(8) { width: 70px; } /* 관리 컬럼 - 상세보기 버튼만 */
            
            .compact-filter-row {
                gap: 6px;
            }
            
            .compact-search {
                width: 100%;
                padding: 6px 10px;
                font-size: 0.8rem;
                margin-bottom: 0;
            }
            
            .filter-row {
                gap: 4px;
            }
            
            .compact-select {
                flex: 1;
                min-width: 65px;
                padding: 6px 8px;
                font-size: 0.75rem;
            }
            
            .compact-buttons {
                gap: 3px;
                margin-top: 4px;
            }
            
            .compact-buttons .btn {
                flex: 1;
                min-width: 0;
                padding: 6px 8px;
                font-size: 0.7rem;
                text-align: center;
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
                <% 
                    Boolean isSuperAdmin = (Boolean) session.getAttribute("isSuperAdmin");
                    if (isSuperAdmin != null && isSuperAdmin) {
                %>
                <a href="adminList.jsp" class="nav-button" style="background: rgba(56, 161, 105, 0.8);">
                    <i>👥</i>관리자 관리
                </a>
                <% } %>
                <a href="logout.jsp" class="nav-button" style="background: rgba(229, 62, 62, 0.8);">
                    <i>🚪</i>로그아웃
                </a>
            </div>
            <h1>상담신청 관리</h1>
            <p>자금상담신청서 목록을 관리할 수 있습니다.</p>
        </div>
        
        <!-- 간소화된 필터 -->
        <div class="compact-filter">
            <div class="compact-filter-row">
                <input type="text" id="compactSearchInput" class="compact-search" placeholder="기업명, 신청자명, 연락처로 검색...">
                <div class="filter-row">
                    <select id="compactStatusFilter" class="compact-select">
                        <option value="">전체 상태</option>
                        <option value="pending">대기중</option>
                        <option value="processing">진행중</option>
                        <option value="completed">완료</option>
                    </select>
                    <select id="compactSortBy" class="compact-select">
                        <option value="created_at_desc">최신순</option>
                        <option value="created_at_asc">오래된순</option>
                        <option value="company_name_asc">기업명순</option>
                        <option value="status_asc">상태순</option>
                    </select>
                </div>
                <div class="compact-buttons">
                    <button class="btn btn-filter" onclick="applyCompactFilters()">검색</button>
                    <button class="btn btn-reset" onclick="resetCompactFilters()">초기화</button>
                </div>
            </div>
        </div>
        
        <!-- 결과 정보 표시 -->
        <div id="resultsInfo" class="results-info" style="display: block;">
            <span id="resultsCount">0</span>개의 결과가 표시됩니다.
        </div>
        
        <div class="table-container">
            <table class="consultation-table" id="consultationTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>기업명</th>
                    <th>신청자</th>
                    <th>연락처</th>
                    <th>업종</th>
                    <th>상태</th>
                    <th>신청일</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <!-- 디버깅 정보 -->
                <script>
                    console.log('상담신청 개수:', <%= consultations.size() %>);
                    <% if (!consultations.isEmpty()) { %>
                        console.log('첫 번째 상담신청:', {
                            id: <%= consultations.get(0).getId() %>,
                            companyName: '<%= consultations.get(0).getCompanyName() %>',
                            status: '<%= consultations.get(0).getStatus() %>'
                        });
                    <% } %>
                </script>
                <% if (consultations.isEmpty()) { %>
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 40px; color: #718096;">
                            등록된 상담신청이 없습니다.
                        </td>
                    </tr>
                <% } else { %>
                    <% for (ConsultationRequest consultation : consultations) { %>
                        <tr>
                            <td data-label="ID"><%= consultation.getId() %></td>
                            <td data-label="기업명"><%= consultation.getCompanyName() %></td>
                            <td data-label="신청자"><%= consultation.getContactName() %></td>
                            <td data-label="연락처"><%= consultation.getPhone() %></td>
                            <td data-label="업종">
                                <%
                                    String industry = consultation.getIndustry();
                                    String displayIndustry = "";
                                    
                                    // 영어를 한글로 변환
                                    if ("manufacturing".equals(industry)) {
                                        displayIndustry = "제조업";
                                    } else if ("service".equals(industry)) {
                                        displayIndustry = "서비스업";
                                    } else if ("it".equals(industry) || "IT/소프트웨어".equals(industry)) {
                                        displayIndustry = "IT/소프트웨어";
                                    } else if ("construction".equals(industry)) {
                                        displayIndustry = "건설업";
                                    } else if ("distribution".equals(industry)) {
                                        displayIndustry = "유통업";
                                    } else if ("other".equals(industry)) {
                                        displayIndustry = "기타";
                                    } else {
                                        // 이미 한글인 경우 그대로 표시
                                        displayIndustry = industry;
                                    }
                                %>
                                <%= displayIndustry %>
                            </td>
                            <td data-label="상태">
                                <%
                                    String status = consultation.getStatus();
                                    String statusClass = "";
                                    String displayStatus = "";
                                    
                                    if ("pending".equals(status) || "대기중".equals(status)) {
                                        statusClass = "waiting";
                                        displayStatus = "대기중";
                                    } else if ("processing".equals(status) || "진행중".equals(status)) {
                                        statusClass = "processing";
                                        displayStatus = "진행중";
                                    } else if ("completed".equals(status) || "완료".equals(status)) {
                                        statusClass = "completed";
                                        displayStatus = "완료";
                                    } else {
                                        statusClass = "waiting";
                                        displayStatus = status;
                                    }
                                %>
                                <span class="status-badge status-<%= statusClass %>">
                                    <%= displayStatus %>
                                </span>
                            </td>
                            <td data-label="신청일"><%= consultation.getCreatedAt() %></td>
                            <td data-label="관리">
                                <button class="btn btn-primary" onclick="showDetail(<%= consultation.getId() %>)">상세보기</button>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>
        </div>
    </div>
    
    <!-- 상세보기 모달 -->
    <div id="detailModal" class="detail-modal">
        <div class="detail-content">
            <span class="close" onclick="closeDetailModal()">&times;</span>
            <div id="detailContent"></div>
        </div>
    </div>
    
    <script>
        function showDetail(id) {
            fetch('getConsultationDetail.jsp?id=' + id)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displayDetail(data.data);
                        document.getElementById('detailModal').style.display = 'block';
                    } else {
                        alert('상세 정보를 불러올 수 없습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다.');
                });
        }
        
        function displayDetail(consultation) {
            const content = document.getElementById('detailContent');
            
            // 한글 변환 함수들
            const getKoreanRelationship = (value) => {
                const mapping = {
                    'self': '본인',
                    'representative': '대표자',
                    'manager': '담당자',
                    'employee': '직원',
                    'other': '기타'
                };
                return mapping[value] || value || '-';
            };
            
            const getKoreanOwnership = (value) => {
                const mapping = {
                    'self': '자기소유',
                    'rent': '임대',
                    'lease': '리스',
                    'other': '기타'
                };
                return mapping[value] || value || '-';
            };
            
            const getKoreanIndustry = (value) => {
                const mapping = {
                    'construction': '건설업',
                    'manufacturing': '제조업',
                    'service': '서비스업',
                    'retail': '도소매업',
                    'food': '음식업',
                    'it': 'IT업',
                    'other': '기타'
                };
                return mapping[value] || value || '-';
            };
            
            const getKoreanFundType = (value) => {
                if (!value || value.trim() === '') return '-';
                
                const mapping = {
                    'working': '운전자금',
                    'facility': '시설자금',
                    'rd': 'R&D / 연구소 설립',
                    'equipment': '설비자금',
                    'expansion': '확장자금',
                    'other': '기타'
                };
                
                // 콤마로 구분된 여러 값 처리
                const values = value.split(',').map(v => v.trim());
                const koreanValues = values.map(v => mapping[v] || v).filter(v => v);
                
                return koreanValues.length > 0 ? koreanValues.join(', ') : '-';
            };
            
            const getKoreanStatus = (value) => {
                const mapping = {
                    'pending': '대기중',
                    'processing': '진행중',
                    'completed': '완료',
                    'cancelled': '취소'
                };
                return mapping[value] || value || '-';
            };
            
            // 간단한 헬퍼 함수
            const getValue = (value) => value || '-';
            const getAddress = () => {
                const addr = getValue(consultation.address);
                const detail = getValue(consultation.detailAddress);
                return addr !== '-' && detail !== '-' ? addr + ' ' + detail : addr;
            };
            
            const getStatusButton = (id, status) => {
                if (status === 'pending' || status === '대기중') {
                    return `<button class="btn btn-success" onclick="updateStatusFromDetail(${id}, 'processing')">진행으로 변경</button>`;
                } else if (status === 'processing' || status === '진행중') {
                    return `<button class="btn btn-success" onclick="updateStatusFromDetail(${id}, 'completed')">완료로 변경</button>`;
                } else {
                    return `<span class="status-completed">처리 완료</span>`;
                }
            };
            
            content.innerHTML = `
                <h2>상담신청 상세정보</h2>
                
                <div class="detail-section">
                    <h3>기본 정보</h3>
                    <div class="detail-row">
                        <div class="detail-label">기업명:</div>
                        <div class="detail-value">${getValue(consultation.companyName)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">사업자번호:</div>
                        <div class="detail-value">${getValue(consultation.businessNumber)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">신청자:</div>
                        <div class="detail-value">${getValue(consultation.applicantName)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">관계:</div>
                        <div class="detail-value">${getKoreanRelationship(consultation.relationship)} ${getValue(consultation.relationshipOther)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">연락처:</div>
                        <div class="detail-value">${getValue(consultation.phone)}</div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <h3>사업장 정보</h3>
                    <div class="detail-row">
                        <div class="detail-label">주소:</div>
                        <div class="detail-value">${getAddress()}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">소유:</div>
                        <div class="detail-value">${getKoreanOwnership(consultation.ownership)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">업종:</div>
                        <div class="detail-value">${getKoreanIndustry(consultation.industry)}</div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <h3>자금 정보</h3>
                    <div class="detail-row">
                        <div class="detail-label">전년도 매출:</div>
                        <div class="detail-value">${getValue(consultation.sales)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">대출 요청 금액:</div>
                        <div class="detail-value">${getValue(consultation.loanAmount)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">자금 종류:</div>
                        <div class="detail-value">${getKoreanFundType(consultation.fundType)}</div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <h3>상담 내용</h3>
                    <div class="detail-value">${getValue(consultation.message)}</div>
                </div>
                
                <div class="detail-section">
                    <h3>처리 정보</h3>
                    <div class="detail-row">
                        <div class="detail-label">상태:</div>
                        <div class="detail-value">${getKoreanStatus(consultation.status)}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">신청일:</div>
                        <div class="detail-value">${getValue(consultation.createdAt)}</div>
                    </div>
                </div>
                
                <div class="detail-actions">
                    <h3>관리 작업</h3>
                    <div class="action-buttons">
                        ${getStatusButton(consultation.id, consultation.status)}
                        <button class="btn btn-danger" onclick="deleteConsultationFromDetail(${consultation.id})">삭제</button>
                    </div>
                </div>
            `;
        }
        
        function closeDetailModal() {
            document.getElementById('detailModal').style.display = 'none';
        }
        
        function updateStatusFromDetail(id, status) {
            if (confirm('상태를 변경하시겠습니까?')) {
                fetch('updateConsultationStatus.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({id: id, status: status})
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('상태가 변경되었습니다.');
                        location.reload();
                    } else {
                        alert('상태 변경에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다.');
                });
            }
        }
        
        function deleteConsultationFromDetail(id) {
            if (confirm('정말로 삭제하시겠습니까?')) {
                fetch('deleteConsultation.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({id: id})
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
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
        
        function updateStatus(id, status) {
            if (confirm('상태를 변경하시겠습니까?')) {
                fetch('updateConsultationStatus.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({id: id, status: status})
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('상태가 변경되었습니다.');
                        location.reload();
                    } else {
                        alert('상태 변경에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다.');
                });
            }
        }
        
        function deleteConsultation(id) {
            if (confirm('정말로 삭제하시겠습니까?')) {
                fetch('deleteConsultation.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({id: id})
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
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
        
        // 모달 외부 클릭시 닫기
        window.onclick = function(event) {
            const modal = document.getElementById('detailModal');
            if (event.target == modal) {
                closeDetailModal();
            }
        }
        
        // ===== 필터링 및 정렬 기능 =====
        
        
        // 간소화된 필터 적용
        function applyCompactFilters() {
            console.log('applyCompactFilters 함수 호출됨');
            
            const searchTerm = document.getElementById('compactSearchInput').value.toLowerCase();
            const statusFilter = document.getElementById('compactStatusFilter').value;
            const sortBy = document.getElementById('compactSortBy').value;
            
            console.log('검색어:', searchTerm);
            console.log('상태 필터:', statusFilter);
            console.log('정렬:', sortBy);
            
            const rows = document.querySelectorAll('#consultationTable tbody tr');
            console.log('총 행 개수:', rows.length);
            let visibleCount = 0;
            
            rows.forEach((row, index) => {
                if (row.querySelector('td[colspan="8"]')) {
                    console.log(`행 ${index}: 빈 행 건너뜀`);
                    return; // "등록된 상담신청이 없습니다" 행은 제외
                }
                
                const companyName = row.cells[1].textContent.toLowerCase();
                const applicantName = row.cells[2].textContent.toLowerCase();
                const phone = row.cells[3].textContent.toLowerCase();
                const statusBadge = row.cells[5].querySelector('.status-badge');
                const status = statusBadge ? statusBadge.textContent.trim() : '';
                
                console.log(`행 ${index}:`, {
                    companyName,
                    applicantName,
                    phone,
                    status
                });
                
                // 검색 조건 확인
                const matchesSearch = searchTerm === '' || 
                    companyName.includes(searchTerm) || 
                    applicantName.includes(searchTerm) || 
                    phone.includes(searchTerm);
                
                // 상태 필터 확인
                const matchesStatus = statusFilter === '' || 
                    (statusFilter === 'pending' && status === '대기중') ||
                    (statusFilter === 'processing' && status === '진행중') ||
                    (statusFilter === 'completed' && status === '완료');
                
                console.log(`행 ${index} 매칭:`, {
                    matchesSearch,
                    matchesStatus,
                    finalMatch: matchesSearch && matchesStatus
                });
                
                if (matchesSearch && matchesStatus) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            console.log('필터링 완료, 표시되는 행:', visibleCount);
            
            // 정렬 적용
            if (sortBy && sortBy !== '') {
                sortTable(sortBy);
            }
            
            // 결과 정보 표시
            updateResultsInfo(visibleCount);
        }
        
        // 간소화된 필터 초기화
        function resetCompactFilters() {
            document.getElementById('compactSearchInput').value = '';
            document.getElementById('compactStatusFilter').value = '';
            document.getElementById('compactSortBy').value = 'created_at_desc';
            
            // 모든 행 표시
            const rows = document.querySelectorAll('#consultationTable tbody tr');
            rows.forEach(row => {
                if (!row.querySelector('td[colspan="8"]')) {
                    row.style.display = '';
                }
            });
            
            // 기본 정렬 적용
            sortTable('created_at_desc');
            
            // 결과 정보 업데이트
            const emptyRow = document.querySelector('td[colspan="8"]');
            const visibleCount = rows.length - (emptyRow ? 1 : 0);
            updateResultsInfo(visibleCount);
        }
        
        
        // 정렬 함수
        function sortTable(sortBy) {
            console.log('sortTable 호출됨, sortBy:', sortBy);
            
            if (!sortBy || sortBy === '') {
                console.log('정렬 조건 없음, 건너뜀');
                return;
            }
            
            const tbody = document.querySelector('#consultationTable tbody');
            const rows = Array.from(tbody.querySelectorAll('tr')).filter(row => 
                row.style.display !== 'none' && !row.querySelector('td[colspan="8"]')
            );
            
            console.log('정렬할 행 개수:', rows.length);
            
            rows.sort((a, b) => {
                let aValue, bValue;
                let direction = 'asc';
                
                // sortBy 값 파싱 (예: created_at_desc, company_name_asc)
                if (sortBy.includes('created_at')) {
                    direction = sortBy.includes('desc') ? 'desc' : 'asc';
                    aValue = new Date(a.cells[6].textContent);
                    bValue = new Date(b.cells[6].textContent);
                    console.log('날짜 정렬:', direction, aValue, bValue);
                } else if (sortBy.includes('company_name')) {
                    direction = sortBy.includes('desc') ? 'desc' : 'asc';
                    aValue = a.cells[1].textContent.toLowerCase();
                    bValue = b.cells[1].textContent.toLowerCase();
                    console.log('기업명 정렬:', direction, aValue, bValue);
                } else if (sortBy.includes('status')) {
                    direction = sortBy.includes('desc') ? 'desc' : 'asc';
                    const aStatus = a.cells[5].querySelector('.status-badge').textContent.trim();
                    const bStatus = b.cells[5].querySelector('.status-badge').textContent.trim();
                    const statusOrder = { '대기중': 1, '진행중': 2, '완료': 3 };
                    aValue = statusOrder[aStatus] || 0;
                    bValue = statusOrder[bStatus] || 0;
                    console.log('상태 정렬:', direction, aValue, bValue);
                } else {
                    return 0;
                }
                
                if (direction === 'desc') {
                    return aValue > bValue ? -1 : aValue < bValue ? 1 : 0;
                } else {
                    return aValue < bValue ? -1 : aValue > bValue ? 1 : 0;
                }
            });
            
            console.log('정렬 완료, 행 재배치 중...');
            // 정렬된 행들을 다시 추가
            rows.forEach(row => tbody.appendChild(row));
        }
        
        
        // 결과 정보 업데이트
        function updateResultsInfo(count) {
            const resultsInfo = document.getElementById('resultsInfo');
            const resultsCount = document.getElementById('resultsCount');
            
            console.log('updateResultsInfo 호출됨, count:', count);
            console.log('resultsInfo 요소:', resultsInfo);
            console.log('resultsCount 요소:', resultsCount);
            
            if (resultsCount) {
                resultsCount.textContent = count;
                console.log('resultsCount 업데이트됨:', resultsCount.textContent);
            }
            
            if (resultsInfo) {
                if (count === 0) {
                    resultsInfo.style.display = 'none';
                    console.log('resultsInfo 숨김 처리');
                } else {
                    resultsInfo.style.display = 'block';
                    console.log('resultsInfo 표시 처리');
                }
            }
        }
        
        // 검색 입력 시 실시간 필터링 (선택사항)
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM 로드 완료, 이벤트 리스너 설정 중...');
            
            const compactSearchInput = document.getElementById('compactSearchInput');
            const compactStatusFilter = document.getElementById('compactStatusFilter');
            const compactSortBy = document.getElementById('compactSortBy');
            
            console.log('요소 확인:', {
                compactSearchInput,
                compactStatusFilter,
                compactSortBy
            });
            
            if (compactSearchInput) {
                // 간소화된 검색 입력 이벤트
                const debouncedApplyFilters = debounce(applyCompactFilters, 300);
                compactSearchInput.addEventListener('input', function(e) {
                    console.log('검색 입력 이벤트 발생:', e.target.value);
                    debouncedApplyFilters();
                });
                
                compactSearchInput.addEventListener('keypress', function(e) {
                    console.log('키 입력 이벤트:', e.key);
                    if (e.key === 'Enter') {
                        console.log('Enter 키 입력, 검색 실행');
                        applyCompactFilters();
                    }
                });
            } else {
                console.error('compactSearchInput 요소를 찾을 수 없습니다!');
            }
            
            // 상태 필터 변경 이벤트
            if (compactStatusFilter) {
                compactStatusFilter.addEventListener('change', function(e) {
                    console.log('상태 필터 변경:', e.target.value);
                    applyCompactFilters();
                });
            } else {
                console.error('compactStatusFilter 요소를 찾을 수 없습니다!');
            }
            
            // 정렬 변경 이벤트
            if (compactSortBy) {
                compactSortBy.addEventListener('change', function(e) {
                    console.log('정렬 변경:', e.target.value);
                    applyCompactFilters();
                });
            } else {
                console.error('compactSortBy 요소를 찾을 수 없습니다!');
            }
            
            console.log('모든 이벤트 리스너 설정 완료');
        });
        
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
        
        // ===== 관리자 페이지 반응형 기능 =====
        
        // 테이블 반응형 처리
        function handleTableResponsive() {
            const table = document.querySelector('.consultation-table');
            if (table && window.innerWidth <= 768) {
                // 모바일에서 테이블 스크롤 처리
                table.style.overflowX = 'auto';
                table.style.display = 'block';
                table.style.whiteSpace = 'nowrap';
            }
        }
        
        // 화면 크기 변경 감지
        window.addEventListener('resize', function() {
            handleTableResponsive();
        });
        
        // 초기 로드 시 반응형 처리
        document.addEventListener('DOMContentLoaded', function() {
            handleTableResponsive();
            
            // 터치 이벤트 최적화
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(btn => {
                btn.style.minHeight = '44px';
                btn.style.minWidth = '44px';
            });
            
            // 초기 결과 정보 표시
            const rows = document.querySelectorAll('#consultationTable tbody tr');
            const emptyRow = document.querySelector('td[colspan="8"]');
            const visibleCount = rows.length - (emptyRow ? 1 : 0);
            
            // 디버깅 로그
            console.log('총 행 개수:', rows.length);
            console.log('빈 행 존재:', !!emptyRow);
            console.log('표시할 행 개수:', visibleCount);
            
            // 약간의 지연 후 결과 정보 업데이트 (다른 초기화 로직과의 충돌 방지)
            setTimeout(() => {
                updateResultsInfo(visibleCount);
            }, 100);
        });
        
        // 모바일에서 버튼 클릭 최적화
        if (window.innerWidth <= 768) {
            document.querySelectorAll('.btn').forEach(btn => {
                btn.addEventListener('touchstart', function() {
                    this.style.transform = 'scale(0.95)';
                });
                
                btn.addEventListener('touchend', function() {
                    this.style.transform = 'scale(1)';
                });
            });
        }
    </script>
</body>
</html>
