# 카페24 + Cloudflare로 배포하기

Consulting 앱을 **카페24 Tomcat JSP 호스팅**에 올리고, **Cloudflare**로 도메인·보안을 연결하는 방법입니다.

---

## 전체 흐름 (한눈에)

```
[사용자] → [Cloudflare: 도메인·캐시·보안] → [카페24: Java 앱 실행]
```

- **카페24**: Java/JSP 앱을 실제로 실행하는 곳 (Tomcat 제공)
- **Cloudflare**: 도메인 연결, 속도·캐시, DDoS 방어 등

---

## 1단계: 카페24에서 Tomcat JSP 호스팅 준비

### 1-1. 호스팅 신청

1. [카페24 호스팅](https://hosting.cafe24.com) 접속 후 **Tomcat JSP 호스팅** 상품 선택
2. 요금제 선택 후 결제·가입 (예: 일반형 3,300원/월)
3. 가입 완료 후 **호스팅 관리자**에서 다음 정보 확인:
   - **FTP 주소, 아이디, 비밀번호**
   - **MySQL(또는 MariaDB) 주소, DB명, 사용자명, 비밀번호**
   - **SSH 접속 정보** (JSP 호스팅에 따라 제공되는 경우)

### 1-2. DB 설정

- 호스팅 관리자에서 **MySQL** DB 생성 후 **접속 주소, DB명, 사용자명, 비밀번호**를 확인합니다.
- 로컬에서 `src/main/java/db.properties` 를 아래처럼 채웁니다 (카페24가 알려준 값으로).

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://카페24DB주소:3306/DB명?useSSL=false&serverTimezone=Asia/Seoul&useUnicode=true&characterEncoding=UTF-8
db.username=DB사용자명
db.password=DB비밀번호
```

### 1-3. WAR 파일 빌드

프로젝트 폴더에서:

```bash
mvn package
```

생성된 파일: `target/Consulting.war`

- **루트 주소**(예: `https://내도메인.com/`)로 서비스하려면:
  - **Tomcat JSP 광호스팅**: 파일명을 **ROOT.war** 로 변경
  - **일반 JSP 호스팅**: 파일명을 **www.war** 로 변경 (매뉴얼 기준)

### 1-4. 카페24에 WAR 배포

**Tomcat JSP 광호스팅**인 경우:

1. FTP로 접속 후 **tomcat/webapps/** 폴더로 이동
2. **ROOT.war** 업로드 (기존 ROOT 폴더가 있으면 삭제 또는 백업 후 업로드)
3. 자동 배포되며, 배포 확인 후 **ROOT.war 파일은 삭제** (재시작 시 재배포 방지)

**일반 JSP 호스팅**인 경우 (매뉴얼 기준):

1. FTP로 **홈 디렉터리**에 **www.war** 업로드
2. SSH로 접속 후 Tomcat 중지 → 기존 `www` 폴더 백업 → Tomcat 재시작 → 배포 확인 후 **www.war 삭제**

배포가 끝나면 카페24에서 부여한 주소(예: `http://아이디.cafe24.com`) 또는 연결한 도메인으로 접속할 수 있습니다.

---

## 2단계: Cloudflare로 도메인 연결

도메인이 **카페24에서 구매**했든 **다른 곳**에서 구매했든, Cloudflare에 연결해 두면 캐시·보안을 쓰기 좋습니다.

### 2-1. Cloudflare에 사이트 추가

1. [Cloudflare 대시보드](https://dash.cloudflare.com) 로그인
2. **사이트 추가** → 사용할 **도메인** 입력 (예: `mydomain.com`)
3. 요금제 선택 (무료 플랜으로 충분)

### 2-2. 네임서버를 Cloudflare로 변경

- Cloudflare가 안내하는 **네임서버 2개** (예: `xxx.ns.cloudflare.com`, `yyy.ns.cloudflare.com`)를 복사합니다.
- **도메인을 관리하는 곳**으로 이동:
  - **카페24**에서 도메인을 관리 중이면: [카페24 도메인 관리](https://dc.cafe24.com) → 해당 도메인 → **네임서버 설정**에서 위 2개로 변경
  - 다른 업체(가비아, 닷네임 등)면: 해당 업체의 "도메인 관리 → 네임서버 변경"에서 동일하게 설정

변경 후 반영까지 **몇 시간~24시간** 걸릴 수 있습니다.

### 2-3. Cloudflare DNS에서 카페24로 연결

Cloudflare 대시보드 → **DNS → 레코드**에서:

| 타입 | 이름 | 대상 | 프록시 | 비고 |
|------|------|------|--------|------|
| **A** 또는 **CNAME** | @ 또는 www | 카페24 서버 IP 또는 호스트명 | 주황색 구름(프록시됨) | 루트는 A, www는 CNAME 가능 |

- **카페24 서버 IP**: 호스팅 관리자 또는 카페24 안내에서 확인 (예: "전용 IP" 또는 "서버 주소")
- **호스트명**을 쓰는 경우: 카페24에서 도메인 연결 시 알려주는 주소(예: `xxx.cafe24.com`)가 있으면 CNAME으로 그 주소를 넣을 수 있습니다.

- **@** = `mydomain.com`
- **www** = `www.mydomain.com`

저장 후, 도메인이 Cloudflare를 거쳐 카페24로 연결됩니다.

### 2-4. SSL(https) 설정

- **Cloudflare SSL/TLS** 메뉴에서:
  - 카페24에서 **SSL을 이미 적용**한 경우: **Full** 또는 **Full (Strict)** 로 두면 됩니다.
  - 카페24에 SSL이 없으면: **Flexible** 로 두면 "사용자 ↔ Cloudflare"만 HTTPS가 되고, Cloudflare ↔ 카페24는 HTTP로 연결됩니다.

카페24 쪽에서 무료 SSL(ZeroSSL·Let’s Encrypt 등)을 적용할 수 있으면, 적용 후 Cloudflare는 **Full**로 두는 것을 권장합니다.

---

## 3단계: 카페24에서 도메인 연결 (도메인을 카페24에 연결할 때)

도메인을 **카페24 호스팅에 연결**해서 쓰는 경우:

1. 카페24 **호스팅 관리자** → **도메인 연결** (또는 "나의 서비스 관리" → 호스팅 → 도메인 설정)
2. 사용할 도메인 추가 (예: `mydomain.com`, `www.mydomain.com`)
3. 위 **2단계**에서 Cloudflare DNS를 카페24 서버(IP 또는 호스트명)로 이미 가리켜 두었으므로, 네임서버가 Cloudflare로 바뀐 뒤에는 **Cloudflare → 카페24**로 트래픽이 갑니다.

---

## 요약

| 단계 | 할 일 |
|------|--------|
| 1 | 카페24 **Tomcat JSP 호스팅** 신청, DB 생성, **Consulting.war**를 **ROOT.war**(또는 **www.war**)로 올려 배포 |
| 2 | 도메인 **네임서버**를 **Cloudflare**로 변경 |
| 3 | Cloudflare **DNS**에서 도메인을 **카페24 서버(IP/호스트)** 로 연결 (A 또는 CNAME, 프록시 켜기) |
| 4 | 필요 시 Cloudflare **SSL**은 Flexible/Full 중 선택, 카페24에서 SSL 적용 시 Full 권장 |

이렇게 하면 **카페24에서 앱을 실행**하고, **Cloudflare로 배포(도메인·캐시·보안)** 하는 구성이 됩니다.

---

## GitHub Actions로 푸시 시 자동 배포

`main` 브랜치에 푸시할 때마다 자동으로 Maven 빌드 후 카페24 FTP로 **ROOT.war**를 업로드하도록 설정되어 있습니다.

### 1. GitHub 시크릿 등록 (한 번만)

1. GitHub 저장소 **Consulting** → **Settings** → **Secrets and variables** → **Actions**
2. **New repository secret** 로 아래 4개를 추가합니다.

| Name | 설명 | 예시 |
|------|------|------|
| `CAFE24_FTP_HOST` | FTP 서버 주소 (프로토콜·포트 제외) | `ftp.xxx.cafe24.com` 또는 카페24가 안내한 호스트 |
| `CAFE24_FTP_USERNAME` | FTP 로그인 아이디 | 호스팅 관리자에서 확인한 FTP 아이디 |
| `CAFE24_FTP_PASSWORD` | FTP 비밀번호 | 호스팅 관리자에서 확인한 FTP 비밀번호 |
| `CAFE24_FTP_SERVER_DIR` | WAR를 올릴 원격 경로 | **Tomcat JSP 광호스팅**: `tomcat/webapps` |

- **Tomcat JSP 광호스팅**이면 원격 경로는 보통 `tomcat/webapps` 입니다. (FTP 로그인 후 보이는 기준)
- **일반 JSP 호스팅**이면 홈 디렉터리 등 안내된 경로를 넣고, 워크플로에서 `ROOT.war` 대신 `www.war`로 올리도록 `.github/workflows/cafe24-ftp-deploy.yml` 의 `put` 대상 파일명을 수정할 수 있습니다.

### 2. 동작 방식

- **main** 에 `git push` 하면 워크플로가 실행됩니다.
- **수동 실행**: 저장소 **Actions** 탭 → **Deploy to Cafe24 (FTP)** → **Run workflow**

### 3. 첫 배포 후

- 카페24 권장대로, 배포가 정상 동작하는지 확인한 뒤 **서버의 ROOT.war 파일은 FTP에서 삭제**해 두면 Tomcat 재시작 시 재배포를 막을 수 있습니다. (매 푸시마다 GitHub Actions가 새 ROOT.war를 덮어쓰므로, 평소에는 삭제해 두어도 다음 푸시에서 다시 올라갑니다.)
