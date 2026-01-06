package Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import JDBCConnection.DBConnection;
import Model.Video;
import Repository.VideoRepository;

public class CopyrightService {
    
    public static void runCopyrightChecks(Video newVideo) throws Exception {
        if (newVideo == null) return;

		/*
		 * System.out.println("CopyrightService: ===== STARTING COPYRIGHT CHECKS ====="
		 * ); System.out.println("CopyrightService: Checking video ID: " +
		 * newVideo.getId()); System.out.println("CopyrightService: Title: " +
		 * newVideo.getVideoTitle());
		 * System.out.println("CopyrightService: Description: " +
		 * newVideo.getVideoDescription()); System.out.println("CopyrightService: URL: "
		 * + newVideo.getVideoUrl());
		 * System.out.println("CopyrightService: Original Filename: " +
		 * newVideo.getOriginalFilename());
		 * System.out.println("CopyrightService: Channel ID: " +
		 * newVideo.getChannelId());
		 */
        checkCopyrightClaims(newVideo);
        checkCopyrightStrikeByFilename(newVideo);
        
 //       System.out.println("CopyrightService: ===== COPYRIGHT CHECKS COMPLETED =====");
    }
    
    public static void checkCopyrightClaims(Video newVideo) throws Exception {
   //     System.out.println("CopyrightService: --- Checking for Copyright Claims ---");
        
        if (newVideo.getVideoTitle() == null || newVideo.getVideoDescription() == null) {
            System.out.println("CopyrightService: Skipping claim check - title or description is null");
            return;
        }
        
        VideoRepository videoRepo = new VideoRepository();
        List<Video> allVideos = videoRepo.getAllPublicVideos();
        
//        System.out.println("CopyrightService: Total public videos to check: " + allVideos.size());
        
        boolean claimFound = false;
        
        for (Video existingVideo : allVideos) {
            // Skip if same channel or same video
            if (existingVideo.getChannelId() == newVideo.getChannelId()) {
           //     System.out.println("CopyrightService: Skipping - same channel (ID: " + existingVideo.getChannelId() + ")");
                continue;
            }
            
            if (existingVideo.getId() == newVideo.getId()) {
   //             System.out.println("CopyrightService: Skipping - same video (ID: " + existingVideo.getId() + ")");
                continue;
            }
            
            // Normalize strings for comparison
            String newTitle = newVideo.getVideoTitle().trim().toLowerCase();
            String newDesc = newVideo.getVideoDescription() != null ? 
                           newVideo.getVideoDescription().trim().toLowerCase() : "";
            
            String existingTitle = existingVideo.getVideoTitle() != null ? 
                                 existingVideo.getVideoTitle().trim().toLowerCase() : "";
            String existingDesc = existingVideo.getVideoDescription() != null ? 
                                existingVideo.getVideoDescription().trim().toLowerCase() : "";
            
            System.out.println("CopyrightService: Comparing with video ID " + existingVideo.getId() + ":");
            System.out.println("CopyrightService:   New Title: '" + newTitle + "'");
            System.out.println("CopyrightService:   Existing Title: '" + existingTitle + "'");
            System.out.println("CopyrightService:   New Desc: '" + newDesc.substring(0, Math.min(newDesc.length(), 50)) + "...'");
            System.out.println("CopyrightService:   Existing Desc: '" + existingDesc.substring(0, Math.min(existingDesc.length(), 50)) + "...'");
            
            // Check for similar title and description
            boolean titleMatch = newTitle.equals(existingTitle);
            boolean descMatch = newDesc.equals(existingDesc);
            
            if (titleMatch && descMatch) {
       //         System.out.println("CopyrightService: ⚠️ FOUND COPYRIGHT CLAIM!");
        //        System.out.println("CopyrightService:   Title Match: YES");
       //         System.out.println("CopyrightService:   Description Match: YES");
                
                claimFound = true;
                
                // Mark new video with copyright claim
                markCopyrightClaim(newVideo.getId(), existingVideo.getId(), 
                    "Copyright claim: Same title and description as video ID " + existingVideo.getId() + " - '" + existingVideo.getVideoTitle() + "'");
                
                // Also mark existing video if it doesn't have a claim yet
                if ("none".equals(existingVideo.getCopyrightStatus())) {
       //             System.out.println("CopyrightService: Marking existing video " + existingVideo.getId() + " with claim");
                    markCopyrightClaim(existingVideo.getId(), newVideo.getId(),
                        "Copyright claim: Your video content has been used by channel ID " + newVideo.getChannelId());
                }
                break; // Found a claim, no need to check further
            } else {
       //         System.out.println("CopyrightService:   No claim - Title Match: " + titleMatch + ", Desc Match: " + descMatch);
            }
        }
        
        if (!claimFound) {
 //           System.out.println("CopyrightService: No copyright claims found");
        }
    }
    
