package Servlet;

import java.io.IOException;


import java.util.List;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.Video;
import Repository.VideoRepository;

/**
 * Servlet implementation class HomeServlet
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public HomeServlet() {
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
		// response.getWriter().append("Served at: ").append(request.getContextPath());
		 try {
	            VideoRepository videoRepo = new VideoRepository();
	            List<Video> allVideos = videoRepo.getAllPublicVideos();
	            
	            System.out.println("HomeServlet: Found " + allVideos.size() + " public videos");
	            
	            // Separate regular videos and short videos
	            List<Video> regularVideos = new ArrayList<>();
	            List<Video> shortVideos = new ArrayList<>();
	            
	            for (Video video : allVideos) {
	                System.out.println("HomeServlet: Video '" + video.getVideoTitle() + "' - Type: " + video.getVideoType() + " - Duration: " + video.getDuration() + " seconds");
	                
	                // Use videoType to categorize
	                if ("short".equals(video.getVideoType())) {
	                    shortVideos.add(video);
	                    System.out.println("HomeServlet: Added to SHORT videos: " + video.getVideoTitle());
	                } else {
	                    regularVideos.add(video);
	                    System.out.println("HomeServlet: Added to REGULAR videos: " + video.getVideoTitle());
	                }
	            }
	            
	            // Shuffle both lists for random display
	            Collections.shuffle(regularVideos);
	            Collections.shuffle(shortVideos);
	            
	            System.out.println("HomeServlet: Regular videos count (randomized): " + regularVideos.size());
	            System.out.println("HomeServlet: Short videos count (randomized): " + shortVideos.size());
	            
	            // Limit the number of videos shown (optional)
	            int maxRegularVideos = 20;
	            int maxShortVideos = 12;
	            
	            if (regularVideos.size() > maxRegularVideos) {
	                regularVideos = regularVideos.subList(0, maxRegularVideos);
	            }
	            
	            if (shortVideos.size() > maxShortVideos) {
	                shortVideos = shortVideos.subList(0, maxShortVideos);
	            }
	            
	            request.setAttribute("regularVideos", regularVideos);
	            request.setAttribute("shortVideos", shortVideos);
	            
	            request.getRequestDispatcher("home.jsp").forward(request, response);
	            
	        } catch (Exception e) {
	            System.out.println("HomeServlet: Error - " + e.getMessage());
	            e.printStackTrace();
	            // Even if there's an error, still forward to home.jsp
	            request.getRequestDispatcher("home.jsp").forward(request, response);
	        }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
