<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ConsultationDAO" %>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.ConsultationRequest" %>
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
    
    ConsultationDAO dao = new ConsultationDAO();
    List<ConsultationRequest> consultations = dao.getAllConsultations();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상담신청 관리 - 중소벤처정책자금센터</title>
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
        
        .consultation-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
            color: #666;
            float: right;
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: #f0f0f0;
            transition: all 0.3s ease;
            line-height: 1;
        }
        
        .close:hover {
            color: #333;
            background: #e0e0e0;
            transform: scale(1.1);
        }
        
        .close:active {
            transform: scale(0.95);
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
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .action-buttons .btn {
            padding: 10px 20px;
            font-size: 14px;
            min-width: 100px;
        }
        
        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
                gap: 8px;
            }
            
            .action-buttons .btn {
                width: 100%;
                min-width: auto;
                padding: 12px 20px;
                font-size: 16px;
            }
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
            
            .consultation-table {
                font-size: 0.875rem;
            }
            
            .consultation-table th,
            .consultation-table td {
                padding: 8px;
            }
            
            .detail-content {
                width: 95%;
                margin: 10% auto;
                padding: 15px;
            }
            
            .close {
                width: 36px;
                height: 36px;
                font-size: 20px;
                background: #f8f8f8;
                border: 1px solid #ddd;
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
            
            .detail-content {
                width: 98%;
                margin: 5% auto;
                padding: 12px;
            }
            
            .close {
                width: 40px;
                height: 40px;
                font-size: 18px;
                background: #f0f0f0;
                border: 2px solid #ccc;
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
                        <% if (isSuperAdmin) { %>
                        <a href="adminManagement.jsp">
                            <i>👥</i>관리자 관리
                        </a>
                        <% } %>
                        <a href="logout.jsp">
                            <i>🚪</i>로그아웃
                        </a>
                    </div>
                </div>
            </div>
            <h1>상담신청 관리</h1>
            <p>자금상담신청서 목록을 관리할 수 있습니다.</p>
        </div>
        
        <table class="consultation-table">
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
                <% if (consultations.isEmpty()) { %>
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 40px; color: #718096;">
                            등록된 상담신청이 없습니다.
                        </td>
                    </tr>
                <% } else { %>
                    <% for (ConsultationRequest consultation : consultations) { %>
                        <tr>
                            <td><%= consultation.getId() %></td>
                            <td><%= consultation.getCompanyName() %></td>
                            <td><%= consultation.getApplicantName() %></td>
                            <td><%= consultation.getPhone() %></td>
                            <td>
                                <%
                                    String industry = consultation.getIndustry();
                                    String industryKorean = "";
                                    if (industry != null) {
                                        switch (industry) {
                                            case "retail": industryKorean = "도소매업"; break;
                                            case "manufacturing": industryKorean = "제조업"; break;
                                            case "service": industryKorean = "서비스업"; break;
                                            case "software": industryKorean = "소프트웨어개발업"; break;
                                            case "construction": industryKorean = "건설업"; break;
                                            case "other": industryKorean = "기타"; break;
                                            default: industryKorean = industry; break;
                                        }
                                    }
                                %>
                                <%= industryKorean %>
                            </td>
                            <td>
                                <span class="status-badge status-<%= consultation.getStatus().equals("대기중") ? "waiting" : 
                                    consultation.getStatus().equals("진행중") ? "processing" : "completed" %>">
                                    <%= consultation.getStatus() %>
                                </span>
                            </td>
                            <td><%= consultation.getCreatedAt() %></td>
                            <td>
                                <button class="btn btn-primary" onclick="showDetail(<%= consultation.getId() %>)">상세보기</button>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>
    </div>
    
    <!-- 상세보기 모달 -->
    <div id="detailModal" class="detail-modal">
        <div class="detail-content">
            <span class="close" onclick="closeDetailModal()">&times;</span>
            <div id="detailContent"></div>
            <!-- 액션 버튼들 -->
            <div class="detail-actions" id="detailActions" style="display: none;">
                <div class="action-buttons">
                    <button class="btn btn-success" id="statusButton" onclick="updateStatusFromModal()">상태 변경</button>
                    <button class="btn btn-danger" id="deleteButton" onclick="deleteConsultationFromModal()">삭제</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 상담 데이터를 JSON으로 저장 -->
    <script type="application/json" id="consultationsData">
    [
        <% for (int i = 0; i < consultations.size(); i++) { 
            ConsultationRequest consultation = consultations.get(i);
        %>
        {
            "id": <%= consultation.getId() %>,
            "companyName": "<%= consultation.getCompanyName() != null ? consultation.getCompanyName().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "businessNumber": "<%= consultation.getBusinessNumber() != null ? consultation.getBusinessNumber().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "applicantName": "<%= consultation.getApplicantName() != null ? consultation.getApplicantName().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "relationship": "<%= consultation.getRelationship() != null ? consultation.getRelationship().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "relationshipOther": "<%= consultation.getRelationshipOther() != null ? consultation.getRelationshipOther().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "phone": "<%= consultation.getPhone() != null ? consultation.getPhone().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "address": "<%= consultation.getAddress() != null ? consultation.getAddress().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "detailAddress": "<%= consultation.getDetailAddress() != null ? consultation.getDetailAddress().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "ownership": "<%= consultation.getOwnership() != null ? consultation.getOwnership().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "industry": "<%= consultation.getIndustry() != null ? consultation.getIndustry().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "sales": "<%= consultation.getSales() != null ? consultation.getSales().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "salesUnit": "<%= consultation.getSalesUnit() != null ? consultation.getSalesUnit().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "원" %>",
            "loanAmount": "<%= consultation.getLoanAmount() != null ? consultation.getLoanAmount().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "loanUnit": "<%= consultation.getLoanUnit() != null ? consultation.getLoanUnit().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "원" %>",
            "fundType": "<%= consultation.getFundType() != null ? consultation.getFundType().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "message": "<%= consultation.getMessage() != null ? consultation.getMessage().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "status": "<%= consultation.getStatus() != null ? consultation.getStatus().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\\", "\\\\") : "" %>",
            "createdAt": "<%= consultation.getCreatedAt() != null ? consultation.getCreatedAt().toString() : "" %>"
        }<%= i < consultations.size() - 1 ? "," : "" %>
        <% } %>
    ]
    </script>
    
    <script>
        let currentConsultationId = null;
        
        function showDetail(id) {
            try {
                // JSON 데이터에서 상담 정보 찾기
                const dataElement = document.getElementById('consultationsData');
                if (!dataElement) {
                    alert('상담 데이터를 찾을 수 없습니다.');
                    return;
                }
                
                const consultations = JSON.parse(dataElement.textContent);
                
                console.log('All consultations:', consultations);
                console.log('Looking for ID:', id);
                
                if (!consultations || consultations.length === 0) {
                    alert('등록된 상담신청이 없습니다.');
                    return;
                }
                
                const consultation = consultations.find(c => c.id === id);
                console.log('Found consultation:', consultation);
                
                if (consultation) {
                    currentConsultationId = id;
                    displayDetail(consultation);
                    
                    // 액션 버튼들 표시 및 설정
                    const detailActions = document.getElementById('detailActions');
                    const statusButton = document.getElementById('statusButton');
                    const deleteButton = document.getElementById('deleteButton');
                    
                    // 상태에 따른 버튼 텍스트 설정
                    if (consultation.status === '대기중') {
                        statusButton.textContent = '진행중으로 변경';
                        statusButton.onclick = () => updateStatusFromModal('진행중');
                        statusButton.disabled = false;
                        statusButton.style.opacity = '1';
                    } else if (consultation.status === '진행중') {
                        statusButton.textContent = '완료로 변경';
                        statusButton.onclick = () => updateStatusFromModal('완료');
                        statusButton.disabled = false;
                        statusButton.style.opacity = '1';
                    } else {
                        statusButton.textContent = '상태 변경';
                        statusButton.disabled = true;
                        statusButton.style.opacity = '0.5';
                    }
                    
                    detailActions.style.display = 'block';
                    document.getElementById('detailModal').style.display = 'block';
                } else {
                    alert('상세 정보를 찾을 수 없습니다. ID: ' + id);
                    console.error('Consultation not found for ID:', id);
                    console.log('Available IDs:', consultations.map(c => c.id));
                }
            } catch (error) {
                console.error('Error parsing consultation data:', error);
                console.error('Raw data:', document.getElementById('consultationsData').textContent);
                alert('데이터를 불러오는 중 오류가 발생했습니다. 콘솔을 확인해주세요.');
            }
        }
        
        function displayDetail(consultation) {
            const content = document.getElementById('detailContent');
            
            // 데이터 검증 및 기본값 설정
            const safeValue = (value) => value || '-';
            const safeText = (text) => text ? text.replace(/\n/g, '<br>') : '-';
            
            // 상태에 따른 CSS 클래스 결정
            const getStatusClass = (status) => {
                if (status === '대기중') return 'waiting';
                if (status === '진행중') return 'processing';
                return 'completed';
            };
            
            // 업종을 한글로 변환
            const getIndustryKorean = (industry) => {
                const industryMap = {
                    'retail': '도소매업',
                    'manufacturing': '제조업',
                    'service': '서비스업',
                    'software': '소프트웨어개발업',
                    'construction': '건설업',
                    'other': '기타'
                };
                return industryMap[industry] || industry || '-';
            };
            
            // 자금 종류를 한글로 변환
            const getFundTypeKorean = (fundType) => {
                if (!fundType) return '-';
                
                const fundTypeMap = {
                    'working': '운전자금',
                    'facility': '시설자금',
                    'rd': 'R&D / 연구소 설립'
                };
                
                // 여러 값이 쉼표로 구분된 경우 처리
                if (fundType.includes(',')) {
                    return fundType.split(',').map(type => 
                        fundTypeMap[type.trim()] || type.trim()
                    ).join(', ');
                }
                
                return fundTypeMap[fundType] || fundType;
            };
            
            // 소유 형태를 한글로 변환
            const getOwnershipKorean = (ownership) => {
                if (!ownership) return '-';
                
                const ownershipMap = {
                    'self': '자가',
                    'rent': '임차'
                };
                
                // 여러 값이 쉼표로 구분된 경우 처리
                if (ownership.includes(',')) {
                    return ownership.split(',').map(type => 
                        ownershipMap[type.trim()] || type.trim()
                    ).join(', ');
                }
                
                return ownershipMap[ownership] || ownership;
            };
            
            // 관계를 한글로 변환
            const getRelationshipKorean = (relationship) => {
                if (!relationship) return '-';
                
                const relationshipMap = {
                    'self': '본인',
                    'other': '기타'
                };
                
                return relationshipMap[relationship] || relationship;
            };
            
            // 매출액을 단위와 함께 표시
            const formatSalesAmount = (sales, salesUnit) => {
                if (!sales || sales === '0' || sales === '') return '-';
                
                const amount = parseInt(sales) || 0;
                if (amount === 0) return '-';
                
                const unitMap = {
                    '원': '원',
                    '만원': '만원',
                    '천만원': '천만원',
                    '억원': '억원'
                };
                
                const unit = unitMap[salesUnit] || '원';
                return amount.toLocaleString('ko-KR') + unit;
            };
            
            // 대출 요청 금액을 단위와 함께 표시
            const formatLoanAmount = (loanAmount, loanUnit) => {
                if (!loanAmount || loanAmount === '0' || loanAmount === '') return '-';
                
                const amount = parseInt(loanAmount) || 0;
                if (amount === 0) return '-';
                
                const unitMap = {
                    '원': '원',
                    '만원': '만원',
                    '천만원': '천만원',
                    '억원': '억원'
                };
                
                const unit = unitMap[loanUnit] || '원';
                return amount.toLocaleString('ko-KR') + unit;
            };
            
            content.innerHTML = 
                '<h2>상담신청 상세정보</h2>' +
                '<div class="detail-section">' +
                    '<h3>기본 정보</h3>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">기업명:</div>' +
                        '<div class="detail-value">' + safeValue(consultation.companyName) + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">사업자번호:</div>' +
                        '<div class="detail-value">' + safeValue(consultation.businessNumber) + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">신청자:</div>' +
                        '<div class="detail-value">' + safeValue(consultation.applicantName) + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">관계:</div>' +
                        '<div class="detail-value">' + getRelationshipKorean(consultation.relationship) + ' ' + (consultation.relationshipOther || '') + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">연락처:</div>' +
                        '<div class="detail-value">' + safeValue(consultation.phone) + '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="detail-section">' +
                    '<h3>사업장 정보</h3>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">주소:</div>' +
                        '<div class="detail-value">' + safeValue(consultation.address) + ' ' + (consultation.detailAddress || '') + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">소유:</div>' +
                        '<div class="detail-value">' + getOwnershipKorean(consultation.ownership) + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">업종:</div>' +
                        '<div class="detail-value">' + getIndustryKorean(consultation.industry) + '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="detail-section">' +
                    '<h3>자금 정보</h3>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">전년도 매출:</div>' +
                        '<div class="detail-value">' + formatSalesAmount(consultation.sales, consultation.salesUnit) + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">대출 요청 금액:</div>' +
                        '<div class="detail-value">' + formatLoanAmount(consultation.loanAmount, consultation.loanUnit) + '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">자금 종류:</div>' +
                        '<div class="detail-value">' + getFundTypeKorean(consultation.fundType) + '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="detail-section">' +
                    '<h3>상담 내용</h3>' +
                    '<div class="detail-value" style="white-space: pre-wrap; line-height: 1.6;">' + safeText(consultation.message) + '</div>' +
                '</div>' +
                '<div class="detail-section">' +
                    '<h3>처리 정보</h3>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">상태:</div>' +
                        '<div class="detail-value">' +
                            '<span class="status-badge status-' + getStatusClass(consultation.status) + '">' +
                                safeValue(consultation.status) +
                            '</span>' +
                        '</div>' +
                    '</div>' +
                    '<div class="detail-row">' +
                        '<div class="detail-label">신청일:</div>' +
                        '<div class="detail-value">' + safeValue(consultation.createdAt) + '</div>' +
                    '</div>' +
                '</div>';
        }
        
        function closeDetailModal() {
            document.getElementById('detailModal').style.display = 'none';
            currentConsultationId = null;
        }
        
        function updateStatusFromModal(status) {
            if (!currentConsultationId) {
                alert('상담 정보를 찾을 수 없습니다.');
                return;
            }
            
            if (confirm('상태를 "' + status + '"로 변경하시겠습니까?')) {
                // 상태 변경 요청
                fetch('updateStatus.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + currentConsultationId + '&status=' + encodeURIComponent(status)
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('success')) {
                        alert('상태가 변경되었습니다.');
                        closeDetailModal();
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
        
        function deleteConsultationFromModal() {
            if (!currentConsultationId) {
                alert('상담 정보를 찾을 수 없습니다.');
                return;
            }
            
            if (confirm('정말로 이 상담신청을 삭제하시겠습니까?')) {
                // 삭제 요청
                fetch('deleteConsultation.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + currentConsultationId
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('success')) {
                        alert('삭제되었습니다.');
                        closeDetailModal();
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
                // 상태 변경 요청
                fetch('updateStatus.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + id + '&status=' + encodeURIComponent(status)
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('success')) {
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
                // 삭제 요청
                fetch('deleteConsultation.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + id
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('success')) {
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
        
        // 햄버거 메뉴 토글
        function toggleHamburgerMenu() {
            const content = document.getElementById('hamburgerContent');
            content.classList.toggle('show');
        }
        
        // 햄버거 메뉴 외부 클릭시 닫기
        window.onclick = function(event) {
            const modal = document.getElementById('detailModal');
            const hamburgerContent = document.getElementById('hamburgerContent');
            const hamburgerBtn = document.querySelector('.hamburger-btn');
            
            if (event.target == modal) {
                closeDetailModal();
            }
            
            if (!event.target.closest('.hamburger-menu') && hamburgerContent.classList.contains('show')) {
                hamburgerContent.classList.remove('show');
            }
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
            
            // 디버깅: 상담 데이터 확인
            const dataElement = document.getElementById('consultationsData');
            if (dataElement) {
                try {
                    const consultations = JSON.parse(dataElement.textContent);
                    console.log('=== 상담 데이터 로드 완료 ===');
                    console.log('총 상담 건수:', consultations.length);
                    consultations.forEach((consultation, index) => {
                        console.log(`상담 ${index + 1}:`, {
                            id: consultation.id,
                            companyName: consultation.companyName,
                            applicantName: consultation.applicantName,
                            status: consultation.status
                        });
                    });
                    console.log('============================');
                } catch (error) {
                    console.error('상담 데이터 파싱 오류:', error);
                }
            } else {
                console.error('상담 데이터 요소를 찾을 수 없습니다.');
            }
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
