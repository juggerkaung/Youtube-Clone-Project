package Servlet;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.*;
import Model.Channel;
import Model.Playlist;
import Model.Video;
import Repository.*;

/**
 * Servlet implementation class ChannelVideosServlet
 */
@WebServlet("/channelVideos")
public class ChannelVideosServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ChannelVideosServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());

		 String channelIdParam = request.getParameter("channelId");
		    
		    if (channelIdParam == null) {
		        response.sendRedirect("home");
		        return;
		    }

		    try {
		        int channelId = Integer.parseInt(channelIdParam);
		        
		        ChannelRepository channelRepo = new ChannelRepository();
		        VideoRepository videoRepo = new VideoRepository();
		        PlaylistRepository playlistRepo = new PlaylistRepository(); // ADD THIS
		        
		        // Get channel details
		        Channel channel = channelRepo.getChannelById(channelId);
		        if (channel == null) {
		            response.sendRedirect("home");
		            return;
		        }
		        
		        // Check if current user is the channel owner
		        HttpSession session = request.getSession();
		        Channel currentUser = (Channel) session.getAttribute("channel");
		        boolean isOwner = (currentUser != null && currentUser.getId() == channelId);
		        
		        // Get videos - show private videos only to owner
		        List<Video> videos;
		        if (isOwner) {
		            videos = videoRepo.getVideosForChannelOwner(channelId);
		        } else {
		            videos = videoRepo.getVideosByChannelId(channelId);
		        }
		        
		        // Get playlists - show private playlists only to owner
		        List<Playlist> playlists;
		        if (isOwner) {
		            playlists = playlistRepo.getPlaylistsByChannelId(channelId, true); // Include private
		        } else {
		            playlists = playlistRepo.getPublicPlaylistsByChannelId(channelId); // Only public
		        }
		        
		        // Separate regular videos and short videos
		        List<Video> regularVideos = new ArrayList<>();
		        List<Video> shortVideos = new ArrayList<>();
		        
		        for (Video video : videos) {
		            if ("short".equals(video.getVideoType())) {
		                shortVideos.add(video);
		            } else {
		                regularVideos.add(video);
		            }
		        }
		        
		        request.setAttribute("channel", channel);
		        request.setAttribute("videos", videos);
		        request.setAttribute("regularVideos", regularVideos);
		        request.setAttribute("shortVideos", shortVideos);
		        request.setAttribute("playlists", playlists); // ADD THIS
		        request.setAttribute("isOwner", isOwner);
		        request.getRequestDispatcher("channelVideos.jsp").forward(request, response);
		        
		    } catch (Exception e) {
		        e.printStackTrace();
		        response.sendRedirect("home");
		    }
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
