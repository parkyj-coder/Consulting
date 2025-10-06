package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtil {
    private static final String PROPERTIES_FILE = "db.properties";
    private static Properties props = new Properties();
    
    static {
        try {
            ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
            InputStream input = classLoader.getResourceAsStream(PROPERTIES_FILE);
            if (input != null) {
                props.load(input);
            } else {
                throw new RuntimeException("db.properties 파일을 찾을 수 없습니다.");
            }
        } catch (IOException e) {
            throw new RuntimeException("db.properties 파일 로드 중 오류 발생", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(props.getProperty("db.driver"));
            return DriverManager.getConnection(
                props.getProperty("db.url") + "&allowPublicKeyRetrieval=true&useSSL=false",
                props.getProperty("db.username"),
                props.getProperty("db.password")
            );
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC 드라이버를 찾을 수 없습니다.", e);
        }
    }
    
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
