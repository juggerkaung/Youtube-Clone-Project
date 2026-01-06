<!-- playlists.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Playlists - YouTube Clone</title>
    <style>
        .playlists-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .playlists-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .create-playlist-btn {
            background: #065fd4;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: bold;
        }
        .playlists-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .playlist-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.2s;
        }
        .playlist-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .playlist-thumbnail {
            width: 100%;
            height: 180px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 14px;
        }
        .playlist-info {
            padding: 15px;
        }
        .playlist-name {
            font-weight: bold;
            margin-bottom: 8px;
            font-size: 18px;
        }
        .playlist-meta {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .playlist-visibility {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            margin-top: 5px;
        }
        .visibility-public {
            background: #e3f2fd;
            color: #1976d2;
        }
        .visibility-private {
            background: #f5f5f5;
            color: #666;
        }
        .no-playlists {
            text-align: center;
            padding: 40px;
            color: #666;
            background: #f9f9f9;
            border-radius: 8px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="playlists-container">
        <div class="playlists-header">
            <h2>My Playlists</h2>
            <a href="createPlaylist" class="create-playlist-btn">
                <span>+</span>
                <span>Create playlist</span>
            </a>
        </div>
        
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
        
        <c:if test="${empty playlists}">
            <div class="no-playlists">
                <h3>You don't have any playlists yet</h3>
                <p>Create your first playlist to organize your favorite videos!</p>
                <a href="createPlaylist" class="create-playlist-btn" style="display: inline-flex; margin-top: 15px;">
                    Create your first playlist
                </a>
            </div>
        </c:if>
        
        <div class="playlists-grid">
            <c:forEach items="${playlists}" var="playlist">
                <a href="viewPlaylist?id=${playlist.id}" style="text-decoration: none; color: inherit;">
                    <div class="playlist-card">
                        <div class="playlist-thumbnail">
                            <c:choose>
                                <c:when test="${playlist.videoCount > 0}">
                                    <div style="text-align: center;">
                                        <div style="font-size: 48px; margin-bottom: 10px;">▶️</div>
                                        <div>${playlist.videoCount} video<c:if test="${playlist.videoCount != 1}">s</c:if></div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align: center;">
                                        <div style="font-size: 48px; margin-bottom: 10px;">📁</div>
                                        <div>Empty playlist</div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="playlist-info">
                            <div class="playlist-name">${playlist.name}</div>
                            <div class="playlist-meta">
                                ${playlist.videoCount} video<c:if test="${playlist.videoCount != 1}">s</c:if> • Created ${playlist.formattedCreatedAt}
                            </div>
                            <div class="playlist-meta">
                                ${playlist.description}
                            </div>
                            <div class="playlist-visibility ${playlist.isPublic == '1' ? 'visibility-public' : 'visibility-private'}">
                                ${playlist.isPublic == '1' ? 'PUBLIC' : 'PRIVATE'}
                            </div>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>
</body>
</html>