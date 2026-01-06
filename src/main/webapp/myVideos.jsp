<!-- myVideos.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Videos</title>
    <style>
        .video-item {
            border: 1px solid #ddd;
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            position: relative;
        }
        .video-thumbnail {
            width: 200px;
            height: 150px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
        }
        .video-actions {
            margin-top: 10px;
        }
        .btn-edit {
            background: #065fd4;
            color: white;
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 3px;
            margin-right: 5px;
        }
        .btn-view {
            background: #666;
            color: white;
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div style="padding: 20px;">
        <h2>My Videos</h2>
        <a href="channelDashboard">Back to Dashboard</a>
        
        <c:if test="${not empty param.success}">
            <div style="color: green; padding: 10px; background: #f0fff0; border: 1px solid #00cc00; border-radius: 4px;">
                ${param.success}
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div style="color: red; padding: 10px; background: #fff0f0; border: 1px solid #cc0000; border-radius: 4px;">
                ${param.error}
            </div>
        </c:if>
        
        <c:if test="${empty videos}">
            <p>You haven't uploaded any videos yet. <a href="uploadVideo.jsp">Upload your first video</a></p>
        </c:if>
        
        <!-- In myVideos.jsp, replace the video item section: -->
<c:forEach items="${videos}" var="video">
    <div class="video-item">
        <h3>${video.videoTitle}</h3>
        
        <c:choose>
            <c:when test="${not empty video.thumbnail}">
                <img src="${pageContext.request.contextPath}/${video.thumbnail}" 
                     alt="${video.videoTitle}" width="200">
            </c:when>
            <c:otherwise>
                <div class="video-thumbnail">No Thumbnail</div>
            </c:otherwise>
        </c:choose>
        
        <p>${video.videoDescription}</p>
        <p>
            Views: ${video.viewsCount} | 
            Likes: ${video.likesCount} | 
            Status: ${video.isPublic == '1' ? 'Public' : 'Private'} |
            Copyright: 
            <c:choose>
                <c:when test="${video.copyrightStatus == 'claim'}">
                    <a href="copyrightInfo?videoId=${video.id}" 
                       style="color: #ff9800; font-weight: bold; text-decoration: none;">
                        ⚠️ Claim
                    </a>
                </c:when>
                <c:when test="${video.copyrightStatus == 'strike'}">
                    <a href="copyrightInfo?videoId=${video.id}" 
                       style="color: #f44336; font-weight: bold; text-decoration: none;">
                        ⛔ Strike
                    </a>
                </c:when>
                <c:otherwise>
                    <span style="color: #4caf50; font-weight: bold;">✅ None</span>
                </c:otherwise>
            </c:choose>
            |
            Uploaded: ${video.formattedCreatedAt}
            <c:if test="${not empty video.formattedUpdatedAt}">
                <br>${video.formattedUpdatedAt}
            </c:if>
        </p>
        
        <div class="video-actions">
            <a href="editVideo?id=${video.id}" class="btn-edit">Edit</a>
            <a href="video?id=${video.id}" class="btn-view">Watch Video</a>
            <c:if test="${video.copyrightStatus != 'none'}">
                <a href="copyrightInfo?videoId=${video.id}" class="btn-edit" 
                   style="background: #ff9800;">Copyright Info</a>
            </c:if>
        </div>
    </div>
</c:forEach>

    </div>
</body>
</html>