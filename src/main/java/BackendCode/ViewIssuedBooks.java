package BackendCode;

import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/ViewIssuedBooks")
public class ViewIssuedBooks extends HttpServlet {
	private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
	private static final String DB_USER = "avnadmin";
	private static final String DB_PASSWORD = "HIDDEN_PASSWORD";
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            getIssuedBooks(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(error.toString());
        }
    }

    private void getIssuedBooks(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        List<Map<String, Object>> issuedBooks = new ArrayList<>();
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String crn = request.getParameter("crn");
        String studentName = request.getParameter("studentName");
        String course = request.getParameter("course");
        
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            StringBuilder sql = new StringBuilder(
                "SELECT issue_id, crn, student_name, contact, course, " +
                "accession_number, book_title, author, edition, " +
                "issue_date, due_date, status " +
                "FROM book_issues WHERE status IN ('ISSUED', 'OVERDUE')"
            );
            List<Object> params = new ArrayList<>();
            
            if (fromDate != null && !fromDate.isEmpty()) {
                sql.append(" AND issue_date >= ?");
                params.add(fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                sql.append(" AND issue_date <= ?");
                params.add(toDate);
            }
            if (crn != null && !crn.isEmpty()) {
                sql.append(" AND crn LIKE ?");
                params.add("%" + crn + "%");
            }
            if (studentName != null && !studentName.isEmpty()) {
                sql.append(" AND student_name LIKE ?");
                params.add("%" + studentName + "%");
            }
            if (course != null && !course.isEmpty()) {
                sql.append(" AND course = ?");
                params.add(course);
            }
            sql.append(" ORDER BY issue_date DESC");
            
            try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i+1, params.get(i));
                }
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, Object> book = new HashMap<>();
                    book.put("issueId", rs.getInt("issue_id"));
                    book.put("crn", rs.getString("crn"));
                    book.put("studentName", rs.getString("student_name"));
                    book.put("contact", rs.getString("contact"));
                    book.put("course", rs.getString("course"));
                    book.put("accessionNumber", rs.getInt("accession_number"));
                    book.put("bookTitle", rs.getString("book_title"));
                    book.put("author", rs.getString("author"));
                    book.put("edition", rs.getString("edition"));
                    book.put("issueDate", rs.getDate("issue_date") != null ? DATE_FORMAT.format(rs.getDate("issue_date")) : null);
                    book.put("dueDate", rs.getDate("due_date") != null ? DATE_FORMAT.format(rs.getDate("due_date")) : null);
                    book.put("status", rs.getString("status"));
                    issuedBooks.add(book);
                }
            }
        }
        
        JSONObject json = new JSONObject();
        json.put("success", true);
        json.put("data", new JSONArray(issuedBooks));
        response.getWriter().write(json.toString());
    }
}