<!-- mySubscribers.jsp file -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Subscribers</title>
    <style>
        .channel-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .channel-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
        }
        .channel-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin: 0 auto 15px;
        }
        .channel-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .channel-stats {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }
        .view-channel-btn {
            background: #065fd4;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div style="padding: 20px;">
        <h2>My Subscribers</h2>
        <p>Channels that are subscribed to you</p>
        
        <c:if test="${empty subscriberChannels}">
            <div style="text-align: center; padding: 40px;">
                <p>You don't have any subscribers yet.</p>
                <p>Upload great content to attract subscribers!</p>
                <a href="uploadVideo.jsp" class="view-channel-btn">Upload Video</a>
            </div>
        </c:if>
        
        <div class="channel-list">
            <c:forEach items="${subscriberChannels}" var="channel">
                <div class="channel-card">
                    <c:choose>
                        <c:when test="${not empty channel.profilePicture}">
                            <img src="${pageContext.request.contextPath}/${channel.profilePicture}" 
                                 alt="${channel.displayName}" class="channel-avatar">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/default-avatar.jpg" 
                                 alt="${channel.displayName}" class="channel-avatar">
                        </c:otherwise>
                    </c:choose>
                    <div class="channel-name">${channel.displayName}</div>
                    <div class="channel-stats">
                        ${channel.subscriberCount} subscribers
                    </div>
                    <p>${channel.description}</p>
                    <a href="channelVideos?channelId=${channel.id}" class="view-channel-btn">View Channel</a>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>