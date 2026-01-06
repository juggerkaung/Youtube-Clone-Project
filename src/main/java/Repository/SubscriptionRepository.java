package Repository;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.*;

import JDBCConnection.DBConnection;
import Model.Channel;
import Model.Subscription;

public class SubscriptionRepository {
    
    // Check if user is subscribed to a channel
    public boolean isSubscribed(int subscriberId, int channelId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT id FROM subscriptions WHERE subscriber_id = ? AND channel_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, subscriberId);
            ps.setInt(2, channelId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
        //    System.out.println("Error checking subscription: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    // Subscribe to a channel
    public int subscribe(int subscriberId, int channelId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "INSERT INTO subscriptions (subscriber_id, channel_id) VALUES (?, ?)";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, subscriberId);
            ps.setInt(2, channelId);
            int result = ps.executeUpdate();
            
            // Update subscriber count
            if (result > 0) {
                updateSubscriberCount(channelId, 1);
            }
            
            return result;
        } catch (SQLException e) {
      //      System.out.println("Error subscribing: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Unsubscribe from a channel
    public int unsubscribe(int subscriberId, int channelId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "DELETE FROM subscriptions WHERE subscriber_id = ? AND channel_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, subscriberId);
            ps.setInt(2, channelId);
            int result = ps.executeUpdate();
            
            // Update subscriber count
            if (result > 0) {
                updateSubscriberCount(channelId, -1);
            }
            
            return result;
        } catch (SQLException e) {
         //   System.out.println("Error unsubscribing: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Get subscriber count for a channel
    public int getSubscriberCount(int channelId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT COUNT(*) as count FROM subscriptions WHERE channel_id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, channelId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
         //   System.out.println("Error getting subscriber count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    
 // Get channels that a user is subscribed to
    public List<Channel> getSubscribedChannels(int subscriberId) throws ClassNotFoundException {
        List<Channel> channels = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT c.* FROM channels c " +
                     "JOIN subscriptions s ON c.id = s.channel_id " +
                     "WHERE s.subscriber_id = ? AND c.is_active = '1'";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, subscriberId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Channel channel = new Channel();
                channel.setId(rs.getInt("id"));
                channel.setEmail(rs.getString("email"));
                channel.setPassword(rs.getString("password"));
                channel.setDisplayName(rs.getString("display_name"));
                channel.setProfilePicture(rs.getString("profile_picture"));
                channel.setDescription(rs.getString("description"));
                channel.setRoleId(rs.getInt("role_id"));
                channel.setIsActive(rs.getString("is_active"));
                channel.setCreatedAt(rs.getTimestamp("created_at"));
                channel.setUpdatedAt(rs.getTimestamp("updated_at"));
                channel.setSubscriberCount(rs.getInt("subscriber_count"));
                
                channels.add(channel);
            }
        } catch (SQLException e) {
        //    System.out.println("Error getting subscribed channels: " + e.getMessage());
            e.printStackTrace();
        }
        return channels;
    }

    // Get channels that are subscribed to a given channel (subscribers)
    public List<Channel> getSubscriberChannels(int channelId) throws ClassNotFoundException {
        List<Channel> channels = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT c.* FROM channels c " +
                     "JOIN subscriptions s ON c.id = s.subscriber_id " +
                     "WHERE s.channel_id = ? AND c.is_active = '1'";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, channelId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Channel channel = new Channel();
                channel.setId(rs.getInt("id"));
                channel.setEmail(rs.getString("email"));
                channel.setPassword(rs.getString("password"));
                channel.setDisplayName(rs.getString("display_name"));
                channel.setProfilePicture(rs.getString("profile_picture"));
                channel.setDescription(rs.getString("description"));
                channel.setRoleId(rs.getInt("role_id"));
                channel.setIsActive(rs.getString("is_active"));
                channel.setCreatedAt(rs.getTimestamp("created_at"));
                channel.setUpdatedAt(rs.getTimestamp("updated_at"));
                channel.setSubscriberCount(rs.getInt("subscriber_count"));
                
                channels.add(channel);
            }
        } catch (SQLException e) {
        //    System.out.println("Error getting subscriber channels: " + e.getMessage());
            e.printStackTrace();
        }
        return channels;
    }
    
    // Update subscriber count
    private void updateSubscriberCount(int channelId, int change) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "UPDATE channels SET subscriber_count = subscriber_count + ? WHERE id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, change);
            ps.setInt(2, channelId);
            ps.executeUpdate();
        } catch (SQLException e) {
           // System.out.println("Error updating subscriber count: " + e.getMessage());
            e.printStackTrace();
        }
    }
}