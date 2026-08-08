<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String rollNo = (String) session.getAttribute("crn");
    if (rollNo == null || rollNo.isEmpty()) {
        response.sendRedirect("StudentSignup.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>View E-Books</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");

        :root {
            --bs-body-bg: #f4f7f6;
            --bs-body-color: #2c3e50;
            --card-bg: #ffffff;
            --primary-gradient: linear-gradient(135deg, #4e73df, #224abe);
            --primary-color: #4e73df; 
            --border-color: rgba(0,0,0,0.05);
        }
        
        [data-bs-theme="dark"] {
            --bs-body-bg: #121212;
            --bs-body-color: #e0e0e0;
            --card-bg: #1e1e1e;
            --primary-gradient: linear-gradient(135deg, #5a67d8, #3a45b4);
            --primary-color: #5a67d8;
            --border-color: rgba(255,255,255,0.05);
        }

        body { font-family: 'Ubuntu', sans-serif; background-color: var(--bs-body-bg); color: var(--bs-body-color); transition: all 0.3s ease; }

        .page-header { display: flex; justify-content: space-between; align-items: center; padding: 1.5rem 0; margin-bottom: 1.5rem; border-bottom: 2px solid var(--border-color); }
        .back-btn { border-radius: 50px; padding: 8px 20px; font-weight: 500; transition: all 0.3s ease; }
        .back-btn:hover { transform: translateX(-5px); box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .theme-toggle { border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease; }
        .theme-toggle:hover { transform: rotate(20deg) scale(1.1); }

        .ebook-card { background-color: var(--card-bg); border: none; border-radius: 15px; box-shadow: 0 8px 25px rgba(0,0,0,0.06); transition: all 0.3s ease; height: 100%; display: flex; flex-direction: column; overflow: hidden; }
        .ebook-card:hover { transform: translateY(-10px); box-shadow: 0 15px 35px rgba(0,0,0,0.12); }
        .ebook-header { background: var(--primary-gradient); color: white; padding: 20px; text-align: center; font-size: 3rem; }
        .ebook-body { padding: 20px; flex-grow: 1; display: flex; flex-direction: column; }
        .ebook-title { font-weight: 700; font-size: 1.2rem; margin-bottom: 10px; color: var(--primary-color); }
        .ebook-author { font-size: 0.9rem; color: #858796; margin-bottom: 15px; font-weight: 500; }
        .ebook-desc { font-size: 0.85rem; margin-bottom: 20px; flex-grow: 1; opacity: 0.8; }
        
        .action-buttons { display: flex; gap: 10px; margin-top: auto; }
        .btn-view { flex: 1; background-color: rgba(78, 115, 223, 0.1); color: var(--primary-color); border: none; font-weight: 600; border-radius: 8px; }
        .btn-view:hover { background-color: var(--primary-color); color: white; }
        .btn-download { flex: 1; background: var(--primary-gradient); color: white; border: none; font-weight: 600; border-radius: 8px; }
        .btn-download:hover { opacity: 0.9; color: white; transform: scale(1.02); }

        .modal-content { background-color: var(--card-bg); border-radius: 15px; border: none; }
        .modal-header { border-bottom: 1px solid var(--border-color); }
        .modal-title { color: var(--primary-color); font-weight: bold; }
        iframe { border-radius: 10px; background-color: #f8f9fa; }
    </style>
</head>
<body>
    <div class="container py-4 animate__animated animate__fadeIn">
        
        <div class="page-header">
            <button class="btn btn-outline-secondary back-btn" onclick="window.location.href='StudentDashboard.jsp'">
                <i class="fas fa-arrow-left me-2"></i>Dashboard
            </button>
            <h2 class="mb-0 fw-bold" style="color: var(--primary-color);">
                <i class="fas fa-desktop me-2"></i>E-Books Library
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
                    conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC", "avnadmin", "AVNS_M_y84BDpUY38oAAS0w1");
                    
                    String query = "SELECT id, title, author, description, pdf_url FROM ebooks ORDER BY id DESC"; 
                    pstmt = conn.prepareStatement(query);
                    rs = pstmt.executeQuery();
                    
                    boolean hasBooks = false;
                    while (rs.next()) {
                        hasBooks = true;
                        String id = rs.getString("id");
                        String title = rs.getString("title");
                        String author = rs.getString("author");
                        String desc = rs.getString("description");
                        String pdfUrl = rs.getString("pdf_url"); 
                        
                        String safeTitle = title != null ? title.replace("'", "\\'") : "Unknown Title";
                        String safeAuthor = author != null ? author.replace("'", "\\'") : "Unknown Author";
            %>
            <div class="col-md-6 col-lg-4 col-xl-3 animate__animated animate__zoomIn">
                <div class="ebook-card">
                    <div class="ebook-header"><i class="fas fa-file-pdf"></i></div>
                    <div class="ebook-body">
                        <div class="ebook-title"><%= title != null ? title : "Unknown Title" %></div>
                        <div class="ebook-author"><i class="fas fa-user-edit me-2"></i><%= author != null ? author : "Unknown Author" %></div>
                        <div class="ebook-desc">
                            <%= desc != null ? desc : "No description available." %>
                        </div>
                        <div class="action-buttons">
                            <button class="btn btn-view" onclick="openPdfViewer('<%= safeTitle %>', '<%= request.getContextPath() %>', '<%= pdfUrl %>')">
                                <i class="fas fa-eye me-1"></i> View
                            </button>
                            <button class="btn btn-download" onclick="downloadEBook('<%= id %>', '<%= safeTitle %>', '<%= safeAuthor %>', '<%= request.getContextPath() %>', '<%= pdfUrl %>')">
                                <i class="fas fa-download me-1"></i> Save
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                    if (!hasBooks) {
                        out.println("<div class='col-12 text-center py-5'><i class='fas fa-folder-open fs-1 text-muted mb-3 d-block'></i><h4 class='text-muted'>No E-Books currently available.</h4></div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='col-12 text-danger text-center fw-bold'>Error loading E-Books. Database connection failed.</div>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { }
                    try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { }
                }
            %>
        </div>
    </div>

    <div class="modal fade" id="pdfModal" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="pdfModalTitle">Reading E-Book</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <iframe id="pdfViewer" src="" width="100%" height="75vh" style="min-height: 80vh; border:none;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        const themeToggle = document.getElementById('themeToggle');
        const root = document.documentElement;
        if (localStorage.getItem('theme') === 'dark') { root.setAttribute('data-bs-theme', 'dark'); themeToggle.innerHTML = '<i class="fas fa-sun text-warning"></i>'; }
        themeToggle.addEventListener('click', function() {
            if (root.getAttribute('data-bs-theme') === 'dark') { root.setAttribute('data-bs-theme', 'light'); themeToggle.innerHTML = '<i class="fas fa-moon"></i>'; localStorage.setItem('theme', 'light'); } 
            else { root.setAttribute('data-bs-theme', 'dark'); themeToggle.innerHTML = '<i class="fas fa-sun text-warning"></i>'; localStorage.setItem('theme', 'dark'); }
        });

        function formatPdfUrl(context, url) {
            if(url.startsWith('http://') || url.startsWith('https://')) return url;
            let formattedUrl = url.startsWith('/') ? url : '/' + url;
            if(context !== '' && !formattedUrl.startsWith(context)) {
                formattedUrl = context + formattedUrl;
            }
            return formattedUrl;
        }

        function openPdfViewer(title, contextPath, rawUrl) {
            let finalUrl = formatPdfUrl(contextPath, rawUrl);
            document.getElementById('pdfModalTitle').innerText = title;
            document.getElementById('pdfViewer').src = finalUrl + "#toolbar=0&navpanes=0&scrollbar=0";
            new bootstrap.Modal(document.getElementById('pdfModal')).show();
        }

        document.getElementById('pdfModal').addEventListener('hidden.bs.modal', function () { document.getElementById('pdfViewer').src = ""; });

        function downloadEBook(ebookId, title, author, contextPath, rawUrl) {
            let finalUrl = formatPdfUrl(contextPath, rawUrl);
            
            $.post("LogDownload.jsp", { 
                ebookId: ebookId, title: title, author: author, pdfUrl: finalUrl
            }, function(response) {
                let res = response.trim();
                
                // Read the 'exists' response from the backend to stop duplicate downloads
                if (res === "exists") {
                    Swal.fire({
                        icon: 'info',
                        title: 'Already Downloaded!',
                        text: 'You have already downloaded this E-Book. Check your "My Downloads" section to access it.',
                        confirmButtonColor: '#4e73df',
                        confirmButtonText: 'Got it!'
                    });
                } 
                // If it doesn't exist, proceed with download
                else if (res === "success") {
                    const link = document.createElement('a');
                    link.href = finalUrl;
                    link.setAttribute('download', ''); 
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);

                    Swal.fire({
                        icon: 'success',
                        title: 'Download Started',
                        text: 'This E-Book has been added to your downloads list.',
                        timer: 2000,
                        showConfirmButton: false
                    });
                } else {
                    Swal.fire('Error!', 'Failed to process request. Please try again.', 'error');
                }
            }).fail(function() { 
                Swal.fire('Error!', 'Database failed to record download. Please try again.', 'error'); 
            });
        }
    </script>
</body>
</html>