-- =============================================
-- 한국미래 중소기업 경영컨설팅 데이터베이스 스키마
-- =============================================

-- 데이터베이스 생성 (필요시)
-- CREATE DATABASE IF NOT EXISTS swcooker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE swcooker;

-- =============================================
-- 관리자 테이블
-- =============================================
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '관리자 아이디',
    password VARCHAR(255) NOT NULL COMMENT '해시화된 비밀번호',
    name VARCHAR(100) NOT NULL COMMENT '관리자 이름',
    email VARCHAR(100) COMMENT '이메일',
    role ENUM('super_admin', 'admin') DEFAULT 'admin' COMMENT '권한 (super_admin: 최고관리자, admin: 일반관리자)',
    active BOOLEAN DEFAULT TRUE COMMENT '활성화 상태',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    
    INDEX idx_username (username),
    INDEX idx_active (active),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='관리자 정보';

-- =============================================
-- 상담 신청 테이블
-- =============================================
CREATE TABLE IF NOT EXISTS consultation_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL COMMENT '회사명',
    business_number VARCHAR(20) NOT NULL COMMENT '사업자등록번호',
    contact_name VARCHAR(100) NOT NULL COMMENT '담당자명',
    relationship VARCHAR(50) NOT NULL COMMENT '담당자와의 관계',
    relationship_other VARCHAR(100) COMMENT '기타 관계',
    phone VARCHAR(20) NOT NULL COMMENT '연락처',
    address VARCHAR(300) NOT NULL COMMENT '주소',
    detail_address VARCHAR(200) NOT NULL COMMENT '상세주소',
    ownership VARCHAR(100) COMMENT '소유형태',
    industry VARCHAR(100) NOT NULL COMMENT '업종',
    sales VARCHAR(50) COMMENT '매출액',
    loan_amount VARCHAR(50) COMMENT '희망 대출금액',
    fund_type VARCHAR(200) COMMENT '자금 용도',
    message TEXT COMMENT '기타 문의사항',
    status ENUM('대기', '진행중', '완료', '취소') DEFAULT '대기' COMMENT '상담 상태',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '신청일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    
    INDEX idx_company_name (company_name),
    INDEX idx_contact_name (contact_name),
    INDEX idx_phone (phone),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_business_number (business_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='상담 신청 정보';

-- =============================================
-- 기본 관리자 계정 생성
-- =============================================
-- 비밀번호: admin123 (해시화된 값)
INSERT INTO admins (username, password, name, email, role, active) VALUES 
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '시스템 관리자', 'admin@consulting.co.kr', 'super_admin', TRUE),
('manager', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', '일반 관리자', 'manager@consulting.co.kr', 'admin', TRUE)
ON DUPLICATE KEY UPDATE 
    password = VALUES(password),
    name = VALUES(name),
    email = VALUES(email),
    role = VALUES(role),
    active = VALUES(active);

-- =============================================
-- 테스트 상담 신청 데이터 (개발용)
-- =============================================
INSERT INTO consultation_requests (
    company_name, business_number, contact_name, relationship, phone, 
    address, detail_address, industry, status
) VALUES 
('테스트 회사', '123-45-67890', '홍길동', '대표이사', '010-1234-5678', 
 '서울시 강남구 테헤란로 123', '456호', 'IT/소프트웨어', '대기'),
('샘플 기업', '987-65-43210', '김철수', '사업부장', '010-9876-5432', 
 '부산시 해운대구 센텀중앙로 789', '101동 202호', '제조업', '진행중')
ON DUPLICATE KEY UPDATE 
    company_name = VALUES(company_name),
    business_number = VALUES(business_number),
    contact_name = VALUES(contact_name);

-- =============================================
-- 뷰 생성 (관리자용)
-- =============================================
CREATE OR REPLACE VIEW admin_dashboard AS
SELECT 
    (SELECT COUNT(*) FROM consultation_requests WHERE status = '대기') as pending_count,
    (SELECT COUNT(*) FROM consultation_requests WHERE status = '진행중') as in_progress_count,
    (SELECT COUNT(*) FROM consultation_requests WHERE status = '완료') as completed_count,
    (SELECT COUNT(*) FROM consultation_requests WHERE DATE(created_at) = CURDATE()) as today_count,
    (SELECT COUNT(*) FROM consultation_requests WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)) as week_count,
    (SELECT COUNT(*) FROM consultation_requests WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)) as month_count;

-- =============================================
-- 프로시저 생성 (상담 상태 업데이트)
-- =============================================
DELIMITER //

CREATE PROCEDURE IF NOT EXISTS UpdateConsultationStatus(
    IN p_id INT,
    IN p_status VARCHAR(20),
    OUT p_result BOOLEAN
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = FALSE;
    END;
    
    START TRANSACTION;
    
    UPDATE consultation_requests 
    SET status = p_status, updated_at = NOW() 
    WHERE id = p_id;
    
    IF ROW_COUNT() > 0 THEN
        SET p_result = TRUE;
        COMMIT;
    ELSE
        SET p_result = FALSE;
        ROLLBACK;
    END IF;
END //

DELIMITER ;

-- =============================================
-- 트리거 생성 (업데이트 시간 자동 갱신)
-- =============================================
DELIMITER //

CREATE TRIGGER IF NOT EXISTS update_admins_updated_at
    BEFORE UPDATE ON admins
    FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END //

CREATE TRIGGER IF NOT EXISTS update_consultation_requests_updated_at
    BEFORE UPDATE ON consultation_requests
    FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END //

DELIMITER ;

-- =============================================
-- 권한 설정 (필요시)
-- =============================================
-- GRANT SELECT, INSERT, UPDATE, DELETE ON swcooker.* TO 'swcooker'@'%';
-- FLUSH PRIVILEGES;

-- =============================================
-- 인덱스 최적화
-- =============================================
-- ANALYZE TABLE admins;
-- ANALYZE TABLE consultation_requests;

-- =============================================
-- 완료 메시지
-- =============================================
SELECT '데이터베이스 스키마 생성이 완료되었습니다.' as message;
SELECT '기본 관리자 계정: admin / admin123' as admin_info;
SELECT '일반 관리자 계정: manager / admin123' as manager_info;
