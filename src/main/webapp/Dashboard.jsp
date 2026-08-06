<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.sql.*" %>
<%
// Set cache control headers
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

// Get user details from session
String username = (String) session.getAttribute("username");
String email = (String) session.getAttribute("email");
String firstName = (String) session.getAttribute("first_name");
String lastName = (String) session.getAttribute("last_name");
String contactNumber = (String) session.getAttribute("contact_number");
String profileImage = (String) session.getAttribute("profile_image");
String address = (String) session.getAttribute("address");

String fullName = "";
if (firstName != null && lastName != null) {
    fullName = firstName + " " + lastName;
} else if (firstName != null) {
    fullName = firstName;
} else if (lastName != null) {
    fullName = lastName;
} else if (username != null) {
    fullName = username;
}

if (email == null) {
    response.sendRedirect("welcome.jsp");
    return;
}

String initials = "";
if (firstName != null && !firstName.isEmpty() && lastName != null && !lastName.isEmpty()) {
    initials = firstName.substring(0, 1).toUpperCase() + lastName.substring(0, 1).toUpperCase();
} else if (username != null && !username.isEmpty()) {
    initials = username.substring(0, 1).toUpperCase();
}

if (email == null || contactNumber == null || profileImage == null || address == null) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "Adishiv@7318");
        
        String query = "SELECT email, first_name, last_name, contact_number, profile_image, address FROM lib_loginsignup WHERE email = ?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            email = rs.getString("email");
            firstName = rs.getString("first_name");
            lastName = rs.getString("last_name");
            contactNumber = rs.getString("contact_number");
            address = rs.getString("address");
            
            byte[] imageBytes = rs.getBytes("profile_image");
            if (imageBytes != null && imageBytes.length > 0) {
                profileImage = Base64.getEncoder().encodeToString(imageBytes);
                session.setAttribute("profile_image", profileImage);
            }
            
            session.setAttribute("email", email);
            session.setAttribute("first_name", firstName);
            session.setAttribute("last_name", lastName);
            session.setAttribute("contact_number", contactNumber);
            session.setAttribute("address", address);
        }
        
        rs.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
   
    <link rel="icon" type="image/x-icon" href="lib.png">
    <title>Admin Dashboard</title>
    
   <style>
        @import url("https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap");
        
        * { font-family: "Ubuntu", sans-serif; margin: 0; padding: 0; box-sizing: border-box; }
        :root { --blue: #2a2185; --white: #fff; --gray: #f5f5f5; --black1: #222; --black2: #999; }
        body { min-height: 100vh; overflow-x: hidden; background: var(--gray); transition: background 0.3s ease; }
        .container { position: relative; width: 100%; }
        
        /* Navigation Styles */
        .navigation { 
            position: fixed; width: 300px; height: 100%; background: var(--blue); 
            border-left: 10px solid var(--blue); transition: 0.5s; overflow: hidden; 
            display: flex; flex-direction: column; justify-content: space-between; 
        }
        .navigation.active { width: 80px; }
        
        /* Custom scrollbar for menu */
        .navigation ul { 
            width: 100%; flex-grow: 1; overflow-y: auto; overflow-x: hidden; padding-bottom: 10px;
        }
        .navigation ul::-webkit-scrollbar { width: 5px; }
        .navigation ul::-webkit-scrollbar-track { background: var(--blue); }
        .navigation ul::-webkit-scrollbar-thumb { background: rgba(255, 255, 255, 0.2); border-radius: 10px; }
        .navigation ul::-webkit-scrollbar-thumb:hover { background: rgba(255, 255, 255, 0.4); }
        
        .navigation ul li { position: relative; width: 100%; list-style: none; border-top-left-radius: 30px; border-bottom-left-radius: 30px; }
        .navigation ul li:hover, .navigation ul li.hovered { background-color: var(--white); }
        .navigation ul li:nth-child(1) { margin-bottom: 40px; pointer-events: none; }
        .navigation ul li a { position: relative; display: block; width: 100%; display: flex; text-decoration: none; color: var(--white); }
        .navigation ul li:hover a, .navigation ul li.hovered a { color: var(--blue); }
        .navigation ul li a .icon { position: relative; display: block; min-width: 60px; height: 60px; line-height: 75px; text-align: center; }
        .navigation ul li a .icon ion-icon { font-size: 1.75rem; }
        .navigation ul li a .title { position: relative; display: block; padding: 0 10px; height: 60px; line-height: 60px; text-align: start; white-space: nowrap; }
        
        .navigation ul li:hover a::before, .navigation ul li.hovered a::before { content: ""; position: absolute; right: 0; top: -50px; width: 50px; height: 50px; background-color: transparent; border-radius: 50%; box-shadow: 35px 35px 0 10px var(--white); pointer-events: none; }
        .navigation ul li:hover a::after, .navigation ul li.hovered a::after { content: ""; position: absolute; right: 0; bottom: -50px; width: 50px; height: 50px; background-color: transparent; border-radius: 50%; box-shadow: 35px -35px 0 10px var(--white); pointer-events: none; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        /* ===== SIDEBAR BOTTOM WIDGET ===== */
        .sidebar-widget {
            margin: 5px;
            padding: 12px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: var(--white);
            transition: all 0.4s ease;
            overflow: hidden;
            flex-shrink: 0;
        }

        body.dark-mode .sidebar-widget {
            background: rgba(0, 0, 0, 0.2);
            border-color: rgba(255, 255, 255, 0.05);
        }

        .widget-profile-info {
            display: flex;
            align-items: center;
            gap: 12px;
            overflow: hidden;
        }

        .widget-user-img {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            background: var(--white);
            color: var(--blue);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: bold;
            overflow: hidden;
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .widget-user-img img { width: 100%; height: 100%; object-fit: cover; }

        .widget-text { display: flex; flex-direction: column; overflow: hidden; white-space: nowrap; max-width: 120px; }
        .widget-text h4 { font-size: 0.95rem; color: var(--white); margin: 0; text-overflow: ellipsis; overflow: hidden; font-weight: 600; }
        .widget-text p { font-size: 0.75rem; color: rgba(255,255,255,0.7); margin: 0; text-overflow: ellipsis; overflow: hidden; }

        .widget-logout-btn {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: rgba(255, 71, 87, 0.2);
            color: #ff4757;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        .widget-logout-btn:hover {
            background: #ff4757;
            color: var(--white);
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(255, 71, 87, 0.4);
        }

        /* Collapsed Sidebar Styles */
        .navigation.active .sidebar-widget {
            margin: 10px;
            flex-direction: column;
            justify-content: center;
            gap: 15px;
            padding: 15px 0;
            border-radius: 20px;
        }

        .navigation.active .widget-text { display: none; }
        .navigation.active .widget-user-img { border-radius: 50%; width: 40px; height: 40px; }
        .navigation.active .widget-logout-btn { border-radius: 50%; width: 40px; height: 40px; }

        /* Main Section */
        .main { position: absolute; width: calc(100% - 300px); left: 300px; min-height: 100vh; background: transparent; transition: 0.5s; }
        .main.active { width: calc(100% - 80px); left: 80px; }
        .topbar { width: 100%; height: 70px; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; }
        .toggle { position: relative; width: 60px; height: 60px; display: flex; justify-content: center; align-items: center; font-size: 2.5rem; cursor: pointer; color: var(--black1); }

        /* Theme Toggle Button */
        .top-actions { display: flex; align-items: center; gap: 15px; }

        #mode-toggle { 
            background: linear-gradient(115deg, #0a0a0a, #4e54c8); border: 2px solid rgba(255, 165, 0, 0.6); 
            color: #ff6600; border-radius: 50%; font-size: 20px; cursor: pointer; transition: all 0.3s ease; 
            box-shadow: 0px 5px 15px rgba(255, 165, 0, 0.5); display: flex; align-items: center; 
            justify-content: center; width: 45px; height: 45px; 
        }
        #mode-toggle:hover { transform: scale(1.1); }

        /* Cards UI */
        .cardBox { 
            position: relative; width: 100%; padding: 20px; display: grid; grid-template-columns: repeat(5, 1fr); grid-gap: 15px; 
        }
        .cardBox .card { 
            position: relative; background: var(--white); padding: 20px; border-radius: 20px; display: flex; 
            justify-content: space-between; cursor: pointer; box-shadow: 0 7px 25px rgba(0, 0, 0, 0.08); transition: background 0.3s; 
        }
        .cardBox .card .numbers { position: relative; font-weight: 500; font-size: 2rem; color: var(--red2); }
        .cardBox .card .cardName { color: var(--black2); font-size: 0.95rem; margin-top: 5px; }
        .cardBox .card .iconBx { font-size: 2.5rem; color: var(--black2); }
        .cardBox .card:hover { background: var(--blue); }
        .cardBox .card:hover .numbers, .cardBox .card:hover .cardName, .cardBox .card:hover .iconBx { color: var(--white); }

        /* Dark Mode */
        body.dark-mode { background: linear-gradient(115deg, #0a0a0a, #4e54c8); color: white; }
        body.dark-mode .navigation { background-color: #1e1e1e; color: white; border-left-color: #1e1e1e; }
        body.dark-mode .navigation ul::-webkit-scrollbar-track { background: #1e1e1e; }
        body.dark-mode .main { background: transparent; color: white; }
        body.dark-mode .card { background-color: #333; color: white; box-shadow: 0 7px 25px rgba(0, 0, 0, 0.5); }
        body.dark-mode .card .cardName, body.dark-mode .card .iconBx { color: #bbb; }
        
        body.dark-mode .navigation ul li:hover a::before, body.dark-mode .navigation ul li.hovered a::before { box-shadow: 35px 35px 0 10px #1e1e1e; }
        body.dark-mode .navigation ul li:hover a::after, body.dark-mode .navigation ul li.hovered a::after { box-shadow: 35px -35px 0 10px #1e1e1e; }

        body.dark-mode #mode-toggle { background: rgba(255, 255, 255, 0.1); color: white; border-color: white; box-shadow: none; }
        body.dark-mode .toggle { color: var(--white); }

        /* Image Slider */
        .gallery-container { width: 100%; max-width: 1000px; margin: 30px auto; padding: 20px; position: relative; overflow: hidden; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); background: var(--white); }
        .gallery-title { text-align: center; margin-bottom: 20px; font-size: 2rem; color: var(--blue); position: relative; }
        .gallery-title::after { content: ''; position: absolute; bottom: -10px; left: 50%; transform: translateX(-50%); width: 100px; height: 3px; background: var(--blue); }
        .single-slide { width: 100%; height: 400px; position: relative; overflow: hidden; border-radius: 10px; }
        .single-slide img { width: 100%; height: 100%; object-fit: cover; position: absolute; top: 0; left: 0; opacity: 0; transition: opacity 1s ease-in-out; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
        .single-slide img.active { opacity: 1; }
        .slider-controls { position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); display: flex; gap: 10px; z-index: 10; }
        .slider-controls .dot { width: 12px; height: 12px; border-radius: 50%; background: rgba(255,255,255,0.5); cursor: pointer; transition: all 0.3s; }
        .slider-controls .dot.active { background: var(--blue); transform: scale(1.2); }
        body.dark-mode .gallery-container { background: #333; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        body.dark-mode .gallery-title { color: #fff; }
        body.dark-mode .gallery-title::after { background: #fff; }
        body.dark-mode .slider-controls .dot { background: rgba(255,255,255,0.3); }
        body.dark-mode .slider-controls .dot.active { background: var(--white); }

        /* Responsive scaling */
        @media (max-width: 1400px) { .cardBox { grid-template-columns: repeat(3, 1fr); } }
        @media (max-width: 991px) {
            .navigation { left: -300px; }
            .navigation.active { width: 300px; left: 0; }
            .main { width: 100%; left: 0; }
            .main.active { left: 300px; }
            .cardBox { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) { .single-slide { height: 300px; } }
        @media (max-width: 480px) {
            .navigation { width: 100%; left: -100%; z-index: 1000; }
            .navigation.active { width: 100%; left: 0; }
            .toggle { z-index: 10001; }
            .main.active .toggle { color: #fff; position: fixed; right: 0; left: initial; }
            .cardBox { grid-template-columns: repeat(1, 1fr); }
            .gallery-title { font-size: 1.5rem; } .single-slide { height: 200px; } .slider-controls .dot { width: 10px; height: 10px; }
        }
    </style>
</head>

<body>
    <!-- =============== Navigation ================ -->
    <div class="container">
        <div class="navigation">
            <!-- Scrollable Menu Area -->
            <ul>
                <li>
                    <a href="#">
                        <span class="icon" style="display: flex; align-items: center; justify-content: center; height: 60px;">
                            <img src="logo2.jpg" alt="Logo" style="width: 34px; height: 34px; border-radius: 50%; object-fit: cover; box-shadow: 0 2px 10px rgba(0,0,0,0.2);">
                        </span>
                        <span class="title">Library Management</span>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <span class="icon"><ion-icon name="home-outline"></ion-icon></span>
                        <span class="title">Home</span>
                    </a>
                </li>
                <li>
                    <a href="Addstudent.jsp">
                        <span class="icon"><ion-icon name="people-outline"></ion-icon></span>
                        <span class="title">Manage Students</span>
                    </a>
                </li>
                <li>
                    <a href="Addbooks.jsp">
                        <span class="icon"><ion-icon name="book-outline"></ion-icon></span>
                        <span class="title">Manage Books</span>
                    </a>
                </li>
                <li>
                    <a href="Issuebooks.jsp">
                        <span class="icon"><ion-icon name="book-outline"></ion-icon></span>
                        <span class="title">Issue Books</span>
                    </a>
                </li>
                <li>
                    <a href="submittedBooks.jsp">
                        <span class="icon"><ion-icon name="cart-outline"></ion-icon></span>
                        <span class="title">Return Books</span>
                    </a>
                </li>
                <li>
                    <a href="ViewIssuedBooks.jsp">
                        <span class="icon"><ion-icon name="book-outline"></ion-icon></span>
                        <span class="title">View issued Books</span>
                    </a>
                </li>
                <li>
                    <a href="studentRecords.jsp">
                        <span class="icon"><ion-icon name="people-outline"></ion-icon></span>
                        <span class="title">View Students</span>
                    </a>
                </li>
                <li>
                    <a href="BooksRecords.jsp">
                        <span class="icon"><ion-icon name="book-outline"></ion-icon></span>
                        <span class="title">View Books Data</span>
                    </a>
                </li>
                <li>
                    <a href="AdminViewEBooks.jsp">
                        <span class="icon"><ion-icon name="desktop-outline"></ion-icon></span>
                        <span class="title">View E-Books</span>
                    </a>
                </li>
                <li>
                    <a href="Report.jsp">
                        <span class="icon"><ion-icon name="receipt-outline"></ion-icon></span>
                        <span class="title">Reports</span>
                    </a>
                </li>
            </ul>
            
            <!-- Fixed Profile & Logout Widget at the bottom -->
            <div class="sidebar-widget">
                <div class="widget-profile-info">
                    <div class="widget-user-img">
                        <% if (profileImage != null && !profileImage.isEmpty()) { %>
                            <img src="data:image/jpeg;base64,<%= profileImage %>" alt="Profile">
                        <% } else { %>
                            <%= initials %>
                        <% } %>
                    </div>
                    <div class="widget-text">
                        <h4><%= fullName %></h4>
                        <p title="<%= email %>"><%= email %></p>
                    </div>
                </div>
                <a href="LogoutServlet" class="widget-logout-btn" title="Logout">
                    <ion-icon name="log-out-outline"></ion-icon>
                </a>
            </div>
        </div>

        <!-- ========================= Main ==================== -->
        <div class="main">
            <div class="topbar">
                <div class="toggle">
                    <ion-icon name="menu-outline"></ion-icon>
                </div>
                <div class="top-actions">
                    <button id="mode-toggle" title="Toggle Theme">🌙</button>
                </div>
            </div>

            <!-- ======================= Cards ================== -->
            <div class="cardBox">
                <div class="card">
                    <div>
                        <div class="numbers" id="studentCount">0</div>
                        <div class="cardName">Total Students</div>
                    </div>
                    <div class="iconBx"><ion-icon name="people-outline"></ion-icon></div>
                </div>

                <div class="card">
                    <div>
                        <div class="numbers" id="bookCount">0</div>
                        <div class="cardName">Total Books</div>
                    </div>
                    <div class="iconBx"><ion-icon name="book-outline"></ion-icon></div>
                </div>

                <div class="card">
                    <div>
                        <div class="numbers" id="issuedBookCount">0</div>
                        <div class="cardName">Issued Books</div>
                    </div>
                    <div class="iconBx"><ion-icon name="book-outline"></ion-icon></div>
                </div>
                
                <div class="card">
                    <div>
                        <div class="numbers" id="pendingCount">0</div>
                        <div class="cardName">Available Books</div>
                    </div>
                    <div class="iconBx"><ion-icon name="file-tray-full-outline"></ion-icon></div>
                </div>
                
                <div class="card" onclick="window.location.href='AdminViewEBooks.jsp'">
                    <div>
                        <div class="numbers" id="eBooksCount">0</div>
                        <div class="cardName">Total E-Books</div>
                    </div>
                    <div class="iconBx"><ion-icon name="desktop-outline"></ion-icon></div>
                </div>
            </div>

            <!-- =================== Single Image Gallery ================== -->
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

            <!-- =========== Scripts =========  -->
            <script>
    // Dark/Light Mode Toggle
    document.addEventListener("DOMContentLoaded", () => {
        const modeToggle = document.getElementById("mode-toggle");
        const body = document.body;

        if (localStorage.getItem("theme") === "dark") {
            body.classList.add("dark-mode");
            modeToggle.innerHTML = "☀";
        } else {
            body.classList.remove("dark-mode");
            modeToggle.innerHTML = "🌙";
        }

        modeToggle.addEventListener("click", () => {
            body.classList.toggle("dark-mode");
            if (body.classList.contains("dark-mode")) {
                modeToggle.innerHTML = "☀";
                localStorage.setItem("theme", "dark");
            } else {
                modeToggle.innerHTML = "🌙";
                localStorage.setItem("theme", "light");
            }
        });

        const toggle = document.querySelector(".toggle");
        const navigation = document.querySelector(".navigation");
        const main = document.querySelector(".main");

        if (toggle && navigation && main) {
            toggle.onclick = function() {
                navigation.classList.toggle("active");
                main.classList.toggle("active");
            };
        }
        
        // Single Image Gallery Functionality
        const galleryContainer = document.querySelector('.single-slide');
        if (galleryContainer) {
            const images = galleryContainer.querySelectorAll('img');
            const sliderControls = document.getElementById('slider-controls');
            let currentIndex = 0; let autoSlideInterval;
            if (sliderControls) {
                images.forEach((_, index) => {
                    const dot = document.createElement('div');
                    dot.classList.add('dot');
                    if (index === 0) dot.classList.add('active');
                    dot.addEventListener('click', () => goToSlide(index));
                    sliderControls.appendChild(dot);
                });
            }
            const dots = sliderControls ? sliderControls.querySelectorAll('.dot') : [];
            function goToSlide(index) {
                images[currentIndex].classList.remove('active');
                if (dots.length > 0) dots[currentIndex].classList.remove('active');
                currentIndex = index;
                images[currentIndex].classList.add('active');
                if (dots.length > 0) dots[currentIndex].classList.add('active');
                resetAutoSlide();
            }
            function nextSlide() { goToSlide((currentIndex + 1) % images.length); }
            function startAutoSlide() { autoSlideInterval = setInterval(nextSlide, 3000); }
            function resetAutoSlide() { clearInterval(autoSlideInterval); startAutoSlide(); }
            
            images[0].classList.add('active');
            if (dots.length > 0) dots[0].classList.add('active');
            startAutoSlide();
            galleryContainer.addEventListener('mouseenter', () => clearInterval(autoSlideInterval));
            galleryContainer.addEventListener('mouseleave', startAutoSlide);
        }
    });
</script>
            <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
            <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        </div>
    </div>
    
<script>
  function fetchPendingBooksCount() {
    fetch('AvailableBooksCount')
      .then(response => { if (!response.ok) throw new Error('Available books count fetch failed'); return response.text(); })
      .then(count => { document.getElementById("pendingCount").innerText = count; })
      .catch(error => { document.getElementById("pendingCount").innerText = "0"; });
  }

  function fetchEBooksCount() {
    fetch('EBookActionServlet?action=count')
      .then(response => response.text())
      .then(count => { document.getElementById("eBooksCount").innerText = count || "0"; })
      .catch(error => { document.getElementById("eBooksCount").innerText = "0"; });
  }

  function initializeCounts() {
    fetch('BooksCount').then(r => r.text()).then(c => document.getElementById("bookCount").innerText = c).catch(() => document.getElementById("bookCount").innerText = "0");
    fetch('TotalStudentCount').then(r => r.text()).then(c => document.getElementById("studentCount").innerText = c).catch(() => document.getElementById("studentCount").innerText = "0");
    // Fixed endpoint name to match @WebServlet("/IssuedBooksCount")
    fetch('IssuedBooksCount').then(r => r.text()).then(c => document.getElementById("issuedBookCount").innerText = c).catch(() => document.getElementById("issuedBookCount").innerText = "0");
    fetchPendingBooksCount();
    fetchEBooksCount(); 
  }

  document.addEventListener("DOMContentLoaded", function() {
    initializeCounts();
    setInterval(initializeCounts, 60000);
  });
</script>
</body>
</html>