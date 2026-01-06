package Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import JDBCConnection.DBConnection;
import Model.SponsorVideo;

public class SponsorVideoRepository {
    
    // Save new sponsor video
    public int saveSponsorVideo(SponsorVideo sponsorVideo) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        
        String sql = "INSERT INTO sponsor_videos (title, description, video_url, thumbnail, duration, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, sponsorVideo.getTitle());
            ps.setString(2, sponsorVideo.getDescription());
            ps.setString(3, sponsorVideo.getVideoUrl());
            ps.setString(4, sponsorVideo.getThumbnail());
            ps.setInt(5, sponsorVideo.getDuration());
            ps.setString(6, sponsorVideo.getIsActive() != null ? sponsorVideo.getIsActive() : "1");
            
            row = ps.executeUpdate();
            
            if (row > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    sponsorVideo.setId(generatedKeys.getInt(1));
                }
            }
            
            ps.close();
        } catch (SQLException e) {
        //    System.out.println("Error saving sponsor video: " + e.getMessage());
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
    
    // Get all sponsor videos
    public List<SponsorVideo> getAllSponsorVideos() throws ClassNotFoundException {
        List<SponsorVideo> sponsorVideos = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        
        String sql = "SELECT * FROM sponsor_videos ORDER BY created_at DESC";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                SponsorVideo sponsorVideo = new SponsorVideo();
                sponsorVideo.setId(rs.getInt("id"));
                sponsorVideo.setTitle(rs.getString("title"));
                sponsorVideo.setDescription(rs.getString("description"));
                sponsorVideo.setVideoUrl(rs.getString("video_url"));
                sponsorVideo.setThumbnail(rs.getString("thumbnail"));
                sponsorVideo.setDuration(rs.getInt("duration"));
                sponsorVideo.setIsActive(rs.getString("is_active"));
                sponsorVideo.setCreatedAt(rs.getTimestamp("created_at"));
                sponsorVideo.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                sponsorVideos.add(sponsorVideo);
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
        //    System.out.println("Error getting sponsor videos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return sponsorVideos;
    }
    
    // Delete sponsor video
    public int deleteSponsorVideo(int sponsorVideoId) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        
        String sql = "DELETE FROM sponsor_videos WHERE id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, sponsorVideoId);
            row = ps.executeUpdate();
            
            ps.close();
        } catch (SQLException e) {
   //         System.out.println("Error deleting sponsor video: " + e.getMessage());
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
}