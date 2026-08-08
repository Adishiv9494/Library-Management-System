package BackendCode;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/IssuesBooksCount")
public class IssuesBooksCount extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC", "avnadmin", "AVNS_M_y84BDpUY38oAAS0w1");
            
            // Accurately counts books that are currently out (ISSUED, ON DUE, OVERDUE)
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM book_issues WHERE status IN ('ISSUED', 'ON DUE', 'OVERDUE')");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                response.getWriter().write(String.valueOf(rs.getInt(1)));
            } else {
                response.getWriter().write("0");
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { response.getWriter().write("0"); }
    }
}