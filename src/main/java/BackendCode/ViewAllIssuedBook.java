package BackendCode;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
import com.google.gson.GsonBuilder;

@WebServlet("/ViewAllIssuedBook")
public class ViewAllIssuedBook extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String crn = request.getParameter("crn");
        String studentName = request.getParameter("studentName");
        String course = request.getParameter("course");
        String status = request.getParameter("status");

        List<Map<String, Object>> issuedBooks = new ArrayList<>();
        Map<String, Object> result = new HashMap<>();
        LocalDate today = LocalDate.now();

        try (Connection conn = DatabaseConnection.getConnection()) {
            StringBuilder sql = new StringBuilder(
                "SELECT issue_id, crn, student_name, contact, course, " +
                "accession_number, book_title, author, edition, " +
                "issue_date, due_date, return_date, fine_amount, status " +
                "FROM book_issues WHERE 1=1"
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
            if (status != null && !status.isEmpty()) {
                sql.append(" AND status = ?");
                params.add(status);
            }
            sql.append(" ORDER BY issue_date DESC");

            try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    int issueId = rs.getInt("issue_id");
                    java.sql.Date sqlDueDate = rs.getDate("due_date");
                    String currentStatus = rs.getString("status");
                    double fineAmount = rs.getDouble("fine_amount");
                    String calculatedStatus = currentStatus != null ? currentStatus : "ISSUED";

                    // Calculate fine and dynamic status if not returned
                    if (!"RETURNED".equalsIgnoreCase(calculatedStatus) && sqlDueDate != null) {
                        LocalDate dueDate = sqlDueDate.toLocalDate();
                        long daysLate = ChronoUnit.DAYS.between(dueDate, today);

                        if (daysLate > 0) {
                            // ₹5 per day fine category
                            fineAmount = daysLate * 5.0;

                            // 20 days unreturned = Defaulter, else Overdue
                            if (daysLate >= 20) {
                                calculatedStatus = "DEFAULTER";
                            } else {
                                calculatedStatus = "OVERDUE";
                            }

                            // Update in database automatically
                            String updateSql = "UPDATE book_issues SET fine_amount = ?, status = ? WHERE issue_id = ?";
                            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                                updateStmt.setDouble(1, fineAmount);
                                updateStmt.setString(2, calculatedStatus);
                                updateStmt.setInt(3, issueId);
                                updateStmt.executeUpdate();
                            }
                        }
                    }

                    Map<String, Object> map = new HashMap<>();
                    map.put("issueId", issueId);
                    map.put("crn", rs.getString("crn"));
                    map.put("studentName", rs.getString("student_name"));
                    map.put("contact", rs.getString("contact"));
                    map.put("course", rs.getString("course"));
                    map.put("accessionNumber", rs.getInt("accession_number"));
                    map.put("bookTitle", rs.getString("book_title"));
                    map.put("author", rs.getString("author"));
                    map.put("edition", rs.getString("edition"));
                    map.put("issueDate", rs.getDate("issue_date"));
                    map.put("dueDate", sqlDueDate);
                    map.put("returnDate", rs.getDate("return_date"));
                    map.put("fine_amount", fineAmount);
                    map.put("status", calculatedStatus);
                    issuedBooks.add(map);
                }
            }
            result.put("success", true);
            result.put("data", issuedBooks);
        } catch (SQLException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
            e.printStackTrace();
        }
        response.getWriter().print(new GsonBuilder().setDateFormat("yyyy-MM-dd").create().toJson(result));
    }
}