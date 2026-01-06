package Servlet;

/*import java.io.IOException;*/


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.Channel;
import Repository.SubscriptionRepository;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class SubscribeServlet
 */
@WebServlet("/subscribe")
public class SubscribeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SubscribeServlet() {
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
		// doGet(request, response);
		        HttpSession session = request.getSession();
		        Channel channel = (Channel) session.getAttribute("channel");
		        
		        if (channel == null) {
		            response.sendRedirect("login.jsp");
		            return;
		        }

		        String videoId = request.getParameter("videoId");
		        String channelIdParam = request.getParameter("channelId");
		        
		        if (channelIdParam == null) {
		            response.sendRedirect("video?id=" + videoId + "&error=Channel not found");
		            return;
		        }

		        try {
		            int targetChannelId = Integer.parseInt(channelIdParam);
		            
		            // Don't allow subscribing to own channel
		            if (channel.getId() == targetChannelId) {
		                response.sendRedirect("video?id=" + videoId + "&error=Cannot subscribe to your own channel");
		                return;
		            }

		            SubscriptionRepository subscriptionRepo = new SubscriptionRepository();
		            
		            if (subscriptionRepo.isSubscribed(channel.getId(), targetChannelId)) {
		                // Unsubscribe
		                subscriptionRepo.unsubscribe(channel.getId(), targetChannelId);
		            } else {
		                // Subscribe
		                subscriptionRepo.subscribe(channel.getId(), targetChannelId);
		            }
		            
		            response.sendRedirect("video?id=" + videoId);
		            
		        } catch (Exception e) {
		            e.printStackTrace();
		            response.sendRedirect("video?id=" + videoId + "&error=Subscription failed");
		        }
		}

}
