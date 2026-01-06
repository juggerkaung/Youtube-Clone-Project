package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Random;
import javax.servlet.http.HttpSession;
import Model.Channel;
import Model.SponsorVideo;
import Repository.ChannelRepository;
import Repository.SponsorVideoRepository;

/**
 * Servlet implementation class UpgradeServlet
 */
@WebServlet("/upgrade")
public class UpgradeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpgradeServlet() {
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
        
        // If already premium, redirect to home
        if ("1".equals(channel.getIsPremium())) {
            response.sendRedirect("home?message=Already%20Premium%20Member");
            return;
        }
        
        try {
            SponsorVideoRepository sponsorRepo = new SponsorVideoRepository();
            List<SponsorVideo> sponsorVideos = sponsorRepo.getAllSponsorVideos();
            
            // Filter only active sponsor videos
            List<SponsorVideo> activeVideos = sponsorVideos.stream()
                .filter(v -> "1".equals(v.getIsActive()))
                .toList();
            
         // Add this at the beginning of doGet method
            System.out.println("=== UpgradeServlet Debug ===");
            System.out.println("Channel ID: " + channel.getId());
            System.out.println("Channel Premium Status: " + channel.getIsPremium());
            System.out.println("Sponsor Videos Count: " + sponsorVideos.size());
            System.out.println("Active Sponsor Videos Count: " + activeVideos.size());
            
            if (activeVideos.isEmpty()) {
                System.out.println("No active sponsor videos found - upgrading directly");
                // No sponsor videos available, upgrade directly
                ChannelRepository channelRepo = new ChannelRepository();
                int result = channelRepo.upgradeToPremium(channel.getId());
                
                if (result > 0) {
                    // Get fresh channel data with updated premium status
                    Channel updatedChannel = channelRepo.getChannelById(channel.getId());
                    
                    // Update session
                    session.setAttribute("channel", updatedChannel);
                    
                    response.sendRedirect("home?message=Upgraded%20to%20premium%20successfully!");
                    return;
                } else {
                    response.sendRedirect("home?error=Failed%20to%20upgrade");
                    return;
                }
            }
            
            // Select a random sponsor video
            Random random = new Random();
            SponsorVideo randomVideo = activeVideos.get(random.nextInt(activeVideos.size()));
            
            request.setAttribute("sponsorVideo", randomVideo);
            request.getRequestDispatcher("watchSponsorVideo.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home?error=Error%20processing%20upgrade");
        }
    }
		
		

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	doGet(request, response);
		
		
		/*HttpSession session = request.getSession();
	        Channel channel = (Channel) session.getAttribute("channel");
	        
	        if (channel == null) {
	            response.sendRedirect("login.jsp");
	            return;
	        }
	        
	        String action = request.getParameter("action");
	        String sponsorVideoIdParam = request.getParameter("sponsorVideoId");
	        
	        if ("completeUpgrade".equals(action)) {
	            try {
	                ChannelRepository channelRepo = new ChannelRepository();
	                
	                // Record that the user watched this sponsor video
	                if (sponsorVideoIdParam != null) {
	                    int sponsorVideoId = Integer.parseInt(sponsorVideoIdParam);
	                    channelRepo.recordSponsorVideoWatch(channel.getId(), sponsorVideoId);
	                }
	                
	                // Upgrade to premium
	                int result = channelRepo.upgradeToPremium(channel.getId());
	                
	                if (result > 0) {
	                    // Get fresh channel data with updated premium status
	                    Channel updatedChannel = channelRepo.getChannelById(channel.getId());
	                    
	                    // Update session
	                    session.setAttribute("channel", updatedChannel);
	                    
	                    response.setStatus(200);
	                    response.getWriter().write("Upgraded to premium successfully!");
	                } else {
	                    response.setStatus(500);
	                    response.getWriter().write("Failed to upgrade to premium");
	                }
	            } catch (Exception e) {
	                e.printStackTrace();
	                response.setStatus(500);
	                response.getWriter().write("Server error");
	            }
	        } else if ("skip".equals(action)) {
	            response.setStatus(200);
	            response.getWriter().write("Upgrade skipped");
	        }
	    }*/
		
		    HttpSession session = request.getSession();
		    Channel channel = (Channel) session.getAttribute("channel");
		    
		    if (channel == null) {
		        response.sendRedirect("login.jsp");
		        return;
		    }
		    
		    try {
		        String action = request.getParameter("action");
		        String sponsorVideoIdParam = request.getParameter("sponsorVideoId");
		        
		        if ("completeUpgrade".equals(action) && sponsorVideoIdParam != null) {
		            int sponsorVideoId = Integer.parseInt(sponsorVideoIdParam);
		            
		            // Record that the channel watched this sponsor video
		            ChannelRepository channelRepo = new ChannelRepository();
		            channelRepo.recordSponsorVideoWatch(channel.getId(), sponsorVideoId);
		            
		            // Upgrade channel to premium
		            int result = channelRepo.upgradeToPremium(channel.getId());
		            
		            if (result > 0) {
		                // Refresh the channel in session
		                Channel updatedChannel = channelRepo.getChannelById(channel.getId());
		                session.setAttribute("channel", updatedChannel);
		                
		                // Redirect to success page instead of returning plain text
		                request.getRequestDispatcher("upgradeSuccess.jsp").forward(request, response);
		                return;
		            }
		        }
		        
		        // If something went wrong, redirect back
		        response.sendRedirect("watchSponsorVideo.jsp?error=Upgrade failed");
		        
		    } catch (Exception e) {
		        e.printStackTrace();
		        response.sendRedirect("watchSponsorVideo.jsp?error=" + e.getMessage());
		    }
	}}
