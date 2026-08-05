package BackendCode;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String newPassword = request.getParameter("newPassword");
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        String tableName = (String) session.getAttribute("resetTable"); // Identifies if it's a student or admin

        if (email != null && newPassword != null && tableName != null) {
            try {
                System.out.println("\n--- INITIATING PASSWORD RESET ---");
                System.out.println("Updating password for email: " + email + " in table: " + tableName);
                
                String finalHashedPassword;
                
                // Determine which hashing algorithm to use based on the table
                if ("student_signup".equals(tableName)) {
                    // Students use Hex-encoded SHA-256
                    finalHashedPassword = hashStudentPassword(newPassword);
                } else {
                    // Admins use Base64-encoded Salted SHA-256
                    finalHashedPassword = hashAdminPassword(newPassword);
                }
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC", "avnadmin", "HIDDEN_PASSWORD");
                
                String query = "UPDATE " + tableName + " SET password_hash = ? WHERE email = ?";
                PreparedStatement ps = con.prepareStatement(query);
                ps.setString(1, finalHashedPassword);
                ps.setString(2, email);
                
                int rowsAffected = ps.executeUpdate();
                ps.close();
                con.close();
                
                if (rowsAffected > 0) {
                    System.out.println("-> Success! Password reset successfully.");
                    session.removeAttribute("otp");
                    session.removeAttribute("resetEmail");
                    session.removeAttribute("resetTable");
                    response.getWriter().write("success");
                } else {
                    System.out.println("-> ERROR: Email not found during update.");
                    response.getWriter().write("error");
                }
                
            } catch (Exception e) {
                System.out.println("!!! PASSWORD RESET DATABASE ERROR !!!");
                e.printStackTrace();
                response.getWriter().write("error");
            }
        } else {
            System.out.println("ERROR: Missing session email data, table name, or new password parameter.");
            response.getWriter().write("error");
        }
    }
    
    // Admin hash logic (from LibloginSignup.java)
    private String hashAdminPassword(String password) throws NoSuchAlgorithmException {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt);
        byte[] hashedPassword = md.digest(password.getBytes());
        
        byte[] combined = new byte[salt.length + hashedPassword.length];
        System.arraycopy(salt, 0, combined, 0, salt.length);
        System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
        
        return Base64.getEncoder().encodeToString(combined);
    }

    // Student hash logic (from StudentLoginServlet.java)
    private String hashStudentPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) {
            hex.append(String.format("%02x", b));
        }
        return hex.toString();
    }
}