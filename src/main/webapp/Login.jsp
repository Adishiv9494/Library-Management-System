<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Librarian Login and Signup</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', 'sans-serif';
        }

        body {
            background-color: #f4f6f9;
            background-image: radial-gradient(rgba(0, 0, 0, 0.03) 1.5px, transparent 1.5px), radial-gradient(rgba(0, 0, 0, 0.03) 1.5px, transparent 1.5px);
            background-size: 30px 30px;
            background-position: 0 0, 15px 15px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            transition: background-color 0.5s ease, color 0.5s ease;
            position: relative;
            overflow: hidden;
            color: #333;
        }

        body.dark-mode {
            background-color: #0a0514;
            background-image: radial-gradient(rgba(255, 255, 255, 0.02) 1.5px, transparent 1.5px), radial-gradient(rgba(255, 255, 255, 0.02) 1.5px, transparent 1.5px);
            color: #f0f0f0;
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

        /* 3D Infinite Grid Floor */
        .bg-grid {
            position: absolute;
            bottom: -30%;
            left: -50%;
            width: 200%;
            height: 100%;
            background-image: 
                linear-gradient(rgba(78, 115, 223, 0.15) 2px, transparent 2px),
                linear-gradient(90deg, rgba(78, 115, 223, 0.15) 2px, transparent 2px);
            background-size: 60px 60px;
            transform-origin: top center;
            transform: rotateX(70deg) translateY(0);
            animation: gridMove 20s linear infinite;
            -webkit-mask-image: linear-gradient(to top, rgba(0,0,0,1) 0%, rgba(0,0,0,0) 80%);
            mask-image: linear-gradient(to top, rgba(0,0,0,1) 0%, rgba(0,0,0,0) 80%);
            transition: background-image 0.5s ease;
        }

        body.dark-mode .bg-grid {
            background-image: 
                linear-gradient(rgba(136, 68, 238, 0.25) 2px, transparent 2px),
                linear-gradient(90deg, rgba(136, 68, 238, 0.25) 2px, transparent 2px);
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
            color: rgba(78, 115, 223, 0.18);
            filter: drop-shadow(0 10px 15px rgba(0,0,0,0.1));
        }

        body.dark-mode .float-book { 
            color: rgba(255, 255, 255, 0.1); 
            filter: drop-shadow(0 10px 20px rgba(136, 68, 238, 0.2)); 
        }

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
            background: rgba(78, 115, 223, 0.08); 
            border: 1px solid rgba(78, 115, 223, 0.15);
        }

        body.dark-mode .float-page { 
            background: rgba(255, 255, 255, 0.04); 
            border: 1px solid rgba(255, 255, 255, 0.05); 
        }

        .float-page:nth-child(7) { top: 12%; left: 22%; animation-delay: 1s; width: 35px; height: 45px; transform: translateZ(60px); }
        .float-page:nth-child(8) { top: 28%; right: 20%; animation-delay: 5s; width: 45px; height: 55px; transform: translateZ(110px); }
        .float-page:nth-child(9) { bottom: 18%; left: 28%; animation-delay: 8s; width: 30px; height: 40px; transform: translateZ(30px); }
        .float-page:nth-child(10) { bottom: 38%; right: 15%; animation-delay: 12s; width: 50px; height: 60px; transform: translateZ(90px); }

        .float-dot {
            position: absolute;
            border-radius: 50%;
            animation: floatDot 18s ease-in-out infinite;
            background: rgba(78, 115, 223, 0.08);
        }

        body.dark-mode .float-dot { background: rgba(255, 255, 255, 0.04); }

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

        .gradient-orb:nth-child(14) { 
            background: radial-gradient(circle, rgba(78, 115, 223, 0.20), transparent); 
            top: -20%; left: -20%; width: 60%; height: 60%; animation-delay: 0s; transform: translateZ(-100px); 
        }
        .gradient-orb:nth-child(15) { 
            background: radial-gradient(circle, rgba(255, 102, 0, 0.15), transparent); 
            bottom: -20%; right: -20%; width: 60%; height: 60%; animation-delay: 15s; transform: translateZ(-100px); 
        }

        body.dark-mode .gradient-orb:nth-child(14) { background: radial-gradient(circle, rgba(136, 68, 238, 0.25), transparent); }
        body.dark-mode .gradient-orb:nth-child(15) { background: radial-gradient(circle, rgba(255, 51, 102, 0.20), transparent); }

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
            position: fixed;
            top: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border: 2px solid rgba(0, 0, 0, 0.1);
            color: #333;
            font-size: 1.5rem;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.1);
        }

        #mode-toggle:hover {
            transform: rotate(30deg) scale(1.1);
            border-color: #a78bfa;
            box-shadow: 0 0 40px rgba(167, 139, 250, 0.4);
        }

        #mode-toggle i { transition: transform 0.4s ease; }

        body.dark-mode #mode-toggle {
            background: rgba(26, 26, 46, 0.9);
            border-color: rgba(255, 255, 255, 0.15);
            color: #fff;
        }

        body.dark-mode #mode-toggle:hover {
            border-color: #a78bfa;
            box-shadow: 0 0 40px rgba(124, 58, 237, 0.3);
        }

        /* ===== CONTAINER ===== */
        .container {
            position: relative;
            width: 1300px;
            height: 730px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 28px;
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            margin: 2px;
            z-index: 1;
            border: 1px solid rgba(255, 255, 255, 0.15);
            transition: all 0.3s ease;
            backdrop-filter: blur(24px);
        }

        body.dark-mode .container {
            background: rgba(26, 26, 46, 0.95);
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.6);
            border-color: rgba(255, 255, 255, 0.06);
        }

        /* ===== FORM BOX ===== */
        .form-box {
            position: absolute;
            top: 0;
            width: 50%;
            height: 100%;
            display: flex;
            align-items: center;
            color: #333;
            text-align: center;
            padding: 40px;
            transition: all 0.8s cubic-bezier(0.65, 0, 0.35, 1);
            z-index: 1;
            overflow: hidden;
        }

        /* STRICT SOLID BACKGROUNDS FOR FORM UI OVERLAP FIX */
        .form-box.login {
            right: 0;
            left: auto;
            background: #fff;
            visibility: visible;
            opacity: 1;
            z-index: 2;
        }

        body.dark-mode .form-box.login {
            background: #1a1a2e;
            color: #f0f0f0;
        }

        .form-box.register {
            left: -50%;
            right: auto;
            background: #fff;
            visibility: hidden;
            opacity: 0;
            z-index: 1;
        }

        body.dark-mode .form-box.register {
            background: #1a1a2e;
            color: #f0f0f0;
        }

        .container.active .form-box.login {
            left: -50%;
            right: auto;
            visibility: hidden;
            opacity: 0;
            z-index: 1;
        }

        .container.active .form-box.register {
            left: 0;
            right: auto;
            visibility: visible;
            opacity: 1;
            z-index: 2;
        }

        /* ===== FORMS ===== */
        form {
            width: 100%;
            height: 100%;
            overflow-y: auto;
            padding-right: 10px;
        }

        form::-webkit-scrollbar { width: 5px; }
        form::-webkit-scrollbar-track { background: rgba(0, 0, 0, 0.04); border-radius: 10px; }
        form::-webkit-scrollbar-thumb { background: linear-gradient(135deg, #7c3aed, #f472b6); border-radius: 10px; }
        body.dark-mode form::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.03); }

        .container h1 {
            font-size: 34px;
            margin-bottom: 18px;
            background: linear-gradient(135deg, #7c3aed, #f472b6, #fb923c);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            font-weight: 800;
        }

        .input-row { display: flex; gap: 14px; margin-bottom: 12px; }

        .input-box {
            position: relative;
            margin-bottom: 14px;
            flex: 1;
        }

        .input-box input {
            width: 100%;
            padding: 14px 48px 14px 18px;
            background: rgba(0, 0, 0, 0.04);
            border-radius: 14px;
            border: 2px solid rgba(0, 0, 0, 0.08);
            outline: none;
            font-size: 15px;
            color: #333;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        body.dark-mode .input-box input {
            background: rgba(255, 255, 255, 0.06);
            color: #f0f0f0;
            border-color: rgba(255, 255, 255, 0.10);
        }

        .input-box input:focus {
            border-color: #7c3aed;
            box-shadow: 0 0 25px rgba(124, 58, 237, 0.15);
            background: rgba(255, 255, 255, 0.9);
        }

        body.dark-mode .input-box input:focus {
            background: rgba(255, 255, 255, 0.10);
            border-color: #a78bfa;
            box-shadow: 0 0 25px rgba(167, 139, 250, 0.15);
        }

        .input-box input::placeholder { color: #999; font-weight: 400; }

        .input-box i {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 19px;
            color: #999;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .input-box i:hover { color: #7c3aed; }

        .floating-label {
            position: absolute;
            pointer-events: none;
            left: 18px;
            top: 14px;
            transition: 0.2s ease all;
            color: #999;
            font-size: 15px;
            background: transparent;
            padding: 0 4px;
        }

        .input-box input:focus ~ .floating-label,
        .input-box input:not(:placeholder-shown) ~ .floating-label {
            top: -10px;
            left: 14px;
            font-size: 11px;
            background: #fff;
            padding: 0 6px;
            color: #7c3aed;
            border-radius: 4px;
            font-weight: 600;
        }

        body.dark-mode .input-box input:focus ~ .floating-label,
        body.dark-mode .input-box input:not(:placeholder-shown) ~ .floating-label {
            background: #1a1a2e;
            color: #a78bfa;
        }

        .forget-link { margin: -8px 0 18px; text-align: right; }
        .forget-link a { font-size: 13px; color: #888; text-decoration: none; transition: color 0.3s ease; font-weight: 500; }
        .forget-link a:hover { color: #7c3aed; text-decoration: underline; }

        body.dark-mode .forget-link a { color: #aaa; }
        body.dark-mode .forget-link a:hover { color: #a78bfa; }

        .btn {
            width: 75%;
            height: 50px;
            background: linear-gradient(135deg, #7c3aed, #a78bfa);
            border-radius: 50px;
            box-shadow: 0 8px 30px rgba(124, 58, 237, 0.25);
            cursor: pointer;
            font-size: 17px;
            color: #fff;
            font-weight: 700;
            border: none;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            letter-spacing: 0.5px;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
            transition: left 0.6s ease;
        }

        .btn:hover::before { left: 100%; }
        .btn:hover { transform: translateY(-3px) scale(1.02); box-shadow: 0 12px 40px rgba(124, 58, 237, 0.4); }
        .btn:disabled { opacity: 0.5; cursor: not-allowed; transform: none !important; box-shadow: 0 4px 15px rgba(124,58,237,0.15); }

        body.dark-mode .btn {
            background: linear-gradient(135deg, #7c3aed, #a78bfa);
            box-shadow: 0 8px 30px rgba(124, 58, 237, 0.3);
        }

        body.dark-mode .btn:hover {
            box-shadow: 0 12px 40px rgba(124, 58, 237, 0.5);
        }

        /* ===== ENHANCED FORM IMAGE ===== */
        .form-image {
            width: 90%;
            max-width: 350px; 
            height: 190px;
            margin: 25px auto 15px auto; 
            display: block;
            border-radius: 20px; 
            box-shadow: 0 12px 30px rgba(124, 58, 237, 0.15); 
            border: 2px solid rgba(124, 58, 237, 0.15); 
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.4s ease; 
            object-fit: cover;
        }
        
        .form-image:hover {
            transform: translateY(-8px) scale(1.03); 
            box-shadow: 0 18px 40px rgba(124, 58, 237, 0.3); 
            border-color: rgba(124, 58, 237, 0.4);
        }
        
        body.dark-mode .form-image {
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.6);
            border-color: rgba(167, 139, 250, 0.15);
        }
        
        body.dark-mode .form-image:hover {
            box-shadow: 0 18px 40px rgba(167, 139, 250, 0.35);
            border-color: rgba(167, 139, 250, 0.5);
        }

        .container p { font-size: 13px; margin: 18px 0; color: #999; }
        body.dark-mode .container p { color: #bbb; }

        /* ===== CAPTCHA ===== */
        .captcha-container { display: flex; align-items: center; gap: 10px; margin: 18px 0; }
        
        .captcha-box {
            display: flex; align-items: center;
            background: rgba(0, 0, 0, 0.04); border-radius: 14px;
            padding: 4px 14px; flex: 1; border: 2px solid rgba(0, 0, 0, 0.08);
        }

        body.dark-mode .captcha-box {
            background: rgba(255, 255, 255, 0.06); border-color: rgba(255, 255, 255, 0.10);
        }

        .captcha-text {
            font-family: 'Courier New', monospace; font-size: 26px; font-weight: 800; letter-spacing: 6px;
            background: linear-gradient(135deg, #7c3aed, #f472b6, #fb923c);
            -webkit-background-clip: text; background-clip: text; color: transparent;
            flex: 1; text-align: center; user-select: none; padding: 4px 0;
        }

        body.dark-mode .captcha-text {
            background: linear-gradient(135deg, #a78bfa, #f472b6, #fb923c);
            -webkit-background-clip: text; background-clip: text; color: transparent;
        }

        .refresh-captcha { cursor: pointer; color: #999; font-size: 22px; transition: all 0.3s ease; }
        .refresh-captcha:hover { transform: rotate(90deg); color: #7c3aed; }
        body.dark-mode .refresh-captcha:hover { color: #a78bfa; }

        .captcha-input {
            flex: 1; padding: 14px 18px; background: rgba(0, 0, 0, 0.04); border-radius: 14px;
            border: 2px solid rgba(0, 0, 0, 0.08); outline: none; font-size: 15px;
            color: #333; font-weight: 500; transition: all 0.3s ease; min-width: 110px;
        }

        .captcha-input:focus { border-color: #7c3aed; box-shadow: 0 0 25px rgba(124, 58, 237, 0.15); background: rgba(255, 255, 255, 0.9); }
        body.dark-mode .captcha-input { background: rgba(255, 255, 255, 0.06); color: #f0f0f0; border-color: rgba(255, 255, 255, 0.10); }
        body.dark-mode .captcha-input:focus { background: rgba(255, 255, 255, 0.10); border-color: #a78bfa; box-shadow: 0 0 25px rgba(167, 139, 250, 0.15); }

        /* ===== TOGGLE BOX (OVERLAY) ===== */
        .toggle-box {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            z-index: 10; pointer-events: none; overflow: hidden;
        }

        .toggle-box::before {
            content: ''; position: absolute; top: 0; left: -250%; width: 300%; height: 100%;
            background: linear-gradient(135deg, #7c3aed, #f472b6, #fb923c);
            border-radius: 150px; z-index: 0; transition: 1.8s cubic-bezier(0.65, 0, 0.35, 1);
        }

        .container.active .toggle-box::before { left: 50%; }
        body.dark-mode .toggle-box::before { background: linear-gradient(135deg, #1e1b4b, #312e81, #4c1d95); }

        .toggle-panel {
            position: absolute; top: 0; width: 50%; height: 100%; color: #fff;
            display: flex; flex-direction: column; justify-content: center; align-items: center;
            z-index: 11; transition: all 0.7s cubic-bezier(0.65, 0, 0.35, 1);
            padding: 40px; text-align: center; pointer-events: auto;
        }

        .toggle-panel h1 {
            color: #fff; background: none; -webkit-background-clip: initial; background-clip: initial;
            font-size: 2.2rem; font-weight: 800; text-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
        }

        .toggle-panel.toggle-left { left: 0; transition-delay: 1.2s; }
        .container.active .toggle-panel.toggle-left { left: -50%; transition-delay: 0.6s; }
        .toggle-panel.toggle-right { right: -50%; transition-delay: 0.6s; }
        .container.active .toggle-panel.toggle-right { right: 0; transition-delay: 1.2s; }
        .toggle-panel p { margin: 15px 0; color: rgba(255, 255, 255, 0.85); font-size: 0.95rem; }

        .toggle-panel .btn {
            width: 160px; height: 46px; background: rgba(255, 255, 255, 0.15);
            border: 2px solid rgba(255, 255, 255, 0.4); border-radius: 50px;
            box-shadow: none; color: #fff; margin-top: 20px; font-weight: 600;
            backdrop-filter: blur(4px); pointer-events: auto; cursor: pointer;
        }

        .toggle-panel .btn:hover {
            background: rgba(255, 255, 255, 0.25); transform: translateY(-2px); box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        }
        .toggle-panel .btn::before { display: none; }

        /* ===== PASSWORD STRENGTH & VALIDATION FEEDBACK ===== */
        .password-feedback { font-size: 11px; margin-top: 4px; text-align: left; padding-left: 4px; transition: all 0.3s ease; font-weight: 500; }
        .password-strength { width: 100%; height: 4px; background: rgba(0, 0, 0, 0.08); border-radius: 2px; margin-top: 6px; overflow: hidden; }
        .password-strength-bar { height: 100%; width: 0%; background: #ef4444; transition: width 0.3s ease, background 0.3s ease; }
        body.dark-mode .password-strength { background: rgba(255, 255, 255, 0.08); }

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
            overflow: auto; background-color: rgba(0, 0, 0, 0.5); backdrop-filter: blur(8px);
        }

        .modal-content {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(24px); margin: 8% auto;
            padding: 35px; border-radius: 24px; box-shadow: 0 30px 80px rgba(0, 0, 0, 0.2);
            width: 420px; max-width: 92%; animation: modalopen 0.4s ease; border: 1px solid rgba(255, 255, 255, 0.15);
        }

        body.dark-mode .modal-content { background: rgba(26, 26, 46, 0.95); border-color: rgba(255, 255, 255, 0.06); color: #f0f0f0; }

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
            width: 50px; height: 50px; text-align: center; font-size: 22px; border: 2px solid rgba(0, 0, 0, 0.08);
            border-radius: 14px; outline: none; transition: all 0.3s ease; background: rgba(0, 0, 0, 0.04); font-weight: 700; color: #333;
        }
        .otp-inputs input:focus { border-color: #7c3aed; box-shadow: 0 0 25px rgba(124, 58, 237, 0.15); background: rgba(255, 255, 255, 0.9); }
        
        body.dark-mode .otp-inputs input { background: rgba(255, 255, 255, 0.06); border-color: rgba(255, 255, 255, 0.10); color: #f0f0f0; }
        body.dark-mode .otp-inputs input:focus { background: rgba(255, 255, 255, 0.10); border-color: #a78bfa; }
        
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
            .container { height: calc(100vh - 4px); width: 100%; border-radius: 0; min-height: 100vh; }
            .form-box { bottom: 0; width: 100%; height: 75%; padding: 20px; top: auto; }
            .form-box.login { right: 0; left: auto; }
            .form-box.register { left: -100%; right: auto; }
            .container.active .form-box.login { left: -100%; right: auto; }
            .container.active .form-box.register { left: 0; right: auto; }
            .toggle-box::before { left: 0; top: -275%; width: 100%; height: 300%; border-radius: 20vw; }
            .toggle-panel { width: 100%; height: 30%; padding: 16px; top: 0 !important; left: 0 !important; right: 0 !important; bottom: auto !important; }
            .toggle-panel.toggle-left { top: 0; left: 0; }
            .toggle-panel.toggle-right { top: 0; right: -100%; }
            .container.active .toggle-panel.toggle-left { left: -100%; top: 0; }
            .container.active .toggle-panel.toggle-right { right: 0; top: 0; }
            .toggle-panel h1 { font-size: 1.5rem; }
            .toggle-panel p { font-size: 12px; }
            .toggle-panel .btn { width: 110px; height: 36px; font-size: 13px; }
            .container h1 { font-size: 24px; margin-bottom: 12px; }
            .input-box input { padding: 11px 42px 11px 14px; font-size: 13px; }
            .btn { height: 42px; font-size: 14px; }
            .modal-content { padding: 22px; margin: 15% auto; }
            .otp-inputs input { width: 38px; height: 38px; font-size: 17px; }
            #mode-toggle { top: 10px; right: 10px; width: 40px; height: 40px; font-size: 1.2rem; }
            .float-book, .float-page, .float-dot, .gradient-orb, .bg-grid { display: none; }
        }

        @media screen and (max-width: 400px) {
            .form-box { padding: 14px; }
            .container h1 { font-size: 20px; }
            .input-box input { padding: 9px 36px 9px 12px; font-size: 12px; }
            .input-box i { right: 12px; font-size: 15px; }
            .floating-label { font-size: 12px; left: 12px; top: 10px; }
            .input-box input:focus ~ .floating-label, .input-box input:not(:placeholder-shown) ~ .floating-label { font-size: 9px; top: -8px; left: 10px; }
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

    <!-- ===== THEME TOGGLE ===== -->
    <button id="mode-toggle" title="Toggle Theme">
        <i class="fas fa-moon"></i>
    </button>

    <!-- ===== MAIN CONTAINER ===== -->
    <div class="container">

        <!-- ===== LOGIN FORM ===== -->
        <div class="form-box login">
            <form action="LibloginSignup" method="post" id="loginForm" enctype="application/x-www-form-urlencoded">
                <input type="hidden" name="action" value="login">
                <h1>Admin Login</h1>
                <div class="input-box">
                    <input type="text" name="email" placeholder=" " required autocomplete="off">
                    <label class="floating-label">Email</label>
                    <i class='bx bxs-envelope'></i>
                </div>
                <div class="input-box">
                    <input type="password" name="password" id="loginPassword" placeholder=" " required autocomplete="off">
                    <label class="floating-label">Password</label>
                    <i class='bx bxs-lock' id="toggleLoginPassword"></i>
                </div>
                <div class="captcha-container">
                    <div class="captcha-box">
                        <span class="captcha-text" id="loginCaptchaText"></span>
                        <i class='bx bx-refresh refresh-captcha' id="refreshLoginCaptcha" title="Refresh CAPTCHA"></i>
                    </div>
                    <input type="text" class="captcha-input" name="captchaInput" id="loginCaptchaInput" placeholder="Enter CAPTCHA" required>
                    <input type="hidden" name="captchaText" id="loginCaptchaHidden">
                </div>
                <div class="forget-link">
                    <a href="#" id="forgotPasswordLink">Forgot Password?</a>
                </div>
                
                <button type="submit" class="btn">Login</button>
                
                <img src="admin.jpg" alt="Admin Dashboard" class="form-image">

            </form>
        </div>

        <!-- ===== SIGNUP FORM ===== -->
        <div class="form-box register">
            <form action="LibloginSignup" method="post" id="registerForm" enctype="application/x-www-form-urlencoded">
                <input type="hidden" name="action" value="register">
                <h1>Admin Signup</h1>
                <div class="input-row">
                    <div class="input-box">
                        <input type="text" name="firstName" placeholder=" " required autocomplete="off">
                        <label class="floating-label">First Name</label>
                        <i class='bx bx-user'></i>
                    </div>
                    <div class="input-box">
                        <input type="text" name="lastName" placeholder=" " required autocomplete="off">
                        <label class="floating-label">Last Name</label>
                        <i class='bx bx-user'></i>
                    </div>
                </div>
                <div class="input-row">
                    <div class="input-box">
                        <input type="email" name="email" placeholder=" " required autocomplete="off">
                        <label class="floating-label">Email</label>
                        <i class='bx bxs-envelope'></i>
                    </div>
                    <div class="input-box">
                        <input type="tel" name="contactNumber" placeholder=" " required autocomplete="off">
                        <label class="floating-label">Phone Number</label>
                        <i class='bx bx-mobile'></i>
                    </div>
                </div>
                <div class="input-row">
                    <div class="input-box">
                        <input type="password" name="password" id="regPassword" placeholder=" " required>
                        <label class="floating-label">Password</label>
                        <i class='bx bxs-lock' id="toggleRegPassword"></i>
                        <div class="password-feedback" id="regPasswordFeedback" style="color: #ef4444;">Min 8 chars, 1 uppercase, 1 special, 2 numbers</div>
                        <div class="password-strength"><div class="password-strength-bar"></div></div>
                    </div>
                    <div class="input-box">
                        <input type="password" name="confirmPassword" id="confirmPassword" placeholder=" " required>
                        <label class="floating-label">Confirm Password</label>
                        <i class='bx bxs-lock' id="toggleConfirmPassword"></i>
                        <div class="password-feedback" id="confirmPasswordFeedback"></div>
                    </div>
                </div>
                <div class="captcha-container">
                    <div class="captcha-box">
                        <span class="captcha-text" id="registerCaptchaText"></span>
                        <i class='bx bx-refresh refresh-captcha' id="refreshRegisterCaptcha"></i>
                    </div>
                    <input type="text" class="captcha-input" name="captchaInput" id="registerCaptchaInput" placeholder="Enter CAPTCHA" required>
                    <input type="hidden" name="captchaText" id="registerCaptchaHidden">
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

        <!-- ===== TOGGLE OVERLAY ===== -->
        <div class="toggle-box">
            <div class="toggle-panel toggle-left">
                <h1>Welcome Admin!</h1>
                <p>Enter your details to use all site features</p>
                <button class="btn register-btn">Sign Up</button>
            </div>
            <div class="toggle-panel toggle-right">
                <img src="admin.jpg" alt="Admin Registration" class="form-image">
                <h1>Hello, Colleague!</h1>
                <p>Register to manage the library system</p>
                <button class="btn login-btn">Login</button>
            </div>
        </div>
    </div>

    <!-- ===== FORGOT PASSWORD MODALS ===== -->
    <div id="forgotPasswordModal" class="modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <h2>Forgot Password</h2>
            <p>Enter your email to receive a password reset OTP</p>
            <div class="input-box">
                <input type="email" id="forgotPasswordInput" placeholder=" " required>
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
            <p>Enter the 6-digit OTP sent to your email</p>
            <div class="otp-inputs">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
                <input type="text" maxlength="1" class="otp-input" pattern="\d*">
            </div>
            <div class="resend-otp">
                <p>Didn't receive OTP? <a id="resendOtpLink" href="#">Resend OTP</a></p>
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
                <div class="password-feedback" id="newPasswordFeedback" style="color: #ef4444;">Min 8 chars, 1 uppercase, 1 special, 2 numbers</div>
                <div class="password-strength"><div class="password-strength-bar" id="newPasswordStrengthBar"></div></div>
            </div>
            <div class="input-box">
                <input type="password" id="confirmNewPassword" placeholder=" " required>
                <label class="floating-label">Confirm New Password</label>
                <i class='bx bxs-lock' id="toggleConfirmNewPassword"></i>
                <div class="password-feedback" id="confirmNewPasswordFeedback"></div>
            </div>
            <button id="resetPasswordBtn" class="btn" disabled>Reset Password</button>
        </div>
    </div>

    <!-- ============================ JAVASCRIPT ============================ -->
    <script>
        // === DARK / LIGHT MODE ===
        document.addEventListener("DOMContentLoaded", function() {
            const modeToggle = document.getElementById("mode-toggle");
            const icon = modeToggle.querySelector("i");
            const body = document.body;

            const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            const savedTheme = localStorage.getItem("theme");

            if (savedTheme === "dark" || (!savedTheme && prefersDark)) {
                body.classList.add("dark-mode");
                icon.className = "fas fa-sun";
            } else {
                body.classList.remove("dark-mode");
                icon.className = "fas fa-moon";
            }

            modeToggle.addEventListener("click", function() {
                body.classList.toggle("dark-mode");
                if (body.classList.contains("dark-mode")) {
                    icon.className = "fas fa-sun";
                    localStorage.setItem("theme", "dark");
                } else {
                    icon.className = "fas fa-moon";
                    localStorage.setItem("theme", "light");
                }
            });
        });

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

        // === LOGIN / SIGNUP TOGGLE ===
        document.addEventListener("DOMContentLoaded", function() {
            const container = document.querySelector(".container");
            document.querySelector(".register-btn").addEventListener("click", () => container.classList.add("active"));
            document.querySelector(".login-btn").addEventListener("click", () => container.classList.remove("active"));
        });

        // === CAPTCHA ===
        function generateCaptcha() {
            const chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
            let captcha = "";
            for (let i = 0; i < 6; i++) { captcha += chars.charAt(Math.floor(Math.random() * chars.length)); }
            return captcha;
        }

        document.addEventListener("DOMContentLoaded", function() {
            const loginCaptchaText = document.getElementById("loginCaptchaText");
            const registerCaptchaText = document.getElementById("registerCaptchaText");
            const loginCaptchaHidden = document.getElementById("loginCaptchaHidden");
            const registerCaptchaHidden = document.getElementById("registerCaptchaHidden");

            loginCaptchaText.textContent = loginCaptchaHidden.value = generateCaptcha();
            registerCaptchaText.textContent = registerCaptchaHidden.value = generateCaptcha();

            document.getElementById("refreshLoginCaptcha").addEventListener("click", function() {
                loginCaptchaText.textContent = loginCaptchaHidden.value = generateCaptcha();
            });

            document.getElementById("refreshRegisterCaptcha").addEventListener("click", function() {
                registerCaptchaText.textContent = registerCaptchaHidden.value = generateCaptcha();
            });
        });

        // === AUTO READ BOT & TERMS CHECKBOX ===
        document.addEventListener("DOMContentLoaded", function() {
            const termsCheckbox = document.getElementById('termsCheckbox');
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
                if(typeof window.validateForm === 'function') window.validateForm();
            }

            readBotBtn.addEventListener('click', function() {
                const termsText = "These are the Terms and Conditions and Privacy Policy for using the Library Admin System. You must keep your admin credentials secure, respect user privacy, and manage library resources responsibly. By creating an account, your data will be stored securely. You have accepted these responsibilities.";
                
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
                    title: '📚 Admin Responsibilities',
                    html: `
                        <div style="text-align:left; max-height:300px; overflow-y:auto; padding-right:10px;">
                            <p style="font-weight:600; color:#7c3aed;">As an admin of the Library System, you agree to:</p>
                            <ul style="list-style:none; padding:0; margin-top:12px;">
                                <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                    <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                    <span>Manage the library resources effectively.</span>
                                </li>
                                <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                    <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                    <span>Respect user data and privacy.</span>
                                </li>
                                <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                    <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                    <span>Keep your admin credentials secure.</span>
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
                            <p style="font-weight:600; color:#7c3aed;">Your privacy and data security are important to us.</p>
                            <ul style="list-style:none; padding:0; margin-top:12px;">
                                <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                    <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                    <span>We collect only necessary information for management.</span>
                                </li>
                                <li style="padding:8px 0; display:flex; align-items:center; gap:10px; border-bottom:1px solid rgba(0,0,0,0.05);">
                                    <i class="fas fa-check-circle" style="color:#10b981; font-size:18px;"></i>
                                    <span>Data is stored securely.</span>
                                </li>
                            </ul>
                            <p style="margin-top:16px; font-weight:500; color:#7c3aed;">We are committed to protecting data.</p>
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
        });

        // === PASSWORD VALIDATION & STRENGTH LOGIC (REGISTRATION) ===
        document.addEventListener("DOMContentLoaded", function() {
            const passwordInput = document.getElementById('regPassword');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const regPasswordFeedback = document.getElementById('regPasswordFeedback');
            const confirmPasswordFeedback = document.getElementById('confirmPasswordFeedback');
            const strengthBar = document.querySelector('.password-strength-bar');
            const registerBtn = document.getElementById('registerBtn');

            function checkPasswordRules(password) {
                const minLength = password.length >= 8;
                const hasUpper = /[A-Z]/.test(password);
                const hasSpecial = /[^A-Za-z0-9]/.test(password);
                const matchesNumbers = password.match(/\d/g);
                const hasTwoNumbers = matchesNumbers && matchesNumbers.length >= 2;

                return {
                    minLength,
                    hasUpper,
                    hasSpecial,
                    hasTwoNumbers,
                    isValid: minLength && hasUpper && hasSpecial && hasTwoNumbers
                };
            }

            function validateForm() {
                const pwd = passwordInput.value;
                const confirmPwd = confirmPasswordInput.value;
                const rules = checkPasswordRules(pwd);
                const termsChecked = document.getElementById('termsCheckbox').checked;

                let score = 0;
                if (rules.minLength) score++;
                if (rules.hasUpper) score++;
                if (rules.hasSpecial) score++;
                if (rules.hasTwoNumbers) score++;
                if (pwd.length >= 12) score++;

                strengthBar.style.width = (score * 20) + '%';
                strengthBar.style.backgroundColor = score <= 2 ? '#ef4444' : score <= 3 ? '#f59e0b' : '#10b981';

                if (pwd.length === 0) {
                    regPasswordFeedback.style.color = '#ef4444';
                    regPasswordFeedback.textContent = 'Min 8 chars, 1 uppercase, 1 special, 2 numbers';
                } else if (rules.isValid) {
                    regPasswordFeedback.style.color = '#10b981';
                    regPasswordFeedback.textContent = 'Strong Password ✓';
                } else {
                    regPasswordFeedback.style.color = '#f59e0b';
                    let missing = [];
                    if (!rules.minLength) missing.push('8+ chars');
                    if (!rules.hasUpper) missing.push('1 uppercase');
                    if (!rules.hasSpecial) missing.push('1 special');
                    if (!rules.hasTwoNumbers) missing.push('2 numbers');
                    regPasswordFeedback.textContent = 'Needs: ' + missing.join(', ');
                }

                if (confirmPwd.length === 0) {
                    confirmPasswordFeedback.textContent = '';
                } else if (pwd === confirmPwd) {
                    confirmPasswordFeedback.style.color = '#10b981';
                    confirmPasswordFeedback.textContent = 'Passwords Match ✓';
                } else {
                    confirmPasswordFeedback.style.color = '#ef4444';
                    confirmPasswordFeedback.textContent = 'Password Mismatch ✗';
                }

                if (rules.isValid && pwd === confirmPwd && confirmPwd.length > 0 && termsChecked) {
                    registerBtn.disabled = false;
                } else {
                    registerBtn.disabled = true;
                }
            }

            passwordInput.addEventListener('input', validateForm);
            confirmPasswordInput.addEventListener('input', validateForm);
            document.getElementById('termsCheckbox').addEventListener('change', validateForm);
            window.validateForm = validateForm;
        });

        // === PASSWORD VALIDATION & STRENGTH LOGIC (RESET PASSWORD MODAL) ===
        document.addEventListener("DOMContentLoaded", function() {
            const newPasswordInput = document.getElementById('newPassword');
            const confirmNewPasswordInput = document.getElementById('confirmNewPassword');
            const newPasswordFeedback = document.getElementById('newPasswordFeedback');
            const confirmNewPasswordFeedback = document.getElementById('confirmNewPasswordFeedback');
            const newPasswordStrengthBar = document.getElementById('newPasswordStrengthBar');
            const resetPasswordBtn = document.getElementById('resetPasswordBtn');

            function checkPasswordRules(password) {
                const minLength = password.length >= 8;
                const hasUpper = /[A-Z]/.test(password);
                const hasSpecial = /[^A-Za-z0-9]/.test(password);
                const matchesNumbers = password.match(/\d/g);
                const hasTwoNumbers = matchesNumbers && matchesNumbers.length >= 2;

                return {
                    minLength,
                    hasUpper,
                    hasSpecial,
                    hasTwoNumbers,
                    isValid: minLength && hasUpper && hasSpecial && hasTwoNumbers
                };
            }

            function validateResetForm() {
                const np = newPasswordInput.value;
                const cp = confirmNewPasswordInput.value;
                const rules = checkPasswordRules(np);

                let score = 0;
                if (rules.minLength) score++;
                if (rules.hasUpper) score++;
                if (rules.hasSpecial) score++;
                if (rules.hasTwoNumbers) score++;
                if (np.length >= 12) score++;

                newPasswordStrengthBar.style.width = (score * 20) + '%';
                newPasswordStrengthBar.style.backgroundColor = score <= 2 ? '#ef4444' : score <= 3 ? '#f59e0b' : '#10b981';

                if (np.length === 0) {
                    newPasswordFeedback.style.color = '#ef4444';
                    newPasswordFeedback.textContent = 'Min 8 chars, 1 uppercase, 1 special, 2 numbers';
                } else if (rules.isValid) {
                    newPasswordFeedback.style.color = '#10b981';
                    newPasswordFeedback.textContent = 'Strong Password ✓';
                } else {
                    newPasswordFeedback.style.color = '#f59e0b';
                    let missing = [];
                    if (!rules.minLength) missing.push('8+ chars');
                    if (!rules.hasUpper) missing.push('1 uppercase');
                    if (!rules.hasSpecial) missing.push('1 special');
                    if (!rules.hasTwoNumbers) missing.push('2 numbers');
                    newPasswordFeedback.textContent = 'Needs: ' + missing.join(', ');
                }

                // Confirm password match feedback for reset modal
                if (cp.length === 0) {
                    confirmNewPasswordFeedback.textContent = '';
                } else if (np === cp) {
                    confirmNewPasswordFeedback.style.color = '#10b981';
                    confirmNewPasswordFeedback.textContent = 'Passwords Match ✓';
                } else {
                    confirmNewPasswordFeedback.style.color = '#ef4444';
                    confirmNewPasswordFeedback.textContent = 'Password Mismatch ✗';
                }

                if (np && cp && np === cp && rules.isValid) {
                    resetPasswordBtn.disabled = false;
                } else {
                    resetPasswordBtn.disabled = true;
                }
            }

            newPasswordInput.addEventListener('input', validateResetForm);
            confirmNewPasswordInput.addEventListener('input', validateResetForm);
        });

        // === TOGGLE PASSWORD VISIBILITY ===
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll('.input-box i.bxs-lock').forEach(icon => {
                icon.addEventListener('click', function() {
                    const input = this.closest('.input-box').querySelector('input');
                    if (input.type === 'password') {
                        input.type = 'text';
                        this.classList.replace('bxs-lock', 'bxs-show');
                    } else {
                        input.type = 'password';
                        this.classList.replace('bxs-show', 'bxs-lock');
                    }
                });
            });
        });

        // === FORGOT PASSWORD FLOW ===
        document.addEventListener("DOMContentLoaded", function() {
            const forgotLink = document.getElementById('forgotPasswordLink');
            const forgotModal = document.getElementById('forgotPasswordModal');
            const otpModal = document.getElementById('otpModal');
            const resetModal = document.getElementById('resetPasswordModal');
            
            const sendOtpBtn = document.getElementById('sendOtpBtn');
            const verifyOtpBtn = document.getElementById('verifyOtpBtn');
            const resetPwdBtn = document.getElementById('resetPasswordBtn');
            const otpInputs = document.querySelectorAll('.otp-input');

            forgotLink.addEventListener('click', e => { e.preventDefault(); forgotModal.style.display = 'block'; });
            document.querySelectorAll('.close-modal').forEach(btn => btn.addEventListener('click', function() { this.closest('.modal').style.display = 'none'; }));
            
            // Send OTP
            sendOtpBtn.addEventListener('click', function() {
                const userEmail = document.getElementById('forgotPasswordInput').value.trim();
                if (!userEmail) { Swal.fire('Error', 'Please enter your email', 'error'); return; }

                sendOtpBtn.disabled = true; sendOtpBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';

                fetch('SendOtpServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({'email': userEmail}).toString()
                }).then(res => res.text()).then(data => {
                    sendOtpBtn.disabled = false; sendOtpBtn.innerHTML = 'Send OTP';
                    if(data.trim() === "success") {
                        forgotModal.style.display = 'none';
                        Swal.fire({
                            icon: 'success',
                            title: 'OTP Sent!',
                            text: 'OTP sent successfully to your email.',
                            confirmButtonColor: '#7c3aed'
                        }).then(() => {
                            otpModal.style.display = 'block';
                        });
                    } else {
                        Swal.fire('Error', 'Email not registered or could not send OTP.', 'error');
                    }
                });
            });

            // Verify OTP
            otpInputs.forEach((inp, idx) => {
                inp.addEventListener('input', function() { if (this.value && idx < 5) otpInputs[idx + 1].focus(); });
                inp.addEventListener('keydown', function(e) { if (e.key === 'Backspace' && !this.value && idx > 0) otpInputs[idx - 1].focus(); });
            });

            verifyOtpBtn.addEventListener('click', function() {
                let enteredOtp = Array.from(otpInputs).map(i => i.value).join('');
                if (enteredOtp.length !== 6) return Swal.fire('Error', 'Enter 6-digit OTP', 'error');

                verifyOtpBtn.disabled = true; verifyOtpBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Verifying...';

                fetch('VerifyOtpServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({'otp': enteredOtp}).toString()
                }).then(res => res.text()).then(data => {
                    verifyOtpBtn.disabled = false; verifyOtpBtn.innerHTML = 'Verify OTP';
                    if(data.trim() === "success") {
                        Swal.fire('Verified', 'You can reset your password', 'success');
                        otpModal.style.display = 'none'; resetModal.style.display = 'block';
                    } else {
                        Swal.fire('Invalid', 'OTP is incorrect', 'error');
                    }
                });
            });

            // Reset Password
            resetPwdBtn.addEventListener('click', function() {
                const np = document.getElementById('newPassword').value;
                const cp = document.getElementById('confirmNewPassword').value;
                if (!np || np !== cp) return Swal.fire('Error', 'Passwords must match', 'error');

                resetPwdBtn.disabled = true; resetPwdBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Resetting...';

                fetch('ResetPasswordServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({'newPassword': np}).toString()
                }).then(res => res.text()).then(data => {
                    resetPwdBtn.disabled = false; resetPwdBtn.innerHTML = 'Reset Password';
                    if(data.trim() === "success") {
                        Swal.fire({
                            icon: 'success',
                            title: 'Success!',
                            text: 'Password successfully changed. Please log in with your new password.',
                            confirmButtonColor: '#7c3aed'
                        }).then(() => {
                            resetModal.style.display = 'none';
                        });
                    } else {
                        Swal.fire('Error', 'Failed to update password.', 'error');
                    }
                });
            });
        });

        // === ENHANCED FORM SUBMISSION (FIXED BULLETPROOF PAYLOAD) ===
        document.addEventListener("DOMContentLoaded", function() {
            document.getElementById('loginForm').addEventListener('submit', function(e) {
                e.preventDefault(); 
                
                const inputCaptcha = document.getElementById('loginCaptchaInput').value;
                const hiddenCaptcha = document.getElementById('loginCaptchaHidden').value;
                if (inputCaptcha !== hiddenCaptcha) {
                    Swal.fire('Error', 'Invalid CAPTCHA', 'error');
                    return;
                }

                const loginBtn = document.querySelector('#loginForm .btn');
                loginBtn.disabled = true;
                loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Logging in...';

                // Bulletproof dynamic payload capture to match LibloginSignup.java perfectly
                const formData = new URLSearchParams(new FormData(this));
                const emailVal = document.querySelector('#loginForm input[name="email"]').value.trim();
                formData.set('email', emailVal);
                formData.set('captchaInput', inputCaptcha);
                formData.set('captchaText', hiddenCaptcha);

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
                    Swal.fire('Error', 'Invalid email or password', 'error');
                    loginBtn.disabled = false;
                    loginBtn.innerHTML = 'Login';
                });
            });
            
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

                    const registerBtn = document.getElementById('registerBtn');
                    registerBtn.disabled = true;
                    registerBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating...';

                    const formData = new FormData(registerForm);

                    fetch(this.getAttribute('action'), {
                        method: 'POST',
                        body: formData
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
        });

        // === 15-MINUTE IDLE LOGOUT ===
        let idleTime = 0;
        setInterval(() => {
            idleTime++;
            if (idleTime >= 15) {
                alert("Session expired due to 15 minutes of inactivity.");
                window.location.href = "LogoutServlet"; 
            }
        }, 60000); // 1 minute
        document.addEventListener('mousemove', () => idleTime = 0);
        document.addEventListener('keypress', () => idleTime = 0);
        document.addEventListener('click', () => idleTime = 0);
    </script>
</body>
</html>
