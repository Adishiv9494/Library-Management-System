package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet("/FetchReturnData")
public class FetchReturnDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        String crn = request.getParameter("crn").toUpperCase();
        String accessionNo = request.getParameter("accessionNo");
        
        if (crn == null || crn.isEmpty() || accessionNo == null || accessionNo.isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "CRN and Accession Number are required");
            out.print(jsonResponse.toString());
            return;
        }
        
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            
            String sql = "SELECT i.issue_id, i.issue_date, i.due_date, i.status, " +
                         "i.student_name, i.contact, i.course, " +
                         "i.book_title, i.author, i.edition, " +
                         "DATEDIFF(CURRENT_DATE, i.due_date) AS days_overdue, " +
                         "CASE " +
                         "  WHEN i.status = 'RETURNED' THEN 0 " +
                         "  WHEN DATEDIFF(CURRENT_DATE, i.due_date) > 14 THEN 10 * DATEDIFF(CURRENT_DATE, i.due_date) " +
                         "  WHEN DATEDIFF(CURRENT_DATE, i.due_date) > 0 THEN 5 * DATEDIFF(CURRENT_DATE, i.due_date) " +
                         "  ELSE 0 " +
                         "END AS fine_amount " +
                         "FROM book_issues i " +
                         "WHERE i.crn = ? AND i.accession_number = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, crn);
            stmt.setString(2, accessionNo);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                jsonResponse.put("success", true);
                
                Map<String, Object> data = new HashMap<>();
                data.put("issue_id", rs.getInt("issue_id"));
                data.put("crn", crn);
                data.put("accession_number", accessionNo);
                data.put("student_name", rs.getString("student_name"));
                data.put("contact", rs.getString("contact"));
                data.put("course", rs.getString("course"));
                data.put("book_title", rs.getString("book_title"));
                data.put("author", rs.getString("author"));
                data.put("edition", rs.getString("edition"));
                data.put("issue_date", rs.getDate("issue_date").toString());
                data.put("due_date", rs.getDate("due_date").toString());
                
                String status = rs.getString("status");
                int daysOverdue = rs.getInt("days_overdue");
                
                if ("ISSUED".equals(status)) {
                    if (daysOverdue > 14) {
                        status = "DEFAULTER";
                    } else if (daysOverdue > 0) {
                        status = "OVERDUE";
                    } else {
                        status = "ON DUE";
                    }
                }
                
                data.put("status", status);
                data.put("fine_amount", rs.getDouble("fine_amount"));
                data.put("days_overdue", daysOverdue);
                
                jsonResponse.put("data", data);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "No issue record found for this student and book");
            }
            
        } catch (SQLException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        out.print(jsonResponse.toString());
    }
}