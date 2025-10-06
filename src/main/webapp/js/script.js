// 가로보기 방지
function preventLandscape() {
    if (window.orientation === 90 || window.orientation === -90) {
        // 가로보기 감지 시 세로보기로 강제 전환
        if (screen.orientation && screen.orientation.lock) {
            screen.orientation.lock('portrait').catch(function(error) {
                console.log('Orientation lock failed:', error);
            });
        }
        
        // 가로보기 경고 메시지 표시
        const warningDiv = document.createElement('div');
        warningDiv.id = 'landscape-warning';
        warningDiv.innerHTML = `
            <div style="
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.9);
                color: white;
                display: flex;
                flex-direction: row;
                justify-content: center;
                align-items: center;
                z-index: 9999;
                text-align: center;
                padding: 20px;
                font-family: 'Noto Sans KR', sans-serif;
            ">
                <div style="
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    max-width: 80%;
                ">
                    <i class="fas fa-mobile-alt" style="font-size: 3rem; margin-bottom: 1rem;"></i>
                    <h2 style="margin-bottom: 1rem; font-size: 1.5rem;">세로보기로 전환해주세요</h2>
                    <p style="font-size: 1rem; line-height: 1.4; margin-bottom: 1.5rem;">
                        이 웹사이트는 세로보기에서 최적화되어 있습니다.<br>
                        기기를 세로로 돌려주세요.
                    </p>
                    <button id="close-landscape-warning" style="
                        background: #3182ce;
                        color: white;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 6px;
                        font-size: 0.9rem;
                        font-weight: 500;
                        cursor: pointer;
                        transition: background 0.3s ease;
                    " onmouseover="this.style.background='#2c5282'" onmouseout="this.style.background='#3182ce'">
                        알겠습니다
                    </button>
                </div>
            </div>
        `;
        document.body.appendChild(warningDiv);
        
        // 닫기 버튼 이벤트 리스너 추가
        const closeButton = document.getElementById('close-landscape-warning');
        if (closeButton) {
            closeButton.addEventListener('click', function() {
                const warningDiv = document.getElementById('landscape-warning');
                if (warningDiv) {
                    warningDiv.remove();
                }
            });
        }
    } else {
        // 세로보기일 때 경고 메시지 제거
        const warningDiv = document.getElementById('landscape-warning');
        if (warningDiv) {
            warningDiv.remove();
        }
    }
}

// 카카오톡 인앱 브라우저 감지
function detectKakaoInApp() {
    const userAgent = navigator.userAgent.toLowerCase();
    const isKakao = userAgent.indexOf('kakaotalk') > -1;
    
    if (isKakao) {
        document.body.classList.add('kakao-inapp');
        console.log('카카오톡 인앱 브라우저 감지됨');
        
        // 카카오톡에서 추가 최적화
        optimizeForKakao();
    }
    
    return isKakao;
}

// 카카오톡 인앱 브라우저 최적화
function optimizeForKakao() {
    // 스크롤 성능 최적화
    document.body.style.webkitOverflowScrolling = 'touch';
    
    // 터치 이벤트 최적화
    document.addEventListener('touchstart', function() {}, { passive: true });
    document.addEventListener('touchmove', function() {}, { passive: true });
    
    // 모달 스크롤 최적화
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        modal.style.webkitOverflowScrolling = 'touch';
    });
    
    // 폼 입력 최적화
    const inputs = document.querySelectorAll('input, textarea, select');
    inputs.forEach(input => {
        input.style.webkitAppearance = 'none';
        input.style.borderRadius = '0';
    });
}

