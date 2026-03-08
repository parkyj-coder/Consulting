# 카카오톡 상담 기능 사용 가이드

이 프로젝트에는 **카카오톡**과 연동되는 기능이 두 가지 있습니다.

1. **문의하기 화면의 "채팅 시작하기" 버튼** — 고객이 카카오톡 채널/채팅으로 바로 문의
2. **상담 신청 시 관리자 알림** — 상담 신청이 접수되면 관리자에게 카카오톡으로 알림 전송

---

## 1. "채팅 시작하기" 버튼 (카카오 채널/채팅 연결)

홈페이지 **문의하기** 섹션의 **채팅 시작하기** 버튼을 누르면, 고객이 카카오톡 채널 또는 1:1 채팅으로 이동하도록 할 수 있습니다.

### 1-1. 수정할 파일

- `src/main/webapp/js/script.js` — `openKakaoChat()` 함수 안의 주소·전화번호

### 1-2. 설정 방법

**방법 A: 카카오톡 채널 사용 (권장)**

1. [카카오 비즈니스](https://business.kakao.com)에서 **카카오톡 채널**을 개설합니다.
2. 채널 관리 페이지에서 **채널 URL**을 확인합니다. (예: `https://pf.kakao.com/_xXXXXXXX`)
3. `script.js`에서 아래 부분을 실제 채널 주소로 바꿉니다.

```javascript
// script.js 내 openKakaoChat() 함수
const kakaoChannelUrl = 'https://pf.kakao.com/_your_channel_id'; // 여기를 실제 채널 URL로 변경
```

- **모바일**: 채널 링크로 이동 (채널 채팅 또는 채널 홈으로 연결 가능).
- **PC**: 위 URL을 새 탭으로 열어 채널 페이지로 이동합니다.

**방법 B: 전화번호로 1:1 채팅 연결 (모바일)**

- 카카오톡 앱에서 전화번호로 연락할 수 있는 경우, 해당 번호를 넣어 앱 채팅으로 띄울 수 있습니다.
- `script.js`에서 전화번호(하이픈 제외)를 설정합니다.

```javascript
const phoneNumber = '0212345678'; // 실제 문의용 전화번호로 변경 (하이픈 없이)
```

- 모바일에서는 `kakaotalk://open?url=chat&phone=전화번호` 로 앱이 열리고, 앱이 없으면 일정 시간 후 위 `kakaoChannelUrl` 로 이동합니다.

### 1-3. 동작 정리

| 환경     | 동작 |
|----------|------|
| 모바일   | 카카오톡 앱 채팅 실행 시도 → 실패 시 채널 URL로 이동 |
| 데스크톱 | 채널 URL을 새 창/탭으로 열기 |

---

## 2. 상담 신청 시 관리자 카카오톡 알림

고객이 **상담 신청** 폼을 제출하면, DB에 저장된 **활성 관리자**에게 카카오톡으로 알림이 전송됩니다.

### 2-1. 사용 API

- **카카오 메시지 API**  
  - URL: `https://kapi.kakao.com/v2/api/talk/memo/default/send`  
  - 상담 신청 시 **회사명, 신청자명, 연락처**가 포함된 메시지가 전송됩니다.

### 2-2. 설정 파일

- `src/main/java/kakao.properties` (커밋되지 않음)
- 예시: `src/main/java/kakao.properties.example` 를 복사한 뒤 값을 채웁니다.

```bash
# 프로젝트 루트 또는 src/main/java 기준
cp src/main/java/kakao.properties.example src/main/java/kakao.properties
```

### 2-3. kakao.properties 항목 설명

| 키 | 설명 | 예시 |
|----|------|------|
| `kakao.api.url` | 카카오 메시지 API URL (변경 없이 사용 가능) | `https://kapi.kakao.com/v2/api/talk/memo/default/send` |
| `kakao.api.key` | **카카오 앱 액세스 토큰** (필수) | 개발자 콘솔에서 발급 |
| `kakao.admin.phone` | 관리자 연락처 (참고용) | `010-0000-0000` |
| `kakao.admin.name` | 관리자 이름 (참고용) | `관리자` |
| `kakao.template.id` | 알림톡 템플릿 ID (선택, 현재 코드는 텍스트 메시지 사용) | `YOUR_TEMPLATE_ID` |
| `kakao.template.name` | 템플릿 이름 (참고용) | `상담신청알림` |
| `kakao.message.enabled` | 알림 사용 여부 (`true` / `false`) | `true` |
| `kakao.message.sender` | 메시지에 표시되는 발신자 이름 | `한국미래 중소기업 경영컨설팅` |

### 2-4. 카카오 API 키(토큰) 발급 절차

1. **카카오 개발자 사이트**  
   - [developers.kakao.com](https://developers.kakao.com) 로그인 후 **내 애플리케이션**에서 앱을 추가합니다.

2. **앱 설정**  
   - **앱 키**에서 **REST API 키**를 확인합니다.  
   - **카카오 로그인** 등 필요한 API를 사용 설정합니다.  
   - **메시지** / **나에게 보내기** 등 메시지 관련 API가 사용 가능한지 확인합니다.

3. **토큰 발급**  
   - **도구** → **토큰 관리** 또는 API 문서에 안내된 방법으로 **액세스 토큰**을 발급합니다.  
   - `kakao.api.key` 에는 이 **액세스 토큰**을 넣습니다. (REST API 키가 아니라 **토큰**입니다.)  
   - 토큰 유효 기간이 있으므로, 만료 시 재발급 후 `kakao.properties` 를 수정해야 합니다.

4. **kakao.properties 저장**  
   - `kakao.api.key` 를 발급받은 토큰으로 저장하고, `kakao.message.enabled=true` 로 두면 상담 신청 시 알림이 동작합니다.

### 2-5. 알림 수신 대상

- **DB에 등록된 관리자** 중 **활성(active)** 인 계정으로 전송됩니다.
- 관리자 목록/활성 여부는 `Admin` 테이블 및 관리자 관리 기능에서 설정합니다.
- 현재 코드는 **동일한 API(토큰)** 로 메시지를 보내므로, 실제 수신 대상은 카카오 API 정책(나에게 보내기 등)에 따릅니다. 관리자별로 다른 계정에 보내려면 카카오 API 문서에 맞게 발신 로직을 확장해야 할 수 있습니다.

### 2-6. 알림 끄기

- `kakao.message.enabled=false` 로 두면 상담 신청은 그대로 DB에만 저장되고, 카카오톡 알림은 나가지 않습니다.

---

## 3. 체크리스트 요약

### "채팅 시작하기" 버튼

- [ ] `script.js` 의 `kakaoChannelUrl` 을 실제 카카오톡 채널 URL로 변경
- [ ] (선택) 전화번호로 채팅 열기 사용 시 `phoneNumber` 를 실제 번호로 변경

### 상담 신청 알림

- [ ] `kakao.properties.example` → `kakao.properties` 복사
- [ ] 카카오 개발자 콘솔에서 앱 생성 및 메시지 API 사용 설정
- [ ] 액세스 토큰 발급 후 `kakao.api.key` 에 입력
- [ ] `kakao.message.enabled=true` 로 설정
- [ ] `kakao.message.sender` 등 필요 시 수정
- [ ] 서버 재시작 후 상담 신청 테스트

---

## 4. 참고 링크

- [카카오 개발자 콘솔](https://developers.kakao.com)
- [카카오톡 채널 소개](https://business.kakao.com/info/channel/)
- [카카오 메시지 API 문서](https://developers.kakao.com/docs/latest/ko/message/rest-api) (실제 사용 중인 API 버전에 맞는 문서 참고)
