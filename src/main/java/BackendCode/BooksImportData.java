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
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String dbURL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&serverTimezone=UTC";
        String dbUser = "avnadmin";
        String dbPassword = "HIDDEN_PASSWORD";

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
                // Fixed table reference to lowercase booksdata
                String sql = "INSERT INTO booksdata (accession_number, book_name, author, publisher, edition, price) VALUES (?, ?, ?, ?, ?, ?)";
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

        out.println("<!DOCTYPE html><html><head><title>Book Import Status</title><script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>");
        out.println("<script>Swal.fire({title: 'Import Completed', html: '" + successCount + " books imported successfully!', icon: 'success'}).then(()=>window.location.href='Report.jsp');</script>");
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