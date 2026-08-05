package BackendCode;

import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;

@WebServlet("/IssueBook")
public class IssueBook extends HttpServlet {
	private static final String JDBC_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
	private static final String JDBC_USER = "avnadmin";
	private static final String JDBC_PASSWORD = "HIDDEN_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        Connection conn = null;
        
        try {
            // Get all parameters with proper null checks
            String crn = getParameter(request, "crn");
            String name = getParameter(request, "name");
            String contact = getParameter(request, "contact");
            String course = getParameter(request, "course");
            String accessionNo = getParameter(request, "accessionNo");
            String bookTitle = getParameter(request, "bookTitle");
            String author = getParameter(request, "author");
            String edition = getParameter(request, "edition");
            String dueDateStr = getParameter(request, "dueDate");
            
            // Validate required fields
            if (crn.isEmpty() || name.isEmpty() || contact.isEmpty() || course.isEmpty() ||
                accessionNo.isEmpty() || bookTitle.isEmpty() || author.isEmpty() || 
                edition.isEmpty() || dueDateStr.isEmpty()) {
                
                result.put("success", false);
                result.put("message", "All fields are required");
                out.print(new Gson().toJson(result));
                return;
            }
            
            // Ensure CRN is in uppercase
            crn = crn.toUpperCase();
            
            // Parse accession number
            int accessionNum;
            try {
                accessionNum = Integer.parseInt(accessionNo);
            } catch (NumberFormatException e) {
                result.put("success", false);
                result.put("message", "Invalid accession number format");
                out.print(new Gson().toJson(result));
                return;
            }
            
            // Parse and validate due date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            
            java.util.Date dueDate;
            try {
                dueDate = sdf.parse(dueDateStr);
            } catch (Exception e) {
                result.put("success", false);
                result.put("message", "Invalid due date format. Please use YYYY-MM-DD format");
                out.print(new Gson().toJson(result));
                return;
            }
            
            // Get current date without time
            Calendar todayCal = Calendar.getInstance();
            todayCal.set(Calendar.HOUR_OF_DAY, 0);
            todayCal.set(Calendar.MINUTE, 0);
            todayCal.set(Calendar.SECOND, 0);
            todayCal.set(Calendar.MILLISECOND, 0);
            java.util.Date today = todayCal.getTime();
            
            // Check if due date is in the future
            if (!dueDate.after(today)) {
                result.put("success", false);
                result.put("message", "Due date must be after today");
                out.print(new Gson().toJson(result));
                return;
            }
            
            // Database operation
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            conn.setAutoCommit(false);
            
            try {
                // 1. Check if the book is already issued
                String checkBookSql = "SELECT status FROM book_issues " +
                                     "WHERE accession_number = ? AND status = 'ISSUED'";
                try (PreparedStatement checkBookStmt = conn.prepareStatement(checkBookSql)) {
                    checkBookStmt.setInt(1, accessionNum);
                    ResultSet rs = checkBookStmt.executeQuery();
                    if (rs.next()) {
                        result.put("success", false);
                        result.put("message", "This book is currently issued to another student");
                        out.print(new Gson().toJson(result));
                        return;
                    }
                }
                
                // 2. Check if the student has reached the maximum issue limit
                String studentCheckSql = "SELECT COUNT(*) FROM book_issues WHERE crn = ? AND status = 'ISSUED'";
                try (PreparedStatement studentCheckStmt = conn.prepareStatement(studentCheckSql)) {
                    studentCheckStmt.setString(1, crn);
                    ResultSet rs = studentCheckStmt.executeQuery();
                    if (rs.next() && rs.getInt(1) >= 3) { // Assuming max 3 books per student
                        result.put("success", false);
                        result.put("message", "This student has reached the maximum number of issued books (3)");
                        out.print(new Gson().toJson(result));
                        return;
                    }
                }
                
                // 3. Verify book exists in booksData table and get details
                String verifyBookSql = "SELECT book_name, author, edition FROM booksData WHERE accession_number = ?";
                try (PreparedStatement verifyBookStmt = conn.prepareStatement(verifyBookSql)) {
                    verifyBookStmt.setInt(1, accessionNum);
                    ResultSet rs = verifyBookStmt.executeQuery();
                    if (!rs.next()) {
                        result.put("success", false);
                        result.put("message", "Book with accession number " + accessionNum + " not found");
                        out.print(new Gson().toJson(result));
                        return;
                    }
                    // Use book details from database rather than form input
                    bookTitle = rs.getString("book_name");
                    author = rs.getString("author");
                    edition = rs.getString("edition");
                }
                
                // 4. Insert the new issue record
                String insertSql = "INSERT INTO book_issues (crn, student_name, contact, course, " +
                                 "accession_number, book_title, author, edition, issue_date, due_date, status) " +
                                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'ISSUED')";
                
                try (PreparedStatement stmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    stmt.setString(1, crn);
                    stmt.setString(2, name);
                    stmt.setString(3, contact);
                    stmt.setString(4, course);
                    stmt.setInt(5, accessionNum);
                    stmt.setString(6, bookTitle);
                    stmt.setString(7, author);
                    stmt.setString(8, edition);
                    stmt.setDate(9, new java.sql.Date(today.getTime()));
                    stmt.setDate(10, new java.sql.Date(dueDate.getTime()));
                    
                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        conn.commit();
                        result.put("success", true);
                        result.put("message", "Book issued successfully!");
                    } else {
                        conn.rollback();
                        result.put("success", false);
                        result.put("message", "Failed to issue book - no rows affected");
                    }
                }
            } catch (SQLException e) {
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
                result.put("success", false);
                result.put("message", "Database error: " + e.getMessage());
                e.printStackTrace();
            } finally {
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true);
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            out.print(new Gson().toJson(result));
            out.flush();
            out.close();
        }
    }
    
    private String getParameter(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value != null ? value.trim() : "";
    }
}