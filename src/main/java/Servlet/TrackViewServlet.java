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
import javax.servlet.http.HttpSession;

import Repository.VideoRepository;
import Service.ViewTrackingService;

/**
 * Servlet implementation class TrackViewServlet
 */
@WebServlet("/trackView")
public class TrackViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TrackViewServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
		  HttpSession session = request.getSession();
	        String videoIdParam = request.getParameter("videoId");
	        
	        if (videoIdParam == null) {
	            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	            return;
	        }
	        
	        try {
	            int videoId = Integer.parseInt(videoIdParam);
	            
	            // Check if already viewed in this session
	            if (!ViewTrackingService.hasViewedVideo(session, videoId)) {
	                VideoRepository videoRepo = new VideoRepository();
	                videoRepo.incrementViewCount(videoId);
	                ViewTrackingService.markVideoAsViewed(session, videoId);
	                
	                System.out.println("TrackViewServlet: Counted view for video " + videoId);
	                response.setStatus(HttpServletResponse.SC_OK);
	            } else {
	                System.out.println("TrackViewServlet: Already viewed video " + videoId);
	                response.setStatus(HttpServletResponse.SC_OK);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        }
	    }
}
