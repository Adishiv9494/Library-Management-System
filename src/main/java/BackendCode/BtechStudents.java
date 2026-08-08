package BackendCode;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.*;

@WebServlet("/BtechStudents")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class BtechStudents extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String dbURL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
        String dbUser = "avnadmin";
        String dbPassword = "AVNS_M_y84BDpUY38oAAS0w1";

        int successCount = 0;
        int duplicateCount = 0;
        int failureCount = 0;

        try {
            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                throw new ServletException("No file uploaded");
            }
            InputStream fileContent = filePart.getInputStream();
            Workbook workbook = WorkbookFactory.create(fileContent);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Sheet sheet = workbook.getSheetAt(0);

            try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
                String sql = "INSERT INTO btech_students (crn, name, course, contact) VALUES (?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);

                for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                    Row row = sheet.getRow(i);
                    if (row != null) {
                        String crn = getCellValue(row.getCell(0));
                        String name = getCellValue(row.getCell(1));
                        String contact = getCellValue(row.getCell(2));
                        String course = getCellValue(row.getCell(3));

                        if (crn.isEmpty()) continue;

                        pstmt.setString(1, crn);
                        pstmt.setString(2, name);
                        pstmt.setString(3, course);
                        pstmt.setString(4, contact);

                        try {
                            pstmt.executeUpdate();
                            successCount++;
                        } catch (SQLException e) {
                            if (e.getErrorCode() == 1062 || e.getSQLState().equals("23000")) {
                                duplicateCount++;
                            } else {
                                failureCount++;
                            }
                        }
                    }
                }
                workbook.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        out.println("<!DOCTYPE html><html><head><title>Import Status</title><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>");
        out.println("<script>Swal.fire({title: 'Import Completed', html: 'Success: " + successCount + "', icon: 'success'}).then(()=>window.location.href='Report.jsp');</script>");
        out.println("</body></html>");
    }

    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING: return cell.getStringCellValue().trim();
            case NUMERIC: return String.valueOf((long) cell.getNumericCellValue());
            default: return "";
        }
    }
}