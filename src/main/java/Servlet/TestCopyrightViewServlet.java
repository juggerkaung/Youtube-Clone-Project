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


/**
 * Servlet implementation class TestCopyrightViewServlet
 */
@WebServlet("/testCopyrightView")
public class TestCopyrightViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TestCopyrightViewServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
	
		 response.setContentType("text/html");
	        
	        try {
	            String videoIdParam = request.getParameter("videoId");
	            if (videoIdParam == null) {
	                response.getWriter().println("<h3>Please provide videoId parameter</h3>");
	                return;
	            }
	            
	            int videoId = Integer.parseInt(videoIdParam);
	            VideoRepository videoRepo = new VideoRepository();
	            Video video = videoRepo.getVideoById(videoId);
	            
	            if (video == null) {
	                response.getWriter().println("<h3>Video not found</h3>");
	                return;
	            }
	            
	            response.getWriter().println("<h3>Video Copyright Data Test</h3>");
	            response.getWriter().println("<hr>");
	            response.getWriter().println("<p><strong>Video ID:</strong> " + video.getId() + "</p>");
	            response.getWriter().println("<p><strong>Title:</strong> " + video.getVideoTitle() + "</p>");
	            response.getWriter().println("<p><strong>Copyright Status:</strong> " + video.getCopyrightStatus() + "</p>");
	            response.getWriter().println("<p><strong>Copyright Reason:</strong> " + video.getCopyrightReason() + "</p>");
	            response.getWriter().println("<p><strong>Copyright Video ID:</strong> " + video.getCopyrightVideoId() + "</p>");
	            
	            response.getWriter().println("<hr>");
	            response.getWriter().println("<a href='channelDashboard'>Back to Dashboard</a>");
	            
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
