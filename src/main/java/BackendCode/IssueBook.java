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
    private static final long serialVersionUID = 1L;
    private static final String JDBC_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
    private static final String JDBC_USER = "avnadmin";
    private static final String JDBC_PASSWORD = "AVNS_M_y84BDpUY38oAAS0w1";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        Connection conn = null;
        
        try {
            String crn = getParameter(request, "crn");
            String name = getParameter(request, "name");
            String contact = getParameter(request, "contact");
            String course = getParameter(request, "course");
            String accessionNo = getParameter(request, "accessionNo");
            String bookTitle = getParameter(request, "bookTitle");
            String author = getParameter(request, "author");
            String edition = getParameter(request, "edition");
            String dueDateStr = getParameter(request, "dueDate");
            
            if (crn.isEmpty() || accessionNo.isEmpty() || dueDateStr.isEmpty()) {
                result.put("success", false);
                result.put("message", "Required fields are missing");
                out.print(new Gson().toJson(result));
                return;
            }
            
            crn = crn.toUpperCase();
            int accessionNum = Integer.parseInt(accessionNo);
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            conn.setAutoCommit(false);
            
            try {
                // 1. Check if the book exists in the catalog (booksdata)
                String checkCatalogSql = "SELECT book_name FROM booksdata WHERE accession_number = ?";
                try (PreparedStatement catalogStmt = conn.prepareStatement(checkCatalogSql)) {
                    catalogStmt.setInt(1, accessionNum);
                    try (ResultSet catalogRs = catalogStmt.executeQuery()) {
                        if (!catalogRs.next()) {
                            result.put("success", false);
                            result.put("alreadyIssued", true);
                            result.put("message", "This book is not available in the library! Please check the book accession number.");
                            out.print(new Gson().toJson(result));
                            return;
                        }
                    }
                }

                // 2. Check if the book is already active/issued to someone else
                String checkBookSql = "SELECT status FROM book_issues WHERE accession_number = ? AND status != 'RETURNED'";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkBookSql)) {
                    checkStmt.setInt(1, accessionNum);
                    ResultSet rs = checkStmt.executeQuery();
                    if (rs.next()) {
                        result.put("success", false);
                        result.put("alreadyIssued", true);
                        result.put("message", "This book (Accession No: " + accessionNum + ") is already issued to another student!");
                        out.print(new Gson().toJson(result));
                        return;
                    }
                }
                
                // 3. Insert new issue record
                String insertSql = "INSERT INTO book_issues (crn, student_name, contact, course, " +
                                 "accession_number, book_title, author, edition, issue_date, due_date, status, fine_amount) " +
                                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURDATE(), ?, 'ISSUED', 0.0)";
                
                try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                    stmt.setString(1, crn);
                    stmt.setString(2, name);
                    stmt.setString(3, contact);
                    stmt.setString(4, course);
                    stmt.setInt(5, accessionNum);
                    stmt.setString(6, bookTitle);
                    stmt.setString(7, author);
                    stmt.setString(8, edition);
                    stmt.setString(9, dueDateStr);
                    
                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        conn.commit();
                        result.put("success", true);
                        result.put("message", "Book issued successfully!");
                    } else {
                        conn.rollback();
                        result.put("success", false);
                        result.put("message", "Failed to issue book.");
                    }
                }
            } catch (SQLException e) {
                if (conn != null) conn.rollback();
                result.put("success", false);
                result.put("message", "Database error: " + e.getMessage());
            } finally {
                if (conn != null) { conn.setAutoCommit(true); conn.close(); }
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Error: " + e.getMessage());
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