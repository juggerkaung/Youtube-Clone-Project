<!-- adminLogin.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - YouTube Clone</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #666;
            font-weight: bold;
        }
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #ff0000;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            font-weight: bold;
        }
        button:hover {
            background: #cc0000;
        }
        .error {
            color: #ff0000;
            text-align: center;
            margin-bottom: 15px;
            padding: 10px;
            background: #fff0f0;
            border-radius: 4px;
        }
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        .back-link a {
            color: #065fd4;
            text-decoration: none;
        }
        .admin-note {
            text-align: center;
            color: #666;
            font-size: 12px;
            margin-top: 20px;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Admin Login</h2>
        
        <c:if test="${not empty param.error}">
            <div class="error">${param.error}</div>
        </c:if>
        
        <form action="adminLogin" method="post">
            <div class="form-group">
                <label for="email">Admin Email</label>
                <input type="email" id="email" name="email" required placeholder="admin@youtube.com">
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="••••••••">
            </div>
            
            <button type="submit">Login as Admin</button>
        </form>
        
        <div class="back-link">
            <a href="home">← Back to Home</a>
        </div>
        
        <div class="admin-note">
            Note: Only users with admin privileges can access this panel
        </div>
    </div>
</body>
</html>