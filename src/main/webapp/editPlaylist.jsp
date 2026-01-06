<!-- editPlaylist.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Playlist - YouTube Clone</title>
    <style>
        .edit-playlist-container {
            max-width: 800px;
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
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-primary {
            background: #065fd4;
            color: white;
        }
        .btn-secondary {
            background: #666;
            color: white;
        }
        .btn-danger {
            background: #cc0000;
            color: white;
        }
        .videos-list {
            margin-top: 30px;
        }
        .video-item {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 15px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .video-info {
            flex: 1;
        }
        .video-title {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .video-stats {
            color: #666;
            font-size: 14px;
        }
        .remove-form {
            margin: 0;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="edit-playlist-container">
        <h2>Edit Playlist</h2>
        
        <c:if test="${not empty param.success}">
            <div style="color: green; padding: 10px; background: #f0fff0; border: 1px solid #00cc00; border-radius: 4px; margin-bottom: 20px;">
                ${param.success}
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div style="color: red; padding: 10px; background: #fff0f0; border: 1px solid #cc0000; border-radius: 4px; margin-bottom: 20px;">
                ${param.error}
            </div>
        </c:if>
        
        <form action="editPlaylist" method="post">
            <input type="hidden" name="playlistId" value="${playlist.id}">
            <input type="hidden" name="action" value="update">
            
            <div class="form-group">
                <label for="name">Playlist Name:</label>
                <input type="text" id="name" name="name" value="${playlist.name}" required>
            </div>
            
            <div class="form-group">
                <label for="description">Description (optional):</label>
                <textarea id="description" name="description">${playlist.description}</textarea>
            </div>
            
            <div class="form-group">
                <label for="isPublic">Visibility:</label>
                <select id="isPublic" name="isPublic">
                    <option value="1" ${playlist.isPublic == '1' ? 'selected' : ''}>Public</option>
                    <option value="0" ${playlist.isPublic == '0' ? 'selected' : ''}>Private</option>
                </select>
            </div>
            
            <div>
                <button type="submit" class="btn btn-primary">Update Playlist</button>
                <a href="viewPlaylist?id=${playlist.id}" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
        
        <div class="videos-list">
            <h3>Videos in this Playlist</h3>
            <c:if test="${empty videos}">
                <p>No videos in this playlist.</p>
            </c:if>
            <c:forEach items="${videos}" var="video">
                <div class="video-item">
                    <div class="video-info">
                        <div class="video-title">${video.videoTitle}</div>
                        <div class="video-stats">
                            ${video.viewsCount} views • ${video.channelName}
                        </div>
                    </div>
                    <form class="remove-form" action="removeVideoFromPlaylist" method="post" onsubmit="return confirm('Remove this video from playlist?');">
                        <input type="hidden" name="playlistId" value="${playlist.id}">
                        <input type="hidden" name="videoId" value="${video.id}">
                        <button type="submit" class="btn btn-danger">Remove</button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>