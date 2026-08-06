package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/ViewIssuedBooksServlet")
public class ViewIssuedBooksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "HIDDEN_PASSWORD";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONArray jsonArray = new JSONArray();

        HttpSession session = request.getSession(false);
        String crn = (session != null) ? (String) session.getAttribute("crn") : null;

        if (crn == null) {
            crn = request.getParameter("crn"); // Fallback parameter query
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                String query = (crn != null && !crn.isEmpty()) 
                    ? "SELECT issue_id, accession_number, book_title, author, edition, issue_date, due_date, status, renewal_count FROM book_issues WHERE crn = ?"
                    : "SELECT issue_id, crn, student_name, accession_number, book_title, author, edition, issue_date, due_date, status, renewal_count FROM book_issues";
                
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    if (crn != null && !crn.isEmpty()) {
                        pstmt.setString(1, crn);
                    }
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            JSONObject obj = new JSONObject();
                            obj.put("issue_id", rs.getInt("issue_id"));
                            if (crn == null || crn.isEmpty()) {
                                obj.put("crn", rs.getString("crn"));
                                obj.put("student_name", rs.getString("student_name"));
                            }
                            obj.put("accession_number", rs.getInt("accession_number"));
                            obj.put("book_title", rs.getString("book_title"));
                            obj.put("author", rs.getString("author"));
                            obj.put("edition", rs.getString("edition"));
                            obj.put("issue_date", rs.getString("issue_date"));
                            obj.put("due_date", rs.getString("due_date"));
                            obj.put("status", rs.getString("status"));
                            obj.put("renewal_count", rs.getInt("renewal_count"));
                            jsonArray.put(obj);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        out.print(jsonArray.toString());
        out.flush();
    }
}