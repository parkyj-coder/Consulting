package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtil {
    private static final String PROPERTIES_FILE = "db.properties";
    private static Properties properties = new Properties();
    
    static {
        loadProperties();
    }
    
    private static void loadProperties() {
        try (InputStream input = DBUtil.class.getClassLoader().getResourceAsStream(PROPERTIES_FILE)) {
            if (input == null) {
                System.err.println("db.properties 파일을 찾을 수 없습니다.");
                return;
            }
            properties.load(input);
        } catch (IOException e) {
            System.err.println("db.properties 파일 로드 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 데이터베이스 연결을 반환합니다.
     * @return Connection 객체
     * @throws SQLException 데이터베이스 연결 오류 시
     */
    public static Connection getConnection() throws SQLException {
        try {
            String driver = properties.getProperty("db.driver");
            String url = properties.getProperty("db.url");
            String username = properties.getProperty("db.username");
            String password = properties.getProperty("db.password");
            
            if (driver == null || url == null || username == null || password == null) {
                throw new SQLException("데이터베이스 설정 정보가 불완전합니다.");
            }
            
            // 드라이버 로드
            Class.forName(driver);
            
            // 연결 생성
            return DriverManager.getConnection(url, username, password);
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("데이터베이스 드라이버를 찾을 수 없습니다: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("데이터베이스 연결 실패: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * 연결을 테스트합니다.
     * @return 연결 성공 시 true, 실패 시 false
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("데이터베이스 연결 테스트 실패: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * 연결을 안전하게 닫습니다.
     * @param conn 닫을 연결
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("연결 닫기 실패: " + e.getMessage());
            }
        }
    }
}
