<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Security check
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("welcome.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="lib.png">
    <title>Manage E-Books</title>
     <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <!-- CSS Dependencies -->
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
            --primary-color: #2a2185; 
            --upload-color: #1cc88a;
            --upload-hover: #16a370;
            --view-color: #3b82f6;
            --view-hover: #2563eb;
            --delete-color: #e74a3b;
            --delete-hover: #c0392b;
            --border-color: rgba(0,0,0,0.08);
        }
        
        [data-bs-theme="dark"] {
            --bs-body-bg: #121212;
            --bs-body-color: #e0e0e0;
            --card-bg: #1e1e1e;
            --primary-color: #5a67d8;
            --upload-color: #10b981;
            --upload-hover: #059669;
            --view-color: #3b82f6;
            --delete-color: #ef4444;
            --border-color: rgba(255,255,255,0.1);
        }

        body { font-family: 'Ubuntu', sans-serif; background-color: var(--bs-body-bg); color: var(--bs-body-color); transition: background-color 0.3s ease, color 0.3s ease; }

        /* Header UI */
        .page-header { display: flex; justify-content: space-between; align-items: center; padding: 1.5rem 0; margin-bottom: 1.5rem; border-bottom: 2px solid var(--border-color); }
        .btn-controls { display: flex; gap: 10px; align-items: center; }
        .back-btn { border-radius: 50px; padding: 8px 20px; font-weight: 500; transition: transform 0.2s; }
        .back-btn:hover { transform: translateX(-3px); }
        .theme-toggle { border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; transition: all 0.3s; }
        .theme-toggle:hover { transform: rotate(20deg) scale(1.1); }
        
        /* Buttons */
        .btn-upload { background-color: var(--upload-color); color: white; border: none; font-weight: bold; padding: 10px 20px; border-radius: 50px; transition: all 0.3s ease; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .btn-upload:hover { background-color: var(--upload-hover); color: white; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(28,200,138,0.3); }

        .filter-container { background: var(--card-bg); padding: 15px 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); margin-bottom: 25px; border: 1px solid var(--border-color); }

        /* Cards UI */
        .ebook-card { background-color: var(--card-bg); border: 1px solid var(--border-color); border-radius: 15px; box-shadow: 0 8px 25px rgba(0,0,0,0.04); transition: all 0.3s ease; height: 100%; display: flex; flex-direction: column; overflow: hidden; }
        .ebook-card:hover { transform: translateY(-7px); box-shadow: 0 15px 35px rgba(0,0,0,0.08); }
        .ebook-header { background: linear-gradient(135deg, var(--primary-color), #4e54c8); color: white; padding: 25px; text-align: center; font-size: 3rem; position: relative; }
        .ebook-body { padding: 20px; flex-grow: 1; display: flex; flex-direction: column; }
        .ebook-title { font-weight: 700; font-size: 1.15rem; margin-bottom: 8px; color: var(--bs-body-color); }
        .ebook-meta { font-size: 0.9rem; color: #858796; margin-bottom: 15px; font-weight: 500; }
        .ebook-desc { font-size: 0.85rem; margin-bottom: 20px; flex-grow: 1; opacity: 0.8; }
        
        .action-buttons { display: flex; gap: 10px; margin-top: auto; }
        .btn-view { flex: 1; background-color: var(--view-color); color: white; border: none; font-weight: 600; border-radius: 8px; padding: 10px; transition: 0.2s; }
        .btn-view:hover { background-color: var(--view-hover); color: white; }
        .btn-delete { flex: 1; background-color: var(--delete-color); color: white; border: none; font-weight: 600; border-radius: 8px; padding: 10px; transition: 0.2s; }
        .btn-delete:hover { background-color: var(--delete-hover); color: white; }

        /* Inputs & Modals */
        .form-control, .modal-content { background-color: var(--card-bg); color: var(--bs-body-color); border-color: var(--border-color); }
        .form-control:focus { background-color: var(--card-bg); color: var(--bs-body-color); border-color: var(--primary-color); box-shadow: 0 0 0 0.25rem rgba(42, 33, 133, 0.25); }
        iframe { border-radius: 10px; background-color: #f8f9fa; width: 100%; height: 75vh; border: none; }
    </style>
</head>
<body>
    <div class="container py-4 animate__animated animate__fadeIn">
        <!-- Header Section -->
        <div class="page-header">
            <div>
                <button class="btn btn-outline-secondary back-btn" onclick="window.location.href='Dashboard.jsp'">
                    <i class="fas fa-arrow-left me-2"></i>Back
                </button>
            </div>
            <h2 class="mb-0 fw-bold text-center" style="color: var(--primary-color);">
                <i class="fas fa-book-reader me-2"></i>Manage E-Books
            </h2>
            <div class="btn-controls">
                <button id="themeToggle" class="btn btn-outline-secondary theme-toggle">
                    <i class="fas fa-moon"></i>
                </button>
                <button class="btn btn-upload" data-bs-toggle="modal" data-bs-target="#uploadModal">
                    <i class="fas fa-cloud-upload-alt me-2"></i>Upload E-Book
                </button>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="filter-container d-flex justify-content-between align-items-center">
            <h5 class="m-0"><i class="fas fa-filter me-2 text-muted"></i>Filter Collection</h5>
            <input type="text" id="searchInput" class="form-control w-50 rounded-pill px-4" placeholder="🔍 Search by title or author...">
        </div>

        <!-- E-Books Grid -->
        <div class="row g-4" id="ebooksGrid">
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&serverTimezone=UTC", "root", "Adishiv@7318");
                    
                    // --- AUTOMATIC TABLE CREATION FIX ---
                    String createTableSQL = "CREATE TABLE IF NOT EXISTS ebooks (" +
                                            "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                            "title VARCHAR(255) NOT NULL, " +
                                            "author VARCHAR(255) NOT NULL, " +
                                            "edition VARCHAR(100), " +
                                            "description TEXT, " +
                                            "pdf_url VARCHAR(500) NOT NULL, " +
                                            "uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                                            ")";
                    try (Statement stmt = conn.createStatement()) {
                        stmt.execute(createTableSQL);
                    }
                    
                    // Fetch existing books
                    String query = "SELECT * FROM ebooks ORDER BY id DESC";
                    pstmt = conn.prepareStatement(query);
                    rs = pstmt.executeQuery();
                    
                    boolean hasBooks = false;
                    while (rs.next()) {
                        hasBooks = true;
                        String id = rs.getString("id");
                        String title = rs.getString("title");
                        String author = rs.getString("author");
                        String edition = rs.getString("edition");
                        String desc = rs.getString("description");
                        String pdfUrl = rs.getString("pdf_url");
            %>
            <div class="col-md-6 col-lg-4 col-xl-3 ebook-item animate__animated animate__zoomIn">
                <div class="ebook-card">
                    <div class="ebook-header"><i class="fas fa-file-pdf"></i></div>
                    <div class="ebook-body">
                        <div class="ebook-title searchable"><%= title %></div>
                        <div class="ebook-meta searchable">
                            <i class="fas fa-user-edit me-1"></i><%= author %> <br>
                            <i class="fas fa-bookmark me-1 mt-1"></i>Edition: <%= edition %>
                        </div>
                        <div class="ebook-desc"><%= desc %></div>
                        <div class="action-buttons">
                            <button class="btn btn-view" onclick="openPdfViewer('<%= title.replace("'", "\\'") %>', '<%= pdfUrl %>')">
                                <i class="fas fa-eye me-1"></i>View
                            </button>
                            <button class="btn btn-delete" onclick="confirmDelete('<%= id %>')">
                                <i class="fas fa-trash-alt me-1"></i>Delete
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                    if (!hasBooks) {
                        out.println("<div class='col-12 text-center py-5'><i class='fas fa-folder-open fs-1 text-muted mb-3 d-block'></i><h4 class='text-muted'>No E-Books found. Click 'Upload E-Book' to add one.</h4></div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='col-12 text-danger text-center fw-bold py-4'><i class='fas fa-exclamation-triangle me-2'></i>Error loading E-Books: " + e.getMessage() + "</div>");
                } finally {
                    try { if (rs != null) rs.close(); } catch(SQLException e){}
                    try { if (pstmt != null) pstmt.close(); } catch(SQLException e){}
                    try { if (conn != null) conn.close(); } catch(SQLException e){}
                }
            %>
        </div>
    </div>

    <!-- Upload E-Book Modal -->
    <div class="modal fade" id="uploadModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <div class="modal-header border-bottom">
                    <h5 class="modal-title fw-bold" style="color: var(--upload-color);"><i class="fas fa-cloud-upload-alt me-2"></i>Upload New E-Book</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="uploadForm" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Book Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="title" required placeholder="Enter book title">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Author <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="author" required placeholder="Enter author name">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Edition <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="edition" required placeholder="e.g., 1st Edition, 2024">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="description" rows="3" required placeholder="Brief summary of the book..."></textarea>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-bold">Attach PDF File <span class="text-danger">*</span></label>
                            <input type="file" class="form-control" name="pdfFile" accept="application/pdf" required>
                        </div>
                        <button type="submit" class="btn w-100 btn-upload fs-5">Submit Upload</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- View PDF Modal -->
    <div class="modal fade" id="pdfModal" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <div class="modal-header border-bottom">
                    <h5 class="modal-title fw-bold text-primary" id="pdfModalTitle">Reading E-Book</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <iframe id="pdfViewer" src=""></iframe>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        // 1. Theme Toggle Logic (Bootstrap 5 native)
        const themeToggle = document.getElementById('themeToggle');
        const htmlElement = document.documentElement;
        
        if (localStorage.getItem('theme') === 'dark') {
            htmlElement.setAttribute('data-bs-theme', 'dark');
            themeToggle.innerHTML = '<i class="fas fa-sun text-warning"></i>';
        }
        
        themeToggle.addEventListener('click', function() {
            if (htmlElement.getAttribute('data-bs-theme') === 'dark') {
                htmlElement.setAttribute('data-bs-theme', 'light');
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
                localStorage.setItem('theme', 'light');
            } else {
                htmlElement.setAttribute('data-bs-theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun text-warning"></i>';
                localStorage.setItem('theme', 'dark');
            }
        });

        // 2. Search Filter Logic
        document.getElementById("searchInput").addEventListener("keyup", function() {
            let filter = this.value.toLowerCase();
            let items = document.querySelectorAll(".ebook-item");
            items.forEach(function(item) {
                let text = item.querySelector(".searchable").innerText.toLowerCase();
                let author = item.querySelector(".ebook-meta").innerText.toLowerCase();
                if (text.indexOf(filter) > -1 || author.indexOf(filter) > -1) {
                    item.style.display = "";
                } else {
                    item.style.display = "none";
                }
            });
        });

        // 3. PDF Viewer Logic
        function openPdfViewer(title, url) {
            document.getElementById('pdfModalTitle').innerText = title;
            document.getElementById('pdfViewer').src = url;
            new bootstrap.Modal(document.getElementById('pdfModal')).show();
        }
        
        document.getElementById('pdfModal').addEventListener('hidden.bs.modal', function () {
            document.getElementById('pdfViewer').src = "";
        });

        // Helper function for Dark Mode SweetAlert backgrounds
        function getSwalBg() { return htmlElement.getAttribute('data-bs-theme') === 'dark' ? '#1e1e1e' : '#fff'; }
        function getSwalColor() { return htmlElement.getAttribute('data-bs-theme') === 'dark' ? '#e0e0e0' : '#2c3e50'; }

        // 4. Delete Confirmation Logic (Red Button)
        function confirmDelete(id) {
            Swal.fire({
                title: 'Delete E-Book?',
                text: "This action cannot be undone!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e74a3b',
                cancelButtonColor: '#858796',
                confirmButtonText: 'Yes, delete it!',
                background: getSwalBg(),
                color: getSwalColor()
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: 'EBookActionServlet',
                        type: 'POST',
                        data: { action: 'delete', id: id },
                        success: function(response) {
                            let res = JSON.parse(response);
                            if(res.status === 'success') {
                                Swal.fire({
                                    title: 'Deleted!', 
                                    text: 'The E-book has been removed.', 
                                    icon: 'success', 
                                    background: getSwalBg(), 
                                    color: getSwalColor()
                                }).then(() => location.reload());
                            } else {
                                Swal.fire({ title: 'Error!', text: res.message, icon: 'error', background: getSwalBg(), color: getSwalColor() });
                            }
                        }
                    });
                }
            })
        }

        // 5. Form Submission Logic for Upload (Green Button)
        $('#uploadForm').submit(function(e){
            e.preventDefault();
            
            // Change button to loading state
            let submitBtn = $(this).find('button[type="submit"]');
            let originalText = submitBtn.html();
            submitBtn.html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Uploading...');
            submitBtn.prop('disabled', true);
            
            var formData = new FormData(this);
            formData.append("action", "upload");

            $.ajax({
                url: 'EBookActionServlet',
                type: 'POST',
                data: formData,
                success: function (response) {
                    let res = JSON.parse(response);
                    if (res.status === 'success') {
                        $('#uploadModal').modal('hide');
                        Swal.fire({
                            title: 'Success!', 
                            text: 'E-Book Uploaded Successfully. The Dashboard count has been updated.', 
                            icon: 'success',
                            background: getSwalBg(),
                            color: getSwalColor()
                        }).then(() => location.reload());
                    } else {
                        Swal.fire({ title: 'Upload Failed!', text: res.message, icon: 'error', background: getSwalBg(), color: getSwalColor() });
                        submitBtn.html(originalText);
                        submitBtn.prop('disabled', false);
                    }
                },
                error: function() {
                    Swal.fire({ title: 'Server Error!', text: 'Could not connect to the server.', icon: 'error', background: getSwalBg(), color: getSwalColor() });
                    submitBtn.html(originalText);
                    submitBtn.prop('disabled', false);
                },
                cache: false,
                contentType: false,
                processData: false
            });
        });
    </script>
</body>
</html>