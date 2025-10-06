<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        
        @media (max-width: 768px) {
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
                <a href="adminManagement.jsp" class="nav-button" style="background: rgba(56, 161, 105, 0.8);">
                    <i>👥</i>관리자 관리
                </a>
                <a href="logout.jsp" class="nav-button" style="background: rgba(229, 62, 62, 0.8);">
                    <i>🚪</i>로그아웃
                </a>
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
                            <td><%= consultation.getIndustry() %></td>
                            <td>
                                <span class="status-badge status-<%= consultation.getStatus().equals("대기중") ? "waiting" : 
                                    consultation.getStatus().equals("진행중") ? "processing" : "completed" %>">
                                    <%= consultation.getStatus() %>
                                </span>
                            </td>
                            <td><%= consultation.getCreatedAt() %></td>
                            <td>
                                <button class="btn btn-primary" onclick="showDetail(<%= consultation.getId() %>)">상세보기</button>
                                <% if (consultation.getStatus().equals("대기중")) { %>
                                    <button class="btn btn-success" onclick="updateStatus(<%= consultation.getId() %>, '진행중')">진행</button>
                                <% } else if (consultation.getStatus().equals("진행중")) { %>
                                    <button class="btn btn-success" onclick="updateStatus(<%= consultation.getId() %>, '완료')">완료</button>
                                <% } %>
                                <button class="btn btn-danger" onclick="deleteConsultation(<%= consultation.getId() %>)">삭제</button>
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
        </div>
    </div>
    
    <script>
        function showDetail(id) {
            fetch('/consultation?id=' + id)
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
            content.innerHTML = `
                <h2>상담신청 상세정보</h2>
                
                <div class="detail-section">
                    <h3>기본 정보</h3>
                    <div class="detail-row">
                        <div class="detail-label">기업명:</div>
                        <div class="detail-value">${consultation.companyName}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">사업자번호:</div>
                        <div class="detail-value">${consultation.businessNumber}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">신청자:</div>
                        <div class="detail-value">${consultation.applicantName}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">관계:</div>
                        <div class="detail-value">${consultation.relationship} ${consultation.relationshipOther || ''}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">연락처:</div>
                        <div class="detail-value">${consultation.phone}</div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <h3>사업장 정보</h3>
                    <div class="detail-row">
                        <div class="detail-label">주소:</div>
                        <div class="detail-value">${consultation.address} ${consultation.detailAddress}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">소유:</div>
                        <div class="detail-value">${consultation.ownership}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">업종:</div>
                        <div class="detail-value">${consultation.industry}</div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <h3>자금 정보</h3>
                    <div class="detail-row">
                        <div class="detail-label">전년도 매출:</div>
                        <div class="detail-value">${consultation.sales || '-'}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">대출 요청 금액:</div>
                        <div class="detail-value">${consultation.loanAmount || '-'}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">자금 종류:</div>
                        <div class="detail-value">${consultation.fundType || '-'}</div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <h3>상담 내용</h3>
                    <div class="detail-value">${consultation.message || '상담 내용이 없습니다.'}</div>
                </div>
                
                <div class="detail-section">
                    <h3>처리 정보</h3>
                    <div class="detail-row">
                        <div class="detail-label">상태:</div>
                        <div class="detail-value">${consultation.status}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">신청일:</div>
                        <div class="detail-value">${consultation.createdAt}</div>
                    </div>
                </div>
            `;
        }
        
        function closeDetailModal() {
            document.getElementById('detailModal').style.display = 'none';
        }
        
        function updateStatus(id, status) {
            if (confirm('상태를 변경하시겠습니까?')) {
                fetch('/consultation', {
                    method: 'PUT',
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
                fetch('/consultation', {
                    method: 'DELETE',
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
