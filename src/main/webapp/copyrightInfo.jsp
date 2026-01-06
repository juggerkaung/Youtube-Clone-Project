<!-- copyrightInfo.jsp file: -->
<%-- 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Copyright Information</title>
    <style>
        .copyright-container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
        }
        .copyright-status {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: bold;
        }
        .status-claim {
            background: #fff3cd;
            border: 1px solid #ffc107;
            color: #856404;
        }
        .status-strike {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        .status-none {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
        }
        .copyright-details {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .video-info-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="copyright-container">
        <h2>Copyright Information</h2>
        <p><a href="channelDashboard">&larr; Back to Dashboard</a></p>
        
        <div class="copyright-status status-${video.copyrightStatus}">
            <c:choose>
                <c:when test="${video.copyrightStatus == 'claim'}">
                    ⚠️ Copyright Claim
                </c:when>
                <c:when test="${video.copyrightStatus == 'strike'}">
                    ⛔ Copyright Strike
                </c:when>
                <c:otherwise>
                    ✅ No Copyright Issues
                </c:otherwise>
            </c:choose>
        </div>
        
        <c:if test="${video.copyrightStatus != 'none'}">
            <div class="copyright-details">
                <h3>Copyright Details</h3>
                <p><strong>Reason:</strong> ${video.copyrightReason}</p>
                
                <c:if test="${not empty sourceVideo}">
                    <h4>Source Video</h4>
                    <div class="video-info-card">
                        <p><strong>Video Title:</strong> ${sourceVideo.videoTitle}</p>
                        <p><strong>Channel:</strong> ${sourceVideo.channelName}</p>
                        <p><strong>Uploaded:</strong> ${sourceVideo.createdAt}</p>
                        <a href="video?id=${sourceVideo.id}" class="btn" style="padding: 8px 16px; background: #065fd4; color: white; text-decoration: none; border-radius: 4px;">
                            View Source Video
                        </a>
                    </div>
                </c:if>
                
                <c:if test="${video.copyrightStatus == 'strike'}">
                    <div style="background: #f8d7da; padding: 15px; border-radius: 8px; margin-top: 20px;">
                        <h4 style="color: #721c24; margin-top: 0;">⚠️ Important Notice</h4>
                        <p>This video has received a copyright strike and has been automatically set to private.</p>
                        <p>You cannot edit this video. You can only delete it.</p>
                        <p><a href="editVideo?id=${video.id}" style="color: #721c24; font-weight: bold;">Go to video edit page to delete</a></p>
                    </div>
                </c:if>
            </div>
        </c:if>
        
        <c:if test="${video.copyrightStatus == 'none'}">
            <div class="copyright-details">
                <p>No copyright issues detected for this video.</p>
            </div>
        </c:if>
    </div>
</body>
</html> --%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Copyright information - YouTube Clone</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --youtube-red: #FF0000;
            --youtube-dark: #0F0F0F;
            --youtube-gray: #606060;
            --youtube-light-gray: #F2F2F2;
            --youtube-text: #0F0F0F;
            --youtube-text-secondary: #606060;
            --youtube-blue: #065fd4;
            --youtube-green: #4CAF50;
            --youtube-warning: #FF9800;
            --youtube-danger: #DC3545;
            --youtube-info: #17A2B8;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: "Roboto", "Arial", sans-serif;
            background-color: #F9F9F9;
            color: var(--youtube-text);
            min-height: 100vh;
        }
        
        .copyright-container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        /* Page Header */
        .page-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #E5E5E5;
        }
        
        .back-button {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: var(--youtube-text);
            padding: 8px 16px;
            border-radius: 4px;
            margin-right: 20px;
            transition: background-color 0.2s;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-family: inherit;
        }
        
        .back-button:hover {
            background-color: var(--youtube-light-gray);
        }
        
        .page-title {
            font-size: 24px;
            font-weight: 500;
            flex: 1;
        }
        
        /* Status Banner */
        .status-banner {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            background: white;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .status-icon {
            font-size: 32px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        
        .status-content {
            flex: 1;
        }
        
        .status-title {
            font-size: 20px;
            font-weight: 500;
            margin-bottom: 4px;
        }
        
        .status-description {
            font-size: 14px;
            color: var(--youtube-text-secondary);
        }
        
        /* Status Colors */
        .status-none {
            background-color: rgba(76, 175, 80, 0.1);
            color: var(--youtube-green);
        }
        
        .status-claim {
            background-color: rgba(255, 152, 0, 0.1);
            color: var(--youtube-warning);
        }
        
        .status-strike {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--youtube-danger);
        }
        
        /* Content Cards */
        .content-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .card-title {
            font-size: 18px;
            font-weight: 500;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid #E5E5E5;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .card-title i {
            font-size: 20px;
        }
        
        /* Copyright Details */
        .copyright-details {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        
        .detail-item {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            padding: 12px;
            background-color: #F8F9FA;
            border-radius: 8px;
            border-left: 4px solid var(--youtube-blue);
        }
        
        .detail-label {
            font-weight: 500;
            color: var(--youtube-text);
            min-width: 120px;
        }
        
        .detail-value {
            flex: 1;
            color: var(--youtube-text-secondary);
        }
        
        /* Source Video Card */
        .source-video-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            overflow: hidden;
            color: white;
        }
        
        .source-video-header {
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
        }
        
        .source-video-title {
            font-size: 18px;
            font-weight: 500;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .source-video-content {
            padding: 20px;
        }
        
        .video-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }
        
        .meta-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        
        .meta-label {
            font-size: 12px;
            opacity: 0.8;
        }
        
        .meta-value {
            font-size: 14px;
            font-weight: 500;
        }
        
        /* Warning Section */
        .warning-section {
            background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 100%);
            border-radius: 12px;
            padding: 30px;
            margin-top: 30px;
        }
        
        .warning-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }
        
        .warning-icon {
            font-size: 32px;
            color: #721C24;
        }
        
        .warning-title {
            font-size: 20px;
            font-weight: 500;
            color: #721C24;
        }
        
        .warning-content {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .warning-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .warning-list li {
            padding: 8px 0;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .warning-list li:before {
            content: "⚠️";
            font-size: 16px;
        }
        
        /* Buttons */
        .button-group {
            display: flex;
            gap: 16px;
            margin-top: 20px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s;
            text-decoration: none;
            font-family: inherit;
        }
        
        .btn-primary {
            background-color: var(--youtube-blue);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #0548A3;
        }
        
        .btn-secondary {
            background-color: transparent;
            color: var(--youtube-text);
            border: 1px solid #DADCE0;
        }
        
        .btn-secondary:hover {
            background-color: var(--youtube-light-gray);
        }
        
        .btn-danger {
            background-color: var(--youtube-danger);
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #C82333;
        }
        
        .btn-view {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .btn-view:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        
        /* No Issues Card */
        .no-issues-card {
            text-align: center;
            padding: 40px;
        }
        
        .no-issues-icon {
            font-size: 64px;
            color: var(--youtube-green);
            margin-bottom: 20px;
        }
        
        .no-issues-title {
            font-size: 24px;
            font-weight: 500;
            margin-bottom: 12px;
            color: var(--youtube-green);
        }
        
        .no-issues-description {
            font-size: 16px;
            color: var(--youtube-text-secondary);
            max-width: 600px;
            margin: 0 auto 30px;
            line-height: 1.6;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .copyright-container {
                padding: 0 16px;
            }
            
            .status-banner {
                flex-direction: column;
                text-align: center;
                gap: 12px;
            }
            
            .status-icon {
                width: 50px;
                height: 50px;
                font-size: 24px;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .video-meta {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 480px) {
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }
            
            .back-button {
                margin-right: 0;
            }
            
            .content-card {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="header.jsp" />
    
    <div class="copyright-container">
        <!-- Page Header -->
        <div class="page-header">
            <button onclick="history.back()" class="back-button">
                <i class="fas fa-arrow-left"></i>
                Back
            </button>
            <h1 class="page-title">Copyright information</h1>
        </div>
        
        <!-- Status Banner -->
        <div class="status-banner">
            <div class="status-icon status-${video.copyrightStatus}">
                <c:choose>
                    <c:when test="${video.copyrightStatus == 'claim'}">
                        <i class="fas fa-exclamation-triangle"></i>
                    </c:when>
                    <c:when test="${video.copyrightStatus == 'strike'}">
                        <i class="fas fa-ban"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-check-circle"></i>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="status-content">
                <h2 class="status-title">
                    <c:choose>
                        <c:when test="${video.copyrightStatus == 'claim'}">
                            Copyright claim detected
                        </c:when>
                        <c:when test="${video.copyrightStatus == 'strike'}">
                            Copyright strike received
                        </c:when>
                        <c:otherwise>
                            No copyright issues
                        </c:otherwise>
                    </c:choose>
                </h2>
                <p class="status-description">
                    <c:choose>
                        <c:when test="${video.copyrightStatus == 'claim'}">
                            Your video has a copyright claim. You can still edit and view the video.
                        </c:when>
                        <c:when test="${video.copyrightStatus == 'strike'}">
                            Your video has received a copyright strike and has been set to private.
                        </c:when>
                        <c:otherwise>
                            Your video is clear of any copyright restrictions.
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>
        
        <!-- Copyright Details -->
        <c:if test="${video.copyrightStatus != 'none'}">
            <div class="content-card">
                <h3 class="card-title">
                    <i class="fas fa-file-alt"></i>
                    Copyright details
                </h3>
                
                <div class="copyright-details">
                    <div class="detail-item">
                        <span class="detail-label">Status</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${video.copyrightStatus == 'claim'}">
                                    <span style="color: var(--youtube-warning); font-weight: 500;">
                                        <i class="fas fa-exclamation-triangle"></i> Copyright Claim
                                    </span>
                                </c:when>
                                <c:when test="${video.copyrightStatus == 'strike'}">
                                    <span style="color: var(--youtube-danger); font-weight: 500;">
                                        <i class="fas fa-ban"></i> Copyright Strike
                                    </span>
                                </c:when>
                            </c:choose>
                        </span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Reason</span>
                        <span class="detail-value">${video.copyrightReason}</span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Video ID</span>
                        <span class="detail-value">${video.id}</span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Video Title</span>
                        <span class="detail-value">${video.videoTitle}</span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Video Status</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${video.isPublic == '1'}">
                                    <span style="color: var(--youtube-green);">Public</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--youtube-danger);">Private</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>
            
            <!-- Source Video Information -->
            <c:if test="${not empty sourceVideo}">
                <div class="content-card source-video-card">
                    <div class="source-video-header">
                        <h3 class="source-video-title">
                            <i class="fas fa-link"></i>
                            Source video information
                        </h3>
                        <p style="opacity: 0.9; font-size: 14px;">
                            This is the original video that triggered the copyright detection
                        </p>
                    </div>
                    
                    <div class="source-video-content">
                        <div class="video-meta">
                            <div class="meta-item">
                                <span class="meta-label">VIDEO TITLE</span>
                                <span class="meta-value">${sourceVideo.videoTitle}</span>
                            </div>
                            
                            <div class="meta-item">
                                <span class="meta-label">CHANNEL</span>
                                <span class="meta-value">${sourceVideo.channelName}</span>
                            </div>
                            
                            <div class="meta-item">
                                <span class="meta-label">UPLOAD DATE</span>
                                <span class="meta-value">${sourceVideo.createdAt}</span>
                            </div>
                            
                            <div class="meta-item">
                                <span class="meta-label">VIEWS</span>
                                <span class="meta-value">${sourceVideo.formattedViews}</span>
                            </div>
                        </div>
                        
                        <div class="button-group">
                            <a href="video?id=${sourceVideo.id}" class="btn btn-view">
                                <i class="fas fa-external-link-alt"></i>
                                View source video
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:if>
        
        <!-- No Issues Card -->
        <c:if test="${video.copyrightStatus == 'none'}">
            <div class="content-card no-issues-card">
                <div class="no-issues-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h2 class="no-issues-title">No copyright issues detected</h2>
                <p class="no-issues-description">
                    Your video is free from copyright claims and strikes. You can continue to 
                    edit, share, and monetize your content without restrictions.
                </p>
                <div class="button-group" style="justify-content: center;">
                    <a href="video?id=${video.id}" class="btn btn-primary">
                        <i class="fas fa-play-circle"></i>
                        Watch video
                    </a>
                    <a href="editVideo?id=${video.id}" class="btn btn-secondary">
                        <i class="fas fa-edit"></i>
                        Edit video
                    </a>
                </div>
            </div>
        </c:if>
        
        <!-- Warning Section for Copyright Strikes -->
        <c:if test="${video.copyrightStatus == 'strike'}">
            <div class="warning-section">
                <div class="warning-header">
                    <div class="warning-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h3 class="warning-title">Important notice</h3>
                </div>
                
                <div class="warning-content">
                    <p style="margin-bottom: 16px; color: #721C24; font-weight: 500;">
                        This video has received a copyright strike and has been automatically set to private.
                    </p>
                    
                    <ul class="warning-list">
                        <li>The video is no longer publicly accessible</li>
                        <li>You cannot edit the video's content or metadata</li>
                        <li>The video does not appear in search results</li>
                        <li>Multiple copyright strikes can lead to channel termination</li>
                    </ul>
                    
                    <div style="margin-top: 20px; padding: 16px; background: rgba(220, 53, 69, 0.1); border-radius: 8px; border-left: 4px solid var(--youtube-danger);">
                        <p style="margin: 0; color: #721C24; font-weight: 500;">
                            <i class="fas fa-exclamation-circle"></i>
                            You can only delete this video to remove it from your channel.
                        </p>
                    </div>
                </div>
                
                <div class="button-group">
                    <a href="editVideo?id=${video.id}" class="btn btn-danger">
                        <i class="fas fa-trash"></i>
                        Delete this video
                    </a>
                    <a href="channelDashboard" class="btn btn-secondary">
                        <i class="fas fa-tachometer-alt"></i>
                        Go to dashboard
                    </a>
                </div>
            </div>
        </c:if>
        
        <!-- For Copyright Claims -->
        <c:if test="${video.copyrightStatus == 'claim'}">
            <div class="content-card">
                <h3 class="card-title">
                    <i class="fas fa-lightbulb"></i>
                    Next steps
                </h3>
                
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-top: 20px;">
                    <div style="padding: 20px; background: #F8F9FA; border-radius: 8px; border: 1px solid #E5E5E5;">
                        <div style="font-size: 24px; color: var(--youtube-blue); margin-bottom: 12px;">
                            <i class="fas fa-edit"></i>
                        </div>
                        <h4 style="margin-bottom: 8px; font-weight: 500;">Edit your video</h4>
                        <p style="font-size: 14px; color: var(--youtube-text-secondary);">
                            You can still edit your video's title, description, and privacy settings.
                        </p>
                    </div>
                    
                    <div style="padding: 20px; background: #F8F9FA; border-radius: 8px; border: 1px solid #E5E5E5;">
                        <div style="font-size: 24px; color: var(--youtube-warning); margin-bottom: 12px;">
                            <i class="fas fa-eye"></i>
                        </div>
                        <h4 style="margin-bottom: 8px; font-weight: 500;">Review the claim</h4>
                        <p style="font-size: 14px; color: var(--youtube-text-secondary);">
                            Check the source video to understand what content was matched.
                        </p>
                    </div>
                    
                    <div style="padding: 20px; background: #F8F9FA; border-radius: 8px; border: 1px solid #E5E5E5;">
                        <div style="font-size: 24px; color: var(--youtube-green); margin-bottom: 12px;">
                            <i class="fas fa-info-circle"></i>
                        </div>
                        <h4 style="margin-bottom: 8px; font-weight: 500;">Learn more</h4>
                        <p style="font-size: 14px; color: var(--youtube-text-secondary);">
                            Copyright claims don't affect your channel standing unless they become strikes.
                        </p>
                    </div>
                </div>
                
                <div class="button-group" style="margin-top: 30px;">
                    <a href="editVideo?id=${video.id}" class="btn btn-primary">
                        <i class="fas fa-edit"></i>
                        Edit this video
                    </a>
                    <a href="video?id=${video.id}" class="btn btn-secondary">
                        <i class="fas fa-play-circle"></i>
                        Watch video
                    </a>
                </div>
            </div>
        </c:if>
    </div>
    
    <script>
    // Add some interactive effects
    document.addEventListener('DOMContentLoaded', function() {
        // Add click animation to buttons
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(button => {
            button.addEventListener('click', function(e) {
                // Add ripple effect
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.cssText = `
                    position: absolute;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, 0.7);
                    transform: scale(0);
                    animation: ripple-animation 0.6s linear;
                    width: ${size}px;
                    height: ${size}px;
                    top: ${y}px;
                    left: ${x}px;
                    pointer-events: none;
                `;
                
                this.style.position = 'relative';
                this.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });
        
        // Add animation to status banner on load
        const statusBanner = document.querySelector('.status-banner');
        if (statusBanner) {
            statusBanner.style.opacity = '0';
            statusBanner.style.transform = 'translateY(20px)';
            statusBanner.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            
            setTimeout(() => {
                statusBanner.style.opacity = '1';
                statusBanner.style.transform = 'translateY(0)';
            }, 100);
        }
        
        // Add CSS for ripple animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple-animation {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    });
    </script>
</body>
</html>