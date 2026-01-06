package Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import JDBCConnection.DBConnection;
import Model.VideoReaction;
import Service.CountSyncService;

public class VideoReactionRepository {
    
    // Get user's reaction for a video
    public String getUserReaction(int userId, int videoId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT reaction_type FROM video_reactions WHERE user_id = ? AND video_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, videoId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("reaction_type");
            }
        } catch (SQLException e) {
     //       System.out.println("Error getting user reaction: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    // Add or update reaction - FIXED VERSION
    public int setReaction(int userId, int videoId, String reactionType) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        
        // First, check if reaction exists
        String existingReaction = getUserReaction(userId, videoId);
        
        try {
            int result = 0;
            
            if (existingReaction == null) {
                // Insert new reaction
                String sql = "INSERT INTO video_reactions (user_id, video_id, reaction_type) VALUES (?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setInt(2, videoId);
                ps.setString(3, reactionType);
                result = ps.executeUpdate();
 //               System.out.println("VideoReactionRepository: Added new " + reactionType + " for video " + videoId + " by user " + userId);
            } else if (existingReaction.equals(reactionType)) {
                // Remove reaction if clicking the same button again
                result = removeReaction(userId, videoId);
     //           System.out.println("VideoReactionRepository: Removed " + reactionType + " for video " + videoId + " by user " + userId);
            } else {
                // Update reaction if switching between like/dislike
                String sql = "UPDATE video_reactions SET reaction_type = ? WHERE user_id = ? AND video_id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, reactionType);
                ps.setInt(2, userId);
                ps.setInt(3, videoId);
                result = ps.executeUpdate();
          //      System.out.println("VideoReactionRepository: Changed reaction from " + existingReaction + " to " + reactionType + " for video " + videoId);
            }
            
            // ALWAYS sync the counts with videos table
            if (result > 0) {
                syncReactionCounts(videoId);
            }
            
            return result;
            
        } catch (SQLException e) {
          //  System.out.println("Error setting reaction: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }

    // Remove reaction - FIXED VERSION
    public int removeReaction(int userId, int videoId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "DELETE FROM video_reactions WHERE user_id = ? AND video_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, videoId);
            int result = ps.executeUpdate();
            
            // ALWAYS sync the counts with videos table
            if (result > 0) {
                syncReactionCounts(videoId);
            }
            
            return result;
        } catch (SQLException e) {
       //     System.out.println("Error removing reaction: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }
    
    // Get like count for a video
    public int getLikeCount(int videoId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT COUNT(*) as count FROM video_reactions WHERE video_id = ? AND reaction_type = 'like'";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, videoId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
      //      System.out.println("Error getting like count: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }
    
    // Get dislike count for a video
    public int getDislikeCount(int videoId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT COUNT(*) as count FROM video_reactions WHERE video_id = ? AND reaction_type = 'dislike'";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, videoId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
  //          System.out.println("Error getting dislike count: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }
    
    // Sync reaction counts with videos table
    public void syncReactionCounts(int videoId) throws ClassNotFoundException {
        try {
            CountSyncService.syncVideoReactionCounts(videoId);
        } catch (Exception e) {
   //         System.out.println("VideoReactionRepository: Error syncing reaction counts: " + e.getMessage());
            e.printStackTrace();
        }
    }
}