// DOM이 로드된 후 실행
document.addEventListener('DOMContentLoaded', function() {
    // 카카오톡 인앱 브라우저 감지
    detectKakaoInApp();
    
    // 모바일 메뉴 토글
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');

    // 클릭과 터치 이벤트 모두 지원
    hamburger.addEventListener('click', toggleMobileMenu);
    hamburger.addEventListener('touchend', function(e) {
        e.preventDefault();
        toggleMobileMenu();
    });

    function toggleMobileMenu() {
        hamburger.classList.toggle('active');
        navMenu.classList.toggle('active');
    }

    // 메뉴 링크 클릭 시 해당 섹션으로 스크롤하고 모바일 메뉴 닫기
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // 모바일 메뉴 닫기
            hamburger.classList.remove('active');
            navMenu.classList.remove('active');
            
            // 해당 섹션으로 스크롤
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                const headerHeight = document.querySelector('.header').offsetHeight;
                const targetPosition = targetSection.offsetTop - headerHeight;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
        
        // 터치 이벤트도 지원
        link.addEventListener('touchend', function(e) {
            e.preventDefault();
            
            // 모바일 메뉴 닫기
            hamburger.classList.remove('active');
            navMenu.classList.remove('active');
            
            // 해당 섹션으로 스크롤
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                const headerHeight = document.querySelector('.header').offsetHeight;
                const targetPosition = targetSection.offsetTop - headerHeight;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });

    // 모바일에서 스와이프로 메뉴 닫기
    let touchStartX = 0;
    let touchEndX = 0;

    document.addEventListener('touchstart', function(e) {
        touchStartX = e.changedTouches[0].screenX;
    });

    document.addEventListener('touchend', function(e) {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    });

    function handleSwipe() {
        const swipeThreshold = 50;
        const swipeDistance = touchEndX - touchStartX;
        
        // 왼쪽으로 스와이프하면 메뉴 닫기
        if (swipeDistance < -swipeThreshold && navMenu.classList.contains('active')) {
            hamburger.classList.remove('active');
            navMenu.classList.remove('active');
        }
    }

    // 가로보기 방지 이벤트 리스너
    window.addEventListener('orientationchange', preventLandscape);
    window.addEventListener('resize', preventLandscape);
    
    // 초기 로드 시에도 체크
    preventLandscape();
    
    // 스크롤 스냅 개선 - 헤더가 섹션 안으로 들어오도록
    let isScrolling = false;
    let scrollTimeout;
    let lastScrollTop = 0;
    
    window.addEventListener('scroll', function() {
        const currentScrollTop = window.scrollY;
        const scrollDirection = currentScrollTop > lastScrollTop ? 'down' : 'up';
        lastScrollTop = currentScrollTop;
        
        if (!isScrolling) {
            isScrolling = true;
        }
        
        clearTimeout(scrollTimeout);
        scrollTimeout = setTimeout(function() {
            isScrolling = false;
            
            // 스크롤이 멈춘 후 자연스러운 스냅 적용
            const sections = document.querySelectorAll('section, .hero, .footer');
            const headerHeight = document.querySelector('.header').offsetHeight;
            const scrollPosition = window.scrollY + headerHeight + window.innerHeight / 2;
            let closestSection = null;
            let minDistance = Infinity;
            
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionCenter = sectionTop + section.offsetHeight / 2;
                
                // 현재 스크롤 위치와 섹션 중심점의 거리 계산
                const distance = Math.abs(scrollPosition - sectionCenter);
                
                if (distance < minDistance) {
                    minDistance = distance;
                    closestSection = section;
                }
            });
            
            // 충분히 가까운 섹션이 있을 때만 스냅 적용
            if (closestSection && minDistance < window.innerHeight / 2) {
                const targetPosition = closestSection.offsetTop;
                
                // 현재 위치와 목표 위치의 차이가 충분할 때만 스크롤
                if (Math.abs(currentScrollTop - targetPosition) > 50) {
                    window.scrollTo({
                        top: targetPosition,
                        behavior: 'smooth'
                    });
                }
            }
        }, 300); // 스냅 지연 시간을 늘려서 더 자연스럽게
    });

    // 헤더를 항상 투명하게 유지
    window.addEventListener('scroll', function() {
        const header = document.querySelector('.header');
        // 헤더 배경을 항상 투명하게 유지
        header.style.background = 'transparent';
        header.style.boxShadow = 'none';
    });

    // 스크롤 애니메이션
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('revealed');
            }
        });
    }, observerOptions);

    // 애니메이션 대상 요소들 관찰
    document.querySelectorAll('.service-card, .contact-item, .stat-item').forEach(el => {
        el.classList.add('scroll-reveal');
        observer.observe(el);
    });

    // 메인 섹션과 서비스 섹션 애니메이션
    const sectionObserverOptions = {
        threshold: 0.3,
        rootMargin: '0px 0px -100px 0px'
    };

    const sectionObserver = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // 메인 섹션 애니메이션
                if (entry.target.id === 'home') {
                    const heroContent = entry.target.querySelector('.hero-content');
                    const heroTitle = entry.target.querySelector('.hero-title');
                    const heroSubtitle = entry.target.querySelector('.hero-subtitle');
                    const heroButtons = entry.target.querySelector('.hero-buttons');
                    
                    if (heroContent) heroContent.classList.add('animate');
                    if (heroTitle) heroTitle.classList.add('animate');
                    if (heroSubtitle) heroSubtitle.classList.add('animate');
                    if (heroButtons) heroButtons.classList.add('animate');
                }
                
                // 서비스 섹션 애니메이션
                if (entry.target.id === 'services') {
                    const servicesGrid = entry.target.querySelector('.services-grid');
                    const serviceCards = entry.target.querySelectorAll('.service-card');
                    
                    if (servicesGrid) servicesGrid.classList.add('animate');
                    serviceCards.forEach(card => {
                        card.classList.add('animate');
                    });
                }
                
                // 회사소개 섹션 애니메이션
                if (entry.target.id === 'about') {
                    const aboutText = entry.target.querySelector('.about-text');
                    const aboutTitle = entry.target.querySelector('.about-text h2');
                    const aboutParagraph = entry.target.querySelector('.about-text p');
                    const stats = entry.target.querySelectorAll('.stat-item');
                    
                    if (aboutText) aboutText.classList.add('animate');
                    if (aboutTitle) aboutTitle.classList.add('animate');
                    if (aboutParagraph) aboutParagraph.classList.add('animate');
                    stats.forEach((stat, index) => {
                        setTimeout(() => {
                            stat.classList.add('animate');
                        }, index * 200);
                    });
                }
                
                // 채용 섹션 애니메이션
                if (entry.target.id === 'careers') {
                    const careersText = entry.target.querySelector('.careers-text');
                    const careersTitle = entry.target.querySelector('.careers-text h2');
                    const careersParagraph = entry.target.querySelector('.careers-text p');
                    const careersButton = entry.target.querySelector('.careers-text .btn');
                    const careersVisual = entry.target.querySelector('.careers-visual');
                    
                    if (careersText) careersText.classList.add('animate');
                    if (careersTitle) careersTitle.classList.add('animate');
                    if (careersParagraph) careersParagraph.classList.add('animate');
                    if (careersButton) careersButton.classList.add('animate');
                    if (careersVisual) careersVisual.classList.add('animate');
                }
            } else {
                // 화면에서 벗어나면 애니메이션 클래스 제거
                if (entry.target.id === 'home') {
                    const heroContent = entry.target.querySelector('.hero-content');
                    const heroTitle = entry.target.querySelector('.hero-title');
                    const heroSubtitle = entry.target.querySelector('.hero-subtitle');
                    const heroButtons = entry.target.querySelector('.hero-buttons');
                    
                    if (heroContent) heroContent.classList.remove('animate');
                    if (heroTitle) heroTitle.classList.remove('animate');
                    if (heroSubtitle) heroSubtitle.classList.remove('animate');
                    if (heroButtons) heroButtons.classList.remove('animate');
                }
                
                if (entry.target.id === 'services') {
                    const servicesGrid = entry.target.querySelector('.services-grid');
                    const serviceCards = entry.target.querySelectorAll('.service-card');
                    
                    if (servicesGrid) servicesGrid.classList.remove('animate');
                    serviceCards.forEach(card => {
                        card.classList.remove('animate');
                    });
                }
                
                if (entry.target.id === 'about') {
                    const aboutText = entry.target.querySelector('.about-text');
                    const aboutTitle = entry.target.querySelector('.about-text h2');
                    const aboutParagraph = entry.target.querySelector('.about-text p');
                    const stats = entry.target.querySelectorAll('.stat-item');
                    
                    if (aboutText) aboutText.classList.remove('animate');
                    if (aboutTitle) aboutTitle.classList.remove('animate');
                    if (aboutParagraph) aboutParagraph.classList.remove('animate');
                    stats.forEach(stat => {
                        stat.classList.remove('animate');
                    });
                }
                
                if (entry.target.id === 'careers') {
                    const careersText = entry.target.querySelector('.careers-text');
                    const careersTitle = entry.target.querySelector('.careers-text h2');
                    const careersParagraph = entry.target.querySelector('.careers-text p');
                    const careersButton = entry.target.querySelector('.careers-text .btn');
                    const careersVisual = entry.target.querySelector('.careers-visual');
                    
                    if (careersText) careersText.classList.remove('animate');
                    if (careersTitle) careersTitle.classList.remove('animate');
                    if (careersParagraph) careersParagraph.classList.remove('animate');
                    if (careersButton) careersButton.classList.remove('animate');
                    if (careersVisual) careersVisual.classList.remove('animate');
                }
            }
        });
    }, sectionObserverOptions);

    // 메인 섹션과 서비스 섹션, 회사소개 섹션, 채용 섹션 관찰
    const homeSection = document.getElementById('home');
    const servicesSection = document.getElementById('services');
    const aboutSection = document.getElementById('about');
    const careersSection = document.getElementById('careers');
    
    if (homeSection) sectionObserver.observe(homeSection);
    if (servicesSection) sectionObserver.observe(servicesSection);
    if (aboutSection) sectionObserver.observe(aboutSection);
    if (careersSection) sectionObserver.observe(careersSection);

    // 폼 제출 이벤트 리스너
    setupFormHandlers();
});

