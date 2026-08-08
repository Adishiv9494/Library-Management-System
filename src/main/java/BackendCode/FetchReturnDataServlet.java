package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/FetchReturnData")
public class FetchReturnDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "AVNS_M_y84BDpUY38oAAS0w1";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        String crn = request.getParameter("crn");
        String accessionNo = request.getParameter("accessionNo");

        if (crn == null || crn.trim().isEmpty() || accessionNo == null || accessionNo.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "CRN and Accession Number are required");
            out.print(new Gson().toJson(result));
            return;
        }

        LocalDate today = LocalDate.now();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                
                String sql = "SELECT issue_id, crn, student_name, contact, course, accession_number, " +
                             "book_title, author, edition, issue_date, due_date, status, fine_amount " +
                             "FROM book_issues WHERE crn = ? AND accession_number = ? ORDER BY issue_id DESC LIMIT 1";
                
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, crn.trim().toUpperCase());
                    pstmt.setInt(2, Integer.parseInt(accessionNo.trim()));
                    
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            int issueId = rs.getInt("issue_id");
                            java.sql.Date sqlDueDate = rs.getDate("due_date");
                            String currentStatus = rs.getString("status");
                            double fineAmount = rs.getDouble("fine_amount");
                            long daysOverdue = 0;
                            String calculatedStatus = currentStatus != null ? currentStatus : "PENDING";

                            if (!"RETURNED".equalsIgnoreCase(calculatedStatus) && sqlDueDate != null) {
                                LocalDate dueDate = sqlDueDate.toLocalDate();
                                long diff = ChronoUnit.DAYS.between(dueDate, today);

                                if (diff > 0) {
                                    daysOverdue = diff;
                                    // ₹5 per day fine category
                                    fineAmount = daysOverdue * 5.0;

                                    // 20 days unreturned = Defaulter, else Overdue
                                    if (daysOverdue >= 20) {
                                        calculatedStatus = "DEFAULTER";
                                    } else {
                                        calculatedStatus = "OVERDUE";
                                    }
                                } else {
                                    calculatedStatus = "ON DUE";
                                }

                                // Update DB record automatically
                                String updateSql = "UPDATE book_issues SET fine_amount = ?, status = ? WHERE issue_id = ?";
                                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                                    updateStmt.setDouble(1, fineAmount);
                                    updateStmt.setString(2, calculatedStatus);
                                    updateStmt.setInt(3, issueId);
                                    updateStmt.executeUpdate();
                                }
                            }

                            Map<String, Object> dataMap = new HashMap<>();
                            dataMap.put("issue_id", issueId);
                            dataMap.put("crn", rs.getString("crn"));
                            dataMap.put("student_name", rs.getString("student_name"));
                            dataMap.put("contact", rs.getString("contact"));
                            dataMap.put("course", rs.getString("course"));
                            dataMap.put("accession_number", rs.getInt("accession_number"));
                            dataMap.put("book_title", rs.getString("book_title"));
                            dataMap.put("author", rs.getString("author"));
                            dataMap.put("edition", rs.getString("edition"));
                            dataMap.put("issue_date", rs.getDate("issue_date"));
                            dataMap.put("due_date", sqlDueDate);
                            dataMap.put("status", calculatedStatus);
                            dataMap.put("fine_amount", fineAmount);
                            dataMap.put("days_overdue", daysOverdue);

                            result.put("success", true);
                            result.put("data", dataMap);
                        } else {
                            result.put("success", false);
                            result.put("message", "No active issue record found for this CRN and Accession Number.");
                        }
                    }
                }
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