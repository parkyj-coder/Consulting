package service;

import dao.AdminDAO;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.List;
import java.io.InputStream;

public class KakaoNotificationService {
    private static Properties props = new Properties();
    
    static {
        try {
            ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
            InputStream input = classLoader.getResourceAsStream("kakao.properties");
            if (input != null) {
                props.load(input);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 카카오톡 알림톡 전송
     * @param phoneNumber 수신자 전화번호
     * @param message 전송할 메시지
     * @return 전송 성공 여부
     */
    public static boolean sendNotification(String phoneNumber, String message) {
        try {
            String apiKey = props.getProperty("kakao.api.key");
            if (apiKey == null || apiKey.equals("YOUR_KAKAO_API_KEY")) {
                System.out.println("카카오 API 키가 설정되지 않았습니다.");
                return false;
            }
            
            // 카카오톡 API 호출
            URL url = new URL("https://kapi.kakao.com/v2/api/talk/memo/default/send");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            
            // HTTP 헤더 설정
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setDoOutput(true);
            
            // 메시지 데이터 구성
            String postData = "template_object=" + java.net.URLEncoder.encode(
                "{\"object_type\":\"text\",\"text\":\"" + message + "\",\"link\":{\"web_url\":\"https://your-domain.com/admin/consultationList.jsp\"}}",
                StandardCharsets.UTF_8.toString()
            );
            
            // 데이터 전송
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = postData.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            // 응답 확인
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                System.out.println("카카오톡 알림 전송 성공");
                return true;
            } else {
                System.out.println("카카오톡 알림 전송 실패: " + responseCode);
                return false;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 상담신청 알림 메시지 생성
     * @param companyName 기업명
     * @param applicantName 신청자명
     * @param phone 연락처
     * @return 알림 메시지
     */
    public static String createConsultationMessage(String companyName, String applicantName, String phone) {
        StringBuilder message = new StringBuilder();
        message.append("🔔 새로운 상담신청이 접수되었습니다!\n\n");
        message.append("📋 기업명: ").append(companyName).append("\n");
        message.append("👤 신청자: ").append(applicantName).append("\n");
        message.append("📞 연락처: ").append(phone).append("\n\n");
        message.append("💼 더문D&C그룹 한국중소기업 경영컨설팅 연구소\n");
        message.append("⏰ 접수시간: ").append(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()));
        
        return message.toString();
    }
    
    /**
     * 관리자에게 상담신청 알림 전송
     * @param companyName 기업명
     * @param applicantName 신청자명
     * @param phone 연락처
     * @return 전송 성공 여부
     */
    public static boolean sendConsultationNotification(String companyName, String applicantName, String phone) {
        String adminPhone = props.getProperty("kakao.admin.phone");
        if (adminPhone == null || adminPhone.equals("010-0000-0000")) {
            System.out.println("관리자 전화번호가 설정되지 않았습니다.");
            return false;
        }
        
        String message = createConsultationMessage(companyName, applicantName, phone);
        return sendNotification(adminPhone, message);
    }
    
    /**
     * 간단한 텍스트 메시지 전송 (테스트용)
     * @param message 전송할 메시지
     * @return 전송 성공 여부
     */
    public static boolean sendSimpleMessage(String message) {
        String adminPhone = props.getProperty("kakao.admin.phone");
        if (adminPhone == null || adminPhone.equals("010-0000-0000")) {
            System.out.println("관리자 전화번호가 설정되지 않았습니다.");
            return false;
        }
        
        return sendNotification(adminPhone, message);
    }
    
    /**
     * DB에서 관리자 전화번호를 가져와서 상담신청 알림 전송
     * @param companyName 기업명
     * @param applicantName 신청자명
     * @param phone 연락처
     * @return 전송 성공한 관리자 수
     */
    public static int sendConsultationNotificationToAllAdmins(String companyName, String applicantName, String phone) {
        try {
            System.out.println("=== 카카오톡 알림 전송 시작 ===");
            System.out.println("companyName: " + companyName);
            System.out.println("applicantName: " + applicantName);
            System.out.println("phone: " + phone);
            
            AdminDAO adminDAO = new AdminDAO();
            List<String> adminPhones = adminDAO.getActiveAdminPhones();
            
            System.out.println("조회된 관리자 전화번호 수: " + adminPhones.size());
            for (String adminPhone : adminPhones) {
                System.out.println("관리자 전화번호: " + adminPhone);
            }
            
            if (adminPhones.isEmpty()) {
                System.out.println("알림을 받을 관리자가 없습니다.");
                return 0;
            }
            
            String message = createConsultationMessage(companyName, applicantName, phone);
            int successCount = 0;
            
            for (String adminPhone : adminPhones) {
                if (sendNotification(adminPhone, message)) {
                    successCount++;
                }
            }
            
            System.out.println("총 " + adminPhones.size() + "명의 관리자 중 " + successCount + "명에게 알림 전송 완료");
            return successCount;
            
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
