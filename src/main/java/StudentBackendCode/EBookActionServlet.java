package StudentBackendCode;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/EBookActionServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB memory threshold
    maxFileSize = 1024 * 1024 * 50,       // 50MB max file size
    maxRequestSize = 1024 * 1024 * 55     // 55MB total request size
)
public class EBookActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Setup Directory for PDF uploads inside the webapp
    private static final String UPLOAD_DIR = "ebook_uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if("count".equals(action)) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC", "avnadmin", "HIDDEN_PASSWORD");
                PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM ebooks");
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    response.getWriter().write(String.valueOf(rs.getInt(1)));
                }
                rs.close(); pstmt.close(); conn.close();
            } catch (Exception e) {
                // If table doesn't exist yet, return 0
                response.getWriter().write("0");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC\", \"avnadmin\", \"HIDDEN_PASSWORD");

            if ("upload".equals(action)) {
                
                // --- SECONDARY TABLE CREATION CHECK ---
                // Prevents the "Table library.ebooks doesn't exist" error during backend upload.
                String createTableSQL = "CREATE TABLE IF NOT EXISTS ebooks (" +
                                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                        "title VARCHAR(255) NOT NULL, " +
                                        "author VARCHAR(255) NOT NULL, " +
                                        "edition VARCHAR(100), " +
                                        "description TEXT, " +
                                        "pdf_url VARCHAR(500) NOT NULL, " +
                                        "uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                                        ")";
                try (Statement stmt = conn.createStatement()) {
                    stmt.execute(createTableSQL);
                }

                // Process Form Fields
                String title = request.getParameter("title");
                String author = request.getParameter("author");
                String edition = request.getParameter("edition");
                String description = request.getParameter("description");
                
                // Process File Upload
                Part filePart = request.getPart("pdfFile");
                String fileName = filePart.getSubmittedFileName();
                
                // Construct safe upload path
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
                
                File fileSaveDir = new File(uploadFilePath);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs();
                }
                
                // Save physical file
                String savePath = uploadFilePath + File.separator + fileName;
                filePart.write(savePath);
                
                // Relative URL path to be saved in database
                String pdfUrl = UPLOAD_DIR + "/" + fileName;
                
                // Insert into Database
                String query = "INSERT INTO ebooks (title, author, edition, description, pdf_url) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, title);
                pstmt.setString(2, author);
                pstmt.setString(3, edition);
                pstmt.setString(4, description);
                pstmt.setString(5, pdfUrl);
                pstmt.executeUpdate();
                pstmt.close();
                
                response.getWriter().write("{\"status\":\"success\"}");
                
            } else if ("delete".equals(action)) {
                String id = request.getParameter("id");
                
                // Note: To be perfectly clean, you could also delete the physical file here
                // using a SELECT query to get the pdf_url, then java.io.File.delete()
                
                String query = "DELETE FROM ebooks WHERE id = ?";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, id);
                pstmt.executeUpdate();
                pstmt.close();
                
                response.getWriter().write("{\"status\":\"success\"}");
            }
            conn.close();
        } catch (Exception e) {
            // Print actual error to ajax response for debugging
            response.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}