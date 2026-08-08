<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String rollNo = (String) session.getAttribute("crn");
    if (rollNo == null || rollNo.trim().isEmpty()) {
        response.sendRedirect("StudentSignup.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Available Books</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");
        :root {
            --bs-body-bg: #f8f9fa; --bs-body-color: #212529; --card-bg: #ffffff;
            --table-bg: #ffffff; --primary-color: #4e73df; --secondary-color: #858796;
        }
        [data-bs-theme="dark"] {
            --bs-body-bg: #1a1a2e; --bs-body-color: #f8f9fa; --card-bg: #16213e;
            --table-bg: #16213e; --primary-color: #5a67d8; --secondary-color: #a0aec0;
        }
        body { font-family: "Ubuntu", sans-serif; background-color: var(--bs-body-bg); color: var(--bs-body-color); transition: all 0.3s ease; }
        .card { background-color: var(--card-bg); border: none; border-radius: 0.5rem; box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15); }
        .table { background-color: var(--table-bg); color: var(--bs-body-color); margin-bottom: 0; }
        .table th { border-bottom-width: 1px; border-top: none; background-color: rgba(78, 115, 223, 0.1); color: var(--primary-color); font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; }
        .table td { vertical-align: middle; border-top: 1px solid rgba(0, 0, 0, 0.05); }
        .btn-primary { background-color: var(--primary-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #3a56c7; border-color: #3a56c7; }
        .form-control, .form-select { background-color: var(--card-bg); color: var(--bs-body-color); border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 0.35rem; }
        .form-control:focus, .form-select:focus { background-color: var(--card-bg); color: var(--bs-body-color); border-color: var(--primary-color); box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25); }
        .search-card { border-left: 0.25rem solid var(--primary-color) !important; }
        .back-btn { transition: all 0.3s; }
        .back-btn:hover { transform: translateX(-3px); }
        .theme-toggle { transition: all 0.3s; }
        .theme-toggle:hover { transform: rotate(15deg); }
        .book-name { font-weight: 500; }
        .author-name { font-style: italic; }
        .serial-number { color: var(--secondary-color); font-weight: 500; }
        /* Hide DataTables default controls to use custom UI */
        .dataTables_filter, .dataTables_length, .dataTables_info, .dataTables_paginate { display: none; }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary back-btn" onclick="window.location.href='StudentDashboard.jsp'">
                        <i class="fas fa-arrow-left me-2"></i>Dashboard
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                        <i class="fas fa-book me-2"></i>Available Books
                    </h2>
                    <div class="d-flex gap-2">
                        <button id="themeToggle" class="btn btn-outline-secondary theme-toggle">
                            <i class="fas fa-moon"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm search-card">
                    <div class="card-body py-3">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-12">
                                <label for="searchInput" class="form-label fw-semibold">Search Books</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    <input type="text" class="form-control" id="searchInput" placeholder="Search by book name, author, or publisher...">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive p-3">
                            <table class="table table-hover" id="booksTable">
                                <thead>
                                    <tr>
                                        <th width="10%">S.No.</th>
                                        <th width="35%">Book Name</th>
                                        <th width="15%">Edition</th>
                                        <th width="20%">Author</th>
                                        <th width="20%">Publisher</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection conn = null;
                                        PreparedStatement pstmt = null;
                                        ResultSet rs = null;
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC", "avnadmin", "AVNS_M_y84BDpUY38oAAS0w1");
                                            
                                            // Fetch DISTINCT available books (groups duplicates together)
                                            String query = "SELECT DISTINCT book_name, edition, author, publisher FROM booksdata WHERE accession_number NOT IN (SELECT accession_number FROM book_issues WHERE status IN ('ISSUED', 'ON DUE', 'OVERDUE'))";
                                            pstmt = conn.prepareStatement(query);
                                            rs = pstmt.executeQuery();
                                            int count = 1;
                                            while (rs.next()) {
                                    %>
                                    <tr>
                                        <td class="serial-number"><%= count++ %></td>
                                        <td class="book-name"><i class="fas fa-book me-2"></i><%= rs.getString("book_name") %></td>
                                        <td><%= rs.getString("edition") %></td>
                                        <td class="author-name"><i class="fas fa-user-pen me-2"></i><%= rs.getString("author") %></td>
                                        <td><i class="fas fa-building me-2"></i><%= rs.getString("publisher") %></td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                        } finally {
                                            try { if (rs != null) rs.close(); } catch (SQLException e) { }
                                            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { }
                                            try { if (conn != null) conn.close(); } catch (SQLException e) { }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.5/js/dataTables.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function() {
            // Initialize Theme
            const themeToggle = document.getElementById('themeToggle');
            const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');
            if (localStorage.getItem('theme') === 'dark' || (!localStorage.getItem('theme') && prefersDarkScheme.matches)) {
                document.documentElement.setAttribute('data-bs-theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            } else {
                document.documentElement.setAttribute('data-bs-theme', 'light');
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
            }
            
            themeToggle.addEventListener('click', function() {
                if (document.documentElement.getAttribute('data-bs-theme') === 'dark') {
                    document.documentElement.setAttribute('data-bs-theme', 'light');
                    themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
                    localStorage.setItem('theme', 'light');
                } else {
                    document.documentElement.setAttribute('data-bs-theme', 'dark');
                    themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
                    localStorage.setItem('theme', 'dark');
                }
            });
            
            // Initialize DataTables
            var table = $('#booksTable').DataTable({
                "pageLength": 100,
                "ordering": true,
                "responsive": true
            });
            
            // Bind custom search input to DataTables
            $('#searchInput').on('keyup', function() {
                table.search(this.value).draw();
            });
        });
    </script>
</body>
</html>