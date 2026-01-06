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
import Repository.SponsorVideoRepository;

/**
 * Servlet implementation class DeleteSponsorVideoServlet
 */
@WebServlet("/deleteSponsorVideo")
public class DeleteSponsorVideoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteSponsorVideoServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
        doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	doGet(request, response);
		 HttpSession session = request.getSession();
	        Channel admin = (Channel) session.getAttribute("admin");
	        
	        if (admin == null || admin.getRoleId() != 1) {
	            response.sendRedirect("adminLogin.jsp");
	            return;
	        }
	        
	        String sponsorVideoIdParam = request.getParameter("id");
	        if (sponsorVideoIdParam == null) {
	            response.sendRedirect("adminDashboard?section=sponsorVideos&error=No video specified");
	            return;
	        }
	        
	        try {
	            int sponsorVideoId = Integer.parseInt(sponsorVideoIdParam);
	            SponsorVideoRepository sponsorVideoRepo = new SponsorVideoRepository();
	            int result = sponsorVideoRepo.deleteSponsorVideo(sponsorVideoId);
	            
	            if (result > 0) {
	                response.sendRedirect("adminDashboard?section=sponsorVideos&success=Sponsor video deleted");
	            } else {
	                response.sendRedirect("adminDashboard?section=sponsorVideos&error=Failed to delete sponsor video");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("adminDashboard?section=sponsorVideos&error=" + e.getMessage());
	        }
	    }
}
