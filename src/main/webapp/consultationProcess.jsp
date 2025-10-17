<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ConsultationDAO" %>
<%@ page import="model.ConsultationRequest" %>
<%@ page import="service.KakaoNotificationService" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    try {
        // 폼 데이터 받기
        String companyName = request.getParameter("companyName");
        String businessNumber = request.getParameter("businessNumber");
        String applicantName = request.getParameter("contactName");
        String relationship = request.getParameter("relationship");
        String relationshipOther = request.getParameter("relationshipOther");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String detailAddress = request.getParameter("detailAddress");
        String[] ownershipArray = request.getParameterValues("ownership");
        String industry = request.getParameter("industry");
        String sales = request.getParameter("sales");
        String loanAmount = request.getParameter("loanAmount");
        String[] fundTypeArray = request.getParameterValues("fundType");
        String message = request.getParameter("message");
        String privacyAgreement = request.getParameter("privacyAgreement");
        
        // 디버깅을 위한 로그 출력 (항상 출력)
        System.out.println("=== 상담신청 폼 데이터 (JSP 수신) ===");
        System.out.println("companyName: " + companyName);
        System.out.println("businessNumber: " + businessNumber);
        System.out.println("applicantName: " + applicantName);
        System.out.println("relationship: " + relationship);
        System.out.println("relationshipOther: " + relationshipOther);
        System.out.println("phone: " + phone);
        System.out.println("address: " + address);
        System.out.println("detailAddress: " + detailAddress);
        System.out.println("ownership: " + (ownershipArray != null ? String.join(",", ownershipArray) : "null"));
        System.out.println("industry: " + industry);
        System.out.println("sales: " + sales);
        System.out.println("loanAmount: " + loanAmount);
        System.out.println("fundType: " + (fundTypeArray != null ? String.join(",", fundTypeArray) : "null"));
        System.out.println("message: " + message);
        System.out.println("privacyAgreement: " + privacyAgreement);
        System.out.println("=========================");
        
        // 유효성 검사
        if (companyName == null || companyName.trim().isEmpty() ||
            businessNumber == null || businessNumber.trim().isEmpty() ||
            applicantName == null || applicantName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            detailAddress == null || detailAddress.trim().isEmpty() ||
            industry == null || industry.trim().isEmpty() ||
            privacyAgreement == null) {
            
            System.out.println("유효성 검사 실패 - 필수 항목 누락");
            out.print("{\"success\": false, \"message\": \"필수 항목을 모두 입력해주세요.\"}");
            return;
        }
        
        System.out.println("유효성 검사 통과 - DB 저장 시작");
        
        // 배열 데이터 처리
        String ownership = (ownershipArray != null) ? String.join(",", ownershipArray) : "";
        String fundType = (fundTypeArray != null) ? String.join(",", fundTypeArray) : "";
        
        // ConsultationRequest 객체 생성
        ConsultationRequest consultationRequest = new ConsultationRequest(
            companyName.trim(),
            businessNumber.trim(),
            applicantName.trim(),
            relationship,
            relationshipOther != null ? relationshipOther.trim() : "",
            phone.trim(),
            address.trim(),
            detailAddress.trim(),
            ownership,
            industry,
            sales != null ? sales.trim() : "",
            loanAmount != null ? loanAmount.trim() : "",
            fundType,
            message != null ? message.trim() : "",
            true
        );
        
        // DB에 저장
        System.out.println("ConsultationRequest 객체 생성 완료");
        ConsultationDAO consultationDAO = new ConsultationDAO();
        System.out.println("ConsultationDAO 객체 생성 완료");
        
        boolean success = consultationDAO.saveConsultation(consultationRequest);
        System.out.println("DB 저장 결과: " + success);
        
        if (success) {
            // 카카오톡 알림 전송 (DB 기반으로 변경)
            try {
                int sentCount = KakaoNotificationService.sendConsultationNotificationToAllAdmins(
                    companyName.trim(), 
                    applicantName.trim(), 
                    phone.trim()
                );
                System.out.println("관리자 " + sentCount + "명에게 알림 전송 완료");
            } catch (Exception e) {
                // 카카오톡 알림 실패해도 상담신청은 성공으로 처리
                System.err.println("카카오톡 알림 전송 실패: " + e.getMessage());
            }
            
            out.print("{\"success\": true, \"message\": \"상담신청이 정상적으로 접수되었습니다.\"}");
        } else {
            out.print("{\"success\": false, \"message\": \"상담신청 처리 중 오류가 발생했습니다.\"}");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
    }
%>