// 모달 관련 함수들
function openConsultingModal(type) {
    const modalId = type === 'corporate' ? 'corporateModal' : 'personalModal';
    const modal = document.getElementById(modalId);
    modal.style.display = 'block';
    document.body.style.overflow = 'hidden';
    
    // 모달이 열린 후 스크롤을 맨 위로 이동
    const modalContent = modal.querySelector('.modal-content');
    if (modalContent) {
        modalContent.scrollTop = 0;
    }
}

function openCareerModal() {
    const modal = document.getElementById('careerModal');
    modal.style.display = 'block';
    document.body.style.overflow = 'hidden';
    
    // 모달이 열린 후 스크롤을 맨 위로 이동
    const modalContent = modal.querySelector('.modal-content');
    if (modalContent) {
        modalContent.scrollTop = 0;
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

// 카카오톡 채팅 열기 함수
function openKakaoChat() {
    // 방법 1: 카카오톡 채널 링크 (실제 채널 URL로 변경 필요)
    const kakaoChannelUrl = 'https://pf.kakao.com/_your_channel_id'; // 실제 채널 URL로 변경
    
    // 방법 2: 카카오톡 앱으로 직접 채팅 (전화번호 기반)
    const phoneNumber = '0212345678'; // 전화번호 (하이픈 제거)
    const kakaoChatUrl = `kakaotalk://open?url=chat&phone=${phoneNumber}`;
    
    // 모바일에서는 카카오톡 앱으로, 데스크톱에서는 채널로 이동
    if (/Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        // 모바일: 카카오톡 앱으로 이동 시도
        window.location.href = kakaoChatUrl;
        
        // 앱이 설치되지 않은 경우를 대비해 3초 후 채널 페이지로 이동
        setTimeout(() => {
            window.location.href = kakaoChannelUrl;
        }, 3000);
    } else {
        // 데스크톱: 채널 페이지로 이동
        window.open(kakaoChannelUrl, '_blank');
    }
}

// 모달 외부 클릭 시 닫기
window.addEventListener('click', function(event) {
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        if (event.target === modal) {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }
    });
});

