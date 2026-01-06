<!-- header.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header style="background: #fff; border-bottom: 1px solid #e0e0e0; padding: 10px 20px; display: flex; justify-content: space-between; align-items: center; position: relative; z-index: 100;">
    <div style="font-size: 24px; font-weight: bold; color: #ff0000;">
        <a href="home" style="text-decoration: none; color: inherit;">YouTube Clone</a>
    </div>

    <!-- Search Bar and Filter Button -->
    <div style="flex: 1; max-width: 600px; margin: 0 20px; display: flex; align-items: center; gap: 10px;">
        <form action="search" method="get" style="display: flex; flex: 1;" id="searchForm">
            <input type="text" name="query" placeholder="Search videos..." 
                   value="${param.query != null ? param.query : ''}"
                   style="flex: 1; padding: 8px 12px; border: 1px solid #ccc; border-radius: 20px 0 0 20px; font-size: 16px;">
            <button type="submit" 
                    style="padding: 8px 20px; background: #f8f8f8; border: 1px solid #ccc; border-left: none; border-radius: 0 20px 20px 0; cursor: pointer;">
                🔍
            </button>
        </form>
        
        <!-- Filter Button (only visible on search results page) -->
        <c:if test="${isSearchPage}">
            <button id="filterBtn" type="button"
                    style="padding: 8px 15px; background: #f8f8f8; border: 1px solid #ccc; border-radius: 20px; cursor: pointer; display: flex; align-items: center; gap: 5px;">
                <span>Filter</span>
                <span style="font-size: 12px;">▼</span>
            </button>
        </c:if>
    </div>
    
    <div style="position: relative;">
        <c:choose>
            <c:when test="${not empty sessionScope.channel}">
                <!-- Logged in - show profile dropdown -->
                <div class="profile-dropdown">
                    <button class="profile-btn" type="button" 
                            style="background: none; border: none; cursor: pointer; display: flex; align-items: center; gap: 8px; padding: 5px; border-radius: 20px;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.channel.profilePicture}">
                                <img src="${pageContext.request.contextPath}/${sessionScope.channel.profilePicture}" 
                                     alt="${sessionScope.channel.displayName}" 
                                     style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <div style="width: 32px; height: 32px; border-radius: 50%; background: #ddd; display: flex; align-items: center; justify-content: center;">
                                    <span style="color: #666; font-size: 14px; font-weight: bold;">
                                        ${sessionScope.channel.displayName.charAt(0)}
                                    </span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <span style="font-weight: 500;">${sessionScope.channel.displayName}</span>
                        <span style="font-size: 12px;">▼</span>
                    </button>
        
                    <div id="profileDropdown" class="dropdown-content" 
                         style="display: none; position: absolute; right: 0; background: white; min-width: 200px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-radius: 8px; z-index: 1001; margin-top: 5px;">
                        <a href="editChannelProfile" 
                           style="display: block; padding: 12px 16px; text-decoration: none; color: #333; border-bottom: 1px solid #f0f0f0; transition: background 0.2s;"
                           onmouseover="this.style.background='#f5f5f5'"
                           onmouseout="this.style.background='white'">
                            Edit Profile
                        </a>
                        <a href="channelDashboard" 
                           style="display: block; padding: 12px 16px; text-decoration: none; color: #333; border-bottom: 1px solid #f0f0f0; transition: background 0.2s;"
                           onmouseover="this.style.background='#f5f5f5'"
                           onmouseout="this.style.background='white'">
                            Channel Dashboard
                        </a>
                        <a href="subscriptions" 
                           style="display: block; padding: 12px 16px; text-decoration: none; color: #333; border-bottom: 1px solid #f0f0f0; transition: background 0.2s;"
                           onmouseover="this.style.background='#f5f5f5'"
                           onmouseout="this.style.background='white'">
                            Subscriptions
                        </a>
                        <a href="mySubscribers" 
                           style="display: block; padding: 12px 16px; text-decoration: none; color: #333; border-bottom: 1px solid #f0f0f0; transition: background 0.2s;"
                           onmouseover="this.style.background='#f5f5f5'"
                           onmouseout="this.style.background='white'">
                            My Subscribers
                        </a>
                        <a href="playlists" 
                           style="display: block; padding: 12px 16px; text-decoration: none; color: #333; border-bottom: 1px solid #f0f0f0; transition: background 0.2s;"
                           onmouseover="this.style.background='#f5f5f5'"
                           onmouseout="this.style.background='white'">
                            Playlists
                        </a>
                        
                        <!-- In header.jsp, inside the dropdown-content div, add these before Logout: -->

