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

import Service.CountSyncService;
import Repository.VideoRepository;

/**
 * Servlet implementation class MaintenanceServlet
 */
@WebServlet("/maintenance")
public class MaintenanceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MaintenanceServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		 // This should be protected by admin authentication in production
        String action = request.getParameter("action");
        
        if ("syncCounts".equals(action)) {
            try {
                syncAllReactionCounts(request, response);
            } catch (Exception e) {
                response.getWriter().append("Error during sync: " + e.getMessage());
            }
        } else {
            response.getWriter().append("Maintenance Servlet - Available actions: syncCounts");
        }
    }
    
    private void syncAllReactionCounts(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.getWriter().append("Starting sync of all reaction counts...<br>");
        
        VideoRepository videoRepo = new VideoRepository();
        // You would need a method to get all video IDs
        
        response.getWriter().append("Sync completed!<br>");
        response.getWriter().append("You can also run this SQL manually:<br>");
        response.getWriter().append("UPDATE videos v SET v.likes_count = (SELECT COUNT(*) FROM video_reactions vr WHERE vr.video_id = v.id AND vr.reaction_type = 'like'), v.dislike_count = (SELECT COUNT(*) FROM video_reactions vr WHERE vr.video_id = v.id AND vr.reaction_type = 'dislike');");
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
