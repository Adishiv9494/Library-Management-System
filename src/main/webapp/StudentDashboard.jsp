<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
// 1. Set cache control headers to prevent back-button access after logout
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

// 2. Fetch session attributes set by StudentLoginServlet
String fullName = (String) session.getAttribute("full_name");
String email = (String) session.getAttribute("email");
String rollNo = (String) session.getAttribute("crn"); 
String profileImage = (String) session.getAttribute("profile_image");

// 3. STRICT SECURITY CHECK: Redirect to Login if not authenticated
if (rollNo == null || rollNo.trim().isEmpty() || email == null) {
    response.sendRedirect("Login.jsp");
    return;
}

String initials = "S";
if (fullName != null && !fullName.trim().isEmpty()) {
    String[] parts = fullName.trim().split("\\s+");
    initials = parts.length > 1 ? parts[0].substring(0, 1).toUpperCase() + parts[parts.length - 1].substring(0, 1).toUpperCase() : parts[0].substring(0, 1).toUpperCase();
}

int myIssuedCount = 0;
int availableCount = 0;
int ebooksCount = 0;
int downloadEBooksCount = 0;

Connection conn = null;
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://library-db-service-adihpcl9598-1e40.k.aivencloud.com:18683/defaultdb?useSSL=true&requireSSL=true&autoReconnect=true&failOverReadOnly=false&serverTimezone=UTC", "avnadmin", "AVNS_M_y84BDpUY38oAAS0w1");
    
    // Count 1: Issued Books (EXCLUDING RETURNED)
    try {
        try (PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM book_issues WHERE crn = ? AND status = 'Issued'")) {
            ps1.setString(1, rollNo);
            try (ResultSet rs1 = ps1.executeQuery()) { if (rs1.next()) myIssuedCount = rs1.getInt(1); }
        }
    } catch(Exception e) {
        // Fallback if status column doesn't exist or is named differently
        try (PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM book_issues WHERE crn = ? AND return_date IS NULL")) {
            ps1.setString(1, rollNo);
            try (ResultSet rs1 = ps1.executeQuery()) { if (rs1.next()) myIssuedCount = rs1.getInt(1); }
        } catch(Exception ex) {}
    }
    
    // Count 2: Available Books Count
    try {
        try (PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM booksdata WHERE accession_number NOT IN (SELECT accession_number FROM book_issues WHERE status = 'Issued')");
             ResultSet rs2 = ps2.executeQuery()) {
            if (rs2.next()) availableCount = rs2.getInt(1);
        }
    } catch (Exception e1) { }
    
    // Count 3: Total E-Books 
    try {
        String createTableSQL = "CREATE TABLE IF NOT EXISTS ebooks (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255) NOT NULL, author VARCHAR(255) NOT NULL, edition VARCHAR(100), description TEXT, pdf_url VARCHAR(500) NOT NULL, uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
        try (Statement stmt = conn.createStatement()) { stmt.execute(createTableSQL); }
        
        try (PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM ebooks")) {
            try (ResultSet rs3 = ps3.executeQuery()) { if (rs3.next()) ebooksCount = rs3.getInt(1); }
        }
    } catch(Exception e) { }
    
    // Count 4: Downloaded E-Books
    try {
        String createTableSQL = "CREATE TABLE IF NOT EXISTS downloaded_ebooks (id INT AUTO_INCREMENT PRIMARY KEY, crn VARCHAR(50), ebook_id INT, title VARCHAR(255), author VARCHAR(255), pdf_url VARCHAR(500), downloaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
        try (Statement stmt = conn.createStatement()) { stmt.execute(createTableSQL); }

        try (PreparedStatement ps4 = conn.prepareStatement("SELECT COUNT(*) FROM downloaded_ebooks WHERE crn = ?")) {
            ps4.setString(1, rollNo);
            try (ResultSet rs4 = ps4.executeQuery()) { if (rs4.next()) downloadEBooksCount = rs4.getInt(1); }
        }
    } catch(Exception e) { }

} catch(Exception e) {
} finally {
    try { if (conn != null) conn.close(); } catch(SQLException e) {}
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Student Dashboard</title>
    
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");
        
        * { font-family: "Ubuntu", sans-serif; margin: 0; padding: 0; box-sizing: border-box; }
        :root { --blue: #2a2185; --white: #fff; --gray: #f5f5f5; --black1: #222; --black2: #999; --dark-bg: #1e1e1e; --dark-bg-card: #333; }
        body { min-height: 100vh; overflow-x: hidden; background: var(--gray); transition: background 0.3s ease; }
        .container { position: relative; width: 100%; }

        /* Navigation Sidebar */
        .navigation { position: fixed; width: 300px; height: 100%; background: var(--blue); border-left: 10px solid var(--blue); transition: 0.5s; overflow: hidden; display: flex; flex-direction: column; justify-content: space-between; }
        .navigation.active { width: 80px; }
        .navigation ul { width: 100%; flex-grow: 1; overflow-y: auto; overflow-x: hidden; padding-bottom: 10px; }
        .navigation ul::-webkit-scrollbar { width: 5px; }
        .navigation ul::-webkit-scrollbar-track { background: var(--blue); }
        .navigation ul::-webkit-scrollbar-thumb { background: rgba(255, 255, 255, 0.2); border-radius: 10px; }
        .navigation ul li { position: relative; width: 100%; list-style: none; border-top-left-radius: 30px; border-bottom-left-radius: 30px; }
        .navigation ul li:hover, .navigation ul li.hovered { background-color: var(--white); }
        .navigation ul li:nth-child(1) { margin-bottom: 40px; pointer-events: none; }
        .navigation ul li a { position: relative; display: block; width: 100%; display: flex; text-decoration: none; color: var(--white); }
        .navigation ul li:hover a, .navigation ul li.hovered a { color: var(--blue); }
        .navigation ul li a .icon { position: relative; display: block; min-width: 60px; height: 60px; line-height: 75px; text-align: center; }
        .navigation ul li a .icon ion-icon { font-size: 1.75rem; }
        .navigation ul li a .title { position: relative; display: block; padding: 0 10px; height: 60px; line-height: 60px; text-align: start; white-space: nowrap; }
        .navigation ul li:hover a::before, .navigation ul li.hovered a::before { content: ""; position: absolute; right: 0; top: -50px; width: 50px; height: 50px; background-color: transparent; border-radius: 50%; box-shadow: 35px 35px 0 10px var(--gray); pointer-events: none; }
        .navigation ul li:hover a::after, .navigation ul li.hovered a::after { content: ""; position: absolute; right: 0; bottom: -50px; width: 50px; height: 50px; background-color: transparent; border-radius: 50%; box-shadow: 35px -35px 0 10px var(--gray); pointer-events: none; }

        .sidebar-profile { padding: 20px 10px; background: rgba(0, 0, 0, 0.15); border-top-left-radius: 20px; display: flex; flex-direction: column; align-items: center; color: var(--white); text-align: center; transition: 0.5s; margin-top: auto; flex-shrink: 0; }
        .navigation.active .sidebar-profile { padding: 20px 0; background: transparent; }
        .sidebar-profile .user-img { width: 70px; height: 70px; border-radius: 50%; background: var(--white); color: var(--blue); display: flex; align-items: center; justify-content: center; font-size: 26px; font-weight: bold; margin-bottom: 12px; overflow: hidden; border: 3px solid rgba(255, 255, 255, 0.4); }
        .sidebar-profile .user-img img { width: 100%; height: 100%; object-fit: cover; }
        .navigation.active .sidebar-profile .user-img { width: 45px; height: 45px; font-size: 18px; }
        .profile-info { margin-bottom: 15px; width: 100%; }
        .navigation.active .profile-info { display: none; }
        .profile-info h4 { font-size: 1.1rem; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; padding: 0 10px; }
        .profile-info p { font-size: 0.85rem; color: #d1d8e0; white-space: nowrap; }
        .logout-btn { width: 85%; padding: 10px; background: #ff4757; color: white; text-decoration: none; border-radius: 8px; font-weight: 500; display: flex; align-items: center; justify-content: center; gap: 8px; transition: 0.3s; }
        .logout-btn:hover { background: #ff6b81; transform: translateY(-2px); }
        .navigation.active .logout-btn { width: 45px; height: 45px; padding: 0; border-radius: 50%; }
        .navigation.active .logout-btn span { display: none; }
        .navigation.active .logout-btn ion-icon { font-size: 1.2rem; margin: 0; }

        .main { position: absolute; width: calc(100% - 300px); left: 300px; min-height: 100vh; background: transparent; transition: 0.5s; }
        .main.active { width: calc(100% - 80px); left: 80px; }
        .topbar { width: 100%; height: 70px; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; background: var(--white); box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .toggle { position: relative; width: 60px; height: 60px; display: flex; justify-content: center; align-items: center; font-size: 2.5rem; cursor: pointer; color: var(--black1); }

        #mode-toggle { background: linear-gradient(115deg, #0a0a0a, #4e54c8); border: 2px solid rgba(255, 165, 0, 0.6); color: #ff6600; border-radius: 50%; font-size: 20px; cursor: pointer; transition: all 0.3s ease; box-shadow: 0px 5px 15px rgba(255, 165, 0, 0.5); display: flex; align-items: center; justify-content: center; width: 45px; height: 45px; }
        #mode-toggle:hover { transform: scale(1.1); }

        .cardBox { position: relative; width: 100%; padding: 20px; display: grid; grid-template-columns: repeat(4, 1fr); grid-gap: 30px; }
        .cardBox .card { position: relative; background: var(--white); padding: 30px; border-radius: 20px; display: flex; justify-content: space-between; cursor: pointer; box-shadow: 0 7px 25px rgba(0, 0, 0, 0.08); transition: background 0.3s, transform 0.3s; }
        .cardBox .card .numbers { position: relative; font-weight: 500; font-size: 2.5rem; color: var(--red2); }
        .cardBox .card .cardName { color: var(--black2); font-size: 1.1rem; margin-top: 5px; }
        .cardBox .card .iconBx { font-size: 3.5rem; color: var(--black2); transition: color 0.3s; }
        .cardBox .card:hover { background: var(--blue); transform: translateY(-5px); }
        .cardBox .card:hover .numbers, .cardBox .card:hover .cardName, .cardBox .card:hover .iconBx { color: var(--white); }

        .gallery-container { width: 100%; max-width: 1000px; margin: 30px auto; padding: 20px; position: relative; overflow: hidden; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); background: var(--white); }
        .gallery-title { text-align: center; margin-bottom: 20px; font-size: 2rem; color: var(--blue); position: relative; }
        .gallery-title::after { content: ''; position: absolute; bottom: -10px; left: 50%; transform: translateX(-50%); width: 100px; height: 3px; background: var(--blue); }
        .single-slide { width: 100%; height: 400px; position: relative; overflow: hidden; border-radius: 10px; }
        .single-slide img { width: 100%; height: 100%; object-fit: cover; position: absolute; top: 0; left: 0; opacity: 0; transition: opacity 1s ease-in-out; border-radius: 10px; }
        .single-slide img.active { opacity: 1; }
        .slider-controls { position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); display: flex; gap: 10px; z-index: 10; }
        .slider-controls .dot { width: 12px; height: 12px; border-radius: 50%; background: rgba(255,255,255,0.5); cursor: pointer; transition: all 0.3s; }
        .slider-controls .dot.active { background: var(--blue); transform: scale(1.2); }

        body.dark-mode { background: #121212; color: white; }
        body.dark-mode .navigation { background-color: var(--dark-bg); border-left-color: var(--dark-bg); }
        body.dark-mode .navigation ul::-webkit-scrollbar-track { background: var(--dark-bg); }
        body.dark-mode .main { background: transparent; }
        body.dark-mode .topbar { background: transparent; box-shadow: none; }
        body.dark-mode .toggle { color: var(--white); }
        body.dark-mode .card { background-color: var(--dark-bg-card); box-shadow: 0 7px 25px rgba(0, 0, 0, 0.5); }
        body.dark-mode .card .cardName, body.dark-mode .card .iconBx { color: #bbb; }
        body.dark-mode .gallery-container { background: var(--dark-bg-card); box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        body.dark-mode .gallery-title { color: #fff; }
        body.dark-mode .gallery-title::after { background: #fff; }
        body.dark-mode .navigation ul li:hover a::before, body.dark-mode .navigation ul li.hovered a::before { box-shadow: 35px 35px 0 10px #121212; }
        body.dark-mode .navigation ul li:hover a::after, body.dark-mode .navigation ul li.hovered a::after { box-shadow: 35px -35px 0 10px #121212; }
        body.dark-mode #mode-toggle { background: rgba(255, 255, 255, 0.1); color: white; border-color: white; box-shadow: none;}

        @media (max-width: 991px) { .navigation { left: -300px; } .navigation.active { width: 300px; left: 0; } .main { width: 100%; left: 0; } .main.active { left: 300px; } .cardBox { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 768px) { .single-slide { height: 300px; } }
        @media (max-width: 480px) { .cardBox { grid-template-columns: repeat(1, 1fr); } .navigation { width: 100%; left: -100%; z-index: 1000; } .navigation.active { width: 100%; left: 0; } .toggle { z-index: 10001; } .main.active .toggle { color: #fff; position: fixed; right: 0; left: initial; } .single-slide { height: 200px; } .gallery-title { font-size: 1.5rem; } .slider-controls .dot { width: 10px; height: 10px; } }
    </style>
</head>
<body>
    <div class="container animate__animated animate__fadeIn">
        <div class="navigation">
            <ul>
                <li>
                    <a href="#">
                        <span class="icon" style="display: flex; align-items: center; justify-content: center; height: 60px;">
                            <img src="logo2.jpg" alt="Logo" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover; box-shadow: 0 2px 10px rgba(0,0,0,0.2);">
                        </span>
                        <span class="title">Library Management</span>
                    </a>
                </li>
                <li><a href="StudentDashboard.jsp"><span class="icon"><ion-icon name="home-outline"></ion-icon></span><span class="title">Home</span></a></li>
                <li><a href="StudentIssuedBooks.jsp"><span class="icon"><ion-icon name="book-outline"></ion-icon></span><span class="title">Issued Books</span></a></li>
                <li><a href="AvailableBooks.jsp"><span class="icon"><ion-icon name="file-tray-full-outline"></ion-icon></span><span class="title">Available Books</span></a></li>
                <li><a href="ViewEBooks.jsp"><span class="icon"><ion-icon name="desktop-outline"></ion-icon></span><span class="title">View E-Books</span></a></li>
                <li><a href="DownloadEBooks.jsp"><span class="icon"><ion-icon name="download-outline"></ion-icon></span><span class="title">Downloads E-books</span></a></li>
            </ul>

            <div class="sidebar-profile">
                <div class="user-img">
                    <% if (profileImage != null && !profileImage.isEmpty()) { %>
                        <img src="data:image/jpeg;base64,<%= profileImage %>" alt="Profile Picture">
                    <% } else { %>
                        <%= initials %>
                    <% } %>
                </div>
                <div class="profile-info">
                    <h4><%= fullName %></h4>
                    <p>Roll No: <%= rollNo %></p>
                </div>
                <a href="StudentLogoutServlet" class="logout-btn">
                    <ion-icon name="log-out-outline"></ion-icon>
                    <span>Logout</span>
                </a>
            </div>
        </div>

        <div class="main">
            <div class="topbar">
                <div class="toggle"><ion-icon name="menu-outline"></ion-icon></div>
                <button id="mode-toggle" title="Toggle Theme">🌙</button>
            </div>

            <div class="cardBox">
                <div class="card" onclick="window.location.href='StudentIssuedBooks.jsp'">
                    <div>
                        <div class="numbers"><%= myIssuedCount %></div>
                        <div class="cardName">My Issued Books</div>
                    </div>
                    <div class="iconBx"><ion-icon name="book-outline"></ion-icon></div>
                </div>

                <div class="card" onclick="window.location.href='AvailableBooks.jsp'">
                    <div>
                        <div class="numbers"><%= availableCount %></div>
                        <div class="cardName">Available Books</div>
                    </div>
                    <div class="iconBx"><ion-icon name="file-tray-full-outline"></ion-icon></div>
                </div>
                                
                <div class="card" onclick="window.location.href='ViewEBooks.jsp'">
                    <div>
                        <div class="numbers" id="eBooksCount"><%= ebooksCount %></div>
                        <div class="cardName">Total E-Books</div>
                    </div>
                    <div class="iconBx"><ion-icon name="desktop-outline"></ion-icon></div>
                </div>

                <div class="card" onclick="window.location.href='DownloadEBooks.jsp'">
                    <div>
                        <div class="numbers"><%= downloadEBooksCount %></div>
                        <div class="cardName">My Downloads</div>
                    </div>
                    <div class="iconBx"><ion-icon name="download-outline"></ion-icon></div>
                </div>
            </div>
            
            <div class="gallery-container">
                <h2 class="gallery-title">Our Library Gallery</h2>
                <div class="single-slide">
                    <img src="library_01.jpg" alt="Library Image 1" class="active">
                    <img src="library_05.jpg" alt="Library Image 5">
                    <img src="library_07.jpg" alt="Library Image 7">
                    <img src="library_02.jpg" alt="Library Image 2">
                    <img src="library_03.jpg" alt="Library Image 3">
                    <img src="library_04.jpg" alt="Library Image 4">
                    <img src="library_09.jpg" alt="Library Image 9">
                    <img src="library_08.jpg" alt="Library Image 8">
                </div>
                <div class="slider-controls" id="slider-controls"></div>
            </div>

            <script>
            document.addEventListener("DOMContentLoaded", () => {
                const modeToggle = document.getElementById("mode-toggle");
                const body = document.body;
                if (localStorage.getItem("theme") === "dark") { body.classList.add("dark-mode"); modeToggle.innerHTML = "☀"; } else { body.classList.remove("dark-mode"); modeToggle.innerHTML = "🌙"; }
                modeToggle.addEventListener("click", () => {
                    body.classList.toggle("dark-mode");
                    if (body.classList.contains("dark-mode")) { modeToggle.innerHTML = "☀"; localStorage.setItem("theme", "dark"); } else { modeToggle.innerHTML = "🌙"; localStorage.setItem("theme", "light"); }
                });

                const toggle = document.querySelector(".toggle");
                const navigation = document.querySelector(".navigation");
                const main = document.querySelector(".main");
                if (toggle && navigation && main) { toggle.onclick = function() { navigation.classList.toggle("active"); main.classList.toggle("active"); }; }
                
                const galleryContainer = document.querySelector('.single-slide');
                if (galleryContainer) {
                    const images = galleryContainer.querySelectorAll('img');
                    const sliderControls = document.getElementById('slider-controls');
                    let currentIndex = 0; let autoSlideInterval;
                    if (sliderControls) { images.forEach((_, index) => { const dot = document.createElement('div'); dot.classList.add('dot'); if (index === 0) dot.classList.add('active'); dot.addEventListener('click', () => goToSlide(index)); sliderControls.appendChild(dot); }); }
                    const dots = sliderControls ? sliderControls.querySelectorAll('.dot') : [];
                    function goToSlide(index) { images[currentIndex].classList.remove('active'); if (dots.length > 0) dots[currentIndex].classList.remove('active'); currentIndex = index; images[currentIndex].classList.add('active'); if (dots.length > 0) dots[currentIndex].classList.add('active'); resetAutoSlide(); }
                    function nextSlide() { goToSlide((currentIndex + 1) % images.length); }
                    function startAutoSlide() { autoSlideInterval = setInterval(nextSlide, 3000); }
                    function resetAutoSlide() { clearInterval(autoSlideInterval); startAutoSlide(); }
                    function initGallery() { images[0].classList.add('active'); if (dots.length > 0) dots[0].classList.add('active'); startAutoSlide(); galleryContainer.addEventListener('mouseenter', () => clearInterval(autoSlideInterval)); galleryContainer.addEventListener('mouseleave', startAutoSlide); }
                    initGallery();
                }
            });
            </script>
            <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
            <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        </div>
    </div>
</body>
</html>
