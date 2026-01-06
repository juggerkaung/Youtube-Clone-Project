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
import Model.Playlist;
import Model.Video;
import Repository.PlaylistRepository;
import Repository.PlaylistVideoRepository;

/**
 * Servlet implementation class ViewPlaylistServlet
 */
@WebServlet("/viewPlaylist")
public class ViewPlaylistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewPlaylistServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
		 String playlistIdParam = request.getParameter("id");
	        
	        if (playlistIdParam == null) {
	            response.sendRedirect("home");
	            return;
	        }
	        
	        try {
	            int playlistId = Integer.parseInt(playlistIdParam);
	            
	            PlaylistRepository playlistRepo = new PlaylistRepository();
	            PlaylistVideoRepository playlistVideoRepo = new PlaylistVideoRepository();
	            
	            Playlist playlist = playlistRepo.getPlaylistById(playlistId);
	            
	            if (playlist == null) {
	                response.sendRedirect("home?error=Playlist not found");
	                return;
	            }
	            
	            // Check if current user is the playlist owner
	            HttpSession session = request.getSession();
	            Channel currentUser = (Channel) session.getAttribute("channel");
	            boolean isOwner = (currentUser != null && currentUser.getId() == playlist.getChannelId());
	            
	            // Check privacy: if playlist is private and user is not owner, redirect
	            if ("0".equals(playlist.getIsPublic()) && !isOwner) {
	                response.sendRedirect("home?error=This playlist is private");
	                return;
	            }
	            
	            // Get videos in playlist
	            List<Video> videos = playlistVideoRepo.getVideosInPlaylist(playlistId);
	            
	            // Separate by video type
	            List<Video> regularVideos = new ArrayList<>();
	            List<Video> shortVideos = new ArrayList<>();
	            
	            for (Video video : videos) {
	                if ("short".equals(video.getVideoType())) {
	                    shortVideos.add(video);
	                } else {
	                    regularVideos.add(video);
	                }
	            }
	            
	            request.setAttribute("playlist", playlist);
	            request.setAttribute("videos", videos);
	            request.setAttribute("regularVideos", regularVideos);
	            request.setAttribute("shortVideos", shortVideos);
	            request.setAttribute("isOwner", isOwner);
	            request.setAttribute("videoCount", videos.size());
	            
	            request.getRequestDispatcher("viewPlaylist.jsp").forward(request, response);
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("home?error=Error loading playlist");
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
