<!-- watchSponsorVideo.jsp file: -->

<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Watch Sponsor Video - Upgrade to Premium</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .sponsor-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            max-width: 800px;
            width: 100%;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
        }
        .sponsor-header {
            margin-bottom: 20px;
        }
        .sponsor-header h1 {
            color: #333;
            margin-bottom: 10px;
        }
        .sponsor-header p {
            color: #666;
            font-size: 16px;
        }
        .premium-benefits {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            text-align: left;
        }
        .premium-benefits h3 {
            color: #333;
            margin-top: 0;
            margin-bottom: 15px;
        }
        .benefit-list {
            list-style: none;
            padding: 0;
        }
        .benefit-list li {
            padding: 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .benefit-list li::before {
            content: "✓";
            color: #4CAF50;
            font-weight: bold;
        }
        .sponsor-video-container {
            margin-bottom: 25px;
        }
        .sponsor-video-container video {
            width: 100%;
            max-height: 400px;
            border-radius: 8px;
            background: #000;
        }
        .upgrade-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        .btn-primary:hover {
            background: #45a049;
        }
        .btn-secondary {
            background: #f8f8f8;
            color: #333;
            border: 1px solid #ddd;
        }
        .btn-secondary:hover {
            background: #e9e9e9;
        }
        .video-info {
            text-align: left;
            margin-top: 15px;
            padding: 15px;
            background: #f9f9f9;
            border-radius: 6px;
        }
        .video-info h3 {
            margin-top: 0;
            color: #333;
        }
        .locked-feature {
            color: #ff9800;
            font-weight: bold;
        }
        .unlocked-feature {
            color: #4CAF50;
            font-weight: bold;
        }
        .watch-progress {
            margin-top: 15px;
            font-size: 14px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="sponsor-container">
        <div class="sponsor-header">
            <h1>🎬 Watch a Sponsor Video</h1>
            <p>Watch this sponsor video to unlock Premium features!</p>
        </div>
        
        <div class="premium-benefits">
            <h3>✨ Premium Benefits You'll Unlock:</h3>
            <ul class="benefit-list">
                <li>🎨 <strong>Gold Theme</strong> - Exclusive golden UI theme</li>
                <li>⬇️ <strong>Video Downloads</strong> - Download any video for offline viewing</li>
                <li>🚀 <strong>Ad-Free Experience</strong> - No interruptions while watching</li>
                <li>👑 <strong>Premium Badge</strong> - Special badge on your channel</li>
            </ul>
        </div>
        
        <div class="sponsor-video-container">
            <video id="sponsorVideo" controls>
                <source src="${pageContext.request.contextPath}/${sponsorVideo.videoUrl}" type="video/mp4">
                Your browser does not support the video tag.
            </video>
            
            <div class="video-info">
                <h3>${sponsorVideo.title}</h3>
                <p>${sponsorVideo.description}</p>
                <div class="watch-progress">
                    <span id="progressText">Please watch the entire video to unlock premium</span>
                    <div id="progressBar" style="width: 100%; height: 4px; background: #ddd; margin-top: 5px;">
                        <div id="progressFill" style="width: 0%; height: 100%; background: #4CAF50;"></div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="upgrade-actions">
            <button id="completeUpgradeBtn" class="btn btn-primary" disabled>
                ⭐ Unlock Premium Features
            </button>
            <button id="skipBtn" class="btn btn-secondary">
                Skip for Now
            </button>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const video = document.getElementById('sponsorVideo');
            const completeBtn = document.getElementById('completeUpgradeBtn');
            const skipBtn = document.getElementById('skipBtn');
            const progressFill = document.getElementById('progressFill');
            const progressText = document.getElementById('progressText');
            
            let hasWatchedEnough = false;
            
            // Track video progress
            video.addEventListener('timeupdate', function() {
                const progress = (video.currentTime / video.duration) * 100;
                progressFill.style.width = progress + '%';
                
                // Enable upgrade button after watching 95% of the video
                if (progress >= 95 && !hasWatchedEnough) {
                    hasWatchedEnough = true;
                    completeBtn.disabled = false;
                    progressText.textContent = "✓ Video watched! Ready to unlock premium";
                    progressFill.style.background = '#4CAF50';
                }
            });
            
            // Complete upgrade
            completeBtn.addEventListener('click', function() {
                if (!hasWatchedEnough) return;
                
                completeBtn.disabled = true;
                completeBtn.innerHTML = 'Processing...';
                
                fetch('upgrade', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=completeUpgrade&sponsorVideoId=${sponsorVideo.id}'
                })
                .then(response => response.text())
                .then(message => {
                    alert('🎉 Congratulations! You are now a Premium member!');
                    window.location.href = 'home';
                })
                .catch(error => {
                    alert('Error: ' + error);
                    completeBtn.disabled = false;
                    completeBtn.innerHTML = '⭐ Unlock Premium Features';
                });
            });
            
            // Skip upgrade
            skipBtn.addEventListener('click', function() {
                if (confirm('Are you sure you want to skip premium upgrade? You will miss out on exclusive features.')) {
                    fetch('upgrade', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=skip'
                    })
                    .then(() => {
                        window.location.href = 'home';
                    });
                }
            });
            
            // Handle video ended
            video.addEventListener('ended', function() {
                hasWatchedEnough = true;
                completeBtn.disabled = false;
                progressText.textContent = "✓ Video completed! Ready to unlock premium";
                progressFill.style.width = '100%';
                progressFill.style.background = '#4CAF50';
            });
        });
    </script>