<!-- Theme Submenu -->
<div style="position: relative;">
    <a href="#" id="themeToggle" 
       style="display: block; padding: 12px 16px; text-decoration: none; color: #333; border-bottom: 1px solid #f0f0f0; transition: background 0.2s;"
       onmouseover="this.style.background='#f5f5f5'"
       onmouseout="this.style.background='white'">
        🎨 Theme
        <span style="float: right; font-size: 12px;">▶</span>
    </a>
    
    <div id="themeMenu" style="display: none; position: absolute; right: 100%; top: 0; background: white; min-width: 150px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-radius: 4px; z-index: 1002;">
        <button class="theme-option" data-theme="light" 
                style="display: block; width: 100%; padding: 10px 16px; background: none; border: none; text-align: left; cursor: pointer; border-bottom: 1px solid #f0f0f0;"
                onmouseover="this.style.background='#f5f5f5'"
                onmouseout="this.style.background='white'">
            ☀️ Light
        </button>
        <button class="theme-option" data-theme="dark" 
                style="display: block; width: 100%; padding: 10px 16px; background: none; border: none; text-align: left; cursor: pointer; border-bottom: 1px solid #f0f0f0;"
                onmouseover="this.style.background='#f5f5f5'"
                onmouseout="this.style.background='white'">
            🌙 Dark
        </button>
        <button class="theme-option" data-theme="gold" 
                style="display: block; width: 100%; padding: 10px 16px; background: none; border: none; text-align: left; cursor: pointer;"
                onmouseover="this.style.background='#f5f5f5'"
                onmouseout="this.style.background='white'"
                ${channel.isPremium == '1' ? '' : 'disabled style="color: #ccc; cursor: not-allowed;"'}>
            ${channel.isPremium == '1' ? '👑 Gold' : '🔒 Gold (Premium)'}
        </button>
    </div>
</div>

<!-- Upgrade Option -->
<a href="#" id="upgradeLink" 
   style="display: block; padding: 12px 16px; text-decoration: none; color: #333; border-bottom: 1px solid #f0f0f0; transition: background 0.2s;"
   onmouseover="this.style.background='#f5f5f5'"
   onmouseout="this.style.background='white'">
    ${channel.isPremium == '1' ? '👑 Premium Member' : '⭐ Upgrade to Premium'}
</a>

<!-- Upgrade Modal -->
<div id="upgradeModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1003; align-items: center; justify-content: center;">
    <div style="background: white; border-radius: 12px; width: 90%; max-width: 400px; padding: 25px; text-align: center;">
        <div style="font-size: 48px; margin-bottom: 15px;">⭐</div>
        <h2 style="margin: 0 0 15px 0;">Upgrade to Premium</h2>
        <p style="color: #666; margin-bottom: 20px; line-height: 1.5;">
            Get exclusive features including Gold theme and video downloads!
        </p>
        
        <div style="text-align: left; margin-bottom: 25px; padding: 15px; background: #f8f9fa; border-radius: 8px;">
            <p style="margin: 0 0 10px 0;"><strong>🎨 Gold Theme</strong> - Exclusive golden UI</p>
            <p style="margin: 0 0 10px 0;"><strong>⬇️ Video Downloads</strong> - Download any video</p>
            <p style="margin: 0;"><strong>👑 Premium Badge</strong> - Special recognition</p>
        </div>
        
        <p style="color: #666; font-size: 14px; margin-bottom: 25px;">
            Watch a short sponsor video to unlock premium features for free!
        </p>
        
        <div style="display: flex; gap: 15px; justify-content: center;">
            <button id="cancelUpgrade" 
                    style="padding: 10px 25px; background: #f8f8f8; border: 1px solid #ccc; border-radius: 6px; cursor: pointer; font-weight: 500;">
                Not Now
            </button>
            <button id="confirmUpgrade" 
                    style="padding: 10px 25px; background: #4CAF50; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold;">
                Yes, Upgrade!
            </button>
        </div>
    </div>
