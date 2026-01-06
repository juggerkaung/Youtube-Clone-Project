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
import Repository.SubscriptionRepository;

/**
 * Servlet implementation class SubscriptionsServlet
 */
@WebServlet("/subscriptions")
public class SubscriptionsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SubscriptionsServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
	
		 HttpSession session = request.getSession();
	        Channel channel = (Channel) session.getAttribute("channel");
	        
	        if (channel == null) {
	            response.sendRedirect("login.jsp");
	            return;
	        }

	        try {
	            SubscriptionRepository subscriptionRepo = new SubscriptionRepository();
	            
	            // Get channels that the current user is subscribed to
	            List<Channel> subscribedChannels = subscriptionRepo.getSubscribedChannels(channel.getId());
	            
	            request.setAttribute("subscribedChannels", subscribedChannels);
	            request.getRequestDispatcher("subscriptions.jsp").forward(request, response);
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("home?error=Error loading subscriptions");
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