</body>
</html> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Watch Sponsor Video - Upgrade to Premium</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .sponsor-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            max-width: 800px;
            width: 100%;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
        }
        .premium-benefits {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            text-align: left;
        }
        .sponsor-video-container {
            margin-bottom: 25px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        .btn-secondary {
            background: #f8f8f8;
            color: #333;
            border: 1px solid #ddd;
        }
        .video-info {
            text-align: left;
            margin-top: 15px;
            padding: 15px;
            background: #f9f9f9;
            border-radius: 6px;
        }
        .watch-progress {
            margin-top: 15px;
            font-size: 14px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="sponsor-container">
        <div class="sponsor-header">
            <h1>🎬 Watch a Sponsor Video</h1>
            <p>Watch this sponsor video to unlock Premium features!</p>
        </div>
        
        <div class="premium-benefits">
            <h3>✨ Premium Benefits You'll Unlock:</h3>
            <ul style="list-style: none; padding: 0;">
                <li style="padding: 8px 0; display: flex; align-items: center; gap: 10px;">✓ <strong>Gold Theme</strong> - Exclusive golden UI theme</li>
                <li style="padding: 8px 0; display: flex; align-items: center; gap: 10px;">✓ <strong>Video Downloads</strong> - Download any video for offline viewing</li>
                <li style="padding: 8px 0; display: flex; align-items: center; gap: 10px;">✓ <strong>Premium Badge</strong> - Special badge on your channel</li>
            </ul>
        </div>
        
        <div class="sponsor-video-container">
            <video id="sponsorVideo" controls style="width: 100%; max-height: 400px; border-radius: 8px; background: #000;">
                <source src="${pageContext.request.contextPath}/${sponsorVideo.videoUrl}" type="video/mp4">
                Your browser does not support the video tag.
            </video>
            
            <div class="video-info">
                <h3 style="margin-top: 0;">${sponsorVideo.title}</h3>
                <p>${sponsorVideo.description}</p>
                <div class="watch-progress">
                    <span id="progressText">Please watch the entire video to unlock premium</span>
                    <div id="progressBar" style="width: 100%; height: 4px; background: #ddd; margin-top: 5px;">
                        <div id="progressFill" style="width: 0%; height: 100%; background: #4CAF50;"></div>
                    </div>
                </div>
            </div>
        </div>
        
        <div style="display: flex; gap: 15px; justify-content: center;">
            <button id="completeUpgradeBtn" class="btn btn-primary" disabled>
                ⭐ Unlock Premium Features
            </button>
            <button id="skipBtn" class="btn btn-secondary">
                Skip for Now
            </button>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const video = document.getElementById('sponsorVideo');
            const completeBtn = document.getElementById('completeUpgradeBtn');
            const skipBtn = document.getElementById('skipBtn');
            const progressFill = document.getElementById('progressFill');
            const progressText = document.getElementById('progressText');
            
            let hasWatchedEnough = false;
            
            // Track video progress
            video.addEventListener('timeupdate', function() {
                const progress = (video.currentTime / video.duration) * 100;
                progressFill.style.width = progress + '%';
                
                // Enable upgrade button after watching 95% of the video
                if (progress >= 95 && !hasWatchedEnough) {
                    hasWatchedEnough = true;
                    completeBtn.disabled = false;
                    progressText.textContent = "✓ Video watched! Ready to unlock premium";
                    progressFill.style.background = '#4CAF50';
                }
            });
            
            // Complete upgrade
            completeBtn.addEventListener('click', function() {
                if (!hasWatchedEnough) return;
                
                completeBtn.disabled = true;
                completeBtn.innerHTML = 'Processing...';
                
                // Use form submission instead of fetch
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'upgrade';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'completeUpgrade';
                form.appendChild(actionInput);
                
                const videoIdInput = document.createElement('input');
                videoIdInput.type = 'hidden';
                videoIdInput.name = 'sponsorVideoId';
                videoIdInput.value = '${sponsorVideo.id}';
                form.appendChild(videoIdInput);
                
                document.body.appendChild(form);
                form.submit();
            });
            
            // Skip upgrade
            skipBtn.addEventListener('click', function() {
                if (confirm('Are you sure you want to skip premium upgrade? You will miss out on exclusive features.')) {
                    // Redirect to home
                    window.location.href = 'home';
                }
            });
            
            // Handle video ended
            video.addEventListener('ended', function() {
                hasWatchedEnough = true;
                completeBtn.disabled = false;
                progressText.textContent = "✓ Video completed! Ready to unlock premium";
                progressFill.style.width = '100%';
                progressFill.style.background = '#4CAF50';
            });
        });
    </script>
</body>
</html>