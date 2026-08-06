<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
    String rollNo = (String) session.getAttribute("crn");
    if (rollNo == null || rollNo.trim().isEmpty()) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>My Downloaded E-Books</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");
        body { font-family: 'Ubuntu', sans-serif; background-color: #f4f7f6; transition: all 0.3s ease; }
        [data-bs-theme="dark"] body { background-color: #121212; color: #e0e0e0; }
        
        .page-header { display: flex; justify-content: space-between; align-items: center; padding: 1.5rem 0; margin-bottom: 1.5rem; border-bottom: 2px solid rgba(0,0,0,0.05); }
        .back-btn { border-radius: 50px; padding: 8px 20px; font-weight: 500; transition: all 0.3s ease; }
        .ebook-card { background-color: #fff; border: none; border-radius: 15px; box-shadow: 0 8px 25px rgba(0,0,0,0.06); transition: all 0.3s ease; display: flex; align-items: center; padding: 20px; }
        [data-bs-theme="dark"] .ebook-card { background-color: #1e1e1e; }
        .ebook-card:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(0,0,0,0.12); }
        
        .ebook-icon { font-size: 3rem; color: #ff6600; margin-right: 20px; }
        .ebook-details { flex-grow: 1; }
        .ebook-title { font-size: 1.2rem; font-weight: 700; color: #4e73df; margin-bottom: 5px; }
        .ebook-meta { font-size: 0.85rem; color: #888; }
        .btn-view { background: linear-gradient(135deg, #4e73df, #224abe); color: white; border: none; border-radius: 8px; font-weight: 600; padding: 8px 20px; }
        .btn-view:hover { opacity: 0.9; color: white; }
    </style>
</head>
<body>
    <div class="container py-4 animate__animated animate__fadeIn">
        <div class="page-header">
            <button class="btn btn-outline-secondary back-btn" onclick="window.location.href='StudentDashboard.jsp'">
                <i class="fas fa-arrow-left me-2"></i>Dashboard
            </button>
            <h2 class="mb-0 fw-bold" style="color: #ff6600;">
                <i class="fas fa-download me-2"></i>My Downloaded E-Books
            </h2>
            <div></div>
        </div>

        <div class="row g-4">
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC", "avnadmin", "AVNS_M_y84BDpUY38oAAS0w1");
                    
                    // FIXED: Ensures table exists before attempting to query it
                    String createTableSQL = "CREATE TABLE IF NOT EXISTS downloaded_ebooks (" +
                                            "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                            "crn VARCHAR(50) NOT NULL, " +
                                            "ebook_id INT, " +
                                            "title VARCHAR(255), " +
                                            "author VARCHAR(255), " +
                                            "pdf_url VARCHAR(500), " +
                                            "downloaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                                            ")";
                    try (Statement stmt = conn.createStatement()) { stmt.execute(createTableSQL); }
                    
                    String query = "SELECT title, author, pdf_url, downloaded_at FROM downloaded_ebooks WHERE crn = ? ORDER BY downloaded_at DESC";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, rollNo);
                    rs = pstmt.executeQuery();
                    
                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
                    boolean hasDownloads = false;
                    
                    while (rs.next()) {
                        hasDownloads = true;
                        String title = rs.getString("title");
                        String author = rs.getString("author");
                        String pdfUrl = rs.getString("pdf_url");
                        Timestamp downDate = rs.getTimestamp("downloaded_at");
            %>
            <div class="col-md-6 animate__animated animate__slideInUp">
                <div class="ebook-card">
                    <div class="ebook-icon"><i class="fas fa-file-pdf"></i></div>
                    <div class="ebook-details">
                        <div class="ebook-title"><%= title %></div>
                        <div class="ebook-meta"><i class="fas fa-user-edit me-1"></i> <%= author %></div>
                        <div class="ebook-meta mt-1"><i class="fas fa-clock me-1"></i> Downloaded: <%= downDate != null ? sdf.format(downDate) : "Unknown" %></div>
                    </div>
                    <div>
                        <!-- Use direct download logic via native link attribute -->
                        <a href="<%= request.getContextPath() %>/<%= pdfUrl %>" download class="btn btn-view text-decoration-none shadow-sm">
                            <i class="fas fa-save me-1"></i> Re-Download
                        </a>
                    </div>
                </div>
            </div>
            <%
                    }
                    if (!hasDownloads) {
                        out.println("<div class='col-12 text-center py-5'><i class='fas fa-folder-open fs-1 text-muted mb-3 d-block'></i><h4 class='text-muted'>You haven't downloaded any E-Books yet.</h4></div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='col-12 text-danger text-center fw-bold'>Error connecting to server. Please try again.</div>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { }
                    try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { }
                }
            %>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            if (localStorage.getItem('theme') === 'dark') { document.documentElement.setAttribute('data-bs-theme', 'dark'); }
        });
    </script>
</body>
</html>
