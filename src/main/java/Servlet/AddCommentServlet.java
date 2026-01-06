package Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.Channel;
import Model.Comment;
import Repository.CommentRepository;

/**
 * Servlet implementation class AddCommentServlet
 */
@WebServlet("/addComment")
public class AddCommentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddCommentServlet() {
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
		        
		     //   if (channel == null) {
		     //       response.sendRedirect("login.jsp");
		     //       return; }
				/*
				 * if (channel == null || "0".equals(channel.getIsActive())) {
				 * response.sendRedirect("login.jsp?error=Your account is suspended"); return; }
				 */
		     // ONLY check if user is logged in, not if they're active
		        if (channel == null) {
		            response.sendRedirect("login.jsp");
		            return;
		        }
		        

		        String videoIdParam = request.getParameter("videoId");
		        String commentText = request.getParameter("commentText");
		        
		        if (videoIdParam == null || commentText == null || commentText.trim().isEmpty()) {
		            response.sendRedirect("home");
		            return;
		        }

		        try {
		            int videoId = Integer.parseInt(videoIdParam);
		            
		            Comment comment = new Comment();
		            comment.setUserId(channel.getId());
		            comment.setVideoId(videoId);
		            comment.setCommentText(commentText.trim());
		            
		            CommentRepository commentRepo = new CommentRepository();
		            commentRepo.saveComment(comment);
		            
		            response.sendRedirect("video?id=" + videoId);
		            
		        } catch (Exception e) {
		            e.printStackTrace();
		            response.sendRedirect("video?id=" + videoIdParam + "&error=Comment failed");
		        }
	}
}
