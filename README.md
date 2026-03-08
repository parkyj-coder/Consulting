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

## Cloudflare로 배포하기

이 프로젝트는 **Java + JSP + MySQL**이라서, Cloudflare만으로는 서버를 돌릴 수 없습니다.  
Cloudflare는 **정적 파일·JavaScript**용이라 **Java 서버를 직접 호스팅하지 않습니다.**

그래서 **두 단계**로 나눕니다.

### 1단계: 앱 서버는 다른 곳에서 실행

- **Render** (또는 Railway 등)에서 위처럼 Java 앱을 배포합니다.
- 배포가 끝나면 예: `https://consulting-xxxx.onrender.com` 같은 **주소**가 생깁니다.

### 2단계: Cloudflare로 도메인 연결 (선택)

**본인 도메인**이 있고, 그 도메인으로 접속하게 하고 싶다면:

1. **Cloudflare** (https://dash.cloudflare.com) 가입 후 **사이트 추가**에서 도메인 입력
2. 안내대로 **네임서버**를 Cloudflare 것으로 변경 (도메인 구매한 곳에서)
3. **DNS** 메뉴에서:
   - 타입: **CNAME**
   - 이름: `www` (또는 원하는 서브도메인)
   - 대상: `consulting-xxxx.onrender.com` (Render에서 준 주소)
   - **프록시 상태: 프록시됨(주황색 구름)** 으로 두기
4. 저장하면, `www.본인도메인.com` 으로 접속 시 Cloudflare를 거쳐 Render 앱으로 연결됩니다.

정리하면:

- **앱 실행** = Render (Java 가능)
- **도메인 + 캐시/보안** = Cloudflare (DNS + 프록시)

자세한 단계는 [CLOUDFLARE.md](CLOUDFLARE.md) 를 참고하세요.

## 카페24 + Cloudflare로 배포하기

앱을 **카페24 Tomcat JSP 호스팅**에 올리고, **Cloudflare**로 도메인·캐시·보안을 연결할 수 있습니다.

- **카페24**: WAR 파일 업로드로 Java/JSP 앱 실행 (Tomcat 제공)
- **Cloudflare**: 도메인 DNS·SSL·캐시

상세 단계는 [CAFE24_CLOUDFLARE.md](CAFE24_CLOUDFLARE.md) 를 참고하세요.

## 기술 스택

- Java 17, Jakarta Servlet 5, JSP, JSTL
- MySQL, Maven, Tomcat 10.1
