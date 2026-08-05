<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management System</title>
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
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

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: var(--bs-body-bg);
            /* Subtle dot-mesh texture */
            background-image: radial-gradient(var(--mesh-color) 1.5px, transparent 1.5px), radial-gradient(var(--mesh-color) 1.5px, transparent 1.5px);
            background-size: 30px 30px;
            background-position: 0 0, 15px 15px;
            color: var(--bs-body-color);
            transition: background-color 0.5s ease, color 0.5s ease;
            overflow-x: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* ===== Scrollbar ===== */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: var(--bs-body-bg); }
        ::-webkit-scrollbar-thumb { background: var(--secondary); border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--accent); }

        /* ===== ULTRA-IMPRESSIVE PRELOADER ===== */
        #preloader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(10, 5, 20, 0.7) 0%, rgba(10, 5, 20, 0.95) 100%);
            backdrop-filter: blur(8px);
            z-index: 99999;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            transition: opacity 0.8s ease, visibility 0.8s ease;
            perspective: 1000px;
        }

        .loader-wrapper {
            position: relative;
            width: 180px;
            height: 180px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 35px;
            transform-style: preserve-3d;
        }

        /* 3D Atomic Orbits */
        .orbit {
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            border: 3px solid transparent;
            transform-style: preserve-3d;
        }

        .orbit:nth-child(1) {
            border-top: 3px solid #ff6600;
            border-right: 3px solid #ff3366;
            animation: spin-orbit1 2.5s linear infinite;
        }

        .orbit:nth-child(2) {
            border-right: 3px solid #4e73df;
            border-bottom: 3px solid #8844ee;
            animation: spin-orbit2 3s linear infinite;
        }

        .orbit:nth-child(3) {
            border-bottom: 3px solid #00d2ff;
            border-left: 3px solid #3a7bd5;
            animation: spin-orbit3 3.5s linear infinite;
        }

        @keyframes spin-orbit1 {
            0% { transform: rotateX(65deg) rotateY(35deg) rotateZ(0deg); }
            100% { transform: rotateX(65deg) rotateY(35deg) rotateZ(360deg); }
        }
        @keyframes spin-orbit2 {
            0% { transform: rotateX(35deg) rotateY(65deg) rotateZ(0deg); }
            100% { transform: rotateX(35deg) rotateY(65deg) rotateZ(360deg); }
        }
        @keyframes spin-orbit3 {
            0% { transform: rotateX(15deg) rotateY(15deg) rotateZ(0deg); }
            100% { transform: rotateX(15deg) rotateY(15deg) rotateZ(360deg); }
        }

        /* Central Logo Image */
        .loader-logo {
            position: absolute;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            z-index: 10;
            box-shadow: 0 0 20px rgba(255, 102, 0, 0.4), inset 0 0 10px rgba(255, 255, 255, 0.3);
            border: 3px solid rgba(255, 255, 255, 0.2);
            animation: pulse-logo 2s ease-in-out infinite, float-logo 3s ease-in-out infinite;
        }

        @keyframes pulse-logo {
            0%, 100% { transform: scale(1) translateZ(0); box-shadow: 0 0 20px rgba(255, 102, 0, 0.4); }
            50% { transform: scale(1.1) translateZ(20px); box-shadow: 0 0 40px rgba(255, 51, 102, 0.8), 0 0 20px rgba(136, 68, 238, 0.6); border-color: rgba(255, 255, 255, 0.5); }
        }

        @keyframes float-logo {
            0%, 100% { top: 50px; }
            50% { top: 45px; }
        }

        .loader-text {
            font-size: 1.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, #ff6600, #ff3366, #8844ee);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: 4px;
            text-transform: uppercase;
            animation: pulse-text 1.5s infinite;
            margin-bottom: 20px;
            text-shadow: 0 0 20px rgba(136, 68, 238, 0.4);
        }

        .loading-bar-container {
            width: 300px;
            height: 8px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            overflow: hidden;
            position: relative;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.5), 0 0 10px rgba(0,0,0,0.2);
            margin-bottom: 25px;
        }

        .loading-bar {
            height: 100%;
            width: 0%;
            background: linear-gradient(90deg, #ff6600, #ff3366, #8844ee, #4e73df);
            background-size: 300% 100%;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(255, 51, 102, 0.9);
            animation: fillBar 4.5s cubic-bezier(0.4, 0, 0.2, 1) forwards, shimmerBar 2s linear infinite;
        }

        .loader-quote {
            color: rgba(255, 255, 255, 0.95);
            font-size: 1.1rem;
            font-style: italic;
            font-weight: 400;
            letter-spacing: 1px;
            text-align: center;
            max-width: 450px;
            opacity: 0;
            animation: fadeQuote 4.5s ease-in-out forwards;
            text-shadow: 0 2px 10px rgba(0,0,0,0.8);
        }

        @keyframes pulse-text { 0%, 100% { opacity: 1; filter: brightness(1.2); } 50% { opacity: 0.6; filter: brightness(0.8); } }
        @keyframes fillBar { 0% { width: 0%; } 20% { width: 35%; } 50% { width: 70%; } 80% { width: 92%; } 100% { width: 100%; } }
        @keyframes shimmerBar { 0% { background-position: 100% 0; } 100% { background-position: -100% 0; } }
        @keyframes fadeQuote { 0% { opacity: 0; transform: translateY(15px); } 15% { opacity: 1; transform: translateY(0); } 85% { opacity: 1; transform: translateY(0); } 100% { opacity: 0; transform: translateY(-15px); } }

        /* ===== IMPRESSIVE 3D BACKGROUND STYLING ===== */
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

        /* 3D Infinite Grid Floor */
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

        /* Parallax Layer */
        .layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            transform-style: preserve-3d;
            transition: transform 0.1s ease-out; 
        }

        /* Floating Elements */
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

        /* ===== Navbar ===== */
        .navbar-custom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 40px;
            background: rgba(0, 0, 0, 0.85);
            backdrop-filter: blur(12px);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 15px;
            text-decoration: none;
        }

        .navbar-brand .logo {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            box-shadow: 0 0 20px rgba(255, 165, 0, 0.3);
            transition: transform 0.5s ease;
            object-fit: cover;
        }

        .navbar-brand .logo:hover {
            transform: rotate(360deg) scale(1.2);
        }

        .brand-name {
            font-size: 24px;
            font-weight: 800;
            background: linear-gradient(90deg, #ff7b00, #ffcc00, #ff7b00);
            background-size: 200% auto;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: shine 3s linear infinite;
            letter-spacing: 2px;
        }

        @keyframes shine {
            0% { background-position: 0% center; }
            100% { background-position: 200% center; }
        }

        /* ===== STYLISH THEME TOGGLE BUTTON ===== */
        .theme-toggle-btn {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            border: 2px solid var(--secondary);
            background: rgba(255, 255, 255, 0.1);
            color: var(--secondary);
            font-size: 1.3rem;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 15px rgba(255, 102, 0, 0.4);
            position: relative;
            overflow: hidden;
        }

        .theme-toggle-btn:hover {
            transform: rotate(30deg) scale(1.1);
            background: var(--gradient-1);
            color: white;
            border-color: transparent;
            box-shadow: 0 0 25px rgba(255, 51, 102, 0.6);
        }

        [data-bs-theme="dark"] .theme-toggle-btn {
            border-color: #8844ee;
            color: #8844ee;
            box-shadow: 0 0 15px rgba(136, 68, 238, 0.4);
            background: rgba(0, 0, 0, 0.3);
        }

        [data-bs-theme="dark"] .theme-toggle-btn:hover {
            background: var(--gradient-2);
            color: white;
            border-color: transparent;
            box-shadow: 0 0 25px rgba(136, 68, 238, 0.6);
        }

        /* ===== Hero Section ===== */
        .hero-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px 20px;
            position: relative;
            z-index: 1;
        }

        .hero-content {
            text-align: center;
            max-width: 850px;
            width: 100%;
        }

        .hero-badge {
            display: inline-block;
            background: linear-gradient(135deg, rgba(255, 102, 0, 0.2), rgba(255, 51, 102, 0.2));
            border: 1px solid rgba(255, 102, 0, 0.3);
            padding: 8px 24px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--secondary);
            margin-bottom: 25px;
            letter-spacing: 1px;
            text-transform: uppercase;
            backdrop-filter: blur(4px);
        }

        .hero-title {
            font-size: 4.8rem;
            font-weight: 900;
            margin-bottom: 20px;
            line-height: 1.1;
        }

        .hero-title .highlight {
            display: inline-block;
            background: var(--gradient-1);
            background-size: 300% 300%;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: gradientShift 5s ease-in-out infinite;
        }

        @keyframes gradientShift {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .hero-subtitle {
            font-size: 1.5rem;
            opacity: 0.85;
            max-width: 650px;
            margin: 0 auto 25px;
            line-height: 1.8;
            font-weight: 300;
        }

        .hero-description {
            font-size: 1.1rem;
            opacity: 0.7;
            max-width: 600px;
            margin: 0 auto 40px;
            line-height: 1.8;
        }

        .hero-actions {
            display: flex;
            gap: 16px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-get-started {
            padding: 16px 48px;
            font-size: 1.1rem;
            font-weight: 700;
            border: none;
            border-radius: 50px;
            background: var(--gradient-1);
            color: white;
            cursor: pointer;
            transition: all 0.4s ease;
            box-shadow: 0 8px 30px rgba(255, 102, 0, 0.35);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            position: relative;
            overflow: hidden;
        }

        .btn-get-started::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.6s ease;
        }

        .btn-get-started:hover::before {
            left: 100%;
        }

        .btn-get-started:hover {
            transform: translateY(-5px) scale(1.03);
            box-shadow: 0 12px 40px rgba(255, 102, 0, 0.5);
            color: white;
        }

        .btn-learn-more {
            padding: 16px 40px;
            font-size: 1.1rem;
            font-weight: 600;
            border: 2px solid var(--border-color);
            border-radius: 50px;
            background: var(--card-bg);
            color: var(--bs-body-color);
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-learn-more:hover {
            border-color: var(--secondary);
            color: var(--secondary);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .hero-scroll-indicator {
            margin-top: 50px;
            animation: bounceDown 2s ease-in-out infinite;
        }

        .hero-scroll-indicator a {
            color: var(--bs-body-color);
            opacity: 0.4;
            font-size: 1.5rem;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .hero-scroll-indicator a:hover {
            opacity: 1;
            color: var(--secondary);
        }

        @keyframes bounceDown {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(10px); }
        }

        /* ===== Section Styles ===== */
        .section-padding {
            padding: 80px 20px;
            position: relative;
            z-index: 2;
        }

        .section-title {
            text-align: center;
            font-size: 2.8rem;
            font-weight: 800;
            margin-bottom: 15px;
        }

        .section-title .highlight {
            background: var(--gradient-1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-size: 200% 200%;
            animation: gradientShift 4s ease-in-out infinite;
        }

        .section-subtitle {
            text-align: center;
            opacity: 0.7;
            margin-bottom: 50px;
            font-size: 1.15rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        /* ===== Features Section ===== */
        .features-section {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border-top: 1px solid var(--border-color);
            border-bottom: 1px solid var(--border-color);
        }

        .feature-card {
            background: var(--bs-body-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 35px 25px;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            height: 100%;
            position: relative;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--gradient-1);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .feature-card:hover::before {
            opacity: 1;
        }

        .feature-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.12);
            border-color: transparent;
        }

        .feature-icon {
            font-size: 3.2rem;
            margin-bottom: 20px;
            background: var(--gradient-1);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: inline-block;
        }

        .feature-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .feature-desc {
            opacity: 0.8;
            font-size: 0.95rem;
            line-height: 1.6;
        }

        /* ===== Role Info Section ===== */
        .role-info-section {
            background: transparent;
        }

        .role-info-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 35px 30px;
            transition: all 0.4s ease;
            height: 100%;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .role-info-card::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(255, 102, 0, 0.05), transparent 70%);
            pointer-events: none;
        }

        .role-info-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.08);
            border-color: var(--secondary);
        }

        .role-info-card .icon {
            font-size: 3rem;
            margin-bottom: 15px;
            display: block;
        }

        .role-info-card .student-icon { color: var(--primary); }
        .role-info-card .librarian-icon { color: var(--secondary); }

        .role-info-card h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .role-info-card p {
            opacity: 0.8;
            margin-bottom: 15px;
            font-size: 0.95rem;
            line-height: 1.6;
        }

        .role-info-card ul {
            list-style: none;
            padding: 0;
            text-align: left;
        }

        .role-info-card ul li {
            padding: 6px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.92rem;
        }

        .role-info-card ul li i {
            color: #10b981;
            width: 20px;
        }

        /* ===== CTA Section ===== */
        .cta-section {
            background: var(--card-bg);
            border-top: 1px solid var(--border-color);
            padding: 70px 20px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .cta-section::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle at 30% 50%, rgba(255, 102, 0, 0.05), transparent 50%);
            pointer-events: none;
        }

        .cta-section h2 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 15px;
            position: relative;
        }

        .cta-section p {
            opacity: 0.7;
            max-width: 600px;
            margin: 0 auto 30px;
            font-size: 1.1rem;
            line-height: 1.7;
            position: relative;
        }

        /* ===== Footer ===== */
        .footer {
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            color: white;
            position: relative;
            padding-top: 60px;
            z-index: 2;
            overflow: hidden;
        }

        .footer-wave {
            position: absolute;
            top: -2px;
            left: 0;
            width: 100%;
            overflow: hidden;
            line-height: 0;
            transform: rotate(180deg);
        }

        .footer-wave svg {
            position: relative;
            display: block;
            width: calc(100% + 1.3px);
            height: 50px;
        }

        .footer::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle at 30% 50%, rgba(255, 102, 0, 0.05), transparent 50%);
            pointer-events: none;
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px 30px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            position: relative;
            z-index: 1;
        }

        .footer-heading {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            position: relative;
        }

        .footer-heading::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 40px;
            height: 3px;
            background: var(--gradient-1);
            border-radius: 3px;
        }

        .footer-icon {
            font-size: 20px;
            color: var(--secondary);
            margin-right: 12px;
            background: rgba(255, 102, 0, 0.15);
            padding: 8px;
            border-radius: 50%;
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .footer-heading h3 {
            font-size: 1.1rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 0;
        }

        .footer-links {
            list-style: none;
            padding: 0;
        }

        .footer-links li {
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }

        .footer-links li:hover {
            transform: translateX(6px);
        }

        .footer-links a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            display: flex;
            align-items: center;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            padding: 4px 0;
        }

        .footer-links a:hover {
            color: var(--secondary);
        }

        .footer-links a i {
            margin-right: 10px;
            font-size: 11px;
            color: var(--secondary);
            opacity: 0.6;
        }

        .contact-info {
            list-style: none;
            padding: 0;
        }

        .contact-item {
            display: flex;
            margin-bottom: 14px;
            padding: 6px 10px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .contact-item:hover {
            background: rgba(255, 255, 255, 0.05);
        }

        .contact-icon {
            font-size: 16px;
            color: var(--secondary);
            margin-right: 14px;
            margin-top: 2px;
            width: 20px;
            text-align: center;
        }

        .contact-label {
            display: block;
            font-weight: 600;
            color: var(--secondary);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .contact-value,
        .contact-link {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.85rem;
        }

        .contact-link {
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .contact-link:hover {
            color: var(--secondary);
        }

        .newsletter-box {
            background: rgba(255, 255, 255, 0.04);
            border-radius: 12px;
            padding: 18px;
            border: 1px solid rgba(255, 255, 255, 0.06);
        }

        .newsletter-text {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 14px;
            line-height: 1.6;
            font-size: 0.9rem;
        }

        .newsletter-form {
            display: flex;
            border-radius: 50px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: all 0.3s ease;
        }

        .newsletter-form:focus-within {
            border-color: var(--secondary);
            box-shadow: 0 0 20px rgba(255, 102, 0, 0.1);
        }

        .newsletter-form .form-control {
            flex: 1;
            padding: 10px 18px;
            border: none;
            outline: none;
            font-size: 0.9rem;
            background: transparent;
            color: white;
        }

        .newsletter-form .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }

        .newsletter-form .subscribe-btn {
            background: var(--gradient-1);
            color: white;
            border: none;
            padding: 0 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .newsletter-form .subscribe-btn:hover {
            opacity: 0.9;
            transform: scale(1.02);
        }

        .copyright-section {
            background: rgba(0, 0, 0, 0.3);
            padding: 18px 0;
            margin-top: 40px;
            border-top: 1px solid rgba(255, 255, 255, 0.04);
        }

        .copyright-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .copyright-text {
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.8rem;
            margin-bottom: 8px;
        }

        .footer-legal {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 12px;
        }

        .legal-link {
            color: rgba(255, 255, 255, 0.4);
            text-decoration: none;
            font-size: 0.75rem;
            transition: color 0.3s ease;
        }

        .legal-link:hover {
            color: var(--secondary);
        }

        .legal-separator {
            color: rgba(255, 255, 255, 0.15);
        }

        .back-to-top {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: var(--gradient-1);
            color: white;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            box-shadow: 0 4px 20px rgba(255, 102, 0, 0.35);
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 999;
        }

        .back-to-top.active {
            opacity: 1;
            visibility: visible;
        }

        .back-to-top:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 8px 30px rgba(255, 102, 0, 0.5);
        }

        /* ===== Responsive ===== */
        @media (max-width: 992px) {
            .hero-title { font-size: 3.5rem; }
            .section-title { font-size: 2.2rem; }
            .footer-container { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 768px) {
            .navbar-custom { padding: 10px 20px; }
            .brand-name { font-size: 18px; }
            .hero-title { font-size: 2.8rem; }
            .hero-subtitle { font-size: 1.2rem; }
            .hero-description { font-size: 0.95rem; }
            .btn-get-started { padding: 14px 32px; font-size: 1rem; }
            .btn-learn-more { padding: 14px 28px; font-size: 1rem; }
            .section-title { font-size: 1.8rem; }
            .section-padding { padding: 50px 15px; }
            .hero-actions { flex-direction: column; align-items: center; }
            .float-book, .float-page, .float-dot, .gradient-orb { display: none; }
            .bg-grid { display: none; }
            .footer-container { grid-template-columns: 1fr; gap: 30px; }
            .footer-section { text-align: center; }
            .footer-heading { justify-content: center; }
            .footer-heading::after { left: 50%; transform: translateX(-50%); }
            .footer-links li { justify-content: center; }
            .footer-links a { justify-content: center; }
            .contact-item { flex-direction: column; align-items: center; text-align: center; }
            .contact-icon { margin-right: 0; margin-bottom: 5px; }
            .newsletter-form { flex-direction: column; border-radius: 16px; }
            .newsletter-form .form-control { text-align: center; padding: 14px; }
            .newsletter-form .subscribe-btn { padding: 14px; justify-content: center; border-radius: 0 0 16px 16px; }
            .hero-scroll-indicator { display: none; }
        }

        @media (max-width: 480px) {
            .hero-title { font-size: 2rem; }
            .navbar-brand .logo { width: 35px; height: 35px; }
            .brand-name { font-size: 16px; }
            .section-title { font-size: 1.5rem; }
            .feature-card { padding: 25px 18px; }
            .role-info-card { padding: 25px 18px; }
            .theme-toggle-btn { width: 40px; height: 40px; font-size: 1rem; }
            .loader-wrapper { width: 130px; height: 130px; }
            .loader-logo { width: 60px; height: 60px; }
            .loader-text { font-size: 1.1rem; }
            .loading-bar-container { width: 220px; }
            .loader-quote { font-size: 0.9rem; padding: 0 20px; }
        }
    </style>
</head>
<body>

    <!-- ===== ENHANCED 3D BACKGROUND ===== -->
    <!-- Positioned at root so it provides the background for both the loader and the main page -->
    <div class="bg-3d">
        <!-- 3D Infinite Grid Floor -->
        <div class="bg-grid"></div>
        
        <!-- Interactive 3D Parallax Layer -->
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

    <!-- ===== ULTRA-IMPRESSIVE PRELOADER ===== -->
    <div id="preloader">
        <div class="loader-wrapper">
            <!-- 3D Spinning Orbits -->
            <div class="orbit"></div>
            <div class="orbit"></div>
            <div class="orbit"></div>
            
            <!-- Central Pulsing Logo -->
            <img src="logo2.jpg" alt="Library Logo" class="loader-logo">
        </div>
        
        <div class="loader-text">Loading Library...</div>
        
        <!-- Animated Glowing Progress Bar -->
        <div class="loading-bar-container">
            <div class="loading-bar"></div>
        </div>
        
        <!-- Rotating Inspirational Quote -->
        <div class="loader-quote" id="loaderQuote">"Today a reader, tomorrow a leader."</div>
    </div>

    <!-- ===== Navbar ===== -->
    <nav class="navbar-custom">
        <a href="#" class="navbar-brand">
            <img src="logo2.jpg" alt="Library Logo" class="logo">
            <span class="brand-name">Library Management</span>
        </a>
        <button class="theme-toggle-btn" id="themeToggle" title="Toggle Light/Dark Mode">
            <i class="fas fa-moon"></i>
        </button>
    </nav>

    <!-- ===== Hero Section ===== -->
    <section class="hero-section" id="home">
        <div class="hero-content">
            <div class="hero-badge" data-aos="fade-down" data-aos-delay="200">
                <i class="fas fa-rocket me-2"></i> Smart Library Solution
            </div>
            <h1 class="hero-title" data-aos="zoom-in" data-aos-delay="400">
                Welcome to the <br>
                <span class="highlight">Smart & Secure</span><br>
                Library Management System
            </h1>
            <p class="hero-subtitle" data-aos="fade-up" data-aos-delay="600">
                Experience hassle-free library management with the best security and automation
            </p>
            <p class="hero-description" data-aos="fade-up" data-aos-delay="700">
                A comprehensive digital solution for managing books, students, and library operations efficiently.
            </p>
            <div class="hero-actions" data-aos="fade-up" data-aos-delay="800">
                <a href="ChooseRole.jsp" class="btn-get-started">
                    <i class="fas fa-rocket"></i> Get Started
                </a>
                <a href="#features" class="btn-learn-more">
                    <i class="fas fa-info-circle"></i> Learn More
                </a>
            </div>
            <div class="hero-scroll-indicator" data-aos="fadeIn" data-aos-delay="1000">
                <a href="#features">
                    <i class="fas fa-chevron-down"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- ===== Features Section ===== -->
    <section class="features-section section-padding" id="features">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">
                Why Choose <span class="highlight">Our System</span>?
            </h2>
            <p class="section-subtitle" data-aos="fade-up" data-aos-delay="100">
                Powerful features designed for modern library management
            </p>
            <div class="row g-4">
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-book-open"></i></div>
                        <h5 class="feature-title">Book Management</h5>
                        <p class="feature-desc">Add, update, and organize books with ease. Track availability and manage catalog efficiently.</p>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-user-graduate"></i></div>
                        <h5 class="feature-title">Student Management</h5>
                        <p class="feature-desc">Register and manage student accounts, track borrowing history, and handle fines seamlessly.</p>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-exchange-alt"></i></div>
                        <h5 class="feature-title">Issue & Return</h5>
                        <p class="feature-desc">Streamline book issuing and returning with automated fine calculation and real-time updates.</p>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-file-alt"></i></div>
                        <h5 class="feature-title">Reports & Analytics</h5>
                        <p class="feature-desc">Generate detailed reports on issued books, pending fines, and defaulter students.</p>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-shield-alt"></i></div>
                        <h5 class="feature-title">Secure & Reliable</h5>
                        <p class="feature-desc">Role-based access control with encrypted authentication for data security.</p>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-cloud-upload-alt"></i></div>
                        <h5 class="feature-title">Bulk Import</h5>
                        <p class="feature-desc">Import student and book records from Excel files with just a few clicks.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== Role Info Section ===== -->
    <section class="role-info-section section-padding" id="roles">
        <div class="container">
            <h2 class="section-title" data-aos="fade-up">
                Who Can Use <span class="highlight">This System</span>?
            </h2>
            <p class="section-subtitle" data-aos="fade-up" data-aos-delay="100">
                Two primary roles designed for different user needs
            </p>
            <div class="row g-4">
                <div class="col-md-6" data-aos="fade-right" data-aos-delay="100">
                    <div class="role-info-card">
                        <span class="icon student-icon"><i class="fas fa-user-graduate"></i></span>
                        <h3>Student</h3>
                        <p>Access library services, issue books, view records, and manage your account.</p>
                        <ul>
                            <li><i class="fas fa-check-circle"></i> Browse and search books</li>
                            <li><i class="fas fa-check-circle"></i> Issue and return books</li>
                            <li><i class="fas fa-check-circle"></i> View issued books history</li>
                            <li><i class="fas fa-check-circle"></i> Track fines and due dates</li>
                            <li><i class="fas fa-check-circle"></i> Update profile and settings</li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6" data-aos="fade-left" data-aos-delay="200">
                    <div class="role-info-card">
                        <span class="icon librarian-icon"><i class="fas fa-user-tie"></i></span>
                        <h3>Librarian</h3>
                        <p>Manage library operations, handle books, students, and generate reports.</p>
                        <ul>
                            <li><i class="fas fa-check-circle"></i> Add and manage books</li>
                            <li><i class="fas fa-check-circle"></i> Register and manage students</li>
                            <li><i class="fas fa-check-circle"></i> Issue and return books</li>
                            <li><i class="fas fa-check-circle"></i> View defaulters and pending fines</li>
                            <li><i class="fas fa-check-circle"></i> Generate reports and analytics</li>
                            <li><i class="fas fa-check-circle"></i> Bulk import data via Excel</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== CTA Section ===== -->
    <section class="cta-section" data-aos="fade-up">
        <div class="container">
            <h2>Ready to Get Started?</h2>
            <p>Join thousands of students and librarians who trust our Library Management System.</p>
            <a href="ChooseRole.jsp" class="btn-get-started">
                <i class="fas fa-rocket me-2"></i> Get Started Now
            </a>
        </div>
    </section>

    <!-- ===== Footer ===== -->
    <footer class="footer">
        <div class="footer-wave">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
                <path fill="#ff6600" fill-opacity="0.2" d="M0,224L48,213.3C96,203,192,181,288,176C384,171,480,181,576,197.3C672,213,768,235,864,224C960,213,1056,171,1152,154.7C1248,139,1344,149,1392,154.7L1440,160L1440,0L1392,0C1344,0,1248,0,1152,0C1056,0,960,0,864,0C768,0,672,0,576,0C480,0,384,0,288,0C192,0,96,0,48,0L0,0Z"></path>
            </svg>
        </div>

        <div class="footer-container">
            <!-- Quick Links -->
            <div class="footer-section">
                <div class="footer-heading">
                    <span class="footer-icon"><i class="fas fa-link"></i></span>
                    <h3>Quick Links</h3>
                </div>
                <ul class="footer-links">
                    <li><a href="#home"><i class="fas fa-chevron-right"></i> Home</a></li>
                    <li><a href="ChooseRole.jsp"><i class="fas fa-chevron-right"></i> Choose Role</a></li>
                    <li><a href="Login.jsp"><i class="fas fa-chevron-right"></i> Admin Login</a></li>
                    <li><a href="StudentSignup.jsp"><i class="fas fa-chevron-right"></i> Student Login</a></li>
                    <li><a href="#features"><i class="fas fa-chevron-right"></i> Features</a></li>
                </ul>
            </div>

            <!-- Contact Info -->
            <div class="footer-section">
                <div class="footer-heading">
                    <span class="footer-icon"><i class="fas fa-envelope-open-text"></i></span>
                    <h3>Contact Info</h3>
                </div>
                <ul class="contact-info">
                    <li>
                        <div class="contact-item">
                            <span class="contact-icon"><i class="fas fa-map-marker-alt"></i></span>
                            <div>
                                <span class="contact-label">Address</span>
                                <span class="contact-value">Kanpur, UP, India</span>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="contact-item">
                            <span class="contact-icon"><i class="fas fa-phone-alt"></i></span>
                            <div>
                                <span class="contact-label">Phone</span>
                                <a href="tel:+917318413600" class="contact-link">+91 7318413600</a>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="contact-item">
                            <span class="contact-icon"><i class="fas fa-envelope"></i></span>
                            <div>
                                <span class="contact-label">Email</span>
                                <a href="mailto:aadityasingh.knp@gmail.com" class="contact-link">aadityasingh.knp@gmail.com</a>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="contact-item">
                            <span class="contact-icon"><i class="fas fa-clock"></i></span>
                            <div>
                                <span class="contact-label">Hours</span>
                                <span class="contact-value">Mon-Sat: 9:00 AM - 6:00 PM</span>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>

            <!-- Newsletter -->
            <div class="footer-section">
                <div class="footer-heading">
                    <span class="footer-icon"><i class="fas fa-paper-plane"></i></span>
                    <h3>Newsletter</h3>
                </div>
                <div class="newsletter-box">
                    <p class="newsletter-text">
                        Subscribe for latest updates and book releases.
                    </p>
                    <form class="newsletter-form" onsubmit="event.preventDefault(); Swal.fire({title:'Subscribed!',text:'Thank you for subscribing.',icon:'success',timer:2000,showConfirmButton:false});">
                        <input type="email" class="form-control" placeholder="Your Email" required>
                        <button type="submit" class="subscribe-btn">
                            <i class="fas fa-paper-plane"></i> Subscribe
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Copyright -->
        <div class="copyright-section">
            <div class="copyright-container">
                <p class="copyright-text">
                    &copy; <span id="current-year">2025</span> Library Management System. All Rights Reserved.
                </p>
                <div class="footer-legal">
                    <a href="#" class="legal-link">Privacy Policy</a>
                    <span class="legal-separator">|</span>
                    <a href="#" class="legal-link">Terms of Service</a>
                    <span class="legal-separator">|</span>
                    <a href="#" class="legal-link">Sitemap</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Back to Top -->
    <button class="back-to-top" onclick="window.scrollTo({top:0,behavior:'smooth'})">
        <i class="fas fa-arrow-up"></i>
    </button>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        // ===== PRELOADER SCRIPT (4.5 Seconds) =====
        window.addEventListener('load', function() {
            
            // Randomly pick an inspirational study quote to display
            const quotes = [
                '"Today a reader, tomorrow a leader." — Margaret Fuller',
                '"A room without books is like a body without a soul." — Cicero',
                '"Education is the most powerful weapon to change the world." — Nelson Mandela',
                '"The only thing that you absolutely have to know, is the location of the library." — Albert Einstein'
            ];
            const randomQuote = quotes[Math.floor(Math.random() * quotes.length)];
            const quoteElement = document.getElementById('loaderQuote');
            if(quoteElement) quoteElement.innerText = randomQuote;

            const preloader = document.getElementById('preloader');
            
            // Give the user 4.5 seconds to watch the loading bar fill and read the quote
            if(preloader) {
                setTimeout(function() {
                    preloader.style.opacity = '0';
                    preloader.style.visibility = 'hidden';
                    
                    // Wait for CSS transition to finish before removing from DOM
                    setTimeout(() => {
                        preloader.style.display = 'none';
                    }, 800);
                }, 4500); 
            }
        });

        // ===== Initialize AOS =====
        AOS.init({
            duration: 800,
            once: true,
            offset: 50,
            easing: 'ease-in-out'
        });

        document.addEventListener("DOMContentLoaded", function() {
            // ===== Interactive 3D Parallax Effect =====
            const parallaxLayer = document.getElementById('parallaxLayer');
            
            if(parallaxLayer) {
                document.addEventListener('mousemove', function(e) {
                    // Calculate mouse position relative to center of screen
                    const x = (window.innerWidth / 2 - e.pageX) / 40;
                    const y = (window.innerHeight / 2 - e.pageY) / 40;
                    
                    // Apply 3D rotation based on mouse movement
                    if (window.innerWidth > 768) { // Only run on desktop to save mobile performance
                        parallaxLayer.style.transform = `rotateY(${x}deg) rotateX(${y}deg)`;
                    }
                });
            }

            // ===== Theme Toggle =====
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
                
                // Add a small rotation effect during click
                icon.style.transform = 'rotate(180deg)';
                setTimeout(() => icon.style.transform = 'rotate(0deg)', 300);
                
                icon.className = newTheme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
            });

            initTheme();

            // ===== Back to Top =====
            const backToTop = document.querySelector('.back-to-top');
            window.addEventListener('scroll', function() {
                backToTop.classList.toggle('active', window.pageYOffset > 300);
            });

            // ===== Set current year =====
            const yearElement = document.getElementById('current-year');
            if(yearElement) {
                yearElement.textContent = new Date().getFullYear();
            }

            // ===== Smooth scroll for anchor links =====
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function(e) {
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        e.preventDefault();
                        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                });
            });
        });
    </script>
</body>
</html>