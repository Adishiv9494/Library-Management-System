package BackendCode;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AvailableBooksCount")
public class PendingBooksCount extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int count = 0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC", "avnadmin", "HIDDEN_PASSWORD")) {

                // Total books minus books currently checked out (status != 'RETURNED')
                String sql = "SELECT (SELECT COUNT(*) FROM booksdata) - (SELECT COUNT(DISTINCT accession_number) FROM book_issues WHERE status != 'RETURNED')";
                try (PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        count = rs.getInt(1);
                        if (count < 0) count = 0;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setContentType("text/plain");
        response.getWriter().write(String.valueOf(count));
    }
}