    // NEW: Check for copyright strike by filename
    public static void checkCopyrightStrikeByFilename(Video video) throws Exception {
   //     System.out.println("CopyrightService: --- Checking for Copyright Strikes (by filename) ---");
        
        if (video == null || video.getOriginalFilename() == null) {
  //          System.out.println("CopyrightService: Skipping strike check - original filename is null");
            return;
        }
        
  //      System.out.println("CopyrightService: Looking for videos with filename: " + video.getOriginalFilename());
        
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT id, channel_id, video_title FROM videos WHERE original_filename = ? AND channel_id != ? AND id != ?";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, video.getOriginalFilename());
            ps.setInt(2, video.getChannelId());
            ps.setInt(3, video.getId());
            ResultSet rs = ps.executeQuery();
            
            boolean strikeFound = false;
            
            while (rs.next()) {
                strikeFound = true;
                int existingVideoId = rs.getInt("id");
                int existingChannelId = rs.getInt("channel_id");
                String existingTitle = rs.getString("video_title");
                
				/*
				 * System.out.println("CopyrightService: ⛔ FOUND COPYRIGHT STRIKE!");
				 * System.out.println("CopyrightService:   Existing video ID: " +
				 * existingVideoId);
				 * System.out.println("CopyrightService:   Existing video title: " +
				 * existingTitle);
				 * System.out.println("CopyrightService:   Existing channel ID: " +
				 * existingChannelId);
				 */
                // Mark new video with copyright strike
                markCopyrightStrike(video.getId(), existingVideoId,
                    "Copyright strike: Duplicate filename detected - This file ('" + video.getOriginalFilename() + "') was already uploaded by another channel in video ID " + existingVideoId + " - '" + existingTitle + "'");
                
                // Mark existing video if it doesn't have a strike yet
                if (!hasCopyrightStrike(existingVideoId)) {
                    markCopyrightClaim(existingVideoId, video.getId(),
                        "Copyright claim: Your video file ('" + video.getOriginalFilename() + "') has been used by channel ID " + video.getChannelId());
                }
            }
            
            if (!strikeFound) {
//                System.out.println("CopyrightService: No copyright strikes found (by filename)");
            }
            
            rs.close();
            ps.close();
            
        } catch (SQLException e) {
//            System.out.println("CopyrightService: Error checking strike by filename: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private static void markCopyrightClaim(int videoId, int sourceVideoId, String reason) throws Exception {
		/*
		 * System.out.println("CopyrightService: Marking claim for video " + videoId);
		 * System.out.println("CopyrightService: Source video: " + sourceVideoId);
		 * System.out.println("CopyrightService: Reason: " + reason);
		 */
        
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE videos SET copyright_status = 'claim', copyright_reason = ?, copyright_video_id = ? WHERE id = ?";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, reason);
            ps.setInt(2, sourceVideoId);
            ps.setInt(3, videoId);
            int rows = ps.executeUpdate();
            
 //           System.out.println("CopyrightService: Claim update result: " + rows + " row(s) affected");
            
            ps.close();
            
        } catch (SQLException e) {
 //           System.out.println("CopyrightService: Error marking claim: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private static void markCopyrightStrike(int videoId, int sourceVideoId, String reason) throws Exception {
 //       System.out.println("CopyrightService: ⛔⛔⛔ MARKING STRIKE for video " + videoId);
        
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            
            // First mark as strike
            String sql = "UPDATE videos SET copyright_status = 'strike', copyright_reason = ?, copyright_video_id = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, reason);
            ps.setInt(2, sourceVideoId);
            ps.setInt(3, videoId);
            int rows = ps.executeUpdate();
            
//            System.out.println("CopyrightService: Strike update result: " + rows + " row(s) affected");
            ps.close();
            
            // Then make video private
            String privateSql = "UPDATE videos SET public = '0' WHERE id = ?";
            PreparedStatement privatePs = con.prepareStatement(privateSql);
            privatePs.setInt(1, videoId);
            privatePs.executeUpdate();
            privatePs.close();
            
//            System.out.println("CopyrightService: Video " + videoId + " set to private");
            
        } catch (SQLException e) {
 //           System.out.println("CopyrightService: Error marking strike: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private static boolean hasCopyrightStrike(int videoId) throws Exception {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT copyright_status FROM videos WHERE id = ?";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, videoId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("copyright_status");
                return "strike".equals(status);
            }
        } catch (SQLException e) {
//            System.out.println("CopyrightService: Error checking strike: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}