package BackendCode;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASSWORD = "HIDDEN_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        
        String newPassword = request.getParameter("newPassword");
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.getWriter().write("error");
            return;
        }
        
        // Grab email from any of the possible session variables
        String email = (String) session.getAttribute("reset_email");
        if (email == null) email = (String) session.getAttribute("resetEmail");
        if (email == null) email = (String) session.getAttribute("temp_email");

        if (email != null && newPassword != null && !newPassword.trim().isEmpty()) {
            try {
                System.out.println("\n--- INITIATING PASSWORD RESET FOR: " + email + " ---");
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                
                boolean updatedAdmin = false;
                boolean updatedStudent = false;

                // 1. Check and Update Admin Table (lib_loginsignup)
                PreparedStatement psAdminCheck = con.prepareStatement("SELECT email FROM lib_loginsignup WHERE email = ?");
                psAdminCheck.setString(1, email);
                ResultSet rsAdmin = psAdminCheck.executeQuery();
                
                if (rsAdmin.next()) {
                    String adminHashedPassword = hashAdminPassword(newPassword.trim());
                    PreparedStatement psAdminUpdate = con.prepareStatement("UPDATE lib_loginsignup SET password_hash = ? WHERE email = ?");
                    psAdminUpdate.setString(1, adminHashedPassword);
                    psAdminUpdate.setString(2, email);
                    psAdminUpdate.executeUpdate();
                    psAdminUpdate.close();
                    updatedAdmin = true;
                    System.out.println("-> Successfully updated Admin password.");
                }
                rsAdmin.close();
                psAdminCheck.close();

                // 2. Check and Update Student Table (student_signup)
                PreparedStatement psStudentCheck = con.prepareStatement("SELECT email FROM student_signup WHERE email = ?");
                psStudentCheck.setString(1, email);
                ResultSet rsStudent = psStudentCheck.executeQuery();
                
                if (rsStudent.next()) {
                    String studentHashedPassword = hashStudentPassword(newPassword.trim());
                    PreparedStatement psStudentUpdate = con.prepareStatement("UPDATE student_signup SET password_hash = ? WHERE email = ?");
                    psStudentUpdate.setString(1, studentHashedPassword);
                    psStudentUpdate.setString(2, email);
                    psStudentUpdate.executeUpdate();
                    psStudentUpdate.close();
                    updatedStudent = true;
                    System.out.println("-> Successfully updated Student password.");
                }
                rsStudent.close();
                psStudentCheck.close();
                
                con.close();
                
                if (updatedAdmin || updatedStudent) {
                    session.removeAttribute("otp");
                    session.removeAttribute("reset_email");
                    session.removeAttribute("resetEmail");
                    session.removeAttribute("temp_email");
                    session.removeAttribute("resetTable");
                    response.getWriter().write("success");
                } else {
                    System.out.println("-> ERROR: Email not found in any database table.");
                    response.getWriter().write("error");
                }
                
            } catch (Exception e) {
                System.out.println("!!! PASSWORD RESET DATABASE ERROR !!!");
                e.printStackTrace();
                response.getWriter().write("error");
            }
        } else {
            System.out.println("ERROR: Missing session email data or new password parameter.");
            response.getWriter().write("error");
        }
    }
    
    // Generates a proper Base64 Salted Hash matching LibloginSignup.java exactly
    private String hashAdminPassword(String password) throws NoSuchAlgorithmException {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt);
        byte[] hashedPassword = md.digest(password.getBytes(StandardCharsets.UTF_8));
        
        byte[] combined = new byte[salt.length + hashedPassword.length];
        System.arraycopy(salt, 0, combined, 0, salt.length);
        System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
        
        return Base64.getEncoder().encodeToString(combined);
    }

    // Generates a Hex-encoded Hash matching StudentLoginServlet.java exactly
    private String hashStudentPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) {
            hex.append(String.format("%02x", b));
        }
        return hex.toString();
    }
}