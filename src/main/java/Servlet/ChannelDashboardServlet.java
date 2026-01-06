package Servlet;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.*;
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
 * Servlet implementation class ChannelDashboardServlet
 */
@WebServlet("/channelDashboard")
public class ChannelDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChannelDashboardServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());

		 HttpSession session = request.getSession();
		    Channel channel = (Channel) session.getAttribute("channel");
		    
		    if (channel == null || channel.getRoleId() != 2) {
		        response.sendRedirect("login.jsp");
		        return;
		    }
		    
		    try {
		        VideoRepository videoRepo = new VideoRepository();
		        // Use getVideosForChannelOwner to include private videos
		        List<Video> videos = videoRepo.getVideosForChannelOwner(channel.getId());
		        
		        // Separate by visibility
		        List<Video> publicVideos = new ArrayList<>();
		        List<Video> privateVideos = new ArrayList<>();
		        
		        for (Video video : videos) {
		            if ("1".equals(video.getIsPublic())) {
		                publicVideos.add(video);
		            } else {
		                privateVideos.add(video);
		            }
		        }
		        
		        request.setAttribute("videos", videos);
		        request.setAttribute("publicVideos", publicVideos);
		        request.setAttribute("privateVideos", privateVideos);
		        request.setAttribute("totalVideos", videos.size());
		        request.setAttribute("publicCount", publicVideos.size());
		        request.setAttribute("privateCount", privateVideos.size());
		        
		        request.getRequestDispatcher("channelDashboard.jsp").forward(request, response);
		        
		    } catch (Exception e) {
		        e.printStackTrace();
		        response.sendRedirect("home?error=Error loading dashboard");
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
