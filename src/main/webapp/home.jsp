<!-- Old File: -->
<!-- home.jsp file -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>YouTube Clone</title>
    <style>
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .short-videos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 15px;
            padding: 20px;
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
        .section-title {
            font-size: 22px;
            font-weight: bold;
            margin: 20px 0 10px 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ff0000;
        }
        .shorts-icon {
            color: #ff0000;
            font-weight: bold;
            margin-right: 5px;
        }
        .debug-info {
            background: #f0f0f0;
            padding: 10px;
            margin: 10px;
            border-radius: 5px;
            font-size: 12px;
            color: #666;
        }
        .no-videos-message {
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="header.jsp" />
    
    <!-- Debug information (optional) -->
    <div class="debug-info">
        <strong>Homepage Statistics:</strong><br>
        Regular Videos: ${not empty regularVideos ? regularVideos.size() : '0'}<br>
        Short Videos: ${not empty shortVideos ? shortVideos.size() : '0'}
    </div>
    
    <!-- Random Regular Videos Section -->
    <c:if test="${not empty regularVideos}">
        <h2 class="section-title">Videos</h2>
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
    
    <!-- Random Short Videos Section -->
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
                                    <div style="color: #666; text-align: center; font-size: 12px; padding: 10px;">
                                        No Thumbnail
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="duration-badge">${video.duration}s</div>
                            <div class="shorts-badge">SHORTS</div>
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
    
    <!-- No Videos Message -->
    <c:if test="${empty regularVideos && empty shortVideos}">
        <div class="no-videos-message">
            <h3>Welcome to YouTube Clone!</h3>
            <p>No videos available yet.</p>
            <c:choose>
                <c:when test="${empty sessionScope.channel}">
                    <p><a href="register.jsp" style="color: #065fd4; text-decoration: none; font-weight: bold;">Create a channel</a> and upload the first video!</p>
                    <p>Or <a href="login.jsp" style="color: #065fd4; text-decoration: none;">login</a> if you already have an account.</p>
                </c:when>
                <c:otherwise>
                    <p><a href="uploadVideo.jsp" style="color: #065fd4; text-decoration: none; font-weight: bold;">Upload your first video</a> to get started!</p>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
</body>
</html>
