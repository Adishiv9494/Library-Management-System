<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
     <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Account Created</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ===== Root Variables ===== */
        :root {
            --primary: #4e73df;
            --secondary: #ff6600;
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
            --mesh-color: var(--mesh-dark);
            --grid-color: var(--grid-color-dark);
        }

        [data-bs-theme="light"] {
            --bs-body-bg: var(--body-bg-light);
            --bs-body-color: var(--text-light);
            --card-bg: var(--card-bg-light);
            --mesh-color: var(--mesh-light);
            --grid-color: var(--grid-color-light);
        }

        body {
            font-family: Arial, sans-serif;
            background-color: var(--bs-body-bg);
            background-image: radial-gradient(var(--mesh-color) 1.5px, transparent 1.5px), radial-gradient(var(--mesh-color) 1.5px, transparent 1.5px);
            background-size: 30px 30px;
            background-position: 0 0, 15px 15px;
            color: var(--bs-body-color);
            text-align: center;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: hidden;
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

        .container {
            position: relative;
            z-index: 1;
            padding: 40px;
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            box-shadow: 0px 15px 40px rgba(0, 0, 0, 0.15);
            border-radius: 20px;
            width: 50%;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        [data-bs-theme="dark"] .container {
            box-shadow: 0px 15px 40px rgba(0, 0, 0, 0.5);
        }

        h1 {
            color: #10b981; /* Green success color */
            margin-bottom: 20px;
        }

        p {
            font-size: 1.1rem;
            margin-bottom: 10px;
        }

        .button {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 35px;
            background: linear-gradient(135deg, #7c3aed, #a78bfa);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(124, 58, 237, 0.3);
        }
        .button:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(124, 58, 237, 0.5);
        }
        
        @media (max-width: 768px) {
            .container { width: 90%; }
            .bg-grid { display: none; }
            .float-book, .float-page, .float-dot, .gradient-orb { display: none; }
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

    <div class="container">
        <h1>🎉 Congratulations! Your Account has been Created 🎉</h1>
        <p><strong>Click here to go the login</strong></p>
        
        <a href="StudentSignup.jsp" class="button">Login</a>
    </div>

    <script>
        // Interactive 3D Parallax Effect
        document.addEventListener("DOMContentLoaded", function() {
            const parallaxLayer = document.getElementById('parallaxLayer');
            if(parallaxLayer) {
                document.addEventListener('mousemove', function(e) {
                    const x = (window.innerWidth / 2 - e.pageX) / 40;
                    const y = (window.innerHeight / 2 - e.pageY) / 40;
                    if (window.innerWidth > 768) { 
                        parallaxLayer.style.transform = `rotateY(${x}deg) rotateX(${y}deg)`;
                    }
                });
            }
        });
    </script>
</body>
</html>