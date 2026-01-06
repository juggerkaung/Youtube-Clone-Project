package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Model.*;
import Repository.*;

/**
 * Servlet implementation class RefreshSessionServlet
 */
@WebServlet("/refreshSession")
public class RefreshSessionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RefreshSessionServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
	
	/*
	 * HttpSession session = request.getSession(); Channel channel = (Channel)
	 * session.getAttribute("channel");
	 * 
	 * response.setContentType("application/json");
	 * 
	 * if (channel != null) { // Refresh channel data from database
	 * ChannelRepository channelRepo = new ChannelRepository(); Channel freshChannel
	 * = null; try { freshChannel = channelRepo.getChannelById(channel.getId()); }
	 * catch (ClassNotFoundException e) { // TODO Auto-generated catch block
	 * e.printStackTrace(); }
	 * 
	 * if (freshChannel != null) { session.setAttribute("channel", freshChannel);
	 * 
	 * // Return JSON response response.getWriter().write("{\"premium\": \"" +
	 * freshChannel.getIsPremium() + "\"}"); } } else {
	 * response.getWriter().write("{\"premium\": \"0\"}"); }
	 */
		HttpSession session = request.getSession();
        Channel channel = (Channel) session.getAttribute("channel");
        
        if (channel != null) {
            try {
                // Refresh channel data from database
                ChannelRepository channelRepo = new ChannelRepository();
                Channel freshChannel = channelRepo.getChannelById(channel.getId());
                
                if (freshChannel != null) {
                    session.setAttribute("channel", freshChannel);
                    
                    // Simple response indicating success
                    response.setContentType("text/plain");
                    response.getWriter().write("OK:" + freshChannel.getIsPremium());
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("text/plain");
                response.getWriter().write("ERROR");
            }
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
