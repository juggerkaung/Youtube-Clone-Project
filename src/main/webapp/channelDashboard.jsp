<!-- channelDashboard.jsp file -->
 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Channel Dashboard</title>
    <style>
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .video-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
        }
        .video-thumbnail {
            width: 100%;
            height: 180px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .video-info {
            padding: 15px;
        }
        .upload-btn {
            background: #cc0000;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            display: inline-block;
            margin: 10px 0;
        }
        
         .copyright-badge {
        display: inline-block;
        padding: 3px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: bold;
        margin-left: 5px;
    }
    .copyright-claim {
        background: #fff3cd;
        color: #856404;
        border: 1px solid #ffeaa7;
    }
    .copyright-strike {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
    .copyright-none {
        background: #d1ecf1;
        color: #0c5460;
        border: 1px solid #bee5eb;
    }
        
        
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div style="padding: 20px;">
        <h2>Welcome, ${channel.displayName}!</h2>
        
        <!-- Add this in channelDashboard.jsp after the welcome message -->
<div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0;">
    <div style="display: flex; gap: 20px;">
        <div>
            <strong>${totalVideos}</strong> Total Videos
        </div>
        <div style="color: green;">
            <strong>${publicCount}</strong> Public
        </div>
        <div style="color: #666;">
            <strong>${privateCount}</strong> Private
        </div>
    </div>
</div>

<!-- Update the video display to show visibility -->
<p style="color: #666; margin: 5px 0;">
    Views: ${video.viewsCount} | 
    Likes: ${video.likesCount} | 
    Status: 
    <c:choose>
        <c:when test="${video.isPublic == '1'}">
            <span style="color: green; font-weight: bold;">Public</span>
        </c:when>
        <c:otherwise>
            <span style="color: #666; font-weight: bold;">Private</span>
        </c:otherwise>
    </c:choose>
</p>

        
        <div>
            <a href="uploadVideo.jsp" class="upload-btn">Upload New Video</a>
        </div>
        
        <% if (request.getParameter("success") != null) { %>
            <div style="color: green; padding: 10px; background: #f0fff0; border: 1px solid #00cc00; border-radius: 4px;">
                <%= request.getParameter("success") %>
            </div>
        <% } %>
        
        <h3>Your Videos</h3>
        
        <c:if test="${empty videos}">
            <div style="text-align: center; padding: 40px; color: #666;">
                <p>You haven't uploaded any videos yet.</p>
                <p>Click "Upload New Video" to get started!</p>
            </div>
        </c:if>
      
        <!-- In channelDashboard.jsp, replace the video display section: -->
<div class="video-grid">
    <c:forEach items="${videos}" var="video">
        <div class="video-card">
            <a href="video?id=${video.id}">
                <c:choose>
                    <c:when test="${not empty video.thumbnail}">
                        <img src="${pageContext.request.contextPath}/${video.thumbnail}" 
                             alt="${video.videoTitle}" class="video-thumbnail">
                    </c:when>
                    <c:otherwise>
                        <div class="video-thumbnail">No Thumbnail</div>
                    </c:otherwise>
                </c:choose>
            </a>
            <div class="video-info">
                <h3><a href="video?id=${video.id}">${video.videoTitle}</a></h3>
                <p style="color: #666; margin: 5px 0;">
                    Views: ${video.viewsCount} | 
                    Likes: ${video.likesCount} | 
                    Status: 
                    <c:choose>
                        <c:when test="${video.isPublic == '1'}">
                            <span style="color: green; font-weight: bold;">Public</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #666; font-weight: bold;">Private</span>
                        </c:otherwise>
                    </c:choose>
                </p>
                
                <!-- COPYRIGHT STATUS -->
                 <!-- Update the copyright status display in channelDashboard.jsp: -->
<p style="margin: 5px 0;">
    Copyright: 
    <c:choose>
        <c:when test="${video.copyrightStatus == 'claim'}">
            <a href="copyrightInfo?videoId=${video.id}" 
               class="copyright-badge copyright-claim">
                ⚠️ Copyright Claim
            </a>
        </c:when>
        <c:when test="${video.copyrightStatus == 'strike'}">
            <a href="copyrightInfo?videoId=${video.id}" 
               class="copyright-badge copyright-strike">
                ⛔ Copyright Strike
            </a>
        </c:when>
        <c:otherwise>
            <span class="copyright-badge copyright-none">
                ✅ No Issues
            </span>
        </c:otherwise>
    </c:choose>
</p>
                <p style="color: #666; font-size: 14px;">Uploaded: ${video.createdAt}</p>
                
                <!-- If video has copyright issue, show warning -->
                <c:if test="${video.copyrightStatus == 'strike'}">
                    <div style="background: #ffebee; border-left: 4px solid #f44336; padding: 8px; margin-top: 8px;">
                        <p style="color: #c62828; margin: 0; font-size: 13px;">
                            ⚠️ This video has a copyright strike and is not visible to the public.
                        </p>
                    </div>
                </c:if>
            </div>
        </div>
    </c:forEach>
</div>
        
    </div>
</body>
</html>