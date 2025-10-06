package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    
    /**
     * SHA-256으로 비밀번호를 해시화합니다.
     * @param password 원본 비밀번호
     * @return 해시화된 비밀번호
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("비밀번호 해시화 중 오류 발생", e);
        }
    }
    
    /**
     * 솔트를 사용한 비밀번호 해시화 (더 안전한 방법)
     * @param password 원본 비밀번호
     * @return 솔트와 해시가 결합된 문자열
     */
    public static String hashPasswordWithSalt(String password) {
        try {
            // 랜덤 솔트 생성
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);
            
            // 솔트와 비밀번호 결합
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            digest.update(salt);
            byte[] hash = digest.digest(password.getBytes("UTF-8"));
            
            // 솔트와 해시를 Base64로 인코딩하여 결합
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hash);
            
            return saltBase64 + ":" + hashBase64;
        } catch (Exception e) {
            throw new RuntimeException("비밀번호 해시화 중 오류 발생", e);
        }
    }
    
    /**
     * 솔트를 사용한 비밀번호 검증
     * @param password 원본 비밀번호
     * @param hashedPassword 저장된 해시된 비밀번호
     * @return 비밀번호 일치 여부
     */
    public static boolean verifyPasswordWithSalt(String password, String hashedPassword) {
        try {
            String[] parts = hashedPassword.split(":");
            if (parts.length != 2) {
                return false;
            }
            
            String saltBase64 = parts[0];
            String hashBase64 = parts[1];
            
            byte[] salt = Base64.getDecoder().decode(saltBase64);
            byte[] storedHash = Base64.getDecoder().decode(hashBase64);
            
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            digest.update(salt);
            byte[] computedHash = digest.digest(password.getBytes("UTF-8"));
            
            return MessageDigest.isEqual(storedHash, computedHash);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 간단한 SHA-256 해시 검증 (기존 방식과 호환)
     * @param password 원본 비밀번호
     * @param hashedPassword 저장된 해시된 비밀번호
     * @return 비밀번호 일치 여부
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        String hashedInput = hashPassword(password);
        return hashedInput.equals(hashedPassword);
    }
    
    /**
     * 강력한 비밀번호 생성
     * @param length 비밀번호 길이
     * @return 생성된 비밀번호
     */
    public static String generateStrongPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }
}
