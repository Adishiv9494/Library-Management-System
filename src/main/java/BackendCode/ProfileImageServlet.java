package BackendCode;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.util.Base64;

@WebServlet("/ProfileImageServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 10,     // 10 MB
    maxRequestSize = 1024 * 1024 * 100  // 100 MB
)
public class ProfileImageServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("username") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"status\":\"error\", \"message\":\"Session expired. Please login again.\", \"redirect\":true}");
                return;
            }

            String username = (String) session.getAttribute("username");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            Part filePart = request.getPart("profilePhoto");

            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\", \"message\":\"Full name is required\"}");
                return;
            }

            // Split full name into first and last names
            String[] names = fullName.trim().split("\\s+");
            String firstName = names[0];
            String lastName = names.length > 1 ? names[names.length - 1] : "";

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC", "avnadmin", "AVNS_M_y84BDpUY38oAAS0w1")) {
                
                String query;
                PreparedStatement pstmt;
                boolean imageUpdated = false;
                
                if (filePart != null && filePart.getSize() > 0) {
                    // Validate image file
                    String contentType = filePart.getContentType();
                    if (!contentType.startsWith("image/")) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print("{\"status\":\"error\", \"message\":\"Only image files are allowed\"}");
                        return;
                    }

                    query = "UPDATE lib_loginsignup SET first_name=?, last_name=?, contact_number=?, address=?, profile_image=? WHERE email=?";
                    pstmt = conn.prepareStatement(query);
                    
                    pstmt.setString(1, firstName);
                    pstmt.setString(2, lastName);
                    pstmt.setString(3, phone);
                    pstmt.setString(4, address);
                    
                    try (InputStream fileContent = filePart.getInputStream()) {
                        pstmt.setBinaryStream(5, fileContent, (int) filePart.getSize());
                        pstmt.setString(6, username);
                        
                        int rowsAffected = pstmt.executeUpdate();
                        
                        if (rowsAffected > 0) {
                            // Convert image to Base64 for session storage
                            byte[] imageBytes = filePart.getInputStream().readAllBytes();
                            String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                            
                            // Update session attributes
                            session.setAttribute("first_name", firstName);
                            session.setAttribute("last_name", lastName);
                            session.setAttribute("contact_number", phone);
                            session.setAttribute("address", address);
                            session.setAttribute("profile_image", base64Image);
                            
                            imageUpdated = true;
                            out.print("{\"status\":\"success\", \"message\":\"Profile updated successfully with image\", \"imageUpdated\":true}");
                        } else {
                            response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
                            out.print("{\"status\":\"error\", \"message\":\"No records updated\"}");
                        }
                    }
                } else {
                    // Update without image
                    query = "UPDATE lib_loginsignup SET first_name=?, last_name=?, contact_number=?, address=? WHERE email=?";
                    pstmt = conn.prepareStatement(query);
                    
                    pstmt.setString(1, firstName);
                    pstmt.setString(2, lastName);
                    pstmt.setString(3, phone);
                    pstmt.setString(4, address);
                    pstmt.setString(5, username);
                    
                    int rowsAffected = pstmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        // Update session attributes
                        session.setAttribute("first_name", firstName);
                        session.setAttribute("last_name", lastName);
                        session.setAttribute("contact_number", phone);
                        session.setAttribute("address", address);
                        
                        out.print("{\"status\":\"success\", \"message\":\"Profile updated successfully\", \"imageUpdated\":false}");
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
                        out.print("{\"status\":\"error\", \"message\":\"No records updated\"}");
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Database driver not found\"}");
            e.printStackTrace();
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Database error: " + e.getMessage().replace("\"", "'") + "\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"An unexpected error occurred: " + e.getMessage().replace("\"", "'") + "\"}");
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}