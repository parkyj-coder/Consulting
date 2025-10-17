package service;

import dao.AdminDAO;
import model.Admin;
import util.DBUtil;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Properties;

public class KakaoNotificationService {
    private static final String PROPERTIES_FILE = "kakao.properties";
    private static Properties properties = new Properties();
    
    static {
        loadProperties();
    }
    
    private static void loadProperties() {
        try (var input = KakaoNotificationService.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (input != null) {
                properties.load(input);
            }
        } catch (Exception e) {
            System.err.println("kakao.properties 파일 로드 중 오류 발생: " + e.getMessage());
        }
    }
    
    /**
     * 모든 관리자에게 상담 신청 알림을 전송합니다.
     * @param companyName 회사명
     * @param applicantName 신청자명
     * @param phone 전화번호
     * @return 전송된 알림 수
     */
    public static int sendConsultationNotificationToAllAdmins(String companyName, String applicantName, String phone) {
        if (!isKakaoEnabled()) {
            System.out.println("카카오톡 알림이 비활성화되어 있습니다.");
            return 0;
        }
        
        try {
            AdminDAO adminDAO = new AdminDAO();
            List<Admin> admins = adminDAO.getAllAdmins();
            
            int sentCount = 0;
            for (Admin admin : admins) {
                if (admin.isActive()) {
                    try {
                        sendKakaoMessage(admin, companyName, applicantName, phone);
                        sentCount++;
                        Thread.sleep(100); // API 호출 간격 조절
                    } catch (Exception e) {
                        System.err.println("관리자 " + admin.getName() + "에게 알림 전송 실패: " + e.getMessage());
                    }
                }
            }
            
            return sentCount;
        } catch (Exception e) {
            System.err.println("관리자 목록 조회 중 오류 발생: " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * 특정 관리자에게 카카오톡 메시지를 전송합니다.
     * @param admin 관리자 정보
     * @param companyName 회사명
     * @param applicantName 신청자명
     * @param phone 전화번호
     * @throws Exception 전송 실패 시
     */
    private static void sendKakaoMessage(Admin admin, String companyName, String applicantName, String phone) throws Exception {
        String apiKey = properties.getProperty("kakao.api.key");
        String apiUrl = properties.getProperty("kakao.api.url");
        
        if (apiKey == null || apiKey.equals("YOUR_KAKAO_API_KEY") || 
            apiUrl == null || apiUrl.isEmpty()) {
            throw new Exception("카카오 API 설정이 올바르지 않습니다.");
        }
        
        // 메시지 내용 생성
        String message = createConsultationMessage(companyName, applicantName, phone);
        
        // HTTP 요청 생성
        URL url = new URL(apiUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        
        try {
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Authorization", "Bearer " + apiKey);
            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            connection.setDoOutput(true);
            
            // 요청 본문 생성
            String postData = "template_object=" + java.net.URLEncoder.encode(message, StandardCharsets.UTF_8);
            
            // 요청 전송
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = postData.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            // 응답 확인
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                System.out.println("관리자 " + admin.getName() + "에게 카카오톡 알림 전송 성공");
            } else {
                // 에러 응답 읽기
                try (BufferedReader br = new BufferedReader(new InputStreamReader(connection.getErrorStream()))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line);
                    }
                    throw new Exception("카카오 API 응답 오류: " + responseCode + " - " + response.toString());
                }
            }
            
        } finally {
            connection.disconnect();
        }
    }
    
    /**
     * 상담 신청 알림 메시지를 생성합니다.
     * @param companyName 회사명
     * @param applicantName 신청자명
     * @param phone 전화번호
     * @return JSON 형태의 메시지
     */
    private static String createConsultationMessage(String companyName, String applicantName, String phone) {
        String senderName = properties.getProperty("kakao.message.sender", "한국미래 중소기업 경영컨설팅");
        
        return String.format(
            "{\n" +
            "  \"object_type\": \"text\",\n" +
            "  \"text\": \"새로운 상담 신청이 접수되었습니다.\\n\\n\" +\n" +
            "           \"회사명: %s\\n\" +\n" +
            "           \"신청자: %s\\n\" +\n" +
            "           \"연락처: %s\\n\\n\" +\n" +
            "           \"관리자 페이지에서 확인해주세요.\",\n" +
            "  \"link\": {\n" +
            "    \"web_url\": \"http://localhost:8080/Consulting/admin/consultationList.jsp\",\n" +
            "    \"mobile_web_url\": \"http://localhost:8080/Consulting/admin/consultationList.jsp\"\n" +
            "  },\n" +
            "  \"button_title\": \"관리자 페이지로 이동\"\n" +
            "}",
            companyName, applicantName, phone
        );
    }
    
    /**
     * 카카오톡 알림이 활성화되어 있는지 확인합니다.
     * @return 활성화되어 있으면 true
     */
    private static boolean isKakaoEnabled() {
        String enabled = properties.getProperty("kakao.message.enabled", "false");
        return "true".equalsIgnoreCase(enabled);
    }
    
    /**
     * 카카오 API 설정을 테스트합니다.
     * @return 설정이 올바르면 true
     */
    public static boolean testKakaoConfig() {
        String apiKey = properties.getProperty("kakao.api.key");
        String apiUrl = properties.getProperty("kakao.api.url");
        
        if (apiKey == null || apiKey.equals("YOUR_KAKAO_API_KEY")) {
            System.err.println("카카오 API 키가 설정되지 않았습니다.");
            return false;
        }
        
        if (apiUrl == null || apiUrl.isEmpty()) {
            System.err.println("카카오 API URL이 설정되지 않았습니다.");
            return false;
        }
        
        if (!isKakaoEnabled()) {
            System.err.println("카카오톡 알림이 비활성화되어 있습니다.");
            return false;
        }
        
        return true;
    }
    
    /**
     * 간단한 텍스트 메시지를 전송합니다. (테스트용)
     * @param message 전송할 메시지
     * @return 전송 성공 시 true
     */
    public static boolean sendSimpleMessage(String message) {
        if (!testKakaoConfig()) {
            return false;
        }
        
        try {
            AdminDAO adminDAO = new AdminDAO();
            List<Admin> admins = adminDAO.getAllAdmins();
            
            for (Admin admin : admins) {
                if (admin.isActive()) {
                    sendSimpleKakaoMessage(admin, message);
                    Thread.sleep(100);
                }
            }
            
            return true;
        } catch (Exception e) {
            System.err.println("간단한 메시지 전송 실패: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * 간단한 카카오톡 메시지를 전송합니다.
     * @param admin 관리자 정보
     * @param message 메시지 내용
     * @throws Exception 전송 실패 시
     */
    private static void sendSimpleKakaoMessage(Admin admin, String message) throws Exception {
        String apiKey = properties.getProperty("kakao.api.key");
        String apiUrl = properties.getProperty("kakao.api.url");
        
        URL url = new URL(apiUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        
        try {
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Authorization", "Bearer " + apiKey);
            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            connection.setDoOutput(true);
            
            String postData = "template_object=" + java.net.URLEncoder.encode(
                "{\"object_type\":\"text\",\"text\":\"" + message + "\"}", 
                StandardCharsets.UTF_8
            );
            
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = postData.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            int responseCode = connection.getResponseCode();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                throw new Exception("카카오 API 응답 오류: " + responseCode);
            }
            
        } finally {
            connection.disconnect();
        }
    }
}
