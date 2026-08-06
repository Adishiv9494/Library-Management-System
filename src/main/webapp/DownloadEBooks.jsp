<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String rollNo = (String) session.getAttribute("crn");
    if (rollNo == null || rollNo.isEmpty()) {
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");

        :root {
            --bs-body-bg: #f4f7f6;
            --bs-body-color: #2c3e50;
            --card-bg: #ffffff;
            --primary-gradient: linear-gradient(135deg, #f6c23e, #e0a800);
            --primary-color: #f6c23e; 
            --danger-color: #e74a3b;
            --border-color: rgba(0,0,0,0.05);
        }
        
        [data-bs-theme="dark"] {
            --bs-body-bg: #121212;
            --bs-body-color: #e0e0e0;
            --card-bg: #1e1e1e;
            --primary-gradient: linear-gradient(135deg, #f59e0b, #b45309);
            --primary-color: #f59e0b;
            --danger-color: #ef4444;
            --border-color: rgba(255,255,255,0.05);
        }

        body { font-family: 'Ubuntu', sans-serif; background-color: var(--bs-body-bg); color: var(--bs-body-color); transition: all 0.3s ease; }

        .page-header { display: flex; justify-content: space-between; align-items: center; padding: 1.5rem 0; margin-bottom: 1.5rem; border-bottom: 2px solid var(--border-color); }
        .back-btn { border-radius: 50px; padding: 8px 20px; font-weight: 500; transition: all 0.3s ease; }
        .back-btn:hover { transform: translateX(-5px); box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .theme-toggle { border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease; }
        .theme-toggle:hover { transform: rotate(20deg) scale(1.1); }

        .downloaded-card { background-color: var(--card-bg); border: none; border-left: 5px solid var(--primary-color); border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); transition: all 0.3s ease; height: 100%; display: flex; align-items: center; padding: 20px; }
        .downloaded-card:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
        
        .card-icon { font-size: 3.5rem; color: var(--primary-color); margin-right: 25px; opacity: 0.9; }
        .card-content { flex-grow: 1; }
        .book-title { font-weight: 700; font-size: 1.25rem; margin-bottom: 5px; color: var(--bs-body-color); }
        .book-author { font-size: 0.9rem; color: #858796; margin-bottom: 10px; }
        .download-date { font-size: 0.8rem; opacity: 0.7; font-style: italic; }
        
        .btn-group-custom { display: flex; flex-direction: column; gap: 10px; }
        .btn-reopen { background: var(--primary-gradient); color: white; border: none; font-weight: 600; border-radius: 6px; padding: 8px 20px; width: 110px; text-align: center; }
        .btn-reopen:hover { opacity: 0.9; color: white; transform: scale(1.03); }
        .btn-delete { background-color: var(--danger-color); color: white; border: none; font-weight: 600; border-radius: 6px; padding: 8px 20px; width: 110px; text-align: center; transition: 0.2s;}
        .btn-delete:hover { background-color: #c0392b; color: white; transform: scale(1.03); }
        .btn-disabled { background-color: #cccccc; color: #666; border: none; font-weight: 600; border-radius: 6px; padding: 8px 20px; width: 110px; text-align: center; cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="container py-4 animate__animated animate__fadeIn">
        
        <!-- Header -->
        <div class="page-header">
            <button class="btn btn-outline-secondary back-btn" onclick="window.location.href='StudentDashboard.jsp'">
                <i class="fas fa-arrow-left me-2"></i>Dashboard
            </button>
            <h2 class="mb-0 fw-bold" style="color: var(--primary-color);">
                <i class="fas fa-download me-2"></i>My Downloaded E-Books
            </h2>
            <button id="themeToggle" class="btn btn-outline-secondary theme-toggle">
                <i class="fas fa-moon"></i>
            </button>
        </div>

        <div class="row g-4">
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&serverTimezone=UTC", "root", "Adishiv@7318");
                    
                    // Left Join query to fetch from both tables
                    String query = "SELECT d.id, " +
                                   "d.title AS d_title, e.title AS e_title, " +
                                   "d.author AS d_author, e.author AS e_author, " +
                                   "d.pdf_url AS d_url, e.pdf_url AS e_url, " +
                                   "d.download_date " +
                                   "FROM downloaded_ebooks d " +
                                   "LEFT JOIN ebooks e ON d.ebook_id = e.id " +
                                   "WHERE d.crn = ? " +
                                   "ORDER BY d.download_date DESC";
                                   
                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, rollNo);
                    rs = pstmt.executeQuery();
                    
                    boolean hasDownloads = false;
                    while (rs.next()) {
                        hasDownloads = true;
                        String recordId = rs.getString("id");
                        
                        // STRICT NULL FILTERING: Fixes the literal "null" string issue
                        String dTitle = rs.getString("d_title");
                        String eTitle = rs.getString("e_title");
                        dTitle = (dTitle != null && !dTitle.equalsIgnoreCase("null") && !dTitle.trim().isEmpty()) ? dTitle : null;
                        eTitle = (eTitle != null && !eTitle.equalsIgnoreCase("null") && !eTitle.trim().isEmpty()) ? eTitle : null;
                        String title = dTitle != null ? dTitle : (eTitle != null ? eTitle : "Unknown Title");

                        String dAuthor = rs.getString("d_author");
                        String eAuthor = rs.getString("e_author");
                        dAuthor = (dAuthor != null && !dAuthor.equalsIgnoreCase("null") && !dAuthor.trim().isEmpty()) ? dAuthor : null;
                        eAuthor = (eAuthor != null && !eAuthor.equalsIgnoreCase("null") && !eAuthor.trim().isEmpty()) ? eAuthor : null;
                        String author = dAuthor != null ? dAuthor : (eAuthor != null ? eAuthor : "Unknown Author");

                        String dUrl = rs.getString("d_url");
                        String eUrl = rs.getString("e_url");
                        dUrl = (dUrl != null && !dUrl.equalsIgnoreCase("null") && !dUrl.trim().isEmpty()) ? dUrl : null;
                        eUrl = (eUrl != null && !eUrl.equalsIgnoreCase("null") && !eUrl.trim().isEmpty()) ? eUrl : null;
                        String pdfUrl = dUrl != null ? dUrl : (eUrl != null ? eUrl : "");
                        
                        String date = rs.getString("download_date");
            %>
            <div class="col-md-6 animate__animated animate__fadeInUp" id="card-<%= recordId %>">
                <div class="downloaded-card">
                    <div class="card-icon">
                        <i class="fas fa-file-pdf"></i>
                    </div>
                    <div class="card-content">
                        <div class="book-title"><%= title %></div>
                        <div class="book-author"><i class="fas fa-user-edit me-1"></i> <%= author %></div>
                        <div class="download-date"><i class="fas fa-clock me-1"></i> Saved on: <%= date %></div>
                    </div>
                    <div class="btn-group-custom">
                        <% if (!pdfUrl.isEmpty()) { %>
                            <!-- Correct URL formatting to prevent 404 -->
                            <a href="<%= request.getContextPath() %>/<%= pdfUrl %>" target="_blank" class="btn btn-reopen text-decoration-none">
                                <i class="fas fa-folder-open"></i> Open
                            </a>
                        <% } else { %>
                            <!-- Fallback if physical file URL is missing -->
                            <button class="btn btn-disabled" disabled title="Original file has been permanently removed by Admin">
                                <i class="fas fa-times-circle"></i> Missing
                            </button>
                        <% } %>
                        <button class="btn btn-delete" onclick="deleteMyDownload('<%= recordId %>')">
                            <i class="fas fa-trash-alt"></i> Delete
                        </button>
                    </div>
                </div>
            </div>
            <%
                    }
                    if (!hasDownloads) {
                        out.println("<div class='col-12 text-center py-5'><i class='fas fa-box-open fs-1 text-muted mb-3 d-block'></i><h4 class='text-muted'>You haven't downloaded any E-Books yet.</h4><p class='text-muted'>Go to 'View E-Books' to explore and download study materials.</p></div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='col-12 text-danger text-center fw-bold'><i class='fas fa-exclamation-triangle me-2'></i>Database Error: Ensure 'downloaded_ebooks' table is created.</div>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { }
                    try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { }
                }
            %>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        const themeToggle = document.getElementById('themeToggle');
        const root = document.documentElement;
        if (localStorage.getItem('theme') === 'dark') {
            root.setAttribute('data-bs-theme', 'dark');
            themeToggle.innerHTML = '<i class="fas fa-sun text-warning"></i>';
        }
        themeToggle.addEventListener('click', function() {
            if (root.getAttribute('data-bs-theme') === 'dark') {
                root.setAttribute('data-bs-theme', 'light');
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
                localStorage.setItem('theme', 'light');
            } else {
                root.setAttribute('data-bs-theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun text-warning"></i>';
                localStorage.setItem('theme', 'dark');
            }
        });

        // Function to remove record from dashboard
        function deleteMyDownload(recordId) {
            Swal.fire({
                title: 'Remove from your downloads?',
                text: "This will remove the book from your dashboard list.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e74a3b',
                cancelButtonColor: '#858796',
                confirmButtonText: 'Yes, remove it!',
                background: root.getAttribute('data-bs-theme') === 'dark' ? '#1e1e1e' : '#fff',
                color: root.getAttribute('data-bs-theme') === 'dark' ? '#fff' : '#000'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.post("RemoveDownload.jsp", { id: recordId }, function(response) {
                        if(response.status === 'success') {
                            $('#card-' + recordId).addClass('animate__fadeOutDown');
                            setTimeout(() => { $('#card-' + recordId).remove(); }, 800);
                            
                            Swal.fire({
                                title: 'Removed!', 
                                text: 'The book was removed from your list.', 
                                icon: 'success',
                                background: root.getAttribute('data-bs-theme') === 'dark' ? '#1e1e1e' : '#fff',
                                color: root.getAttribute('data-bs-theme') === 'dark' ? '#fff' : '#000',
                                timer: 1500
                            });
                        } else {
                            Swal.fire('Error!', 'Failed to remove the book.', 'error');
                        }
                    }, "json").fail(function() {
                        Swal.fire('Error!', 'Server connection failed.', 'error');
                    });
                }
            });
        }
    </script>
</body>
</html>