package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/DefaulterStudentsServlet")
public class DefaulterStudentsServlet extends HttpServlet {
	private static final String JDBC_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
	private static final String JDBC_USER = "avnadmin";
	private static final String JDBC_PASSWORD = "HIDDEN_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        Map<String, Object> result = new HashMap<>();
        List<Map<String, String>> defaulters = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            
            // SQL query to fetch defaulter students (distinct to avoid duplicates)
            String sql = "SELECT DISTINCT crn, student_name, contact, course, status " +
                         "FROM book_issues " +
                         "WHERE status = 'DEFAULTER' " +
                         "ORDER BY student_name";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, String> student = new HashMap<>();
                student.put("crn", rs.getString("crn"));
                student.put("studentName", rs.getString("student_name"));
                student.put("contact", rs.getString("contact"));
                student.put("course", rs.getString("course"));
                student.put("status", rs.getString("status"));
                defaulters.add(student);
            }
            
            result.put("success", true);
            result.put("data", defaulters);
            
        } catch (ClassNotFoundException e) {
            result.put("success", false);
            result.put("message", "JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            result.put("success", false);
            result.put("message", "Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // Convert result map to JSON
        Gson gson = new Gson();
        out.print(gson.toJson(result));
        out.flush();
    }
}
