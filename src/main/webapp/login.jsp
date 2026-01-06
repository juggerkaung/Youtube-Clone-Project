<!-- login.jsp file -->
<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Channel Login</title>
</head>
<body>
    <h2>Channel Login</h2>
    
    <% if (request.getParameter("error") != null) { %>
        <div style="color: red;"><%= request.getParameter("error") %></div>
    <% } %>
    
    <form action="loginChannel" method="post">
        <div>
            <label>Email:</label>
            <input type="email" name="email" required>
        </div>
        
        <div>
            <label>Password:</label>
            <input type="password" name="password" required>
        </div>
        
        <button type="submit">Login</button>
    </form>
    
    <p>Don't have a channel? <a href="register.jsp">Register here</a></p>
</body>
</html> --%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sign in - YouTube Clone</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --youtube-red: #FF0000;
            --youtube-dark: #0F0F0F;
            --youtube-gray: #606060;
            --youtube-light-gray: #F2F2F2;
            --youtube-text: #0F0F0F;
            --youtube-text-secondary: #606060;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: "Roboto", "Arial", sans-serif;
            background-color: #F9F9F9;
            color: var(--youtube-text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .login-header {
            padding: 20px 24px;
            border-bottom: 1px solid #E5E5E5;
        }
        
        .logo-container {
            display: flex;
            align-items: center;
            gap: 4px;
            text-decoration: none;
        }
        
        .logo-icon {
            color: var(--youtube-red);
            font-size: 24px;
        }
        
        .logo-text {
            font-size: 20px;
            font-weight: bold;
            color: var(--youtube-text);
        }
        
        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex: 1;
            padding: 40px 20px;
        }
        
        .login-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            padding: 48px 40px;
        }
        
        .login-title {
            font-size: 28px;
            font-weight: 400;
            margin-bottom: 8px;
            text-align: center;
        }
        
        .login-subtitle {
            color: var(--youtube-text-secondary);
            text-align: center;
            margin-bottom: 32px;
            font-size: 15px;
        }
        
        .login-form {
            width: 100%;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            color: var(--youtube-text);
            font-weight: 500;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #DADCE0;
            border-radius: 4px;
            font-size: 16px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: var(--youtube-red);
            box-shadow: 0 0 0 3px rgba(255, 0, 0, 0.1);
        }
        
        .form-input.error {
            border-color: #EA4335;
        }
        
        .error-message {
            color: #EA4335;
            font-size: 14px;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .login-button {
            width: 100%;
            padding: 14px;
            background-color: var(--youtube-red);
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s, transform 0.1s;
            margin-top: 8px;
        }
        
        .login-button:hover {
            background-color: #CC0000;
        }
        
        .login-button:active {
            transform: scale(0.98);
        }
        
        .login-button:disabled {
            background-color: #FFCCCC;
            cursor: not-allowed;
        }
        
        .divider {
            display: flex;
            align-items: center;
            margin: 32px 0;
            color: var(--youtube-text-secondary);
            font-size: 14px;
        }
        
        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            height: 1px;
            background-color: #E5E5E5;
        }
        
        .divider span {
            padding: 0 16px;
        }
        
        .alternative-login {
            text-align: center;
        }
        
        .register-link {
            display: inline-block;
            padding: 12px 24px;
            background-color: white;
            color: var(--youtube-text);
            border: 1px solid #DADCE0;
            border-radius: 4px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            transition: background-color 0.2s, border-color 0.2s;
        }
        
        .register-link:hover {
            background-color: #F8F8F8;
            border-color: #C6C6C6;
        }
        
        .register-link i {
            margin-right: 8px;
        }
        
        .footer-links {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #E5E5E5;
            text-align: center;
        }
        
        .footer-link {
            color: var(--youtube-text-secondary);
            text-decoration: none;
            font-size: 13px;
            margin: 0 12px;
        }
        
        .footer-link:hover {
            color: var(--youtube-red);
            text-decoration: underline;
        }
        
        .admin-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: var(--youtube-red);
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
        }
        
        .admin-link:hover {
            text-decoration: underline;
        }
        
        /* Responsive Design */
        @media (max-width: 600px) {
            .login-card {
                padding: 32px 24px;
                box-shadow: none;
                border: 1px solid #E5E5E5;
            }
            
            .login-title {
                font-size: 24px;
            }
        }
        
        @media (max-width: 480px) {
            .login-container {
                padding: 20px 16px;
            }
            
            .login-card {
                padding: 24px 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="login-header">
        <a href="home" class="logo-container">
            <i class="fab fa-youtube logo-icon"></i>
            <span class="logo-text">YouTube Clone</span>
        </a>
    </header>
    
    <!-- Main Login Container -->
    <div class="login-container">
        <div class="login-card">
            <h1 class="login-title">Sign in</h1>
            <p class="login-subtitle">to continue to YouTube Clone</p>
            
            <!-- Error Display -->
            <c:if test="${not empty param.error}">
                <div class="error-message" style="margin-bottom: 20px; padding: 12px; background-color: #FCE8E6; border-radius: 4px; border-left: 4px solid #EA4335;">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${param.error}</span>
                </div>
            </c:if>
            
            <form action="loginChannel" method="post" class="login-form" id="loginForm">
                <div class="form-group">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" 
                           id="email" 
                           name="email" 
                           class="form-input" 
                           placeholder="Enter your email"
                           required
                           autocomplete="email"
                           autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           class="form-input" 
                           placeholder="Enter your password"
                           required
                           autocomplete="current-password">
                </div>
                
                <button type="submit" class="login-button" id="loginBtn">
                    Sign in
                </button>
            </form>
            
            <div class="divider">
                <span>or</span>
            </div>
            
            <div class="alternative-login">
                <a href="register.jsp" class="register-link">
                    <i class="fas fa-user-plus"></i>
                    Create an account
                </a>
            </div>
            
            <a href="adminLogin.jsp" class="admin-link">
                <i class="fas fa-user-shield"></i>
                Admin login
            </a>
            
            <div class="footer-links">
                <a href="#" class="footer-link">Help</a>
                <a href="#" class="footer-link">Privacy</a>
                <a href="#" class="footer-link">Terms</a>
            </div>
        </div>
    </div>
    
    <script>
    // Form validation and enhancement
    document.addEventListener('DOMContentLoaded', function() {
        const loginForm = document.getElementById('loginForm');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        const loginBtn = document.getElementById('loginBtn');
        
        // Email validation
        function validateEmail(email) {
            const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return re.test(email);
        }
        
        // Update form validity
        function updateFormValidity() {
            const isEmailValid = validateEmail(emailInput.value);
            const isPasswordValid = passwordInput.value.length >= 6;
            
            if (emailInput.value && !isEmailValid) {
                emailInput.classList.add('error');
            } else {
                emailInput.classList.remove('error');
            }
            
            loginBtn.disabled = !(isEmailValid && isPasswordValid);
        }
        
        // Event listeners
        emailInput.addEventListener('input', updateFormValidity);
        passwordInput.addEventListener('input', updateFormValidity);
        
        // Form submission
        loginForm.addEventListener('submit', function(e) {
            const email = emailInput.value.trim();
            const password = passwordInput.value;
            
            if (!validateEmail(email)) {
                e.preventDefault();
                emailInput.focus();
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                passwordInput.focus();
                return false;
            }
            
            // Show loading state
            loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Signing in...';
            loginBtn.disabled = true;
            
            return true;
        });
        
        // Enter key navigation
        emailInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !validateEmail(emailInput.value)) {
                e.preventDefault();
            }
        });
        
        passwordInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && emailInput.value && !passwordInput.value) {
                e.preventDefault();
                passwordInput.focus();
            }
        });
        
        // Focus management
        emailInput.focus();
        
        // Auto-capitalize first letter of email (for better UX)
        emailInput.addEventListener('blur', function() {
            if (this.value && this.value.indexOf('@') === -1) {
                this.value = this.value.toLowerCase();
            }
        });
    });
    </script>
</body>
</html>