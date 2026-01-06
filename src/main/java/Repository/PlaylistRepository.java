package Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import JDBCConnection.DBConnection;
import Model.Playlist;
import Model.Video;

public class PlaylistRepository {
    
    // Create new playlist
    public int createPlaylist(Playlist playlist) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        String sql = "INSERT INTO playlists (channel_id, name, description, is_public) VALUES (?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, playlist.getChannelId());
            ps.setString(2, playlist.getName());
            ps.setString(3, playlist.getDescription());
            ps.setString(4, playlist.getIsPublic());
            
            row = ps.executeUpdate();
            
            if (row > 0) {
                System.out.println("PlaylistRepository: Created playlist '" + playlist.getName() + "'");
            }
        } catch (SQLException e) {
          //  System.out.println("Error creating playlist: " + e.getMessage());
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
    
    // Get playlist by ID
    public Playlist getPlaylistById(int playlistId) throws ClassNotFoundException {
        Playlist playlist = null;
        Connection con = DBConnection.getConnection();
        String sql = "SELECT p.*, c.display_name as channel_name, c.profile_picture as channel_profile_picture, " +
                    "(SELECT COUNT(*) FROM playlist_videos WHERE playlist_id = p.id) as video_count " +
                    "FROM playlists p " +
                    "JOIN channels c ON p.channel_id = c.id " +
                    "WHERE p.id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, playlistId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                playlist = new Playlist();
                playlist.setId(rs.getInt("id"));
                playlist.setChannelId(rs.getInt("channel_id"));
                playlist.setName(rs.getString("name"));
                playlist.setDescription(rs.getString("description"));
                playlist.setIsPublic(rs.getString("is_public"));
                playlist.setCreatedAt(rs.getTimestamp("created_at"));
                playlist.setUpdatedAt(rs.getTimestamp("updated_at"));
                playlist.setChannelName(rs.getString("channel_name"));
                playlist.setChannelProfilePicture(rs.getString("channel_profile_picture"));
                playlist.setVideoCount(rs.getInt("video_count"));
            }
        } catch (SQLException e) {
           // System.out.println("Error getting playlist by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return playlist;
    }
    
    // Get playlists by channel ID
    public List<Playlist> getPlaylistsByChannelId(int channelId, boolean includePrivate) throws ClassNotFoundException {
        List<Playlist> playlists = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT p.*, c.display_name as channel_name, c.profile_picture as channel_profile_picture, " +
                    "(SELECT COUNT(*) FROM playlist_videos WHERE playlist_id = p.id) as video_count " +
                    "FROM playlists p " +
                    "JOIN channels c ON p.channel_id = c.id " +
                    "WHERE p.channel_id = ?";
        
        if (!includePrivate) {
            sql += " AND p.is_public = '1'";
        }
        
        sql += " ORDER BY p.created_at DESC";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, channelId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Playlist playlist = new Playlist();
                playlist.setId(rs.getInt("id"));
                playlist.setChannelId(rs.getInt("channel_id"));
                playlist.setName(rs.getString("name"));
                playlist.setDescription(rs.getString("description"));
                playlist.setIsPublic(rs.getString("is_public"));
                playlist.setCreatedAt(rs.getTimestamp("created_at"));
                playlist.setUpdatedAt(rs.getTimestamp("updated_at"));
                playlist.setChannelName(rs.getString("channel_name"));
                playlist.setChannelProfilePicture(rs.getString("channel_profile_picture"));
                playlist.setVideoCount(rs.getInt("video_count"));
                
                playlists.add(playlist);
            }
        } catch (SQLException e) {
          //  System.out.println("Error getting playlists by channel ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return playlists;
    }
    
    // Get public playlists by channel ID (for other users)
    public List<Playlist> getPublicPlaylistsByChannelId(int channelId) throws ClassNotFoundException {
        return getPlaylistsByChannelId(channelId, false);
    }
    
    // Update playlist
    public int updatePlaylist(Playlist playlist) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        String sql = "UPDATE playlists SET name = ?, description = ?, is_public = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND channel_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, playlist.getName());
            ps.setString(2, playlist.getDescription());
            ps.setString(3, playlist.getIsPublic());
            ps.setInt(4, playlist.getId());
            ps.setInt(5, playlist.getChannelId());
            
            row = ps.executeUpdate();
            
            if (row > 0) {
              //  System.out.println("PlaylistRepository: Updated playlist ID " + playlist.getId());
            }
        } catch (SQLException e) {
           // System.out.println("Error updating playlist: " + e.getMessage());
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
    
    // Delete playlist
    public int deletePlaylist(int playlistId, int channelId) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        String sql = "DELETE FROM playlists WHERE id = ? AND channel_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, playlistId);
            ps.setInt(2, channelId);
            
            row = ps.executeUpdate();
            
            if (row > 0) {
             //   System.out.println("PlaylistRepository: Deleted playlist ID " + playlistId);
            }
        } catch (SQLException e) {
         //   System.out.println("Error deleting playlist: " + e.getMessage());
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