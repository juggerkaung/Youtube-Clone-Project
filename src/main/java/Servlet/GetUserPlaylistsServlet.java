package Servlet;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.Channel;
import Model.Playlist;
import Repository.PlaylistRepository;
import Repository.*;

/**
 * Servlet implementation class GetUserPlaylistsServlet
 */
@WebServlet("/getUserPlaylists")
public class GetUserPlaylistsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetUserPlaylistsServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
		 HttpSession session = request.getSession();
		    Channel channel = (Channel) session.getAttribute("channel");
		    
		    response.setContentType("text/html");
		    PrintWriter out = response.getWriter();
		    
		    if (channel == null) {
		        out.println("<p>Please login to use playlists</p>");
		        return;
		    }
		    
		    try {
		        String videoIdParam = request.getParameter("videoId");
		        int videoId = videoIdParam != null ? Integer.parseInt(videoIdParam) : 0;
		        
		        PlaylistRepository playlistRepo = new PlaylistRepository();
		        PlaylistVideoRepository playlistVideoRepo = new PlaylistVideoRepository(); // ADD THIS
		        List<Playlist> playlists = playlistRepo.getPlaylistsByChannelId(channel.getId(), true);
		        
		        if (playlists.isEmpty()) {
		            out.println("<p>You don't have any playlists yet.</p>");
		            return;
		        }
		        
		        for (Playlist playlist : playlists) {
		            // Check if video is already in this playlist
		            boolean isInPlaylist = false;
		            if (videoId > 0) {
		                isInPlaylist = playlistVideoRepo.isVideoInPlaylist(playlist.getId(), videoId);
		            }
		            
		            out.println("<div style='padding: 10px; border-bottom: 1px solid #eee; cursor: pointer;' " +
		                       "onclick='addToPlaylist(" + playlist.getId() + ")'>");
		            out.println("<div style='font-weight: bold;'>" + playlist.getName());
		            if (isInPlaylist) {
		                out.println(" <span style='color: green; font-size: 12px;'>(Already added)</span>");
		            }
		            out.println("</div>");
		            out.println("<div style='color: #666; font-size: 14px;'>" + 
		                       playlist.getVideoCount() + " videos • " +
		                       (playlist.getIsPublic().equals("1") ? "Public" : "Private") +
		                       "</div>");
		            out.println("</div>");
		        }
		        
		    } catch (Exception e) {
		        e.printStackTrace();
		        out.println("<p>Error loading playlists</p>");
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
