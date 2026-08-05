package BackendCode;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.*;

@WebServlet("/BooksImportData")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class BooksImportData extends HttpServlet {

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
                String sql = "INSERT INTO booksData (accession_number, book_name, author, publisher, edition, price) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);

                for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                    Row row = sheet.getRow(i);
                    if (row != null) {
                        int accessionNumber = (int) row.getCell(0).getNumericCellValue();
                        String bookName = getCellValue(row.getCell(1));
                        String author = getCellValue(row.getCell(2));
                        String publisher = getCellValue(row.getCell(3));
                        String edition = getCellValue(row.getCell(4));
                        double price = row.getCell(5).getNumericCellValue();

                        pstmt.setInt(1, accessionNumber);
                        pstmt.setString(2, bookName);
                        pstmt.setString(3, author);
                        pstmt.setString(4, publisher);
                        pstmt.setString(5, edition);
                        pstmt.setDouble(6, price);

                        try {
                            pstmt.executeUpdate();
                            successCount++;
                        } catch (SQLException e) {
                            if (e.getErrorCode() == 1062 || e.getSQLState().equals("23000")) {
                                duplicateCount++;
                                duplicateDetails.append(accessionNumber).append(", ");
                            } else {
                                failureCount++;
                            }
                            System.err.println("Insert failed for Accession " + accessionNumber + ": " + e.getMessage());
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

        out.println("<!DOCTYPE html><html><head><title>Book Import Status</title><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
        out.println("<style>body{font-family:'Segoe UI',sans-serif;background:#f5f7fa;}.swal2-popup{border-radius:15px;}.swal2-title{color:#27ae60;}</style>");
        out.println("</head><body>");
        out.println("<script>");
        out.println("Swal.fire({");
        out.println("  title: 'Book Import Completed',");
        out.println("  html: '<div style=\"font-size:1.2rem;\">" + successCount + " books imported successfully!</div>" + 
                (duplicateCount > 0 ? "<div style=\"color:#f39c12;\">Duplicate Accessions: " + duplicateCount + "</div>" : "") + 
                (failureCount > 0 ? "<div style=\"color:#e74c3c;\">Failed: " + failureCount + "</div>" : "") + 
                (duplicateCount > 0 ? "<br><small>Duplicate Accessions: " + duplicateDetails.toString().replaceAll(", $", "") + "</small>" : "") + "',");
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