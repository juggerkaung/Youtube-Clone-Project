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

import Model.Video;
import Repository.VideoRepository;
import Service.CopyrightService;


/**
 * Servlet implementation class CheckCopyrightServlet
 */
@WebServlet("/checkCopyright")
public class CheckCopyrightServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CheckCopyrightServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
	
		  response.setContentType("text/html");
	        
	        String videoIdParam = request.getParameter("videoId");
	        
	        if (videoIdParam == null) {
	            response.getWriter().println("<h3>Please provide videoId parameter</h3>");
	            return;
	        }
	        
	        try {
	            int videoId = Integer.parseInt(videoIdParam);
	            VideoRepository videoRepo = new VideoRepository();
	            Video video = videoRepo.getVideoById(videoId);
	            
	            if (video == null) {
	                response.getWriter().println("<h3>Video not found</h3>");
	                return;
	            }
	            
	            response.getWriter().println("<h3>Running Copyright Check for Video ID: " + videoId + "</h3>");
	            response.getWriter().println("<p>Title: " + video.getVideoTitle() + "</p>");
	            response.getWriter().println("<p>Description: " + video.getVideoDescription() + "</p>");
	            response.getWriter().println("<p>URL: " + video.getVideoUrl() + "</p>");
	            response.getWriter().println("<hr>");
	            
	            // Run copyright checks
	            CopyrightService.checkCopyrightClaims(video);
//	            CopyrightService.checkCopyrightStrike(video);
	            CopyrightService.checkCopyrightStrikeByFilename(video);

	            
	            // Refresh video data
	            video = videoRepo.getVideoById(videoId);
	            
	            response.getWriter().println("<h4>Result:</h4>");
	            response.getWriter().println("<p>Copyright Status: " + video.getCopyrightStatus() + "</p>");
	            response.getWriter().println("<p>Copyright Reason: " + video.getCopyrightReason() + "</p>");
	            response.getWriter().println("<p>Copyright Video ID: " + video.getCopyrightVideoId() + "</p>");
	            
	            response.getWriter().println("<br><br><a href='channelDashboard'>Back to Dashboard</a>");
	            
	        } catch (Exception e) {
	            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
	            e.printStackTrace(response.getWriter());
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
