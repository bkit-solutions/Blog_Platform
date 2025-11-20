import java.sql.*;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/insta_blog";
    private static final String USER = "root";
    private static final String PASS = "ijustDh53@";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // ✅ ensure driver is loaded
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
