# Cloudflare로 배포하기 (쉬운 설명)

## 한 줄 요약

- **앱(Java)은 Render에서 실행**  
- **Cloudflare는 "도메인 연결 + 보안/캐시"** 용도로 사용

---

## 왜 Cloudflare만으로는 안 되나요?

| 구분 | Cloudflare Pages | 이 프로젝트(Consulting) |
|------|------------------|--------------------------|
| 실행 환경 | HTML, CSS, JavaScript만 | **Java + JSP + MySQL** |
| 서버 | 없음 (정적/간단한 함수만) | **Tomcat 서버 필요** |

→ Java 앱은 **반드시 Java를 돌릴 수 있는 곳**(Render, Railway 등)에서 실행해야 합니다.  
Cloudflare는 그 앞에서 **도메인 연결·캐시·보안**만 담당하는 방식으로 쓰는 게 맞습니다.

---

## 순서대로 하기

### 1. 먼저: Render에서 앱 배포

1. https://render.com 가입 후 **New → Web Service**
2. GitHub에서 **Consulting** 저장소 연결
3. **MySQL** 데이터베이스 하나 만들기
4. 환경 변수에 DB 정보 넣기:
   - `DB_DRIVER` = `com.mysql.cj.jdbc.Driver`
   - `DB_URL` = (Render가 알려주는 MySQL 주소)
   - `DB_USERNAME` = DB 사용자명
   - `DB_PASSWORD` = DB 비밀번호
5. 배포 완료 후 **주소 확인**  
   예: `https://consulting-abc123.onrender.com`

---

### 2. 그다음: Cloudflare에 도메인 연결 (도메인이 있을 때만)

**도메인이 없다면**  
→ Render 주소(`https://consulting-xxx.onrender.com`)로만 접속해도 됩니다. Cloudflare는 건너뛰어도 됩니다.

**도메인이 있다면** (예: `mycompany.com`):

1. **Cloudflare 가입**  
   https://dash.cloudflare.com → **사이트 추가** → `mycompany.com` 입력

2. **네임서버 변경**  
   Cloudflare가 알려주는 네임서버 2개를, 도메인을 산 곳(가비아, 카페24 등)의 "네임서버 설정"에 넣습니다.

3. **DNS 설정**  
   Cloudflare 대시보드 → **DNS → 레코드**에서:

   | 타입 | 이름 | 대상 | 프록시 |
   |------|------|------|--------|
   | CNAME | www | consulting-abc123.onrender.com | 주황색 구름(프록시됨) |

   - "이름"을 비우면 `mycompany.com`, `www`면 `www.mycompany.com` 으로 접속됩니다.
   - **대상**에는 Render에서 준 주소를 그대로 넣습니다.

4. **저장** 후 5~10분 정도 기다리면,  
   `www.mycompany.com` 으로 접속 시 Cloudflare를 거쳐 Render 앱으로 연결됩니다.

---

## 정리

- **Cloudflare로 배포** = **도메인을 Cloudflare에 연결해서, 그 도메인으로 Render 앱에 접속하게 하는 것**
- 앱 자체는 계속 **Render**에서 실행됩니다.
- Cloudflare를 쓰면 **속도·캐시·DDoS 방어** 같은 이점을 받을 수 있습니다.

도메인이 없어도 Render 주소만으로 서비스 사용은 가능합니다.
