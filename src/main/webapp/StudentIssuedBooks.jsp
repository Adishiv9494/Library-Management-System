<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String rollNo = (String) session.getAttribute("crn");
    if (rollNo == null || rollNo.isEmpty()) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<%! 
    // Helper to gracefully fallback on column names without crashing the UI
    private String getSafeString(ResultSet rs, String[] columnChoices) {
        for(String col : columnChoices) {
            try {
                String val = rs.getString(col);
                if (val != null) return val;
            } catch(Exception e) { /* try next */ }
        }
        return "N/A";
    }
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>My Issued Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <style>
        :root {
            --bs-body-bg: #f8f9fa;
            --bs-body-color: #212529;
            --card-bg: #ffffff;
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --danger-color: #e74a3b;
            --warning-color: #f6c23e;
            --info-color: #36b9cc;
        }
        [data-bs-theme="dark"] {
            --bs-body-bg: #1a1a2e;
            --bs-body-color: #f8f9fa;
            --card-bg: #16213e;
            --primary-color: #5a67d8;
            --secondary-color: #a0aec0;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --info-color: #3b82f6;
        }
        body { background-color: var(--bs-body-bg); color: var(--bs-body-color); transition: all 0.3s ease; }
        .card { background-color: var(--card-bg); border: none; border-radius: 0.5rem; box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15); }
        .back-btn:hover { transform: translateX(-3px); transition: all 0.3s; }
        .theme-toggle:hover { transform: rotate(15deg); transition: all 0.3s; }
        .table { background-color: var(--card-bg); color: var(--bs-body-color); }
        .table th { border-bottom-width: 1px; border-top: none; background-color: rgba(78, 115, 223, 0.1); color: var(--primary-color); font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; }
        .table td { vertical-align: middle; border-top: 1px solid rgba(0, 0, 0, 0.05); }
        .status-badge { padding: 0.35em 0.65em; border-radius: 0.25rem; font-weight: 600; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; display: inline-block; min-width: 80px; text-align: center; }
        .status-issued { background-color: var(--success-color); color: white; }
        .dataTables_wrapper .dataTables_filter input { background-color: var(--card-bg); color: var(--bs-body-color); border: 1px solid rgba(0,0,0,0.1); border-radius: 0.35rem; padding: 0.375rem 0.75rem; }
        .dataTables_wrapper .dataTables_length select { background-color: var(--card-bg); color: var(--bs-body-color); border: 1px solid rgba(0,0,0,0.1); border-radius: 0.35rem; }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary back-btn" onclick="window.location.href='StudentDashboard.jsp'">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                        <i class="fas fa-book-open me-2"></i>My Issued Books
                    </h2>
                    <div class="d-flex gap-2">
                        <button id="themeToggle" class="btn btn-outline-secondary theme-toggle"><i class="fas fa-moon"></i></button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            <table class="table table-hover w-100" id="bookIssuesTable">
                                <thead>
                                    <tr>
                                        <th>Accession No.</th>
                                        <th>Book Title</th>
                                        <th>Author</th>
                                        <th>Edition</th>
                                        <th>Issue Date</th>
                                        <th>Due Date</th>
                                        
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection conn = null;
                                        PreparedStatement pstmt = null;
                                        ResultSet rs = null;
                                        
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&serverTimezone=UTC", "root", "Adishiv@7318");
                                            
                                            // Fallback Query Logic to completely avoid 'Unknown Column'
                                            String query = "SELECT * FROM book_issues i JOIN booksdata b ON i.accession_no = b.accession_no WHERE i.crn = ?";
                                            try {
                                                pstmt = conn.prepareStatement(query);
                                                pstmt.setString(1, rollNo);
                                                rs = pstmt.executeQuery();
                                            } catch (Exception ex) {
                                                query = "SELECT * FROM book_issues i JOIN booksdata b ON i.accession_number = b.accession_number WHERE i.crn = ?";
                                                pstmt = conn.prepareStatement(query);
                                                pstmt.setString(1, rollNo);
                                                rs = pstmt.executeQuery();
                                            }
                                            
                                            while (rs.next()) {
                                                String accNo = getSafeString(rs, new String[]{"accession_no", "accession_number"});
                                                String title = getSafeString(rs, new String[]{"book_title", "title", "bookName"});
                                                String author = getSafeString(rs, new String[]{"author", "author_name"});
                                                String edition = getSafeString(rs, new String[]{"edition"});
                                                String issueDate = getSafeString(rs, new String[]{"issue_date"});
                                                String dueDate = getSafeString(rs, new String[]{"due_date"});
                                    %>
                                                <tr>
                                                    <td><%= accNo %></td>
                                                    <td class="fw-bold"><%= title %></td>
                                                    <td><%= author %></td>
                                                    <td><%= edition %></td>
                                                    <td><%= issueDate %></td>
                                                    <td><%= dueDate %></td>
                                                    
                                                </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='7' class='text-danger text-center'>Error connecting to database. Please notify admin.</td></tr>");
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

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            // Theme toggle initialization
            const themeToggle = document.getElementById('themeToggle');
            if (localStorage.getItem('theme') === 'dark') {
                document.documentElement.setAttribute('data-bs-theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
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

            // Initialize DataTables statically
            $('#bookIssuesTable').DataTable({
                responsive: true,
                language: {
                    emptyTable: "You currently have no issued books.",
                    search: "_INPUT_",
                    searchPlaceholder: "Search your books...",
                    lengthMenu: "Show _MENU_ entries"
                },
                dom: '<"top"<"d-flex justify-content-between align-items-center"lf>>rt<"bottom"<"d-flex justify-content-between align-items-center"ip>>'
            });
        });
    </script>
</body>
</html>