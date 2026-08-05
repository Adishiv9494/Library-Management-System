package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet("/ReturnBook")
public class ReturnBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        String crn = request.getParameter("crn");
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
            conn.setAutoCommit(false);
            
            String checkSql = "SELECT i.issue_id, i.issue_date, i.due_date, i.status, " +
                             "DATEDIFF(CURRENT_DATE, i.due_date) AS days_overdue " +
                             "FROM book_issues i " +
                             "WHERE i.crn = ? AND i.accession_number = ? AND i.status != 'RETURNED'";
            
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, crn);
            checkStmt.setString(2, accessionNo);
            
            ResultSet rs = checkStmt.executeQuery();
            
            if (!rs.next()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "No active issue found for this student and book");
                out.print(jsonResponse.toString());
                return;
            }
            
            int issueId = rs.getInt("issue_id");
            String currentStatus = rs.getString("status");
            int daysOverdue = rs.getInt("days_overdue");
            
            double fineAmount = 0.0;
            if (daysOverdue > 0) {
                fineAmount = daysOverdue * 10.0;
            }
            
            String updateSql = "UPDATE book_issues SET status = 'RETURNED', return_date = CURRENT_DATE, fine_amount = ? WHERE issue_id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setDouble(1, fineAmount);
            updateStmt.setInt(2, issueId);
            int rowsUpdated = updateStmt.executeUpdate();
            
            if (rowsUpdated == 0) {
                conn.rollback();
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Failed to update issue status");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Removed the update to available_copies since the column doesn't exist
            // If you need to track availability, you'll need to add this column to your booksData table
            
            conn.commit();
            
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Book successfully returned");
            
            Map<String, Object> data = new HashMap<>();
            data.put("issue_id", issueId);
            data.put("crn", crn);
            data.put("accession_number", accessionNo);
            data.put("status", "RETURNED");
            data.put("fine_amount", fineAmount);
            data.put("days_overdue", daysOverdue);
            
            jsonResponse.put("data", data);
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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