package BackendCode;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/PendingFineServlet")
public class PendingFineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Database connection parameters
    private static final String JDBC_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
	private static final String JDBC_USER = "avnadmin";
	private static final String JDBC_PASSWORD = "HIDDEN_PASSWORD";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            // Set up database connection
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            
            // SQL query to get students with pending fines (OVERDUE or DEFAULTER status)
            String sql = "SELECT crn, student_name, contact, SUM(fine_amount) as total_fine " +
                         "FROM book_issues " +
                         "WHERE status IN ('OVERDUE', 'DEFAULTER') " +
                         "GROUP BY crn, student_name, contact " +
                         "HAVING total_fine > 0 " +
                         "ORDER BY total_fine DESC";
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            // Process results
            List<StudentFine> studentFines = new ArrayList<>();
            while (rs.next()) {
                StudentFine student = new StudentFine();
                student.setCrn(rs.getString("crn"));
                student.setName(rs.getString("student_name"));
                student.setContact(rs.getString("contact"));
                student.setTotalFine(rs.getDouble("total_fine"));
                
                studentFines.add(student);
            }
            
            // Prepare JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(new Response(true, "Data retrieved successfully", studentFines));
            response.getWriter().write(jsonResponse);
            
        } catch (SQLException e) {
            e.printStackTrace();
            sendErrorResponse(response, "Database error: " + e.getMessage());
        } finally {
            // Close resources
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new Gson().toJson(new Response(false, message, null)));
    }
    
    // Helper classes for JSON response
    class Response {
        boolean success;
        String message;
        List<StudentFine> data;
        
        public Response(boolean success, String message, List<StudentFine> data) {
            this.success = success;
            this.message = message;
            this.data = data;
        }
    }
    
    class StudentFine {
        private String crn;
        private String name;
        private String contact;
        private double totalFine;
        
        // Getters and setters
        public String getCrn() { return crn; }
        public void setCrn(String crn) { this.crn = crn; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getContact() { return contact; }
        public void setContact(String contact) { this.contact = contact; }
        
        public double getTotalFine() { return totalFine; }
        public void setTotalFine(double totalFine) { this.totalFine = totalFine; }
    }
}