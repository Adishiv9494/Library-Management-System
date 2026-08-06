package BackendCode;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        int enteredOtp = Integer.parseInt(request.getParameter("otp"));
        
        HttpSession session = request.getSession();
        Integer sessionOtp = (Integer) session.getAttribute("otp");

        // Verify if the OTP matches
        if (sessionOtp != null && enteredOtp == sessionOtp) {
            response.getWriter().write("success");
        } else {
            response.getWriter().write("error");
        }
    }
}