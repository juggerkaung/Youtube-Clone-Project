<!-- admin.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - YouTube Clone</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        :root {
            --primary-color: #ff0000;
            --sidebar-width: 250px;
            --header-height: 60px;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            transition: background 0.3s, color 0.3s;
        }
        
        /* Theme classes */
        body.day-theme {
            --bg-color: #ffffff;
            --sidebar-bg: #1a1a1a;
            --text-color: #333333;
            --card-bg: #ffffff;
            --border-color: #e0e0e0;
            --hover-color: #f5f5f5;
        }
        
        body.dark-theme {
            --bg-color: #121212;
            --sidebar-bg: #1e1e1e;
            --text-color: #ffffff;
            --card-bg: #1e1e1e;
            --border-color: #333333;
            --hover-color: #2a2a2a;
        }
        
        body.gold-theme {
            --bg-color: #fffaf0;
            --sidebar-bg: #8b7355;
            --text-color: #5c4033;
            --card-bg: #fff8e1;
            --border-color: #d4af37;
            --hover-color: #f5e6c8;
        }
        
        body {
            background-color: var(--bg-color);
            color: var(--text-color);
        }
        
        .admin-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar */
        .admin-sidebar {
            width: var(--sidebar-width);
            background: var(--sidebar-bg);
            color: white;
            padding: 20px 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: transform 0.3s;
            z-index: 1000;
        }
        
        .admin-logo {
            padding: 0 20px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 20px;
        }
        
        .admin-logo h2 {
            color: white;
            font-size: 18px;
        }
        
        .admin-logo .role {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        
        .sidebar-menu {
            list-style: none;
        }
        
        .sidebar-menu li {
            margin-bottom: 5px;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: #ddd;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: rgba(255,255,255,0.1);
            color: white;
            border-left: 4px solid var(--primary-color);
        }
        
        .sidebar-menu i {
            margin-right: 10px;
            font-size: 18px;
        }
        
        /* Main Content */
        .admin-main {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 20px;
            transition: margin-left 0.3s;
        }
        
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--border-color);
        }
        
        .admin-header h1 {
            font-size: 24px;
        }
        
        .theme-selector {
            display: flex;
            gap: 10px;
        }
        
        .theme-btn {
            padding: 8px 15px;
            border: 1px solid var(--border-color);
            background: var(--card-bg);
            color: var(--text-color);
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .theme-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .theme-btn.active {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
        
        /* Content Sections */
        .content-section {
            display: none;
            animation: fadeIn 0.3s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .content-section.active {
            display: block;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .stat-card h3 {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .stat-card .value {
            font-size: 28px;
            font-weight: bold;
            color: var(--primary-color);
        }
        
        /* Tables */
        .data-table {
            width: 100%;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .data-table th,
        .data-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        
        .data-table th {
            background: rgba(0,0,0,0.05);
            font-weight: bold;
        }
        
        .data-table tr:hover {
            background: var(--hover-color);
        }
        
        /* Action Buttons */
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        
        .btn-edit {
            background: #4CAF50;
            color: white;
        }
        
        .btn-delete {
            background: #f44336;
            color: white;
        }
        
        .btn-ban {
            background: #ff9800;
            color: white;
        }
        
        .btn-view {
            background: #2196F3;
            color: white;
        }
        
        .btn-toggle {
            background: #9C27B0;
            color: white;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        
        /* Search Bar */
        .search-bar {
            margin-bottom: 20px;
        }
        
        .search-bar input {
            width: 300px;
            padding: 10px 15px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            background: var(--card-bg);
            color: var(--text-color);
            font-size: 14px;
        }
        
        .search-bar input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(255,0,0,0.1);
        }
        
        /* Status Badges */
        .status-badge {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }
        
        .status-active {
            background: #4CAF50;
            color: white;
        }
        
        .status-inactive {
            background: #f44336;
            color: white;
        }
        
        .status-public {
            background: #2196F3;
            color: white;
        }
        
        .status-private {
            background: #9C27B0;
            color: white;
        }
        
        /* Form Styles */
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: var(--text-color);
        }
        
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group textarea,
        .form-group input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            background: var(--card-bg);
            color: var(--text-color);
        }
        
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        /* Messages */
        .message {
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-weight: bold;
        }
        
        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .admin-sidebar {
                transform: translateX(-100%);
            }
            
            .admin-main {
                margin-left: 0;
            }
            
            .admin-sidebar.active {
                transform: translateX(0);
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .search-bar input {
                width: 100%;
            }
        }
        
        /* Debug Info */
        .debug-info {
            background: var(--hover-color);
            padding: 5px 10px;
            margin-bottom: 15px;
            border-radius: 4px;
            font-size: 12px;
            color: #666;
            border: 1px dashed var(--border-color);
        }
        
        /* Mobile Menu Button */
        .mobile-menu-btn {
            display: none;
            position: fixed;
            top: 15px;
            left: 15px;
            z-index: 1001;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 4px;
            padding: 8px 12px;
            cursor: pointer;
            font-size: 16px;
        }
        
        @media (max-width: 768px) {
            .mobile-menu-btn {
                display: block;
            }
        }
    </style>
</head>
<body class="day-theme ${sessionScope.adminTheme != null ? sessionScope.adminTheme : 'day'}-theme">
    <!-- Mobile Menu Button -->
    <button class="mobile-menu-btn" id="mobileMenuBtn">☰</button>
    
    <div class="admin-container">
        <!-- Sidebar -->
        <div class="admin-sidebar" id="adminSidebar">
            <div class="admin-logo">
                <h2>YouTube Admin</h2>
                <div class="role">Administrator</div>
                <div style="font-size: 11px; color: #999; margin-top: 5px;">
                    Logged in as: ${admin.email}
                </div>
            </div>
            
            <ul class="sidebar-menu">
                <li>
                    <a href="#" class="sidebar-link ${currentSection == 'channels' ? 'active' : ''}" data-section="channels">
                        📺 Channels
                    </a>
                </li>
                <li>
                    <a href="#" class="sidebar-link ${currentSection == 'videos' ? 'active' : ''}" data-section="videos">
                        🎬 Videos
                    </a>
                </li>
                <li>
                    <a href="#" class="sidebar-link ${currentSection == 'sponsorVideos' ? 'active' : ''}" data-section="sponsorVideos">
                        ⭐ Sponsor Videos
                    </a>
                </li>
                
               <!--  <li style="margin-top: 30px;">
                    <a href="logout" class="sidebar-link" onclick="return confirm('Are you sure you want to logout?');">
                        🚪 Logout   
                  </a>
                </li> -->
                <li style="margin-top: 30px;">
    <a href="adminLogout" class="sidebar-link" onclick="return confirm('Are you sure you want to logout from admin?');">
        🚪 Logout   
    </a>
</li>
                
                
            </ul>
        </div>
        
        <!-- Main Content -->
        <div class="admin-main">
            <div class="admin-header">
                <h1>Admin Dashboard</h1>
                <div class="theme-selector">
                    <button class="theme-btn ${sessionScope.adminTheme == 'day' or empty sessionScope.adminTheme ? 'active' : ''}" data-theme="day">Day</button>
                    <button class="theme-btn ${sessionScope.adminTheme == 'dark' ? 'active' : ''}" data-theme="dark">Dark</button>
                    <button class="theme-btn ${sessionScope.adminTheme == 'gold' ? 'active' : ''}" data-theme="gold">Gold</button>
                </div>
            </div>
            
            <!-- Debug Info -->
            <div class="debug-info">
                Debug: Channels: ${not empty channels ? channels.size() : 0} | 
                Videos: ${not empty videos ? videos.size() : 0} | 
                Sponsor Videos: ${not empty sponsorVideos ? sponsorVideos.size() : 0} |
                Active Users: ${activeCount}
            </div>
            
            <!-- Success/Error Messages -->
            <c:if test="${not empty param.success}">
                <div class="message success">${param.success}</div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="message error">${param.error}</div>
            </c:if>
            
            <!-- Stats Overview -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total Channels</h3>
                    <div class="value">${not empty channels ? channels.size() : '0'}</div>
                </div>
                <div class="stat-card">
                    <h3>Total Videos</h3>
                    <div class="value">${not empty videos ? videos.size() : '0'}</div>
                </div>
                <div class="stat-card">
                    <h3>Active Users</h3>
                    <div class="value">${activeCount}</div>
                </div>
                <div class="stat-card">
                    <h3>Sponsor Videos</h3>
                    <div class="value">${not empty sponsorVideos ? sponsorVideos.size() : '0'}</div>
                </div>
            </div>
            
           <!--  Add this debug section near the top of your admin.jsp (after the stats grid): -->
           <!-- Debug Information Section -->
<div style="background: #e8f4fd; border: 1px solid #b6d4fe; border-radius: 4px; padding: 10px; margin-bottom: 15px; font-size: 12px;">
    <strong>Debug Information:</strong><br>
    Session Admin: ${not empty admin ? 'Logged in' : 'Not logged in'}<br>
    Session Admin Role: ${admin.roleId}<br>
    Current Section: ${currentSection}<br>
    
    <c:if test="${not empty param.success}">
        <div style="color: green; margin-top: 5px;">Success Message: ${param.success}</div>
    </c:if>
    
    <c:if test="${not empty param.error}">
        <div style="color: red; margin-top: 5px;">Error Message: ${param.error}</div>
    </c:if>
    
    <!-- Test buttons for direct debugging -->
    <div style="margin-top: 10px;">
        <button onclick="testBan(1)" style="padding: 5px 10px; background: #ff9800; color: white; border: none; border-radius: 3px; cursor: pointer; font-size: 11px;">
            Test Ban Channel 1
        </button>
        <button onclick="testUnban(1)" style="padding: 5px 10px; background: #4CAF50; color: white; border: none; border-radius: 3px; cursor: pointer; font-size: 11px;">
            Test Unban Channel 1
        </button>
    </div>
</div>

<script>
function testBan(channelId) {
    if(confirm('Test ban channel ' + channelId + '?')) {
        fetch('adminAction', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=toggleChannelStatus&channelId=' + channelId
        }).then(response => {
            alert('Ban action sent. Page will reload.');
            location.reload();
        });
    }
}

function testUnban(channelId) {
    if(confirm('Test unban channel ' + channelId + '?')) {
        fetch('adminAction', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=toggleChannelStatus&channelId=' + channelId
        }).then(response => {
            alert('Unban action sent. Page will reload.');
            location.reload();
        });
    }
}
</script>

            
            
            
            <!-- Channels Section -->
            <div id="channels-section" class="content-section ${currentSection == 'channels' ? 'active' : ''}">
                <div class="search-bar">
                    <input type="text" id="channelSearch" placeholder="Search channels by name or email..." 
                           value="${param.channelSearch}">
                </div>
                
             
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Display Name</th>
                            <th>Email</th>
                            <th>Subscribers</th>
                            <th>Status</th>
                            <th>Role</th>
                            <th>Premium</th> <!-- Add this column -->
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${channels}" var="channel">
                            <tr>
                                <td>${channel.id}</td>
                                <td>
                                    <strong>${channel.displayName}</strong>
                                    <br><small>${fn:substring(channel.description, 0, 50)}...</small>
                                </td>
                                <td>${channel.email}</td>
                                <td>${channel.subscriberCount}</td>
                                <td>
                                    <span class="status-badge ${channel.isActive == '1' ? 'status-active' : 'status-inactive'}">
                                        ${channel.isActive == '1' ? 'Active' : 'Banned'}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${channel.roleId == 1}"><span style="color: #ff0000;">Admin</span></c:when>
                                        <c:when test="${channel.roleId == 2}">Channel</c:when>
                                        <c:otherwise>Guest</c:otherwise>
                                    </c:choose>
                                </td>
                                
                                 <!-- In admin.jsp, in the channels table, add a Premium column: -->
                                <td>
                                 <c:choose>
                        <c:when test="${channel.isPremium == '1'}">
                            <span style="color: #FFD700; font-weight: bold;">👑 Premium</span>
                            <c:if test="${not empty channel.premiumSince}">
                                <br><small style="font-size: 10px; color: #888;">
                                    Since: ${fn:substring(channel.premiumSince.toString(), 0, 10)}
                                </small>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #666;">Regular</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                
                
                                   <td>
                                    <div class="action-buttons">
                                        <a href="channelVideos?channelId=${channel.id}" class="btn btn-view" target="_blank">View</a>
                                        <form action="adminAction" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="toggleChannelStatus">
                                            <input type="hidden" name="channelId" value="${channel.id}">
                                            <button type="submit" class="btn btn-ban">
                                                ${channel.isActive == '1' ? 'Ban' : 'Unban'}
                                            </button>
                                        </form>
                                        <form action="adminAction" method="post" style="display:inline;" 
                                              onsubmit="return confirm('Are you sure you want to delete this channel and all its content? This cannot be undone!');">
                                            <input type="hidden" name="action" value="deleteChannel">
                                            <input type="hidden" name="channelId" value="${channel.id}">
                                            <button type="submit" class="btn btn-delete">Delete</button>
                                        </form>
                                    </div>
                                </td>
                                
                                <!-- In admin.jsp, in the channels table, add a Premium column: -->
<%-- <td>
    <c:choose>
        <c:when test="${channel.isPremium == '1'}">
            <span style="color: #FFD700; font-weight: bold;">👑 Premium</span>
        </c:when>
        <c:otherwise>
            <span style="color: #666;">Regular</span>
        </c:otherwise>
    </c:choose>
</td> --%>
                                
                                
                                
                                
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <c:if test="${empty channels}">
                    <div style="text-align: center; padding: 40px; color: #666;">
                        No channels found.
                    </div>
                </c:if>
            </div>
            
            <!-- Videos Section -->
            <div id="videos-section" class="content-section ${currentSection == 'videos' ? 'active' : ''}">
                <div class="search-bar">
                    <input type="text" id="videoSearch" placeholder="Search videos by title or channel name..." 
                           value="${param.videoSearch}">
                </div>
                
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Channel</th>
                            <th>Views</th>
                            <th>Visibility</th>
                            <th>Type</th>
                            <th>Copyright</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${videos}" var="video">
                            <tr>
                                <td>${video.id}</td>
                                <td>
                                    <strong>${video.videoTitle}</strong>
                                    <br><small>
                                        <c:choose>
                                            <c:when test="${not empty video.videoDescription}">
                                                <c:set var="desc" value="${video.videoDescription}" />
                                                <c:choose>
                                                    <c:when test="${fn:length(desc) > 50}">
                                                        ${fn:substring(desc, 0, 50)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${desc}
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                No description
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </td>
                                <td>${video.channelName}</td>
                                <td>${video.formattedViews}</td>
                                <td>
                                    <span class="status-badge ${video.isPublic == '1' ? 'status-public' : 'status-private'}">
                                        ${video.isPublic == '1' ? 'Public' : 'Private'}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${video.videoType == 'short'}">
                                            <span style="color: #ff0000; font-weight: bold;">Short</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>Regular</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${video.copyrightStatus == 'claim'}">
                                            <span style="color: orange; font-weight: bold;">⚠️ Claim</span>
                                        </c:when>
                                        <c:when test="${video.copyrightStatus == 'strike'}">
                                            <span style="color: red; font-weight: bold;">⛔ Strike</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: green;">✅ None</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="video?id=${video.id}" class="btn btn-view" target="_blank">Watch</a>
                                        <form action="adminAction" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="toggleVideoVisibility">
                                            <input type="hidden" name="videoId" value="${video.id}">
                                            <button type="submit" class="btn btn-toggle">
                                                ${video.isPublic == '1' ? 'Make Private' : 'Make Public'}
                                            </button>
                                        </form>
                                        <form action="adminAction" method="post" style="display:inline;" 
                                              onsubmit="return confirm('Are you sure you want to delete this video?');">
                                            <input type="hidden" name="action" value="deleteVideo">
                                            <input type="hidden" name="videoId" value="${video.id}">
                                            <button type="submit" class="btn btn-delete">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <c:if test="${empty videos}">
                    <div style="text-align: center; padding: 40px; color: #666;">
                        No videos found.
                    </div>
                </c:if>
            </div>
            
            <!-- Sponsor Videos Section -->
            <div id="sponsorVideos-section" class="content-section ${currentSection == 'sponsorVideos' ? 'active' : ''}">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h3>Sponsor Videos Management</h3>
                    <button id="addSponsorVideoBtn" style="padding: 10px 20px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;">
                        ＋ Add Sponsor Video
                    </button>
                </div>
                
                <!-- Add Sponsor Video Form (initially hidden) -->
                <div id="addSponsorVideoForm" style="display: none; background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; margin-bottom: 20px;">
                    <h4 style="margin-bottom: 15px;">Upload New Sponsor Video</h4>
                    <form action="uploadSponsorVideo" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label>Title *</label>
                            <input type="text" name="title" required>
                        </div>
                        
                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="description"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label>Video File *</label>
                            <input type="file" name="videoFile" accept="video/*" required>
                        </div>
                        
                        <div class="form-group">
                            <label>Thumbnail (optional)</label>
                            <input type="file" name="thumbnail" accept="image/*">
                        </div>
                        
                        <div class="form-group">
                            <label style="display: flex; align-items: center; gap: 10px;">
                                <input type="checkbox" name="isActive" value="1" checked>
                                <span>Active (visible to channels)</span>
                            </label>
                        </div>
                        
                        <div style="display: flex; gap: 10px;">
                            <button type="submit" style="padding: 10px 20px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;">
                                Upload Video
                            </button>
                            <button type="button" id="cancelSponsorVideoBtn" style="padding: 10px 20px; background: #f44336; color: white; border: none; border-radius: 4px; cursor: pointer;">
                                Cancel
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- Sponsor Videos List -->
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Thumbnail</th>
                            <th>Duration</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${sponsorVideos}" var="sponsorVideo">
                            <tr>
                                <td>${sponsorVideo.id}</td>
                                <td>
                                    <strong>${sponsorVideo.title}</strong>
                                    <br><small>
                                        <c:choose>
                                            <c:when test="${not empty sponsorVideo.description}">
                                                <c:set var="desc" value="${sponsorVideo.description}" />
                                                <c:choose>
                                                    <c:when test="${fn:length(desc) > 50}">
                                                        ${fn:substring(desc, 0, 50)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${desc}
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                No description
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </td>
                                <td>
                                    <c:if test="${not empty sponsorVideo.thumbnail}">
                                        <img src="${pageContext.request.contextPath}/${sponsorVideo.thumbnail}" 
                                             alt="${sponsorVideo.title}" style="width: 80px; height: 45px; object-fit: cover; border-radius: 4px;">
                                    </c:if>
                                    <c:if test="${empty sponsorVideo.thumbnail}">
                                        <div style="width: 80px; height: 45px; background: #ddd; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: #666;">
                                            No Image
                                        </div>
                                    </c:if>
                                </td>
                                <td>${sponsorVideo.duration}s</td>
                                <td>
                                    <span class="status-badge ${sponsorVideo.isActive == '1' ? 'status-active' : 'status-inactive'}">
                                        ${sponsorVideo.isActive == '1' ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${not empty sponsorVideo.createdAt}">
                                        ${fn:substring(sponsorVideo.createdAt.toString(), 0, 10)}
                                    </c:if>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/${sponsorVideo.videoUrl}" 
                                           class="btn btn-view" target="_blank">Watch</a>
                                        <form action="deleteSponsorVideo" method="post" style="display:inline;" 
                                              onsubmit="return confirm('Delete this sponsor video?');">
                                            <input type="hidden" name="id" value="${sponsorVideo.id}">
                                            <button type="submit" class="btn btn-delete">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <c:if test="${empty sponsorVideos}">
                    <div style="text-align: center; padding: 40px; color: #666;">
                        No sponsor videos found. Click "Add Sponsor Video" to upload one.
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
        // Mobile menu toggle
        document.getElementById('mobileMenuBtn').addEventListener('click', function() {
            document.getElementById('adminSidebar').classList.toggle('active');
        });
        
     // Sidebar navigation - Only for section navigation links, not logout
        document.querySelectorAll('.sidebar-link[data-section]').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const section = this.getAttribute('data-section');
                
                // Remove active class from all links
                document.querySelectorAll('.sidebar-link').forEach(l => l.classList.remove('active'));
                // Add active class to clicked link
                this.classList.add('active');
                
                // Hide all sections
                document.querySelectorAll('.content-section').forEach(s => s.classList.remove('active'));
                // Show selected section
                document.getElementById(section + '-section').classList.add('active');
                
                // Close mobile menu on mobile
                if (window.innerWidth <= 768) {
                    document.getElementById('adminSidebar').classList.remove('active');
                }
                
                // Update URL without reloading page
                history.pushState({}, '', 'adminDashboard?section=' + section);
            });
        });
        
        
        
        // Theme switching
        document.querySelectorAll('.theme-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const theme = this.getAttribute('data-theme');
                
                // Remove active class from all buttons
                document.querySelectorAll('.theme-btn').forEach(b => b.classList.remove('active'));
                // Add active class to clicked button
                this.classList.add('active');
                
                // Remove all theme classes
                document.body.classList.remove('day-theme', 'dark-theme', 'gold-theme');
                // Add selected theme
                document.body.classList.add(theme + '-theme');
                
                // Save theme preference via AJAX
                fetch('adminAction', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=changeTheme&theme=' + theme
                }).catch(err => console.error('Theme save error:', err));
            });
        });
        
        // Channel search functionality
        const channelSearchInput = document.getElementById('channelSearch');
        if (channelSearchInput) {
            channelSearchInput.addEventListener('input', function(e) {
                const searchTerm = e.target.value.toLowerCase();
                const rows = document.querySelectorAll('#channels-section tbody tr');
                
                rows.forEach(row => {
                    const displayName = row.cells[1]?.textContent.toLowerCase() || '';
                    const email = row.cells[2]?.textContent.toLowerCase() || '';
                    const text = displayName + ' ' + email;
                    row.style.display = text.includes(searchTerm) ? '' : 'none';
                });
            });
        }
        
        // Video search functionality
        const videoSearchInput = document.getElementById('videoSearch');
        if (videoSearchInput) {
            videoSearchInput.addEventListener('input', function(e) {
                const searchTerm = e.target.value.toLowerCase();
                const rows = document.querySelectorAll('#videos-section tbody tr');
                
                rows.forEach(row => {
                    const title = row.cells[1]?.textContent.toLowerCase() || '';
                    const channel = row.cells[2]?.textContent.toLowerCase() || '';
                    const text = title + ' ' + channel;
                    row.style.display = text.includes(searchTerm) ? '' : 'none';
                });
            });
        }
        
        // Sponsor video form toggle
        const addSponsorVideoBtn = document.getElementById('addSponsorVideoBtn');
        const cancelSponsorVideoBtn = document.getElementById('cancelSponsorVideoBtn');
        const sponsorVideoForm = document.getElementById('addSponsorVideoForm');
        
        if (addSponsorVideoBtn) {
            addSponsorVideoBtn.addEventListener('click', function() {
                sponsorVideoForm.style.display = 'block';
            });
        }
        
        if (cancelSponsorVideoBtn) {
            cancelSponsorVideoBtn.addEventListener('click', function() {
                sponsorVideoForm.style.display = 'none';
            });
        }
        
        // Close forms when clicking outside
        document.addEventListener('click', function(e) {
            if (sponsorVideoForm && sponsorVideoForm.style.display === 'block') {
                if (!sponsorVideoForm.contains(e.target) && e.target !== addSponsorVideoBtn) {
                    sponsorVideoForm.style.display = 'none';
                }
            }
        });
        
        // Initialize based on URL parameter
        const urlParams = new URLSearchParams(window.location.search);
        const section = urlParams.get('section') || 'channels';
        
        // Activate correct section on page load
        window.addEventListener('DOMContentLoaded', () => {
            const sectionLink = document.querySelector(`[data-section="${section}"]`);
            if (sectionLink) {
                sectionLink.click();
            }
        });
        
        // Handle back/forward browser buttons
        window.addEventListener('popstate', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const section = urlParams.get('section') || 'channels';
            const sectionLink = document.querySelector(`[data-section="${section}"]`);
            if (sectionLink) {
                sectionLink.click();
            }
        });
    </script>
</body>
</html>