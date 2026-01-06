
package Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import JDBCConnection.DBConnection;
import Model.Channel;
import Repository.ChannelRepository;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class RegisterChannelServlet
 */
@WebServlet("/registerChannel")
public class RegisterChannelServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	   
    // Email validation patterns
    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@gmail\\.com$";
    private static final Pattern emailPattern = Pattern.compile(EMAIL_PATTERN);
    
    // Password validation pattern: 8-20 chars, at least one letter and one number
    private static final String PASSWORD_PATTERN = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*?&]{8,20}$";
    private static final Pattern passwordPattern = Pattern.compile(PASSWORD_PATTERN);
       
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterChannelServlet() {
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
		 String email = request.getParameter("email");
	        String password = request.getParameter("password");
	        String displayName = request.getParameter("displayName");
	        String description = request.getParameter("description");
	        
	        HttpSession session = request.getSession();
	        
	        // Step 1: Validate email format
	        if (email == null || email.trim().isEmpty()) {
	            response.sendRedirect("register.jsp?error=Email is required");
	            return;
	        }
	        
	        if (!emailPattern.matcher(email).matches()) {
	            response.sendRedirect("register.jsp?error=Email must be a valid Gmail address (ending with @gmail.com)");
	            return;
	        }
	        
	        // Check email length
	        if (email.length() < 10 || email.length() > 30) {
	            response.sendRedirect("register.jsp?error=Email must be between 10 and 30 characters long");
	            return;
	        }
	        
	        // Step 2: Validate password
	        if (password == null || password.trim().isEmpty()) {
	            response.sendRedirect("register.jsp?error=Password is required");
	            return;
	        }
	        
	        if (!passwordPattern.matcher(password).matches()) {
	            response.sendRedirect("register.jsp?error=Password must be 8-20 characters long and contain at least one letter and one number");
	            return;
	        }
	        
	        // Step 3: Validate display name
	        if (displayName == null || displayName.trim().isEmpty()) {
	            response.sendRedirect("register.jsp?error=Channel name is required");
	            return;
	        }
	        
	        if (displayName.length() < 3 || displayName.length() > 50) {
	            response.sendRedirect("register.jsp?error=Channel name must be between 3 and 50 characters long");
	            return;
	        }
	        
	        try {
	            ChannelRepository channelRepo = new ChannelRepository();
	            
	            // Step 4: Check if email already exists
	            Channel existingEmail = channelRepo.getChannelByEmail(email);
	            if (existingEmail != null) {
	                response.sendRedirect("register.jsp?error=Email already exists. Please use a different email.");
	                return;
	            }
	            
	            // Step 5: Check if display name already exists
	          //  if (isDisplayNameExists(channelRepo, displayName)) {
	          //     response.sendRedirect("register.jsp?error=Channel name already taken. Please choose a different name.");
	          //      return;
	           // }
	            if (channelRepo.isDisplayNameExists(displayName)) {
	                response.sendRedirect("register.jsp?error=Channel name '" + displayName + "' is already taken. Please choose a different name.");
	                return;
	            }
	            
	            
	            // Step 6: Create new channel
	            Channel channel = new Channel();
	            channel.setEmail(email);
	            channel.setPassword(password); // In real app, you should hash this password
	            channel.setDisplayName(displayName);
	            channel.setDescription(description);
	            channel.setRoleId(2); // Channel role
	            channel.setIsActive("1");
	            
	            int result = channelRepo.saveChannel(channel);
	            
	            if (result > 0) {
	                response.sendRedirect("login.jsp?success=Channel created successfully! Please login.");
	            } else {
	                response.sendRedirect("register.jsp?error=Registration failed. Please try again.");
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("register.jsp?error=Server error: " + e.getMessage());
	        }
	    }
	    
	    // Helper method to check if display name exists
		/*
		 * private boolean isDisplayNameExists(ChannelRepository repo, String
		 * displayName) throws Exception { // Get all active channels and check for
		 * display name java.util.List<Channel> allChannels =
		 * repo.getAllActiveChannels(); for (Channel channel : allChannels) { if
		 * (channel.getDisplayName().equalsIgnoreCase(displayName.trim())) { return
		 * true; } } return false; }
		 */
	// Repository/ChannelRepository.java - Add this method

	public boolean isDisplayNameExists(String displayName) throws ClassNotFoundException {
	    Connection con = DBConnection.getConnection();
	    String sql = "SELECT COUNT(*) as count FROM channels WHERE LOWER(display_name) = LOWER(?) AND is_active = '1'";
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, displayName.trim());
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            return rs.getInt("count") > 0;
	        }
	    } catch (SQLException e) {
	        System.out.println("Error checking display name: " + e.getMessage());
	        e.printStackTrace();
	    }
	    return false;
	}}
