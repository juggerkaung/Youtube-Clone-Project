package Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import JDBCConnection.DBConnection;
import Model.Comment;

public class CommentRepository {
	
	// Pin/Unpin comment
	// In CommentRepository.java, update the togglePinComment method:
	public int togglePinComment(int commentId, String isPinned) throws ClassNotFoundException {
	    int row = 0;
	    Connection con = DBConnection.getConnection();
	    
	    try {
	        // First, get the video_id for this comment
	        String getVideoIdSql = "SELECT video_id FROM comments WHERE id = ?";
	        PreparedStatement getVideoIdPs = con.prepareStatement(getVideoIdSql);
	        getVideoIdPs.setInt(1, commentId);
	        ResultSet rs = getVideoIdPs.executeQuery();
	        
	        int videoId = 0;
	        if (rs.next()) {
	            videoId = rs.getInt("video_id");
	        }
	        
	        // First unpin any currently pinned comment for this video
	        if ("1".equals(isPinned) && videoId > 0) {
	            String unpinSql = "UPDATE comments SET is_pinned = '0' WHERE video_id = ? AND is_pinned = '1'";
	            PreparedStatement unpinPs = con.prepareStatement(unpinSql);
	            unpinPs.setInt(1, videoId);
	            unpinPs.executeUpdate();
	          //  System.out.println("CommentRepository: Unpinned previous pinned comment for video " + videoId);
	        }
	        
	        // Then pin/unpin the specific comment
	        String sql = "UPDATE comments SET is_pinned = ? WHERE id = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, isPinned);
	        ps.setInt(2, commentId);
	        
	        row = ps.executeUpdate();
	       //System.out.println("CommentRepository: Set comment " + commentId + " pinned status to " + isPinned);
	        
	    } catch (SQLException e) {
	       // System.out.println("Error toggling pin comment: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return row;
	}
	
	

		// Get pinned comment for a video
		public Comment getPinnedCommentByVideoId(int videoId) throws ClassNotFoundException {
		    Comment comment = null;
		    Connection con = DBConnection.getConnection();
		    String sql = "SELECT c.*, ch.display_name, ch.profile_picture " +
		                 "FROM comments c " +
		                 "JOIN channels ch ON c.user_id = ch.id " +
		                 "WHERE c.video_id = ? AND c.is_pinned = '1' " +
		                 "ORDER BY c.created_at DESC LIMIT 1";
		    
		    try {
		        PreparedStatement ps = con.prepareStatement(sql);
		        ps.setInt(1, videoId);
		        ResultSet rs = ps.executeQuery();
		        
		        if (rs.next()) {
		            comment = new Comment();
		            comment.setId(rs.getInt("id"));
		            comment.setUserId(rs.getInt("user_id"));
		            comment.setVideoId(rs.getInt("video_id"));
		            comment.setCommentText(rs.getString("comment_text"));
		            comment.setCreatedAt(rs.getTimestamp("created_at"));
		            comment.setUpdatedAt(rs.getTimestamp("updated_at"));
		            comment.setIsPinned(rs.getString("is_pinned"));
		            comment.setUserDisplayName(rs.getString("display_name"));
		            comment.setUserProfilePicture(rs.getString("profile_picture"));
		        }
		    } catch (SQLException e) {
		       // System.out.println("Error getting pinned comment: " + e.getMessage());
		        e.printStackTrace();
		    }
		    return comment;
		}

    
    // Get comments by video ID with user information
	// Update the getCommentsByVideoId method to order by pinned first
		// Repository/CommentRepository.java - Update getCommentsByVideoId method

		public List<Comment> getCommentsByVideoId(int videoId) throws ClassNotFoundException {
		    List<Comment> comments = new ArrayList<>();
		    Connection con = DBConnection.getConnection();
		    
		    // FIXED: Order by pinned first, then by created_at for non-pinned comments
		    String sql = "SELECT c.*, ch.display_name, ch.profile_picture " +
		                 "FROM comments c " +
		                 "JOIN channels ch ON c.user_id = ch.id " +
		                 "WHERE c.video_id = ? " +
		                 "ORDER BY " +
		                 "  CASE WHEN c.is_pinned = '1' THEN 0 ELSE 1 END, " +  // Pinned first (0), then non-pinned (1)
		                 "  c.created_at DESC";  // Most recent first within each group
		    
		    try {
		        PreparedStatement ps = con.prepareStatement(sql);
		        ps.setInt(1, videoId);
		        ResultSet rs = ps.executeQuery();
		        
		        while (rs.next()) {
		            Comment comment = new Comment();
		            comment.setId(rs.getInt("id"));
		            comment.setUserId(rs.getInt("user_id"));
		            comment.setVideoId(rs.getInt("video_id"));
		            comment.setCommentText(rs.getString("comment_text"));
		            comment.setCreatedAt(rs.getTimestamp("created_at"));
		            comment.setUpdatedAt(rs.getTimestamp("updated_at"));
		            comment.setIsPinned(rs.getString("is_pinned"));
		            comment.setUserDisplayName(rs.getString("display_name"));
		            comment.setUserProfilePicture(rs.getString("profile_picture"));
		            
		            comments.add(comment);
		        }
		    } catch (SQLException e) {
		     //   System.out.println("Error getting comments by video ID: " + e.getMessage());
		        e.printStackTrace();
		    }
		    return comments;
		}
    
    // Save new comment
    public int saveComment(Comment comment) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        String sql = "INSERT INTO comments (user_id, video_id, comment_text) VALUES (?, ?, ?)";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, comment.getUserId());
            ps.setInt(2, comment.getVideoId());
            ps.setString(3, comment.getCommentText());
            
            row = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error saving comment: " + e.getMessage());
            e.printStackTrace();
        }
        return row;
    }
    
    // Delete comment
    public int deleteComment(int commentId, int userId) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        String sql = "DELETE FROM comments WHERE id = ? AND user_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, commentId);
            ps.setInt(2, userId);
            
            row = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleting comment: " + e.getMessage());
            e.printStackTrace();
        }
        return row;
    }
    
    // Get comment count for a video
    public int getCommentCountByVideoId(int videoId) throws ClassNotFoundException {
        int count = 0;
        Connection con = DBConnection.getConnection();
        String sql = "SELECT COUNT(*) as count FROM comments WHERE video_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, videoId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("count");
            }
        } catch (SQLException e) {
         //   System.out.println("Error getting comment count: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }
    
    // Get comments by user ID
    public List<Comment> getCommentsByUserId(int userId) throws ClassNotFoundException {
        List<Comment> comments = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT c.*, v.video_title " +
                     "FROM comments c " +
                     "JOIN videos v ON c.video_id = v.id " +
                     "WHERE c.user_id = ? " +
                     "ORDER BY c.created_at DESC";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setVideoId(rs.getInt("video_id"));
                comment.setCommentText(rs.getString("comment_text"));
                comment.setCreatedAt(rs.getTimestamp("created_at"));
                comment.setUpdatedAt(rs.getTimestamp("updated_at"));
                comment.setUserDisplayName(rs.getString("video_title")); // Reusing for video title
                
                comments.add(comment);
            }
        } catch (SQLException e) {
         //   System.out.println("Error getting comments by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        return comments;
    }
}