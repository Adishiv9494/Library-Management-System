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

@WebServlet("/BookRecordsServlet")
public class BookRecordsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Connects to defaultdb based on exact schema
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "AVNS_M_y84BDpUY38oAAS0w1";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        int page = 1;
        int limit = 10;
        String search = request.getParameter("search");

        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
            if (request.getParameter("limit") != null) limit = Integer.parseInt(request.getParameter("limit"));
        } catch (NumberFormatException e) {
            page = 1;
            limit = 10;
        }

        int offset = (page - 1) * limit;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                
                String countQuery = "SELECT COUNT(*) FROM booksdata";
                String dataQuery = "SELECT accession_number, book_name, author, publisher, edition, price FROM booksdata";
                
                boolean hasSearch = (search != null && !search.trim().isEmpty());
                if (hasSearch) {
                    String searchFilter = " WHERE accession_number LIKE ? OR book_name LIKE ? OR author LIKE ? OR publisher LIKE ?";
                    countQuery += searchFilter;
                    dataQuery += searchFilter;
                }
                
                dataQuery += " ORDER BY accession_number ASC LIMIT ? OFFSET ?";

                // Get Total Count
                int totalRecords = 0;
                try (PreparedStatement countStmt = conn.prepareStatement(countQuery)) {
                    if (hasSearch) {
                        String likeSearch = "%" + search.trim() + "%";
                        for (int i = 1; i <= 4; i++) countStmt.setString(i, likeSearch);
                    }
                    try (ResultSet rsCount = countStmt.executeQuery()) {
                        if (rsCount.next()) totalRecords = rsCount.getInt(1);
                    }
                }

                // Get Data
                StringBuilder json = new StringBuilder();
                json.append("{ \"totalRecords\": ").append(totalRecords).append(", \"data\": [");
                
                try (PreparedStatement dataStmt = conn.prepareStatement(dataQuery)) {
                    int paramIndex = 1;
                    if (hasSearch) {
                        String likeSearch = "%" + search.trim() + "%";
                        for (int i = 1; i <= 4; i++) dataStmt.setString(paramIndex++, likeSearch);
                    }
                    dataStmt.setInt(paramIndex++, limit);
                    dataStmt.setInt(paramIndex, offset);

                    try (ResultSet rs = dataStmt.executeQuery()) {
                        boolean first = true;
                        while (rs.next()) {
                            if (!first) json.append(",");
                            json.append("{");
                            json.append("\"accession_number\":").append(rs.getInt("accession_number")).append(",");
                            json.append("\"book_name\":\"").append(escapeJson(rs.getString("book_name"))).append("\",");
                            json.append("\"author\":\"").append(escapeJson(rs.getString("author"))).append("\",");
                            json.append("\"publisher\":\"").append(escapeJson(rs.getString("publisher"))).append("\",");
                            json.append("\"edition\":\"").append(escapeJson(rs.getString("edition"))).append("\",");
                            json.append("\"price\":").append(rs.getDouble("price"));
                            json.append("}");
                            first = false;
                        }
                    }
                }
                json.append("]}");
                out.print(json.toString());
            }
        } catch (Exception e) {
            out.print("{ \"error\": \"Database connection failed: " + escapeJson(e.getMessage()) + "\" }");
        }
    }

    private String escapeJson(String data) {
        if (data == null) return "";
        return data.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}