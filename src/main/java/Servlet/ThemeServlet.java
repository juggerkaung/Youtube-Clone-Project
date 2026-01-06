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
 * Servlet implementation class ThemeServlet
 */
@WebServlet("/changeTheme")
public class ThemeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ThemeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
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
	        
	        String theme = request.getParameter("theme");
	        String[] allowedThemes = {"light", "dark", "gold"};
	        boolean isValidTheme = false;
	        
	        // Check if theme is valid
	        for (String allowed : allowedThemes) {
	            if (allowed.equals(theme)) {
	                isValidTheme = true;
	                break;
	            }
	        }
	        
	        if (!isValidTheme) {
	            response.setStatus(400);
	            response.getWriter().write("Invalid theme");
	            return;
	        }
	        
	        // Check if trying to access gold theme without premium
	        if ("gold".equals(theme) && !"1".equals(channel.getIsPremium())) {
	            response.setStatus(403);
	            response.getWriter().write("Gold theme requires premium subscription");
	            return;
	        }
	        
	        try {
	            ChannelRepository channelRepo = new ChannelRepository();
	            int result = channelRepo.updateThemePreference(channel.getId(), theme);
	            
	            if (result > 0) {
	                // Update channel in session
	                channel.setThemePreference(theme);
	                session.setAttribute("channel", channel);
	                
	                response.setStatus(200);
	                response.getWriter().write("Theme updated successfully");
	            } else {
	                response.setStatus(500);
	                response.getWriter().write("Failed to update theme");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.setStatus(500);
	            response.getWriter().write("Server error");
	        }
	    }
}
