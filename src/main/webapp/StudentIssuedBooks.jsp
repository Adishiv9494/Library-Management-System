<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
    String rollNo = (String) session.getAttribute("crn");
    if (rollNo == null || rollNo.trim().isEmpty()) {
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
    <title>My Issued Books</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");
        
        :root {
            --primary-color: #4e73df; --secondary-color: #858796;
            --success-color: #1cc88a; --danger-color: #e74a3b; --warning-color: #f6c23e;
            --card-bg-light: #ffffff; --card-bg-dark: #16213e;
            --body-bg-light: #f8f9fa; --body-bg-dark: #1a1a2e;
            --table-bg-light: #ffffff; --table-bg-dark: #16213e;
            --table-border-light: #dee2e6; --table-border-dark: #495057;
        }

        [data-bs-theme="dark"] {
            --bs-body-bg: var(--body-bg-dark);
            --card-bg: var(--card-bg-dark);
            --border-color: #2c3e50;
            --table-bg: var(--table-bg-dark);
            --table-border: var(--table-border-dark);
        }

        [data-bs-theme="light"] {
            --bs-body-bg: var(--body-bg-light);
            --card-bg: var(--card-bg-light);
            --border-color: #dee2e6;
            --table-bg: var(--table-bg-light);
            --table-border: var(--table-border-light);
        }

        body { font-family: "Ubuntu", sans-serif; background-color: var(--bs-body-bg); transition: all 0.3s ease; }
        .card { background-color: var(--card-bg); border: none; border-radius: 0.75rem; box-shadow: 0 0.25rem 0.75rem rgba(0, 0, 0, 0.1); margin-bottom: 1rem; }
        .card-body { padding: 1.5rem; }
        .theme-toggle-btn { transition: transform 0.3s; }
        .theme-toggle-btn:hover { transform: rotate(15deg); }
        .table-container { border-radius: 0.75rem; overflow: hidden; margin-top: 1rem; }

        table.dataTable { background-color: var(--table-bg); border-color: var(--table-border) !important; width: 100% !important; margin: 0 !important; }
        table.dataTable thead th { border-bottom-color: var(--table-border) !important; white-space: nowrap; padding: 12px 15px; background-color: rgba(78, 115, 223, 0.1); color: var(--primary-color); }
        table.dataTable tbody td { border-top-color: var(--table-border) !important; padding: 10px 15px; vertical-align: middle; }

        .fine-badge-0 { background-color: rgba(28, 200, 138, 0.2); color: var(--success-color); border: 1px solid var(--success-color); padding: 0.5em 0.75em; border-radius: 0.375rem; font-weight: bold; }
        .fine-badge-penalty { background-color: rgba(231, 74, 59, 0.2); color: var(--danger-color); border: 1px solid var(--danger-color); padding: 0.5em 0.75em; border-radius: 0.375rem; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container-fluid py-3">
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <button class="btn btn-outline-primary" onclick="window.location.href='StudentDashboard.jsp'">
                                <i class="fas fa-arrow-left me-2"></i>Back
                            </button>
                            <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                                <i class="fas fa-book-reader me-2"></i>My Issued Books
                            </h2>
                            <button id="themeToggle" class="btn btn-outline-secondary theme-toggle-btn">
                                <i class="fas fa-moon"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive table-container">
                            <table id="bookIssuesTable" class="table table-hover w-100">
                                <thead>
                                    <tr>
                                        <th>S.No.</th>
                                        <th>Book Name</th>
                                        <th>Edition</th>
                                        <th>Author</th>
                                        <th>Publisher</th>
                                        <th>Due Date</th>
                                        <th>Fine (₹)</th>
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
                                            
                                            // JOIN to get Publisher from booksdata table
                                            String query = "SELECT i.book_title, i.edition, i.author, b.publisher, i.due_date, i.fine_amount " +
                                                           "FROM book_issues i " +
                                                           "LEFT JOIN booksdata b ON i.accession_number = b.accession_number " +
                                                           "WHERE i.crn = ? AND i.status IN ('ISSUED', 'ON DUE', 'OVERDUE') " +
                                                           "ORDER BY i.due_date ASC";
                                            pstmt = conn.prepareStatement(query);
                                            pstmt.setString(1, rollNo);
                                            rs = pstmt.executeQuery();
                                            
                                            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
                                            long currentTime = System.currentTimeMillis();
                                            int count = 1;
                                            
                                            while (rs.next()) {
                                                Date dueDate = rs.getDate("due_date");
                                                double dbFine = rs.getDouble("fine_amount");
                                                
                                                long dynamicFine = 0;
                                                if (dueDate != null && currentTime > dueDate.getTime()) {
                                                    long diffDays = (currentTime - dueDate.getTime()) / (1000 * 60 * 60 * 24);
                                                    dynamicFine = diffDays * 10; 
                                                }
                                                long finalFine = Math.max(dynamicFine, (long)dbFine);
                                                String fineClass = finalFine == 0 ? "fine-badge-0" : "fine-badge-penalty";
                                                String publisher = rs.getString("publisher") != null ? rs.getString("publisher") : "N/A";
                                    %>
                                    <tr>
                                        <td><%= count++ %></td>
                                        <td class="fw-bold"><i class="fas fa-book me-2 text-muted"></i><%= rs.getString("book_title") %></td>
                                        <td><%= rs.getString("edition") %></td>
                                        <td><%= rs.getString("author") %></td>
                                        <td><%= publisher %></td>
                                        <td class="text-danger fw-semibold"><%= dueDate != null ? sdf.format(dueDate) : "N/A" %></td>
                                        <td><span class="<%= fineClass %>">₹ <%= finalFine %></span></td>
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

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

    <script>
    $(document).ready(function() {
        function initTheme() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            $('html').attr('data-bs-theme', savedTheme);
            $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(savedTheme === 'dark' ? 'fa-sun' : 'fa-moon');
        }

        $('#themeToggle').click(function() {
            const currentTheme = $('html').attr('data-bs-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            $('html').attr('data-bs-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(newTheme === 'dark' ? 'fa-sun' : 'fa-moon');
        });

        initTheme();

        $('#bookIssuesTable').DataTable({
            responsive: true,
            scrollX: true,
            language: {
                emptyTable: "You have no actively issued books.",
                search: "_INPUT_",
                searchPlaceholder: "Search records..."
            }
        });
    });
    </script>
</body>
</html>