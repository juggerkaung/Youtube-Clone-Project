<!-- upgradeSuccess.jsp file: -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upgrade Successful - YouTube Clone</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Roboto', 'Arial', sans-serif;
        }
        
        body {
            background: #f9f9f9;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: linear-gradient(135deg, #fffaf0 0%, #f5e6c8 100%);
        }
        
        .success-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex: 1;
            padding: 40px 20px;
        }
        
        .success-card {
            background: white;
            width: 100%;
            max-width: 500px;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
            padding: 50px 40px;
            border: 1px solid #e0e0e0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .success-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #FFD700, #FFC107, #FF9800);
        }
        
        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: bounce 1s ease-in-out;
            display: inline-block;
        }
        
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }
        
        .success-title {
            font-size: 32px;
            color: #202124;
            margin-bottom: 16px;
            font-weight: 600;
        }
        
        .success-subtitle {
            font-size: 18px;
            color: #5f6368;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        
        .premium-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(45deg, #FFD700, #FFC107);
            color: #5c4033;
            padding: 12px 24px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 18px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.3);
        }
        
        .benefits-list {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 35px;
            text-align: left;
        }
        
        .benefits-title {
            font-size: 18px;
            color: #202124;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        .benefit-item {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
            padding: 8px 0;
        }
        
        .benefit-icon {
            color: #4CAF50;
            font-size: 20px;
            flex-shrink: 0;
        }
        
        .benefit-text {
            color: #3c4043;
            font-size: 15px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        
        .btn {
            padding: 14px 32px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: #1a73e8;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0d62d9;
            box-shadow: 0 2px 8px rgba(26, 115, 232, 0.3);
        }
        
        .btn-secondary {
            background: #f8f9fa;
            color: #3c4043;
            border: 1px solid #dadce0;
        }
        
        .btn-secondary:hover {
            background: #f1f3f4;
        }
        
        .countdown {
            margin-top: 25px;
            color: #5f6368;
            font-size: 14px;
        }
        
        .countdown-number {
            font-weight: 600;
            color: #1a73e8;
        }
        
        .channel-info {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .channel-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #FFD700;
        }
        
        .avatar-placeholder {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #FFD700 0%, #FFC107 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: bold;
            border: 3px solid #FFD700;
        }
        
        .channel-name {
            font-size: 20px;
            font-weight: 500;
            color: #202124;
        }
        
        .channel-premium {
            font-size: 14px;
            color: #5c4033;
            font-weight: 500;
        }
        
        @media (max-width: 480px) {
            .success-card {
                padding: 40px 24px;
                margin: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="success-container">
        <div class="success-card">
            <div class="success-icon">👑</div>
            <h1 class="success-title">Congratulations!</h1>
            <p class="success-subtitle">
                You have successfully upgraded your channel to Premium
            </p>
            
            <div class="channel-info">
                <c:choose>
                    <c:when test="${not empty sessionScope.channel.profilePicture}">
                        <img src="${pageContext.request.contextPath}/${sessionScope.channel.profilePicture}" 
                             alt="${sessionScope.channel.displayName}" 
                             class="channel-avatar">
                    </c:when>
                    <c:otherwise>
                        <div class="avatar-placeholder">
                            ${fn:substring(sessionScope.channel.displayName, 0, 1)}
                        </div>
                    </c:otherwise>
                </c:choose>
                <div>
                    <div class="channel-name">${sessionScope.channel.displayName}</div>
                    <div class="channel-premium">👑 Premium Channel</div>
                </div>
            </div>
            
            <div class="premium-badge">
                <span>⭐</span>
                <span>PREMIUM MEMBER</span>
            </div>
            
            <div class="benefits-list">
                <div class="benefits-title">Your Premium Benefits:</div>
                <div class="benefit-item">
                    <span class="benefit-icon">✓</span>
                    <span class="benefit-text"><strong>Gold Theme</strong> - Exclusive golden UI theme unlocked</span>
                </div>
                <div class="benefit-item">
                    <span class="benefit-icon">✓</span>
                    <span class="benefit-text"><strong>Video Downloads</strong> - Download any video for offline viewing</span>
                </div>
                <div class="benefit-item">
                    <span class="benefit-icon">✓</span>
                    <span class="benefit-text"><strong>Premium Badge</strong> - Special badge displayed on your channel</span>
                </div>
                <div class="benefit-item">
                    <span class="benefit-icon">✓</span>
                    <span class="benefit-text"><strong>Priority Support</strong> - Faster responses from our team</span>
                </div>
                <div class="benefit-item">
                    <span class="benefit-icon">✓</span>
                    <span class="benefit-text"><strong>No Ads</strong> - Enjoy videos without interruptions</span>
                </div>
            </div>
            
            <div class="action-buttons">
                <a href="home" class="btn btn-primary">Go to Home</a>
                <a href="channelDashboard" class="btn btn-secondary">Go to Dashboard</a>
            </div>
            
            <div class="countdown">
                Auto redirecting to home in <span class="countdown-number" id="countdown">5</span> seconds...
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Start countdown
            let countdown = 5;
            const countdownElement = document.getElementById('countdown');
            const countdownInterval = setInterval(function() {
                countdown--;
                countdownElement.textContent = countdown;
                
                if (countdown <= 0) {
                    clearInterval(countdownInterval);
                    window.location.href = 'home';
                }
            }, 1000);
            
            // Add confetti effect
            createConfetti();
            
            // Play success sound (optional)
            playSuccessSound();
        });
        
        function createConfetti() {
            const colors = ['#FFD700', '#FFC107', '#FF9800', '#FF5722'];
            
            for (let i = 0; i < 50; i++) {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.width = '10px';
                confetti.style.height = '10px';
                confetti.style.background = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.borderRadius = '50%';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = '-20px';
                confetti.style.zIndex = '9999';
                confetti.style.pointerEvents = 'none';
                
                document.body.appendChild(confetti);
                
                // Animation
                const animation = confetti.animate([
                    { transform: 'translateY(0) rotate(0deg)', opacity: 1 },
                    { transform: `translateY(${window.innerHeight + 100}px) rotate(${Math.random() * 360}deg)`, opacity: 0 }
                ], {
                    duration: Math.random() * 2000 + 2000,
                    easing: 'cubic-bezier(0.215, 0.610, 0.355, 1)'
                });
                
                animation.onfinish = () => confetti.remove();
            }
        }
        
        function playSuccessSound() {
            try {
                // Create a simple success sound using Web Audio API
                const audioContext = new (window.AudioContext || window.webkitAudioContext)();
                const oscillator = audioContext.createOscillator();
                const gainNode = audioContext.createGain();
                
                oscillator.connect(gainNode);
                gainNode.connect(audioContext.destination);
                
                oscillator.frequency.setValueAtTime(523.25, audioContext.currentTime); // C5
                oscillator.frequency.setValueAtTime(659.25, audioContext.currentTime + 0.1); // E5
                oscillator.frequency.setValueAtTime(783.99, audioContext.currentTime + 0.2); // G5
                
                gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
                gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);
                
                oscillator.start(audioContext.currentTime);
                oscillator.stop(audioContext.currentTime + 0.5);
            } catch (e) {
                // Audio context not supported, continue silently
            }
        }
        
        // Add keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Enter to go home
            if (e.key === 'Enter') {
                window.location.href = 'home';
            }
            
            // Escape to go to dashboard
            if (e.key === 'Escape') {
                window.location.href = 'channelDashboard';
            }
        });
    </script>
</body>
</html>