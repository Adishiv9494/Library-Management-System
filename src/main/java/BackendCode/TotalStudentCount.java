package BackendCode;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/TotalStudentCount")
public class TotalStudentCount extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC", "avnadmin", "AVNS_M_y84BDpUY38oAAS0w1");
            
            // Accurately sum all students across all course tables
            String query = "SELECT " +
                           "(SELECT COUNT(*) FROM bba_students) + " +
                           "(SELECT COUNT(*) FROM bca_students) + " +
                           "(SELECT COUNT(*) FROM btech_students) + " +
                           "(SELECT COUNT(*) FROM mba_students) + " +
                           "(SELECT COUNT(*) FROM mca_students) + " +
                           "(SELECT COUNT(*) FROM ptech_students) AS total_students";
                           
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                response.getWriter().write(String.valueOf(rs.getInt("total_students")));
            } else {
                response.getWriter().write("0");
            }
            rs.close(); ps.close(); conn.close();
        } catch (Exception e) { 
            response.getWriter().write("0"); 
        }
    }
}