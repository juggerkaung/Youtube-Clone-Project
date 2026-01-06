package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Repository.VideoReactionRepository;
import Repository.VideoRepository;

/**
 * Servlet implementation class TestSyncServlet
 */
@WebServlet("/testSync")
public class TestSyncServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TestSyncServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		 response.setContentType("text/plain");
	        
	        try {
	            int videoId = 1; // Test with video ID 1
	            
	            VideoReactionRepository reactionRepo = new VideoReactionRepository();
	            VideoRepository videoRepo = new VideoRepository();
	            
	            // Get current counts from both sources
	            int actualLikes = reactionRepo.getLikeCount(videoId);
	            int actualDislikes = reactionRepo.getDislikeCount(videoId);
	            
	            response.getWriter().println("=== SYNC TEST FOR VIDEO " + videoId + " ===");
	            response.getWriter().println("Actual Likes from video_reactions: " + actualLikes);
	            response.getWriter().println("Actual Dislikes from video_reactions: " + actualDislikes);
	            
	            // Manually sync
	            videoRepo.syncVideoReactionCountsInDatabase(videoId);
	            
	            response.getWriter().println("Sync completed!");
	            
	        } catch (Exception e) {
	            response.getWriter().println("Error: " + e.getMessage());
	            e.printStackTrace();
	        }
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
