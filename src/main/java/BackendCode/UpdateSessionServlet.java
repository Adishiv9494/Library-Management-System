package BackendCode;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateSessionServlet")
public class UpdateSessionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            String contactNumber = request.getParameter("contact_number");
            if (contactNumber != null && !contactNumber.trim().isEmpty()) {
                session.setAttribute("contact_number", contactNumber.trim());
                response.getWriter().write("Session updated successfully");
                return;
            }
        }
        response.getWriter().write("Session update failed");
    }
}