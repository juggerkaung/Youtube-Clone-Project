<!-- register.jsp file -->
<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Your Channel - YouTube Clone</title>
    <style>
        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"], input[type="email"], input[type="password"], textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .btn {
            background: #cc0000;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            width: 100%;
        }
        .btn:hover {
            background: #b30000;
        }
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
        }
        .success-message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #2e7d32;
        }
        .requirements {
            font-size: 13px;
            color: #666;
            margin-top: 5px;
        }
        .requirements ul {
            margin: 5px 0;
            padding-left: 20px;
        }
        .requirements li {
            margin-bottom: 3px;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        .login-link a {
            color: #065fd4;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container">
        <h2 style="text-align: center; color: #cc0000; margin-bottom: 30px;">Create Your Channel</h2>
        
        Display error messages
        <c:if test="${not empty param.error}">
            <div class="error-message">
                <strong>⚠️ Error:</strong> ${param.error}
            </div>
        </c:if>
        
        Display success messages
        <c:if test="${not empty param.success}">
            <div class="success-message">
                <strong>✅ Success:</strong> ${param.success}
            </div>
        </c:if>
        
        <form action="registerChannel" method="post" id="registerForm" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="email">Email Address:</label>
                <input type="email" id="email" name="email" 
                       placeholder="example@gmail.com" 
                       required
                       oninput="validateEmail()">
                <div class="requirements">
                    <ul>
                        <li>Must be a valid Gmail address (ending with @gmail.com)</li>
                        <li>Must be 10-30 characters long</li>
                        <li>Email must be unique</li>
                    </ul>
                    <span id="emailError" style="color: #c62828; display: none;"></span>
                </div>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" 
                       placeholder="Enter password" 
                       required
                       oninput="validatePassword()">
                <div class="requirements">
                    <ul>
                        <li>Must be 8-20 characters long</li>
                        <li>Must contain at least one letter (a-z, A-Z)</li>
                        <li>Must contain at least one number (0-9)</li>
                        <li>Special characters allowed: @$!%*?&</li>
                    </ul>
                    <span id="passwordError" style="color: #c62828; display: none;"></span>
                </div>
            </div>
            
            <div class="form-group">
                <label for="passwordConfirm">Confirm Password:</label>
                <input type="password" id="passwordConfirm" name="passwordConfirm" 
                       placeholder="Confirm password" 
                       required
                       oninput="validatePasswordConfirm()">
                <span id="passwordConfirmError" style="color: #c62828; font-size: 13px; display: none;"></span>
            </div>
            
            <div class="form-group">
                <label for="displayName">Channel Name:</label>
                <input type="text" id="displayName" name="displayName" 
                       placeholder="Enter your channel name" 
                       required
                       oninput="validateDisplayName()">
                <div class="requirements">
                    <ul>
                        <li>Must be 3-50 characters long</li>
                        <li>Channel name must be unique</li>
                        <li>This will be displayed as your public channel name</li>
                    </ul>
                    <span id="displayNameError" style="color: #c62828; display: none;"></span>
                </div>
            </div>
            
            <div class="form-group">
                <label for="description">Channel Description (optional):</label>
                <textarea id="description" name="description" 
                          placeholder="Tell us about your channel..."></textarea>
            </div>
            
            <button type="submit" class="btn">Create Channel</button>
        </form>
        
        <div class="login-link">
            Already have a channel? <a href="login.jsp">Login here</a>
        </div>
    </div>

    <script>
        // Validation functions
        const emailPattern = /^[A-Za-z0-9+_.-]+@gmail\.com$/;
        const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,20}$/;
        
        function validateEmail() {
            const email = document.getElementById('email').value;
            const errorElement = document.getElementById('emailError');
            
            if (!email) {
                errorElement.textContent = "Email is required";
                errorElement.style.display = 'block';
                return false;
            }
            
            if (!emailPattern.test(email)) {
                errorElement.textContent = "Email must be a valid Gmail address (ending with @gmail.com)";
                errorElement.style.display = 'block';
                return false;
            }
            
            if (email.length < 10 || email.length > 30) {
                errorElement.textContent = "Email must be between 10 and 30 characters long";
                errorElement.style.display = 'block';
                return false;
            }
            
            errorElement.style.display = 'none';
            return true;
        }
        
        function validatePassword() {
            const password = document.getElementById('password').value;
            const errorElement = document.getElementById('passwordError');
            
            if (!password) {
                errorElement.textContent = "Password is required";
                errorElement.style.display = 'block';
                return false;
            }
            
            if (!passwordPattern.test(password)) {
                errorElement.textContent = "Password must be 8-20 characters with at least one letter and one number";
                errorElement.style.display = 'block';
                return false;
            }
            
            errorElement.style.display = 'none';
            return true;
        }
        
        function validatePasswordConfirm() {
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;
            const errorElement = document.getElementById('passwordConfirmError');
            
            if (password !== passwordConfirm) {
                errorElement.textContent = "Passwords do not match";
                errorElement.style.display = 'block';
                return false;
            }
            
            errorElement.style.display = 'none';
            return true;
        }
        
        function validateDisplayName() {
            const displayName = document.getElementById('displayName').value;
            const errorElement = document.getElementById('displayNameError');
            
            if (!displayName) {
                errorElement.textContent = "Channel name is required";
                errorElement.style.display = 'block';
                return false;
            }
            
            if (displayName.length < 3 || displayName.length > 50) {
                errorElement.textContent = "Channel name must be between 3 and 50 characters";
                errorElement.style.display = 'block';
                return false;
            }
            
            errorElement.style.display = 'none';
            return true;
        }
        
        function validateForm() {
            const isEmailValid = validateEmail();
            const isPasswordValid = validatePassword();
            const isPasswordConfirmValid = validatePasswordConfirm();
            const isDisplayNameValid = validateDisplayName();
            
            if (!isEmailValid || !isPasswordValid || !isPasswordConfirmValid || !isDisplayNameValid) {
                // Scroll to first error
                const firstError = document.querySelector('[style*="display: block"]');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                return false;
            }
            
            return true;
        }
        
        // Initialize validation on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Clear any existing error messages from server-side
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('error')) {
                // Scroll to form
                document.querySelector('.container').scrollIntoView({ behavior: 'smooth' });
            }
        });
    </script>