// ESC 키로 모달 닫기
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            if (modal.style.display === 'block') {
                modal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        });
    }
});

// 폼 핸들러 설정
function setupFormHandlers() {
    // 기업 컨설팅 폼
    const corporateForm = document.getElementById('corporateForm');
    if (corporateForm) {
        corporateForm.addEventListener('submit', function(e) {
            e.preventDefault();
            handleFormSubmission(this, '기업 컨설팅');
        });
    }

    // 개인 컨설팅 폼
    const personalForm = document.getElementById('personalForm');
    if (personalForm) {
        personalForm.addEventListener('submit', function(e) {
            e.preventDefault();
            handleFormSubmission(this, '개인 컨설팅');
        });
    }

    // 입사 지원 폼
    const careerForm = document.getElementById('careerForm');
    if (careerForm) {
        careerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            handleFormSubmission(this, '입사 지원');
        });
    }
}

// 폼 제출 처리
function handleFormSubmission(form, formType) {
    const formData = new FormData(form);
    
    // 디버깅: 폼 데이터 확인
    console.log("=== 폼 데이터 디버깅 ===");
    for (let [key, value] of formData.entries()) {
        console.log(key + ": " + value);
    }
    console.log("========================");
    
    // 유효성 검사
    if (!validateForm(formData, formType)) {
        return;
    }

    // 로딩 상태 표시
    const submitButton = form.querySelector('button[type="submit"]');
    const originalText = submitButton.textContent;
    submitButton.textContent = '처리 중...';
    submitButton.disabled = true;

    // FormData를 URLSearchParams로 변환
    const urlSearchParams = new URLSearchParams();
    for (let [key, value] of formData.entries()) {
        urlSearchParams.append(key, value);
    }
    
    console.log("전송할 데이터:", urlSearchParams.toString());
    
    // 서버로 데이터 전송
    fetch('consultationProcess.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: urlSearchParams.toString()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showSuccessMessage(formType, data.message);
            form.reset();
            
            // 모달 닫기
            const modal = form.closest('.modal');
            if (modal) {
                closeModal(modal.id);
            }
        } else {
            showErrorMessage(data.message || '상담신청 처리 중 오류가 발생했습니다.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showErrorMessage('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    })
    .finally(() => {
        submitButton.textContent = originalText;
        submitButton.disabled = false;
    });
}

// 폼 유효성 검사
function validateForm(formData, formType) {
    const requiredFields = {
        '기업 컨설팅': ['companyName', 'businessNumber', 'contactName', 'phone', 'address', 'detailAddress', 'industry', 'privacyAgreement'],
        '개인 컨설팅': ['name', 'phone', 'email', 'serviceType'],
        '입사 지원': ['name', 'phone', 'email', 'position']
    };

    const fields = requiredFields[formType];
    
    for (let field of fields) {
        const value = formData.get(field);
        // 체크박스의 경우 특별 처리
        if (field === 'privacyAgreement') {
            if (!value) {
                showErrorMessage('개인정보 수집 및 이용에 동의해주세요.');
                return false;
            }
        } else {
            if (!value || value.trim() === '') {
                showErrorMessage(`${getFieldLabel(field)}을(를) 입력해주세요.`);
                return false;
            }
        }
    }

    // 전화번호 형식 검사
    const phone = formData.get('phone');
    if (phone && !isValidPhone(phone)) {
        showErrorMessage('올바른 전화번호 형식을 입력해주세요.');
        return false;
    }
    
    // 사업자번호 형식 검사
    const businessNumber = formData.get('businessNumber');
    if (businessNumber && !isValidBusinessNumber(businessNumber)) {
        showErrorMessage('올바른 사업자번호 형식을 입력해주세요. (예: 123-45-67890)');
        return false;
    }

    return true;
}

// 사업자번호 형식 검사
function isValidBusinessNumber(businessNumber) {
    const pattern = /^\d{3}-\d{2}-\d{5}$/;
    return pattern.test(businessNumber);
}

