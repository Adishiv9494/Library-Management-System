package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/PendingFineServlet")
public class PendingFineServlet extends HttpServlet {
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
        
        Map<String, Object> jsonResponse = new HashMap<>();
        List<Map<String, Object>> fineList = new ArrayList<>();
        LocalDate today = LocalDate.now();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                
                // Fetch active issued or overdue records
                String query = "SELECT issue_id, crn, student_name, contact, due_date, status FROM book_issues WHERE status != 'RETURNED'";
                
                try (PreparedStatement pstmt = conn.prepareStatement(query);
                     ResultSet rs = pstmt.executeQuery()) {
                    
                    while (rs.next()) {
                        java.sql.Date sqlDueDate = rs.getDate("due_date");
                        if (sqlDueDate == null) continue;
                        
                        LocalDate dueDate = sqlDueDate.toLocalDate();
                        long daysLate = ChronoUnit.DAYS.between(dueDate, today);
                        
                        String currentStatus = rs.getString("status");
                        double fineAmount = 0.0;
                        String calculatedStatus = "ISSUED";

                        if (daysLate > 0) {
                            // ₹5 per day fine calculation
                            fineAmount = daysLate * 5.0;
                            
                            if (daysLate > 20) {
                                calculatedStatus = "DEFAULTER"; // 20+ days late = Defaulter (Red)
                            } else {
                                calculatedStatus = "OVERDUE";   // 1 to 20 days late = Overdue (Yellow)
                            }
                            
                            // Automatically update the status and fine in database
                            String updateSql = "UPDATE book_issues SET fine_amount = ?, status = ? WHERE issue_id = ?";
                            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                                updateStmt.setDouble(1, fineAmount);
                                updateStmt.setString(2, calculatedStatus);
                                updateStmt.setInt(3, rs.getInt("issue_id"));
                                updateStmt.executeUpdate();
                            }
                        } else {
                            calculatedStatus = currentStatus;
                        }

                        // Aggregate response entry
                        Map<String, Object> item = new HashMap<>();
                        item.put("crn", rs.getString("crn"));
                        item.put("name", rs.getString("student_name"));
                        item.put("contact", rs.getString("contact") != null ? rs.getString("contact") : "N/A");
                        item.put("dueDate", sqlDueDate.toString());
                        item.put("totalFine", fineAmount);
                        item.put("status", calculatedStatus);
                        
                        // Include if fines apply or status is overdue/defaulter
                        if (fineAmount > 0 || calculatedStatus.equals("OVERDUE") || calculatedStatus.equals("DEFAULTER")) {
                            fineList.add(item);
                        }
                    }
                }
            }
            
            jsonResponse.put("success", true);
            jsonResponse.put("data", fineList);
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", e.getMessage());
            jsonResponse.put("data", new ArrayList<>());
        }

        Gson gson = new Gson();
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}