package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

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
 * Servlet implementation class EditPlaylistServlet
 */
@WebServlet("/editPlaylist")
public class EditPlaylistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditPlaylistServlet() {
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

	        String playlistIdParam = request.getParameter("id");
	        if (playlistIdParam == null) {
	            response.sendRedirect("playlists");
	            return;
	        }

	        try {
	            int playlistId = Integer.parseInt(playlistIdParam);
	            
	            PlaylistRepository playlistRepo = new PlaylistRepository();
	            PlaylistVideoRepository playlistVideoRepo = new PlaylistVideoRepository();
	            
	            Playlist playlist = playlistRepo.getPlaylistById(playlistId);
	            
	            if (playlist == null) {
	                response.sendRedirect("playlists?error=Playlist not found");
	                return;
	            }
	            
	            // Check if the current user is the owner of the playlist
	            if (playlist.getChannelId() != channel.getId()) {
	                response.sendRedirect("viewPlaylist?id=" + playlistId + "&error=You don't have permission to edit this playlist");
	                return;
	            }
	            
	            // Get videos in the playlist
	            List<Video> videos = playlistVideoRepo.getVideosInPlaylist(playlistId);
	            
	            request.setAttribute("playlist", playlist);
	            request.setAttribute("videos", videos);
	            request.getRequestDispatcher("editPlaylist.jsp").forward(request, response);
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("playlists?error=Error loading playlist");
	        }
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
		 HttpSession session = request.getSession();
	        Channel channel = (Channel) session.getAttribute("channel");
	        
	        if (channel == null) {
	            response.sendRedirect("login.jsp");
	            return;
	        }

	        String playlistIdParam = request.getParameter("playlistId");
	        String action = request.getParameter("action");
	        
	        if (playlistIdParam == null) {
	            response.sendRedirect("playlists");
	            return;
	        }

	        try {
	            int playlistId = Integer.parseInt(playlistIdParam);
	            PlaylistRepository playlistRepo = new PlaylistRepository();
	            Playlist playlist = playlistRepo.getPlaylistById(playlistId);
	            
	            // Check if the current user is the owner of the playlist
	            if (playlist == null || playlist.getChannelId() != channel.getId()) {
	                response.sendRedirect("playlists?error=You don't have permission to edit this playlist");
	                return;
	            }
	            
	            if ("update".equals(action)) {
	                String name = request.getParameter("name");
	                String description = request.getParameter("description");
	                String isPublic = request.getParameter("isPublic");
	                
	                if (name == null || name.trim().isEmpty()) {
	                    response.sendRedirect("editPlaylist?id=" + playlistId + "&error=Playlist name is required");
	                    return;
	                }
	                
	                playlist.setName(name.trim());
	                playlist.setDescription(description != null ? description.trim() : "");
	                playlist.setIsPublic(isPublic != null ? "1" : "0");
	                
	                int result = playlistRepo.updatePlaylist(playlist);
	                if (result > 0) {
	                    response.sendRedirect("editPlaylist?id=" + playlistId + "&success=Playlist updated successfully");
	                } else {
	                    response.sendRedirect("editPlaylist?id=" + playlistId + "&error=Failed to update playlist");
	                }
	            } else {
	                response.sendRedirect("editPlaylist?id=" + playlistId + "&error=Invalid action");
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("playlists?error=Error updating playlist");
	        }
	}
}
