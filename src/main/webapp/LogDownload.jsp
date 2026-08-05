<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String rollNo = (String) session.getAttribute("crn");
    String ebookId = request.getParameter("ebookId");
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String pdfUrl = request.getParameter("pdfUrl");
    
    if (rollNo == null || ebookId == null || title == null || pdfUrl == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"status\":\"error\", \"message\":\"Unauthorized or missing data\"}");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&serverTimezone=UTC", "root", "Adishiv@7318");
        
        // 1. Ensure Table Exists with New Columns (Decoupled from main ebooks table)
        String createTableSQL = "CREATE TABLE IF NOT EXISTS downloaded_ebooks (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "crn VARCHAR(50) NOT NULL, " +
            "ebook_id INT NOT NULL, " +
            "title VARCHAR(255), " +
            "author VARCHAR(255), " +
            "pdf_url VARCHAR(500), " +
            "download_date DATETIME NOT NULL" +
        ")";
        try (Statement stmt = conn.createStatement()) {
            stmt.execute(createTableSQL);
            
            // Auto-update older tables if they don't have the new columns yet (fail-safe)
            try { stmt.execute("ALTER TABLE downloaded_ebooks ADD COLUMN title VARCHAR(255)"); } catch(Exception e){}
            try { stmt.execute("ALTER TABLE downloaded_ebooks ADD COLUMN author VARCHAR(255)"); } catch(Exception e){}
            try { stmt.execute("ALTER TABLE downloaded_ebooks ADD COLUMN pdf_url VARCHAR(500)"); } catch(Exception e){}
        }
        
        // 2. Prevent Duplicate Logs
        String checkQuery = "SELECT COUNT(*) FROM downloaded_ebooks WHERE crn = ? AND ebook_id = ?";
        pstmt = conn.prepareStatement(checkQuery);
        pstmt.setString(1, rollNo);
        pstmt.setString(2, ebookId);
        ResultSet rs = pstmt.executeQuery();
        
        boolean alreadyDownloaded = false;
        if(rs.next() && rs.getInt(1) > 0) {
            alreadyDownloaded = true;
        }
        rs.close();
        pstmt.close();

        // 3. Insert specific download data allowing persistence if admin deletes original book
        if (!alreadyDownloaded) {
            String insertQuery = "INSERT INTO downloaded_ebooks (crn, ebook_id, title, author, pdf_url, download_date) VALUES (?, ?, ?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(insertQuery);
            pstmt.setString(1, rollNo);
            pstmt.setString(2, ebookId);
            pstmt.setString(3, title);
            pstmt.setString(4, author);
            pstmt.setString(5, pdfUrl);
            pstmt.executeUpdate();
        }

        out.print("{\"status\":\"success\"}");
        
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { }
        try { if (conn != null) conn.close(); } catch (SQLException e) { }
    }
%>