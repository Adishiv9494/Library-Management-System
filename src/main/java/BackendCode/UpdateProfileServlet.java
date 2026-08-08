package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "AVNS_M_y84BDpUY38oAAS0w1";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Unauthorized session. Please login again.");
            out.print(jsonResponse.toString());
            return;
        }

        String sessionEmail = (String) session.getAttribute("email");
        String fullName = request.getParameter("fullName");
        String contactNumber = request.getParameter("contactNumber");
        String department = request.getParameter("department");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                String sql = "UPDATE student_signup SET full_name = ?, contact_number = ?, department = ? WHERE email = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, fullName);
                    pstmt.setString(2, contactNumber);
                    pstmt.setString(3, department);
                    pstmt.setString(4, sessionEmail);

                    int rows = pstmt.executeUpdate();
                    if (rows > 0) {
                        session.setAttribute("full_name", fullName);
                        session.setAttribute("contact", contactNumber);
                        session.setAttribute("department", department);

                        jsonResponse.put("success", true);
                        jsonResponse.put("message", "Profile updated successfully!");
                    } else {
                        jsonResponse.put("success", false);
                        jsonResponse.put("message", "Profile update failed. User not found.");
                    }
                }
            }
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error: " + e.getMessage());
            e.printStackTrace();
        }

        out.print(jsonResponse.toString());
        out.flush();
    }
}