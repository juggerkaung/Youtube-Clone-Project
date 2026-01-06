<!-- editVideo.jsp file: -->
<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Video - YouTube Clone</title>
    <style>
        /* Your existing styles */
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <!-- At the top of editVideo.jsp, add this check: -->
<c:if test="${video.copyrightStatus == 'strike'}">
    <div style="background: #f8d7da; color: #721c24; padding: 20px; border-radius: 8px; text-align: center; margin: 20px;">
        <h3>⛔ Copyright Strike</h3>
        <p>This video has received a copyright strike and cannot be edited.</p>
        <p>You can only delete this video.</p>
    </div>
    
    <!-- Disable all form inputs -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('input, textarea, select, button:not(.btn-danger)').forEach(function(element) {
                element.disabled = true;
            });
        });
    </script>
</c:if>


    
    <div class="edit-container">
        <h2>Edit Video</h2>
        
        <c:if test="${not empty param.success}">
            <div class="success-message">
                ${param.success}
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="error-message">
                ${param.error}
            </div>
        </c:if>

        <div class="video-info">
            <strong>Video Information:</strong><br>
            Duration: ${video.duration} seconds<br>
            Uploaded: ${video.formattedCreatedAt}<br>
            <c:if test="${not empty video.formattedUpdatedAt}">
                ${video.formattedUpdatedAt}<br>
            </c:if>
            Views: ${video.formattedViews}<br>
            Current Status: <strong>${video.isPublic == '1' ? 'Public' : 'Private'}</strong>
        </div>

        <form action="editVideo" method="post">
            <input type="hidden" name="videoId" value="${video.id}">
            <input type="hidden" name="action" value="update">
            
            <div class="form-group">
                <label for="title">Video Title:</label>
                <input type="text" id="title" name="title" value="${video.videoTitle}" required>
            </div>
            
            <div class="form-group">
                <label for="description">Video Description:</label>
                <textarea id="description" name="description">${video.videoDescription}</textarea>
            </div>
            
            <div class="form-group">
                <label for="isPublic">Visibility:</label>
                <select id="isPublic" name="isPublic">
                    <option value="1" ${video.isPublic == '1' ? 'selected' : ''}>Public - Anyone can watch this video</option>
                    <option value="0" ${video.isPublic == '0' ? 'selected' : ''}>Private - Only you can watch this video</option>
                </select>
                <div class="visibility-info">
                    <c:choose>
                        <c:when test="${video.isPublic == '1'}">
                            This video is currently <strong>public</strong> and visible to everyone.
                        </c:when>
                        <c:otherwise>
                            This video is currently <strong>private</strong> and only visible to you.
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div>
                <button type="submit" class="btn btn-primary">Update Video</button>
                <a href="video?id=${video.id}" class="btn btn-secondary">Cancel</a>
            </div>
        </form>

        <div class="delete-section">
            <h3 style="color: #cc0000;">Danger Zone</h3>
            <p>Once you delete a video, it cannot be recovered. This will remove the video, its comments, and all reactions.</p>
            
            <form action="editVideo" method="post" onsubmit="return confirmDelete()">
                <input type="hidden" name="videoId" value="${video.id}">
                <input type="hidden" name="action" value="delete">
                <button type="submit" class="btn btn-danger">Delete Video</button>
            </form>
        </div>
    </div>

    <script>
        function confirmDelete() {
            return confirm('Are you sure you want to delete this video? This action cannot be undone.');
        }
        
        // Update visibility info when selection changes
        document.getElementById('isPublic').addEventListener('change', function() {
            const visibilityInfo = document.querySelector('.visibility-info');
            if (this.value === '1') {
                visibilityInfo.innerHTML = 'This video will be <strong>public</strong> and visible to everyone.';
            } else {
                visibilityInfo.innerHTML = 'This video will be <strong>private</strong> and only visible to you.';
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
    <title>Edit video - YouTube Clone</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --youtube-red: #FF0000;
            --youtube-dark: #0F0F0F;
            --youtube-gray: #606060;
            --youtube-light-gray: #F2F2F2;
            --youtube-text: #0F0F0F;
            --youtube-text-secondary: #606060;
            --youtube-blue: #065fd4;
            --youtube-green: #4CAF50;
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
        }
        
        .edit-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        
        /* Header */
        .page-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #E5E5E5;
        }
        
        .back-button {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: var(--youtube-text);
            padding: 8px 16px;
            border-radius: 4px;
            margin-right: 20px;
            transition: background-color 0.2s;
        }
        
        .back-button:hover {
            background-color: var(--youtube-light-gray);
        }
        
        .page-title {
            font-size: 24px;
            font-weight: 500;
        }
        
        /* Main Content Layout */
        .content-wrapper {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 40px;
        }
        
        /* Form Container */
        .form-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .form-section {
            margin-bottom: 32px;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 500;
            margin-bottom: 16px;
            padding-bottom: 8px;
            border-bottom: 1px solid #E5E5E5;
            color: var(--youtube-text);
        }
        
        /* Form Elements */
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
            color: var(--youtube-text);
        }
        
        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #DADCE0;
            border-radius: 8px;
            font-size: 16px;
            font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s;
            background-color: white;
        }
        
        .form-input:focus {
            outline: none;
            border-color: var(--youtube-blue);
            box-shadow: 0 0 0 3px rgba(6, 95, 212, 0.1);
        }
        
        .form-input.disabled, .form-input:disabled {
            background-color: #F8F9FA;
            color: #6C757D;
            cursor: not-allowed;
            border-color: #E9ECEF;
        }
        
        .form-textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #DADCE0;
            border-radius: 8px;
            font-size: 16px;
            font-family: inherit;
            resize: vertical;
            min-height: 120px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        
        .form-textarea:focus {
            outline: none;
            border-color: var(--youtube-blue);
            box-shadow: 0 0 0 3px rgba(6, 95, 212, 0.1);
        }
        
        .form-select {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #DADCE0;
            border-radius: 8px;
            font-size: 16px;
            font-family: inherit;
            background-color: white;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        
        .form-select:focus {
            outline: none;
            border-color: var(--youtube-blue);
            box-shadow: 0 0 0 3px rgba(6, 95, 212, 0.1);
        }
        
        .form-option {
            padding: 8px;
        }
        
        /* Info Boxes */
        .info-box {
            background-color: #E3F2FD;
            border: 1px solid #90CAF9;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 20px;
        }
        
        .info-title {
            font-weight: 500;
            margin-bottom: 8px;
            color: #1976D2;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-content {
            font-size: 14px;
            color: #424242;
            line-height: 1.5;
        }
        
        /* Warning Box */
        .warning-box {
            background-color: #FFF3CD;
            border: 1px solid #FFECB5;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 20px;
        }
        
        .warning-title {
            font-weight: 500;
            margin-bottom: 8px;
            color: #856404;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .warning-content {
            font-size: 14px;
            color: #856404;
            line-height: 1.5;
        }
        
        /* Danger Box */
        .danger-box {
            background-color: #F8D7DA;
            border: 1px solid #F5C6CB;
            border-radius: 8px;
            padding: 20px;
            margin-top: 30px;
        }
        
        .danger-title {
            font-weight: 500;
            margin-bottom: 12px;
            color: #721C24;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 18px;
        }
        
        .danger-content {
            font-size: 14px;
            color: #721C24;
            line-height: 1.5;
            margin-bottom: 20px;
        }
        
        /* Buttons */
        .form-actions {
            display: flex;
            gap: 16px;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #E5E5E5;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s;
            text-decoration: none;
            font-family: inherit;
        }
        
        .btn-primary {
            background-color: var(--youtube-blue);
            color: white;
        }
        
        .btn-primary:hover:not(:disabled) {
            background-color: #0548A3;
        }
        
        .btn-secondary {
            background-color: transparent;
            color: var(--youtube-text);
            border: 1px solid #DADCE0;
        }
        
        .btn-secondary:hover {
            background-color: var(--youtube-light-gray);
        }
        
        .btn-danger {
            background-color: #DC3545;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #C82333;
        }
        
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        /* Preview Section */
        .preview-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .video-preview {
            margin-bottom: 24px;
        }
        
        .preview-thumbnail {
            width: 100%;
            aspect-ratio: 16/9;
            background-color: #000;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 16px;
        }
        
        .preview-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .preview-title {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 8px;
            line-height: 1.4;
        }
        
        .preview-info {
            font-size: 14px;
            color: var(--youtube-text-secondary);
        }
        
        .preview-stats {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: var(--youtube-text-secondary);
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        /* Visibility Options */
        .visibility-options {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .visibility-option {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 12px;
            border: 1px solid #DADCE0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .visibility-option:hover {
            background-color: var(--youtube-light-gray);
        }
        
        .visibility-option.selected {
            border-color: var(--youtube-blue);
            background-color: #E3F2FD;
        }
        
        .visibility-icon {
            font-size: 20px;
            margin-top: 2px;
        }
        
        .visibility-content {
            flex: 1;
        }
        
        .visibility-title {
            font-weight: 500;
            margin-bottom: 4px;
        }
        
        .visibility-description {
            font-size: 14px;
            color: var(--youtube-text-secondary);
        }
        
        /* Copyright Strike Overlay */
        .strike-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        .strike-modal {
            background: white;
            border-radius: 12px;
            padding: 40px;
            max-width: 500px;
            width: 90%;
            text-align: center;
        }
        
        .strike-icon {
            font-size: 64px;
            color: #DC3545;
            margin-bottom: 20px;
        }
        
        .strike-title {
            font-size: 24px;
            font-weight: 500;
            margin-bottom: 16px;
            color: #721C24;
        }
        
        .strike-message {
            font-size: 16px;
            color: var(--youtube-text);
            margin-bottom: 24px;
            line-height: 1.5;
        }
        
        /* Responsive Design */
        @media (max-width: 1024px) {
            .content-wrapper {
                grid-template-columns: 1fr;
            }
            
            .preview-section {
                position: static;
                order: -1;
            }
        }
        
        @media (max-width: 768px) {
            .edit-container {
                padding: 0 16px;
            }
            
            .form-container, .preview-section {
                padding: 20px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="header.jsp" />
    
    <!-- Copyright Strike Overlay -->
    <c:if test="${video.copyrightStatus == 'strike'}">
        <div class="strike-overlay">
            <div class="strike-modal">
                <div class="strike-icon">
                    <i class="fas fa-ban"></i>
                </div>
                <h2 class="strike-title">Copyright Strike</h2>
                <p class="strike-message">
                    This video has received a copyright strike and cannot be edited.
                    <br><br>
                    <strong>Reason:</strong> ${video.copyrightReason}
                    <br><br>
                    You can only delete this video.
                </p>
                <div style="display: flex; gap: 16px; justify-content: center;">
                    <a href="myVideos" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Back to My Videos
                    </a>
                    <button type="button" onclick="showDeleteConfirmation()" class="btn btn-danger">
                        <i class="fas fa-trash"></i>
                        Delete Video
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Hidden form for deletion -->
        <form id="deleteForm" action="editVideo" method="post" style="display: none;">
            <input type="hidden" name="videoId" value="${video.id}">
            <input type="hidden" name="action" value="delete">
        </form>
        
        <script>
            function showDeleteConfirmation() {
                if (confirm('Are you sure you want to delete this video? This action cannot be undone.')) {
                    document.getElementById('deleteForm').submit();
                }
            }
        </script>
    </c:if>
    
    <div class="edit-container">
        <!-- Page Header -->
        <div class="page-header">
            <a href="video?id=${video.id}" class="back-button">
                <i class="fas fa-arrow-left"></i>
                Back to video
            </a>
            <h1 class="page-title">Edit video</h1>
        </div>
        
        <!-- Main Content -->
        <div class="content-wrapper">
            <!-- Left Column: Form -->
            <div class="form-container">
                <!-- Copyright Warning -->
                <c:if test="${video.copyrightStatus == 'claim'}">
                    <div class="warning-box">
                        <div class="warning-title">
                            <i class="fas fa-exclamation-triangle"></i>
                            Copyright Claim
                        </div>
                        <div class="info-content">
                            This video has a copyright claim. Editing may be restricted. 
                            <br>Reason: ${video.copyrightReason}
                        </div>
                    </div>
                </c:if>
                
                <!-- Form -->
                <form action="editVideo" method="post" id="editForm">
                    <input type="hidden" name="videoId" value="${video.id}">
                    <input type="hidden" name="action" value="update">
                    
                    <!-- Video Information Section -->
                    <div class="form-section">
                        <h3 class="section-title">Details</h3>
                        
                        <div class="form-group">
                            <label for="title" class="form-label">Title</label>
                            <input type="text" 
                                   id="title" 
                                   name="title" 
                                   class="form-input" 
                                   value="${video.videoTitle}" 
                                   placeholder="Add a title that describes your video"
                                   required
                                   maxlength="100"
                                   ${video.copyrightStatus == 'strike' ? 'disabled' : ''}>
                            <div style="font-size: 12px; color: var(--youtube-text-secondary); margin-top: 4px;">
                                <span id="titleCount">0</span>/100 characters
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" 
                                      name="description" 
                                      class="form-textarea" 
                                      placeholder="Tell viewers about your video"
                                      rows="6"
                                      ${video.copyrightStatus == 'strike' ? 'disabled' : ''}>${video.videoDescription}</textarea>
                            <div style="font-size: 12px; color: var(--youtube-text-secondary); margin-top: 4px;">
                                <span id="descriptionCount">0</span>/5000 characters
                            </div>
                        </div>
                    </div>
                    
                    <!-- Visibility Section -->
                    <div class="form-section">
                        <h3 class="section-title">Visibility</h3>
                        
                        <div class="form-group">
                            <label class="form-label">Who can watch this video?</label>
                            
                            <div class="visibility-options">
                                <div class="visibility-option ${video.isPublic == '1' ? 'selected' : ''}" 
                                     onclick="selectVisibility('public')">
                                    <div class="visibility-icon">
                                        <i class="fas fa-globe-americas"></i>
                                    </div>
                                    <div class="visibility-content">
                                        <div class="visibility-title">Public</div>
                                        <div class="visibility-description">
                                            Anyone can watch this video
                                        </div>
                                    </div>
                                    <div>
                                        <input type="radio" 
                                               name="isPublic" 
                                               value="1" 
                                               ${video.isPublic == '1' ? 'checked' : ''}
                                               ${video.copyrightStatus == 'strike' ? 'disabled' : ''}
                                               style="display: none;">
                                    </div>
                                </div>
                                
                                <div class="visibility-option ${video.isPublic == '0' ? 'selected' : ''}" 
                                     onclick="selectVisibility('private')">
                                    <div class="visibility-icon">
                                        <i class="fas fa-lock"></i>
                                    </div>
                                    <div class="visibility-content">
                                        <div class="visibility-title">Private</div>
                                        <div class="visibility-description">
                                            Only you can watch this video
                                        </div>
                                    </div>
                                    <div>
                                        <input type="radio" 
                                               name="isPublic" 
                                               value="0" 
                                               ${video.isPublic == '0' ? 'checked' : ''}
                                               ${video.copyrightStatus == 'strike' ? 'disabled' : ''}
                                               style="display: none;">
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Visibility Info -->
                        <div class="info-box">
                            <div class="info-title">
                                <i class="fas fa-info-circle"></i>
                                Current status
                            </div>
                            <div class="info-content">
                                This video is currently 
                                <strong>${video.isPublic == '1' ? 'Public' : 'Private'}</strong>
                                ${video.copyrightStatus == 'strike' ? '(Locked due to copyright strike)' : ''}
                            </div>
                        </div>
                    </div>
                    
                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" 
                                class="btn btn-primary"
                                ${video.copyrightStatus == 'strike' ? 'disabled' : ''}>
                            <i class="fas fa-save"></i>
                            Save changes
                        </button>
                        <a href="video?id=${video.id}" class="btn btn-secondary">
                            <i class="fas fa-times"></i>
                            Cancel
                        </a>
                    </div>
                </form>
                
                <!-- Danger Zone -->
                <div class="danger-box">
                    <div class="danger-title">
                        <i class="fas fa-exclamation-triangle"></i>
                        Danger zone
                    </div>
                    <div class="danger-content">
                        Once you delete a video, it cannot be recovered. This will permanently remove:
                        <ul style="margin: 8px 0 8px 20px;">
                            <li>The video file</li>
                            <li>All comments and replies</li>
                            <li>All likes and dislikes</li>
                            <li>View count history</li>
                        </ul>
                    </div>
                    <button type="button" 
                            onclick="showDeleteConfirmation()" 
                            class="btn btn-danger">
                        <i class="fas fa-trash"></i>
                        Delete video
                    </button>
                </div>
            </div>
            
            <!-- Right Column: Preview -->
            <div class="preview-section">
                <div class="video-preview">
                    <div class="preview-thumbnail">
                        <c:choose>
                            <c:when test="${not empty video.thumbnail}">
                                <img src="${pageContext.request.contextPath}/${video.thumbnail}" 
                                     alt="Video thumbnail"
                                     onerror="this.src='data:image/svg+xml,<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 16 9\"><rect width=\"16\" height=\"9\" fill=\"%23f0f0f0\"/><text x=\"8\" y=\"4.5\" font-family=\"Arial\" font-size=\"3\" text-anchor=\"middle\" fill=\"%23999\">No Thumbnail</text></svg>'">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 100%; height: 100%; background: linear-gradient(45deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 18px;">
                                    <i class="fas fa-play-circle" style="font-size: 48px; opacity: 0.8;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div id="previewTitle" class="preview-title">${video.videoTitle}</div>
                    
                    <div class="preview-info">
                        <div class="preview-stats">
                            <div class="stat-item">
                                <i class="far fa-eye"></i>
                                ${video.formattedViews} views
                            </div>
                            <div class="stat-item">
                                <i class="far fa-calendar-alt"></i>
                                ${video.formattedCreatedAt}
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Video Information -->
                <div class="form-section">
                    <h3 class="section-title">Video information</h3>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div>
                            <div style="font-size: 12px; color: var(--youtube-text-secondary); margin-bottom: 4px;">
                                Duration
                            </div>
                            <div style="font-weight: 500;">
                                ${video.duration} seconds
                            </div>
                        </div>
                        
                        <div>
                            <div style="font-size: 12px; color: var(--youtube-text-secondary); margin-bottom: 4px;">
                                Status
                            </div>
                            <div style="font-weight: 500; color: ${video.isPublic == '1' ? 'var(--youtube-green)' : '#FF9800'}">
                                ${video.isPublic == '1' ? 'Public' : 'Private'}
                                <c:if test="${video.copyrightStatus == 'strike'}">
                                    <span style="color: #DC3545;">(Strike)</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty param.success}">
                    <div style="background-color: #d4edda; color: #155724; padding: 12px; border-radius: 8px; margin-top: 20px; border: 1px solid #c3e6cb;">
                        <i class="fas fa-check-circle"></i>
                        ${param.success}
                    </div>
                </c:if>
                
                <c:if test="${not empty param.error}">
                    <div style="background-color: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; margin-top: 20px; border: 1px solid #f5c6cb;">
                        <i class="fas fa-exclamation-circle"></i>
                        ${param.error}
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Hidden form for deletion -->
    <form id="deleteForm" action="editVideo" method="post" style="display: none;">
        <input type="hidden" name="videoId" value="${video.id}">
        <input type="hidden" name="action" value="delete">
    </form>
    
    <script>
    // Initialize character counters
    document.addEventListener('DOMContentLoaded', function() {
        const titleInput = document.getElementById('title');
        const descriptionInput = document.getElementById('description');
        const titleCount = document.getElementById('titleCount');
        const descriptionCount = document.getElementById('descriptionCount');
        const previewTitle = document.getElementById('previewTitle');
        
        // Update counters on load
        updateCounter(titleInput, titleCount, 100);
        updateCounter(descriptionInput, descriptionCount, 5000);
        
        // Update counters on input
        titleInput.addEventListener('input', function() {
            updateCounter(this, titleCount, 100);
            // Update preview
            previewTitle.textContent = this.value || '${video.videoTitle}';
        });
        
        descriptionInput.addEventListener('input', function() {
            updateCounter(this, descriptionCount, 5000);
        });
        
        // Function to update character counter
        function updateCounter(inputElement, counterElement, maxLength) {
            const currentLength = inputElement.value.length;
            counterElement.textContent = currentLength;
            
            if (currentLength > maxLength * 0.8) {
                counterElement.style.color = '#FF9800';
            } else {
                counterElement.style.color = 'var(--youtube-text-secondary)';
            }
            
            if (currentLength > maxLength) {
                counterElement.style.color = '#DC3545';
            }
        }
        
        // Visibility selection
        window.selectVisibility = function(type) {
            const publicOption = document.querySelector('.visibility-option:first-child');
            const privateOption = document.querySelector('.visibility-option:last-child');
            const publicRadio = document.querySelector('input[name="isPublic"][value="1"]');
            const privateRadio = document.querySelector('input[name="isPublic"][value="0"]');
            
            if (type === 'public') {
                publicOption.classList.add('selected');
                privateOption.classList.remove('selected');
                publicRadio.checked = true;
            } else {
                privateOption.classList.add('selected');
                publicOption.classList.remove('selected');
                privateRadio.checked = true;
            }
        };
        
        // Handle form submission
        const editForm = document.getElementById('editForm');
        if (editForm) {
            editForm.addEventListener('submit', function(e) {
                const title = titleInput.value.trim();
                const description = descriptionInput.value.trim();
                
                if (!title) {
                    e.preventDefault();
                    alert('Please enter a video title');
                    titleInput.focus();
                    return false;
                }
                
                if (title.length > 100) {
                    e.preventDefault();
                    alert('Title cannot exceed 100 characters');
                    titleInput.focus();
                    return false;
                }
                
                if (description.length > 5000) {
                    e.preventDefault();
                    alert('Description cannot exceed 5000 characters');
                    descriptionInput.focus();
                    return false;
                }
                
                // Show loading state
                const submitBtn = editForm.querySelector('button[type="submit"]');
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
                submitBtn.disabled = true;
                
                return true;
            });
        }
    });
    
    // Delete confirmation
    function showDeleteConfirmation() {
        if (confirm('Are you sure you want to delete this video? This action cannot be undone.')) {
            document.getElementById('deleteForm').submit();
        }
    }
    
    // Disable form elements if video has strike
    <c:if test="${video.copyrightStatus == 'strike'}">
        document.addEventListener('DOMContentLoaded', function() {
            const formElements = document.querySelectorAll('#editForm input, #editForm textarea, #editForm select, #editForm button');
            formElements.forEach(element => {
                if (!element.classList.contains('btn-danger')) {
                    element.disabled = true;
                    if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA') {
                        element.classList.add('disabled');
                    }
                }
            });
        });
    </c:if>
    </script>
</body>
</html>