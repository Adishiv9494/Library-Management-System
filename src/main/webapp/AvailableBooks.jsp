<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Ensure the student is logged in
    String rollNo = (String) session.getAttribute("crn");
    if (rollNo == null || rollNo.isEmpty()) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<%! 
    // Enhanced safe string fetcher to cover all possible database column names
    private String getSafeString(ResultSet rs, String[] columnChoices) {
        for(String col : columnChoices) {
            try {
                String val = rs.getString(col);
                if (val != null && !val.trim().isEmpty()) {
                    return val;
                }
            } catch(Exception e) { 
                // Ignore and try the next column name in the array
            }
        }
        return "N/A";
    }
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="lib.png">
    <title>Available Books Collection</title>
     <link rel="icon" type="image/x-icon" href="logo2.jpg">
    
    <!-- CSS Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");

        :root {
            --bs-body-bg: #f4f7f6;
            --bs-body-color: #2c3e50;
            --card-bg: #ffffff;
            --primary-gradient: linear-gradient(135deg, #1cc88a, #13855c);
            --primary-color: #1cc88a; 
            --hover-bg: #f8fcfb;
            --border-color: rgba(0,0,0,0.05);
        }
        
        [data-bs-theme="dark"] {
            --bs-body-bg: #121212;
            --bs-body-color: #e0e0e0;
            --card-bg: #1e1e1e;
            --primary-gradient: linear-gradient(135deg, #10b981, #047857);
            --primary-color: #10b981;
            --hover-bg: #2a2a2a;
            --border-color: rgba(255,255,255,0.05);
        }

        body { 
            font-family: 'Ubuntu', sans-serif; 
            background-color: var(--bs-body-bg); 
            color: var(--bs-body-color); 
            transition: all 0.3s ease; 
        }

        /* Top Header Styling */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 0;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid var(--border-color);
        }

        .back-btn {
            border-radius: 50px;
            padding: 8px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            transform: translateX(-5px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .theme-toggle {
            border-radius: 50%;
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .theme-toggle:hover {
            transform: rotate(20deg) scale(1.1);
        }

        /* Card & Table Styling */
        .custom-card {
            background-color: var(--card-bg);
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .table-custom {
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0 8px;
            padding: 0 15px 15px 15px;
        }

        .table-custom thead th {
            border-bottom: none;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 15px;
        }
        
        .table-custom thead tr {
            background: var(--primary-gradient);
            box-shadow: 0 4px 10px rgba(28, 200, 138, 0.2);
            border-radius: 10px;
        }
        
        /* Make header rounded corners via first/last child */
        .table-custom thead th:first-child { border-top-left-radius: 10px; border-bottom-left-radius: 10px; }
        .table-custom thead th:last-child { border-top-right-radius: 10px; border-bottom-right-radius: 10px; }

        .table-custom tbody tr {
            background-color: var(--card-bg);
            box-shadow: 0 2px 6px var(--border-color);
            border-radius: 8px;
            transition: all 0.2s ease-in-out;
        }

        .table-custom tbody tr:hover {
            transform: translateY(-2px) scale(1.005);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
            background-color: var(--hover-bg);
            z-index: 1;
            position: relative;
        }

        .table-custom td {
            vertical-align: middle;
            border-top: none;
            padding: 16px 15px;
            color: var(--bs-body-color);
        }
        
        .table-custom tbody td:first-child { border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
        .table-custom tbody td:last-child { border-top-right-radius: 8px; border-bottom-right-radius: 8px; }

        .book-icon { color: var(--primary-color); font-size: 1.1rem; margin-right: 10px; }
        .author-icon { color: #f6c23e; font-size: 1.1rem; margin-right: 10px; }
        .edition-icon { color: #36b9cc; font-size: 1.1rem; margin-right: 10px; }

        /* DataTables Controls UI */
        .dataTables_wrapper .dataTables_filter input {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
            border: 2px solid var(--border-color);
            border-radius: 20px;
            padding: 6px 15px;
            outline: none;
            transition: all 0.3s;
        }
        
        .dataTables_wrapper .dataTables_filter input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(28, 200, 138, 0.25);
        }
        
        .dataTables_wrapper .dataTables_length select {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
            border: 2px solid var(--border-color);
            border-radius: 10px;
            padding: 4px 10px;
        }

        .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
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
                <i class="fas fa-layer-group me-2"></i>Library Collection
            </h2>
            <button id="themeToggle" class="btn btn-outline-secondary theme-toggle">
                <i class="fas fa-moon"></i>
            </button>
        </div>

        <!-- Main Content -->
        <div class="row">
            <div class="col-12">
                <div class="custom-card animate__animated animate__slideInUp">
                    <div class="card-body p-4">
                        <div class="table-responsive" style="overflow-x: hidden;">
                            <table class="table table-custom w-100" id="availableBooksTable">
                                <thead>
                                    <tr>
                                        <th>Book Details</th>
                                        <th>Author Name</th>
                                        <th>Edition Info</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection conn = null;
                                        PreparedStatement pstmt = null;
                                        ResultSet rs = null;
                                        
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            // Using exact database credentials
                                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&serverTimezone=UTC", "root", "Adishiv@7318");
                                            
                                            // Ensure query executes without SQL syntax errors
                                            String query = "SELECT * FROM booksdata WHERE accession_no NOT IN (SELECT accession_no FROM book_issues)";
                                            try {
                                                pstmt = conn.prepareStatement(query);
                                                rs = pstmt.executeQuery();
                                            } catch (Exception ex) {
                                                // Fallback if accession_no is named accession_number
                                                query = "SELECT * FROM booksdata WHERE accession_number NOT IN (SELECT accession_number FROM book_issues)";
                                                pstmt = conn.prepareStatement(query);
                                                rs = pstmt.executeQuery();
                                            }
                                            
                                            // Comprehensive Column check lists to fix "N/A"
                                            String[] titleColumns = {"book_name", "title", "book_title", "booktitle", "name", "bookName"};
                                            String[] authorColumns = {"author", "author_name", "writer", "book_author"};
                                            String[] editionColumns = {"edition", "book_edition", "version", "year"};

                                            while (rs.next()) {
                                                String title = getSafeString(rs, titleColumns);
                                                String author = getSafeString(rs, authorColumns);
                                                String edition = getSafeString(rs, editionColumns);
                                    %>
                                                <tr>
                                                    <td class="fw-bold">
                                                        <i class="fas fa-book book-icon"></i> <%= title %>
                                                    </td>
                                                    <td>
                                                        <i class="fas fa-user-edit author-icon"></i> <%= author %>
                                                    </td>
                                                    <td>
                                                        <i class="fas fa-bookmark edition-icon"></i> 
                                                        <span class="badge bg-secondary rounded-pill"><%= edition %></span>
                                                    </td>
                                                </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='3' class='text-danger text-center fw-bold py-4'><i class='fas fa-exclamation-triangle me-2'></i>Error loading library data.</td></tr>");
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

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            // Theme toggle initialization
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

            // Initialize DataTables with customized styling
            $('#availableBooksTable').DataTable({
                responsive: true,
                language: {
                    emptyTable: "<div class='text-center py-4'><i class='fas fa-folder-open fs-1 text-muted mb-3 d-block'></i> No available books currently found in the library.</div>",
                    search: "",
                    searchPlaceholder: "🔍 Search books, authors...",
                    lengthMenu: "Show _MENU_ entries"
                },
                dom: '<"top"<"row w-100"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6 d-flex justify-content-end"f>>>rt<"bottom"<"row w-100 mt-3"<"col-sm-12 col-md-6"i><"col-sm-12 col-md-6 d-flex justify-content-end"p>>>'
            });
        });
    </script>
</body>
</html>