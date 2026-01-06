package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import JDBCConnection.DBConnection;
import Model.Channel;
import Model.SponsorVideo;
import Repository.SponsorVideoRepository;
import Util.VideoMetadataUtil;

/**
 * Servlet implementation class UploadSponsorVideoServlet
 */
@WebServlet("/uploadSponsorVideo")
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
	    maxFileSize = 1024L * 1024L * 1024L * 10L, // 10GB
	    maxRequestSize = 1024L * 1024L * 1024L * 10L // 10GB
	)
public class UploadSponsorVideoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UploadSponsorVideoServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	//	response.getWriter().append("Served at: ").append(request.getContextPath());
        response.sendRedirect("adminDashboard?section=sponsorVideos");

	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
		 HttpSession session = request.getSession();
	        Channel admin = (Channel) session.getAttribute("admin");
	        
	        if (admin == null || admin.getRoleId() != 1) {
	            response.sendRedirect("adminLogin.jsp");
	            return;
	        }
	        
	        Connection con = null;
	        try {
	            String title = request.getParameter("title");
	            String description = request.getParameter("description");
	            String isActive = request.getParameter("isActive");
	            
	            System.out.println("UploadSponsorVideoServlet: Starting upload...");
	            System.out.println("Title: " + title);
	            
	            if (title == null || title.trim().isEmpty()) {
	                response.sendRedirect("adminDashboard?section=sponsorVideos&error=Title is required");
	                return;
	            }
	            
	            // Handle video file upload
	            Part videoPart = request.getPart("videoFile");
	            if (videoPart == null || videoPart.getSize() == 0) {
	                response.sendRedirect("adminDashboard?section=sponsorVideos&error=Video file is required");
	                return;
	            }
	            
	            // Get application path
	            String appPath = request.getServletContext().getRealPath("");
	            String uploadPath = appPath + UPLOAD_DIR;
	            
	            // Create uploads directory if it doesn't exist
	            File uploadDir = new File(uploadPath);
	            if (!uploadDir.exists()) {
	                uploadDir.mkdirs();
	            }
	            
	            // Create sponsor_videos subdirectory
	            File sponsorVideosDir = new File(uploadPath + File.separator + "sponsor_videos");
	            File sponsorThumbnailsDir = new File(uploadPath + File.separator + "sponsor_thumbnails");
	            
	            if (!sponsorVideosDir.exists()) {
	                sponsorVideosDir.mkdirs();
	            }
	            if (!sponsorThumbnailsDir.exists()) {
	                sponsorThumbnailsDir.mkdirs();
	            }
	            
	            // Save video file
	            String videoFileName = System.currentTimeMillis() + "_" + getFileName(videoPart);
	            String videoPath = UPLOAD_DIR + "/sponsor_videos/" + videoFileName;
	            String videoFullPath = uploadPath + File.separator + "sponsor_videos" + File.separator + videoFileName;
	            videoPart.write(videoFullPath);
	            
	            // Auto-detect duration
	            File videoFile = new File(videoFullPath);
	            int duration = 0;
	            try {
	                duration = VideoMetadataUtil.getVideoDuration(videoFile);
	            } catch (Exception e) {
	                duration = 180; // Default 3 minutes
	            }
	            
	            // Handle thumbnail upload
	            String thumbnailPath = null;
	            Part thumbnailPart = request.getPart("thumbnail");
	            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
	                String thumbnailFileName = "thumb_" + System.currentTimeMillis() + "_" + getFileName(thumbnailPart);
	                thumbnailPath = UPLOAD_DIR + "/sponsor_thumbnails/" + thumbnailFileName;
	                String thumbnailFullPath = uploadPath + File.separator + "sponsor_thumbnails" + File.separator + thumbnailFileName;
	                thumbnailPart.write(thumbnailFullPath);
	            } else {
	                // Default thumbnail
	                thumbnailPath = "images/default-thumbnail.jpg";
	            }
	            
	            // Save to database using Repository
	            SponsorVideo sponsorVideo = new SponsorVideo();
	            sponsorVideo.setTitle(title.trim());
	            sponsorVideo.setDescription(description != null ? description.trim() : "");
	            sponsorVideo.setVideoUrl(videoPath);
	            sponsorVideo.setThumbnail(thumbnailPath);
	            sponsorVideo.setDuration(duration);
	            sponsorVideo.setIsActive(isActive != null ? "1" : "0");
	            
	            SponsorVideoRepository sponsorVideoRepo = new SponsorVideoRepository();
	            int result = sponsorVideoRepo.saveSponsorVideo(sponsorVideo);
	            
	            if (result > 0) {
	         //       response.sendRedirect("adminDashboard?section=sponsorVideos&success=Sponsor video uploaded successfully");
	         //   } else {
	         //       response.sendRedirect("adminDashboard?section=sponsorVideos&error=Failed to upload sponsor video");
	         //   }
	                // Clear any old session attributes that might interfere
	                session.removeAttribute("error");
	                session.removeAttribute("message");
	                
	                // Redirect to admin dashboard with sponsor videos section
	                response.sendRedirect("adminDashboard?section=sponsorVideos&success=Sponsor+video+uploaded+successfully");
	            } else {
	                response.sendRedirect("adminDashboard?section=sponsorVideos&error=Failed+to+upload+sponsor+video");
	            }  	
	            	
	            
	        } catch (Exception e) {
	            System.out.println("UploadSponsorVideoServlet Error: " + e.getMessage());
	            e.printStackTrace();
	            response.sendRedirect("adminDashboard?section=sponsorVideos&error=Upload error: " + e.getMessage());
	        }
	    }
	    
	    private String getFileName(Part part) {
	        String contentDisp = part.getHeader("content-disposition");
	        if (contentDisp != null) {
	            String[] tokens = contentDisp.split(";");
	            for (String token : tokens) {
	                if (token.trim().startsWith("filename")) {
	                    return token.substring(token.indexOf("=") + 2, token.length() - 1);
	                }
	            }
	        }
	        return "";
	    }
}
