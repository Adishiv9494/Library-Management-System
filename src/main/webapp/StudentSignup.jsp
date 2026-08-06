<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Student Portal - Login & Signup</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap');

        /* ===== Root Variables ===== */
        :root {
            --primary: #4e73df;
            --secondary: #ff6600;
            --accent: #ff3366;
            --gradient-1: linear-gradient(135deg, #ff6600, #ff3366, #8844ee);
            --gradient-2: linear-gradient(135deg, #4e73df, #8844ee);
            --text-light: #333;
            --text-dark: #f0f0f0;
            --body-bg-light: #f4f6f9;
            --body-bg-dark: #0a0514;
            --card-bg-light: rgba(255, 255, 255, 0.95);
            --card-bg-dark: rgba(26, 26, 46, 0.95);
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
            font-family: 'Poppins', 'sans-serif';
        }

        body {
            background-color: var(--bs-body-bg);
            background-image: radial-gradient(var(--mesh-color) 1.5px, transparent 1.5px), radial-gradient(var(--mesh-color) 1.5px, transparent 1.5px);
            background-size: 30px 30px;
            background-position: 0 0, 15px 15px;
            color: var(--bs-body-color);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            transition: background-color 0.5s ease, color 0.5s ease;
            position: relative;
            overflow: hidden;
            padding: 20px;
        }

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

        /* ===== THEME TOGGLE BUTTON ===== */
        #mode-toggle {
            position: fixed; top: 20px; right: 20px; width: 44px; height: 44px; border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.15); background: rgba(255,255,255,0.08); backdrop-filter: blur(12px);
            color: #fff; font-size: 1.2rem; cursor: pointer; transition: all 0.4s ease;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2); z-index: 1000; display: flex; align-items: center; justify-content: center;
        }
        #mode-toggle:hover { transform: rotate(30deg) scale(1.08); border-color: #a78bfa; box-shadow: 0 6px 30px rgba(167,139,250,0.3); }

        /* ===== CONTAINER ===== */
        .container {
            position: relative; width: 1300px; height: 730px;
            background: var(--card-bg); backdrop-filter: blur(24px);
            border-radius: 28px; box-shadow: 0 30px 80px rgba(0,0,0,0.15);
            overflow: hidden; margin: 2px; z-index: 1; border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }
        body.dark-mode .container { box-shadow: 0 25px 60px rgba(0,0,0,0.6); }

        /* ===== FORM BOX ===== */
        .form-box {
            position: absolute; top: 0; width: 50%; height: 100%; background: transparent;
            display: flex; align-items: center; color: var(--bs-body-color); text-align: center; padding: 40px;
            transition: all 0.7s cubic-bezier(0.65,0,0.35,1); z-index: 2;
        }
        .form-box.login { left: 0; visibility: visible; opacity: 1; }
        .form-box.register { left: 50%; visibility: hidden; opacity: 0; }
        .container.active .form-box.login { visibility: hidden; opacity: 0; }
        .container.active .form-box.register { visibility: visible; opacity: 1; }

        /* ===== FORMS ===== */
        form { width: 100%; height: 100%; overflow-y: auto; padding-right: 10px; }
        form::-webkit-scrollbar { width: 5px; }
        form::-webkit-scrollbar-track { background: rgba(0,0,0,0.04); border-radius: 10px; }
        form::-webkit-scrollbar-thumb { background: linear-gradient(135deg, #7c3aed, #f472b6); border-radius: 10px; }
        body.dark-mode form::-webkit-scrollbar-track { background: rgba(255,255,255,0.03); }

        .container h1 {
            font-size: 34px; margin-bottom: 18px;
            background: linear-gradient(135deg, #7c3aed, #f472b6, #fb923c);
            -webkit-background-clip: text; background-clip: text; color: transparent; font-weight: 800;
        }

        .input-row { display: flex; gap: 14px; margin-bottom: 12px; }
        .input-box { position: relative; margin-bottom: 14px; flex: 1; }
        .input-box input, .input-box select {
            width: 100%; padding: 14px 48px 14px 18px;
            background: rgba(0,0,0,0.03); border-radius: 14px;
            border: 2px solid rgba(0,0,0,0.06); outline: none;
            font-size: 15px; color: var(--bs-body-color); font-weight: 500;
            transition: all 0.3s ease; appearance: none; -webkit-appearance: none;
        }
        .input-box select { padding-right: 48px; cursor: pointer; }
        .input-box input:focus, .input-box select:focus {
            border-color: #7c3aed; box-shadow: 0 0 25px rgba(124,58,237,0.12);
            background: rgba(255,255,255,0.8);
        }
        body.dark-mode .input-box input, body.dark-mode .input-box select { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.08); }
        body.dark-mode .input-box input:focus, body.dark-mode .input-box select:focus { background: rgba(255,255,255,0.08); border-color: #a78bfa; box-shadow: 0 0 25px rgba(167,139,250,0.15); }
        .input-box input::placeholder { color: #999; font-weight: 400; }
        .input-box i {
            position: absolute; right: 16px; top: 50%; transform: translateY(-50%);
            font-size: 19px; color: #999; cursor: pointer; transition: color 0.3s ease;
        }
        .input-box i:hover { color: #7c3aed; }
        .input-box .bx-custom-select { right: 16px; pointer-events: none; }

        .floating-label {
            position: absolute; pointer-events: none; left: 18px; top: 14px;
            transition: 0.2s ease all; color: #999; font-size: 15px; background: transparent; padding: 0 4px;
        }
        .input-box input:focus~.floating-label, .input-box input:not(:placeholder-shown)~.floating-label,
        .input-box select:focus~.floating-label, .input-box select[data-filled="true"]~.floating-label {
            top: -10px; left: 14px; font-size: 11px; background: var(--card-bg);
            padding: 0 6px; color: #7c3aed; border-radius: 4px; font-weight: 600;
        }
        body.dark-mode .input-box input:focus~.floating-label, body.dark-mode .input-box input:not(:placeholder-shown)~.floating-label,
        body.dark-mode .input-box select[data-filled="true"]~.floating-label { color: #a78bfa; }

        .forget-link { margin: -8px 0 18px; text-align: right; }
        .forget-link a { font-size: 13px; color: #888; text-decoration: none; transition: color 0.3s ease; font-weight: 500; }
        .forget-link a:hover { color: #7c3aed; text-decoration: underline; }
        body.dark-mode .forget-link a { color: #aaa; }
        body.dark-mode .forget-link a:hover { color: #a78bfa; }

        .btn {
            width: 75%; height: 50px; background: linear-gradient(135deg, #7c3aed, #a78bfa);
            border-radius: 50px; box-shadow: 0 8px 30px rgba(124,58,237,0.25);
            cursor: pointer; font-size: 17px; color: #fff; font-weight: 700; border: none;
            transition: all 0.4s ease; position: relative; overflow: hidden; letter-spacing: 0.5px;
        }
        .btn::before {
            content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent); transition: left 0.6s ease;
        }
        .btn:hover::before { left: 100%; }
        .btn:hover { transform: translateY(-3px) scale(1.02); box-shadow: 0 12px 40px rgba(124,58,237,0.4); }
        .btn:disabled { opacity: 0.5; cursor: not-allowed; transform: none !important; box-shadow: 0 4px 15px rgba(124,58,237,0.15); }
        body.dark-mode .btn { box-shadow: 0 8px 30px rgba(124,58,237,0.3); }
        body.dark-mode .btn:hover { box-shadow: 0 12px 40px rgba(124,58,237,0.5); }

        /* ===== ENHANCED FORM IMAGE ===== */
        .form-image {
            width: 90%; max-width: 350px; height: 190px; margin: 25px auto 15px auto; 
            display: block; border-radius: 20px; box-shadow: 0 12px 30px rgba(124, 58, 237, 0.15); 
            border: 2px solid rgba(124, 58, 237, 0.15); transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.4s ease; 
            object-fit: cover;
        }
        .form-image:hover { transform: translateY(-8px) scale(1.03); box-shadow: 0 18px 40px rgba(124, 58, 237, 0.3); border-color: rgba(124, 58, 237, 0.4); }
        body.dark-mode .form-image { box-shadow: 0 12px 30px rgba(0, 0, 0, 0.6); border-color: rgba(167, 139, 250, 0.15); }
        body.dark-mode .form-image:hover { box-shadow: 0 18px 40px rgba(167, 139, 250, 0.35); border-color: rgba(167, 139, 250, 0.5); }

        .container p { font-size: 13px; margin: 18px 0; color: #999; }
        body.dark-mode .container p { color: #aaa; }

        .captcha-container { display: flex; align-items: center; gap: 10px; margin: 18px 0; }
        .captcha-box {
            display: flex; align-items: center; background: rgba(0,0,0,0.03); border-radius: 14px;
            padding: 4px 14px; flex: 1; border: 2px solid rgba(0,0,0,0.06);
        }
        body.dark-mode .captcha-box { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.08); }
        .captcha-text {
            font-family: 'Courier New', monospace; font-size: 26px; font-weight: 800; letter-spacing: 6px;
            background: linear-gradient(135deg, #7c3aed, #f472b6, #fb923c);
            -webkit-background-clip: text; background-clip: text; color: transparent;
            flex: 1; text-align: center; user-select: none; padding: 4px 0;
        }
        body.dark-mode .captcha-text { background: linear-gradient(135deg, #a78bfa, #f472b6, #fb923c); -webkit-background-clip: text; background-clip: text; color: transparent; }
        .refresh-captcha { cursor: pointer; color: #999; font-size: 22px; transition: all 0.3s ease; }
        .refresh-captcha:hover { transform: rotate(90deg); color: #7c3aed; }
        body.dark-mode .refresh-captcha:hover { color: #a78bfa; }
        .captcha-input {
            flex: 1; padding: 14px 18px; background: rgba(0,0,0,0.03); border-radius: 14px;
            border: 2px solid rgba(0,0,0,0.06); outline: none; font-size: 15px; color: var(--bs-body-color);
            font-weight: 500; transition: all 0.3s ease; min-width: 110px;
        }
        .captcha-input:focus { border-color: #7c3aed; box-shadow: 0 0 25px rgba(124,58,237,0.12); background: rgba(255,255,255,0.8); }
        body.dark-mode .captcha-input { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.08); color: #f0f0f0; }
        body.dark-mode .captcha-input:focus { background: rgba(255,255,255,0.08); border-color: #a78bfa; box-shadow: 0 0 25px rgba(167, 139, 250, 0.15); }

        /* ===== TOGGLE BOX ===== */
        .toggle-box {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            z-index: 10; pointer-events: none; overflow: hidden;
        }
        .toggle-box::before {
            content: ''; position: absolute; left: 50%; width: 300%; height: 100%;
            background: linear-gradient(135deg, #7c3aed, #f472b6, #fb923c);
            border-radius: 150px; z-index: -1; transition: 1.8s cubic-bezier(0.65,0,0.35,1);
        }
        .container.active .toggle-box::before { left: -250%; }
        body.dark-mode .toggle-box::before { background: linear-gradient(135deg, #1e1b4b, #312e81, #4c1d95); }

        .toggle-panel {
            position: absolute; width: 50%; height: 100%; color: #fff;
            display: flex; flex-direction: column; justify-content: center; align-items: center;
            z-index: 11; transition: all 0.7s cubic-bezier(0.65,0,0.35,1);
            padding: 40px; text-align: center; pointer-events: auto;
        }
        .toggle-panel h1 { color: #fff; background: none; -webkit-background-clip: initial; background-clip: initial; font-size: 2.2rem; font-weight: 800; text-shadow: 0 2px 20px rgba(0,0,0,0.1); }
        .toggle-panel.toggle-left { left: -50%; transition-delay: 0.6s; }
        .container.active .toggle-panel.toggle-left { left: 0; transition-delay: 1.2s; }
        .toggle-panel.toggle-right { right: 0; transition-delay: 1.2s; }
        .container.active .toggle-panel.toggle-right { right: -50%; transition-delay: 0.6s; }
        .toggle-panel p { margin: 14px 0; color: rgba(255,255,255,0.9); font-size: 0.95rem; max-width: 320px; }
        .toggle-panel .btn {
            width: 160px; height: 46px; background: rgba(255,255,255,0.15);
            border: 2px solid rgba(255,255,255,0.4); border-radius: 50px;
            box-shadow: none; color: #fff; margin-top: 18px; font-weight: 600;
            backdrop-filter: blur(4px); pointer-events: auto; cursor: pointer;
        }
        .toggle-panel .btn:hover { background: rgba(255,255,255,0.25); transform: translateY(-2px); box-shadow: 0 8px 30px rgba(0,0,0,0.15); }
        .toggle-panel .btn::before { display: none; }

        /* ===== PASSWORD STRENGTH ===== */
        .password-feedback { font-size: 11px; margin-top: 4px; text-align: left; padding-left: 4px; transition: all 0.3s ease; font-weight: 500; }
        .password-strength { width: 100%; height: 4px; background: rgba(0,0,0,0.06); border-radius: 2px; margin-top: 6px; overflow: hidden; }
        .password-strength-bar { height: 100%; width: 0%; background: #ef4444; transition: width 0.3s ease, background 0.3s ease; }
        body.dark-mode .password-strength { background: rgba(255,255,255,0.06); }

        /* ===== TERMS ===== */
        .terms-container { display: flex; align-items: center; margin: 14px 0; text-align: left; gap: 10px; }
        .terms-container input[type="checkbox"] { width: 18px; height: 18px; accent-color: #7c3aed; cursor: pointer; flex-shrink: 0; transition: all 0.3s ease; }
        .terms-container input[type="checkbox"]:disabled { opacity: 0.4; cursor: not-allowed; }
        .terms-container label { font-size: 13px; color: #888; font-weight: 500; }
        body.dark-mode .terms-container label { color: #bbb; }
        .terms-container a { color: #7c3aed; text-decoration: none; font-weight: 600; cursor: pointer; }
        .terms-container a:hover { text-decoration: underline; }
        body.dark-mode .terms-container a { color: #a78bfa; }
        
        .bot-btn {
            background: rgba(124, 58, 237, 0.1); color: #7c3aed; border: 1px solid #7c3aed;
            padding: 5px 12px; border-radius: 20px; font-size: 12px; cursor: pointer;
            transition: all 0.3s ease; margin-bottom: 15px; display: inline-block;
        }
        .bot-btn:hover { background: #7c3aed; color: #fff; }
        body.dark-mode .bot-btn { border-color: #a78bfa; color: #a78bfa; }
        body.dark-mode .bot-btn:hover { background: #a78bfa; color: #fff; }

        /* ===== MODALS ===== */
        .modal {
            display: none; position: fixed; z-index: 1001; left: 0; top: 0; width: 100%; height: 100%;
            overflow: auto; background-color: rgba(0,0,0,0.5); backdrop-filter: blur(8px);
        }
        .modal-content {
            background: var(--card-bg); backdrop-filter: blur(24px); margin: 8% auto;
            padding: 35px; border-radius: 24px; box-shadow: 0 30px 80px rgba(0,0,0,0.2);
            width: 420px; max-width: 92%; animation: modalopen 0.4s ease; border: 1px solid var(--border-color);
        }
        @keyframes modalopen { from { opacity: 0; transform: translateY(-30px) scale(0.96); } to { opacity: 1; transform: translateY(0) scale(1); } }
        .modal-content h2 {
            font-size: 26px; margin-bottom: 6px;
            background: linear-gradient(135deg, #7c3aed, #f472b6, #fb923c);
            -webkit-background-clip: text; background-clip: text; color: transparent; font-weight: 800;
        }
        .modal-content p { color: #999; margin-bottom: 18px; font-size: 14px; }
        body.dark-mode .modal-content p { color: #aaa; }
        .close-modal { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; transition: color 0.3s ease; line-height: 1; }
        .close-modal:hover { color: #7c3aed; }
        body.dark-mode .close-modal:hover { color: #a78bfa; }
        .otp-inputs { display: flex; justify-content: center; gap: 10px; margin: 18px 0; }
        .otp-inputs input {
            width: 50px; height: 50px; text-align: center; font-size: 22px;
            border: 2px solid rgba(0,0,0,0.08); border-radius: 14px; outline: none;
            transition: all 0.3s ease; background: rgba(0,0,0,0.03); font-weight: 700; color: var(--bs-body-color);
        }
        .otp-inputs input:focus { border-color: #7c3aed; box-shadow: 0 0 25px rgba(124,58,237,0.12); background: rgba(255,255,255,0.8); }
        body.dark-mode .otp-inputs input { background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.08); }
        body.dark-mode .otp-inputs input:focus { background: rgba(255,255,255,0.08); border-color: #a78bfa; }
        .resend-otp { text-align: center; margin-top: 14px; }
        .resend-otp a { color: #7c3aed; text-decoration: none; cursor: pointer; font-weight: 600; }
        .resend-otp a:hover { text-decoration: underline; }
        body.dark-mode .resend-otp a { color: #a78bfa; }

        /* ===== RESPONSIVE ===== */
        @media screen and (max-width: 950px) {
            .container { width: 92%; height: auto; min-height: 700px; }
            .form-box { padding: 28px; width: 100%; }
            .form-box.login { right: 0; left: auto; }
            .form-box.register { left: -100%; right: auto; }
            .container.active .form-box.login { left: -100%; right: auto; }
            .container.active .form-box.register { left: 0; right: auto; }
            .input-row { flex-direction: column; gap: 0; }
            .captcha-container { flex-direction: column; }
            .captcha-box { width: 100%; }
            .captcha-input { width: 100%; }
            .btn { width: 100%; }
            .toggle-panel h1 { font-size: 1.8rem; }
        }
        @media screen and (max-width: 650px) {
            .container { height: calc(100vh - 4px); width: 100%; border-radius: 0; min-height: auto; }
            .form-box { bottom: 0; top: auto; width: 100%; height: 70%; padding: 18px; }
            .form-box.login { left: 0; } .form-box.register { left: 0; }
            .toggle-box::before { left: 0 !important; top: -275%; width: 100%; height: 300%; border-radius: 20vw; }
            .container.active .toggle-box::before { left: 0 !important; top: 70%; }
            .toggle-panel { width: 100%; height: 30%; padding: 16px; left: 0 !important; right: 0 !important; }
            .toggle-panel.toggle-left { top: -100%; }
            .container.active .toggle-panel.toggle-left { top: 0; }
            .toggle-panel.toggle-right { top: 0; }
            .container.active .toggle-panel.toggle-right { top: -100%; }
            .toggle-panel h1 { font-size: 1.5rem; }
            .toggle-panel p { font-size: 12px; }
            .toggle-panel .btn { width: 110px; height: 36px; font-size: 13px; }
            .container h1 { font-size: 24px; margin-bottom: 12px; }
            .input-box input, .input-box select { padding: 11px 42px 11px 14px; font-size: 13px; }
            .btn { height: 42px; font-size: 14px; }
            .modal-content { padding: 22px; margin: 15% auto; }
            .otp-inputs input { width: 38px; height: 38px; font-size: 17px; }
            #mode-toggle { top: 10px; right: 10px; width: 36px; height: 36px; font-size: 0.95rem; }
            .float-book, .float-page, .float-dot, .gradient-orb, .bg-grid { display: none; }
        }
        @media screen and (max-width: 400px) {
            .form-box { padding: 14px; }
            .container h1 { font-size: 20px; }
            .input-box input, .input-box select { padding: 9px 36px 9px 12px; font-size: 12px; }
            .input-box i { right: 12px; font-size: 15px; }
            .floating-label { font-size: 12px; left: 12px; top: 10px; }
            .input-box input:focus~.floating-label, .input-box input:not(:placeholder-shown)~.floating-label,
            .input-box select[data-filled="true"]~.floating-label { font-size: 9px; top: -8px; left: 10px; }
            .btn { height: 38px; font-size: 13px; }
            .captcha-text { font-size: 16px; letter-spacing: 3px; }
            .captcha-input { padding: 9px 12px; font-size: 12px; }
            .container p { font-size: 11px; margin: 10px 0; }
            .forget-link a { font-size: 11px; }
            .terms-container label { font-size: 10px; }
            .modal-content { padding: 16px; }
            .otp-inputs input { width: 32px; height: 32px; font-size: 15px; }
        }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            document.getElementById("loginForm").enctype = "application/x-www-form-urlencoded";
            document.getElementById("registerForm").enctype = "application/x-www-form-urlencoded";
        });
    </script>
</head>
<body>

    <!-- ===== ENHANCED 3D BACKGROUND ===== -->
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

    <!-- ===== THEME TOGGLE ===== -->
    <button id="mode-toggle" title="Toggle Theme">
        <i class="fas fa-moon"></i>
    </button>

    <!-- ===== MAIN CONTAINER ===== -->
    <div class="container" id="mainContainer">

        <!-- ===== TOGGLE BOX ===== -->
        <div class="toggle-box">
            <div class="toggle-panel toggle-left">
                <img src="student.png" alt="Student Registration" class="form-image">
                <h1>Welcome Back!</h1>
                <p>Already have an account? Enter your credentials to access your student account.</p>
                <button class="btn login-btn">Login</button>
            </div>
            <div class="toggle-panel toggle-right">
                <h1>Hello, Student!</h1>
                <p>Don't have an account? Register with your details to start using the library.</p>
                <button class="btn register-btn">Sign Up</button>
            </div>
        </div>

        <!-- ===== LOGIN FORM ===== -->
        <div class="form-box login">
            <form action="StudentLoginServlet" method="post" id="loginForm" autocomplete="off">
                <input type="hidden" name="action" value="login">
                <h1>Student Login</h1>
                <div class="input-box">
                    <!-- FIX: Set name to "email" explicitly but keep alias id for JS fallback mapping -->
                    <input type="text" name="email" id="loginIdentifier" placeholder=" " required>
                    <label class="floating-label">Email or CRN / Roll No.</label>
                    <i class='bx bxs-user'></i>
                </div>
                <div class="input-box">
                    <input type="password" name="password" id="loginPassword" placeholder=" " required>
                    <label class="floating-label">Password</label>
                    <i class='bx bxs-lock' id="toggleLoginPassword"></i>
                </div>
                <div class="captcha-container">
                    <div class="captcha-box">
                        <span class="captcha-text" id="loginCaptchaText"></span>
                        <i class='bx bx-refresh refresh-captcha' id="refreshLoginCaptcha" title="Refresh CAPTCHA"></i>
                    </div>
                    <input type="text" class="captcha-input" name="captchaInput" id="loginCaptchaInput" placeholder="Enter CAPTCHA" required>
                    <input type="hidden" name="captchaHidden" id="loginCaptchaHidden">
                </div>
                <div class="forget-link">
                    <a href="#" id="forgotPasswordLink">Forgot Password?</a>
                </div>
                
                <button type="submit" class="btn" id="loginBtn">Login</button>
                
                <img src="student.png" alt="Student Dashboard" class="form-image">
                
            </form>
        </div>

        <!-- ===== REGISTER FORM ===== -->
        <div class="form-box register">
            <form action="StudentSignupServlet" method="post" id="registerForm" autocomplete="off">
                <input type="hidden" name="action" value="register">
                <h1>Student Signup</h1>
                <div class="input-row">
                    <div class="input-box">
                        <input type="text" name="fullName" id="regFullName" placeholder=" " required>
                        <label class="floating-label">Full Name</label>
                        <i class='bx bx-user'></i>
                    </div>
                    <div class="input-box">
                        <input type="email" name="email" id="regEmail" placeholder=" " required>
                        <label class="floating-label">Email Address</label>
                        <i class='bx bxs-envelope'></i>
                    </div>
                </div>
                <div class="input-row">
                    <div class="input-box">
                        <input type="tel" name="contactNumber" id="regContact" placeholder=" " required>
                        <label class="floating-label">Contact Number</label>
                        <i class='bx bx-mobile'></i>
                    </div>
                    <div class="input-box">
                        <input type="text" name="crn" id="regCrn" placeholder=" " required>
                        <label class="floating-label">CRN / Roll Number</label>
                        <i class='bx bx-id-card'></i>
                    </div>
                </div>
                <div class="input-row">
                    <div class="input-box">
                        <select name="course" id="regCourse" required>
                            <option value="" disabled selected></option>
                            <option value="BCA">BCA</option>
                            <option value="BBA">BBA</option>
                            <option value="BTech">B. Tech</option>
                            <option value="MCA">MCA</option>
                            <option value="MBA">MBA</option>
                            <option value="PTech">PolyTech</option>
                        </select>
                        <label class="floating-label">Course</label>
                        <i class='bx bx-graduation bx-custom-select'></i>
                    </div>
                    <div class="input-box" id="departmentWrapper">
                        <select name="department" id="regDepartment">
                            <option value="" disabled selected></option>
                            <option value="NA">N/A</option>
                            <option value="Computer Science">Computer Science</option>
                            <option value="Information Technology">Information Technology</option>
                            <option value="Mechanical">Mechanical</option>
                            <option value="Civil">Civil</option>
                            <option value="Electrical">Electrical</option>
                            <option value="Electronics">Electronics</option>
                            <option value="Management">Management</option>
                        </select>
                        <label class="floating-label">Department</label>
                        <i class='bx bx-building bx-custom-select'></i>
                    </div>
                </div>

                <div class="input-row">
                    <div class="input-box">
                        <input type="password" name="password" id="regPassword" placeholder=" " required>
                        <label class="floating-label">Password</label>
                        <i class='bx bxs-lock' id="toggleRegPassword"></i>
                        <div class="password-feedback" id="passwordFeedback"></div>
                        <div class="password-strength">
                            <div class="password-strength-bar" id="strengthBar"></div>
                        </div>
                    </div>
                    <div class="input-box">
                        <input type="password" name="confirmPassword" id="regConfirmPassword" placeholder=" " required>
                        <label class="floating-label">Confirm Password</label>
                        <i class='bx bxs-lock' id="toggleRegConfirmPassword"></i>
                        <div class="password-feedback" id="confirmFeedback"></div>
                    </div>
                </div>

                <div class="captcha-container">
                    <div class="captcha-box">
                        <span class="captcha-text" id="registerCaptchaText"></span>
                        <i class='bx bx-refresh refresh-captcha' id="refreshRegisterCaptcha" title="Refresh CAPTCHA"></i>
                    </div>
                    <input type="text" class="captcha-input" name="captchaInput" id="registerCaptchaInput" placeholder="Enter CAPTCHA" required>
                    <input type="hidden" name="captchaHidden" id="registerCaptchaHidden">
                </div>

                <div class="terms-container">
                    <input type="checkbox" id="termsCheckbox" name="terms" disabled>
                    <label for="termsCheckbox">
                        I agree to the <a href="#" id="termsLink">Terms &amp; Conditions</a> and <a href="#" id="privacyLink">Privacy Policy</a>
                    </label>
                </div>

                <button type="button" class="bot-btn" id="readBotBtn"><i class="fas fa-robot"></i> Read Terms for Me</button>

                <button type="submit" class="btn" id="registerBtn" disabled>Create Account</button>
               
            </form>
        </div>

    </div>

    <!-- ===== FORGOT PASSWORD MODALS ===== -->
    <div id="forgotPasswordModal" class="modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <h2>Forgot Password</h2>
            <p>Enter your email to receive a password reset OTP</p>
            <div class="input-box" style="margin-bottom:18px;">
                <input type="text" id="forgotPasswordInput" placeholder=" " required>
                <label class="floating-label">Enter Your Email</label>
                <i class='bx bx-mail-send'></i>
            </div>
            <button id="sendOtpBtn" class="btn">Send OTP</button>
        </div>
    </div>

    <div id="otpModal" class="modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <h2>Verify OTP</h2>
            <p>Enter the 6-digit OTP sent to your email or mobile</p>
            <div class="otp-inputs">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
            </div>
            <div class="resend-otp">
                <p>Didn't receive OTP? <a id="resendOtpLink">Resend OTP</a></p>
            </div>
            <button id="verifyOtpBtn" class="btn">Verify OTP</button>
        </div>
    </div>

    <div id="resetPasswordModal" class="modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <h2>Reset Password</h2>
            <p>Create a new password for your account</p>
            <div class="input-box">
                <input type="password" id="newPassword" placeholder=" " required>
                <label class="floating-label">New Password</label>
                <i class='bx bxs-lock' id="toggleNewPassword"></i>
            </div>
            <div class="input-box">
                <input type="password" id="confirmNewPassword" placeholder=" " required>
                <label class="floating-label">Confirm New Password</label>
                <i class='bx bxs-lock' id="toggleConfirmNewPassword"></i>
                <div class="password-feedback" id="newPasswordFeedback"></div>
            </div>
            <button id="resetPasswordBtn" class="btn">Reset Password</button>
        </div>
    </div>

    <!-- ============================ JAVASCRIPT ============================ -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {

            // Interactive 3D Parallax Effect
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

            // ===== DARK / LIGHT MODE =====
            const modeToggle = document.getElementById('mode-toggle');
            const modeIcon = modeToggle.querySelector('i');
            const body = document.body;

            const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            const savedTheme = localStorage.getItem('theme');

            if (savedTheme === 'dark' || (!savedTheme && prefersDark)) {
                body.classList.add('dark-mode');
                document.documentElement.setAttribute('data-bs-theme', 'dark');
                modeIcon.className = 'fas fa-sun';
                modeToggle.title = 'Switch to Light Mode';
            } else {
                body.classList.remove('dark-mode');
                document.documentElement.setAttribute('data-bs-theme', 'light');
                modeIcon.className = 'fas fa-moon';
                modeToggle.title = 'Switch to Dark Mode';
            }

            modeToggle.addEventListener('click', function() {
                body.classList.toggle('dark-mode');
                const isDark = body.classList.contains('dark-mode');
                document.documentElement.setAttribute('data-bs-theme', isDark ? 'dark' : 'light');
                modeIcon.className = isDark ? 'fas fa-sun' : 'fas fa-moon';
                modeToggle.title = isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode';
                localStorage.setItem('theme', isDark ? 'dark' : 'light');
            });

            // ===== LOGIN / SIGNUP TOGGLE =====
            const container = document.getElementById('mainContainer');
            const registerBtn = document.querySelector('.register-btn');
            const loginBtn = document.querySelector('.login-btn');

            registerBtn.addEventListener('click', function() {
                container.classList.add('active');
            });

            loginBtn.addEventListener('click', function() {
                container.classList.remove('active');
            });

            // ===== CAPTCHA GENERATOR =====
            function generateCaptcha() {
                const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
                let captcha = '';
                for (let i = 0; i < 6; i++) {
                    captcha += chars.charAt(Math.floor(Math.random() * chars.length));
                }
                return captcha;
            }

            function initCaptcha(textEl, hiddenEl, refreshBtn) {
                let current = generateCaptcha();
                textEl.textContent = current;
                hiddenEl.value = current;
                refreshBtn.addEventListener('click', function() {
                    current = generateCaptcha();
                    textEl.textContent = current;
                    hiddenEl.value = current;
                });
                return function() { return current; };
            }

            const loginCaptchaText = document.getElementById('loginCaptchaText');
            const loginCaptchaHidden = document.getElementById('loginCaptchaHidden');
            const refreshLoginCaptcha = document.getElementById('refreshLoginCaptcha');
            let getLoginCaptcha = initCaptcha(loginCaptchaText, loginCaptchaHidden, refreshLoginCaptcha);

            const registerCaptchaText = document.getElementById('registerCaptchaText');
            const registerCaptchaHidden = document.getElementById('registerCaptchaHidden');
            const refreshRegisterCaptcha = document.getElementById('refreshRegisterCaptcha');
            let getRegisterCaptcha = initCaptcha(registerCaptchaText, registerCaptchaHidden, refreshRegisterCaptcha);

            // ===== PASSWORD STRENGTH & MATCH =====
            const regPassword = document.getElementById('regPassword');
            const regConfirm = document.getElementById('regConfirmPassword');
            const strengthBar = document.getElementById('strengthBar');
            const passwordFeedback = document.getElementById('passwordFeedback');
            const confirmFeedback = document.getElementById('confirmFeedback');

            function calcStrength(pw) {
                let s = 0;
                if (pw.length >= 8) s += 1;
                if (pw.length >= 12) s += 1;
                if (/[A-Z]/.test(pw)) s += 1;
                if (/[a-z]/.test(pw)) s += 1;
                if (/[0-9]/.test(pw)) s += 1;
                if (/[^A-Za-z0-9]/.test(pw)) s += 2;
                return Math.min(s, 5);
            }

            function updateStrength() {
                const pw = regPassword.value;
                const strength = calcStrength(pw);
                const pct = strength * 20;
                strengthBar.style.width = pct + '%';

                if (strength <= 1) {
                    strengthBar.style.backgroundColor = '#ef4444';
                    passwordFeedback.textContent = 'Weak password';
                    passwordFeedback.style.color = '#ef4444';
                } else if (strength <= 3) {
                    strengthBar.style.backgroundColor = '#f59e0b';
                    passwordFeedback.textContent = 'Medium password';
                    passwordFeedback.style.color = '#f59e0b';
                } else {
                    strengthBar.style.backgroundColor = '#10b981';
                    passwordFeedback.textContent = 'Strong password!';
                    passwordFeedback.style.color = '#10b981';
                }
                validateMatch();
                toggleSignupButton();
            }

            function validateMatch() {
                const pw = regPassword.value;
                const conf = regConfirm.value;
                if (conf.length === 0) {
                    confirmFeedback.textContent = '';
                    return;
                }
                if (pw === conf) {
                    confirmFeedback.textContent = 'Passwords match ✓';
                    confirmFeedback.style.color = '#10b981';
                } else {
                    confirmFeedback.textContent = 'Passwords do not match';
                    confirmFeedback.style.color = '#ef4444';
                }
                toggleSignupButton();
            }

            regPassword.addEventListener('input', updateStrength);
            regConfirm.addEventListener('input', validateMatch);

            // ===== TOGGLE PASSWORD VISIBILITY =====
            document.querySelectorAll('.input-box i.bxs-lock').forEach(function(icon) {
                icon.addEventListener('click', function() {
                    const input = this.closest('.input-box').querySelector('input');
                    if (!input) return;
                    if (input.type === 'password') {
                        input.type = 'text';
                        this.classList.remove('bxs-lock');
                        this.classList.add('bxs-show');
                    } else {
                        input.type = 'password';
                        this.classList.remove('bxs-show');
                        this.classList.add('bxs-lock');
                    }
                });
            });

            // ===== COURSE -> DEPARTMENT DISABLE LOGIC =====
            const regCourse = document.getElementById('regCourse');
            const regDepartment = document.getElementById('regDepartment');
            const departmentWrapper = document.getElementById('departmentWrapper');
            const disableDeptCourses = ['BCA', 'BBA', 'MBA', 'MCA'];

            function updateDepartmentState() {
                const selected = regCourse.value;
                if (disableDeptCourses.includes(selected)) {
                    regDepartment.disabled = true;
                    regDepartment.value = 'NA';
                    regDepartment.removeAttribute('required');
                    departmentWrapper.style.opacity = '0.5';
                } else {
                    regDepartment.disabled = false;
                    regDepartment.setAttribute('required', 'required');
                    departmentWrapper.style.opacity = '1';
                    if (regDepartment.value === 'NA') {
                        regDepartment.value = '';
                    }
                }
                regDepartment.dispatchEvent(new Event('change'));
            }

            regCourse.addEventListener('change', updateDepartmentState);
            updateDepartmentState();

            // ===== AUTO READ BOT & TERMS CHECKBOX =====
            const termsCheckbox = document.getElementById('termsCheckbox');
            const registerBtnSubmit = document.getElementById('registerBtn');
            const readBotBtn = document.getElementById('readBotBtn');
            
            let termsRead = false;
            let privacyRead = false;

            function updateTermsState() {
                if (termsRead && privacyRead) {
                    termsCheckbox.disabled = false;
                    termsCheckbox.checked = true;
                } else {
                    termsCheckbox.disabled = true;
                    termsCheckbox.checked = false;
                }
                toggleSignupButton();
            }

            function toggleSignupButton() {
                const pw = regPassword.value;
                const conf = regConfirm.value;
                const termsOk = termsCheckbox.checked && !termsCheckbox.disabled;
                const pwOk = pw.length > 0 && pw === conf && calcStrength(pw) >= 2;
                registerBtnSubmit.disabled = !(termsOk && pwOk);
            }

            // Web Speech API Implementation
            readBotBtn.addEventListener('click', function() {
                const termsText = "These are the Terms and Conditions and Privacy Policy for using the Library System. You must return borrowed books on time, pay overdue fines, keep your account credentials secure, and use library resources responsibly. By creating an account, your data will be stored securely and will not be shared with third parties. You have accepted these responsibilities.";
                
                const speech = new SpeechSynthesisUtterance(termsText);
                speech.lang = 'en-US';
                speech.rate = 1.0;
                
                readBotBtn.innerHTML = '<i class="fas fa-volume-up"></i> Reading Terms...';
                readBotBtn.disabled = true;

                speech.onend = function() {
                    termsRead = true;
                    privacyRead = true;
                    updateTermsState();
                    readBotBtn.innerHTML = '<i class="fas fa-check-circle"></i> Terms Read & Accepted';
                    readBotBtn.style.background = '#10b981';
                    readBotBtn.style.color = '#fff';
                    readBotBtn.style.borderColor = '#10b981';
                };

                window.speechSynthesis.speak(speech);
            });

            document.getElementById('termsLink').addEventListener('click', function(e) {
                e.preventDefault();
                Swal.fire({
                    title: '📚 Student Responsibilities',
                    html: `
                                <div style="text-align:left; max-height:300px; overflow-y:auto; padding-right:10px;">
                                    <p style="font-weight:600; color:#7c3aed;">As a student user of the Library Management System, you agree to:</p>
                                    <ul style="list-style:none; padding:0; margin-top:12px;">
                                        <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                            <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                            <span>Return borrowed books on or before the due date.</span>
                                        </li>
                                        <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                            <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                            <span>Pay any overdue fines promptly.</span>
                                        </li>
                                        <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                            <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                            <span>Keep your account credentials secure.</span>
                                        </li>
                                        <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                            <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                            <span>Use library resources responsibly.</span>
                                        </li>
                                        <li style="padding:8px 0; display:flex; align-items:center; gap:10px;">
                                            <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                            <span>Report any issues with books or accounts to the librarian.</span>
                                        </li>
                                    </ul>
                                    <p style="margin-top:16px; font-weight:500; color:#7c3aed;">By creating an account, you accept these responsibilities.</p>
                                </div>
                            `,
                    icon: 'info',
                    confirmButtonText: 'I Understand & Accept',
                    confirmButtonColor: '#7c3aed',
                    didClose: function() {
                        termsRead = true;
                        updateTermsState();
                    }
                });
            });

            document.getElementById('privacyLink').addEventListener('click', function(e) {
                e.preventDefault();
                Swal.fire({
                    title: '🔒 Privacy Policy',
                    html: `
                                <div style="text-align:left; max-height:300px; overflow-y:auto; padding-right:10px;">
                                    <p style="font-weight:600; color:#7c3aed;">Your privacy is important to us. This policy explains how we collect, use, and protect your personal information.</p>
                                    <ul style="list-style:none; padding:0; margin-top:12px;">
                                        <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                            <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                            <span>We collect only necessary information for library services.</span>
                                        </li>
                                        <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                            <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                            <span>Your data is stored securely and not shared with third parties.</span>
                                        </li>
                                        <li style="padding:8px 0; display:flex; align-items:center; gap:10px;">
                                            <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                            <span>You can update or delete your account anytime.</span>
                                        </li>
                                    </ul>
                                    <p style="margin-top:16px; font-weight:500; color:#7c3aed;">We are committed to protecting your data.</p>
                                </div>
                            `,
                    icon: 'info',
                    confirmButtonText: 'I Understand & Accept',
                    confirmButtonColor: '#7c3aed',
                    didClose: function() {
                        privacyRead = true;
                        updateTermsState();
                    }
                });
            });

            updateTermsState();

            // ===== REAL-TIME OTP AJAX FORGOT PASSWORD FLOW =====
            const forgotLink = document.getElementById('forgotPasswordLink');
            const forgotModal = document.getElementById('forgotPasswordModal');
            const otpModal = document.getElementById('otpModal');
            const resetModal = document.getElementById('resetPasswordModal');
            const closeModals = document.querySelectorAll('.close-modal');
            const sendOtpBtn = document.getElementById('sendOtpBtn');
            const verifyOtpBtn = document.getElementById('verifyOtpBtn');
            const resetPwdBtn = document.getElementById('resetPasswordBtn');
            const otpInputs = document.querySelectorAll('.otp-input');

            forgotLink.addEventListener('click', function(e) {
                e.preventDefault();
                forgotModal.style.display = 'block';
                document.getElementById('forgotPasswordInput').focus();
            });

            closeModals.forEach(function(btn) {
                btn.addEventListener('click', function() {
                    this.closest('.modal').style.display = 'none';
                });
            });

            window.addEventListener('click', function(e) {
                if (e.target.classList.contains('modal')) {
                    e.target.style.display = 'none';
                }
            });

            // 1. AJAX CALL TO SEND OTP
            sendOtpBtn.addEventListener('click', function() {
                const userEmail = document.getElementById('forgotPasswordInput').value.trim();
                
                if (!userEmail) {
                    Swal.fire('Error', 'Please enter your registered email', 'error');
                    return;
                }

                sendOtpBtn.disabled = true;
                sendOtpBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';

                const params = new URLSearchParams();
                params.append('email', userEmail);

                fetch('SendOtpServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                })
                .then(response => response.text())
                .then(data => {
                    sendOtpBtn.disabled = false;
                    sendOtpBtn.innerHTML = 'Send OTP';

                    if(data.trim() === "success") {
                        Swal.fire({
                            icon: 'success',
                            title: 'OTP Sent',
                            text: 'A 6-digit OTP has been sent to your email.',
                            timer: 3000,
                            showConfirmButton: false
                        });
                        forgotModal.style.display = 'none';
                        otpModal.style.display = 'block';
                        otpInputs[0].focus();
                    } else {
                        Swal.fire('Error', 'Could not send OTP. Ensure email is registered.', 'error');
                    }
                })
                .catch(err => {
                    sendOtpBtn.disabled = false;
                    sendOtpBtn.innerHTML = 'Send OTP';
                    Swal.fire('Error', 'Network connection failed.', 'error');
                });
            });

            // Manage OTP inputs auto-advance
            otpInputs.forEach(function(inp, idx) {
                inp.addEventListener('input', function() {
                    if (this.value.length === 1 && idx < otpInputs.length - 1) {
                        otpInputs[idx + 1].focus();
                    }
                });
                inp.addEventListener('keydown', function(e) {
                    if (e.key === 'Backspace' && this.value.length === 0 && idx > 0) {
                        otpInputs[idx - 1].focus();
                    }
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        if (idx === otpInputs.length - 1) verifyOtpBtn.click();
                    }
                });
            });

            // 2. AJAX CALL TO VERIFY OTP
            verifyOtpBtn.addEventListener('click', function() {
                let enteredOtp = '';
                otpInputs.forEach(function(inp) { enteredOtp += inp.value; });
                
                if (enteredOtp.length !== 6) {
                    Swal.fire('Error', 'Please enter the complete 6-digit OTP', 'error');
                    return;
                }

                verifyOtpBtn.disabled = true;
                verifyOtpBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Verifying...';

                const params = new URLSearchParams();
                params.append('otp', enteredOtp);

                fetch('VerifyOtpServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                })
                .then(response => response.text())
                .then(data => {
                    verifyOtpBtn.disabled = false;
                    verifyOtpBtn.innerHTML = 'Verify OTP';

                    if(data.trim() === "success") {
                        Swal.fire('Verified', 'You can now reset your password', 'success');
                        otpModal.style.display = 'none';
                        resetModal.style.display = 'block';
                        document.getElementById('newPassword').focus();
                    } else {
                        Swal.fire('Invalid OTP', 'The OTP you entered is incorrect', 'error');
                    }
                });
            });

            // 3. AJAX CALL TO RESET PASSWORD
            resetPwdBtn.addEventListener('click', function() {
                const newPassword = document.getElementById('newPassword').value.trim(); 
                const confirmNewPassword = document.getElementById('confirmNewPassword').value.trim();
                const fb = document.getElementById('newPasswordFeedback');
                
                if (!newPassword || !confirmNewPassword) {
                    Swal.fire('Error', 'Please enter and confirm your new password', 'error');
                    return;
                }
                if (newPassword !== confirmNewPassword) {
                    fb.textContent = 'Passwords do not match';
                    fb.style.color = '#ef4444';
                    return;
                }

                resetPwdBtn.disabled = true;
                resetPwdBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Resetting...';

                const params = new URLSearchParams();
                params.append('newPassword', newPassword);

                fetch('ResetPasswordServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                })
                .then(response => response.text())
                .then(data => {
                    resetPwdBtn.disabled = false;
                    resetPwdBtn.innerHTML = 'Reset Password';

                    if(data.trim() === "success") {
                        Swal.fire('Success', 'Your password has been successfully reset', 'success').then(() => {
                            resetModal.style.display = 'none';
                            window.location.reload(); 
                        });
                    } else {
                        Swal.fire('Error', 'Failed to update password. Try again.', 'error');
                    }
                })
                .catch(err => {
                    resetPwdBtn.disabled = false;
                    resetPwdBtn.innerHTML = 'Reset Password';
                    Swal.fire('Error', 'Network connection failed.', 'error');
                });
            });

            document.getElementById('newPassword').addEventListener('input', function() {
                const np = this.value;
                const cp = document.getElementById('confirmNewPassword').value;
                const fb = document.getElementById('newPasswordFeedback');
                if (np && cp) {
                    if (np !== cp) { fb.textContent = 'Passwords do not match'; fb.style.color = '#ef4444'; } 
                    else { fb.textContent = 'Passwords match ✓'; fb.style.color = '#10b981'; }
                } else { fb.textContent = ''; }
            });

            document.getElementById('confirmNewPassword').addEventListener('input', function() {
                const np = document.getElementById('newPassword').value;
                const cp = this.value;
                const fb = document.getElementById('newPasswordFeedback');
                if (np && cp) {
                    if (np !== cp) { fb.textContent = 'Passwords do not match'; fb.style.color = '#ef4444'; } 
                    else { fb.textContent = 'Passwords match ✓'; fb.style.color = '#10b981'; }
                } else { fb.textContent = ''; }
            });

            // ===== LOGIN FORM SUBMISSION (FIXED) =====
            const loginForm = document.getElementById('loginForm');
            loginForm.addEventListener('submit', function(e) {
                e.preventDefault();

                const inputCaptcha = document.getElementById('loginCaptchaInput').value;
                const hiddenCaptcha = document.getElementById('loginCaptchaHidden').value;
                if (inputCaptcha !== hiddenCaptcha) {
                    Swal.fire('Invalid CAPTCHA', 'Please enter the correct CAPTCHA code.', 'error');
                    return;
                }

                const loginBtn = document.getElementById('loginBtn');
                loginBtn.disabled = true;
                loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Logging in...';

                // BULLETPROOF PAYLOAD: Satisfies any backend parameter expectation
                const formData = new URLSearchParams(new FormData(this));
                const identifier = document.getElementById('loginIdentifier').value;
                formData.set('email', identifier); 
                formData.set('crn', identifier);   
                formData.set('loginIdentifier', identifier);
                formData.set('captchaInput', inputCaptcha);
                formData.set('captchaText', hiddenCaptcha);
                formData.set('captchaHidden', hiddenCaptcha);

                fetch(this.getAttribute('action'), {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData.toString()
                })
                .then(response => {
                    if (response.redirected) { window.location.href = response.url; return null; }
                    return response.json();
                })
                .then(data => {
                    if (data && data.status === 'error') {
                        Swal.fire('Error', data.message, 'error');
                        loginBtn.disabled = false;
                        loginBtn.innerHTML = 'Login';
                    } else if (data && data.status === 'success') {
                        Swal.fire({
                            icon: 'success', title: 'Success', text: data.message,
                            timer: 2000, showConfirmButton: false
                        }).then(() => { if (data.redirect) window.location.href = data.redirect; });
                    }
                })
                .catch(error => {
                    Swal.fire('Error', 'Login processing failed. Please try again.', 'error');
                    loginBtn.disabled = false;
                    loginBtn.innerHTML = 'Login';
                });
            });

            // ===== REGISTER FORM SUBMISSION =====
            const registerForm = document.getElementById('registerForm');
            if (registerForm) {
                registerForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    
                    const termsCheckbox = document.getElementById('termsCheckbox');
                    if (!termsCheckbox.checked) {
                        Swal.fire('Terms Not Accepted', 'Please read and accept the Terms & Conditions.', 'warning');
                        return;
                    }
                    
                    const inputCaptcha = document.getElementById('registerCaptchaInput').value;
                    const hiddenCaptcha = document.getElementById('registerCaptchaHidden').value;
                    if (inputCaptcha !== hiddenCaptcha) {
                        Swal.fire('Error', 'Invalid CAPTCHA', 'error');
                        return;
                    }

                    const pwd = document.getElementById('regPassword').value;
                    const conf = document.getElementById('regConfirmPassword').value;
                    if (pwd !== conf) {
                        Swal.fire('Password Mismatch', 'Passwords do not match.', 'error');
                        return;
                    }

                    const registerBtn = document.getElementById('registerBtn');
                    registerBtn.disabled = true;
                    registerBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';

                    // Force URLSearchParams to ensure robust parsing against @MultipartConfig mismatch
                    const formData = new URLSearchParams(new FormData(this));
                    const deptSelect = document.getElementById('regDepartment');
                    if (deptSelect.disabled) formData.set('department', 'NA');

                    fetch(this.getAttribute('action'), {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: formData.toString()
                    })
                    .then(response => {
                        if (response.redirected) { window.location.href = response.url; return null; }
                        return response.json();
                    })
                    .then(data => {
                        if (data && data.status === 'error') {
                            Swal.fire('Error', data.message, 'error');
                            registerBtn.disabled = false;
                            registerBtn.innerHTML = 'Create Account';
                        } else if (data && data.status === 'success') {
                            Swal.fire({
                                icon: 'success', title: 'Success', text: data.message,
                                timer: 2000, showConfirmButton: false
                            }).then(() => { if (data.redirect) window.location.href = data.redirect; });
                        }
                    })
                    .catch(error => {
                        Swal.fire('Error', 'Registration processing failed. Please try again.', 'error');
                        registerBtn.disabled = false;
                        registerBtn.innerHTML = 'Create Account';
                    });
                });
            }

            // ===== FLOATING LABEL FIX FOR SELECT ELEMENTS =====
            document.querySelectorAll('select').forEach(function(sel) {
                sel.addEventListener('change', function() {
                    if (this.value) this.setAttribute('data-filled', 'true');
                    else this.removeAttribute('data-filled');
                });
                if (sel.value) sel.setAttribute('data-filled', 'true');
            });

            const styleEl = document.createElement('style');
            styleEl.textContent = `
                .input-box select:not([data-filled="true"]) ~ .floating-label { top: 14px; font-size: 15px; color: #999; }
                .input-box select[data-filled="true"] ~ .floating-label, .input-box select:focus ~ .floating-label {
                    top: -10px !important; left: 14px !important; font-size: 11px !important;
                    background: var(--card-bg) !important; padding: 0 6px !important;
                    color: #7c3aed !important; border-radius: 4px !important; font-weight: 600 !important;
                }
                body.dark-mode .input-box select[data-filled="true"] ~ .floating-label,
                body.dark-mode .input-box select:focus ~ .floating-label { color: #a78bfa !important; }
                .input-box select:disabled ~ .floating-label { opacity: 0.5; }
                .input-box select:disabled { cursor: not-allowed; }
            `;
            document.head.appendChild(styleEl);

        });

        // ===== IDLE LOGOUT TRACKER (15 Minutes) =====
        let idleTime = 0;
        const timeoutThreshold = 15; // 15 minutes

        setInterval(timerIncrement, 60000); 

        document.addEventListener('mousemove', () => idleTime = 0);
        document.addEventListener('keypress', () => idleTime = 0);
        document.addEventListener('click', () => idleTime = 0);
        document.addEventListener('scroll', () => idleTime = 0);

        function timerIncrement() {
            idleTime++;
            if (idleTime >= timeoutThreshold) {
                alert("Session expired due to 15 minutes of inactivity.");
                window.location.href = "LogoutServlet"; 
            }
        }
    </script>
</body>
</html>