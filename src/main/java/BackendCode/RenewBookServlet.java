package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/RenewBook")
public class RenewBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "AVNS_M_y84BDpUY38oAAS0w1";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        String issueIdStr = request.getParameter("issueId");
        if (issueIdStr == null || issueIdStr.trim().isEmpty()) {
            issueIdStr = request.getParameter("issue_id");
        }
        String newDueDate = request.getParameter("newDueDate");

        if (issueIdStr == null || issueIdStr.trim().isEmpty() || newDueDate == null || newDueDate.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Issue ID and new due date are required.");
            out.print(new Gson().toJson(result));
            return;
        }

        try {
            int issueId = Integer.parseInt(issueIdStr);
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                String sql = "UPDATE book_issues SET due_date = ?, renewal_count = renewal_count + 1, status = 'ISSUED', fine_amount = 0.0 WHERE issue_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, newDueDate.trim());
                    pstmt.setInt(2, issueId);
                    int rows = pstmt.executeUpdate();

                    if (rows > 0) {
                        result.put("success", true);
                        result.put("message", "Book renewed successfully!");
                    } else {
                        result.put("success", false);
                        result.put("message", "Renewal failed: Record not found.");
                    }
                }
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Error: " + e.getMessage());
            e.printStackTrace();
        }

        out.print(new Gson().toJson(result));
        out.flush();
    }
}