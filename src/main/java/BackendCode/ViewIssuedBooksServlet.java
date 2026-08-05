package BackendCode;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

@WebServlet("/ViewIssuedBooksOld")   // <-- FIXED: unique mapping (was "/ViewIssuedBooks")
public class ViewIssuedBooksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        List<IssuedBook> issuedBooks = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT i.issue_id, s.crn, s.student_name, s.contact, s.course, " +
                         "b.accession_number, b.title as book_title, b.author, b.edition, " +
                         "i.issue_date, i.due_date, i.status " +
                         "FROM issued_books i " +
                         "JOIN students s ON i.student_id = s.student_id " +
                         "JOIN books b ON i.book_id = b.book_id";
            
            if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
                sql += " WHERE i.issue_date BETWEEN ? AND ?";
            }
            
            sql += " ORDER BY i.issue_date DESC";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
                    stmt.setString(1, fromDate);
                    stmt.setString(2, toDate);
                }
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        IssuedBook book = new IssuedBook();
                        book.setIssueId(rs.getString("issue_id"));
                        book.setCrn(rs.getString("crn"));
                        book.setStudentName(rs.getString("student_name"));
                        book.setContact(rs.getString("contact"));
                        book.setCourse(rs.getString("course"));
                        book.setAccessionNumber(rs.getString("accession_number"));
                        book.setBookTitle(rs.getString("book_title"));
                        book.setAuthor(rs.getString("author"));
                        book.setEdition(rs.getString("edition"));
                        book.setIssueDate(rs.getDate("issue_date"));
                        book.setDueDate(rs.getDate("due_date"));
                        book.setStatus(rs.getString("status"));
                        
                        issuedBooks.add(book);
                    }
                }
            }
            
            // Create response JSON
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(new Response(true, "Data fetched successfully", issuedBooks));
            
            PrintWriter out = response.getWriter();
            out.print(jsonResponse);
            out.flush();
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}

class IssuedBook {
    private String issueId;
    private String crn;
    private String studentName;
    private String contact;
    private String course;
    private String accessionNumber;
    private String bookTitle;
    private String author;
    private String edition;
    private Date issueDate;
    private Date dueDate;
    private String status;
    
    // Getters and setters
    public String getIssueId() { return issueId; }
    public void setIssueId(String issueId) { this.issueId = issueId; }
    
    public String getCrn() { return crn; }
    public void setCrn(String crn) { this.crn = crn; }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
    
    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }
    
    public String getAccessionNumber() { return accessionNumber; }
    public void setAccessionNumber(String accessionNumber) { this.accessionNumber = accessionNumber; }
    
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    
    public String getEdition() { return edition; }
    public void setEdition(String edition) { this.edition = edition; }
    
    public Date getIssueDate() { return issueDate; }
    public void setIssueDate(Date issueDate) { this.issueDate = issueDate; }
    
    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

class Response {
    private boolean success;
    private String message;
    private List<IssuedBook> data;
    
    public Response(boolean success, String message, List<IssuedBook> data) {
        this.success = success;
        this.message = message;
        this.data = data;
    }
    
    public boolean isSuccess() { return success; }
    public String getMessage() { return message; }
    public List<IssuedBook> getData() { return data; }
}