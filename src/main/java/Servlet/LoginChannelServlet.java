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
 * Servlet implementation class LoginChannelServlet
 */
@WebServlet("/loginChannel")
public class LoginChannelServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginChannelServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
				String email = request.getParameter("email");
				String password = request.getParameter("password");
				
				try {
					ChannelRepository channelRepo = new ChannelRepository();
					Channel channel = channelRepo.getChannelByEmail(email);
					
					if (channel != null && channel.getPassword().equals(password)) {
						// Check if channel is active
						if ("1".equals(channel.getIsActive())) {
							// Login successful
							HttpSession session = request.getSession();
							
							// GET FULL CHANNEL DATA INCLUDING PREMIUM STATUS
							Channel fullChannel = channelRepo.getChannelById(channel.getId());
							
							if (fullChannel == null) {
								// Fallback to basic channel data
								fullChannel = channel;
							}
							
							// Check if premium has expired and update if needed
							if ("1".equals(fullChannel.getIsPremium()) && fullChannel.getPremiumSince() != null) {
								channelRepo.checkAndUpdatePremiumExpiration(fullChannel.getId());
								
								// Get fresh data after potential expiration update
								fullChannel = channelRepo.getChannelById(fullChannel.getId());
							}
							
							// Set session with complete channel object
							session.setAttribute("channel", fullChannel);
							
							// Debug output
							System.out.println("=== Login Debug ===");
							System.out.println("Channel ID: " + fullChannel.getId());
							System.out.println("Premium Status: " + fullChannel.getIsPremium());
							System.out.println("Premium Since: " + fullChannel.getPremiumSince());
							System.out.println("Theme: " + fullChannel.getThemePreference());
							
							// Redirect based on role
							if (fullChannel.getRoleId() == 1) {
								response.sendRedirect("adminDashboard");
							} else {
								response.sendRedirect("home");
							}
						} else {
							// Channel is banned
							response.sendRedirect("login.jsp?error=Your channel has been banned. Please contact support.");
						}
					} else {
						response.sendRedirect("login.jsp?error=Invalid email or password");
					}
				} catch (Exception e) {
					e.printStackTrace();
					response.sendRedirect("login.jsp?error=Server error: " + e.getMessage());
				} } }