// 필드 라벨 가져오기
function getFieldLabel(fieldName) {
    const labels = {
        'companyName': '기업명',
        'businessNumber': '사업자번호',
        'contactName': '신청자 성명',
        'address': '주소',
        'detailAddress': '상세주소',
        'industry': '업종',
        'privacyAgreement': '개인정보 동의',
        'contactName': '담당자명',
        'name': '이름',
        'phone': '연락처',
        'email': '이메일',
        'serviceType': '서비스 유형',
        'position': '지원 직무'
    };
    return labels[fieldName] || fieldName;
}

// 이메일 유효성 검사
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// 전화번호 유효성 검사
function isValidPhone(phone) {
    const phoneRegex = /^[0-9-+\s()]+$/;
    return phoneRegex.test(phone) && phone.replace(/[^0-9]/g, '').length >= 10;
}

// 성공 메시지 표시
function showSuccessMessage(formType, customMessage = null) {
    const messages = {
        '기업 컨설팅': '자금상담신청이 완료되었습니다. 빠른 시일 내에 연락드리겠습니다.',
        '개인 컨설팅': '개인 컨설팅 상담 신청이 완료되었습니다. 빠른 시일 내에 연락드리겠습니다.',
        '입사 지원': '입사 지원이 완료되었습니다. 검토 후 연락드리겠습니다.'
    };

    const message = customMessage || messages[formType];
    showNotification(message, 'success');
}

// 에러 메시지 표시
function showErrorMessage(message) {
    showNotification(message, 'error');
}

