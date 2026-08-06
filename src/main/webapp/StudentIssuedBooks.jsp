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
    <title>My Issued Books</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");
        body { font-family: 'Ubuntu', sans-serif; background-color: #f4f7f6; transition: all 0.3s ease; }
        [data-bs-theme="dark"] body { background-color: #121212; color: #e0e0e0; }
        
        .page-header { display: flex; justify-content: space-between; align-items: center; padding: 1.5rem 0; margin-bottom: 1.5rem; border-bottom: 2px solid rgba(0,0,0,0.05); }
        .back-btn { border-radius: 50px; padding: 8px 20px; font-weight: 500; transition: all 0.3s ease; }
        .card { border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); border: none; overflow: hidden; }
        [data-bs-theme="dark"] .card { background-color: #1e1e1e; box-shadow: 0 5px 15px rgba(0,0,0,0.5); }
        .table-responsive { padding: 20px; }
        .badge-issued { background-color: #f59e0b; color: white; padding: 5px 10px; border-radius: 5px; }
        .badge-returned { background-color: #10b981; color: white; padding: 5px 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container py-4 animate__animated animate__fadeIn">
        <div class="page-header">
            <button class="btn btn-outline-secondary back-btn" onclick="window.location.href='StudentDashboard.jsp'">
                <i class="fas fa-arrow-left me-2"></i>Dashboard
            </button>
            <h2 class="mb-0 fw-bold" style="color: #4e73df;">
                <i class="fas fa-book-reader me-2"></i>My Issued Books
            </h2>
            <div></div> <!-- Spacer -->
        </div>

        <div class="card animate__animated animate__slideInUp">
            <div class="table-responsive">
                <!-- EXACTLY 6 COLUMNS DEFINED HERE -->
                <table id="bookIssuesTable" class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Issue ID</th>
                            <th>Accession No</th>
                            <th>Book Name</th>
                            <th>Issue Date</th>
                            <th>Due Date</th>
                            <th>Status</th>
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
                                
                                // Querying your issues
                                String query = "SELECT i.issue_id, i.accession_number, b.book_title, i.issue_date, i.due_date, i.status FROM book_issues i LEFT JOIN booksdata b ON i.accession_number = b.accession_number WHERE i.crn = ? ORDER BY i.issue_date DESC";
                                pstmt = conn.prepareStatement(query);
                                pstmt.setString(1, rollNo);
                                rs = pstmt.executeQuery();
                                
                                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
                                
                                while (rs.next()) {
                                    String status = rs.getString("status");
                                    if(status == null || status.trim().isEmpty()) status = "Issued";
                                    String badgeClass = status.equalsIgnoreCase("Returned") ? "badge-returned" : "badge-issued";
                                    String bookTitle = rs.getString("book_title") != null ? rs.getString("book_title") : "Unknown Book";
                                    
                                    Date issueDate = rs.getDate("issue_date");
                                    Date dueDate = rs.getDate("due_date");
                                    
                                    // EXACTLY 6 TDs HERE TO PREVENT DATATABLES CRASH
                        %>
                        <tr>
                            <td><strong>#<%= rs.getString("issue_id") %></strong></td>
                            <td><%= rs.getString("accession_number") %></td>
                            <td><%= bookTitle %></td>
                            <td><%= issueDate != null ? sdf.format(issueDate) : "N/A" %></td>
                            <td><%= dueDate != null ? sdf.format(dueDate) : "N/A" %></td>
                            <td><span class="<%= badgeClass %>"><%= status %></span></td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='6' class='text-danger text-center'>Error loading your issued books.</td></tr>");
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

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.5/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#bookIssuesTable').DataTable({
                "pageLength": 10,
                "ordering": true,
                "info": true,
                "responsive": true
            });
            if (localStorage.getItem('theme') === 'dark') { document.documentElement.setAttribute('data-bs-theme', 'dark'); }
        });
    </script>
</body>
</html>