</body>
</html> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Your Channel - YouTube Clone</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Roboto', 'Arial', sans-serif;
        }
        
        body {
            background: #f9f9f9;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .register-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex: 1;
            padding: 40px 20px;
            background: linear-gradient(135deg, #f5f5f5 0%, #e8f4fd 100%);
        }
        
        .register-card {
            background: white;
            width: 100%;
            max-width: 450px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 40px;
            border: 1px solid #e0e0e0;
        }
        
        .logo-container {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo {
            font-size: 32px;
            font-weight: 700;
            color: #ff0000;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }
        
        .logo-subtitle {
            color: #606060;
            font-size: 18px;
            font-weight: 400;
        }
        
        .form-header {
            margin-bottom: 30px;
        }
        
        .form-header h1 {
            font-size: 24px;
            color: #202124;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-header p {
            color: #5f6368;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #3c4043;
            font-size: 14px;
            font-weight: 500;
        }
        
        .form-input {
            width: 100%;
            padding: 13px 16px;
            border: 1px solid #dadce0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.2s;
            background: white;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #1a73e8;
            box-shadow: 0 0 0 3px rgba(26, 115, 232, 0.1);
        }
        
        .form-input::placeholder {
            color: #9aa0a6;
        }
        
        .form-textarea {
            min-height: 100px;
            resize: vertical;
            line-height: 1.5;
        }
        
        .requirements {
            font-size: 12px;
            color: #5f6368;
            margin-top: 6px;
            line-height: 1.4;
        }
        
        .requirements ul {
            list-style: none;
            padding-left: 0;
            margin: 4px 0;
        }
        
        .requirements li {
            margin-bottom: 4px;
            display: flex;
            align-items: flex-start;
        }
        
        .requirements li:before {
            content: "•";
            color: #5f6368;
            margin-right: 8px;
        }
        
        .error-message {
            background: #fce8e6;
            color: #c5221f;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
            font-size: 14px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .error-icon {
            font-size: 18px;
            flex-shrink: 0;
        }
        
        .success-message {
            background: #e6f4ea;
            color: #137333;
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
            font-size: 14px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .success-icon {
            font-size: 18px;
            flex-shrink: 0;
        }
        
        .btn {
            width: 100%;
            padding: 14px 24px;
            background: #ff0000;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 10px;
        }
        
        .btn:hover {
            background: #cc0000;
            box-shadow: 0 2px 6px rgba(255, 0, 0, 0.2);
        }
        
        .btn:active {
            transform: translateY(1px);
        }
        
        .login-link {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            color: #5f6368;
            font-size: 14px;
        }
        
        .login-link a {
            color: #1a73e8;
            text-decoration: none;
            font-weight: 500;
            margin-left: 5px;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .validation-error {
            color: #d93025;
            font-size: 12px;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
            display: none;
        }
        
        .password-container {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #5f6368;
            cursor: pointer;
            font-size: 14px;
        }
        
        .input-hint {
            color: #5f6368;
            font-size: 12px;
            margin-top: 4px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .input-hint.hidden {
            display: none;
        }
        
        @media (max-width: 480px) {
            .register-card {
                padding: 30px 24px;
                border-radius: 0;
                box-shadow: none;
                border: none;
            }
            
            .register-container {
                padding: 0;
                background: white;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="register-container">
        <div class="register-card">
            <div class="logo-container">
                <div class="logo">YouTube</div>
                <div class="logo-subtitle">Create your channel</div>
            </div>
            
            <div class="form-header">
                <h1>Create your YouTube channel</h1>
                <p>Get started with your own channel to share videos with the world</p>
            </div>
            
            <%-- Display error messages --%>
            <c:if test="${not empty param.error && not empty param.error.trim()}">
                <div class="error-message">
                    <span class="error-icon">⚠️</span>
                    <div>${param.error}</div>
                </div>
            </c:if>
            
            <%-- Display success messages --%>
            <c:if test="${not empty param.success && not empty param.success.trim()}">
                <div class="success-message">
                    <span class="success-icon">✅</span>
                    <div>${param.success}</div>
                </div>
            </c:if>
            
            <form action="registerChannel" method="post" id="registerForm" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="email" class="form-label">Email address</label>
                    <input type="email" id="email" name="email" 
                           class="form-input"
                           placeholder="you@gmail.com" 
                           required
                           oninput="validateEmail()">
                    <div class="input-hint" id="emailHint">Enter your Gmail address</div>
                    <div class="validation-error" id="emailError">
                        <span style="font-size: 14px;">❌</span>
                        <span id="emailErrorText"></span>
                    </div>
                    <div class="requirements">
                        <ul>
                            <li>Must be a valid Gmail address (ending with @gmail.com)</li>
                            <li>Must be 10-30 characters long</li>
                            <li>Email must be unique and not already registered</li>
                        </ul>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" 
                               class="form-input"
                               placeholder="Create a strong password" 
                               required
                               oninput="validatePassword()">
                        <button type="button" class="password-toggle" onclick="togglePassword('password')">👁️</button>
                    </div>
                    <div class="validation-error" id="passwordError">
                        <span style="font-size: 14px;">❌</span>
                        <span id="passwordErrorText"></span>
                    </div>
                    <div class="requirements">
                        <ul>
                            <li>Must be 8-20 characters long</li>
                            <li>Must contain at least one letter (a-z, A-Z)</li>
                            <li>Must contain at least one number (0-9)</li>
                            <li>Special characters allowed: @$!%*?&</li>
                        </ul>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="passwordConfirm" class="form-label">Confirm password</label>
                    <div class="password-container">
                        <input type="password" id="passwordConfirm" name="passwordConfirm" 
                               class="form-input"
                               placeholder="Re-enter your password" 
                               required
                               oninput="validatePasswordConfirm()">
                        <button type="button" class="password-toggle" onclick="togglePassword('passwordConfirm')">👁️</button>
                    </div>
                    <div class="validation-error" id="passwordConfirmError">
                        <span style="font-size: 14px;">❌</span>
                        <span id="passwordConfirmErrorText"></span>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="displayName" class="form-label">Channel name</label>
                    <input type="text" id="displayName" name="displayName" 
                           class="form-input"
                           placeholder="Choose a unique channel name" 
                           required
                           oninput="validateDisplayName()">
                    <div class="input-hint" id="displayNameHint">This will be displayed as your public channel name</div>
                    <div class="validation-error" id="displayNameError">
                        <span style="font-size: 14px;">❌</span>
                        <span id="displayNameErrorText"></span>
                    </div>
                    <div class="requirements">
                        <ul>
                            <li>Must be 3-50 characters long</li>
                            <li>Channel name must be unique</li>
                            <li>You can change this later in your channel settings</li>
                        </ul>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="description" class="form-label">Channel description (optional)</label>
                    <textarea id="description" name="description" 
                              class="form-input form-textarea"
                              placeholder="Tell viewers about your channel..."></textarea>
                    <div class="input-hint">You can add or edit this later</div>
                </div>
                
                <button type="submit" class="btn">Create channel</button>
            </form>
            
            <div class="login-link">
                Already have a channel? <a href="login.jsp">Sign in instead</a>
            </div>
        </div>
    </div>

    <script>
        // Validation patterns
        const emailPattern = /^[A-Za-z0-9+_.-]+@gmail\.com$/;
        const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,20}$/;
        
        // Toggle password visibility
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const toggle = input.nextElementSibling;
            
            if (input.type === 'password') {
                input.type = 'text';
                toggle.textContent = '👁️‍🗨️';
            } else {
                input.type = 'password';
                toggle.textContent = '👁️';
            }
        }
        
        // Validation functions
        function validateEmail() {
            const email = document.getElementById('email').value.trim();
            const errorElement = document.getElementById('emailError');
            const errorText = document.getElementById('emailErrorText');
            const hint = document.getElementById('emailHint');
            
            if (!email) {
                errorText.textContent = "Email is required";
                errorElement.style.display = 'flex';
                hint.classList.add('hidden');
                return false;
            }
            
            if (!emailPattern.test(email)) {
                errorText.textContent = "Email must be a valid Gmail address (ending with @gmail.com)";
                errorElement.style.display = 'flex';
                hint.classList.add('hidden');
                return false;
            }
            
            if (email.length < 10 || email.length > 30) {
                errorText.textContent = "Email must be between 10 and 30 characters long";
                errorElement.style.display = 'flex';
                hint.classList.add('hidden');
                return false;
            }
            
            errorElement.style.display = 'none';
            hint.classList.remove('hidden');
            return true;
        }
        
        function validatePassword() {
            const password = document.getElementById('password').value;
            const errorElement = document.getElementById('passwordError');
            const errorText = document.getElementById('passwordErrorText');
            
            if (!password) {
                errorText.textContent = "Password is required";
                errorElement.style.display = 'flex';
                return false;
            }
            
            if (!passwordPattern.test(password)) {
                errorText.textContent = "Password must be 8-20 characters with at least one letter and one number";
                errorElement.style.display = 'flex';
                return false;
            }
            
            errorElement.style.display = 'none';
            return true;
        }
        
        function validatePasswordConfirm() {
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;
            const errorElement = document.getElementById('passwordConfirmError');
            const errorText = document.getElementById('passwordConfirmErrorText');
            
            if (!passwordConfirm) {
                errorText.textContent = "Please confirm your password";
                errorElement.style.display = 'flex';
                return false;
            }
            
            if (password !== passwordConfirm) {
                errorText.textContent = "Passwords do not match";
                errorElement.style.display = 'flex';
                return false;
            }
            
            errorElement.style.display = 'none';
            return true;
        }
        
        function validateDisplayName() {
            const displayName = document.getElementById('displayName').value.trim();
            const errorElement = document.getElementById('displayNameError');
            const errorText = document.getElementById('displayNameErrorText');
            const hint = document.getElementById('displayNameHint');
            
            if (!displayName) {
                errorText.textContent = "Channel name is required";
                errorElement.style.display = 'flex';
                hint.classList.add('hidden');
                return false;
            }
            
            if (displayName.length < 3 || displayName.length > 50) {
                errorText.textContent = "Channel name must be between 3 and 50 characters";
                errorElement.style.display = 'flex';
                hint.classList.add('hidden');
                return false;
            }
            
            errorElement.style.display = 'none';
            hint.classList.remove('hidden');
            return true;
        }
        
        function validateForm() {
            const isEmailValid = validateEmail();
            const isPasswordValid = validatePassword();
            const isPasswordConfirmValid = validatePasswordConfirm();
            const isDisplayNameValid = validateDisplayName();
            
            if (!isEmailValid || !isPasswordValid || !isPasswordConfirmValid || !isDisplayNameValid) {
                // Scroll to first error
                const firstError = document.querySelector('.validation-error[style*="display: flex"]');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                return false;
            }
            
            // Show loading state
            const submitBtn = document.querySelector('.btn');
            const originalText = submitBtn.textContent;
            submitBtn.textContent = 'Creating channel...';
            submitBtn.disabled = true;
            
            // Re-enable after 5 seconds just in case
            setTimeout(() => {
                submitBtn.textContent = originalText;
                submitBtn.disabled = false;
            }, 5000);
            
            return true;
        }
        
        // Initialize validation on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Clear any existing error/success messages if they're empty
            const urlParams = new URLSearchParams(window.location.search);
            
            // If there are no error or success parameters, hide the message containers
            const errorMessage = document.querySelector('.error-message');
            const successMessage = document.querySelector('.success-message');
            
            if (!urlParams.has('error') && errorMessage) {
                errorMessage.style.display = 'none';
            }
            
            if (!urlParams.has('success') && successMessage) {
                successMessage.style.display = 'none';
            }
            
            // Clear error messages when user starts typing
            const inputs = document.querySelectorAll('.form-input');
            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    const errorId = this.id + 'Error';
                    const errorElement = document.getElementById(errorId);
                    if (errorElement) {
                        errorElement.style.display = 'none';
                    }
                });
            });
            
            // Focus on first input
            document.getElementById('email').focus();
        });
        
        // Handle form submission with Enter key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                const form = document.getElementById('registerForm');
                if (form && !e.target.matches('textarea')) {
                    e.preventDefault();
                    if (form.reportValidity()) {
                        form.submit();
                    }
                }
            }
        });
    </script>
</body>
</html>