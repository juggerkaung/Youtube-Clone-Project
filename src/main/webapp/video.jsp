<!-- video.jsp file -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${video.videoTitle} - YouTube Clone</title>
    <style>
        .video-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .video-player {
            width: 100%;
            background: #000;
            position: relative;
        }
        .video-info {
            margin-top: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
        }
        .video-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .video-stats {
            color: #666;
            font-size: 14px;
        }
        .channel-info {
            display: flex;
            align-items: center;
            margin: 20px 0;
        }
        .channel-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
        }
        .comments-section {
            margin-top: 30px;
        }
        .comment {
            margin: 15px 0;
            padding: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .comment-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .pinned-comment {
            background: #fff8e1;
            border-left: 4px solid #ffc107;
            padding-left: 10px;
        }
        .pin-badge {
            background: #ffc107;
            color: #333;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            margin-right: 5px;
        }
        .channel-banned-indicator {
            color: red;
            font-size: 12px;
            padding: 2px 8px;
            background: #ffe6e6;
            border-radius: 12px;
            font-weight: normal;
            margin-left: 10px;
        }
        
        /* Premium badge styling */
        .premium-badge {
            background: linear-gradient(45deg, #FFD700, #FFC107);
            color: #333;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            margin-left: 10px;
        }

        .premium-member {
            position: relative;
        }

        .premium-member::after {
            content: "👑";
            margin-left: 5px;
        }

        .locked-feature {
            color: #666;
            position: relative;
        }

        .locked-feature::before {
            content: "🔒";
            margin-right: 5px;
        }

        /* Gold theme specific styles */
        .gold-theme .premium-badge {
            background: linear-gradient(45deg, #D4AF37, #FFD700);
            color: #5c4033;
            box-shadow: 0 2px 4px rgba(212, 175, 55, 0.3);
        }

        .gold-theme a {
            color: #b8860b;
        }

        .gold-theme .btn-primary {
            background: linear-gradient(45deg, #D4AF37, #FFD700);
            color: #5c4033;
            border: 1px solid #d4af37;
        }

        /* Hide download button in video controls for non-premium users */
        video::-webkit-media-controls-download-button {
            display: none !important;
        }

        video::-webkit-media-controls {
            -webkit-justify-content: flex-start;
        }

        /* For Firefox */
        video::-moz-media-controls-download-button {
            display: none;
        }

        /* For IE/Edge */
        video::-ms-media-controls-download-button {
            display: none;
        }

        video::-ms-media-controls {
            -ms-justify-content: flex-start;
        }
        
        /* Custom overlay for non-premium users */
        .video-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            z-index: 10;
            pointer-events: none;
        }
        
        .download-section {
            margin: 20px 0;
            padding: 15px;
            background: #f9f9f9;
            border-radius: 8px;
            border-left: 4px solid #065fd4;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />
    <div class="video-container">
    
        <!-- Video Player -->
        <div class="video-player">
            <c:choose>
                <c:when test="${sessionScope.channel != null && sessionScope.channel.isPremium == '1'}">
                    <!-- Premium users can watch without restrictions -->
                    <video id="mainVideo" width="100%" height="500" controls 
                           oncontextmenu="return false;" 
                           controlsList="nodownload">
                        <source src="${pageContext.request.contextPath}/${video.videoUrl}" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                </c:when>
                <c:otherwise>
                    <!-- Non-premium users - video works but with some restrictions -->
                    <video id="mainVideo" width="100%" height="500" controls 
                           controlsList="nodownload">
                        <source src="${pageContext.request.contextPath}/${video.videoUrl}" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                    
                    <!-- Simple overlay that shows only on hover -->
               <!--      <div id="videoOverlay" class="video-overlay" style="display: none; pointer-events: none;">
                        <div style="background: rgba(0,0,0,0.8); padding: 20px; border-radius: 10px; text-align: center;">
                            <div style="font-size: 48px; margin-bottom: 10px;">🔒</div>
                            <div>Upgrade to Premium for full features</div>
                            <button onclick="showUpgradeModal()" 
                                    style="margin-top: 15px; padding: 10px 20px; background: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer;">
                                Upgrade Now
                            </button>
                        </div>
                    </div> -->
                    
                    
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Video Download Section -->
        <div class="download-section">
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <div>
                    <div style="font-weight: bold; margin-bottom: 5px;">
                        <c:choose>
                            <c:when test="${sessionScope.channel != null && sessionScope.channel.isPremium == '1'}">
                                ⬇️ Download Video
                            </c:when>
                            <c:otherwise>
                                🔒 Download Video (Premium Only)
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="color: #666; font-size: 14px;">
                        <c:choose>
                            <c:when test="${sessionScope.channel != null && sessionScope.channel.isPremium == '1'}">
                                Download this video for offline viewing
                            </c:when>
                            <c:otherwise>
                                Upgrade to Premium to download videos
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <c:choose>
                    <c:when test="${sessionScope.channel != null && sessionScope.channel.isPremium == '1'}">
                        <!-- Premium Download Button -->
                        <a href="${pageContext.request.contextPath}/${video.videoUrl}" 
                           download="${video.videoTitle}.mp4"
                           style="padding: 8px 20px; background: #4CAF50; color: white; text-decoration: none; border-radius: 4px; font-weight: bold;">
                            Download
                        </a>
                    </c:when>
                    <c:otherwise>
                        <!-- Non-Premium Upgrade Button -->
                        <button onclick="showUpgradeModal()"
                                style="padding: 8px 20px; background: linear-gradient(45deg, #FFD700, #FFC107); color: #333; border: none; border-radius: 4px; font-weight: bold; cursor: pointer;">
                            🔒 Upgrade to Download
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Premium Expiration Warning -->
        <c:if test="${sessionScope.channel != null && sessionScope.channel.isPremium == '1'}">
            <div id="premiumExpiryWarning" style="margin: 10px 0; padding: 10px; background: #fff3cd; border: 1px solid #ffc107; border-radius: 4px;">
                <div style="display: flex; align-items: center; justify-content: space-between;">
                    <div>
                        <strong>⏳ Premium Membership Active</strong>
                        <div style="font-size: 12px; color: #856404;">
                            <c:if test="${sessionScope.channel.premiumSince != null}">
                                Activated: ${sessionScope.channel.premiumSince}
                            </c:if>
                        </div>
                    </div>
                    <button onclick="checkPremiumStatus()" 
                            style="padding: 5px 10px; background: #ffc107; border: none; border-radius: 3px; font-size: 12px; cursor: pointer;">
                        Check Status
                    </button>
                </div>
            </div>
        </c:if>

        <!-- Video Information -->
        <div class="video-info">
            <div class="video-title">${video.videoTitle}</div>
            <div class="video-stats">
                ${video.formattedViews} views • ${video.formattedCreatedAt}
            </div>
            
            <!-- Short Video Badge -->
            <c:if test="${video.videoType == 'short'}">
                <div style="background: #ff0000; color: white; padding: 2px 6px; border-radius: 4px; display: inline-block; font-size: 12px; font-weight: bold; margin-left: 10px;">
                    SHORT
                </div>
            </c:if>
            
            <!-- Add Edit Button for Video Owner -->
            <c:if test="${not empty sessionScope.channel && sessionScope.channel.id == video.channelId}">
                <div style="margin: 10px 0;">
                    <a href="editVideo?id=${video.id}" 
                       style="padding: 8px 16px; background: #065fd4; color: white; text-decoration: none; border-radius: 4px;">
                        Edit Video
                    </a>
                </div>
            </c:if>

            <!-- Add to Playlist Button -->
            <c:if test="${not empty sessionScope.channel}">
                <div style="margin: 10px 0;">
                    <button id="addToPlaylistBtn" 
                        style="padding: 8px 16px; background: #065fd4; color: white; border: none; border-radius: 4px; cursor: pointer;">
                        <c:choose>
                            <c:when test="${sessionScope.channel.id == video.channelId}">
                                Add to Playlist
                            </c:when>
                            <c:otherwise>
                                Save to Playlist
                            </c:otherwise>
                        </c:choose>
                    </button>
                </div>
                
                <!-- Playlist Selection Modal -->
                <div id="playlistModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
                    <div style="background: white; border-radius: 12px; width: 90%; max-width: 400px; padding: 20px;">
                        <h3 style="margin: 0 0 15px 0;">Add to Playlist</h3>
                        <div id="playlistList">
                            <!-- Playlists will be loaded here via AJAX -->
                            <p>Loading playlists...</p>
                        </div>
                        <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px;">
                            <button id="cancelPlaylist" 
                                    style="padding: 8px 16px; background: #f8f8f8; border: 1px solid #ccc; border-radius: 4px; cursor: pointer;">
                                Cancel
                            </button>
                            <a href="createPlaylist" 
                               style="padding: 8px 16px; background: #065fd4; color: white; text-decoration: none; border-radius: 4px;">
                                Create New
                            </a>
                        </div>
                    </div>
                </div>
                
                <script>
                    document.getElementById('addToPlaylistBtn').addEventListener('click', function() {
                        document.getElementById('playlistModal').style.display = 'flex';
                        loadPlaylists();
                    });
                    
                    document.getElementById('cancelPlaylist').addEventListener('click', function() {
                        document.getElementById('playlistModal').style.display = 'none';
                    });
                    
                    // Close modal when clicking outside
                    document.getElementById('playlistModal').addEventListener('click', function(e) {
                        if (e.target === this) {
                            this.style.display = 'none';
                        }
                    });

                    function loadPlaylists() {
                        var xhr = new XMLHttpRequest();
                        xhr.open('GET', 'getUserPlaylists?videoId=' + ${video.id}, true);
                        xhr.onload = function() {
                            if (xhr.status === 200) {
                                document.getElementById('playlistList').innerHTML = xhr.responseText;
                            } else {
                                document.getElementById('playlistList').innerHTML = '<p>Error loading playlists</p>';
                            }
                        };
                        xhr.send();
                    }
                    
                    function addToPlaylist(playlistId) {
                        var xhr = new XMLHttpRequest();
                        xhr.open('POST', 'addVideoToPlaylist', true);
                        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                        xhr.onload = function() {
                            if (xhr.status === 200) {
                                alert('Video added to playlist!');
                                document.getElementById('playlistModal').style.display = 'none';
                            } else {
                                alert('Error adding video to playlist');
                            }
                        };
                        xhr.send('playlistId=' + playlistId + '&videoId=' + ${video.id});
                    }
                </script>
            </c:if>
            
            <!-- Channel Information -->
            <div class="channel-info">
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
                <div style="flex: 1;">
                    <!-- Make channel name clickable -->
                    <a href="channelVideos?channelId=${channel.id}" style="text-decoration: none; color: inherit;">
                        <div style="font-weight: bold; display: flex; align-items: center;">
                            ${channel.displayName}
                            <!-- Channel Banned Indicator -->
                            <c:if test="${channel.isActive == '0'}">
                                <span class="channel-banned-indicator">(Channel Banned)</span>
                            </c:if>
                        </div>
                    </a>
                    <div style="color: #666; font-size: 14px;">
                        ${subscriberCount} subscribers
                    </div>
                </div>
                
                <!-- Subscribe Button -->
                <c:if test="${not empty sessionScope.channel && sessionScope.channel.id != channel.id}">
                    <form action="subscribe" method="post" style="margin-left: 20px;">
                        <input type="hidden" name="videoId" value="${video.id}">
                        <input type="hidden" name="channelId" value="${channel.id}">
                        <button type="submit" style="padding: 8px 16px; background: ${isSubscribed ? '#ccc' : '#cc0000'}; color: white; border: none; border-radius: 4px; font-weight: bold;">
                            ${isSubscribed ? 'SUBSCRIBED' : 'SUBSCRIBE'}
                        </button>
                    </form>
                </c:if>
            </div>

            <!-- Like/Dislike Buttons -->
            <div style="margin: 20px 0; display: flex; gap: 20px;">
                <form action="videoReaction" method="post" style="display: inline;">
                    <input type="hidden" name="videoId" value="${video.id}">
                    <input type="hidden" name="reactionType" value="like">
                    <button type="submit" style="background: none; border: none; cursor: pointer; display: flex; align-items: center; gap: 5px; color: ${userReaction == 'like' ? '#065fd4' : '#606060'};">
                        <span style="font-size: 20px;">👍</span>
                        <span>Like</span>
                        <span style="color: #606060;">(${video.likesCount})</span>
                    </button>
                </form>
                
                <form action="videoReaction" method="post" style="display: inline;">
                    <input type="hidden" name="videoId" value="${video.id}">
                    <input type="hidden" name="reactionType" value="dislike">
                    <button type="submit" style="background: none; border: none; cursor: pointer; display: flex; align-items: center; gap: 5px; color: ${userReaction == 'dislike' ? '#065fd4' : '#606060'};">
                        <span style="font-size: 20px;">👎</span>
                        <span>Dislike</span>
                        <span style="color: #606060;">(${video.dislikeCount})</span>
                    </button>
                </form>
            </div>

            <!-- Video Description -->
            <div style="background: #f9f9f9; padding: 15px; border-radius: 5px; margin-top: 15px;">
                <div style="font-weight: bold; margin-bottom: 10px;">Description:</div>
                <div>${video.videoDescription}</div>
            </div>
        </div>

        <!-- Comments Section -->
        <div class="comments-section">
            <h3>Comments (<c:out value="${comments.size()}"/>)</h3>
            
            <!-- Add Comment Form (only for logged-in users) -->
            <c:if test="${not empty sessionScope.channel}">
                <form action="addComment" method="post" style="margin-bottom: 30px;">
                    <input type="hidden" name="videoId" value="${video.id}">
                    <textarea name="commentText" placeholder="Add a public comment..." 
                              style="width: 100%; height: 80px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"></textarea>
                    <button type="submit" style="margin-top: 10px; padding: 8px 16px; background: #065fd4; color: white; border: none; border-radius: 4px;">
                        Comment
                    </button>
                </form>
            </c:if>

            <!-- Display Pinned Comment Separately -->
            <c:if test="${not empty comments}">
                <c:set var="hasPinnedComment" value="false" />
                <c:forEach items="${comments}" var="comment">
                    <c:if test="${comment.isPinned == '1'}">
                        <c:set var="hasPinnedComment" value="true" />
                    </c:if>
                </c:forEach>
                
                <c:if test="${hasPinnedComment}">
                    <div style="margin-bottom: 30px;">
                        <h4 style="color: #ff9800; margin-bottom: 15px;">
                            📌 Pinned Comment
                        </h4>
                        <c:forEach items="${comments}" var="comment">
                            <c:if test="${comment.isPinned == '1'}">
                                <div class="comment pinned-comment" style="background: #fff8e1; border-left: 4px solid #ff9800; padding: 15px; margin-bottom: 15px;">
                                    <div style="display: flex; align-items: flex-start;">
                                        <c:choose>
                                            <c:when test="${not empty comment.userProfilePicture}">
                                                <img src="${pageContext.request.contextPath}/${comment.userProfilePicture}" 
                                                     alt="${comment.userDisplayName}" 
                                                     style="width: 40px; height: 40px; border-radius: 50%; margin-right: 15px;">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/images/default-avatar.jpg" 
                                                     alt="${comment.userDisplayName}" 
                                                     style="width: 40px; height: 40px; border-radius: 50%; margin-right: 15px;">
                                            </c:otherwise>
                                        </c:choose>
                                        <div style="flex: 1;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <span style="background: #ff9800; color: white; padding: 2px 6px; border-radius: 4px; font-size: 11px; margin-right: 8px;">PINNED</span>
                                                <a href="channelVideos?channelId=${comment.userId}" style="text-decoration: none; color: inherit;">
                                                    ${comment.userDisplayName}
                                                </a>
                                                <span style="color: #666; font-weight: normal; font-size: 12px; margin-left: 10px;">
                                                    ${comment.createdAt}
                                                </span>
                                            </div>
                                            <div style="margin: 10px 0;">${comment.commentText}</div>
                                            
                                            <!-- Pin/Unpin controls for video owner -->
                                            <c:if test="${not empty sessionScope.channel && sessionScope.channel.id == video.channelId}">
                                                <div class="comment-actions">
                                                    <form action="manageComment" method="post" style="display: inline;">
                                                        <input type="hidden" name="commentId" value="${comment.id}">
                                                        <input type="hidden" name="videoId" value="${video.id}">
                                                        <input type="hidden" name="action" value="unpin">
                                                        <button type="submit" style="background: none; border: none; color: #065fd4; cursor: pointer; font-size: 12px;">
                                                            📍 Unpin
                                                        </button>
                                                    </form>
                                                    <form action="manageComment" method="post" style="display: inline;" onsubmit="return confirm('Delete this comment?');">
                                                        <input type="hidden" name="commentId" value="${comment.id}">
                                                        <input type="hidden" name="videoId" value="${video.id}">
                                                        <input type="hidden" name="action" value="delete">
                                                        <button type="submit" style="background: none; border: none; color: #cc0000; cursor: pointer; font-size: 12px;">
                                                            🗑️ Delete
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>
            </c:if>

            <!-- Display Other Comments -->
            <h4 style="margin-bottom: 15px;">All Comments</h4>
            <c:forEach items="${comments}" var="comment">
                <c:if test="${comment.isPinned != '1'}">
                    <div class="comment" style="margin: 15px 0; padding: 10px; border-bottom: 1px solid #eee;">
                        <div style="display: flex; align-items: flex-start;">
                            <c:choose>
                                <c:when test="${not empty comment.userProfilePicture}">
                                    <img src="${pageContext.request.contextPath}/${comment.userProfilePicture}" 
                                         alt="${comment.userDisplayName}" 
                                         style="width: 40px; height: 40px; border-radius: 50%; margin-right: 15px;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/images/default-avatar.jpg" 
                                         alt="${comment.userDisplayName}" 
                                         style="width: 40px; height: 40px; border-radius: 50%; margin-right: 15px;">
                                </c:otherwise>
                            </c:choose>
                            <div style="flex: 1;">
                                <div style="font-weight: bold; margin-bottom: 5px;">
                                    <a href="channelVideos?channelId=${comment.userId}" style="text-decoration: none; color: inherit;">
                                        ${comment.userDisplayName}
                                    </a>
                                    <span style="color: #666; font-weight: normal; font-size: 12px; margin-left: 10px;">
                                        ${comment.createdAt}
                                    </span>
                                </div>
                                <div style="margin: 10px 0;">${comment.commentText}</div>
                                
                                <!-- Pin controls for video owner (only show for non-pinned comments) -->
                                <c:if test="${not empty sessionScope.channel && sessionScope.channel.id == video.channelId}">
                                    <div class="comment-actions">
                                        <form action="manageComment" method="post" style="display: inline;">
                                            <input type="hidden" name="commentId" value="${comment.id}">
                                            <input type="hidden" name="videoId" value="${video.id}">
                                            <input type="hidden" name="action" value="pin">
                                            <button type="submit" style="background: none; border: none; color: #065fd4; cursor: pointer; font-size: 12px;">
                                                📍 Pin this comment
                                            </button>
                                        </form>
                                        <form action="manageComment" method="post" style="display: inline;" onsubmit="return confirm('Delete this comment?');">
                                            <input type="hidden" name="commentId" value="${comment.id}">
                                            <input type="hidden" name="videoId" value="${video.id}">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" style="background: none; border: none; color: #cc0000; cursor: pointer; font-size: 12px;">
                                                🗑️ Delete
                                            </button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>

    <script>
    // Single unified showUpgradeModal function
    function showUpgradeModal() {
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            z-index: 10000;
            display: flex;
            align-items: center;
            justify-content: center;
        `;
        
        modal.innerHTML = `
            <div style="background: white; border-radius: 12px; padding: 30px; max-width: 400px; width: 90%; text-align: center;">
                <div style="font-size: 48px; margin-bottom: 15px;">🔒</div>
                <h2 style="margin: 0 0 15px 0;">Premium Feature</h2>
                <p style="color: #666; margin-bottom: 20px;">
                    This feature is available for Premium members only.<br>
                    Watch a short sponsor video to unlock Premium for free!
                </p>
                <div style="display: flex; gap: 15px; justify-content: center;">
                    <button id="cancelUpgradeBtn" style="padding: 10px 25px; background: #f8f8f8; border: 1px solid #ccc; border-radius: 6px; cursor: pointer;">
                        Cancel
                    </button>
                    <button id="goToUpgradeBtn" style="padding: 10px 25px; background: #4CAF50; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold;">
                        Upgrade Now
                    </button>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Add event listeners
        modal.querySelector('#cancelUpgradeBtn').addEventListener('click', function() {
            document.body.removeChild(modal);
        });
        
        modal.querySelector('#goToUpgradeBtn').addEventListener('click', function() {
            window.location.href = 'upgrade';
        });
        
        // Close when clicking outside
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                document.body.removeChild(modal);
            }
        });
    }

    // Check premium status
    function checkPremiumStatus() {
        fetch('getPremiumRemainingTime')
            .then(response => response.text())
            .then(data => {
                if (data === 'Expired') {
                    alert('Your premium membership has expired. Features will be disabled.');
                    location.reload();
                } else {
                    alert(`Premium active! Time remaining: ${data}`);
                }
            });
    }

    // Track when video is actually played
    document.addEventListener('DOMContentLoaded', function() {
        var videoElement = document.querySelector('video');
        
        if (videoElement) {
            var hasBeenPlayed = false;
            var hasTriggeredView = false;
            
            videoElement.addEventListener('play', function() {
                hasBeenPlayed = true;
                
                // If this is the first play and we haven't triggered a view yet
                if (!hasTriggeredView) {
                    triggerViewCount();
                    hasTriggeredView = true;
                }
            });
            
            // Also count views if user watches for at least 30 seconds
            videoElement.addEventListener('timeupdate', function() {
                if (videoElement.currentTime >= 30 && !hasTriggeredView) {
                    triggerViewCount();
                    hasTriggeredView = true;
                }
            });
            
            function triggerViewCount() {
                // Send AJAX request to count the view
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'trackView', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.send('videoId=' + ${video.id});
                
                console.log('View counted for video ${video.id}');
            }
        }
        
        // Video overlay behavior for non-premium users
        const videoOverlay = document.getElementById('videoOverlay');
        const videoPlayer = document.getElementById('mainVideo');
        
        if (videoOverlay && videoPlayer) {
            // Show overlay when video is hovered
            videoPlayer.addEventListener('mouseenter', function() {
                videoOverlay.style.display = 'flex';
            });
            
            videoPlayer.addEventListener('mouseleave', function() {
                videoOverlay.style.display = 'none';
            });
            
            // Allow video controls to work
            videoOverlay.style.pointerEvents = 'none';
        }
        
        // Disable right-click and keyboard shortcuts for non-premium users
        <c:if test="${sessionScope.channel == null || sessionScope.channel.isPremium != '1'}">
        if (videoPlayer) {
            // Disable right-click
            videoPlayer.addEventListener('contextmenu', function(e) {
                e.preventDefault();
                showUpgradeModal();
                return false;
            });
            
            // Disable keyboard shortcuts (Ctrl+S)
            document.addEventListener('keydown', function(e) {
                if (e.ctrlKey && (e.key === 's' || e.key === 'S')) {
                    e.preventDefault();
                    showUpgradeModal();
                }
            });
        }
        </c:if>
    });
    </script>
</body>
</html>