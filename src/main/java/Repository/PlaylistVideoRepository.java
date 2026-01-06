package Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import JDBCConnection.DBConnection;
import Model.Video;

public class PlaylistVideoRepository {
    
    // Add video to playlist
    public int addVideoToPlaylist(int playlistId, int videoId) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        
        // First check if video is already in playlist
        String checkSql = "SELECT id FROM playlist_videos WHERE playlist_id = ? AND video_id = ?";
        String insertSql = "INSERT INTO playlist_videos (playlist_id, video_id) VALUES (?, ?)";
        
        try {
            // Check if already exists
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, playlistId);
            checkPs.setInt(2, videoId);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
             //   System.out.println("Video " + videoId + " already in playlist " + playlistId);
                return 0; // Already exists
            }
            
            // Insert new
            PreparedStatement insertPs = con.prepareStatement(insertSql);
            insertPs.setInt(1, playlistId);
            insertPs.setInt(2, videoId);
            
            row = insertPs.executeUpdate();
            
            if (row > 0) {
            //    System.out.println("Added video " + videoId + " to playlist " + playlistId);
            }
        } catch (SQLException e) {
          //  System.out.println("Error adding video to playlist: " + e.getMessage());
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
    
    // Remove video from playlist
    public int removeVideoFromPlaylist(int playlistId, int videoId) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        String sql = "DELETE FROM playlist_videos WHERE playlist_id = ? AND video_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, playlistId);
            ps.setInt(2, videoId);
            
            row = ps.executeUpdate();
            
            if (row > 0) {
                System.out.println("Removed video " + videoId + " from playlist " + playlistId);
            }
        } catch (SQLException e) {
          //  System.out.println("Error removing video from playlist: " + e.getMessage());
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
    
    // Get videos in playlist
    public List<Video> getVideosInPlaylist(int playlistId) throws ClassNotFoundException {
        List<Video> videos = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT v.*, c.display_name as channel_name, c.profile_picture as channel_profile_picture " +
                    "FROM playlist_videos pv " +
                    "JOIN videos v ON pv.video_id = v.id " +
                    "JOIN channels c ON v.channel_id = c.id " +
                    "WHERE pv.playlist_id = ? " +
                    "ORDER BY pv.added_at DESC";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, playlistId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Video video = new Video();
                video.setId(rs.getInt("id"));
                video.setChannelId(rs.getInt("channel_id"));
                video.setVideoTitle(rs.getString("video_title"));
                video.setVideoDescription(rs.getString("video_description"));
                video.setVideoUrl(rs.getString("video_url"));
                video.setThumbnail(rs.getString("thumbnail"));
                video.setDuration(rs.getInt("duration"));
                video.setViewsCount(rs.getLong("views_count"));
                video.setLikesCount(rs.getInt("likes_count"));
                video.setDislikeCount(rs.getInt("dislike_count"));
                video.setIsPublic(rs.getString("public"));
                video.setCreatedAt(rs.getTimestamp("created_at"));
                video.setUpdatedAt(rs.getTimestamp("updated_at"));
                video.setVideoType(rs.getString("video_type"));
                video.setChannelName(rs.getString("channel_name"));
                video.setChannelProfilePicture(rs.getString("channel_profile_picture"));
                
                videos.add(video);
            }
        } catch (SQLException e) {
         //   System.out.println("Error getting videos in playlist: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return videos;
    }
    
    // Check if video is in playlist
    public boolean isVideoInPlaylist(int playlistId, int videoId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT id FROM playlist_videos WHERE playlist_id = ? AND video_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, playlistId);
            ps.setInt(2, videoId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
        //    System.out.println("Error checking if video in playlist: " + e.getMessage());
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
    
    // Get video count in playlist
    public int getVideoCountInPlaylist(int playlistId) throws ClassNotFoundException {
        int count = 0;
        Connection con = DBConnection.getConnection();
        String sql = "SELECT COUNT(*) as count FROM playlist_videos WHERE playlist_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, playlistId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("count");
            }
        } catch (SQLException e) {
         //   System.out.println("Error getting video count in playlist: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return count;
    }
}