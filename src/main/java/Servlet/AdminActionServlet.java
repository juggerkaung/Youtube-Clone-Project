package Servlet;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Model.*;
import Repository.*;
import java.util.*;

/**
 * Servlet implementation class AdminActionServlet
 */
@WebServlet("/adminAction")
public class AdminActionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminActionServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
        response.sendRedirect("adminDashboard");	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	doGet(request, response);
	
		HttpSession session = request.getSession();
        Channel admin = (Channel) session.getAttribute("admin");
        
        // Check if admin is logged in
        if (admin == null || admin.getRoleId() != 1) {
            response.sendRedirect("adminLogin.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String channelIdParam = request.getParameter("channelId");
        String videoIdParam = request.getParameter("videoId");
        String theme = request.getParameter("theme");
        
        try {
            switch (action) {
         // In AdminActionServlet.java - doPost method
            case "toggleChannelStatus":
                if (channelIdParam != null) {
                    int channelId = Integer.parseInt(channelIdParam);
                    ChannelRepository channelRepo = new ChannelRepository();
                    
                    // Get current status directly from database to ensure accuracy
                    Channel channel = channelRepo.getChannelById(channelId);
                    
                    if (channel != null) {
                        String currentStatus = channel.getIsActive();
                        System.out.println("Current status for channel " + channelId + ": " + currentStatus);
                        
                        // Toggle the status
                        String newStatus = "1".equals(currentStatus) ? "0" : "1";
                        System.out.println("Setting new status for channel " + channelId + ": " + newStatus);
                        
                        // Update in database - ONLY update channel status, NOT video visibility
                        int result = channelRepo.toggleChannelStatus(channelId, newStatus);
                        System.out.println("Update result: " + result);
                        
                        // REMOVED: Don't change video visibility when banning/unbanning
                        // Videos remain as they are (public or private based on their own settings)
                    }
                }
                break;
            
            
                    
                case "deleteChannel":
                    if (channelIdParam != null) {
                        int channelId = Integer.parseInt(channelIdParam);
                        deleteChannelAndContent(channelId);
                    }
                    break;
                    
                case "toggleVideoVisibility":
                    if (videoIdParam != null) {
                        int videoId = Integer.parseInt(videoIdParam);
                        VideoRepository videoRepo = new VideoRepository();
                        Video video = videoRepo.getVideoById(videoId);
                        if (video != null) {
                            String currentVisibility = video.getIsPublic();
                            String newVisibility = "1".equals(currentVisibility) ? "0" : "1";
                            System.out.println("Toggling video " + videoId + " from " + currentVisibility + " to " + newVisibility);
                            videoRepo.toggleVideoVisibility(videoId, newVisibility);
                        }
                    }
                    break;
                    
                case "deleteVideo":
                    if (videoIdParam != null) {
                        int videoId = Integer.parseInt(videoIdParam);
                        VideoRepository videoRepo = new VideoRepository();
                        int result = videoRepo.deleteVideo(videoId);
                        System.out.println("Deleted video " + videoId + ", result: " + result);
                    }
                    break;
                    
                case "changeTheme":
                    if (theme != null) {
                        session.setAttribute("adminTheme", theme);
                        // Send success response
                        response.setStatus(200);
                        return;
                    }
                    break;
            }
            
            // Redirect back to referrer with the current section
            String referer = request.getHeader("Referer");
            if (referer != null) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect("adminDashboard");
            }
            
        } catch (Exception e) {
            System.out.println("AdminActionServlet Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("adminDashboard?error=" + e.getMessage());
        }
    }
    
    private void deleteChannelAndContent(int channelId) throws Exception {
        ChannelRepository channelRepo = new ChannelRepository();
        VideoRepository videoRepo = new VideoRepository();
        
        // Get all videos by this channel
        List<Video> channelVideos = videoRepo.getVideosForChannelOwner(channelId);
        System.out.println("Deleting " + channelVideos.size() + " videos for channel " + channelId);
        
        // Delete each video (this will delete comments, reactions, etc.)
        for (Video video : channelVideos) {
            videoRepo.deleteVideo(video.getId());
            System.out.println("Deleted video: " + video.getId());
        }
        
        // Now delete the channel
        int result = channelRepo.deleteChannel(channelId);
        
        System.out.println("Admin: Deleted channel " + channelId + " with " + 
                          channelVideos.size() + " videos. Result: " + result);	
	}
}
