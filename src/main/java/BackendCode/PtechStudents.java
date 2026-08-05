package BackendCode;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.*;

@WebServlet("/PtechStudents")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class PtechStudents extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String dbURL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
        String dbUser = "avnadmin";
        String dbPassword = "HIDDEN_PASSWORD";

        int successCount = 0;
        int duplicateCount = 0;
        int failureCount = 0;
        StringBuilder duplicateDetails = new StringBuilder();

        try {
            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                throw new ServletException("No file uploaded");
            }
            InputStream fileContent = filePart.getInputStream();

            Workbook workbook;
            try {
                workbook = WorkbookFactory.create(fileContent);
            } catch (NoClassDefFoundError e) {
                out.println("<!DOCTYPE html><html><head><title>Missing JAR</title><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>");
                out.println("<script>Swal.fire({title:'Missing JAR',text:'The required POI OOXML Full jar is missing from WEB-INF/lib. Please add poi-ooxml-full-5.2.5.jar',icon:'error',confirmButtonText:'OK'}).then(()=>window.history.back());</script>");
                out.println("</body></html>");
                return;
            }

            Class.forName("com.mysql.cj.jdbc.Driver");

            Sheet sheet = workbook.getSheetAt(0);

            try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
                String sql = "INSERT INTO ptech_students (crn, name, course, contact) VALUES (?, ?, ?, ?)";
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
                                duplicateDetails.append(crn).append(", ");
                            } else {
                                failureCount++;
                            }
                            System.err.println("Insert failed for CRN " + crn + ": " + e.getMessage());
                        }
                    }
                }
                workbook.close();
            }

        } catch (ClassNotFoundException e) {
            out.println("<!DOCTYPE html><html><head><title>Error</title><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>");
            out.println("<script>Swal.fire({title:'MySQL Driver Error',text:'MySQL JDBC driver not found. Please add mysql-connector-java-8.0.33.jar to WEB-INF/lib',icon:'error',confirmButtonText:'OK'}).then(()=>window.history.back());</script>");
            out.println("</body></html>");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<!DOCTYPE html><html><head><title>Error</title><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>");
            out.println("<script>Swal.fire({title:'Import Failed',text:'" + e.getMessage().replace("'", "\\'") + "',icon:'error',confirmButtonText:'OK'}).then(()=>window.history.back());</script>");
            out.println("</body></html>");
            return;
        }

        out.println("<!DOCTYPE html><html><head><title>Import Status</title><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
        out.println("<style>body{font-family:Arial;background:#f5f5f5;}</style>");
        out.println("</head><body>");
        out.println("<script>");
        out.println("Swal.fire({");
        out.println("  title: 'Import Completed',");
        out.println("  html: '<b>Success:</b> " + successCount + " records<br><b>Duplicate:</b> " + duplicateCount + " records" + 
                (duplicateCount > 0 ? "<br><small>Duplicate CRNs: " + duplicateDetails.toString().replaceAll(", $", "") + "</small>" : "") + 
                (failureCount > 0 ? "<br><b>Failed:</b> " + failureCount + " records" : "") + "',");
        out.println("  icon: '" + (failureCount == 0 && duplicateCount == 0 ? "success" : "warning") + "',");
        out.println("  confirmButtonText: 'OK',");
        out.println("  confirmButtonColor: '#4e73df'");
        out.println("}).then(()=>window.location.href='Report.jsp');");
        out.println("</script>");
        out.println("</body></html>");
    }

    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING: return cell.getStringCellValue().trim();
            case NUMERIC: return String.valueOf((long) cell.getNumericCellValue());
            case BOOLEAN: return String.valueOf(cell.getBooleanCellValue());
            case FORMULA: return cell.getCellFormula();
            default: return "";
        }
    }
}