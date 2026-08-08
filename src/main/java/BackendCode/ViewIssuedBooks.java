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

@WebServlet("/ViewIssuedBooks")
public class ViewIssuedBooks extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "AVNS_M_y84BDpUY38oAAS0w1";

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
        List<Map<String, Object>> issueList = new ArrayList<>();
        LocalDate today = LocalDate.now();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                
                String query = "SELECT issue_id, crn, student_name, contact, course, accession_number, " +
                               "book_title, author, edition, issue_date, due_date, status, fine_amount " +
                               "FROM book_issues WHERE status != 'RETURNED'";
                
                try (PreparedStatement pstmt = conn.prepareStatement(query);
                     ResultSet rs = pstmt.executeQuery()) {
                    
                    while (rs.next()) {
                        int issueId = rs.getInt("issue_id");
                        java.sql.Date sqlDueDate = rs.getDate("due_date");
                        String currentStatus = rs.getString("status");
                        double fineAmount = rs.getDouble("fine_amount");
                        String calculatedStatus = currentStatus != null ? currentStatus : "ISSUED";

                        if (sqlDueDate != null) {
                            LocalDate dueDate = sqlDueDate.toLocalDate();
                            long daysLate = ChronoUnit.DAYS.between(dueDate, today);

                            if (daysLate > 0) {
                                // ₹5 per day fine calculation
                                fineAmount = daysLate * 5.0;

                                // 20 days or more past due date = Defaulter, otherwise Overdue
                                if (daysLate >= 20) {
                                    calculatedStatus = "DEFAULTER";
                                } else {
                                    calculatedStatus = "OVERDUE";
                                }

                                // Update status and fine in database automatically
                                String updateSql = "UPDATE book_issues SET fine_amount = ?, status = ? WHERE issue_id = ?";
                                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                                    updateStmt.setDouble(1, fineAmount);
                                    updateStmt.setString(2, calculatedStatus);
                                    updateStmt.setInt(3, issueId);
                                    updateStmt.executeUpdate();
                                }
                            }
                        }

                        Map<String, Object> item = new HashMap<>();
                        item.put("issueId", issueId);
                        item.put("crn", rs.getString("crn"));
                        item.put("studentName", rs.getString("student_name"));
                        item.put("contact", rs.getString("contact") != null ? rs.getString("contact") : "N/A");
                        item.put("course", rs.getString("course"));
                        item.put("accessionNumber", rs.getInt("accession_number"));
                        item.put("bookTitle", rs.getString("book_title"));
                        item.put("author", rs.getString("author"));
                        item.put("edition", rs.getString("edition"));
                        item.put("issueDate", rs.getDate("issue_date") != null ? rs.getDate("issue_date").toString() : "");
                        item.put("dueDate", sqlDueDate != null ? sqlDueDate.toString() : "");
                        item.put("status", calculatedStatus);
                        item.put("fineAmount", fineAmount);

                        issueList.add(item);
                    }
                }
            }

            jsonResponse.put("success", true);
            jsonResponse.put("data", issueList);

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