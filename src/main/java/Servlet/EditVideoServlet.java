package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.http.HttpSession;

import Model.Channel;
import Model.Video;
import Repository.VideoRepository;

/**
 * Servlet implementation class EditVideoServlet
 */
@WebServlet("/editVideo")
public class EditVideoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditVideoServlet() {
        super();
        // TODO Auto-generated constructor stub
        System.out.println("EditVideoServlet: Constructor called - Servlet is being initialized");
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
System.out.println("EditVideoServlet: doGet called with ID: " + request.getParameter("id"));
        
        HttpSession session = request.getSession();
        Channel channel = (Channel) session.getAttribute("channel");
        
        if (channel == null) {
            System.out.println("EditVideoServlet: No channel in session, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }

        String videoIdParam = request.getParameter("id");
        if (videoIdParam == null) {
            System.out.println("EditVideoServlet: No video ID parameter, redirecting to myVideos");
            response.sendRedirect("myVideos");
            return;
        }

        try {
            int videoId = Integer.parseInt(videoIdParam);
            System.out.println("EditVideoServlet: Processing video ID: " + videoId);
            
            VideoRepository videoRepo = new VideoRepository();
            Video video = videoRepo.getVideoById(videoId);
            
            // Check if the channel owns this video
            if (video == null) {
                System.out.println("EditVideoServlet: Video not found with ID: " + videoId);
                response.sendRedirect("myVideos?error=Video not found");
                return;
            }
            
            if (video.getChannelId() != channel.getId()) {
                System.out.println("EditVideoServlet: Channel " + channel.getId() + " doesn't own video " + videoId);
                response.sendRedirect("myVideos?error=You don't have permission to edit this video");
                return;
            }
            
            System.out.println("EditVideoServlet: Forwarding to editVideo.jsp for video: " + video.getVideoTitle());
            request.setAttribute("video", video);
            request.getRequestDispatcher("editVideo.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("EditVideoServlet: Error loading video: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("myVideos?error=Error loading video");
        }
	
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
	
		  HttpSession session = request.getSession();
		    Channel channel = (Channel) session.getAttribute("channel");
		    
		    if (channel == null) {
		        response.sendRedirect("login.jsp");
		        return;
		    }

		    String action = request.getParameter("action");
		    String videoIdParam = request.getParameter("videoId");
		    
		    if (videoIdParam == null) {
		        response.sendRedirect("myVideos");
		        return;
		    }

		    try {
		        int videoId = Integer.parseInt(videoIdParam);
		        VideoRepository videoRepo = new VideoRepository();
		        Video video = videoRepo.getVideoById(videoId);
		        
		        // Check if the channel owns this video
		        if (video == null || video.getChannelId() != channel.getId()) {
		            response.sendRedirect("myVideos?error=You don't have permission to edit this video");
		            return;
		        }

		        if ("update".equals(action)) {
		            // Update video title, description, and visibility
		            String title = request.getParameter("title");
		            String description = request.getParameter("description");
		            String isPublic = request.getParameter("isPublic"); // Get visibility
		            
		            // DEBUG: Log all parameters
		            System.out.println("=== DEBUG: EditVideoServlet ===");
		            System.out.println("Title: " + title);
		            System.out.println("Description: " + description);
		            System.out.println("isPublic parameter: " + isPublic);
		            System.out.println("Current video visibility: " + video.getIsPublic());
		            
		            if (title == null || title.trim().isEmpty()) {
		                response.sendRedirect("editVideo?id=" + videoId + "&error=Title is required");
		                return;
		            }
		            
		            video.setVideoTitle(title.trim());
		            video.setVideoDescription(description != null ? description.trim() : "");
		            
		            // FIX: Properly handle the isPublic parameter
		            if (isPublic != null && isPublic.equals("1")) {
		                video.setIsPublic("1"); // Public
		                System.out.println("Setting video to PUBLIC");
		            } else {
		                video.setIsPublic("0"); // Private
		                System.out.println("Setting video to PRIVATE");
		            }
		            
		            int result = videoRepo.updateVideo(video);
		            if (result > 0) {
		                System.out.println("Video updated successfully - New visibility: " + video.getIsPublic());
		                response.sendRedirect("editVideo?id=" + videoId + "&success=Video updated successfully");
		            } else {
		                response.sendRedirect("editVideo?id=" + videoId + "&error=Failed to update video");
		            }
		            
		        } else if ("delete".equals(action)) {
		            // Delete video
		            int result = videoRepo.deleteVideo(videoId);
		            if (result > 0) {
		                response.sendRedirect("myVideos?success=Video deleted successfully");
		            } else {
		                response.sendRedirect("editVideo?id=" + videoId + "&error=Failed to delete video");
		            }
		        } else {
		            response.sendRedirect("editVideo?id=" + videoId + "&error=Invalid action");
		        }
		        
		    } catch (Exception e) {
		        e.printStackTrace();
		        response.sendRedirect("myVideos?error=Error processing request");
		    }
	
	}

}
