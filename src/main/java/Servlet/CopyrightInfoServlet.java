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

import Model.Channel;
import Model.Video;
import Repository.VideoRepository;

/**
 * Servlet implementation class CopyrightInfoServlet
 */
@WebServlet("/copyrightInfo")
public class CopyrightInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CopyrightInfoServlet() {
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
	        
	        if (channel == null) {
	            response.sendRedirect("login.jsp");
	            return;
	        }

	        String videoIdParam = request.getParameter("videoId");
	        if (videoIdParam == null) {
	            response.sendRedirect("channelDashboard");
	            return;
	        }

	        try {
	            int videoId = Integer.parseInt(videoIdParam);
	            VideoRepository videoRepo = new VideoRepository();
	            Video video = videoRepo.getVideoById(videoId);
	            
	            // Check if user owns this video
	            if (video == null || video.getChannelId() != channel.getId()) {
	                response.sendRedirect("channelDashboard?error=You don't own this video");
	                return;
	            }
	            
	            // Get the source video if there is a copyright issue
	            Video sourceVideo = null;
	            if (video.getCopyrightVideoId() != null && video.getCopyrightVideoId() > 0) {
	                sourceVideo = videoRepo.getVideoById(video.getCopyrightVideoId());
	            }
	            
	            request.setAttribute("video", video);
	            request.setAttribute("sourceVideo", sourceVideo);
	            request.getRequestDispatcher("copyrightInfo.jsp").forward(request, response);
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("channelDashboard?error=Error loading copyright information");
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
