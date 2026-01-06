<!-- editChannelProfile.jsp file -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Channel Profile - YouTube Clone</title>
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
        
        .edit-profile-container {
            max-width: 800px;
            margin: 20px auto;
            padding: 0 20px;
        }
        
        .edit-profile-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
            padding: 30px 40px;
            position: relative;
        }
        
        .profile-header h1 {
            font-size: 28px;
            font-weight: 500;
            margin-bottom: 8px;
        }
        
        .profile-header p {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .back-link {
            position: absolute;
            top: 30px;
            right: 40px;
            color: white;
            text-decoration: none;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            transition: background 0.2s;
        }
        
        .back-link:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .profile-content {
            padding: 40px;
        }
        
        .form-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            font-size: 20px;
            color: #202124;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e0e0e0;
            font-weight: 500;
        }
        
        .profile-picture-section {
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .current-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e0e0e0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .avatar-placeholder {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 42px;
            font-weight: bold;
            border: 3px solid #e0e0e0;
        }
        
        .avatar-info {
            flex: 1;
        }
        
        .avatar-info h3 {
            font-size: 16px;
            color: #202124;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .avatar-info p {
            font-size: 14px;
            color: #5f6368;
            margin-bottom: 16px;
            line-height: 1.5;
        }
        
        .file-upload {
            position: relative;
            display: inline-block;
        }
        
        .file-upload input[type="file"] {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }
        
        .upload-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: #1a73e8;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
        }
        
        .upload-btn:hover {
            background: #0d62d9;
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
        
        .form-label span {
            color: #d93025;
            margin-left: 4px;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 16px;
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
        
        .form-textarea {
            min-height: 120px;
            resize: vertical;
            line-height: 1.5;
        }
        
        .char-count {
            font-size: 12px;
            color: #5f6368;
            margin-top: 4px;
            text-align: right;
        }
        
        .char-count.warning {
            color: #fbbc04;
        }
        
        .char-count.error {
            color: #d93025;
        }
        
        .form-hint {
            font-size: 12px;
            color: #5f6368;
            margin-top: 4px;
            line-height: 1.4;
        }
        
        .message {
            padding: 14px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .message.success {
            background: #e6f4ea;
            color: #137333;
            border: 1px solid #c3e6cb;
        }
        
        .message.error {
            background: #fce8e6;
            color: #c5221f;
            border: 1px solid #f5c6cb;
        }
        
        .message-icon {
            font-size: 18px;
            flex-shrink: 0;
        }
        
        .action-buttons {
            display: flex;
            gap: 16px;
            margin-top: 40px;
            padding-top: 24px;
            border-top: 1px solid #e0e0e0;
        }
        
        .btn {
            padding: 12px 32px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
        }
        
        .btn-primary {
            background: #ff0000;
            color: white;
        }
        
        .btn-primary:hover {
            background: #cc0000;
            box-shadow: 0 2px 6px rgba(255, 0, 0, 0.2);
        }
        
        .btn-secondary {
            background: #f8f9fa;
            color: #3c4043;
            border: 1px solid #dadce0;
        }
        
        .btn-secondary:hover {
            background: #f1f3f4;
            border-color: #c4c7c5;
        }
        
        .stats-section {
            background: #f8f9fa;
            padding: 24px;
            border-radius: 8px;
            margin-top: 40px;
        }
        
        .stats-title {
            font-size: 16px;
            color: #202124;
            margin-bottom: 16px;
            font-weight: 500;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 16px;
        }
        
        .stat-item {
            text-align: center;
            padding: 16px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: 500;
            color: #ff0000;
            margin-bottom: 4px;
        }
        
        .stat-label {
            font-size: 12px;
            color: #5f6368;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        @media (max-width: 768px) {
            .edit-profile-container {
                padding: 0 16px;
                margin: 10px auto;
            }
            
            .profile-header {
                padding: 24px 20px;
            }
            
            .profile-content {
                padding: 24px 20px;
            }
            
            .profile-picture-section {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .back-link {
                position: relative;
                top: 0;
                right: 0;
                margin-top: 16px;
                display: inline-flex;
            }
        }
        
        .preview-container {
            margin-top: 20px;
            padding: 16px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px dashed #dadce0;
        }
        
        .preview-title {
            font-size: 14px;
            color: #5f6368;
            margin-bottom: 12px;
            font-weight: 500;
        }
        
        .preview-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
        }
        
        .preview-displayname {
            font-size: 18px;
            font-weight: 500;
            color: #202124;
            margin: 12px 0 4px;
        }
        
        .preview-description {
            font-size: 14px;
            color: #5f6368;
            line-height: 1.4;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="edit-profile-container">
        <div class="edit-profile-card">
            <div class="profile-header">
                <h1>Edit Channel Profile</h1>
                <p>Customize how you appear to viewers on YouTube</p>
                <a href="channelDashboard" class="back-link">
                    <span>←</span> Back to Dashboard
                </a>
            </div>
            
            <div class="profile-content">
                <!-- Success/Error Messages -->
                <c:if test="${not empty param.success}">
                    <div class="message success">
                        <span class="message-icon">✅</span>
                        <div>${param.success}</div>
                    </div>
                </c:if>
                
                <c:if test="${not empty param.error}">
                    <div class="message error">
                        <span class="message-icon">⚠️</span>
                        <div>${param.error}</div>
                    </div>
                </c:if>
                
                <form action="editChannelProfile" method="post" enctype="multipart/form-data" id="profileForm">
                    <!-- Profile Picture Section -->
                    <div class="form-section">
                        <h2 class="section-title">Profile Picture</h2>
                        <div class="profile-picture-section">
                            <c:choose>
                                <c:when test="${not empty sessionScope.channel.profilePicture}">
                                    <img src="${pageContext.request.contextPath}/${sessionScope.channel.profilePicture}" 
                                         alt="Current Profile" 
                                         class="current-avatar"
                                         id="currentAvatar">
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.channel.displayName}">
                                            <div class="avatar-placeholder" id="avatarPlaceholder">
                                                ${fn:substring(sessionScope.channel.displayName, 0, 1)}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="avatar-placeholder" id="avatarPlaceholder">
                                                ?
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="avatar-info">
                                <h3>Channel Avatar</h3>
                                <p>This picture will appear next to your videos and comments. Recommended size: 800x800 pixels. Max size: 2MB.</p>
                                <div class="file-upload">
                                    <button type="button" class="upload-btn" id="uploadBtn">
                                        <span>📷</span> Change Photo
                                    </button>
                                    <input type="file" 
                                           name="profilePicture" 
                                           accept="image/*" 
                                           id="profilePictureInput"
                                           onchange="previewImage(event)">
                                </div>
                                <div class="form-hint" id="fileInfo">No file selected</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Channel Information Section -->
                    <div class="form-section">
                        <h2 class="section-title">Channel Information</h2>
                        
                        <div class="form-group">
                            <label for="displayName" class="form-label">
                                Display Name <span>*</span>
                            </label>
                            <input type="text" 
                                   id="displayName" 
                                   name="displayName" 
                                   class="form-input"
                                   value="${sessionScope.channel.displayName}" 
                                   required
                                   maxlength="50"
                                   oninput="updatePreview()">
                            <div class="char-count" id="nameCharCount">${fn:length(sessionScope.channel.displayName)}/50</div>
                            <div class="form-hint">This is the name that will appear on your channel and videos</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" 
                                      name="description" 
                                      class="form-input form-textarea"
                                      maxlength="1000"
                                      oninput="updatePreview()">${sessionScope.channel.description}</textarea>
                            <div class="char-count" id="descCharCount">${fn:length(sessionScope.channel.description)}/1000</div>
                            <div class="form-hint">Tell viewers about your channel. This will appear on your channel page.</div>
                        </div>
                        
                        <!-- Preview Section -->
                        <div class="preview-container">
                            <div class="preview-title">Preview</div>
                            <div style="display: flex; align-items: center; gap: 16px;">
                                <img src="${pageContext.request.contextPath}/${not empty sessionScope.channel.profilePicture ? sessionScope.channel.profilePicture : ''}" 
                                     alt="Preview" 
                                     class="preview-avatar"
                                     id="previewAvatar"
                                     onerror="this.style.display='none'; document.getElementById('previewPlaceholder').style.display='flex'">
                                <div id="previewPlaceholder" class="avatar-placeholder" style="width: 60px; height: 60px; font-size: 24px; display: ${empty sessionScope.channel.profilePicture ? 'flex' : 'none'}">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.channel.displayName}">
                                            ${fn:substring(sessionScope.channel.displayName, 0, 1)}
                                        </c:when>
                                        <c:otherwise>
                                            ?
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <div class="preview-displayname" id="previewDisplayName">
                                        ${sessionScope.channel.displayName}
                                    </div>
                                    <div class="preview-description" id="previewDescription">
                                        ${sessionScope.channel.description}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            Save Changes
                        </button>
                        <a href="channelDashboard" class="btn btn-secondary">
                            Cancel
                        </a>
                    </div>
                </form>
                
                <!-- Channel Stats (Optional) -->
                <div class="stats-section">
                    <div class="stats-title">Channel Statistics</div>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-value">${sessionScope.channel.subscriberCount}</div>
                            <div class="stat-label">Subscribers</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value" id="videoCount">0</div>
                            <div class="stat-label">Videos</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value" id="viewCount">0</div>
                            <div class="stat-label">Total Views</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
    // Initialize character counters
    document.addEventListener('DOMContentLoaded', function() {
        const displayName = document.getElementById('displayName');
        const description = document.getElementById('description');
        
        updateCharCounter(displayName, 'nameCharCount', 50);
        updateCharCounter(description, 'descCharCount', 1000);
        
        // Initialize preview
        updatePreview();
        
        // Load channel stats (you would need to fetch this from server)
        loadChannelStats();
        
        // Focus on display name field
        displayName.focus();
    });
    
    function updateCharCounter(element, counterId, maxLength) {
        const counter = document.getElementById(counterId);
        const currentLength = element.value.length;
        
        counter.textContent = currentLength + '/' + maxLength;
        
        if (currentLength > maxLength * 0.9) {
            counter.classList.add('warning');
            counter.classList.remove('error');
        } else if (currentLength > maxLength) {
            counter.classList.add('error');
            counter.classList.remove('warning');
        } else {
            counter.classList.remove('warning', 'error');
        }
    }
    
    function previewImage(event) {
        const input = event.target;
        const fileInfo = document.getElementById('fileInfo');
        const previewAvatar = document.getElementById('previewAvatar');
        const previewPlaceholder = document.getElementById('previewPlaceholder');
        
        if (input.files && input.files[0]) {
            const file = input.files[0];
            
            // Validate file size (2MB max)
            if (file.size > 2 * 1024 * 1024) {
                alert('File size must be less than 2MB');
                input.value = '';
                fileInfo.textContent = 'No file selected';
                return;
            }
            
            // Validate file type
            if (!file.type.match('image.*')) {
                alert('Please select an image file');
                input.value = '';
                fileInfo.textContent = 'No file selected';
                return;
            }
            
            // Use string concatenation instead of template literals
            fileInfo.textContent = file.name + ' (' + formatFileSize(file.size) + ')';
            
            const reader = new FileReader();
            reader.onload = function(e) {
                // Update preview
                previewAvatar.src = e.target.result;
                previewAvatar.style.display = 'block';
                previewPlaceholder.style.display = 'none';
                
                // Update current avatar
                const currentAvatar = document.getElementById('currentAvatar');
                const avatarPlaceholder = document.getElementById('avatarPlaceholder');
                
                if (currentAvatar) {
                    currentAvatar.src = e.target.result;
                } else if (avatarPlaceholder) {
                    avatarPlaceholder.style.display = 'none';
                    const newAvatar = document.createElement('img');
                    newAvatar.id = 'currentAvatar';
                    newAvatar.className = 'current-avatar';
                    newAvatar.src = e.target.result;
                    newAvatar.alt = 'Current Profile';
                    avatarPlaceholder.parentNode.insertBefore(newAvatar, avatarPlaceholder.nextSibling);
                }
            };
            reader.readAsDataURL(file);
        } else {
            fileInfo.textContent = 'No file selected';
        }
    }
    
    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }
    
    function updatePreview() {
        const displayName = document.getElementById('displayName').value;
        const description = document.getElementById('description').value;
        
        document.getElementById('previewDisplayName').textContent = displayName;
        document.getElementById('previewDescription').textContent = description;
        
        // Update character counters
        updateCharCounter(document.getElementById('displayName'), 'nameCharCount', 50);
        updateCharCounter(document.getElementById('description'), 'descCharCount', 1000);
        
        // Update avatar placeholder initial
        const avatarPlaceholder = document.getElementById('avatarPlaceholder');
        const previewPlaceholder = document.getElementById('previewPlaceholder');
        if (avatarPlaceholder && displayName && displayName.length > 0) {
            avatarPlaceholder.textContent = displayName.charAt(0).toUpperCase();
        }
        if (previewPlaceholder && displayName && displayName.length > 0) {
            previewPlaceholder.textContent = displayName.charAt(0).toUpperCase();
        }
    }
    
    function loadChannelStats() {
        // This would typically be an AJAX call to get channel stats
        // For now, we'll simulate with placeholder values
        // You would need to implement the actual API endpoint
        /*
        fetch('/api/channel/stats?channelId=${sessionScope.channel.id}')
            .then(response => response.json())
            .then(data => {
                document.getElementById('videoCount').textContent = data.videoCount || 0;
                document.getElementById('viewCount').textContent = data.viewCount || 0;
            })
            .catch(error => {
                console.error('Error loading channel stats:', error);
            });
        */
    }
    
    // Form validation and submission
    document.getElementById('profileForm').addEventListener('submit', function(e) {
        const displayName = document.getElementById('displayName').value.trim();
        const submitBtn = document.getElementById('submitBtn');
        
        if (!displayName) {
            e.preventDefault();
            alert('Display name is required');
            document.getElementById('displayName').focus();
            return;
        }
        
        // Show loading state
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<span style="margin-right: 8px;">⏳</span>Saving...';
        submitBtn.disabled = true;
        
        // Re-enable after 5 seconds (in case of error)
        setTimeout(() => {
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
        }, 5000);
    });
    
    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl+S to save
        if (e.ctrlKey && e.key === 's') {
            e.preventDefault();
            document.getElementById('profileForm').submit();
        }
        
        // Escape to cancel
        if (e.key === 'Escape') {
            if (confirm('Discard changes?')) {
                window.location.href = 'channelDashboard';
            }
        }
    });
    
    // File upload button click handler
    document.getElementById('uploadBtn').addEventListener('click', function() {
        document.getElementById('profilePictureInput').click();
    });
</script>
</body>
</html>