package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet("/RenewBook")
public class RenewBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        String crn = request.getParameter("crn");
        String accessionNo = request.getParameter("accessionNo");
        String newDueDate = request.getParameter("newDueDate");
        int issueId = Integer.parseInt(request.getParameter("issueId"));
        
        if (crn == null || crn.isEmpty() || accessionNo == null || accessionNo.isEmpty() || newDueDate == null || newDueDate.isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "All fields are required");
            out.print(jsonResponse.toString());
            return;
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date dueDate;
        try {
            dueDate = sdf.parse(newDueDate);
            Date today = new Date();
            
            if (dueDate.before(today)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "New due date must be in the future");
                out.print(jsonResponse.toString());
                return;
            }
        } catch (ParseException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Invalid date format");
            out.print(jsonResponse.toString());
            return;
        }
        
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Check if book is overdue by more than 14 days
            String checkSql = "SELECT DATEDIFF(CURRENT_DATE, due_date) AS days_overdue, status FROM book_issues WHERE issue_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, issueId);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                int daysOverdue = rs.getInt("days_overdue");
                String currentStatus = rs.getString("status");
                
                if (daysOverdue > 14 && "OVERDUE".equals(currentStatus)) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Book is overdue by more than 2 weeks. Cannot renew.");
                    out.print(jsonResponse.toString());
                    return;
                }
            }
            
            // Update both due date and set status to ISSUED (since PENDING isn't in our ENUM)
            String updateSql = "UPDATE book_issues SET due_date = ?, status = 'ISSUED' WHERE issue_id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setString(1, newDueDate);
            updateStmt.setInt(2, issueId);
            
            int rowsUpdated = updateStmt.executeUpdate();
            
            if (rowsUpdated == 0) {
                conn.rollback();
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Failed to renew book");
                out.print(jsonResponse.toString());
                return;
            }
            
            conn.commit();
            
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Book successfully renewed until " + newDueDate + ". Status set to ISSUED.");
            
            Map<String, Object> data = new HashMap<>();
            data.put("issue_id", issueId);
            data.put("crn", crn);
            data.put("accession_number", accessionNo);
            data.put("new_due_date", newDueDate);
            data.put("status", "ISSUED");
            
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