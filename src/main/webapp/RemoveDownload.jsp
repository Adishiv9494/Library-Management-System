<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String rollNo = (String) session.getAttribute("crn");
    String recordId = request.getParameter("id");
    
    // Security check: Must have session and pass the ID
    if (rollNo == null || recordId == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"status\":\"error\", \"message\":\"Unauthorized request.\"}");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&serverTimezone=UTC", "root", "Adishiv@7318");
        
        // Delete exactly this record, strictly ensuring it belongs to the logged in student
        String query = "DELETE FROM downloaded_ebooks WHERE id = ? AND crn = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, recordId);
        pstmt.setString(2, rollNo);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"error\", \"message\":\"Record not found or already deleted.\"}");
        }
        
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("{\"status\":\"error\", \"message\":\"Database Error.\"}");
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { }
        try { if (conn != null) conn.close(); } catch (SQLException e) { }
    }
%>