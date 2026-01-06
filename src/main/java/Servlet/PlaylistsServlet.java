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
import Repository.PlaylistRepository;

/**
 * Servlet implementation class PlaylistsServlet
 */
@WebServlet("/playlists")
public class PlaylistsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PlaylistsServlet() {
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
	        
	        if (channel == null) {
	            response.sendRedirect("login.jsp");
	            return;
	        }
	        
	        try {
	            PlaylistRepository playlistRepo = new PlaylistRepository();
	            List<Playlist> playlists = playlistRepo.getPlaylistsByChannelId(channel.getId(), true);
	            
	            request.setAttribute("playlists", playlists);
	            request.getRequestDispatcher("playlists.jsp").forward(request, response);
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("channelDashboard?error=Error loading playlists");
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
