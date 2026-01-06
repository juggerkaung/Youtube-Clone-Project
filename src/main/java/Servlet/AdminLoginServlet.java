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
 * Servlet implementation class AdminLoginServlet
 */
@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminLoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
        response.sendRedirect("adminLogin.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	doGet(request, response);
		
		String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            ChannelRepository channelRepo = new ChannelRepository();
           // Channel admin = channelRepo.getChannelByEmail(email);
            Channel admin = channelRepo.getChannelByEmailForAdmin(email);
            // Check if user exists, password matches, is active, and has admin role (role_id = 1)
            if (admin != null && admin.getPassword().equals(password) && 
                "1".equals(admin.getIsActive()) && admin.getRoleId() == 1) {
                
                HttpSession session = request.getSession();
                session.setAttribute("admin", admin);
                response.sendRedirect("adminDashboard");
            } else {
                response.sendRedirect("adminLogin.jsp?error=Invalid credentials or insufficient privileges");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminLogin.jsp?error=Server error");
        }
   }}
