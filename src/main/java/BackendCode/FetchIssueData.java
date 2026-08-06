package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/FetchIssueData")
public class FetchIssueData extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "HIDDEN_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        String crn = request.getParameter("crn");
        String accessionNoStr = request.getParameter("accessionNo");

        if (crn == null || crn.trim().isEmpty() || accessionNoStr == null || accessionNoStr.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "CRN and Accession Number are required");
            out.print(new Gson().toJson(result));
            return;
        }

        crn = crn.trim().toUpperCase();
        int accessionNo = 0;
        try {
            accessionNo = Integer.parseInt(accessionNoStr.trim());
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Invalid Accession Number format");
            out.print(new Gson().toJson(result));
            return;
        }

        Map<String, Object> studentMap = new HashMap<>();
        Map<String, Object> bookMap = new HashMap<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                
                // 1. Check if this book is already issued to someone else
                String checkIssuedSql = "SELECT status FROM book_issues WHERE accession_number = ? AND status != 'RETURNED'";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkIssuedSql)) {
                    checkStmt.setInt(1, accessionNo);
                    try (ResultSet rsCheck = checkStmt.executeQuery()) {
                        if (rsCheck.next()) {
                            result.put("success", false);
                            result.put("message", "This book (Accession No: " + accessionNo + ") is already issued and not available!");
                            out.print(new Gson().toJson(result));
                            return;
                        }
                    }
                }

                // 2. Search student across all departmental tables
                String[] studentTables = {"bca_students", "bba_students", "mba_students", "mca_students", "btech_students", "ptech_students"};
                boolean studentFound = false;

                for (String table : studentTables) {
                    String studentQuery = "SELECT name, contact, course FROM " + table + " WHERE crn = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(studentQuery)) {
                        pstmt.setString(1, crn);
                        try (ResultSet rs = pstmt.executeQuery()) {
                            if (rs.next()) {
                                studentMap.put("name", rs.getString("name"));
                                studentMap.put("contact", rs.getString("contact"));
                                studentMap.put("course", rs.getString("course"));
                                studentFound = true;
                                break;
                            }
                        }
                    } catch (Exception ignored) {}
                }

                if (!studentFound) {
                    result.put("success", false);
                    result.put("message", "Student with CRN " + crn + " not found in records.");
                    out.print(new Gson().toJson(result));
                    return;
                }

                // 3. Search book details in booksdata table
                String bookQuery = "SELECT book_name, author, edition, accession_number FROM booksdata WHERE accession_number = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(bookQuery)) {
                    pstmt.setInt(1, accessionNo);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            bookMap.put("book_name", rs.getString("book_name"));
                            bookMap.put("author", rs.getString("author"));
                            bookMap.put("edition", rs.getString("edition"));
                            bookMap.put("accession_number", rs.getInt("accession_number"));
                        } else {
                            result.put("success", false);
                            result.put("message", "Book with Accession Number " + accessionNo + " does not exist in the library catalog.");
                            out.print(new Gson().toJson(result));
                            return;
                        }
                    }
                }

                result.put("success", true);
                result.put("student", studentMap);
                result.put("book", bookMap);

            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Database error: " + e.getMessage());
        }

        out.print(new Gson().toJson(result));
        out.flush();
    }
}