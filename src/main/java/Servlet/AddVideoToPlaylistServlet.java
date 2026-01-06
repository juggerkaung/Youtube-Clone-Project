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
import Repository.PlaylistVideoRepository;

/**
 * Servlet implementation class AddVideoToPlaylistServlet
 */
@WebServlet("/addVideoToPlaylist")
public class AddVideoToPlaylistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddVideoToPlaylistServlet() {
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
	//	doGet(request, response);
		 HttpSession session = request.getSession();
	        Channel channel = (Channel) session.getAttribute("channel");
	        
	        if (channel == null) {
	            response.sendRedirect("login.jsp");
	            return;
	        }

	        String playlistIdParam = request.getParameter("playlistId");
	        String videoIdParam = request.getParameter("videoId");
	        
	        if (playlistIdParam == null || videoIdParam == null) {
	            response.sendRedirect("home");
	            return;
	        }
	        
	        try {
	            int playlistId = Integer.parseInt(playlistIdParam);
	            int videoId = Integer.parseInt(videoIdParam);
	            
	            // TODO: Add validation to check if playlist belongs to channel
	            // and if video exists and is accessible
	            
	            PlaylistVideoRepository playlistVideoRepo = new PlaylistVideoRepository();
	            int result = playlistVideoRepo.addVideoToPlaylist(playlistId, videoId);
	            
	            if (result > 0) {
	                response.sendRedirect("viewPlaylist?id=" + playlistId + "&success=Video added to playlist");
	            } else {
	                response.sendRedirect("video?id=" + videoId + "&error=Video already in playlist");
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("home?error=Error adding video to playlist");
	        }
	}
}
