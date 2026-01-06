<!-- searchResults.jsp file:  -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Results - YouTube Clone</title>
    <style>
        .search-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .search-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .search-query {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }
        .results-info {
            color: #666;
            margin: 10px 0;
        }
        .no-results-message {
            text-align: center;
            padding: 40px;
            color: #666;
            background: #f9f9f9;
            border-radius: 8px;
            margin: 20px 0;
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
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }
        .video-stats {
            color: #666;
            font-size: 13px;
        }
        .short-video-stats {
            color: #666;
            font-size: 12px;
        }
        .match-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 11px;
            margin-left: 5px;
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
        .section-title {
            font-size: 22px;
            font-weight: bold;
            margin: 20px 0 10px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #ff0000;
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
    
    <div class="search-container">
        <div class="search-header">
            <div class="search-query">
                Search results for "${searchQuery}"
            </div>
            
          <%--   <c:if test="${titleMatchCount > 0 || descriptionMatchCount > 0}">
                <div class="results-info">
                    Found ${titleMatchCount + descriptionMatchCount} matching videos
                    <c:if test="${titleMatchCount > 0}">
                        <span style="color: #1976d2;">(${titleMatchCount} in titles</span>
                    </c:if>
                    <c:if test="${descriptionMatchCount > 0}">
                        <span style="color: #388e3c;">, ${descriptionMatchCount} in descriptions)</span>
                    </c:if>
                </div>
            </c:if>
            
            <c:if test="${titleMatchCount == 0 && descriptionMatchCount == 0}">
                <div class="no-results-message">
                    <h3>Sorry, we couldn't find anything that matches your search</h3>
                    <p>Try different keywords or browse all videos below</p>
                </div>
            </c:if> --%>
            <!-- In searchResults.jsp - Update the results info section -->

<c:if test="${type != 'channel'}">
    <c:if test="${titleMatchCount > 0 || descriptionMatchCount > 0}">
        <div class="results-info">
            Found ${titleMatchCount + descriptionMatchCount} matching videos
            <c:if test="${titleMatchCount > 0}">
                <span style="color: #1976d2;">(${titleMatchCount} in titles</span>
            </c:if>
            <c:if test="${descriptionMatchCount > 0}">
                <span style="color: #388e3c;">, ${descriptionMatchCount} in descriptions)</span>
            </c:if>
        </div>
    </c:if>
</c:if>

<c:if test="${type != 'video' && channelMatchCount > 0}">
    <div class="results-info">
        Found ${channelMatchCount} matching channel<c:if test="${channelMatchCount != 1}">s</c:if>
    </div>
</c:if>
            
        </div>
        
        
        <!-- Filter Status -->
<div style="padding: 10px 20px; background: #f9f9f9; border-bottom: 1px solid #e0e0e0;">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
            <span style="color: #666; font-size: 14px;">
                About ${totalResults} results
                <c:if test="${not empty param.uploadDate and param.uploadDate != 'any'}">
                    • Upload date: 
                    <c:choose>
                        <c:when test="${param.uploadDate == 'hour'}">Last hour</c:when>
                        <c:when test="${param.uploadDate == 'today'}">Today</c:when>
                        <c:when test="${param.uploadDate == 'week'}">This week</c:when>
                        <c:when test="${param.uploadDate == 'month'}">This month</c:when>
                        <c:when test="${param.uploadDate == 'year'}">This year</c:when>
                    </c:choose>
                </c:if>
                <c:if test="${not empty param.sortBy and param.sortBy != 'relevance'}">
                    • Sorted by: 
                    <c:choose>
                        <c:when test="${param.sortBy == 'uploadDate'}">Upload date</c:when>
                        <c:when test="${param.sortBy == 'viewCount'}">View count</c:when>
                    </c:choose>
                </c:if>
            </span>
        </div>
        
        <c:if test="${not empty param.uploadDate or not empty param.type or not empty param.sortBy}">
            <div>
                <a href="search?query=${searchQuery}" 
                   style="color: #065fd4; text-decoration: none; font-size: 14px;">
                    ✕ Clear filters
                </a>
            </div>
        </c:if>
    </div>
</div>

<!-- Channel Results -->
<%-- <c:if test="${not empty channelMatches}">
    <h2 class="section-title">Channels</h2>
    <div class="channels-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; padding: 20px;">
        <c:forEach items="${channelMatches}" var="channel">
            <div class="channel-card" style="display: flex; align-items: center; padding: 15px; border: 1px solid #ddd; border-radius: 8px;">
                <a href="channelVideos?channelId=${channel.id}" style="display: flex; align-items: center; text-decoration: none; color: inherit; width: 100%;">
                  --%>  
                  <c:if test="${type != 'video' && not empty channelMatches}">
    <h2 class="section-title">Channels</h2>
    <div class="channels-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; padding: 20px;">
        <c:forEach items="${channelMatches}" var="channel">
            <div class="channel-card" style="display: flex; align-items: center; padding: 15px; border: 1px solid #ddd; border-radius: 8px;">
                <a href="channelVideos?channelId=${channel.id}" style="display: flex; align-items: center; text-decoration: none; color: inherit; width: 100%;">
                   
                    <c:choose>
                        <c:when test="${not empty channel.profilePicture}">
                            <img src="${pageContext.request.contextPath}/${channel.profilePicture}" 
                                 alt="${channel.displayName}" 
                                 style="width: 80px; height: 80px; border-radius: 50%; margin-right: 15px;">
                        </c:when>
                        <c:otherwise>
                            <div style="width: 80px; height: 80px; border-radius: 50%; background: #ddd; display: flex; align-items: center; justify-content: center; margin-right: 15px;">
                                <span style="color: #666; font-size: 24px;">
                                    ${channel.displayName.charAt(0)}
                                </span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div>
                        <div style="font-weight: bold; font-size: 18px; margin-bottom: 5px;">${channel.displayName}</div>
                        <div style="color: #666; font-size: 14px; margin-bottom: 5px;">${channel.subscriberCount} subscribers</div>
                        <div style="color: #666; font-size: 14px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                            ${channel.description}
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
</c:if>

        <!-- Regular Videos Section -->
      <%--   <c:if test="${not empty regularVideos}"> --%>
      <c:if test="${type != 'channel' && not empty regularVideos}">
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
                                        <div style="color: #666; text-align: center;">
                                            No Thumbnail
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="duration-badge">${video.duration}s</div>
                            </div>
                        </a>
                        
                        <div class="video-info">
                            <a href="video?id=${video.id}" style="text-decoration: none; color: inherit;">
                                <div class="video-title">
                                    ${video.videoTitle}
                                    <c:if test="${matchTypeMap[video.id] == 'title'}">
                                        <span class="match-badge">Title Match</span>
                                    </c:if>
                                    <c:if test="${matchTypeMap[video.id] == 'description'}">
                                        <span class="match-badge" style="background: #e8f5e8; color: #388e3c;">Description Match</span>
                                    </c:if>
                                </div>
                            </a>
                            
                            <div class="video-channel">
                                ${video.channelName}
                            </div>
                            
                            <div class="video-stats">
                                ${video.formattedViews} views • ${video.formattedCreatedAt}
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Short Videos Section -->
       <%--  <c:if test="${not empty shortVideos}"> --%>
       <c:if test="${type != 'channel' && not empty shortVideos}">
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
                                <div class="duration-badge">${video.duration}s</div>
                            </div>
                        </a>
                        
                        <div class="short-video-info">
                            <a href="video?id=${video.id}" style="text-decoration: none; color: inherit;">
                                <div class="short-video-title">
                                    ${video.videoTitle}
                                    <c:if test="${matchTypeMap[video.id] == 'title'}">
                                        <span class="match-badge">Title Match</span>
                                    </c:if>
                                    <c:if test="${matchTypeMap[video.id] == 'description'}">
                                        <span class="match-badge" style="background: #e8f5e8; color: #388e3c;">Description Match</span>
                                    </c:if>
                                </div>
                            </a>
                            
                            <div class="short-video-stats">
                                ${video.formattedViews} views
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Fallback: If no separated lists, show all videos in regular format -->
        <c:if test="${empty regularVideos && empty shortVideos && not empty searchResults}">
            <div class="video-grid">
                <c:forEach items="${searchResults}" var="video">
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
                                <div class="duration-badge">${video.duration}s</div>
                            </div>
                        </a>
                        
                        <div class="video-info">
                            <a href="video?id=${video.id}" style="text-decoration: none; color: inherit;">
                                <div class="video-title">
                                    ${video.videoTitle}
                                    <c:if test="${matchTypeMap[video.id] == 'title'}">
                                        <span class="match-badge">Title Match</span>
                                    </c:if>
                                    <c:if test="${matchTypeMap[video.id] == 'description'}">
                                        <span class="match-badge" style="background: #e8f5e8; color: #388e3c;">Description Match</span>
                                    </c:if>
                                </div>
                            </a>
                            
                            <div class="video-channel">
                                ${video.channelName}
                            </div>
                            
                            <div class="video-stats">
                                ${video.formattedViews} views • ${video.formattedCreatedAt}
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- No results at all -->
        <c:if test="${empty regularVideos && empty shortVideos && empty searchResults}">
            <div class="no-results-message">
                <h3>No videos found</h3>
                <p>Try different search terms or browse the home page</p>
                <a href="home" style="display: inline-block; margin-top: 15px; padding: 10px 20px; background: #065fd4; color: white; text-decoration: none; border-radius: 4px;">
                    Browse All Videos
                </a>
            </div>
        </c:if>
    </div>
</body>
</html>