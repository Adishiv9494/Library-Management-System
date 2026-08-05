package BackendCode;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet("/AddBookServlet")
public class AddBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Database connection parameters
 // Update these variables with your Aiven details
    private static final String DB_URL = "jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&serverTimezone=UTC";
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASSWORD = "HIDDEN_PASSWORD";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        try {
            // Get form parameters
            int startingAccessionNumber = Integer.parseInt(request.getParameter("accessionNumber"));
            int numCopies = Integer.parseInt(request.getParameter("numCopies"));
            String bookName = request.getParameter("bookName");
            String author = request.getParameter("author");
            String publisher = request.getParameter("publisher");
            String edition = request.getParameter("edition");
            double price = Double.parseDouble(request.getParameter("price"));
            
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                // Prepare SQL statement
                String sql = "INSERT INTO booksData (accession_number, book_name, author, publisher, edition, price) VALUES (?, ?, ?, ?, ?, ?)";
                
                // Start transaction
                conn.setAutoCommit(false);
                
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    int successCount = 0;
                    
                    // Insert each copy of the book with sequential accession numbers
                    for (int i = 0; i < numCopies; i++) {
                        int currentAccessionNumber = startingAccessionNumber + i;
                        
                        pstmt.setInt(1, currentAccessionNumber);
                        pstmt.setString(2, bookName);
                        pstmt.setString(3, author);
                        pstmt.setString(4, publisher);
                        pstmt.setString(5, edition);
                        pstmt.setDouble(6, price);
                        
                        pstmt.addBatch();
                        successCount++;
                    }
                    
                    // Execute batch insert
                    int[] results = pstmt.executeBatch();
                    
                    // Verify all inserts were successful
                    for (int result : results) {
                        if (result != PreparedStatement.SUCCESS_NO_INFO && result <= 0) {
                            conn.rollback();
                            jsonResponse.put("success", false);
                            jsonResponse.put("message", "Failed to insert some book records");
                            out.print(jsonResponse.toString());
                            return;
                        }
                    }
                    
                    // Commit transaction if all inserts were successful
                    conn.commit();
                    
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Successfully added " + successCount + " book(s) with accession numbers " + 
                            startingAccessionNumber + " to " + (startingAccessionNumber + numCopies - 1));
                } catch (SQLException e) {
                    conn.rollback();
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Database error: " + e.getMessage());
                } finally {
                    conn.setAutoCommit(true);
                }
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Invalid number format: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "JDBC driver not found: " + e.getMessage());
        } catch (SQLException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Database connection error: " + e.getMessage());
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Unexpected error: " + e.getMessage());
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }
}