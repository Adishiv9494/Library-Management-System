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
    <title>All Issued Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container py-4">
        <h2 class="mb-4 text-primary"><i class="fas fa-book-reader me-2"></i>All Issued Books</h2>
        <div class="card shadow-sm p-4">
            <table id="allIssuedTable" class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <!-- 8 HEADERS -->
                        <th>Issue ID</th>
                        <th>CRN</th>
                        <th>Student Name</th>
                        <th>Accession No</th>
                        <th>Book Title</th>
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
                            
                            String query = "SELECT issue_id, crn, student_name, accession_number, book_title, issue_date, due_date, status FROM book_issues ORDER BY issue_date DESC";
                            pstmt = conn.prepareStatement(query);
                            rs = pstmt.executeQuery();
                            
                            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
                            while (rs.next()) {
                                Date issueDate = rs.getDate("issue_date");
                                Date dueDate = rs.getDate("due_date");
                                String status = rs.getString("status");
                                
                                String badgeClass = "bg-warning text-dark"; 
                                if ("RETURNED".equalsIgnoreCase(status)) badgeClass = "bg-success";
                                else if ("OVERDUE".equalsIgnoreCase(status) || "DEFAULTER".equalsIgnoreCase(status)) badgeClass = "bg-danger";
                                else if ("ON DUE".equalsIgnoreCase(status)) badgeClass = "bg-info";
                    %>
                    <tr>
                        <!-- 8 DATA CELLS -->
                        <td>#<%= rs.getInt("issue_id") %></td>
                        <td><%= rs.getString("crn") %></td>
                        <td><%= rs.getString("student_name") %></td>
                        <td><%= rs.getString("accession_number") %></td>
                        <td><%= rs.getString("book_title") %></td>
                        <td><%= issueDate != null ? sdf.format(issueDate) : "N/A" %></td>
                        <td><%= dueDate != null ? sdf.format(dueDate) : "N/A" %></td>
                        <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            // Empty catch for DataTables stability
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception e) {}
                            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                            try { if (conn != null) conn.close(); } catch (Exception e) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.5/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#allIssuedTable').DataTable({
                "pageLength": 10, "ordering": true, "responsive": true
            });
        });
    </script>
</body>
</html>