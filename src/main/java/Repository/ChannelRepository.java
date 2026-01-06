package Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import JDBCConnection.DBConnection;
import Model.Channel;

public class ChannelRepository {	
	// In Repository/ChannelRepository.java - Add these methods
	public int upgradeToPremium(int channelId) throws ClassNotFoundException {
	    int row = 0;
	    Connection con = DBConnection.getConnection();
	    // Set theme_preference to 'gold' and premium_since to current timestamp
	    String sql = "UPDATE channels SET is_premium = '1', premium_since = NOW(), theme_preference = 'gold' WHERE id = ?";
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, channelId);
	        row = ps.executeUpdate();
	      //  System.out.println("ChannelRepository: Upgraded channel " + channelId + " to premium at " + new java.util.Date());
	    } catch (SQLException e) {
	       // System.out.println("Error upgrading channel to premium: " + e.getMessage());
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

	public int updateThemePreference(int channelId, String theme) throws ClassNotFoundException {
	    int row = 0;
	    Connection con = DBConnection.getConnection();
	    String sql = "UPDATE channels SET theme_preference = ? WHERE id = ?";
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, theme);
	        ps.setInt(2, channelId);
	        row = ps.executeUpdate();
	       // System.out.println("ChannelRepository: Updated theme for channel " + channelId + " to " + theme);
	    } catch (SQLException e) {
	       // System.out.println("Error updating theme preference: " + e.getMessage());
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

	public boolean hasWatchedSponsorVideo(int channelId, int sponsorVideoId) throws ClassNotFoundException {
	    Connection con = DBConnection.getConnection();
	    String sql = "SELECT COUNT(*) as count FROM sponsor_watch_history WHERE channel_id = ? AND sponsor_video_id = ?";
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, channelId);
	        ps.setInt(2, sponsorVideoId);
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            return rs.getInt("count") > 0;
	        }
	    } catch (SQLException e) {
	      //  System.out.println("Error checking sponsor video watch history: " + e.getMessage());
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

	public int recordSponsorVideoWatch(int channelId, int sponsorVideoId) throws ClassNotFoundException {
	    int row = 0;
	    Connection con = DBConnection.getConnection();
	    String sql = "INSERT INTO sponsor_watch_history (channel_id, sponsor_video_id) VALUES (?, ?)";
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, channelId);
	        ps.setInt(2, sponsorVideoId);
	        row = ps.executeUpdate();
	      //  System.out.println("ChannelRepository: Recorded sponsor video watch for channel " + channelId);
	    } catch (SQLException e) {
	      //  System.out.println("Error recording sponsor video watch: " + e.getMessage());
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
    
    // Get channel by ID
	// In ChannelRepository.java - Update getChannelById method
	public Channel getChannelById(int channelId) throws ClassNotFoundException {
	    Channel channel = null;
	    Connection con = DBConnection.getConnection();
	    // REMOVE the is_active check to allow displaying banned channels
	    String sql = "SELECT * FROM channels WHERE id = ?"; // Removed: AND is_active = '1'
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, channelId);
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            channel = new Channel();
	            channel.setId(rs.getInt("id"));
	            channel.setEmail(rs.getString("email"));
	            channel.setPassword(rs.getString("password"));
	            channel.setDisplayName(rs.getString("display_name"));
	            channel.setProfilePicture(rs.getString("profile_picture"));
	            channel.setDescription(rs.getString("description"));
	            channel.setRoleId(rs.getInt("role_id"));
	            channel.setIsActive(rs.getString("is_active")); // This will be '0' for banned
	            channel.setCreatedAt(rs.getTimestamp("created_at"));
	            channel.setUpdatedAt(rs.getTimestamp("updated_at"));
	            channel.setSubscriberCount(rs.getInt("subscriber_count"));
	            
	            // Check if premium has expired before setting it
	            Timestamp premiumSince = rs.getTimestamp("premium_since");
	            String isPremium = rs.getString("is_premium");
	            
	            // If premium exists but has expired, mark as not premium
	            if ("1".equals(isPremium) && premiumSince != null) {
	                long premiumTime = premiumSince.getTime();
	                long currentTime = System.currentTimeMillis();
	                long hours24 = 24 * 60 * 60 * 1000; // 24 hours in milliseconds
	                
	                if (currentTime - premiumTime > hours24) {
	                    // Premium has expired, update database
	                    updatePremiumToExpired(channelId);
	                    isPremium = "0";
	                }
	            }
	            
	            // Add these lines in the ResultSet processing
	            channel.setIsPremium(rs.getString("is_premium"));
	            channel.setPremiumSince(rs.getTimestamp("premium_since"));
	            channel.setThemePreference(rs.getString("theme_preference") != null ? 
	                                       rs.getString("theme_preference") : "light");
	            
				/*
				 * System.out.println("=== ChannelRepository Debug ===");
				 * System.out.println("Channel ID: " + channelId);
				 * System.out.println("Is Active: " + channel.getIsActive());
				 */
	            
				/*
				 * System.out.println("=== ChannelRepository Debug ===");
				 * System.out.println("Channel ID: " + channelId);
				 * System.out.println("Is Premium: " + channel.getIsPremium());
				 * System.out.println("Premium Since: " + premiumSince);
				 * System.out.println("Theme Preference: " + channel.getThemePreference());
				 */
	        } else {
	           // System.out.println("No channel found with ID: " + channelId);
	        }
	    } catch (SQLException e) {
	       // System.out.println("Error getting channel by ID: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return channel;
	}

    // Get channel by email (for login)
	public Channel getChannelByEmail(String email) throws ClassNotFoundException {
	    Channel channel = null;
	    Connection con = DBConnection.getConnection();
	    String sql = "SELECT * FROM channels WHERE email = ? AND is_active = '1'";
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, email);
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            channel = new Channel();
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
	            
	            // ADD THESE LINES - LOAD PREMIUM FIELDS
	            channel.setIsPremium(rs.getString("is_premium"));
	            channel.setPremiumSince(rs.getTimestamp("premium_since"));
	            channel.setThemePreference(rs.getString("theme_preference") != null ? 
	                                       rs.getString("theme_preference") : "light");
	            
				/*
				 * System.out.println("=== ChannelRepository.getChannelByEmail Debug ===");
				 * System.out.println("Email: " + email); System.out.println("Is Premium: " +
				 * channel.getIsPremium()); System.out.println("Theme Preference: " +
				 * channel.getThemePreference());
				 */
	        }
	    } catch (SQLException e) {
	      //  System.out.println("Error getting channel by email: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return channel;
	}
	
	// Method specifically for admin login (doesn't check is_active)
	public Channel getChannelByEmailForAdmin(String email) throws ClassNotFoundException {
	    Channel channel = null;
	    Connection con = DBConnection.getConnection();
	    // Remove the is_active check for admin login
	    String sql = "SELECT * FROM channels WHERE email = ?";
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, email);
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            channel = new Channel();
	            channel.setId(rs.getInt("id"));
	            channel.setEmail(rs.getString("email"));
	            channel.setPassword(rs.getString("password"));
	            channel.setDisplayName(rs.getString("display_name"));
	            channel.setProfilePicture(rs.getString("profile_picture"));
	            channel.setDescription(rs.getString("description"));
	            channel.setRoleId(rs.getInt("role_id"));
	            channel.setIsActive(rs.getString("is_active")); // This might be '0' or '1'
	            channel.setCreatedAt(rs.getTimestamp("created_at"));
	            channel.setUpdatedAt(rs.getTimestamp("updated_at"));
	            channel.setSubscriberCount(rs.getInt("subscriber_count"));
	            channel.setIsPremium(rs.getString("is_premium"));
	            channel.setPremiumSince(rs.getTimestamp("premium_since"));
	            channel.setThemePreference(rs.getString("theme_preference") != null ? 
	                                       rs.getString("theme_preference") : "light");
	            
				/*
				 * System.out.println("=== getChannelByEmailForAdmin Debug ===");
				 * System.out.println("Email: " + email); System.out.println("Is Active: " +
				 * channel.getIsActive()); System.out.println("Role: " + channel.getRoleId());
				 */
	        }
	    } catch (SQLException e) {
	      //  System.out.println("Error getting channel by email for admin: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return channel;
	}

    public int saveChannel(Channel channel) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        String sql = "INSERT INTO channels (email, password, display_name, profile_picture, description, role_id) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, channel.getEmail());
            ps.setString(2, channel.getPassword());
            ps.setString(3, channel.getDisplayName());
            ps.setString(4, channel.getProfilePicture());
            ps.setString(5, channel.getDescription());
            ps.setInt(6, channel.getRoleId());
            
            row = ps.executeUpdate();
        } catch (SQLException e) {
          //  System.out.println("Error saving channel: " + e.getMessage());
            e.printStackTrace();
        }
        return row;
    }
    
    
    // Update channel profile
    public int updateChannel(Channel channel) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        String sql = "UPDATE channels SET display_name = ?, profile_picture = ?, description = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            
            // Handle potential null values
            String displayName = channel.getDisplayName();
            if (displayName == null) {
                displayName = ""; // Set to empty string instead of null
            }
            
            String profilePicture = channel.getProfilePicture();
            if (profilePicture == null) {
                profilePicture = ""; // Set to empty string instead of null
            }
            
            String description = channel.getDescription();
            if (description == null) {
                description = ""; // Set to empty string instead of null
            }
            
            ps.setString(1, displayName);
            ps.setString(2, profilePicture);
            ps.setString(3, description);
            ps.setInt(4, channel.getId());
            
            row = ps.executeUpdate();
          //  System.out.println("Channel updated: " + channel.getId());
        } catch (SQLException e) {
          //  System.out.println("Error updating channel: " + e.getMessage());
            e.printStackTrace();
        }
        return row;
    }
    
    
    // Get all active channels
    public List<Channel> getAllActiveChannels() throws ClassNotFoundException {
        List<Channel> channels = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM channels WHERE is_active = '1'";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
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
                channel.setSubscriberCount(rs.getInt("subscriber_count")); // ADD THIS LINE

                
                channels.add(channel);
            }
        } catch (SQLException e) {
          //  System.out.println("Error getting all channels: " + e.getMessage());
            e.printStackTrace();
        }
        return channels;
    }
    
    // Ban/Unban channel (Admin function)
    
 // ChannelRepository.java - Update toggleChannelStatus method
 // Toggle channel status (ban/unban)
    public int toggleChannelStatus(int channelId, String status) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        String sql = "UPDATE channels SET is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
       // System.out.println("ChannelRepository.toggleChannelStatus: Setting channel " + channelId + " to status: " + status);
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, channelId);
            row = ps.executeUpdate();
            
          //  System.out.println("ChannelRepository: Updated " + row + " row(s)");
            
            // Verify the update
            String verifySql = "SELECT is_active FROM channels WHERE id = ?";
            PreparedStatement verifyPs = con.prepareStatement(verifySql);
            verifyPs.setInt(1, channelId);
            ResultSet rs = verifyPs.executeQuery();
            if (rs.next()) {
             //   System.out.println("ChannelRepository: Verified new status is: " + rs.getString("is_active"));
            }
            
            rs.close();
            verifyPs.close();
            ps.close();
        } catch (SQLException e) {
       //     System.out.println("Error toggling channel status: " + e.getMessage());
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
    
    
 // Repository/ChannelRepository.java - Add this method

    public boolean isDisplayNameExists(String displayName) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT COUNT(*) as count FROM channels WHERE LOWER(display_name) = LOWER(?) AND is_active = '1'";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, displayName.trim());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
          //  System.out.println("Error checking display name: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
 // Get all channels (admin only)
    public List<Channel> getAllChannels() throws ClassNotFoundException {
        List<Channel> channels = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM channels ORDER BY created_at DESC";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
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
                
             // ADD THESE LINES TO LOAD PREMIUM FIELDS
                channel.setIsPremium(rs.getString("is_premium"));
                channel.setPremiumSince(rs.getTimestamp("premium_since"));
                channel.setThemePreference(rs.getString("theme_preference") != null ? 
                                           rs.getString("theme_preference") : "light");
                
                
                channels.add(channel);
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
          //  System.out.println("Error getting all channels: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return channels;
    }  
  
 // Delete channel completely (admin only)
    public int deleteChannel(int channelId) throws ClassNotFoundException {
        int row = 0;
        Connection con = DBConnection.getConnection();
        
        try {
            // Start transaction
            con.setAutoCommit(false);
            
            // 1. Delete subscriptions where channel is the subscriber
            String deleteSubscriptions1 = "DELETE FROM subscriptions WHERE subscriber_id = ?";
            PreparedStatement ps1 = con.prepareStatement(deleteSubscriptions1);
            ps1.setInt(1, channelId);
            ps1.executeUpdate();
            
            // 2. Delete subscriptions where channel is being subscribed to
            String deleteSubscriptions2 = "DELETE FROM subscriptions WHERE channel_id = ?";
            PreparedStatement ps2 = con.prepareStatement(deleteSubscriptions2);
            ps2.setInt(1, channelId);
            ps2.executeUpdate();
            
            // 3. Delete video reactions by this channel
            String deleteReactions = "DELETE FROM video_reactions WHERE user_id = ?";
            PreparedStatement ps3 = con.prepareStatement(deleteReactions);
            ps3.setInt(1, channelId);
            ps3.executeUpdate();
            
            // 4. Delete comments by this channel
            String deleteComments = "DELETE FROM comments WHERE user_id = ?";
            PreparedStatement ps4 = con.prepareStatement(deleteComments);
            ps4.setInt(1, channelId);
            ps4.executeUpdate();
            
            // 5. Get all videos by this channel first
            String selectVideos = "SELECT id FROM videos WHERE channel_id = ?";
            PreparedStatement ps5 = con.prepareStatement(selectVideos);
            ps5.setInt(1, channelId);
            ResultSet rs = ps5.executeQuery();
            
            // 6. Delete each video's reactions and comments
            while (rs.next()) {
                int videoId = rs.getInt("id");
                
                // Delete reactions for this video
                String deleteVideoReactions = "DELETE FROM video_reactions WHERE video_id = ?";
                PreparedStatement ps6 = con.prepareStatement(deleteVideoReactions);
                ps6.setInt(1, videoId);
                ps6.executeUpdate();
                
                // Delete comments for this video
                String deleteVideoComments = "DELETE FROM comments WHERE video_id = ?";
                PreparedStatement ps7 = con.prepareStatement(deleteVideoComments);
                ps7.setInt(1, videoId);
                ps7.executeUpdate();
                
                // Delete playlist videos for this video
                String deletePlaylistVideos = "DELETE FROM playlist_videos WHERE video_id = ?";
                PreparedStatement ps8 = con.prepareStatement(deletePlaylistVideos);
                ps8.setInt(1, videoId);
                ps8.executeUpdate();
            }
            rs.close();
            
            // 7. Delete videos by this channel
            String deleteVideos = "DELETE FROM videos WHERE channel_id = ?";
            PreparedStatement ps9 = con.prepareStatement(deleteVideos);
            ps9.setInt(1, channelId);
            ps9.executeUpdate();
            
            // 8. Delete playlists by this channel
            // First delete playlist videos
            String deletePlaylistVideosByPlaylist = "DELETE pv FROM playlist_videos pv " +
                                                   "JOIN playlists p ON pv.playlist_id = p.id " +
                                                   "WHERE p.channel_id = ?";
            PreparedStatement ps10 = con.prepareStatement(deletePlaylistVideosByPlaylist);
            ps10.setInt(1, channelId);
            ps10.executeUpdate();
            
            // Then delete playlists
            String deletePlaylists = "DELETE FROM playlists WHERE channel_id = ?";
            PreparedStatement ps11 = con.prepareStatement(deletePlaylists);
            ps11.setInt(1, channelId);
            ps11.executeUpdate();
            
            // 9. Finally delete the channel
            String deleteChannel = "DELETE FROM channels WHERE id = ?";
            PreparedStatement ps12 = con.prepareStatement(deleteChannel);
            ps12.setInt(1, channelId);
            row = ps12.executeUpdate();
            
            // Commit transaction
            con.commit();
            
         //   System.out.println("Admin: Deleted channel ID " + channelId + " and all associated content");
            
        } catch (SQLException e) {
            try {
                if (con != null) {
                    con.rollback();
                }
              //  System.out.println("Error deleting channel, transaction rolled back: " + e.getMessage());
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return row;
    }
    
    
 // Method to check and update premium expiration
    public void checkAndUpdatePremiumExpiration(int channelId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        
        try {
            // Check if channel is premium and premium_since is more than 24 hours ago
            String sql = "UPDATE channels SET is_premium = '0', theme_preference = 'light' " +
                        "WHERE id = ? AND is_premium = '1' " +
                        "AND premium_since <= DATE_SUB(NOW(), INTERVAL 24 HOUR)";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, channelId);
            int rowsUpdated = ps.executeUpdate();
            
            if (rowsUpdated > 0) {
                System.out.println("Channel " + channelId + " premium status expired after 24 hours");
            }
        } catch (SQLException e) {
         //   System.out.println("Error checking premium expiration: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to check if premium is expired
    public boolean isPremiumExpired(int channelId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        
        try {
            // Check if premium_since is more than 24 hours ago
            String sql = "SELECT COUNT(*) as expired FROM channels " +
                        "WHERE id = ? AND is_premium = '1' " +
                        "AND premium_since <= DATE_SUB(NOW(), INTERVAL 24 HOUR)";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, channelId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("expired") > 0;
            }
        } catch (SQLException e) {
          //  System.out.println("Error checking if premium expired: " + e.getMessage());
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

    // Method to get remaining premium time in hours
    public String getPremiumRemainingTime(int channelId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        
        try {
            String sql = "SELECT TIMESTAMPDIFF(HOUR, premium_since, DATE_ADD(NOW(), INTERVAL 24 HOUR)) as hours_remaining " +
                        "FROM channels WHERE id = ? AND is_premium = '1'";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, channelId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int hours = rs.getInt("hours_remaining");
                if (hours > 0) {
                    return hours + " hours";
                } else {
                    // Convert to minutes if less than 1 hour
                    String minuteSql = "SELECT TIMESTAMPDIFF(MINUTE, premium_since, DATE_ADD(NOW(), INTERVAL 24 HOUR)) as minutes_remaining " +
                                      "FROM channels WHERE id = ? AND is_premium = '1'";
                    PreparedStatement minutePs = con.prepareStatement(minuteSql);
                    minutePs.setInt(1, channelId);
                    ResultSet minuteRs = minutePs.executeQuery();
                    
                    if (minuteRs.next()) {
                        int minutes = minuteRs.getInt("minutes_remaining");
                        return minutes + " minutes";
                    }
                }
            }
        } catch (SQLException e) {
          //  System.out.println("Error getting premium remaining time: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return "Expired";
    }
    
 // Helper method to update expired premium
    private void updatePremiumToExpired(int channelId) throws ClassNotFoundException {
        Connection con = DBConnection.getConnection();
        
        try {
            String sql = "UPDATE channels SET is_premium = '0', theme_preference = 'light' WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, channelId);
            int updated = ps.executeUpdate();
            
            if (updated > 0) {
                System.out.println("Updated channel " + channelId + " premium status to expired");
            }
        } catch (SQLException e) {
         //   System.out.println("Error updating premium to expired: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }   }
    }}