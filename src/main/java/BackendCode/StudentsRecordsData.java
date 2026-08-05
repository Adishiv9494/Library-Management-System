package BackendCode;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/StudentsRecordsData")
public class StudentsRecordsData extends HttpServlet {
    // Database configuration
	private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
	private static final String DB_USER = "avnadmin";
	private static final String DB_PASSWORD = "HIDDEN_PASSWORD";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Get request parameters
        int page = getIntParameter(request, "page", 1);
        int limit = getIntParameter(request, "limit", 10);
        String searchTerm = request.getParameter("search") != null ? 
                           request.getParameter("search").trim() : "";
        String courseFilter = request.getParameter("course") != null ?
                             request.getParameter("course").trim() : "";
        
        // Calculate offset
        int offset = (page - 1) * limit;
        
        try (PrintWriter out = response.getWriter()) {
            try {
                // Load JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // Establish connection
                try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                    // Get total records count
                    int totalRecords = getTotalRecords(conn, searchTerm, courseFilter);
                    
                    // Get paginated student data
                    List<Student> students = getStudentRecords(conn, offset, limit, searchTerm, courseFilter);
                    
                    // Build JSON response
                    out.print("{");
                    out.print("\"totalRecords\":" + totalRecords + ",");
                    out.print("\"data\":[");
                    
                    boolean first = true;
                    for (Student student : students) {
                        if (!first) out.print(",");
                        out.print(studentToJson(student));
                        first = false;
                    }
                    
                    out.print("]}");
                }
            } catch (ClassNotFoundException e) {
                out.print("{\"error\":\"Database driver not found\"}");
                log("Database driver not found", e);
            } catch (SQLException e) {
                out.print("{\"error\":\"Database error: " + e.getMessage() + "\"}");
                log("Database error", e);
            } catch (Exception e) {
                out.print("{\"error\":\"Unexpected error: " + e.getMessage() + "\"}");
                log("Unexpected error", e);
            }
        }
    }
    
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        try {
            return Integer.parseInt(request.getParameter(paramName));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    private int getTotalRecords(Connection conn, String searchTerm, String courseFilter) throws SQLException {
        String countQuery = "SELECT COUNT(*) FROM (" +
                           "SELECT crn FROM BCA_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                           "AND (? = '' OR course LIKE ?) " +
                           "UNION ALL SELECT crn FROM BBA_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                           "AND (? = '' OR course LIKE ?) " +
                           "UNION ALL SELECT crn FROM BTech_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                           "AND (? = '' OR course LIKE ?) " +
                           "UNION ALL SELECT crn FROM MCA_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                           "AND (? = '' OR course LIKE ?) " +
                           "UNION ALL SELECT crn FROM MBA_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                           "AND (? = '' OR course LIKE ?) " +
                           "UNION ALL SELECT crn FROM PTech_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                           "AND (? = '' OR course LIKE ?)" +
                           ") AS all_students";
        
        try (PreparedStatement pstmt = conn.prepareStatement(countQuery)) {
            setSearchParameters(pstmt, searchTerm, courseFilter);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
    
    private List<Student> getStudentRecords(Connection conn, int offset, int limit, String searchTerm, String courseFilter) 
            throws SQLException {
        List<Student> students = new ArrayList<>();
        String query = "SELECT crn, name, contact, course FROM BCA_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                       "AND (? = '' OR course LIKE ?) " +
                       "UNION ALL SELECT crn, name, contact, course FROM BBA_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                       "AND (? = '' OR course LIKE ?) " +
                       "UNION ALL SELECT crn, name, contact, course FROM BTech_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                       "AND (? = '' OR course LIKE ?) " +
                       "UNION ALL SELECT crn, name, contact, course FROM MCA_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                       "AND (? = '' OR course LIKE ?) " +
                       "UNION ALL SELECT crn, name, contact, course FROM MBA_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                       "AND (? = '' OR course LIKE ?) " +
                       "UNION ALL SELECT crn, name, contact, course FROM PTech_students WHERE (? = '' OR crn LIKE ? OR name LIKE ?) " +
                       "AND (? = '' OR course LIKE ?) " +
                       "ORDER BY name LIMIT ? OFFSET ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            int paramIndex = setSearchParameters(pstmt, searchTerm, courseFilter);
            pstmt.setInt(paramIndex++, limit);
            pstmt.setInt(paramIndex, offset);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Student student = new Student();
                    student.setCrn(rs.getString("crn"));
                    student.setName(rs.getString("name"));
                    student.setContact(rs.getString("contact"));
                    student.setCourse(rs.getString("course"));
                    students.add(student);
                }
            }
        }
        return students;
    }
    
    private int setSearchParameters(PreparedStatement pstmt, String searchTerm, String courseFilter) 
            throws SQLException {
        String searchPattern = "%" + searchTerm + "%";
        String coursePattern = "%" + courseFilter + "%";
        int paramIndex = 1;
        
        // Set parameters for each table (6 tables)
        for (int i = 0; i < 6; i++) {
            // Search parameters
            pstmt.setString(paramIndex++, searchTerm.isEmpty() ? "" : searchTerm);
            pstmt.setString(paramIndex++, searchPattern);
            pstmt.setString(paramIndex++, searchPattern);
            
            // Course filter parameters
            pstmt.setString(paramIndex++, courseFilter.isEmpty() ? "" : courseFilter);
            pstmt.setString(paramIndex++, coursePattern);
        }
        
        return paramIndex;
    }
    
    private String studentToJson(Student student) {
        return String.format(
            "{\"crn\":\"%s\",\"name\":\"%s\",\"contact\":\"%s\",\"course\":\"%s\"}",
            escapeJson(student.getCrn()),
            escapeJson(student.getName()),
            escapeJson(student.getContact()),
            escapeJson(student.getCourse())
        );
    }
    
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
    
    // Student data model class
    private static class Student {
        private String crn;
        private String name;
        private String contact;
        private String course;
        
        // Getters and setters
        public String getCrn() { return crn; }
        public void setCrn(String crn) { this.crn = crn; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getContact() { return contact; }
        public void setContact(String contact) { this.contact = contact; }
        
        public String getCourse() { return course; }
        public void setCourse(String course) { this.course = course; }
    }
}