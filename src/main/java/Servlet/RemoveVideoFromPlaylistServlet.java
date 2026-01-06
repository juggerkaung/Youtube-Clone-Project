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
import Repository.PlaylistRepository;
import Repository.PlaylistVideoRepository;

/**
 * Servlet implementation class RemoveVideoFromPlaylistServlet
 */
@WebServlet("/removeVideoFromPlaylist")
public class RemoveVideoFromPlaylistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RemoveVideoFromPlaylistServlet() {
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
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String playlistIdParam = request.getParameter("playlistId");
        String videoIdParam = request.getParameter("videoId");
        
        if (playlistIdParam == null || videoIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int playlistId = Integer.parseInt(playlistIdParam);
            int videoId = Integer.parseInt(videoIdParam);
            
            // First verify that the playlist belongs to the channel
            PlaylistRepository playlistRepo = new PlaylistRepository();
            Model.Playlist playlist = playlistRepo.getPlaylistById(playlistId);
            
            if (playlist == null || playlist.getChannelId() != channel.getId()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            PlaylistVideoRepository playlistVideoRepo = new PlaylistVideoRepository();
            int result = playlistVideoRepo.removeVideoFromPlaylist(playlistId, videoId);
            
            if (result > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
	}
}
