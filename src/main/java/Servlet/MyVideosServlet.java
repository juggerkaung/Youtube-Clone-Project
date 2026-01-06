package Servlet;

import java.io.IOException;
import java.util.List;

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
 * Servlet implementation class MyVideosServlet
 */
@WebServlet("/myVideos")
public class MyVideosServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MyVideosServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());

		HttpSession session = request.getSession();
	    Channel channel = (Channel) session.getAttribute("channel");
	    
	    System.out.println("MyVideosServlet: Channel = " + channel);
	    
	    if (channel == null || channel.getRoleId() != 2) {
	        System.out.println("MyVideosServlet: Redirecting to login");
	        response.sendRedirect("login.jsp");
	        return;
	    }
	    
	    try {
	        VideoRepository videoRepo = new VideoRepository();
	        System.out.println("MyVideosServlet: Getting videos for channel ID: " + channel.getId());

	        // Use the method that includes private videos for channel owner
	        List<Video> videos = videoRepo.getVideosForChannelOwner(channel.getId());
	        System.out.println("MyVideosServlet: Found " + videos.size() + " videos");

	        request.setAttribute("videos", videos);
	        request.getRequestDispatcher("myVideos.jsp").forward(request, response);
	        
	    } catch (Exception e) {
	        System.out.println("MyVideosServlet: Error - " + e.getMessage());
	        e.printStackTrace();
	        response.sendRedirect("channelDashboard?error=Error loading videos");
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
