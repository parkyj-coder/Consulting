# Consulting

상담 신청 웹 애플리케이션 (JSP/Servlet, Jakarta EE)

## 로컬 실행

1. **설정 파일**
   - `src/main/java/db.properties.example` → `db.properties` 로 복사 후 DB 정보 입력
   - `src/main/java/kakao.properties.example` → `kakao.properties` 로 복사 후 카카오 API 정보 입력

2. **빌드 및 실행**
   ```bash
   mvn package
   # 생성된 target/Consulting.war 를 Tomcat 10.1+ webapps 에 배치 후 실행
   ```

## 배포 (Render)

1. [Render](https://render.com) 가입 후 **New → Blueprint** 선택
2. GitHub 저장소 `parkyj-coder/Consulting` 연결
3. Render에서 **MySQL** 데이터베이스 생성
4. Web Service 설정에서 **Environment** 에 다음 변수 추가:
   - `DB_DRIVER`: `com.mysql.cj.jdbc.Driver`
   - `DB_URL`: (Render MySQL 연결 정보의 JDBC URL)
   - `DB_USERNAME`: DB 사용자명
   - `DB_PASSWORD`: DB 비밀번호
5. **Deploy** 실행

저장소 루트의 `render.yaml` 이 있으면 Blueprint 로 자동 설정됩니다.

## 기술 스택

- Java 17, Jakarta Servlet 5, JSP, JSTL
- MySQL, Maven, Tomcat 10.1
