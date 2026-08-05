package BackendCode;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;
import java.util.Random;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SendOtpServlet")
public class SendOtpServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        System.out.println("\n--- OTP PROCESS STARTED ---");
        System.out.println("1. Requested Email: " + email);
        
        if (email == null || email.trim().isEmpty()) {
            System.out.println("ERROR: Email is null or empty.");
            response.getWriter().write("error");
            return;
        }

        // --- 1. VERIFY EMAIL EXISTS IN DATABASE ---
        boolean isRegistered = false;
        String tableName = ""; // We will store which table the user belongs to

        try {
            System.out.println("2. Loading MySQL Driver...");
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            System.out.println("3. Connecting to database 'library'...");
            Connection con = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC", "avnadmin", "HIDDEN_PASSWORD");
            
            System.out.println("4. Checking student_signup table...");
            PreparedStatement psStudent = con.prepareStatement("SELECT email FROM student_signup WHERE email = ?");
            psStudent.setString(1, email);
            ResultSet rsStudent = psStudent.executeQuery();
            if (rsStudent.next()) {
                isRegistered = true;
                tableName = "student_signup";
                System.out.println("   -> MATCH FOUND in student table.");
            }
            rsStudent.close();
            psStudent.close();
            
            // Check Admin/Librarian Table if not found in student table
            if (!isRegistered) {
                System.out.println("4. Checking lib_loginsignup table...");
                PreparedStatement psAdmin = con.prepareStatement("SELECT email FROM lib_loginsignup WHERE email = ?");
                psAdmin.setString(1, email);
                ResultSet rsAdmin = psAdmin.executeQuery();
                if (rsAdmin.next()) {
                    isRegistered = true;
                    tableName = "lib_loginsignup";
                    System.out.println("   -> MATCH FOUND in admin/librarian table.");
                }
                rsAdmin.close();
                psAdmin.close();
            }
            con.close();
            
        } catch (Throwable e) { 
            System.out.println("!!! DATABASE ERROR OCCURRED !!!");
            e.printStackTrace();
            response.getWriter().write("error");
            return;
        }

        // If email is not in the database, stop the process and return error
        if (!isRegistered) {
            System.out.println("ERROR: Email '" + email + "' does not exist in the database! OTP process aborted.");
            response.getWriter().write("error");
            return;
        }

        // --- 2. GENERATE AND SEND OTP ---
        System.out.println("5. Generating OTP...");
        Random rand = new Random();
        int otpValue = 100000 + rand.nextInt(900000); 
        System.out.println("   -> Generated OTP: " + otpValue);

        final String senderEmail = "aadityasingh.knp@gmail.com"; 
        final String senderPassword = "hsveatgatrwvhqvt"; 

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        System.out.println("6. Connecting to Gmail SMTP...");
        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(senderEmail));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
            message.setSubject("Library System - Password Reset OTP");
            message.setText("Hello,\n\nYour OTP for resetting your password is: " + otpValue + "\n\nPlease do not share this with anyone.");
            
            System.out.println("7. Dispatching email to " + email + "...");
            Transport.send(message);
            System.out.println("   -> Email sent successfully!");

            // Store OTP, Email, and the Table Name in HTTP session
            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("otp", otpValue);
            httpSession.setAttribute("resetEmail", email);
            httpSession.setAttribute("resetTable", tableName); 

            response.getWriter().write("success");
            System.out.println("--- OTP PROCESS COMPLETED SUCCESSFULLY ---\n");

        } catch (Throwable e) { 
            System.out.println("!!! EMAIL SENDING ERROR OCCURRED !!!");
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}