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

/**
 * Servlet implementation class DeletePlaylistServlet
 */
@WebServlet("/deletePlaylist")
public class DeletePlaylistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeletePlaylistServlet() {
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
	            int result = playlistRepo.deletePlaylist(playlistId, channel.getId());
	            
	            if (result > 0) {
	                response.sendRedirect("playlists?success=Playlist deleted successfully");
	            } else {
	                response.sendRedirect("viewPlaylist?id=" + playlistId + "&error=Failed to delete playlist");
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("playlists?error=Error deleting playlist");
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
