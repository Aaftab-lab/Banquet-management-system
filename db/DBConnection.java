package db;
import java.sql.Connection;
import java.sql.DriverManager;
import javax.swing.JOptionPane;

public class DBConnection {
    public static Connection connect() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/banquet_management", "root", "password"
            );
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "DB Connection Failed: " + e);
            return null;
        }
    }
}
