package BackendCode;

import java.io.*;
import java.math.BigDecimal;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.xssf.usermodel.*;

@WebServlet("/BtechStudentsData")
public class BtechStudentsData extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Path to Excel file
    	String filePath = "C:/Users/adity/OneDrive/Desktop/StudentData/BTechStudentData.xlsx";
        System.out.println("File Path: " + filePath);

        // Database credentials
        String dbURL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
        String dbUser = "avnadmin";
        String dbPassword = "HIDDEN_PASSWORD";

        // Counters for success and failures
        int successCount = 0;
        int failureCount = 0;
        StringBuilder errorDetails = new StringBuilder();
        
        // Connect to database
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
            System.out.println("Database connected successfully.");

            String insertSQL = "INSERT INTO BTech_students (crn, name, course, contact) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(insertSQL);

            try (FileInputStream fis = new FileInputStream(filePath);
                 XSSFWorkbook workbook = new XSSFWorkbook(fis)) {

                XSSFSheet sheet = workbook.getSheetAt(0);
                System.out.println("Excel file loaded successfully.");

                for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                    XSSFRow row = sheet.getRow(i);
                    if (row != null) {
                        String crn = row.getCell(0).toString().trim();
                        String name = row.getCell(1).toString().trim();
                        String course = row.getCell(2).toString().trim();

                        // Handle contact number (avoid scientific notation)
                        String contact;
                        if (row.getCell(3).getCellType() == CellType.NUMERIC) {
                            contact = BigDecimal.valueOf(row.getCell(3).getNumericCellValue()).toPlainString();
                        } else {
                            contact = row.getCell(3).toString().trim();
                        }

                        pstmt.setString(1, crn);
                        pstmt.setString(2, name);
                        pstmt.setString(3, course);
                        pstmt.setString(4, contact);

                        try {
                            pstmt.executeUpdate();
                            successCount++;
                            System.out.println("Inserted: " + crn + ", " + name + ", " + course + ", " + contact);
                        } catch (SQLException e) {
                            failureCount++;
                            errorDetails.append("Failed CRN: ").append(crn).append(" - ").append(e.getMessage()).append("\\n");
                            System.out.println("Error inserting data for CRN " + crn + ": " + e.getMessage());
                        }
                    }
                }
            }

            // Prepare success response with SweetAlert popup
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Import Status</title>");
            out.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; background-color: #f5f5f5; }");
            out.println(".swal2-popup { font-size: 1.1rem !important; }");
            out.println("</style>");
            out.println("</head><body>");
            out.println("<script>");
            out.println("Swal.fire({");
            out.println("  title: 'Import Completed',");
            out.println("  html: '<b>Success:</b> " + successCount + " records<br><b>Failed:</b> " + failureCount + " records" + 
                   (failureCount > 0 ? "<br><br><small>Check console for details</small>" : "") + "',");
            out.println("  icon: '" + (failureCount == 0 ? "success" : "warning") + "',");
            out.println("  confirmButtonText: 'OK',");
            out.println("  confirmButtonColor: '#3085d6',");
            out.println("  width: '500px',");
            out.println("  customClass: { popup: 'animated bounceIn' }");
            out.println("}).then((result) => {");
            out.println("  window.location.href = 'Report.jsp';"); // Redirect after click
            out.println("});");
            out.println("</script>");
            out.println("</body></html>");

        } catch (Exception e) {
            // Prepare error response with SweetAlert popup
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Error</title>");
            out.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
            out.println("</head><body>");
            out.println("<script>");
            out.println("Swal.fire({");
            out.println("  title: 'Import Failed',");
            out.println("  text: '" + e.getMessage().replace("'", "\\'") + "',");
            out.println("  icon: 'error',");
            out.println("  confirmButtonText: 'OK',");
            out.println("  confirmButtonColor: '#d33',");
            out.println("  width: '500px'");
            out.println("}).then((result) => {");
            out.println("  window.history.back();"); // Go back after click
            out.println("});");
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}