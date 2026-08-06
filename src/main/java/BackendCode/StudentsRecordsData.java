package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/StudentsRecordsData")
public class StudentsRecordsData extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "HIDDEN_PASSWORD";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        JSONObject jsonResponse = new JSONObject();
        JSONArray jsonArray = new JSONArray();

        String course = request.getParameter("course");
        String searchCRN = request.getParameter("searchCRN");
        String searchName = request.getParameter("searchName");
        
        int page = 1;
        int limit = 10;
        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
            if (request.getParameter("limit") != null) limit = Integer.parseInt(request.getParameter("limit"));
        } catch (NumberFormatException ignored) {}

        int offset = (page - 1) * limit;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                
                // Base subquery or union query to gather all relevant student rows based on course filter
                String sourceQuery = "";
                if (course == null || course.trim().isEmpty() || course.equalsIgnoreCase("all")) {
                    sourceQuery = "(SELECT crn, name, course, contact, is_defaulter FROM bba_students " +
                                  "UNION ALL SELECT crn, name, course, contact, is_defaulter FROM bca_students " +
                                  "UNION ALL SELECT crn, name, course, contact, is_defaulter FROM mba_students " +
                                  "UNION ALL SELECT crn, name, course, contact, is_defaulter FROM mca_students " +
                                  "UNION ALL SELECT crn, name, course, contact, is_defaulter FROM btech_students " +
                                  "UNION ALL SELECT crn, name, course, contact, is_defaulter FROM ptech_students)";
                } else {
                    String cleanCourse = course.toLowerCase().replaceAll("[^a-z]", "");
                    sourceQuery = cleanCourse + "_students";
                }

                // Build dynamic filters for CRN and Name search
                StringBuilder whereClause = new StringBuilder(" WHERE 1=1");
                List<String> params = new ArrayList<>();

                if (searchCRN != null && !searchCRN.trim().isEmpty()) {
                    whereClause.append(" AND crn LIKE ?");
                    params.add("%" + searchCRN.trim() + "%");
                }
                if (searchName != null && !searchName.trim().isEmpty()) {
                    whereClause.append(" AND name LIKE ?");
                    params.add("%" + searchName.trim() + "%");
                }

                // 1. Get total records count for pagination
                String countSql = "SELECT COUNT(*) FROM " + sourceQuery + " AS sub" + whereClause.toString();
                int totalRecords = 0;
                try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
                    for (int i = 0; i < params.size(); i++) {
                        countStmt.setString(i + 1, params.get(i));
                    }
                    try (ResultSet rsCount = countStmt.executeQuery()) {
                        if (rsCount.next()) {
                            totalRecords = rsCount.getInt(1);
                        }
                    }
                }

                // 2. Get paginated data
                String dataSql = "SELECT crn, name, course, contact, is_defaulter FROM " + sourceQuery + " AS sub" + 
                                 whereClause.toString() + " ORDER BY crn LIMIT ? OFFSET ?";
                
                try (PreparedStatement pstmt = conn.prepareStatement(dataSql)) {
                    int idx = 1;
                    for (String p : params) {
                        pstmt.setString(idx++, p);
                    }
                    pstmt.setInt(idx++, limit);
                    pstmt.setInt(idx++, offset);

                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            JSONObject obj = new JSONObject();
                            obj.put("crn", rs.getString("crn") != null ? rs.getString("crn") : "");
                            obj.put("name", rs.getString("name") != null ? rs.getString("name") : ""); // Fixed syntax bracket here
                            obj.put("course", rs.getString("course") != null ? rs.getString("course") : "");
                            obj.put("contact", rs.getString("contact") != null ? rs.getString("contact") : "");
                            obj.put("is_defaulter", rs.getBoolean("is_defaulter"));
                            jsonArray.put(obj);
                        }
                    }
                }

                jsonResponse.put("totalRecords", totalRecords);
                jsonResponse.put("data", jsonArray);

            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("error", e.getMessage());
        }

        out.print(jsonResponse.toString());
        out.flush();
    }
}