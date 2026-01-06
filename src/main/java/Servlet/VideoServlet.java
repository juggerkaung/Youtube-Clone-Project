
package Servlet;

import java.io.IOException;




import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.Video;
import Model.Channel;
import Model.Comment;
import Service.*;
import Repository.*;



@WebServlet("/video")
public class VideoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public VideoServlet() {
        super();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String videoIdParam = request.getParameter("id");
        
     // Modify the channel display logic:
        Channel displayChannel;
        if (videoIdParam == null) {
            response.sendRedirect("home");
            return;
        }
        
        try {
            int videoId = Integer.parseInt(videoIdParam);
            
            VideoRepository videoRepo = new VideoRepository();
            ChannelRepository channelRepo = new ChannelRepository();
            CommentRepository commentRepo = new CommentRepository();
            
         // DEBUG: Check before increment
            System.out.println("=== VideoServlet Debug ===");
            System.out.println("Video ID: " + videoId);
            
         // Inside doGet method, after getting video and channel, add:
            SubscriptionRepository subscriptionRepo = new SubscriptionRepository();
            VideoReactionRepository reactionRepo = new VideoReactionRepository();

            // Get video details
            Video video = videoRepo.getVideoById(videoId);
            if (video == null) {
                response.sendRedirect("home");
                return;
            }
            
            
            System.out.println("Before increment - Views: " + video.getViewsCount());
            // Increment view count
            videoRepo.incrementViewCount(videoId);
            
            // Get updated video
            video = videoRepo.getVideoById(videoId);
            System.out.println("After increment - Views: " + video.getViewsCount());
            
            
            // Get channel details
            HttpSession session = request.getSession();
            Channel currentUserChannel = (Channel) session.getAttribute("channel");
            
            // ALWAYS get fresh data from database for display
               displayChannel = channelRepo.getChannelById(video.getChannelId()); 
            //Channel displayChannel;
            
            // ALWAYS try to get fresh data from database first
           // displayChannel = channelRepo.getChannelById(video.getChannelId());
               
            // If displayChannel is null (channel is banned), we should still show something
               if (displayChannel == null) {
                   // Create a placeholder channel with basic info
                   displayChannel = new Channel();
                   displayChannel.setId(video.getChannelId());
                   displayChannel.setDisplayName("Channel Unavailable");
                   displayChannel.setProfilePicture("images/default-avatar.jpg");
               }
            
            // If current user is the channel owner AND session data is more recent, use session data
            if (currentUserChannel != null && currentUserChannel.getId() == video.getChannelId()) {
                // Compare timestamps - if session channel was updated more recently, use it
                if (currentUserChannel.getUpdatedAt() != null && displayChannel.getUpdatedAt() != null) {
                    if (currentUserChannel.getUpdatedAt().after(displayChannel.getUpdatedAt())) {
                        displayChannel = currentUserChannel;
                        System.out.println("Using session channel data (more recent)");
                    }
                }
            }
            // ---
            
         // ONLY INCREMENT VIEW IF USER HASN'T VIEWED THIS VIDEO IN THIS SESSION
            if (!ViewTrackingService.hasViewedVideo(session, videoId)) {
                // Increment view count in database
                videoRepo.incrementViewCount(videoId);
                
                // Mark as viewed in this session
                ViewTrackingService.markVideoAsViewed(session, videoId);
                
                System.out.println("VideoServlet: Incremented view for video " + videoId + " by session " + session.getId());
            } else {
                System.out.println("VideoServlet: Video " + videoId + " already viewed by session " + session.getId());
            }
            
            // Get fresh video data after potential increment
            video = videoRepo.getVideoById(videoId);
            
         // Check if current user is subscribed to this channel
            boolean isSubscribed = false;
            if (currentUserChannel != null && currentUserChannel.getId() != video.getChannelId()) {
                isSubscribed = subscriptionRepo.isSubscribed(currentUserChannel.getId(), video.getChannelId());
            }
            request.setAttribute("isSubscribed", isSubscribed);

            // Get current user's reaction to this video
            String userReaction = null;
            if (currentUserChannel != null) {
                userReaction = reactionRepo.getUserReaction(currentUserChannel.getId(), video.getId());
            }
            request.setAttribute("userReaction", userReaction);

            // Get subscriber count for the channel
            int subscriberCount = subscriptionRepo.getSubscriberCount(video.getChannelId());
            request.setAttribute("subscriberCount", subscriberCount);
            // ---
            
            // Get comments for this video
            List<Comment> comments = commentRepo.getCommentsByVideoId(videoId);
            
            // Increment view count
            videoRepo.incrementViewCount(videoId);
            
            // Set attributes for JSP
            request.setAttribute("video", video);
            request.setAttribute("channel", displayChannel);
            request.setAttribute("comments", comments);
            
            System.out.println("=== VideoServlet Debug ===");
            System.out.println("Video Channel ID: " + video.getChannelId());
            System.out.println("Current User Channel ID: " + (currentUserChannel != null ? currentUserChannel.getId() : "null"));
            System.out.println("Display Channel Name: " + displayChannel.getDisplayName());
            System.out.println("Display Channel Profile: " + displayChannel.getProfilePicture());
            System.out.println("Session Channel Name: " + (currentUserChannel != null ? currentUserChannel.getDisplayName() : "null"));
            System.out.println("Session Channel Profile: " + (currentUserChannel != null ? currentUserChannel.getProfilePicture() : "null"));
            
            request.getRequestDispatcher("video.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}