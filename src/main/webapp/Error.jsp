<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
 <link rel="icon" type="image/x-icon" href="logo2.jpg">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Error</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: rgb(250,128,114);
            color: white;
            text-align: center;
        }
        .container {
            background: #29293d;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            animation: fadeIn 1s ease-in-out;
        }
        h2 {
            font-size: 26px;
            color: #ff4b5c;
            margin-bottom: 10px;
        }
        .error-message {
            font-size: 18px;
            color: #ddd;
            margin-bottom: 20px;
            background: rgba(255, 75, 92, 0.2);
            padding: 15px;
            border-radius: 8px;
        }
        .motivation {
            font-size: 16px;
            font-style: italic;
            color: #bbb;
            margin-bottom: 20px;
        }
        button {
            padding: 12px 20px;
            background: #ff4b5c;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            cursor: pointer;
            transition: 0.3s;
        }
        button:hover {
            background: #e43e4e;
            transform: scale(1.05);
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🚫 Login Failed!</h2>
        <p class="error-message">Invalid Username or Password. Please try again.</p>
        <p class="motivation">"Failure is simply the opportunity to begin again, this time more intelligently." 💡</p>
        <button onclick="redirectToLogin()">🔄 Try Again</button>
    </div>

    <script>
        function redirectToLogin() {
            window.location.href = 'Login.jsp';
        }
    </script>
</body>
</html>