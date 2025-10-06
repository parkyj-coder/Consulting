# 중소벤처정책자금센터 - 상담신청 시스템

## 📋 프로젝트 개요
중소기업과 벤처기업의 정책자금 상담을 위한 웹 애플리케이션입니다.

## 🛠️ 기술 스택
- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Backend**: Java Servlet, JSP
- **Database**: MySQL 8.0+
- **Server**: Apache Tomcat 10.1+
- **Build Tool**: Maven

## 📁 프로젝트 구조
```
consulting/
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── classes/
│   │   │   ├── dao/           # 데이터 접근 객체
│   │   │   ├── model/         # 데이터 모델
│   │   │   ├── servlet/       # 서블릿
│   │   │   └── util/          # 유틸리티
│   │   ├── lib/               # JAR 라이브러리
│   │   └── web.xml           # 웹 애플리케이션 설정
│   ├── admin/                # 관리자 페이지
│   ├── css/                  # 스타일시트
│   ├── js/                   # JavaScript
│   ├── database/             # 데이터베이스 스크립트
│   └── index.html            # 메인 페이지
└── README.md
```

## 🚀 설치 및 실행 방법

### 1. 데이터베이스 설정
```sql
-- MySQL에 접속하여 다음 명령어 실행
mysql -u root -p

-- 데이터베이스 및 테이블 생성
source consulting/database/create_tables.sql
```

### 2. 데이터베이스 연결 설정
`src/main/webapp/WEB-INF/classes/db.properties` 파일에서 데이터베이스 연결 정보를 수정하세요:
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/consulting_db?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8
db.username=root
db.password=1234
```

### 3. Tomcat 서버 설정
1. Apache Tomcat 10.1+ 설치
2. 프로젝트를 Tomcat의 webapps 폴더에 배포
3. MySQL Connector JAR 파일이 `WEB-INF/lib/` 폴더에 있는지 확인

### 4. 서버 실행
```bash
# Tomcat 서버 시작
./catalina.sh start  # Linux/Mac
catalina.bat start   # Windows
```

## 📱 주요 기능

### 1. 자금상담신청서
- **기본 정보**: 기업명, 사업자번호, 신청자 정보
- **사업장 정보**: 주소, 소유 형태, 업종
- **자금 정보**: 매출액, 대출 요청 금액, 자금 종류
- **상담 내용**: 상세한 상담 요청 사항
- **개인정보 동의**: 개인정보 처리방침 동의

### 2. 관리자 기능
- **상담신청 목록 조회**: 모든 상담신청 내역 확인
- **상세 정보 보기**: 개별 상담신청의 상세 내용 확인
- **상태 관리**: 대기중 → 진행중 → 완료 상태 변경
- **삭제 기능**: 불필요한 상담신청 삭제

## 🔧 API 엔드포인트

### POST /consultation
상담신청 데이터를 저장합니다.
```javascript
// 요청 예시
const formData = new FormData();
formData.append('companyName', '테스트기업');
formData.append('businessNumber', '123-45-67890');
// ... 기타 필드들

fetch('/consultation', {
    method: 'POST',
    body: formData
});
```

### GET /consultation
모든 상담신청 목록을 조회합니다.
```javascript
fetch('/consultation')
    .then(response => response.json())
    .then(data => console.log(data));
```

## 📊 데이터베이스 스키마

### consultation_requests 테이블
| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| id | INT | 기본키 (자동증가) |
| company_name | VARCHAR(100) | 기업명 |
| business_number | VARCHAR(20) | 사업자번호 |
| applicant_name | VARCHAR(50) | 신청자 성명 |
| relationship | VARCHAR(20) | 사업주와의 관계 |
| phone | VARCHAR(20) | 휴대폰 |
| address | VARCHAR(200) | 주소 |
| detail_address | VARCHAR(200) | 상세주소 |
| industry | VARCHAR(50) | 업종 |
| sales | VARCHAR(100) | 전년도 매출액 |
| loan_amount | VARCHAR(100) | 대출 요청 금액 |
| fund_type | VARCHAR(200) | 요청 자금 종류 |
| message | TEXT | 상담 요청시 전달 내용 |
| privacy_agreement | BOOLEAN | 개인정보 수집 및 이용 동의 |
| status | VARCHAR(20) | 상담 상태 |
| created_at | TIMESTAMP | 신청일시 |
| updated_at | TIMESTAMP | 수정일시 |

## 🎨 UI/UX 특징
- **반응형 디자인**: 모바일, 태블릿, 데스크톱 지원
- **직관적인 폼**: 사용자 친화적인 입력 인터페이스
- **실시간 유효성 검사**: 입력 데이터 검증
- **관리자 대시보드**: 효율적인 상담신청 관리

## 🔒 보안 고려사항
- **개인정보 보호**: 개인정보 처리방침 준수
- **데이터 검증**: 서버사이드 유효성 검사
- **SQL 인젝션 방지**: PreparedStatement 사용
- **XSS 방지**: 입력 데이터 이스케이프 처리

## 📞 문의사항
프로젝트 관련 문의사항이 있으시면 개발팀에 연락해주세요.

---
© 2024 중소벤처정책자금센터. All rights reserved.