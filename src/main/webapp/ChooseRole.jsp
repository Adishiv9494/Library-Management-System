<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Choose Your Role</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <style>
        /* ===== Root Variables ===== */
        :root {
            --primary: #4e73df;
            --primary-dark: #2e59d9;
            --secondary: #ff6600;
            --accent: #ff3366;
            --gradient-1: linear-gradient(135deg, #ff6600, #ff3366, #8844ee);
            --gradient-2: linear-gradient(135deg, #4e73df, #8844ee);
            --text-light: #212529;
            --text-dark: #f8f9fa;
            --body-bg-light: #f4f6f9;
            --body-bg-dark: #0a0514;
            --card-bg-light: rgba(255, 255, 255, 0.95);
            --card-bg-dark: rgba(22, 30, 50, 0.95);
            --grid-color-light: rgba(78, 115, 223, 0.15);
            --grid-color-dark: rgba(136, 68, 238, 0.25);
            --mesh-light: rgba(0, 0, 0, 0.03);
            --mesh-dark: rgba(255, 255, 255, 0.02);
        }

        [data-bs-theme="dark"] {
            --bs-body-bg: var(--body-bg-dark);
            --bs-body-color: var(--text-dark);
            --card-bg: var(--card-bg-dark);
            --border-color: rgba(255, 255, 255, 0.1);
            --mesh-color: var(--mesh-dark);
            --grid-color: var(--grid-color-dark);
        }

        [data-bs-theme="light"] {
            --bs-body-bg: var(--body-bg-light);
            --bs-body-color: var(--text-light);
            --card-bg: var(--card-bg-light);
            --border-color: rgba(0, 0, 0, 0.08);
            --mesh-color: var(--mesh-light);
            --grid-color: var(--grid-color-light);
        }

        body {
            background-color: var(--bs-body-bg);
            background-image: radial-gradient(var(--mesh-color) 1.5px, transparent 1.5px), radial-gradient(var(--mesh-color) 1.5px, transparent 1.5px);
            background-size: 30px 30px;
            background-position: 0 0, 15px 15px;
            color: var(--bs-body-color);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.5s ease;
            padding: 20px;
            overflow: hidden;
            position: relative;
        }

        /* ===== 3D Background ===== */
        .bg-3d {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            pointer-events: none;
            overflow: hidden;
            perspective: 1200px;
        }

        .bg-grid {
            position: absolute;
            bottom: -30%;
            left: -50%;
            width: 200%;
            height: 100%;
            background-image: 
                linear-gradient(var(--grid-color) 2px, transparent 2px),
                linear-gradient(90deg, var(--grid-color) 2px, transparent 2px);
            background-size: 60px 60px;
            transform-origin: top center;
            transform: rotateX(70deg) translateY(0);
            animation: gridMove 20s linear infinite;
            -webkit-mask-image: linear-gradient(to top, rgba(0,0,0,1) 0%, rgba(0,0,0,0) 80%);
            mask-image: linear-gradient(to top, rgba(0,0,0,1) 0%, rgba(0,0,0,0) 80%);
            transition: background-image 0.5s ease;
        }

        @keyframes gridMove {
            0% { transform: rotateX(70deg) translateY(0); }
            100% { transform: rotateX(70deg) translateY(60px); }
        }

        .layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            transform-style: preserve-3d;
            transition: transform 0.1s ease-out;
        }

        .float-book {
            position: absolute;
            font-size: 4rem;
            animation: floatBook 20s ease-in-out infinite;
            color: var(--float-book-color, rgba(78, 115, 223, 0.15));
            filter: drop-shadow(0 10px 15px rgba(0,0,0,0.1));
        }

        [data-bs-theme="light"] .float-book { color: rgba(78, 115, 223, 0.18); }
        [data-bs-theme="dark"] .float-book { color: rgba(255, 255, 255, 0.1); filter: drop-shadow(0 10px 20px rgba(136, 68, 238, 0.2)); }

        .float-book:nth-child(1) { top: 10%; left: 5%; animation-delay: 0s; font-size: 5rem; transform: translateZ(50px); }
        .float-book:nth-child(2) { top: 20%; right: 8%; animation-delay: 3s; font-size: 3.5rem; transform: translateZ(100px); }
        .float-book:nth-child(3) { bottom: 25%; left: 10%; animation-delay: 6s; font-size: 4.5rem; transform: translateZ(20px); }
        .float-book:nth-child(4) { bottom: 15%; right: 5%; animation-delay: 9s; font-size: 3rem; transform: translateZ(80px); }
        .float-book:nth-child(5) { top: 50%; left: 3%; animation-delay: 12s; font-size: 3.8rem; transform: translateZ(120px); }
        .float-book:nth-child(6) { top: 40%; right: 3%; animation-delay: 15s; font-size: 4.2rem; transform: translateZ(40px); }

        .float-page {
            position: absolute;
            width: 40px;
            height: 50px;
            border-radius: 2px;
            transform: rotate(10deg) skewX(-5deg);
            animation: floatPage 25s ease-in-out infinite;
        }

        [data-bs-theme="light"] .float-page { background: rgba(78, 115, 223, 0.08); border: 1px solid rgba(78, 115, 223, 0.15); }
        [data-bs-theme="dark"] .float-page { background: rgba(255, 255, 255, 0.04); border: 1px solid rgba(255, 255, 255, 0.05); }

        .float-page:nth-child(7) { top: 12%; left: 22%; animation-delay: 1s; width: 35px; height: 45px; transform: translateZ(60px); }
        .float-page:nth-child(8) { top: 28%; right: 20%; animation-delay: 5s; width: 45px; height: 55px; transform: translateZ(110px); }
        .float-page:nth-child(9) { bottom: 18%; left: 28%; animation-delay: 8s; width: 30px; height: 40px; transform: translateZ(30px); }
        .float-page:nth-child(10) { bottom: 38%; right: 15%; animation-delay: 12s; width: 50px; height: 60px; transform: translateZ(90px); }

        .float-dot {
            position: absolute;
            border-radius: 50%;
            animation: floatDot 18s ease-in-out infinite;
        }

        [data-bs-theme="light"] .float-dot { background: rgba(78, 115, 223, 0.08); }
        [data-bs-theme="dark"] .float-dot { background: rgba(255, 255, 255, 0.04); }

        .float-dot:nth-child(11) { top: 15%; left: 48%; width: 80px; height: 80px; animation-delay: 2s; transform: translateZ(40px); }
        .float-dot:nth-child(12) { bottom: 28%; right: 42%; width: 120px; height: 120px; animation-delay: 7s; transform: translateZ(70px); }
        .float-dot:nth-child(13) { top: 58%; left: 18%; width: 60px; height: 60px; animation-delay: 10s; transform: translateZ(130px); }

        .gradient-orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 1;
            animation: orbFloat 30s ease-in-out infinite;
        }

        [data-bs-theme="light"] .gradient-orb:nth-child(14) { background: radial-gradient(circle, rgba(78, 115, 223, 0.20), transparent); }
        [data-bs-theme="dark"] .gradient-orb:nth-child(14) { background: radial-gradient(circle, rgba(136, 68, 238, 0.25), transparent); }
        [data-bs-theme="light"] .gradient-orb:nth-child(15) { background: radial-gradient(circle, rgba(255, 102, 0, 0.15), transparent); }
        [data-bs-theme="dark"] .gradient-orb:nth-child(15) { background: radial-gradient(circle, rgba(255, 51, 102, 0.20), transparent); }

        .gradient-orb:nth-child(14) { top: -20%; left: -20%; width: 60%; height: 60%; animation-delay: 0s; transform: translateZ(-100px); }
        .gradient-orb:nth-child(15) { bottom: -20%; right: -20%; width: 60%; height: 60%; animation-delay: 15s; transform: translateZ(-100px); }

        @keyframes floatBook {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            25% { transform: translateY(-30px) rotate(5deg); }
            50% { transform: translateY(20px) rotate(-5deg); }
            75% { transform: translateY(-15px) rotate(3deg); }
        }

        @keyframes floatPage {
            0%, 100% { transform: translateY(0) rotate(10deg) skewX(-5deg); }
            33% { transform: translateY(-40px) rotate(15deg) skewX(-8deg); }
            66% { transform: translateY(30px) rotate(5deg) skewX(-2deg); }
        }

        @keyframes floatDot {
            0%, 100% { transform: translate(0, 0); }
            25% { transform: translate(30px, -20px) scale(1.1); }
            50% { transform: translate(-20px, 30px) scale(0.9); }
            75% { transform: translate(15px, -10px) scale(1.05); }
        }

        @keyframes orbFloat {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33% { transform: translate(5%, -5%) scale(1.1); }
            66% { transform: translate(-5%, 5%) scale(0.9); }
        }

        .role-container {
            max-width: 920px;
            width: 100%;
            padding: 30px 35px 35px 35px;
            background: var(--card-bg);
            border-radius: 25px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-color);
        }

        [data-bs-theme="dark"] .role-container {
            backdrop-filter: blur(25px);
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }

        .btn-back {
            background: transparent;
            border: 2px solid var(--border-color);
            color: var(--bs-body-color);
            padding: 8px 18px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-back:hover {
            border-color: var(--primary);
            color: var(--primary);
            transform: translateX(-3px);
        }

        .theme-toggle-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid var(--border-color);
            background: var(--card-bg);
            color: var(--bs-body-color);
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .theme-toggle-btn:hover {
            transform: rotate(30deg);
            border-color: var(--primary);
        }

        .role-header {
            text-align: center;
            margin-bottom: 22px;
        }

        .role-header .logo {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 10px;
            box-shadow: 0 8px 25px rgba(78, 115, 223, 0.25);
            transition: transform 0.5s ease;
        }

        .role-header .logo:hover {
            transform: rotate(10deg) scale(1.05);
        }

        .role-header h1 {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, #ff6600, #ff3366, #8844ee);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 4px;
        }

        .role-header p {
            opacity: 0.7;
            font-size: 0.95rem;
            margin: 0;
        }

        .role-cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .role-card {
            background: var(--bs-body-bg);
            border: 2px solid var(--border-color);
            border-radius: 16px;
            padding: 20px 22px 22px 22px;
            text-align: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            position: relative;
            transform-style: preserve-3d;
            perspective: 600px;
        }

        .role-card:hover {
            transform: translateY(-6px) rotateX(2deg);
            border-color: var(--primary);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
        }

        .role-card.selected {
            border-color: var(--primary);
            background: rgba(78, 115, 223, 0.06);
            box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.2), 0 10px 30px rgba(0, 0, 0, 0.08);
            transform: translateY(-4px);
        }

        .role-card .icon {
            font-size: 2.8rem;
            margin-bottom: 10px;
            display: block;
            transition: transform 0.3s ease;
        }

        .role-card:hover .icon {
            transform: scale(1.1) rotate(-5deg);
        }

        .role-card .student-icon {
            color: var(--primary);
        }

        .role-card .librarian-icon {
            color: var(--secondary);
        }

        .role-card h3 {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .role-card p {
            opacity: 0.7;
            font-size: 0.85rem;
            margin-bottom: 12px;
        }

        .role-card .features-list {
            list-style: none;
            padding: 0;
            text-align: left;
            margin: 0;
        }

        .role-card .features-list li {
            padding: 3px 0;
            font-size: 0.8rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .role-card .features-list li i {
            color: #10b981;
            width: 16px;
            font-size: 0.8rem;
        }

        .role-card .select-badge {
            position: absolute;
            top: 10px;
            right: 12px;
            background: var(--primary);
            color: white;
            padding: 2px 12px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
            opacity: 0;
            transition: all 0.3s ease;
        }

        .role-card.selected .select-badge {
            opacity: 1;
        }

        .role-footer {
            text-align: center;
            margin-top: 25px;
        }

        .btn-continue {
            padding: 12px 50px;
            font-size: 1rem;
            font-weight: 700;
            border: none;
            border-radius: 50px;
            background: linear-gradient(135deg, #ff6600, #ff3366);
            color: white;
            cursor: pointer;
            transition: all 0.4s ease;
            box-shadow: 0 8px 25px rgba(255, 102, 0, 0.3);
            opacity: 0.5;
            pointer-events: none;
        }

        .btn-continue.active {
            opacity: 1;
            pointer-events: auto;
        }

        .btn-continue.active:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 12px 35px rgba(255, 102, 0, 0.5);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .role-cards { grid-template-columns: 1fr; gap: 16px; }
            .role-container { padding: 20px 18px 25px 18px; }
            .role-header h1 { font-size: 1.6rem; }
            .role-card { padding: 16px 18px; }
            .role-card .icon { font-size: 2.2rem; }
            .btn-continue { padding: 10px 35px; font-size: 0.95rem; }
            .top-bar { margin-bottom: 15px; }
            .float-book, .float-page, .float-dot, .gradient-orb { display: none; }
            .bg-grid { display: none; }
        }

        @media (max-width: 480px) {
            .role-header .logo { width: 55px; height: 55px; }
            .role-header h1 { font-size: 1.3rem; }
            .role-card .features-list li { font-size: 0.75rem; }
        }
    </style>
</head>
<body>

    <!-- ===== 3D BACKGROUND ===== -->
    <div class="bg-3d">
        <div class="bg-grid"></div>
        <div class="layer" id="parallaxLayer">
            <div class="float-book"><i class="fas fa-book"></i></div>
            <div class="float-book"><i class="fas fa-book-open"></i></div>
            <div class="float-book"><i class="fas fa-book"></i></div>
            <div class="float-book"><i class="fas fa-book-open"></i></div>
            <div class="float-book"><i class="fas fa-book"></i></div>
            <div class="float-book"><i class="fas fa-book-open"></i></div>
            <div class="float-page"></div>
            <div class="float-page"></div>
            <div class="float-page"></div>
            <div class="float-page"></div>
            <div class="float-dot"></div>
            <div class="float-dot"></div>
            <div class="float-dot"></div>
            <div class="gradient-orb"></div>
            <div class="gradient-orb"></div>
        </div>
    </div>

    <!-- ===== MAIN CONTENT ===== -->
    <div class="role-container">
        <div class="top-bar">
            <a href="welcome.jsp" class="btn-back">
                <i class="fas fa-arrow-left"></i> Back
            </a>
            <button class="theme-toggle-btn" id="themeToggle">
                <i class="fas fa-moon"></i>
            </button>
        </div>

        <div class="role-header">
            <img src="logo2.jpg" alt="Library Logo" class="logo">
            <h1>Choose Your Role</h1>
            <p>Select how you want to access the Library Management System</p>
        </div>

        <div class="role-cards">
            <div class="role-card" data-role="student" id="studentCard">
                <span class="select-badge"><i class="fas fa-check"></i> Selected</span>
                <span class="icon student-icon"><i class="fas fa-user-graduate"></i></span>
                <h3>Student</h3>
                <p>Access library services, issue books, view records.</p>
                <ul class="features-list">
                    <li><i class="fas fa-check-circle"></i> Browse & search books</li>
                    <li><i class="fas fa-check-circle"></i> Issue & return books</li>
                    <li><i class="fas fa-check-circle"></i> View & Download E-Books</li>
                    <li><i class="fas fa-check-circle"></i> View issued history</li>
                    <li><i class="fas fa-check-circle"></i> Track fines & due dates</li>
                </ul>
            </div>

            <div class="role-card" data-role="librarian" id="librarianCard">
                <span class="select-badge"><i class="fas fa-check"></i> Selected</span>
                <span class="icon librarian-icon"><i class="fas fa-user-tie"></i></span>
                <h3>Librarian</h3>
                <p>Manage library operations, books, students, and reports.</p>
                <ul class="features-list">
                    <li><i class="fas fa-check-circle"></i> Add & manage books</li>
                    <li><i class="fas fa-check-circle"></i> Register & manage students</li>
                    <li><i class="fas fa-check-circle"></i> Issue & return books</li>
                    <li><i class="fas fa-check-circle"></i> View defaulters & fines</li>
                    <li><i class="fas fa-check-circle"></i> Generate reports</li>
                </ul>
            </div>
        </div>

        <div class="role-footer">
            <button class="btn-continue" id="continueBtn">
                <i class="fas fa-arrow-right me-2"></i>Continue
            </button>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

    <script>
        // ===== Theme Toggle =====
        document.addEventListener("DOMContentLoaded", function() {
            const themeToggle = document.getElementById('themeToggle');
            const icon = themeToggle.querySelector('i');

            function initTheme() {
                const savedTheme = localStorage.getItem('theme') || 'light';
                document.documentElement.setAttribute('data-bs-theme', savedTheme);
                icon.className = savedTheme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
            }

            themeToggle.addEventListener('click', function() {
                const currentTheme = document.documentElement.getAttribute('data-bs-theme');
                const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                document.documentElement.setAttribute('data-bs-theme', newTheme);
                localStorage.setItem('theme', newTheme);
                icon.style.transform = 'rotate(180deg)';
                setTimeout(() => icon.style.transform = 'rotate(0deg)', 300);
                icon.className = newTheme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
            });

            initTheme();

            // ===== Role Selection =====
            const studentCard = document.getElementById('studentCard');
            const librarianCard = document.getElementById('librarianCard');
            const continueBtn = document.getElementById('continueBtn');
            let selectedRole = null;

            function selectRole(card) {
                studentCard.classList.remove('selected');
                librarianCard.classList.remove('selected');
                card.classList.add('selected');
                selectedRole = card.dataset.role;
                continueBtn.classList.add('active');
            }

            studentCard.addEventListener('click', function() { selectRole(this); });
            librarianCard.addEventListener('click', function() { selectRole(this); });

            continueBtn.addEventListener('click', function() {
                if (!selectedRole) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Select a Role',
                        text: 'Please choose either Student or Librarian.',
                        confirmButtonColor: '#4e73df'
                    });
                    return;
                }

                if (selectedRole === 'student') {
                    Swal.fire({
                        icon: 'info',
                        title: 'Redirecting...',
                        text: 'You selected Student. Proceeding to registration.',
                        timer: 1200,
                        showConfirmButton: false,
                        willClose: function() { window.location.href = 'StudentSignup.jsp'; }
                    });
                } else if (selectedRole === 'librarian') {
                    Swal.fire({
                        icon: 'info',
                        title: 'Redirecting...',
                        text: 'You selected Librarian. Proceeding to login.',
                        timer: 1200,
                        showConfirmButton: false,
                        willClose: function() { window.location.href = 'Login.jsp'; }
                    });
                }
            });

            // ===== Parallax effect on cards =====
            const cards = document.querySelectorAll('.role-card');
            cards.forEach(card => {
                card.addEventListener('mousemove', function(e) {
                    const rect = this.getBoundingClientRect();
                    const x = (e.clientX - rect.left) / rect.width - 0.5;
                    const y = (e.clientY - rect.top) / rect.height - 0.5;
                    this.style.transform = `perspective(600px) rotateY(${x * 6}deg) rotateX(${-y * 6}deg) translateY(-4px)`;
                });
                card.addEventListener('mouseleave', function() {
                    this.style.transform = '';
                });
            });

            // ===== Interactive 3D Parallax =====
            const parallaxLayer = document.getElementById('parallaxLayer');
            if(parallaxLayer) {
                document.addEventListener('mousemove', function(e) {
                    if (window.innerWidth > 768) {
                        const x = (window.innerWidth / 2 - e.pageX) / 40;
                        const y = (window.innerHeight / 2 - e.pageY) / 40;
                        parallaxLayer.style.transform = `rotateY(${x}deg) rotateX(${y}deg)`;
                    }
                });
            }
        });
    </script>
</body>
</html>