</div>                        
                        
                        <a href="logout" 
                           style="display: block; padding: 12px 16px; text-decoration: none; color: #333; transition: background 0.2s;"
                           onmouseover="this.style.background='#f5f5f5'"
                           onmouseout="this.style.background='white'">
                            Logout
                        </a>
                    </div> 
                </div>
            </c:when>
            <c:otherwise>
                <!-- Not logged in - show login/register links -->
                <div>
                    <a href="login.jsp" 
                       style="margin-right: 15px; text-decoration: none; color: #065fd4; font-weight: 500; padding: 8px 12px; border-radius: 4px;"
                       onmouseover="this.style.background='#f0f0f0'"
                       onmouseout="this.style.background='transparent'">
                        Login
                    </a>
                    <a href="register.jsp" 
                       style="margin-right: 15px; text-decoration: none; color: #065fd4; font-weight: 500; padding: 8px 12px; border-radius: 4px;"
                       onmouseover="this.style.background='#f0f0f0'"
                       onmouseout="this.style.background='transparent'">
                        Create Channel
                    </a>
                    <a href="adminLogin.jsp" 
                       style="text-decoration: none; color: #ff0000; font-weight: bold; padding: 8px 12px; border-radius: 4px;"
                       onmouseover="this.style.background='#ffe6e6'"
                       onmouseout="this.style.background='transparent'">
                        Admin
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<!-- Filter Modal -->
<div id="filterModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1002; align-items: center; justify-content: center;">
    <div style="background: white; border-radius: 12px; width: 90%; max-width: 500px; max-height: 80vh; overflow-y: auto;">
        <div style="padding: 20px; border-bottom: 1px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center;">
            <h2 style="margin: 0; font-size: 20px;">Search filters</h2>
            <button type="button" id="closeFilterModal" 
                    style="background: none; border: none; font-size: 20px; cursor: pointer; color: #666;">
                ×
            </button>
        </div>
        
        <form id="filterForm" action="search" method="get" style="padding: 20px;">
            <!-- Keep the search query -->
            <input type="hidden" name="query" value="${param.query}">
            
            <!-- Upload Date -->
            <div style="margin-bottom: 25px;">
                <h3 style="margin-bottom: 10px; font-size: 16px; font-weight: bold;">Upload date</h3>
                <div style="display: flex; flex-direction: column; gap: 8px;">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="uploadDate" value="any" ${empty param.uploadDate or param.uploadDate eq 'any' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>Any time</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="uploadDate" value="hour" ${param.uploadDate eq 'hour' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>Last hour</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="uploadDate" value="today" ${param.uploadDate eq 'today' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>Today</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="uploadDate" value="week" ${param.uploadDate eq 'week' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>This week</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="uploadDate" value="month" ${param.uploadDate eq 'month' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>This month</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="uploadDate" value="year" ${param.uploadDate eq 'year' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>This year</span>
                    </label>
                </div>
            </div>
            
            <!-- Type -->
            <div style="margin-bottom: 25px;">
                <h3 style="margin-bottom: 10px; font-size: 16px; font-weight: bold;">Type</h3>
                <div style="display: flex; flex-direction: column; gap: 8px;">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="type" value="all" 
                               ${empty param.type or param.type eq 'all' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>All</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="type" value="video" 
                               ${param.type eq 'video' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>Video</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="type" value="channel" 
                               ${param.type eq 'channel' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>Channel</span>
                    </label>
                </div>
            </div>
            
            <!-- Sort by -->
            <div style="margin-bottom: 25px;">
                <h3 style="margin-bottom: 10px; font-size: 16px; font-weight: bold;">Sort by</h3>
                <div style="display: flex; flex-direction: column; gap: 8px;">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="sortBy" value="relevance" ${empty param.sortBy or param.sortBy eq 'relevance' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>Relevance</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="sortBy" value="uploadDate" ${param.sortBy eq 'uploadDate' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>Upload date</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; padding: 5px 0;">
                        <input type="radio" name="sortBy" value="viewCount" ${param.sortBy eq 'viewCount' ? 'checked' : ''} 
                               style="margin: 0; width: 16px; height: 16px;">
                        <span>View count</span>
                    </label>
                </div>
            </div>
            
            <!-- Modal Footer -->
            <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; padding-top: 20px; border-top: 1px solid #e0e0e0;">
                <button type="button" id="cancelFilter" 
                        style="padding: 10px 20px; background: #f8f8f8; border: 1px solid #ccc; border-radius: 4px; cursor: pointer; font-weight: 500;">
                    Cancel
                </button>
                <button type="submit" 
                        style="padding: 10px 20px; background: #065fd4; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: 500;">
                    Apply filters
                </button>
            </div>
        </form>
    </div>
</div>


<!-- Premium Status Badge with Timer -->
<c:if test="${sessionScope.channel != null && sessionScope.channel.isPremium == '1'}">
    <div id="premiumTimer" style="display: block; padding: 8px 16px; background: linear-gradient(45deg, #FFD700, #FFC107); color: #333; border-radius: 4px; margin: 10px 0; font-size: 14px; font-weight: bold;">
        <div style="display: flex; align-items: center; gap: 10px;">
            <span>👑 Premium Member</span>
            <span id="timerText" style="font-size: 12px; color: #5c4033;">Loading...</span>
        </div>
    </div>
    
    <script>
    // Premium expiration timer
    function updatePremiumTimer() {
        <c:if test="${sessionScope.channel != null && sessionScope.channel.isPremium == '1' && sessionScope.channel.premiumSince != null}">
            fetch('getPremiumRemainingTime')
                .then(response => response.text())
                .then(data => {
                    const timerText = document.getElementById('timerText');
                    if (timerText) {
                        if (data === 'Expired') {
                            timerText.innerHTML = 'Expired - <a href="upgrade" style="color: #4CAF50;">Renew</a>';
                            // Refresh page to update premium status
                            setTimeout(() => location.reload(), 5000);
                        } else {
                            timerText.innerHTML = `Remaining: ${data}`;
                        }
                    }
                })
                .catch(error => {
                    console.error('Error fetching premium timer:', error);
                });
        </c:if>
    }
    
    // Update timer on page load
    document.addEventListener('DOMContentLoaded', function() {
        updatePremiumTimer();
        // Update every minute
        setInterval(updatePremiumTimer, 60000);
    });
    </script>
</c:if>
    
    
<script>
// Make sure the DOM is fully loaded before attaching event listeners
document.addEventListener('DOMContentLoaded', function() {
    
    // ========== PROFILE DROPDOWN FUNCTIONALITY ==========
    const profileBtn = document.querySelector('.profile-btn');
    const profileDropdown = document.getElementById('profileDropdown');
    
    if (profileBtn && profileDropdown) {
        // Toggle profile dropdown
        profileBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            // Close filter modal if open
            closeFilterModal();
            // Toggle profile dropdown
            profileDropdown.style.display = 
                profileDropdown.style.display === 'block' ? 'none' : 'block';
        });
        
        // Close profile dropdown when clicking on a link
        profileDropdown.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', function() {
                profileDropdown.style.display = 'none';
            });
        });
    }
    
    // Close profile dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (profileDropdown && !e.target.closest('.profile-dropdown')) {
            profileDropdown.style.display = 'none';
        }
    });
    
    // Close profile dropdown with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && profileDropdown && profileDropdown.style.display === 'block') {
            profileDropdown.style.display = 'none';
        }
    });
    
    // ========== THEME FUNCTIONALITY ==========
    const themeToggle = document.getElementById('themeToggle');
    const themeMenu = document.getElementById('themeMenu');
        
    if (themeToggle && themeMenu) {
        themeToggle.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            themeMenu.style.display = themeMenu.style.display === 'block' ? 'none' : 'block';
        });
        
        // Close theme menu when clicking outside
        document.addEventListener('click', function(e) {
            if (!e.target.closest('#themeToggle') && !e.target.closest('#themeMenu')) {
                themeMenu.style.display = 'none';
            }
        });
        
        // Theme selection
        document.querySelectorAll('.theme-option').forEach(btn => {
            btn.addEventListener('click', function() {
                const theme = this.getAttribute('data-theme');
                
                // Check if gold theme is locked
                if (theme === 'gold' && this.disabled) {
                    showUpgradeModal();
                    return;
                }
                
                changeTheme(theme);
                themeMenu.style.display = 'none';
            });
        });
    }
    
    // ========== UPGRADE FUNCTIONALITY ==========
    const upgradeLink = document.getElementById('upgradeLink');
    const upgradeModal = document.getElementById('upgradeModal');
    const cancelUpgrade = document.getElementById('cancelUpgrade');
    const confirmUpgrade = document.getElementById('confirmUpgrade');
    
    if (upgradeLink) {
        upgradeLink.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Check if already premium
            const isPremium = '${channel.isPremium}' === '1';
            if (isPremium) {
                alert('👑 You are already a Premium member!');
                return;
            }
            
            showUpgradeModal();
        });
    }
    
    if (cancelUpgrade) {
        cancelUpgrade.addEventListener('click', function() {
            upgradeModal.style.display = 'none';
        });
    }
    
    if (confirmUpgrade) {
        confirmUpgrade.addEventListener('click', function() {
            upgradeModal.style.display = 'none';
            // Redirect to upgrade page which should show sponsor video
            window.location.href = 'upgrade';
        });
    }
    
    // Close upgrade modal when clicking outside
    if (upgradeModal) {
        upgradeModal.addEventListener('click', function(e) {
            if (e.target === upgradeModal) {
                upgradeModal.style.display = 'none';
            }
        });
    }
    
    // Apply current theme on page load
    applyTheme();
    
    // ========== FILTER MODAL FUNCTIONALITY ==========
    const filterBtn = document.getElementById('filterBtn');
    const filterModal = document.getElementById('filterModal');
    const cancelFilter = document.getElementById('cancelFilter');
    const closeFilterModalBtn = document.getElementById('closeFilterModal');
    
    // Open filter modal
    if (filterBtn && filterModal) {
        filterBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            // Close profile dropdown if open
            if (profileDropdown) {
                profileDropdown.style.display = 'none';
            }
            // Open filter modal
            filterModal.style.display = 'flex';
        });
    }
    
    // Close filter modal functions
    function closeFilterModal() {
        if (filterModal) {
            filterModal.style.display = 'none';
        }
    }
    
    // Close modal with Cancel button
    if (cancelFilter) {
        cancelFilter.addEventListener('click', closeFilterModal);
    }
    
    // Close modal with X button
    if (closeFilterModalBtn) {
        closeFilterModalBtn.addEventListener('click', closeFilterModal);
    }
    
    // Close filter modal when clicking outside
    if (filterModal) {
        filterModal.addEventListener('click', function(e) {
            if (e.target === filterModal) {
                closeFilterModal();
            }
        });
    }
    
    // Close filter modal with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && filterModal && filterModal.style.display === 'flex') {
            closeFilterModal();
        }
    });
    
    // Prevent form submission from closing modal
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        filterForm.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    }
    
    // ========== SEARCH FORM ENHANCEMENT ==========
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        // Focus search input when '/' key is pressed (like YouTube)
        document.addEventListener('keydown', function(e) {
            if (e.key === '/' && e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                e.preventDefault();
                const searchInput = searchForm.querySelector('input[name="query"]');
                if (searchInput) {
                    searchInput.focus();
                }
            }
        });
        
        // Clear search when clicking on logo
        const logoLink = document.querySelector('header a[href="home"]');
        if (logoLink) {
            logoLink.addEventListener('click', function() {
                const searchInput = searchForm.querySelector('input[name="query"]');
                if (searchInput) {
                    searchInput.value = '';
                }
            });
        }
    }
});

