<!-- viewPlaylist.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${playlist.name} - YouTube Clone</title>
    <style>
        .playlist-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .playlist-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .playlist-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .playlist-meta {
            display: flex;
            align-items: center;
            gap: 15px;
            color: #666;
            margin-bottom: 15px;
        }
        .channel-info {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        .channel-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }
        .playlist-stats {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }
        .stat-item {
            color: #666;
        }
        .playlist-description {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        .playlist-visibility-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
        }
        .visibility-public {
            background: #e3f2fd;
            color: #1976d2;
        }
        .visibility-private {
            background: #f5f5f5;
            color: #666;
        }
        .videos-section {
            margin-top: 30px;
        }
        .section-title {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ff0000;
        }
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .short-videos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        .video-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.2s;
        }
        .short-video-card {
            border: 1px solid #ddd;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.2s;
            aspect-ratio: 9/16;
        }
        .video-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .short-video-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .video-thumbnail {
            width: 100%;
            height: 180px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }
        .short-video-thumbnail {
            width: 100%;
            height: 100%;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }
        .video-thumbnail img, .short-video-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .video-info {
            padding: 15px;
        }
        .short-video-info {
            padding: 10px;
        }
        .video-title {
            font-weight: bold;
            margin-bottom: 8px;
            line-height: 1.3;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .short-video-title {
            font-weight: bold;
            margin-bottom: 5px;
            line-height: 1.2;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            font-size: 14px;
        }
        .video-channel {
            color: #606060;
            font-size: 14px;
            margin-bottom: 5px;
        }
        .video-stats {
            color: #606060;
            font-size: 13px;
        }
        .short-video-stats {
            color: #606060;
            font-size: 12px;
        }
        .duration-badge {
            position: absolute;
            bottom: 8px;
            right: 8px;
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .shorts-badge {
            position: absolute;
            top: 8px;
            right: 8px;
            background: #ff0000;
            color: white;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .remove-video-btn {
            position: absolute;
            top: 8px;
            left: 8px;
            background: rgba(255, 0, 0, 0.8);
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }
        .remove-video-btn:hover {
            background: rgba(255, 0, 0, 1);
        }
        .no-videos-message {
            text-align: center;
            padding: 40px;
            color: #666;
            background: #f9f9f9;
            border-radius: 8px;
            margin-top: 20px;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }
        .btn-primary {
            background: #065fd4;
            color: white;
        }
        .btn-danger {
            background: #cc0000;
            color: white;
        }
        .btn-secondary {
            background: #666;
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="playlist-container">
        <!-- Playlist Header -->
        <div class="playlist-header">
            <h1 class="playlist-title">${playlist.name}</h1>
            
            <div class="playlist-meta">
                <span class="playlist-visibility-badge ${playlist.isPublic == '1' ? 'visibility-public' : 'visibility-private'}">
                    ${playlist.isPublic == '1' ? 'PUBLIC' : 'PRIVATE'}
                </span>
                <span>${videoCount} video<c:if test="${videoCount != 1}">s</c:if></span>
                <span>Created ${playlist.formattedCreatedAt}</span>
            </div>
            
            <div class="channel-info">
                <c:choose>
                    <c:when test="${not empty playlist.channelProfilePicture}">
                        <img src="${pageContext.request.contextPath}/${playlist.channelProfilePicture}" 
                             alt="${playlist.channelName}" class="channel-avatar">
                    </c:when>
                    <c:otherwise>
                        <div class="channel-avatar" style="background: #ddd; display: flex; align-items: center; justify-content: center;">
                            <span style="color: #666; font-size: 18px;">${playlist.channelName.charAt(0)}</span>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div>
                    <div style="font-weight: bold;">${playlist.channelName}</div>
                    <a href="channelVideos?channelId=${playlist.channelId}" style="color: #065fd4; text-decoration: none; font-size: 14px;">
                        View Channel
                    </a>
                </div>
            </div>
            
            <c:if test="${not empty playlist.description}">
                <div class="playlist-description">
                    ${playlist.description}
                </div>
            </c:if>
            
            <!-- Action Buttons for Playlist Owner -->
           <%--  <c:if test="${isOwner}">
                <div class="action-buttons">
                    <a href="playlists" class="btn btn-secondary">Back to Playlists</a>
                    <a href="editPlaylist?id=${playlist.id}" class="btn btn-primary">Edit Playlist</a>
                    <button class="btn btn-danger" onclick="confirmDeletePlaylist()">Delete Playlist</button>
                </div>
            </c:if>
        </div> --%>
        <!-- Replace the existing action buttons section with this: -->
<c:if test="${isOwner}">
    <div class="action-buttons">
        <a href="playlists" class="btn btn-secondary">Back to Playlists</a>
        <a href="editPlaylist?id=${playlist.id}" class="btn btn-primary">Edit Playlist</a>
        <button class="btn btn-danger" onclick="confirmDeletePlaylist()">Delete Playlist</button>
    </div>
</c:if>
        

        <!-- Videos Section -->
        <div class="videos-section">
            <h2 class="section-title">Videos in this Playlist</h2>
            
            <c:if test="${empty videos}">
                <div class="no-videos-message">
                    <h3>This playlist is empty</h3>
                    <p>No videos have been added to this playlist yet.</p>
                    <c:if test="${isOwner}">
                        <p>Browse your videos or search for videos to add to this playlist!</p>
                        <div style="margin-top: 15px;">
                            <a href="channelDashboard" class="btn btn-primary">Browse Your Videos</a>
                            <a href="home" class="btn btn-secondary" style="margin-left: 10px;">Browse All Videos</a>
                        </div>
                    </c:if>
                </div>
            </c:if>
            
            <!-- Regular Videos -->
            <c:if test="${not empty regularVideos}">
                <h3 style="font-size: 18px; margin: 20px 0 10px 0;">Videos</h3>
                <div class="video-grid">
                    <c:forEach items="${regularVideos}" var="video">
                        <div class="video-card">
                            <a href="video?id=${video.id}">
                                <div class="video-thumbnail">
                                    <c:choose>
                                        <c:when test="${not empty video.thumbnail}">
                                            <img src="${pageContext.request.contextPath}/${video.thumbnail}" 
                                                 alt="${video.videoTitle}">
                                        </c:when>
                                        <c:otherwise>
                                            <div style="color: #666; text-align: center; padding: 10px;">
                                                No Thumbnail
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="duration-badge">${video.duration}s</div>
                                    <c:if test="${isOwner}">
                                        <button class="remove-video-btn" onclick="removeFromPlaylist(${video.id}, event)">
                                            ×
                                        </button>
                                    </c:if>
                                </div>
                            </a>
                            <div class="video-info">
                                <a href="video?id=${video.id}" style="text-decoration: none; color: inherit;">
                                    <div class="video-title">${video.videoTitle}</div>
                                </a>
                                <div class="video-channel">${video.channelName}</div>
                                <div class="video-stats">
                                    ${video.formattedViews} views • ${video.formattedCreatedAt}
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <!-- Short Videos -->
            <c:if test="${not empty shortVideos}">
                <h3 style="font-size: 18px; margin: 20px 0 10px 0;">
                    <span style="color: #ff0000; font-weight: bold;">Shorts</span> Short Videos
                </h3>
                <div class="short-videos-grid">
                    <c:forEach items="${shortVideos}" var="video">
                        <div class="short-video-card">
                            <a href="video?id=${video.id}">
                                <div class="short-video-thumbnail">
                                    <c:choose>
                                        <c:when test="${not empty video.thumbnail}">
                                            <img src="${pageContext.request.contextPath}/${video.thumbnail}" 
                                                 alt="${video.videoTitle}">
                                        </c:when>
                                        <c:otherwise>
                                            <div style="color: #666; text-align: center; font-size: 12px; padding: 10px;">
                                                No Thumbnail
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="duration-badge">${video.duration}s</div>
                                    <div class="shorts-badge">SHORTS</div>
                                    <c:if test="${isOwner}">
                                        <button class="remove-video-btn" onclick="removeFromPlaylist(${video.id}, event)">
                                            ×
                                        </button>
                                    </c:if>
                                </div>
                            </a>
                            <div class="short-video-info">
                                <a href="video?id=${video.id}" style="text-decoration: none; color: inherit;">
                                    <div class="short-video-title">${video.videoTitle}</div>
                                </a>
                                <div class="short-video-stats">
                                    ${video.formattedViews} views • ${video.formattedCreatedAt}
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        function confirmDeletePlaylist() {
            if (confirm('Are you sure you want to delete this playlist? This action cannot be undone.')) {
                // Redirect to delete playlist servlet
                window.location.href = 'deletePlaylist?id=${playlist.id}';
            }
        }
        
        function removeFromPlaylist(videoId, event) {
            event.preventDefault();
            event.stopPropagation();
            
            if (confirm('Remove this video from playlist?')) {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'removeVideoFromPlaylist', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.onload = function() {
                    if (xhr.status === 200) {
                        alert('Video removed from playlist!');
                        location.reload();
                    } else {
                        alert('Error removing video from playlist');
                    }
                };
                xhr.send('playlistId=${playlist.id}&videoId=' + videoId);
            }
        }
    </script>
</body>
</html>