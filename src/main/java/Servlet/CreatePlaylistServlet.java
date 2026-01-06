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
import Model.Playlist;
import Repository.PlaylistRepository;


/**
 * Servlet implementation class CreatePlaylistServlet
 */
@WebServlet("/createPlaylist")
public class CreatePlaylistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreatePlaylistServlet() {
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
	        
	        request.getRequestDispatcher("createPlaylist.jsp").forward(request, response);
	
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

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String isPublic = request.getParameter("isPublic");
        
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("createPlaylist.jsp?error=Playlist name is required");
            return;
        }
        
        try {
            Playlist playlist = new Playlist();
            playlist.setChannelId(channel.getId());
            playlist.setName(name.trim());
            playlist.setDescription(description != null ? description.trim() : "");
            playlist.setIsPublic(isPublic != null ? "1" : "0");
            
            PlaylistRepository playlistRepo = new PlaylistRepository();
            int result = playlistRepo.createPlaylist(playlist);
            
            if (result > 0) {
                response.sendRedirect("playlists?success=Playlist created successfully");
            } else {
                response.sendRedirect("createPlaylist.jsp?error=Failed to create playlist");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("createPlaylist.jsp?error=Server error: " + e.getMessage());
	
	}}}


