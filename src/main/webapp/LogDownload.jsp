<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String crn = (String) session.getAttribute("crn");
    if (crn == null || crn.trim().isEmpty()) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        return;
    }

    String ebookIdStr = request.getParameter("ebookId");
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String pdfUrl = request.getParameter("pdfUrl");
    
    if (ebookIdStr == null || ebookIdStr.trim().isEmpty() || ebookIdStr.equals("null")) {
        out.print("error");
        return;
    }
    
    int ebookId = Integer.parseInt(ebookIdStr);

    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC", "avnadmin", "AVNS_M_y84BDpUY38oAAS0w1");

        // 1. Check if the student has already downloaded this specific E-Book
        String checkSql = "SELECT id FROM downloaded_ebooks WHERE crn = ? AND ebook_id = ?";
        try(PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setString(1, crn);
            checkPs.setInt(2, ebookId);
            try(ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    // Book is already downloaded! Return "exists" and stop processing.
                    out.print("exists");
                    return; 
                }
            }
        }

        // 2. If not found, insert the new download record
        String sql = "INSERT INTO downloaded_ebooks (crn, ebook_id, title, author, pdf_url, download_date) VALUES (?, ?, ?, ?, ?, NOW())";
        try(PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, crn);
            ps.setInt(2, ebookId);
            ps.setString(3, title);
            ps.setString(4, author);
            ps.setString(5, pdfUrl);
            ps.executeUpdate();
        }
        out.print("success");
        
    } catch(Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("error");
    } finally {
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>