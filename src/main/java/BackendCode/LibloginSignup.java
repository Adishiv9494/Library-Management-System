package BackendCode;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.Date;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet("/LibloginSignup")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 10,     // 10 MB
    maxRequestSize = 1024 * 1024 * 50   // 50 MB
)
public class LibloginSignup extends HttpServlet {
    
    // Database configuration
	private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
	private static final String DB_USER = "avnadmin";
	private static final String DB_PASSWORD = "HIDDEN_PASSWORD";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            System.out.println("[" + new Date() + "] Request received. Content-Type: " + request.getContentType());
            
            String action = getParameter(request, "action");
            System.out.println("Action: " + action);
            
            if ("login".equals(action)) {
                handleLogin(request, response, out);
            } else if ("register".equals(action)) {
                handleRegistration(request, response, out);
            } else {
                sendErrorResponse(out, "Invalid action");
            }
            
        } catch (Exception e) {
            logError("Servlet processing error", e);
            sendErrorResponse(out, "System error: " + e.getClass().getSimpleName());
        } finally {
            out.close();
        }
    }
    
    private String getParameter(HttpServletRequest request, String paramName) 
            throws IOException, ServletException {
        String value = request.getParameter(paramName);
        
        // Safely extract multipart form data if standard getParameter returns null
        if (value == null && request.getContentType() != null 
            && request.getContentType().toLowerCase().startsWith("multipart/")) {
            Part part = request.getPart(paramName);
            if (part != null) {
                try (InputStream is = part.getInputStream()) {
                    // Use readAllBytes() instead of available() for reliable reading
                    byte[] bytes = is.readAllBytes();
                    // Enforce UTF-8 encoding
                    value = new String(bytes, StandardCharsets.UTF_8);
                }
            }
        }
        
        // CRITICAL FIX: Trim whitespace and invisible newline characters (\r\n)
        System.out.println("Parameter '" + paramName + "' value: " + (value != null ? value.trim() : "null"));
        return value != null ? value.trim() : null;
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws SQLException, IOException, ServletException {
        try {
            String email = getParameter(request, "email");
            String password = getParameter(request, "password");
            String captchaInput = getParameter(request, "captchaInput");
            String captchaText = getParameter(request, "captchaText");
            
            // Validate required fields
            if (email == null || email.isEmpty()) {
                sendErrorResponse(out, "Email is required");
                return;
            }
            
            if (password == null || password.isEmpty()) {
                sendErrorResponse(out, "Password is required");
                return;
            }
            
            // Validate CAPTCHA
            if (captchaInput == null || !captchaInput.equalsIgnoreCase(captchaText)) {
                sendErrorResponse(out, "Invalid CAPTCHA");
                return;
            }

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                System.out.println("Database connection established for login");
                
                String sql = "SELECT user_id, first_name, last_name, email, password_hash FROM lib_loginsignup WHERE email = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, email);
                    
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            String storedHash = rs.getString("password_hash");
                            System.out.println("User found. Verifying password...");
                            
                            if (verifyPassword(password, storedHash)) {
                                System.out.println("Password verification successful");
                                
                                // Create session
                                HttpSession session = request.getSession();
                                session.setAttribute("user_id", rs.getInt("user_id"));
                                session.setAttribute("email", rs.getString("email"));
                                session.setAttribute("first_name", rs.getString("first_name"));
                                session.setAttribute("last_name", rs.getString("last_name"));
                                
                                System.out.println("Session created for user ID: " + rs.getInt("user_id"));
                                sendSuccessResponse(out, "Login successful", "Dashboard.jsp");
                            } else {
                                System.out.println("Password verification failed");
                                sendErrorResponse(out, "Invalid email or password");
                            }
                        } else {
                            System.out.println("No user found with email: " + email);
                            sendErrorResponse(out, "Account not found");
                        }
                    }
                }
            } catch (SQLException e) {
                logError("Database error during login", e);
                sendErrorResponse(out, "Database error. Please try again later.");
            }
        } catch (Exception e) {
            logError("Unexpected error during login", e);
            sendErrorResponse(out, "Login processing failed. Please try again.");
        }
    }
    
    private void handleRegistration(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws SQLException, IOException, ServletException, NoSuchAlgorithmException {
        try {
            String firstName = getParameter(request, "firstName");
            String lastName = getParameter(request, "lastName");
            String email = getParameter(request, "email");
            String contactNumber = getParameter(request, "contactNumber");
            String password = getParameter(request, "password");
            String confirmPassword = getParameter(request, "confirmPassword");
            String captchaInput = getParameter(request, "captchaInput");
            String captchaText = getParameter(request, "captchaText");
            String terms = getParameter(request, "terms");
            
            // Validate CAPTCHA
            if (captchaInput == null || !captchaInput.equalsIgnoreCase(captchaText)) {
                sendErrorResponse(out, "Invalid CAPTCHA");
                return;
            }
            
            // Validate required fields
            if (firstName == null || firstName.isEmpty() ||
                lastName == null || lastName.isEmpty() ||
                email == null || email.isEmpty() ||
                password == null || password.isEmpty() ||
                confirmPassword == null || confirmPassword.isEmpty()) {
                
                sendErrorResponse(out, "All required fields must be filled");
                return;
            }
            
            // Check if terms are accepted
            if (terms == null || !terms.equals("on")) {
                sendErrorResponse(out, "You must agree to the Terms & Conditions");
                return;
            }
            
            // Check password match
            if (!password.equals(confirmPassword)) {
                sendErrorResponse(out, "Passwords do not match");
                return;
            }
            
            // Check if email exists
            if (isEmailExists(email)) {
                sendErrorResponse(out, "Email already registered");
                return;
            }
            
            // FIX: Check if contact number already exists to prevent SQL Integrity Crash
            if (isContactNumberExists(contactNumber)) {
                sendErrorResponse(out, "Phone number is already registered");
                return;
            }
            
            // Generate verification token
            String verificationToken = UUID.randomUUID().toString();
            Date now = new Date();
            
            // Hash password
            String hashedPassword = hashPassword(password);
            
            // Save user to database
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO lib_loginsignup (first_name, last_name, email, contact_number, password_hash, " +
                     "account_status, created_at, updated_at, email_verified, verification_token) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                
                stmt.setString(1, firstName);
                stmt.setString(2, lastName);
                stmt.setString(3, email);
                stmt.setString(4, contactNumber);
                stmt.setString(5, hashedPassword);
                stmt.setString(6, "active");
                stmt.setTimestamp(7, new java.sql.Timestamp(now.getTime()));
                stmt.setTimestamp(8, new java.sql.Timestamp(now.getTime()));
                stmt.setBoolean(9, false);
                stmt.setString(10, verificationToken);
                
                int affectedRows = stmt.executeUpdate();
                
                if (affectedRows > 0) {
                    sendSuccessResponse(out, "Registration successful", "Signupdone.jsp");
                } else {
                    sendErrorResponse(out, "Registration failed");
                }
            }
        } catch (SQLException e) {
            logError("Database error during registration", e);
            sendErrorResponse(out, "Database error. Please try again.");
        } catch (NoSuchAlgorithmException e) {
            logError("Password hashing error", e);
            sendErrorResponse(out, "System error. Please try again.");
        } catch (Exception e) {
            logError("Unexpected registration error", e);
            sendErrorResponse(out, "Registration failed. Please try again.");
        }
    }
    
    private boolean isEmailExists(String email) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT 1 FROM lib_loginsignup WHERE email = ?")) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    // Checks if the phone number is already taken
    private boolean isContactNumberExists(String contactNumber) throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT 1 FROM lib_loginsignup WHERE contact_number = ?")) {
            
            stmt.setString(1, contactNumber);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt);
        // Explicitly encode to UTF-8
        byte[] hashedPassword = md.digest(password.getBytes(StandardCharsets.UTF_8));
        
        byte[] combined = new byte[salt.length + hashedPassword.length];
        System.arraycopy(salt, 0, combined, 0, salt.length);
        System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
        
        return Base64.getEncoder().encodeToString(combined);
    }
    
    private boolean verifyPassword(String password, String storedHash) {
        if (storedHash == null || storedHash.isEmpty()) {
            System.out.println("Password verification failed: No stored hash");
            return false;
        }
        
        try {
            byte[] combined = Base64.getDecoder().decode(storedHash);
            byte[] salt = new byte[16];
            
            if (combined.length <= salt.length) {
                return false;
            }
            
            System.arraycopy(combined, 0, salt, 0, salt.length);
            
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            // Explicitly encode to UTF-8
            byte[] hashedPassword = md.digest(password.getBytes(StandardCharsets.UTF_8));
            
            for (int i = 0; i < hashedPassword.length; i++) {
                if (hashedPassword[i] != combined[salt.length + i]) {
                    System.out.println("Password mismatch at byte " + i);
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            System.out.println("Password verification failed: Stored hash format invalid.");
            return false;
        }
    }
    
    private void sendSuccessResponse(PrintWriter out, String message, String redirect) {
        String jsonResponse = String.format(
            "{\"status\":\"success\",\"message\":\"%s\",\"redirect\":\"%s\"}",
            message, redirect
        );
        System.out.println("Sending success response: " + jsonResponse);
        out.print(jsonResponse);
    }
    
    private void sendErrorResponse(PrintWriter out, String message) {
        String jsonResponse = String.format(
            "{\"status\":\"error\",\"message\":\"%s\"}",
            message
        );
        System.out.println("Sending error response: " + jsonResponse);
        out.print(jsonResponse);
    }
    
    private void logError(String message, Exception e) {
        System.err.println("[" + new Date() + "] ERROR: " + message);
        e.printStackTrace(System.err);
    }
    
    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL JDBC Driver not found", e);
        }
    }
}