package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import JDBCConnection.DBConnection;
import Model.Video;
import Repository.VideoRepository;
import Service.CopyrightService;

/**
 * Servlet implementation class DebugCopyrightServlet
 */
@WebServlet("/debugCopyright")
public class DebugCopyrightServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DebugCopyrightServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		 
		try {
            response.getWriter().println("<h2>Debug Copyright System</h2>");
            response.getWriter().println("<hr>");
            
            // Check database structure
            response.getWriter().println("<h3>1. Database Structure Check:</h3>");
            checkDatabaseStructure(response);
            
            // Check for duplicate titles/descriptions
            response.getWriter().println("<h3>2. Check for Copyright Claims (same title & description):</h3>");
            checkDuplicateTitleDescription(response);
            
            // Check for duplicate original filenames
            response.getWriter().println("<h3>3. Check for Copyright Strikes (same original_filename):</h3>");
            checkDuplicateOriginalFilenames(response);
            
            // Test manual copyright check
            String testVideoId = request.getParameter("testVideoId");
            if (testVideoId != null) {
                response.getWriter().println("<h3>4. Manual Copyright Check for Video ID " + testVideoId + ":</h3>");
                testManualCopyrightCheck(response, Integer.parseInt(testVideoId));
            }
            
            response.getWriter().println("<hr>");
            response.getWriter().println("<h4>Test Copyright Detection:</h4>");
            response.getWriter().println("<form method='GET'>");
            response.getWriter().println("Test Video ID: <input type='text' name='testVideoId'>");
            response.getWriter().println("<input type='submit' value='Test'>");
            response.getWriter().println("</form>");
            
        } catch (Exception e) {
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
            e.printStackTrace(response.getWriter());
        }
    }
    
    private void checkDatabaseStructure(HttpServletResponse response) throws Exception {
        Connection con = DBConnection.getConnection();
        try {
            // Check if copyright columns exist
            String[] columns = {"copyright_status", "copyright_reason", "copyright_video_id", "original_filename"};
            
            for (String column : columns) {
                String sql = "SHOW COLUMNS FROM videos LIKE ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, column);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    response.getWriter().println("<p style='color: green;'>✓ Column '" + column + "' exists</p>");
                } else {
                    response.getWriter().println("<p style='color: red;'>✗ Column '" + column + "' DOES NOT EXIST</p>");
                }
                rs.close();
                ps.close();
            }
            
        } catch (Exception e) {
            response.getWriter().println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (con != null) con.close();
        }
    }
    
    private void checkDuplicateTitleDescription(HttpServletResponse response) throws Exception {
        Connection con = DBConnection.getConnection();
        try {
            String sql = "SELECT v1.id as vid1, v1.video_title as title1, v1.channel_id as chan1, " +
                        "v2.id as vid2, v2.video_title as title2, v2.channel_id as chan2 " +
                        "FROM videos v1 " +
                        "JOIN videos v2 ON v1.video_title = v2.video_title " +
                        "AND v1.video_description = v2.video_description " +
                        "AND v1.id != v2.id " +
                        "AND v1.channel_id != v2.channel_id " +
                        "WHERE v1.copyright_status = 'none' OR v1.copyright_status IS NULL";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                count++;
                response.getWriter().println("<p>Found duplicate title/description:</p>");
                response.getWriter().println("<ul>");
                response.getWriter().println("<li>Video 1: ID=" + rs.getInt("vid1") + ", Title='" + rs.getString("title1") + "', Channel=" + rs.getInt("chan1") + "</li>");
                response.getWriter().println("<li>Video 2: ID=" + rs.getInt("vid2") + ", Title='" + rs.getString("title2") + "', Channel=" + rs.getInt("chan2") + "</li>");
                response.getWriter().println("</ul>");
            }
            
            if (count == 0) {
                response.getWriter().println("<p style='color: green;'>No duplicate titles/descriptions found</p>");
            } else {
                response.getWriter().println("<p style='color: orange;'>Found " + count + " potential copyright claim(s)</p>");
            }
            
            rs.close();
            ps.close();
            
        } catch (Exception e) {
            response.getWriter().println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (con != null) con.close();
        }
    }
    
    private void checkDuplicateOriginalFilenames(HttpServletResponse response) throws Exception {
        Connection con = DBConnection.getConnection();
        try {
            String sql = "SELECT original_filename, COUNT(*) as count, GROUP_CONCAT(id) as video_ids, " +
                        "GROUP_CONCAT(channel_id) as channel_ids " +
                        "FROM videos " +
                        "WHERE original_filename IS NOT NULL AND original_filename != '' " +
                        "GROUP BY original_filename " +
                        "HAVING count > 1";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                count++;
                response.getWriter().println("<p>Found duplicate original filename:</p>");
                response.getWriter().println("<ul>");
                response.getWriter().println("<li>Original Filename: " + rs.getString("original_filename") + "</li>");
                response.getWriter().println("<li>Count: " + rs.getInt("count") + "</li>");
                response.getWriter().println("<li>Video IDs: " + rs.getString("video_ids") + "</li>");
                response.getWriter().println("<li>Channel IDs: " + rs.getString("channel_ids") + "</li>");
                response.getWriter().println("</ul>");
            }
            
            if (count == 0) {
                response.getWriter().println("<p style='color: green;'>No duplicate original filenames found</p>");
            } else {
                response.getWriter().println("<p style='color: orange;'>Found " + count + " potential copyright strike(s)</p>");
            }
            
            rs.close();
            ps.close();
            
        } catch (Exception e) {
            response.getWriter().println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (con != null) con.close();
        }
    }
    
    private void testManualCopyrightCheck(HttpServletResponse response, int videoId) throws Exception {
        VideoRepository videoRepo = new VideoRepository();
        Video video = videoRepo.getVideoById(videoId);
        
        if (video == null) {
            response.getWriter().println("<p style='color: red;'>Video not found with ID: " + videoId + "</p>");
            return;
        }
        
        response.getWriter().println("<p>Video Details:</p>");
        response.getWriter().println("<ul>");
        response.getWriter().println("<li>ID: " + video.getId() + "</li>");
        response.getWriter().println("<li>Title: " + video.getVideoTitle() + "</li>");
        response.getWriter().println("<li>Description: " + video.getVideoDescription() + "</li>");
        response.getWriter().println("<li>URL: " + video.getVideoUrl() + "</li>");
        response.getWriter().println("<li>Original Filename: " + video.getOriginalFilename() + "</li>");
        response.getWriter().println("<li>Channel ID: " + video.getChannelId() + "</li>");
        response.getWriter().println("<li>Current Copyright Status: " + video.getCopyrightStatus() + "</li>");
        response.getWriter().println("</ul>");
        
        // Run copyright checks manually
        response.getWriter().println("<p>Running Copyright Checks...</p>");
        
        CopyrightService.checkCopyrightClaims(video);
        CopyrightService.checkCopyrightStrikeByFilename(video); // Changed this line
        
        // Refresh video data
        video = videoRepo.getVideoById(videoId);
        
        response.getWriter().println("<p>After Copyright Checks:</p>");
        response.getWriter().println("<ul>");
        response.getWriter().println("<li>Copyright Status: " + video.getCopyrightStatus() + "</li>");
        response.getWriter().println("<li>Copyright Reason: " + video.getCopyrightReason() + "</li>");
        response.getWriter().println("<li>Copyright Video ID: " + video.getCopyrightVideoId() + "</li>");
        response.getWriter().println("</ul>");
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
	}

}