// 알림 표시
function showNotification(message, type) {
    // 기존 알림 제거
    const existingNotification = document.querySelector('.notification');
    if (existingNotification) {
        existingNotification.remove();
    }

    // 새 알림 생성
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <span class="notification-message">${message}</span>
            <button class="notification-close" onclick="this.parentElement.parentElement.remove()">&times;</button>
        </div>
    `;

    // 스타일 적용
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? '#48bb78' : '#f56565'};
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 8px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        z-index: 3000;
        max-width: 400px;
        animation: slideInRight 0.3s ease;
    `;

    // 알림 내용 스타일
    const content = notification.querySelector('.notification-content');
    content.style.cssText = `
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 1rem;
    `;

    // 닫기 버튼 스타일
    const closeBtn = notification.querySelector('.notification-close');
    closeBtn.style.cssText = `
        background: none;
        border: none;
        color: white;
        font-size: 1.5rem;
        cursor: pointer;
        padding: 0;
        line-height: 1;
    `;

    // 애니메이션 스타일 추가
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
    `;
    document.head.appendChild(style);

    document.body.appendChild(notification);

    // 5초 후 자동 제거
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// 부드러운 스크롤 (네비게이션 링크 외의 다른 링크들)
document.querySelectorAll('a[href^="#"]:not(.nav-link)').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const targetId = this.getAttribute('href');
        const target = document.querySelector(targetId);
        
        if (target) {
            const headerHeight = document.querySelector('.header').offsetHeight;
            const targetPosition = target.offsetTop - headerHeight;
            
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// 모바일 최적화
function optimizeForMobile() {
    const isMobile = window.innerWidth <= 768;
    
    // 모바일에서 터치 이벤트 최적화
    if (isMobile) {
        // 터치 지연 제거
        document.body.style.touchAction = 'manipulation';
        
        // 더블 탭 줌 방지
        let lastTouchEnd = 0;
        document.addEventListener('touchend', function (event) {
            const now = (new Date()).getTime();
            if (now - lastTouchEnd <= 300) {
                event.preventDefault();
            }
            lastTouchEnd = now;
        }, false);
    }
}

// 화면 크기 변경 시 최적화 적용
window.addEventListener('resize', optimizeForMobile);
optimizeForMobile(); // 초기 로드 시에도 적용

// 숫자 카운터 애니메이션
function animateCounter(element, target, duration = 2000) {
    let start = 0;
    const increment = target / (duration / 16);
    
    function updateCounter() {
        start += increment;
        if (start < target) {
            element.textContent = Math.floor(start) + '+';
            requestAnimationFrame(updateCounter);
        } else {
            element.textContent = target + '+';
        }
    }
    
    updateCounter();
}

// 통계 숫자 애니메이션 (스크롤 시마다 실행)
const statObserver = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const statNumber = entry.target.querySelector('h3');
            const statText = entry.target.querySelector('p');
            
            // 텍스트를 먼저 보이게 함
            if (statText) {
                statText.style.opacity = '1';
                statText.style.transform = 'translateY(0)';
            }
            
            // 숫자 애니메이션 실행
            const target = parseInt(statNumber.textContent);
            animateCounter(statNumber, target);
        }
    });
}, { threshold: 0.3 });

document.querySelectorAll('.stat-item').forEach(stat => {
    statObserver.observe(stat);
});

// 파일 업로드 미리보기 (입사 지원 폼)
const resumeInput = document.getElementById('careerResume');
if (resumeInput) {
    resumeInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            // 파일 크기 검사 (5MB 제한)
            if (file.size > 5 * 1024 * 1024) {
                showErrorMessage('파일 크기는 5MB 이하여야 합니다.');
                this.value = '';
                return;
            }

            // 파일 형식 검사
            const allowedTypes = ['.pdf', '.doc', '.docx'];
            const fileName = file.name.toLowerCase();
            const isValidType = allowedTypes.some(type => fileName.endsWith(type));
            
            if (!isValidType) {
                showErrorMessage('PDF, DOC, DOCX 파일만 업로드 가능합니다.');
                this.value = '';
                return;
            }

            showNotification(`파일 "${file.name}"이(가) 선택되었습니다.`, 'success');
        }
    });
}

// ===== 반응형 디자인 JavaScript 기능 =====

// 모바일 네비게이션 토글
function toggleMobileMenu() {
    const navMenu = document.querySelector('.nav-menu');
    const hamburger = document.querySelector('.hamburger');
    
    if (navMenu && hamburger) {
        navMenu.classList.toggle('active');
        hamburger.classList.toggle('active');
        
        // body 스크롤 방지/허용
        if (navMenu.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = '';
        }
    }
}

// 화면 크기 변경 감지 및 처리
function handleResize() {
    const navMenu = document.querySelector('.nav-menu');
    const hamburger = document.querySelector('.hamburger');
    
    if (window.innerWidth > 768) {
        // 데스크톱에서는 모바일 메뉴 닫기
        if (navMenu && hamburger) {
            navMenu.classList.remove('active');
            hamburger.classList.remove('active');
            document.body.style.overflow = '';
        }
    }
}

// 터치 이벤트 처리 (모바일 최적화)
function handleTouchEvents() {
    const navMenu = document.querySelector('.nav-menu');
    
    if (navMenu) {
        // 터치 스와이프로 메뉴 닫기
        let startX = 0;
        let startY = 0;
        
        navMenu.addEventListener('touchstart', function(e) {
            startX = e.touches[0].clientX;
            startY = e.touches[0].clientY;
        });
        
        navMenu.addEventListener('touchmove', function(e) {
            if (!startX || !startY) return;
            
            const diffX = startX - e.touches[0].clientX;
            const diffY = startY - e.touches[0].clientY;
            
            // 오른쪽으로 스와이프하면 메뉴 닫기
            if (Math.abs(diffX) > Math.abs(diffY) && diffX < -50) {
                toggleMobileMenu();
            }
        });
    }
}

// 모바일에서 메뉴 링크 클릭 시 자동 닫기
function setupMobileMenuLinks() {
    const navLinks = document.querySelectorAll('.nav-link');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            if (window.innerWidth <= 768) {
                toggleMobileMenu();
            }
        });
    });
}

// 모바일에서 모달 외부 클릭 시 닫기
function setupMobileModalClose() {
    const modals = document.querySelectorAll('.modal');
    
    modals.forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeModal(modal.id);
            }
        });
    });
}

// 터치 친화적 스크롤 처리
function setupTouchScroll() {
    // iOS에서 부드러운 스크롤
    if (navigator.userAgent.match(/iPhone|iPad|iPod/i)) {
        document.body.style.webkitOverflowScrolling = 'touch';
    }
    
    // 모바일에서 스크롤 성능 최적화
    let ticking = false;
    
    function updateScroll() {
        // 스크롤 이벤트 처리
        ticking = false;
    }
    
    function requestTick() {
        if (!ticking) {
            requestAnimationFrame(updateScroll);
            ticking = true;
        }
    }
    
    window.addEventListener('scroll', requestTick, { passive: true });
}

// 모바일 키보드 처리
function handleMobileKeyboard() {
    const inputs = document.querySelectorAll('input, textarea');
    
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            // iOS에서 키보드가 올라올 때 뷰포트 조정
            if (window.innerWidth <= 768) {
                setTimeout(() => {
                    this.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }, 300);
            }
        });
    });
}

// 디바이스 방향 변경 처리
function handleOrientationChange() {
    window.addEventListener('orientationchange', function() {
        setTimeout(() => {
            // 방향 변경 후 레이아웃 재조정
            handleResize();
        }, 100);
    });
}

// 네트워크 상태 감지
function handleNetworkStatus() {
    function updateOnlineStatus() {
        if (navigator.onLine) {
            console.log('온라인 상태');
        } else {
            showErrorMessage('인터넷 연결이 끊어졌습니다. 연결을 확인해주세요.');
        }
    }
    
    window.addEventListener('online', updateOnlineStatus);
    window.addEventListener('offline', updateOnlineStatus);
}

// 성능 최적화: 지연 로딩
function setupLazyLoading() {
    const images = document.querySelectorAll('img[data-src]');
    
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.remove('lazy');
                    imageObserver.unobserve(img);
                }
            });
        });
        
        images.forEach(img => imageObserver.observe(img));
    }
}

// 접근성 개선
function setupAccessibility() {
    // 키보드 네비게이션
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            // ESC 키로 모달 닫기
            const openModal = document.querySelector('.modal[style*="block"]');
            if (openModal) {
                closeModal(openModal.id);
            }
            
            // ESC 키로 모바일 메뉴 닫기
            const navMenu = document.querySelector('.nav-menu.active');
            if (navMenu) {
                toggleMobileMenu();
            }
        }
    });
    
    // 포커스 관리
    const focusableElements = 'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])';
    
    function trapFocus(element) {
        const focusableContent = element.querySelectorAll(focusableElements);
        const firstFocusableElement = focusableContent[0];
        const lastFocusableElement = focusableContent[focusableContent.length - 1];
        
        element.addEventListener('keydown', function(e) {
            if (e.key === 'Tab') {
                if (e.shiftKey) {
                    if (document.activeElement === firstFocusableElement) {
                        lastFocusableElement.focus();
                        e.preventDefault();
                    }
                } else {
                    if (document.activeElement === lastFocusableElement) {
                        firstFocusableElement.focus();
                        e.preventDefault();
                    }
                }
            }
        });
    }
    
    // 모달에 포커스 트랩 적용
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => trapFocus(modal));
}

// 초기화 함수
function initResponsiveFeatures() {
    // 이벤트 리스너 등록
    window.addEventListener('resize', handleResize);
    
    // 햄버거 메뉴 클릭 이벤트
    const hamburger = document.querySelector('.hamburger');
    if (hamburger) {
        hamburger.addEventListener('click', toggleMobileMenu);
    }
    
    // 터치 이벤트 설정
    handleTouchEvents();
    
    // 모바일 메뉴 링크 설정
    setupMobileMenuLinks();
    
    // 모바일 모달 설정
    setupMobileModalClose();
    
    // 터치 스크롤 설정
    setupTouchScroll();
    
    // 모바일 키보드 처리
    handleMobileKeyboard();
    
    // 방향 변경 처리
    handleOrientationChange();
    
    // 네트워크 상태 처리
    handleNetworkStatus();
    
    // 지연 로딩 설정
    setupLazyLoading();
    
    // 접근성 설정
    setupAccessibility();
    
    console.log('반응형 기능이 초기화되었습니다.');
}

// DOM 로드 완료 후 초기화
document.addEventListener('DOMContentLoaded', function() {
    initResponsiveFeatures();
});

// 페이지 로드 완료 후 추가 초기화
window.addEventListener('load', function() {
    // 성능 모니터링
    if ('performance' in window) {
        const loadTime = performance.timing.loadEventEnd - performance.timing.navigationStart;
        console.log(`페이지 로드 시간: ${loadTime}ms`);
    }
    
    // 자동 포맷팅 기능 초기화
    initAutoFormatting();
    
    // 주소 검색 기능 초기화
    initAddressSearch();
});

// ===== 자동 포맷팅 기능 =====

// 전화번호 자동 포맷팅
function formatPhoneNumber(input) {
    let value = input.value.replace(/\D/g, ''); // 숫자만 추출
    
    if (value.length <= 3) {
        input.value = value;
    } else if (value.length <= 7) {
        input.value = value.slice(0, 3) + '-' + value.slice(3);
    } else if (value.length <= 11) {
        input.value = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7);
    } else {
        // 11자리 초과 시 11자리까지만
        input.value = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7, 11);
    }
}

// 사업자번호 자동 포맷팅
function formatBusinessNumber(input) {
    let value = input.value.replace(/\D/g, ''); // 숫자만 추출
    
    if (value.length <= 3) {
        input.value = value;
    } else if (value.length <= 5) {
        input.value = value.slice(0, 3) + '-' + value.slice(3);
    } else if (value.length <= 10) {
        input.value = value.slice(0, 3) + '-' + value.slice(3, 5) + '-' + value.slice(5);
    } else {
        // 10자리 초과 시 10자리까지만
        input.value = value.slice(0, 3) + '-' + value.slice(3, 5) + '-' + value.slice(5, 10);
    }
}

// 금액 자동 포맷팅 (천 단위 구분자)
function formatAmount(input) {
    let value = input.value.replace(/[^\d]/g, ''); // 숫자만 추출
    
    if (value === '') {
        input.value = '';
        updateAmountPreview(input);
        return;
    }
    
    // 천 단위 구분자 추가
    const formattedValue = parseInt(value).toLocaleString('ko-KR');
    input.value = formattedValue;
    
    updateAmountPreview(input);
}

// 금액 미리보기 업데이트
function updateAmountPreview(input) {
    const amount = input.value.replace(/[^\d]/g, '');
    const unitSelect = input.parentElement.querySelector('.amount-unit');
    const previewElement = input.parentElement.querySelector('.amount-preview');
    
    if (!unitSelect || !previewElement) return;
    
    const unit = unitSelect.value;
    const amountNum = parseInt(amount) || 0;
    
    if (amountNum === 0) {
        previewElement.textContent = '';
        return;
    }
    
    let displayAmount = '';
    switch (unit) {
        case '원':
            displayAmount = amountNum.toLocaleString('ko-KR') + '원';
            break;
        case '만원':
            displayAmount = (amountNum * 10000).toLocaleString('ko-KR') + '원';
            break;
        case '천만원':
            displayAmount = (amountNum * 10000000).toLocaleString('ko-KR') + '원';
            break;
        case '억원':
            displayAmount = (amountNum * 100000000).toLocaleString('ko-KR') + '원';
            break;
    }
    
    previewElement.textContent = `= ${displayAmount}`;
}

// 자동 포맷팅 초기화
function initAutoFormatting() {
    // 전화번호 필드들에 이벤트 리스너 추가
    const phoneInputs = document.querySelectorAll('input[type="tel"], input[name="phone"], input[id*="phone"], input[id*="Phone"]');
    phoneInputs.forEach(input => {
        input.addEventListener('input', function() {
            formatPhoneNumber(this);
        });
        
        // 포커스 아웃 시에도 포맷팅 적용
        input.addEventListener('blur', function() {
            formatPhoneNumber(this);
        });
        
        // 키 입력 시 실시간 포맷팅
        input.addEventListener('keyup', function() {
            formatPhoneNumber(this);
        });
    });
    
    // 사업자번호 필드들에 이벤트 리스너 추가
    const businessNumberInputs = document.querySelectorAll('input[name="businessNumber"], input[id*="businessNumber"], input[id*="BusinessNumber"]');
    businessNumberInputs.forEach(input => {
        input.addEventListener('input', function() {
            formatBusinessNumber(this);
        });
        
        // 포커스 아웃 시에도 포맷팅 적용
        input.addEventListener('blur', function() {
            formatBusinessNumber(this);
        });
        
        // 키 입력 시 실시간 포맷팅
        input.addEventListener('keyup', function() {
            formatBusinessNumber(this);
        });
    });
    
    // 금액 입력 필드들에 이벤트 리스너 추가
    const amountInputs = document.querySelectorAll('.amount-input');
    amountInputs.forEach(input => {
        // 미리보기 요소 추가
        const previewElement = document.createElement('span');
        previewElement.className = 'amount-preview';
        input.parentElement.appendChild(previewElement);
        
        input.addEventListener('input', function() {
            formatAmount(this);
        });
        
        input.addEventListener('blur', function() {
            formatAmount(this);
        });
        
        input.addEventListener('keyup', function() {
            formatAmount(this);
        });
    });
    
    // 단위 선택 변경 시 미리보기 업데이트
    const unitSelects = document.querySelectorAll('.amount-unit');
    unitSelects.forEach(select => {
        select.addEventListener('change', function() {
            const input = this.parentElement.querySelector('.amount-input');
            if (input) {
                updateAmountPreview(input);
            }
        });
    });
    
    console.log('자동 포맷팅 기능이 초기화되었습니다.');
    console.log('전화번호 필드:', phoneInputs.length, '개');
    console.log('사업자번호 필드:', businessNumberInputs.length, '개');
    console.log('금액 입력 필드:', amountInputs.length, '개');
}

// ===== 주소 검색 기능 =====

// 주소 검색 함수
function searchAddress(addressInputId, detailInputId) {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드
            let addr = ''; // 주소 변수
            let extraAddr = ''; // 참고항목 변수

            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById(addressInputId).value = addr + extraAddr;
            
            // 상세주소 필드에 포커스를 이동한다.
            document.getElementById(detailInputId).focus();
            
            // 주소 입력 완료 알림
            showNotification('주소가 입력되었습니다. 상세주소를 입력해주세요.', 'success');
        },
        // 팝업 크기 및 위치 설정
        width: '100%',
        height: '100%',
        maxSuggestItems: 5,
        showMoreHName: true,
        hideMapBtn: true,
        hideEngBtn: true,
        alwaysShowEngAddr: false,
        submitMode: false,
        useBanner: false,
        theme: {
            bgColor: '#ffffff',
            searchBgColor: '#f5f5f5',
            contentBgColor: '#ffffff',
            pageBgColor: '#ffffff',
            textColor: '#333333',
            queryTextColor: '#222222',
            postcodeTextColor: '#fa4256',
            emphTextColor: '#008bd3',
            outlineColor: '#e0e0e0'
        }
    }).open({
        // 팝업 위치 설정
        q: '', // 검색어 미리 입력
        left: (screen.width / 2) - (500 / 2),
        top: (screen.height / 2) - (600 / 2)
    });
}

// 주소 검색 버튼 초기화
function initAddressSearch() {
    // 주소 검색 버튼들에 이벤트 리스너 추가
    const addressSearchBtns = document.querySelectorAll('.address-search-btn');
    addressSearchBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            
            // 버튼의 onclick 속성에서 주소 입력 필드 ID 추출
            const onclickAttr = this.getAttribute('onclick');
            const matches = onclickAttr.match(/searchAddress\('([^']+)',\s*'([^']+)'\)/);
            
            if (matches && matches.length >= 3) {
                const addressInputId = matches[1];
                const detailInputId = matches[2];
                searchAddress(addressInputId, detailInputId);
            }
        });
    });
    
    console.log('주소 검색 기능이 초기화되었습니다.');
    console.log('주소 검색 버튼:', addressSearchBtns.length, '개');
}
