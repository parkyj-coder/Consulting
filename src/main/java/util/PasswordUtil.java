package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * 비밀번호를 해시화합니다.
     * @param password 원본 비밀번호
     * @return 해시화된 비밀번호 (salt + hash)
     */
    public static String hashPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("비밀번호는 null이거나 빈 문자열일 수 없습니다.");
        }
        
        try {
            // 솔트 생성
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // 비밀번호 + 솔트 해시화
            String hashedPassword = hashWithSalt(password, salt);
            
            // 솔트를 Base64로 인코딩하여 해시 앞에 붙임
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            return saltBase64 + ":" + hashedPassword;
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("해시 알고리즘을 찾을 수 없습니다: " + e.getMessage());
        }
    }
    
    /**
     * 비밀번호를 검증합니다.
     * @param password 원본 비밀번호
     * @param hashedPassword 저장된 해시화된 비밀번호
     * @return 일치하면 true, 아니면 false
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        if (password == null || hashedPassword == null) {
            return false;
        }
        
        try {
            // 저장된 해시에서 솔트와 해시 분리
            String[] parts = hashedPassword.split(":");
            if (parts.length != 2) {
                return false;
            }
            
            String saltBase64 = parts[0];
            String storedHash = parts[1];
            
            // 솔트 디코딩
            byte[] salt = Base64.getDecoder().decode(saltBase64);
            
            // 입력된 비밀번호를 같은 솔트로 해시화
            String inputHash = hashWithSalt(password, salt);
            
            // 해시 비교
            return inputHash.equals(storedHash);
            
        } catch (Exception e) {
            System.err.println("비밀번호 검증 중 오류 발생: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * 비밀번호와 솔트를 사용하여 해시를 생성합니다.
     * @param password 비밀번호
     * @param salt 솔트
     * @return 해시화된 문자열
     * @throws NoSuchAlgorithmException
     */
    private static String hashWithSalt(String password, byte[] salt) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance(ALGORITHM);
        digest.update(salt);
        byte[] hash = digest.digest(password.getBytes());
        return Base64.getEncoder().encodeToString(hash);
    }
    
    /**
     * 강력한 비밀번호인지 검사합니다.
     * @param password 검사할 비밀번호
     * @return 강력한 비밀번호면 true
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasUpperCase = password.chars().anyMatch(Character::isUpperCase);
        boolean hasLowerCase = password.chars().anyMatch(Character::isLowerCase);
        boolean hasDigit = password.chars().anyMatch(Character::isDigit);
        boolean hasSpecialChar = password.chars().anyMatch(ch -> 
            "!@#$%^&*()_+-=[]{}|;':\",./<>?".indexOf(ch) >= 0);
        
        return hasUpperCase && hasLowerCase && hasDigit && hasSpecialChar;
    }
    
    /**
     * 랜덤 비밀번호를 생성합니다.
     * @param length 비밀번호 길이
     * @return 생성된 비밀번호
     */
    public static String generateRandomPassword(int length) {
        if (length < 8) {
            length = 8;
        }
        
        String upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lowerCase = "abcdefghijklmnopqrstuvwxyz";
        String digits = "0123456789";
        String specialChars = "!@#$%^&*()_+-=[]{}|;':\",./<>?";
        String allChars = upperCase + lowerCase + digits + specialChars;
        
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        // 최소 요구사항 충족
        password.append(upperCase.charAt(random.nextInt(upperCase.length())));
        password.append(lowerCase.charAt(random.nextInt(lowerCase.length())));
        password.append(digits.charAt(random.nextInt(digits.length())));
        password.append(specialChars.charAt(random.nextInt(specialChars.length())));
        
        // 나머지 문자들 추가
        for (int i = 4; i < length; i++) {
            password.append(allChars.charAt(random.nextInt(allChars.length())));
        }
        
        // 문자 순서 섞기
        for (int i = 0; i < password.length(); i++) {
            int randomIndex = random.nextInt(password.length());
            char temp = password.charAt(i);
            password.setCharAt(i, password.charAt(randomIndex));
            password.setCharAt(randomIndex, temp);
        }
        
        return password.toString();
    }
}
