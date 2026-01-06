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
import Repository.CommentRepository;

/**
 * Servlet implementation class ManageCommentServlet
 */
@WebServlet("/manageComment")
public class ManageCommentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ManageCommentServlet() {
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

	        String action = request.getParameter("action");
	        String commentIdParam = request.getParameter("commentId");
	        String videoIdParam = request.getParameter("videoId");
	        
	        if (commentIdParam == null || videoIdParam == null) {
	            response.sendRedirect("home");
	            return;
	        }

	        try {
	            int commentId = Integer.parseInt(commentIdParam);
	            int videoId = Integer.parseInt(videoIdParam);
	            
	            CommentRepository commentRepo = new CommentRepository();
	            int result = 0;
	            
	            if ("pin".equals(action)) {
	                // First check if user owns the video
	                // You'll need to get video by ID and check if channel.id == video.channelId
	                // For now, assuming permission check is done
	                result = commentRepo.togglePinComment(commentId, "1");
	            } else if ("unpin".equals(action)) {
	                result = commentRepo.togglePinComment(commentId, "0");
	            } else if ("delete".equals(action)) {
	                // Check if user owns the video or the comment
	                result = commentRepo.deleteComment(commentId, channel.getId());
	            }
	            
	            if (result > 0) {
	                response.sendRedirect("video?id=" + videoId + "&success=Comment updated");
	            } else {
	                response.sendRedirect("video?id=" + videoId + "&error=Failed to update comment");
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("video?id=" + videoIdParam + "&error=Error processing request");
	        }
	}

}