// ========== GLOBAL FUNCTIONS ==========
function showUpgradeModal() {
    const upgradeModal = document.getElementById('upgradeModal');
    if (upgradeModal) {
        // Close any other open dropdowns
        closeAllDropdowns();
        upgradeModal.style.display = 'flex';
    }
}

function changeTheme(theme) {
    // Save theme preference via AJAX
    fetch('changeTheme', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'theme=' + theme
    })
    .then(response => {
        if (response.ok) {
            applyTheme(theme);
        } else {
            response.text().then(message => {
                if (response.status === 403) {
                    showUpgradeModal();
                } else {
                    alert('Error: ' + message);
                }
            });
        }
    })
    .catch(error => {
        console.error('Error changing theme:', error);
    });
}


function applyTheme(theme) {
    // If theme parameter is provided, use it, otherwise get from session
    if (!theme) {
        theme = '${channel.themePreference}' || 'light';
    }
    
    // IMPORTANT: Check if user can access gold theme
    var isPremium = '${channel.isPremium}' === '1';
    var isLoggedIn = '${channel}' !== '';
    
    // Force light theme for guests or non-premium users trying to use gold theme
    if (!isLoggedIn && theme === 'gold') {
        theme = 'light';  // Guests cannot use gold theme
        console.log("Guest detected, forcing light theme instead of gold");
    } else if (isLoggedIn && theme === 'gold' && !isPremium) {
        theme = 'light';  // Non-premium users cannot use gold theme
        console.log("Non-premium user trying to use gold theme, forcing light theme");
    }
    
    
    // Remove existing theme classes
  //  document.body.classList.remove('light-theme', 'dark-theme', 'gold-theme');
    
    // Apply new theme
  //  document.body.classList.add(theme + '-theme');
    
        // Remove existing theme classes
    document.body.classList.remove('light-theme', 'dark-theme', 'gold-theme');
    
    // Apply new theme
    document.body.classList.add(theme + '-theme');
    
    // Also update the body tag with theme class for CSS
    document.body.setAttribute('data-theme', theme);
    
    
    
    // Add CSS for themes if not already added
    if (!document.getElementById('themeStyles')) {
        const style = document.createElement('style');
        style.id = 'themeStyles';
        style.textContent = `
            .light-theme {
                --bg-color: #ffffff;
                --text-color: #333333;
                --header-bg: #ffffff;
                --card-bg: #ffffff;
                --border-color: #e0e0e0;
                --primary-color: #ff0000;
            }
            
            .dark-theme {
                --bg-color: #121212;
                --text-color: #ffffff;
                --header-bg: #1f1f1f;
                --card-bg: #1e1e1e;
                --border-color: #333333;
                --primary-color: #ff0000;
            }
            
            .gold-theme {
                --bg-color: #fffaf0;
                --text-color: #5c4033;
                --header-bg: #f5e6c8;
                --card-bg: #fff8e1;
                --border-color: #d4af37;
                --primary-color: #d4af37;
            }
            
            body {
                background-color: var(--bg-color);
                color: var(--text-color);
                transition: background-color 0.3s, color 0.3s;
            }
            
            header {
                background: var(--header-bg) !important;
                border-bottom-color: var(--border-color) !important;
                transition: background 0.3s, border-color 0.3s;
            }
        `;
        document.head.appendChild(style);
    }
}

function closeAllDropdowns() {
    // Close profile dropdown
    const profileDropdown = document.getElementById('profileDropdown');
    if (profileDropdown) {
        profileDropdown.style.display = 'none';
    }
    
    // Close theme menu
    const themeMenu = document.getElementById('themeMenu');
    if (themeMenu) {
        themeMenu.style.display = 'none';
    }
    
    // Close filter modal
    const filterModal = document.getElementById('filterModal');
    if (filterModal) {
        filterModal.style.display = 'none';
    }
}

// Additional helper function to handle page transitions
function handleNavigation() {
    // Close any open dropdowns/modals when navigating
    const profileDropdown = document.getElementById('profileDropdown');
    const filterModal = document.getElementById('filterModal');
    
    if (profileDropdown) {
        profileDropdown.style.display = 'none';
    }
    
    if (filterModal) {
        filterModal.style.display = 'none';
    }
}

// Add navigation handling to all links (except those with special handling)
document.addEventListener('click', function(e) {
    if (e.target.tagName === 'A' && !e.target.classList.contains('no-nav-handle')) {
        // Add a small delay to allow the navigation to start
        setTimeout(handleNavigation, 50);
    }
});
</script>
