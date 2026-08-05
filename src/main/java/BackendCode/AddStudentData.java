
package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet("/AddStudentData")
public class AddStudentData extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Database configuration
    private static final String JDBC_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC\";";
    private static final String JDBC_USER = "avnadmin";
    private static final String JDBC_PASSWORD = "HIDDEN_PASSWORD";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        String crn = request.getParameter("crn");
        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        String course = request.getParameter("course");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            
            // Determine which table to insert into based on course
            String tableName = getTableName(course);
            if (tableName == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Invalid course selected");
                out.print(jsonResponse.toString());
                return;
            }
            
            // SQL query to insert student
            String sql = "INSERT INTO " + tableName + " (crn, name, course, contact) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, crn);
            pstmt.setString(2, name);
            pstmt.setString(3, course);
            pstmt.setString(4, contact);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Student added successfully to " + course + " table!");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Failed to add student");
            }
        } catch (ClassNotFoundException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Database driver not found");
            e.printStackTrace();
        } catch (SQLException e) {
            if (e.getSQLState().equals("23000") && e.getMessage().contains("Duplicate entry")) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "CRN already exists in " + course + " table");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Database error: " + e.getMessage());
            }
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }
    
    private String getTableName(String course) {
        switch(course) {
            case "BBA":
                return "BBA_students";
            case "BCA":
                return "BCA_students";
            case "MBA":
                return "MBA_students";
            case "MCA":
                return "MCA_students";
            case "PTech":
                return "PTech_students";
            case "BTech":
                return "BTech_students";
            default:
                return null;
        }
    }
}