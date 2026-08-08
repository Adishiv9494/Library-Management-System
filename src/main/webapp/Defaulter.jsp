<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
    String adminEmail = (String) session.getAttribute("email");
    if (adminEmail == null || adminEmail.trim().isEmpty()) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <title>Pending Fine & Defaulters</title>
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");
        body { font-family: 'Ubuntu', sans-serif; background-color: #f8f9fa; transition: all 0.3s ease; }
        [data-bs-theme="dark"] body { background-color: #1a1a2e; color: #f8f9fa; }
        .card { border-radius: 15px; border: none; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        [data-bs-theme="dark"] .card { background-color: #16213e; }
        .back-btn { transition: all 0.3s ease; }
        .back-btn:hover { transform: translateX(-3px); }
        .table-light th { background-color: rgba(231, 76, 60, 0.1); color: #e74c3c; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.05em; border-top: none; }
        [data-bs-theme="dark"] .table-light th { background-color: rgba(231, 76, 60, 0.2); }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <button class="btn btn-outline-danger back-btn" onclick="window.location.href='Dashboard.jsp'">
                <i class="fas fa-arrow-left me-2"></i>Dashboard
            </button>
            <h2 class="mb-0 fw-bold" style="color: #e74c3c;">
                <i class="fas fa-exclamation-triangle me-2"></i>Pending Fines & Defaulters
            </h2>
            <div></div>
        </div>

        <div class="card p-4">
            <div class="table-responsive">
                <table id="defaulterTable" class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>S.No.</th>
                            <th>CRN No.</th>
                            <!-- ADDED ACCESSION NO. COLUMN -->
                            <th>Accession No.</th>
                            <th>Student Name</th>
                            <th>Course</th>
                            <th>Book Title</th>
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
                                
                                String query = "SELECT crn, accession_number, student_name, course, book_title, due_date, fine_amount, status FROM book_issues WHERE status IN ('OVERDUE', 'DEFAULTER') ORDER BY due_date ASC";
                                pstmt = conn.prepareStatement(query);
                                rs = pstmt.executeQuery();
                                
                                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
                                long currentTime = System.currentTimeMillis();
                                int count = 1;
                                
                                while (rs.next()) {
                                    Date dueDate = rs.getDate("due_date");
                                    double storedFine = rs.getDouble("fine_amount");
                                    
                                    long dynamicFine = 0;
                                    if (dueDate != null && currentTime > dueDate.getTime()) {
                                        long diffDays = (currentTime - dueDate.getTime()) / (1000 * 60 * 60 * 24);
                                        dynamicFine = diffDays * 10; 
                                    }
                                    
                                    long displayFine = Math.max(dynamicFine, (long)storedFine);
                        %>
                        <tr>
                            <!-- Exactly 8 Columns matching 8 headers -->
                            <td class="text-muted fw-bold"><%= count++ %></td>
                            <td><span class="badge bg-secondary"><%= rs.getString("crn") %></span></td>
                            <!-- Added Accession Number Result -->
                            <td><strong><%= rs.getInt("accession_number") %></strong></td>
                            <td><%= rs.getString("student_name") %></td>
                            <td><%= rs.getString("course") %></td>
                            <td><%= rs.getString("book_title") %></td>
                            <td class="text-danger"><%= dueDate != null ? sdf.format(dueDate) : "N/A" %></td>
                            <td><span class="badge bg-danger fs-6">₹ <%= displayFine %></span></td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                // Handled to prevent DataTables crash
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
            $('#defaulterTable').DataTable({
                "pageLength": 10,
                "ordering": true,
                "info": true,
                "responsive": true
            });
            
            if (localStorage.getItem('theme') === 'dark' || window.matchMedia('(prefers-color-scheme: dark)').matches) { 
                document.documentElement.setAttribute('data-bs-theme', 'dark'); 
            }
        });
    </script>
</body>
</html>