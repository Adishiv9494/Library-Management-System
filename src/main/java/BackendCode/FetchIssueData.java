package BackendCode;

import java.io.*;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;

@WebServlet("/FetchIssueData")
public class FetchIssueData extends HttpServlet {
	private static final String JDBC_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
	private static final String JDBC_USER = "avnadmin";
	private static final String JDBC_PASSWORD = "HIDDEN_PASSWORD";
    
    private static final String[] STUDENT_TABLES = {
        "BBA_students", "BCA_students", "MBA_students", 
        "MCA_students", "BTech_students", "PTech_students"
    };

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        try {
            String crn = request.getParameter("crn");
            String accessionNo = request.getParameter("accessionNo");
            
            if (crn == null || crn.trim().isEmpty() || 
                accessionNo == null || accessionNo.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "CRN and Accession Number are required");
                out.print(new Gson().toJson(result));
                return;
            }
            
            // Ensure CRN is in uppercase
            crn = crn.toUpperCase();
            
            try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD)) {
                // Check if connection is valid
                if (!conn.isValid(1)) {
                    throw new SQLException("Database connection is invalid");
                }

                // Fetch student data
                Map<String, String> studentData = fetchStudentData(conn, crn);
                if (studentData == null) {
                    result.put("success", false);
                    result.put("message", "Student not found");
                    out.print(new Gson().toJson(result));
                    return;
                }

                // Fetch book data
                Map<String, String> bookData = fetchBookData(conn, accessionNo);
                if (bookData == null) {
                    result.put("success", false);
                    result.put("message", "Book not found");
                    out.print(new Gson().toJson(result));
                    return;
                }

                // Check if book is available
                if (!isBookAvailable(conn, accessionNo)) {
                    result.put("success", false);
                    result.put("message", "Book is already issued");
                    out.print(new Gson().toJson(result));
                    return;
                }

                result.put("success", true);
                result.put("student", studentData);
                result.put("book", bookData);
                out.print(new Gson().toJson(result));
            } catch (SQLException e) {
                result.put("success", false);
                result.put("message", "Database error: " + e.getMessage());
                out.print(new Gson().toJson(result));
                e.printStackTrace();
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Server error: " + e.getMessage());
            out.print(new Gson().toJson(result));
            e.printStackTrace();
        } finally {
            out.flush();
        }
    }

    private Map<String, String> fetchStudentData(Connection conn, String crn) throws SQLException {
        for (String table : STUDENT_TABLES) {
            String sql = "SELECT name, contact, course FROM " + table + " WHERE crn = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, crn);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    Map<String, String> student = new HashMap<>();
                    student.put("name", rs.getString("name"));
                    student.put("contact", rs.getString("contact"));
                    student.put("course", rs.getString("course"));
                    return student;
                }
            }
        }
        return null;
    }

    private Map<String, String> fetchBookData(Connection conn, String accessionNo) throws SQLException {
        try {
            int accessionNum = Integer.parseInt(accessionNo);
            String sql = "SELECT accession_number, book_name, author, edition FROM booksData WHERE accession_number = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, accessionNum);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    Map<String, String> book = new HashMap<>();
                    book.put("accessionNo", rs.getString("accession_number"));
                    book.put("title", rs.getString("book_name"));
                    book.put("author", rs.getString("author"));
                    book.put("edition", rs.getString("edition"));
                    return book;
                }
            }
        } catch (NumberFormatException e) {
            throw new SQLException("Invalid accession number format");
        }
        return null;
    }

    private boolean isBookAvailable(Connection conn, String accessionNo) throws SQLException {
        try {
            int accessionNum = Integer.parseInt(accessionNo);
            String sql = "SELECT 1 FROM book_issues WHERE accession_number = ? AND return_date IS NULL";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, accessionNum);
                return !stmt.executeQuery().next();
            }
        } catch (NumberFormatException e) {
            throw new SQLException("Invalid accession number format");
        }
    }
}