
<!-- uploadVideo.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Video</title>
    <style>
        .upload-container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .btn {
            background: #065fd4;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn:hover {
            background: #0550b8;
        }
        .file-input {
            padding: 8px;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .checkbox-group input[type="checkbox"] {
            width: auto;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="upload-container">
        <h2>Upload New Video</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <div style="color: red; padding: 10px; background: #fff0f0; border: 1px solid #cc0000; border-radius: 4px; margin-bottom: 20px;">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <form action="uploadVideo" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="title">Video Title:</label>
                <input type="text" id="title" name="title" required>
            </div>
            
            <div class="form-group">
                <label for="description">Video Description:</label>
                <textarea id="description" name="description" placeholder="Describe your video..."></textarea>
            </div>
            
            <!-- NEW: Video Type Selection -->
            <div class="form-group">
                <label for="videoType">Video Type:</label>
                <select id="videoType" name="videoType" required>
                    <option value="regular" selected>Regular Video</option>
                    <option value="short">Short Video</option>
                </select>
                <small style="color: #666; font-size: 14px;">
                    • Regular Videos: Standard format, displayed in regular layout<br>
                    • Short Videos: Vertical format, displayed in shorts layout
                </small>
            </div>
            
            <div class="form-group">
                <label for="videoFile">Video File:</label>
                <input type="file" id="videoFile" name="videoFile" accept="video/*" required class="file-input">
                <small style="color: #666; font-size: 14px;">Supported formats: MP4, AVI, MOV, WMV</small>
            </div>
            
            <div class="form-group">
                <label for="thumbnail">Thumbnail (optional):</label>
                <input type="file" id="thumbnail" name="thumbnail" accept="image/*" class="file-input">
                <small style="color: #666; font-size: 14px;">Recommended: 1280x720 pixels</small>
            </div>
            
            <div class="form-group">
                <div class="checkbox-group">
                    <input type="checkbox" id="isPublic" name="isPublic" value="1" checked>
                    <label for="isPublic" style="display: inline; font-weight: normal;">
                        Make this video public
                    </label>
                </div>
            </div>
            
            <button type="submit" class="btn">Upload Video</button>
            <a href="channelDashboard" style="margin-left: 15px;">Cancel</a>
        </form>
    </div>

    <script>
        // Add some client-side validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const videoFile = document.getElementById('videoFile');
            const title = document.getElementById('title');
            
            if (!title.value.trim()) {
                alert('Please enter a video title');
                e.preventDefault();
                return;
            }
            
            if (!videoFile.files.length) {
                alert('Please select a video file');
                e.preventDefault();
                return;
            }
            
            // Check file size (optional - you can remove this if you want)
            const maxSize = 100 * 1024 * 1024; // 100MB
            if (videoFile.files[0].size > maxSize) {
                if (!confirm('The video file is quite large. This may take a while to upload. Continue?')) {
                    e.preventDefault();
                    return;
                }
            }
        });
    </script>
</body>
</html>