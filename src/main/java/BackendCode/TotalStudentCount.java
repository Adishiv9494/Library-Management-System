// ==========================================
// 15. TotalStudentCount.java
// ==========================================
package BackendCode;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/TotalStudentCount")
public class TotalStudentCount extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int totalCount = 0;
        String[] tables = {"bca_students", "bba_students", "mba_students", "mca_students", "btech_students", "ptech_students"};

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC", "avnadmin", "HIDDEN_PASSWORD")) {

                for (String table : tables) {
                    try (Statement stmt = con.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
                        if (rs.next()) {
                            totalCount += rs.getInt(1);
                        }
                    } catch (Exception ignored) {
                        // Table might not exist yet
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setContentType("text/plain");
        response.getWriter().write(String.valueOf(totalCount));
    }
}