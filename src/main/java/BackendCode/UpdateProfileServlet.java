package BackendCode;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect("welcome.jsp");
                return;
            }
            
            String email = (String) session.getAttribute("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            Part filePart = request.getPart("profilePhoto");
            
            // Update database
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/libraryjdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC", "avnadmin", "HIDDEN_PASSWORD");
            String query = "UPDATE lib_loginsignup SET first_name = ?, last_name = ?, contact_number = ?, address = ? WHERE email = ?";
            
            // Split full name into first and last names
            String[] nameParts = fullName.split(" ");
            String firstName = nameParts[0];
            String lastName = nameParts.length > 1 ? nameParts[nameParts.length-1] : "";
            
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, phone);
            pstmt.setString(4, address);
            pstmt.setString(5, email);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Update session attributes
                session.setAttribute("first_name", firstName);
                session.setAttribute("last_name", lastName);
                session.setAttribute("contact_number", phone);
                
                // Handle file upload if present
                if (filePart != null && filePart.getSize() > 0) {
                    // Save the file to server or database here
                    // This is just a placeholder - implement your actual file handling logic
                    InputStream fileContent = filePart.getInputStream();
                    // ... save the file ...
                }
                
                response.getWriter().write("{\"status\":\"success\",\"message\":\"Profile updated successfully\"}");
            } else {
                response.getWriter().write("{\"status\":\"error\",\"message\":\"No changes were made\"}");
            }
            
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Database error: " + e.getMessage() + "\"}");
        }
    }
}