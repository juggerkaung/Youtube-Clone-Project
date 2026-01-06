<!-- channelVideos.jsp file: -->
<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${channel.displayName} - YouTube Clone</title>
    <style>
        .channel-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .channel-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .channel-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin-right: 30px;
        }
        .channel-info {
            flex: 1;
        }
        .channel-name {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .channel-stats {
            color: #666;
            margin-bottom: 10px;
            font-size: 16px;
        }
        .channel-description {
            margin-top: 15px;
            line-height: 1.5;
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
        .videos-grid {
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
        .video-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .short-video-card {
            border: 1px solid #ddd;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.2s;
            aspect-ratio: 9/16;
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
        .video-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .short-video-thumbnail img {
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
        .video-stats {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
        }
        .short-video-stats {
            color: #666;
            font-size: 12px;
            margin-top: 3px;
        }
        .video-reactions {
            display: flex;
            gap: 15px;
            margin-top: 8px;
            font-size: 13px;
            color: #606060;
        }
        .short-video-reactions {
            display: flex;
            gap: 10px;
            margin-top: 5px;
            font-size: 11px;
            color: #606060;
        }
        .no-videos {
            text-align: center;
            padding: 40px;
            color: #666;
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
        .shorts-icon {
            color: #ff0000;
            font-weight: bold;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="channel-container">
        <!-- Channel Header -->
        <div class="channel-header">
            <c:choose>
                <c:when test="${not empty channel.profilePicture}">
                    <img src="${pageContext.request.contextPath}/${channel.profilePicture}" 
                         alt="${channel.displayName}" class="channel-avatar">
                </c:when>
                <c:otherwise>
                    <div class="channel-avatar" style="background: #ddd; display: flex; align-items: center; justify-content: center;">
                        <span style="color: #666; font-size: 40px;">
                            ${channel.displayName.charAt(0)}
                        </span>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="channel-info">
                <h1 class="channel-name">${channel.displayName}</h1>
                <div class="channel-stats">
                    ${channel.subscriberCount} subscribers
                </div>
                <div class="channel-description">
                    ${channel.description}
                </div>
            </div>
        </div>

        <!-- Videos Section -->
        <div class="videos-section">
            <!-- Regular Videos -->
            <c:set var="regularVideos" value="${videos.stream().filter(v -> v.duration > 60).toList()}" />
          
            <c:if test="${not empty regularVideos}">
                <h2 class="section-title">Videos</h2>
                <div class="videos-grid">
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
                                            <div style="color: #666; text-align: center;">
                                                No Thumbnail
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="duration-badge">
                                        ${video.duration} sec
                                    </div>
                                </div>
                            </a>
                            
                            <div class="video-info">
                                <a href="video?id=${video.id}" style="text-decoration: none; color: inherit;">
                                    <div class="video-title">${video.videoTitle}</div>
                                </a>
                                
                                <div class="video-stats">
                                    ${video.viewsCount} views
                                </div>
                                
                                <div class="video-reactions">
                                    <span>👍 ${video.likesCount}</span>
                                    <span>👎 ${video.dislikeCount}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Short Videos -->
            <c:set var="shortVideos" value="${videos.stream().filter(v -> v.duration <= 60).toList()}" />
            <c:if test="${not empty shortVideos}">
                <h2 class="section-title">
                    <span class="shorts-icon">Shorts</span> Short Videos
                </h2>
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
                                            <div style="color: #666; text-align: center; font-size: 12px;">
                                                No Thumbnail
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="duration-badge">
                                        ${video.duration} sec
                                    </div>
                                </div>
                            </a>
                            
                            <div class="short-video-info">
                                <a href="video?id=${video.id}" style="text-decoration: none; color: inherit;">
                                    <div class="short-video-title">${video.videoTitle}</div>
                                </a>
                                
                                <div class="short-video-stats">
                                    ${video.viewsCount} views
                                </div>
                                
                                <div class="short-video-reactions">
                                    <span>👍 ${video.likesCount}</span>
                                    <span>👎 ${video.dislikeCount}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <!-- Add this section in channelVideos.jsp after the videos section -->

<!-- Playlists Section -->
<c:if test="${not empty playlists}">
    <div class="playlists-section" style="margin-top: 40px;">
        <h2 class="section-title">Playlists</h2>
        <div class="playlists-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; margin-top: 20px;">
            <c:forEach items="${playlists}" var="playlist">
                <a href="viewPlaylist?id=${playlist.id}" style="text-decoration: none; color: inherit;">
                    <div class="playlist-card" style="border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: transform 0.2s;">
                        <div class="playlist-thumbnail" style="width: 100%; height: 140px; background: #f0f0f0; display: flex; align-items: center; justify-content: center; position: relative;">
                            <div style="text-align: center; color: #666;">
                                <div style="font-size: 40px; margin-bottom: 5px;">📁</div>
                                <div>${playlist.videoCount} videos</div>
                            </div>
                            <c:if test="${playlist.isPublic == '0'}">
                                <div style="position: absolute; top: 10px; right: 10px; background: rgba(0,0,0,0.7); color: white; padding: 2px 6px; border-radius: 4px; font-size: 11px;">
                                    Private
                                </div>
                            </c:if>
                        </div>
                        <div class="playlist-info" style="padding: 15px;">
                            <div style="font-weight: bold; margin-bottom: 8px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                ${playlist.name}
                            </div>
                            <div style="color: #666; font-size: 14px; margin-bottom: 5px;">
                                ${playlist.videoCount} videos • ${playlist.formattedCreatedAt}
                            </div>
                            <div style="color: #666; font-size: 13px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                ${playlist.description}
                            </div>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>
</c:if>

<!-- Add this at the end of channelVideos.jsp if there are no videos or playlists -->
<c:if test="${empty videos && empty playlists}">
    <div style="text-align: center; padding: 40px; color: #666;">
        <p>This channel hasn't uploaded any videos or created any playlists yet.</p>
    </div>
</c:if>

            <!-- No Videos Message -->
            <c:if test="${empty videos}">
                <div class="no-videos">
                    <p>This channel hasn't uploaded any videos yet.</p>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${channel.displayName} - YouTube Clone</title>
    <style>
        .channel-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .channel-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .channel-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin-right: 30px;
        }
        .channel-info {
            flex: 1;
        }
        .channel-name {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .channel-stats {
            color: #666;
            margin-bottom: 10px;
            font-size: 16px;
        }
        .channel-description {
            margin-top: 15px;
            line-height: 1.5;
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
        .videos-grid {
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
        .video-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .short-video-card {
            border: 1px solid #ddd;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.2s;
            aspect-ratio: 9/16;
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
        .video-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .short-video-thumbnail img {
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
        .video-stats {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
        }
        .short-video-stats {
            color: #666;
            font-size: 12px;
            margin-top: 3px;
        }
        .video-reactions {
            display: flex;
            gap: 15px;
            margin-top: 8px;
            font-size: 13px;
            color: #606060;
        }
        .short-video-reactions {
            display: flex;
            gap: 10px;
            margin-top: 5px;
            font-size: 11px;
            color: #606060;
        }
        .no-videos {
            text-align: center;
            padding: 40px;
            color: #666;
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
        .shorts-icon {
            color: #ff0000;
            font-weight: bold;
            margin-right: 5px;
        }
        .channel-banned-indicator {
            color: red;
            font-size: 14px;
            padding: 4px 10px;
            background: #ffe6e6;
            border-radius: 12px;
            font-weight: normal;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="channel-container">
        <!-- Channel Header -->
        <div class="channel-header">
            <c:choose>
                <c:when test="${not empty channel.profilePicture}">
                    <img src="${pageContext.request.contextPath}/${channel.profilePicture}" 
                         alt="${channel.displayName}" class="channel-avatar">
                </c:when>
                <c:otherwise>
                    <div class="channel-avatar" style="background: #ddd; display: flex; align-items: center; justify-content: center;">
                        <span style="color: #666; font-size: 40px;">
                            ${channel.displayName.charAt(0)}
                        </span>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="channel-info">
                <h1 class="channel-name">
                    ${channel.displayName}
                    <!-- Channel Banned Indicator -->
                    <c:if test="${channel.isActive == '0'}">
                        <span class="channel-banned-indicator">Channel Banned</span>
                    </c:if>
                </h1>
                <div class="channel-stats">
                    ${channel.subscriberCount} subscribers
                </div>
                <div class="channel-description">
                    ${channel.description}
                </div>
            </div>
        </div>

        <!-- Videos Section -->
        <div class="videos-section">
            <!-- Regular Videos -->
            <c:set var="regularVideos" value="${videos.stream().filter(v -> v.duration > 60).toList()}" />
          
            <c:if test="${not empty regularVideos}">
                <h2 class="section-title">Videos</h2>
                <div class="videos-grid">
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
                                            <div style="color: #666; text-align: center;">
                                                No Thumbnail
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="duration-badge">
                                        ${video.duration} sec
                                    </div>
                                </div>
                            </a>
                            
                            <div class="video-info">
                                <a href="video?id=${video.id}" style="text-decoration: none; color: inherit;">
                                    <div class="video-title">${video.videoTitle}</div>
                                </a>
                                
                                <div class="video-stats">
                                    ${video.viewsCount} views
                                </div>
                                
                                <div class="video-reactions">
                                    <span>👍 ${video.likesCount}</span>
                                    <span>👎 ${video.dislikeCount}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Short Videos -->
            <c:set var="shortVideos" value="${videos.stream().filter(v -> v.duration <= 60).toList()}" />
            <c:if test="${not empty shortVideos}">
                <h2 class="section-title">
                    <span class="shorts-icon">Shorts</span> Short Videos
                </h2>
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
                                            <div style="color: #666; text-align: center; font-size: 12px;">
                                                No Thumbnail
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="duration-badge">
                                        ${video.duration} sec
                                    </div>
                                </div>
                            </a>
                            
                            <div class="short-video-info">
                                <a href="video?id=${video.id}" style="text-decoration: none; color: inherit;">
                                    <div class="short-video-title">${video.videoTitle}</div>
                                </a>
                                
                                <div class="short-video-stats">
                                    ${video.viewsCount} views
                                </div>
                                
                                <div class="short-video-reactions">
                                    <span>👍 ${video.likesCount}</span>
                                    <span>👎 ${video.dislikeCount}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <!-- Playlists Section -->
            <c:if test="${not empty playlists}">
                <div class="playlists-section" style="margin-top: 40px;">
                    <h2 class="section-title">Playlists</h2>
                    <div class="playlists-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; margin-top: 20px;">
                        <c:forEach items="${playlists}" var="playlist">
                            <a href="viewPlaylist?id=${playlist.id}" style="text-decoration: none; color: inherit;">
                                <div class="playlist-card" style="border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: transform 0.2s;">
                                    <div class="playlist-thumbnail" style="width: 100%; height: 140px; background: #f0f0f0; display: flex; align-items: center; justify-content: center; position: relative;">
                                        <div style="text-align: center; color: #666;">
                                            <div style="font-size: 40px; margin-bottom: 5px;">📁</div>
                                            <div>${playlist.videoCount} videos</div>
                                        </div>
                                        <c:if test="${playlist.isPublic == '0'}">
                                            <div style="position: absolute; top: 10px; right: 10px; background: rgba(0,0,0,0.7); color: white; padding: 2px 6px; border-radius: 4px; font-size: 11px;">
                                                Private
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="playlist-info" style="padding: 15px;">
                                        <div style="font-weight: bold; margin-bottom: 8px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            ${playlist.name}
                                        </div>
                                        <div style="color: #666; font-size: 14px; margin-bottom: 5px;">
                                            ${playlist.videoCount} videos • ${playlist.formattedCreatedAt}
                                        </div>
                                        <div style="color: #666; font-size: 13px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            ${playlist.description}
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- Add this at the end of channelVideos.jsp if there are no videos or playlists -->
            <c:if test="${empty videos && empty playlists}">
                <div style="text-align: center; padding: 40px; color: #666;">
                    <p>This channel hasn't uploaded any videos or created any playlists yet.</p>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>