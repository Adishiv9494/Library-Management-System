// ==========================================
// 4. StudentSignupServlet.java
// ==========================================
package StudentBackendCode;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/StudentSignupServlet")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10,
    fileSizeThreshold = 1024 * 1024
)
public class StudentSignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(StudentSignupServlet.class.getName());

    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASS = "AVNS_M_y84BDpUY38oAAS0w1";

    private static final List<String> DISABLE_DEPT_COURSES = Arrays.asList("BCA", "BBA", "MBA", "MCA");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("StudentSignup.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String contact = request.getParameter("contactNumber");
            String crn = request.getParameter("crn");
            String course = request.getParameter("course");
            String department = request.getParameter("department");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String captchaInput = request.getParameter("captchaInput");
            String captchaHidden = request.getParameter("captchaHidden");

            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                contact == null || contact.trim().isEmpty() ||
                crn == null || crn.trim().isEmpty() ||
                course == null || course.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty() ||
                captchaInput == null || captchaInput.trim().isEmpty() ||
                captchaHidden == null || captchaHidden.trim().isEmpty()) {
                sendError(response, "All fields are required.");
                return;
            }

            if (!captchaInput.equals(captchaHidden)) {
                sendError(response, "Invalid CAPTCHA. Please try again.");
                return;
            }

            if (!password.equals(confirmPassword)) {
                sendError(response, "Passwords do not match.");
                return;
            }

            boolean departmentRequired = !DISABLE_DEPT_COURSES.contains(course);
            if (departmentRequired && (department == null || department.trim().isEmpty())) {
                sendError(response, "Department is required for this course.");
                return;
            }
            if (!departmentRequired || department == null || department.trim().isEmpty()) {
                department = "NA";
            }
            department = department.trim();

            String hashedPassword = hashPassword(password);
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

                String checkEmail = "SELECT email FROM student_signup WHERE email = ?";
                pstmt = conn.prepareStatement(checkEmail);
                pstmt.setString(1, email);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    sendError(response, "Email already registered. Please login.");
                    return;
                }
                rs.close();
                pstmt.close();

                String tableName = course.toLowerCase() + "_students";
                String validateQuery = "SELECT * FROM " + tableName + " WHERE crn = ? AND name = ? AND contact = ?";
                pstmt = conn.prepareStatement(validateQuery);
                pstmt.setString(1, crn);
                pstmt.setString(2, fullName);
                pstmt.setString(3, contact);
                rs = pstmt.executeQuery();

                if (!rs.next()) {
                    sendError(response, "Student details do not match our records. Please check CRN, Name, and Contact.");
                    return;
                }
                rs.close();
                pstmt.close();

                String insertQuery = "INSERT INTO student_signup (full_name, email, contact_number, crn, course, department, password_hash) VALUES (?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertQuery);
                pstmt.setString(1, fullName);
                pstmt.setString(2, email);
                pstmt.setString(3, contact);
                pstmt.setString(4, crn);
                pstmt.setString(5, course);
                pstmt.setString(6, department);
                pstmt.setString(7, hashedPassword);

                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    request.getSession().setAttribute("full_name", fullName);
                    request.getSession().setAttribute("email", email);
                    request.getSession().setAttribute("contact", contact);
                    request.getSession().setAttribute("crn", crn);
                    request.getSession().setAttribute("course", course);
                    request.getSession().setAttribute("department", department);

                    response.sendRedirect("studentsignupdone.jsp");
                } else {
                    sendError(response, "Signup failed. Please try again.");
                }

            } catch (ClassNotFoundException e) {
                LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found", e);
                sendError(response, "Database driver error. Please contact support.");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "SQL Error during signup", e);
                if (e.getMessage().contains("Duplicate entry") && e.getMessage().contains("email")) {
                    sendError(response, "Email already registered. Please login.");
                } else if (e.getMessage().contains("Duplicate entry") && e.getMessage().contains("crn")) {
                    sendError(response, "CRN already registered. Please contact support.");
                } else {
                    sendError(response, "Database error: " + e.getMessage());
                }
            } finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) {}
                try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
                try { if (conn != null) conn.close(); } catch (SQLException e) {}
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error", e);
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
            byte[] hash = md.digest(password.getBytes());
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