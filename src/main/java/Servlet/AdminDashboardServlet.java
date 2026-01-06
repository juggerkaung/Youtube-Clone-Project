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

import Model.*;
import Repository.*;


/**
 * Servlet implementation class AdminDashboardServlet
 */
@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminDashboardServlet() {
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
	        Channel admin = (Channel) session.getAttribute("admin");
	        
	        // Check if admin is logged in and has admin role
	        if (admin == null || admin.getRoleId() != 1) {
	            response.sendRedirect("adminLogin.jsp");
	            return;
	        }
	        
	        try {
	            String section = request.getParameter("section");
	            if (section == null || section.isEmpty()) {
	                section = "channels";
	            }
	            
	            System.out.println("AdminDashboardServlet: Loading section - " + section);
	            
	            // Load ALL data regardless of section so all sections work
	            ChannelRepository channelRepo = new ChannelRepository();
	            VideoRepository videoRepo = new VideoRepository();
	            SponsorVideoRepository sponsorVideoRepo = new SponsorVideoRepository();
	            
	            // Load channels
	            List<Channel> allChannels = channelRepo.getAllChannels();
	            System.out.println("AdminDashboardServlet: Loaded " + allChannels.size() + " channels");
	            
	            // Load videos
	            List<Video> allVideos = videoRepo.getAllVideos();
	            System.out.println("AdminDashboardServlet: Loaded " + allVideos.size() + " videos");
	            
	            // Load sponsor videos
	            List<SponsorVideo> allSponsorVideos = sponsorVideoRepo.getAllSponsorVideos();
	            System.out.println("AdminDashboardServlet: Loaded " + allSponsorVideos.size() + " sponsor videos");
	            
	            // Set all attributes
	            request.setAttribute("channels", allChannels);
	            request.setAttribute("videos", allVideos);
	            request.setAttribute("sponsorVideos", allSponsorVideos);
	            request.setAttribute("currentSection", section);
	            
	            // Calculate active users count
	            int activeCount = 0;
	            for (Channel channel : allChannels) {
	                if ("1".equals(channel.getIsActive())) {
	                    activeCount++;
	                }
	            }
	            request.setAttribute("activeCount", activeCount);
	            
	            request.getRequestDispatcher("admin.jsp").forward(request, response);
	            
	        } catch (Exception e) {
	            System.out.println("AdminDashboardServlet Error: " + e.getMessage());
	            e.printStackTrace();
	            response.sendRedirect("adminLogin.jsp?error=Error loading dashboard: " + e.getMessage());
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
