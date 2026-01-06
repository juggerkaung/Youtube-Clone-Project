
package Servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
import Model.Video;
import Repository.VideoRepository;
import Service.CopyrightService;
import Util.VideoMetadataUtil;

@WebServlet("/uploadVideo")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024L * 1024L * 1024L * 10L, // 10GB
    maxRequestSize = 1024L * 1024L * 1024L * 10L // 10GB
)
public class UploadVideoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";
       
    public UploadVideoServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Channel channel = (Channel) session.getAttribute("channel");
        
        if (channel == null || channel.getRoleId() != 2) {
            response.sendRedirect("login.jsp");
            return;
        }
        
     // NEW: Check if channel is banned (isActive = '0')
        if ("0".equals(channel.getIsActive())) {
            response.sendRedirect("uploadVideo.jsp?error=Your channel has been banned and cannot upload new videos");
            return;
        }

        Connection con = null;
        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String isPublic = request.getParameter("isPublic");
            String videoType = request.getParameter("videoType");
            
            System.out.println("UploadVideoServlet: Starting upload process...");
            System.out.println("UploadVideoServlet: Title: " + title);
            System.out.println("UploadVideoServlet: Video Type: " + videoType);
            
            // Validate required fields
            if (title == null || title.trim().isEmpty()) {
                response.sendRedirect("uploadVideo.jsp?error=Title is required");
                return;
            }
            
            if (videoType == null || (!videoType.equals("regular") && !videoType.equals("short"))) {
                videoType = "regular";
            }
            
            // Handle video file upload
            Part videoPart = request.getPart("videoFile");
            if (videoPart == null || videoPart.getSize() == 0) {
                response.sendRedirect("uploadVideo.jsp?error=Video file is required");
                return;
            }
            
            // Get the original filename
            String originalVideoFileName = getFileName(videoPart);
            System.out.println("UploadVideoServlet: Original filename: " + originalVideoFileName);
            
            // Get application path
            String appPath = request.getServletContext().getRealPath("");
            System.out.println("UploadVideoServlet: App Path: " + appPath);
            
            // Create uploads directory in webapp if it doesn't exist
            String uploadPath = appPath + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
                System.out.println("UploadVideoServlet: Created upload directory: " + uploadPath);
            }
            
            // Create videos and thumbnails subdirectories
            File videosDir = new File(uploadPath + File.separator + "videos");
            File thumbnailsDir = new File(uploadPath + File.separator + "thumbnails");
            if (!videosDir.exists()) {
                videosDir.mkdirs();
                System.out.println("UploadVideoServlet: Created videos directory: " + videosDir.getAbsolutePath());
            }
            if (!thumbnailsDir.exists()) {
                thumbnailsDir.mkdirs();
                System.out.println("UploadVideoServlet: Created thumbnails directory: " + thumbnailsDir.getAbsolutePath());
            }
            
            String cleanVideoFileName = cleanFileName(originalVideoFileName);
            String videoFileName = System.currentTimeMillis() + "_" + cleanVideoFileName;
            String videoPath = UPLOAD_DIR + "/videos/" + videoFileName;
            String videoFullPath = uploadPath + File.separator + "videos" + File.separator + videoFileName;
            
            // Save video file
            videoPart.write(videoFullPath);
            System.out.println("UploadVideoServlet: Video saved to: " + videoFullPath);
            
            // Auto-detect duration from the uploaded video file
            File videoFile = new File(videoFullPath);
            int duration = 0;
            try {
                duration = VideoMetadataUtil.getVideoDuration(videoFile);
                System.out.println("UploadVideoServlet: Auto-detected duration: " + duration + " seconds");
            } catch (Exception e) {
                System.out.println("UploadVideoServlet: Error detecting duration, using default: " + e.getMessage());
                duration = 180; // Default to 3 minutes if detection fails
            }
            
            // Handle thumbnail upload
            String thumbnailPath = null;
            Part thumbnailPart = request.getPart("thumbnail");
            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
                String thumbnailFileName = "thumb_" + System.currentTimeMillis() + "_" + getFileName(thumbnailPart);
                thumbnailPath = UPLOAD_DIR + "/thumbnails/" + thumbnailFileName;
                String thumbnailFullPath = uploadPath + File.separator + "thumbnails" + File.separator + thumbnailFileName;
                thumbnailPart.write(thumbnailFullPath);
                System.out.println("UploadVideoServlet: Thumbnail saved to: " + thumbnailFullPath);
            } else {
                // Set a default thumbnail path if no thumbnail uploaded
                thumbnailPath = "images/default-thumbnail.jpg";
                System.out.println("UploadVideoServlet: Using default thumbnail");
            }
            
            // Save to database
            con = DBConnection.getConnection();
            String insertSql = "INSERT INTO videos (channel_id, video_title, video_description, video_url, thumbnail, duration, public, video_type, views_count, original_filename) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, channel.getId());
            ps.setString(2, title.trim());
            ps.setString(3, description != null ? description.trim() : "");
            ps.setString(4, videoPath);
            ps.setString(5, thumbnailPath);
            ps.setInt(6, duration);
            ps.setString(7, isPublic != null ? "1" : "0");
            ps.setString(8, videoType);
            ps.setLong(9, 0);
            ps.setString(10, originalVideoFileName); // Set original filename
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get the generated video ID
                ResultSet generatedKeys = ps.getGeneratedKeys();
                int savedVideoId = 0;
                if (generatedKeys.next()) {
                    savedVideoId = generatedKeys.getInt(1);
                    System.out.println("UploadVideoServlet: Video saved with ID: " + savedVideoId);
                    
                    // Run copyright checks
                    try {
                        System.out.println("UploadVideoServlet: Starting copyright checks...");
                        VideoRepository videoRepo = new VideoRepository();
                        Video savedVideo = videoRepo.getVideoById(savedVideoId);
                        
                        if (savedVideo != null) {
                            System.out.println("UploadVideoServlet: Found saved video, running copyright checks...");
                            CopyrightService.runCopyrightChecks(savedVideo);
                        } else {
                            System.out.println("UploadVideoServlet: Could not retrieve saved video for copyright checks");
                        }
                    } catch (Exception e) {
                        System.out.println("UploadVideoServlet: Error during copyright checks: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    System.out.println("UploadVideoServlet: Could not retrieve generated video ID");
                }
                generatedKeys.close();
                
                response.sendRedirect("channelDashboard?success=Video uploaded successfully");
            } else {
                response.sendRedirect("uploadVideo.jsp?error=Upload failed - database error");
            }
            
            ps.close();
            
        } catch (Exception e) {
            System.out.println("UploadVideoServlet: Error during upload: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("uploadVideo.jsp?error=Upload error: " + e.getMessage());
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    private String cleanFileName(String fileName) {
        String cleanName = new File(fileName).getName();
        cleanName = cleanName.replaceAll("\\s+", "_");
        cleanName = cleanName.replaceAll("[^a-zA-Z0-9._-]", "");
        return cleanName;
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