package StudentBackendCode;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/StudentLoginServlet")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10,
    fileSizeThreshold = 1024 * 1024
)
public class StudentLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(StudentLoginServlet.class.getName());

    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    // Restored the working password so the live server can successfully connect
    private static final String DB_PASS = "AVNS_M_y84BDpUY38oAAS0w1";

    private String getParameterRobust(HttpServletRequest request, String paramName) throws IOException, ServletException {
        String value = request.getParameter(paramName);
        if (value == null && request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/")) {
            Part part = request.getPart(paramName);
            if (part != null) {
                try (InputStream is = part.getInputStream()) {
                    byte[] bytes = is.readAllBytes();
                    value = new String(bytes, StandardCharsets.UTF_8);
                }
            }
        }
        return value != null ? value.trim() : null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String loginIdentifier = getParameterRobust(request, "loginIdentifier");
            String password = getParameterRobust(request, "password");
            String captchaInput = getParameterRobust(request, "captchaInput");
            String captchaHidden = getParameterRobust(request, "captchaHidden");
            
            if (loginIdentifier == null || loginIdentifier.isEmpty()) {
                loginIdentifier = getParameterRobust(request, "email");
            }

            if (loginIdentifier == null || loginIdentifier.isEmpty() || 
                password == null || password.isEmpty() || 
                captchaInput == null || captchaInput.isEmpty() || 
                captchaHidden == null || captchaHidden.isEmpty()) {
                sendError(response, "All fields are required.");
                return;
            }

            if (!captchaInput.equals(captchaHidden)) {
                sendError(response, "Invalid CAPTCHA.");
                return;
            }

            String hashedPassword = hashPassword(password);
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

                String query = "SELECT * FROM student_signup WHERE email = ? OR crn = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, loginIdentifier);
                pstmt.setString(2, loginIdentifier);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String storedPassword = rs.getString("password_hash");
                    if (storedPassword.equals(hashedPassword)) {
                        request.getSession().setAttribute("full_name", rs.getString("full_name"));
                        request.getSession().setAttribute("email", rs.getString("email"));
                        request.getSession().setAttribute("contact", rs.getString("contact_number"));
                        request.getSession().setAttribute("crn", rs.getString("crn"));
                        request.getSession().setAttribute("course", rs.getString("course"));
                        request.getSession().setAttribute("department", rs.getString("department"));
                        
                        // Safely retrieve and set profile image for the dashboard
                        try {
                            String profileImg = rs.getString("profile_image");
                            if (profileImg != null) {
                                request.getSession().setAttribute("profile_image", profileImg);
                            }
                        } catch (SQLException ignored) {}

                        response.getWriter().write("{\"status\":\"success\", \"message\":\"Login successful!\", \"redirect\":\"StudentDashboard.jsp\"}");
                        return;
                    } else {
                        sendError(response, "Invalid password.");
                    }
                } else {
                    sendError(response, "User not found.");
                }

            } catch (ClassNotFoundException | SQLException e) {
                LOGGER.log(Level.SEVERE, "Database error during login", e);
                sendError(response, "Database error: " + e.getMessage());
            } finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) {}
                try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
                try { if (conn != null) conn.close(); } catch (SQLException e) {}
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected login error", e);
            sendError(response, "An unexpected error occurred: " + e.getMessage());
        }
    }

    private void sendError(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"status\":\"error\", \"message\":\"" + message + "\"}");
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            // Enforce UTF-8 encoding to prevent hash mismatch errors
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
}
