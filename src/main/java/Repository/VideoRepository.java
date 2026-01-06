package Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import JDBCConnection.DBConnection;
import Model.Video;
import Service.CountSyncService;

public class VideoRepository {

	// Update video reaction counts in the database
	public void updateVideoReactionCounts(int videoId, int likesCount, int dislikesCount)
			throws ClassNotFoundException {
		String sql = "UPDATE videos SET likes_count = ?, dislike_count = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, likesCount);
			pstmt.setInt(2, dislikesCount);
			pstmt.setInt(3, videoId);
			pstmt.executeUpdate();

		//	System.out.println("VideoRepository: Updated video " + videoId + " - Likes: " + likesCount + ", Dislikes: "
		//			+ dislikesCount);

		} catch (SQLException e) {
			System.out.println("Error updating video reaction counts in database: " + e.getMessage());
			e.printStackTrace();
		}
	}

	// Update video object with current reaction counts from database
	private void updateVideoReactionCounts(Video video) throws ClassNotFoundException {
		if (video == null)
			return;

		VideoReactionRepository reactionRepo = new VideoReactionRepository();
		int likesCount = reactionRepo.getLikeCount(video.getId());
		int dislikesCount = reactionRepo.getDislikeCount(video.getId());

		video.setLikesCount(likesCount);
		video.setDislikeCount(dislikesCount);

//		System.out.println("VideoRepository: Updated video object " + video.getId() + " - Likes: " + likesCount
//				+ ", Dislikes: " + dislikesCount);
	}

	// Update the getVideoById method
	public Video getVideoById(int videoId) throws ClassNotFoundException {
		Video video = null;
		Connection con = DBConnection.getConnection();

		String sql = "SELECT v.*, c.display_name as channel_name, c.profile_picture as channel_profile_picture, c.subscriber_count, "
	            + "v.copyright_status, v.copyright_reason, v.copyright_video_id, v.original_filename "  // ADD THIS
	            + "FROM videos v " 
	            + "JOIN channels c ON v.channel_id = c.id " 
	            + "WHERE v.id = ? AND c.is_active = '1'";
		
		
		
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, videoId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				video = new Video();
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
				video.setOriginalFilename(rs.getString("original_filename"));

				// Set channel info
				video.setChannelName(rs.getString("channel_name"));
				video.setChannelProfilePicture(rs.getString("channel_profile_picture"));

				 // SET COPYRIGHT FIELDS
	            video.setCopyrightStatus(rs.getString("copyright_status"));
	            video.setCopyrightReason(rs.getString("copyright_reason"));
	            if (rs.getObject("copyright_video_id") != null) {
	                video.setCopyrightVideoId(rs.getInt("copyright_video_id"));
	            }
	            
				/*
				 * System.out.println("=== DEBUG: VideoRepository.getVideoById ===");
				 * System.out.println("DB - Video ID: " + videoId);
				 * System.out.println("DB - Copyright Status: " + video.getCopyrightStatus());
				 * System.out.println("DB - Copyright Reason: " + video.getCopyrightReason());
				 * System.out.println("DB - Copyright Video ID: " +
				 * video.getCopyrightVideoId());
				 */
	        }
				
				
		} catch (Exception e) {
			System.out.println("Error getting video by ID: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return video;
	}

	public int saveVideo(Video video) throws ClassNotFoundException {
		int row = 0;
		Connection con = DBConnection.getConnection();

		// UPDATED: Add views_count to INSERT statement
		String sql = "INSERT INTO videos (channel_id, video_title, video_description, video_url, thumbnail, duration, public, video_type, views_count) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, video.getChannelId());
			ps.setString(2, video.getVideoTitle());
			ps.setString(3, video.getVideoDescription());
			ps.setString(4, video.getVideoUrl());
			ps.setString(5, video.getThumbnail());
			ps.setInt(6, video.getDuration());
			ps.setString(7, video.getIsPublic());
			ps.setString(8, video.getVideoType()); // NEW: Set video type
			ps.setLong(9, video.getViewsCount()); // Set initial views to 0

			/*
			 * System.out.println("VideoRepository: Saving video:");
			 * System.out.println("  - Title: " + video.getVideoTitle());
			 * System.out.println("  - Type: " + video.getVideoType());
			 * System.out.println("  - Duration: " + video.getDuration());
			 * System.out.println("  - Initial views: " + video.getViewsCount());
			 */
			row = ps.executeUpdate();

			if (row > 0) {
		//		System.out.println("VideoRepository: Video saved successfully");
			} else {
		//		System.out.println("VideoRepository: Video save failed");
			}

		} catch (SQLException e) {
	//		System.out.println("VideoRepository: Video save error: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return row;
	}

	// Public method for getting videos by channel ID (only public videos)
	public List<Video> getVideosByChannelId(int channelId) throws ClassNotFoundException {
		return getVideosByChannelId(channelId, false);
	}

	// Private method for internal use

	// Update the getVideosByChannelId method in VideoRepository.java
	private List<Video> getVideosByChannelId(int channelId, boolean includePrivate) throws ClassNotFoundException {
	    List<Video> videos = new ArrayList<>();
	    Connection con = DBConnection.getConnection();
	    
	    // FIXED: Added table alias 'v' in FROM clause
	    String sql = "SELECT v.*, v.copyright_status, v.copyright_reason, v.copyright_video_id, v.original_filename " +  // ADD THIS
	            "FROM videos v WHERE v.channel_id = ? ";
	    

	    if (!includePrivate) {
	        sql += "AND v.public = '1' ";
	    }

	    sql += "ORDER BY v.created_at DESC";

	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, channelId);
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
	            video.setOriginalFilename(rs.getString("original_filename"));
	            
	            // SET COPYRIGHT FIELDS
	            video.setCopyrightStatus(rs.getString("copyright_status"));
	            video.setCopyrightReason(rs.getString("copyright_reason"));
	            if (rs.getObject("copyright_video_id") != null) {
	                video.setCopyrightVideoId(rs.getInt("copyright_video_id"));
	            }

	            videos.add(video);
	        }
	    } catch (SQLException e) {
	    //    System.out.println("Error getting videos by channel ID: " + e.getMessage());
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
	
	
	

	// Add a method to get videos for channel owner (includes private videos)
	public List<Video> getVideosForChannelOwner(int channelId) throws ClassNotFoundException {
		return getVideosByChannelId(channelId, true);
	}

	// Update video reaction counts in the database - FIXED VERSION
	public void syncVideoReactionCountsInDatabase(int videoId) throws ClassNotFoundException {
		Connection con = DBConnection.getConnection();

		try {
			// Get current counts from video_reactions table
			VideoReactionRepository reactionRepo = new VideoReactionRepository();
			int likesCount = reactionRepo.getLikeCount(videoId);
			int dislikesCount = reactionRepo.getDislikeCount(videoId);

			// Update the videos table
			String sql = "UPDATE videos SET likes_count = ?, dislike_count = ? WHERE id = ?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, likesCount);
			ps.setInt(2, dislikesCount);
			ps.setInt(3, videoId);

			int rowsUpdated = ps.executeUpdate();
			if (rowsUpdated > 0) {
		//		System.out.println("VideoRepository: SYNCED reaction counts for video " + videoId + " - Likes: "
		//				+ likesCount + ", Dislikes: " + dislikesCount);
			} else {
	//			System.out.println("VideoRepository: Failed to sync reaction counts for video " + videoId);
			}

		} catch (SQLException e) {
//			System.out.println("Error updating video reaction counts in database: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	// Update video title and description
	public int updateVideo(Video video) throws ClassNotFoundException {
		int row = 0;
		Connection con = DBConnection.getConnection();
		String sql = "UPDATE videos SET video_title = ?, video_description = ?, public = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, video.getVideoTitle());
			ps.setString(2, video.getVideoDescription());
			ps.setString(3, video.getIsPublic()); // Update visibility
			ps.setInt(4, video.getId());

			/*
			 * System.out.println( "VideoRepository: Updating video ID " + video.getId() +
			 * " - Title: " + video.getVideoTitle() + " - Visibility: " +
			 * (video.getIsPublic().equals("1") ? "Public" : "Private"));
			 */
			row = ps.executeUpdate();

			if (row > 0) {
				System.out.println("VideoRepository: Video updated successfully");
				// Verify the update worked
				String verifySql = "SELECT public FROM videos WHERE id = ?";
				PreparedStatement verifyPs = con.prepareStatement(verifySql);
				verifyPs.setInt(1, video.getId());
				ResultSet rs = verifyPs.executeQuery();
				if (rs.next()) {
			//		System.out.println("VideoRepository: Verified visibility in DB: " + rs.getString("public"));
				}
			} else {
	//			System.out.println("VideoRepository: Video update failed");
			}

		} catch (SQLException e) {
//			System.out.println("VideoRepository: Video update error: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return row;
	}

	// Delete video
	public int deleteVideo(int videoId) throws ClassNotFoundException {
		int row = 0;
		Connection con = DBConnection.getConnection();

		try {
			// First delete associated reactions and comments
			String deleteReactions = "DELETE FROM video_reactions WHERE video_id = ?";
			PreparedStatement ps1 = con.prepareStatement(deleteReactions);
			ps1.setInt(1, videoId);
			ps1.executeUpdate();

			String deleteComments = "DELETE FROM comments WHERE video_id = ?";
			PreparedStatement ps2 = con.prepareStatement(deleteComments);
			ps2.setInt(1, videoId);
			ps2.executeUpdate();

			// Then delete the video
			String deleteVideo = "DELETE FROM videos WHERE id = ?";
			PreparedStatement ps3 = con.prepareStatement(deleteVideo);
			ps3.setInt(1, videoId);
			row = ps3.executeUpdate();

//			System.out.println("VideoRepository: Deleted video ID " + videoId);

		} catch (SQLException e) {
//			System.out.println("VideoRepository: Video delete error: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return row;
	}

	public void incrementViewCount(int videoId) throws ClassNotFoundException {
		Connection con = DBConnection.getConnection();

		// String sql = "UPDATE videos SET views_count = views_count + 1 WHERE id = ?";
		// Use COALESCE to handle NULL values (just in case)
		String sql = "UPDATE videos SET views_count = COALESCE(views_count, 0) + 1 WHERE id = ?";

		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, videoId);
			int rowsUpdated = ps.executeUpdate();

			if (rowsUpdated > 0) {
				// Get the updated view count
				String selectSql = "SELECT views_count FROM videos WHERE id = ?";
				PreparedStatement selectPs = con.prepareStatement(selectSql);
				selectPs.setInt(1, videoId);
				ResultSet rs = selectPs.executeQuery();

				if (rs.next()) {
					long newViewCount = rs.getLong("views_count");
	//				System.out.println("VideoRepository: Incremented view count for video " + videoId + " - New count: "
	//						+ newViewCount);
				}
			} else {
//				System.out.println("VideoRepository: Failed to increment view count for video " + videoId);
			}
		} catch (SQLException e) {
//			System.out.println("Error incrementing view count: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public List<Video> getAllPublicVideos() throws ClassNotFoundException {
		List<Video> videos = new ArrayList<>();
		Connection con = DBConnection.getConnection();


		/*
		 * String sql =
		 * "SELECT v.*, c.display_name as channel_name, c.profile_picture as channel_profile_picture, c.subscriber_count, "
		 * +
		 * "v.copyright_status, v.copyright_reason, v.copyright_video_id, v.original_filename "
		 * // ADD THIS + "FROM videos v " + "JOIN channels c ON v.channel_id = c.id " +
		 * "WHERE v.public = '1' AND c.is_active = '1' " + "ORDER BY v.created_at DESC";
		 */
	    // REMOVE: AND c.is_active = '1' to show videos from banned channels
	    String sql = "SELECT v.*, c.display_name as channel_name, c.profile_picture as channel_profile_picture, c.subscriber_count, "
	            + "v.copyright_status, v.copyright_reason, v.copyright_video_id, v.original_filename "
	            + "FROM videos v " 
	            + "JOIN channels c ON v.channel_id = c.id "
	            + "WHERE v.public = '1' " // Only show public videos
	            + "ORDER BY v.created_at DESC";
		
		

		try {
			PreparedStatement ps = con.prepareStatement(sql);
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
				video.setOriginalFilename(rs.getString("original_filename"));
				
			      // SET COPYRIGHT FIELDS
	            video.setCopyrightStatus(rs.getString("copyright_status"));
	            video.setCopyrightReason(rs.getString("copyright_reason"));
	            if (rs.getObject("copyright_video_id") != null) {
	                video.setCopyrightVideoId(rs.getInt("copyright_video_id"));
	            }

				// Set channel info
				video.setChannelName(rs.getString("channel_name"));
				video.setChannelProfilePicture(rs.getString("channel_profile_picture"));

				videos.add(video);
			}

//			System.out.println("VideoRepository: Retrieved " + videos.size() + " PUBLIC videos");

		} catch (SQLException e) {
//			System.out.println("Error getting all public videos: " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return videos;
	}
	
	// Get all videos (admin only - includes private videos)
	public List<Video> getAllVideos() throws ClassNotFoundException {
	    List<Video> videos = new ArrayList<>();
	    Connection con = DBConnection.getConnection();
	    
	    String sql = "SELECT v.*, c.display_name as channel_name, c.profile_picture as channel_profile_picture, c.subscriber_count, "
	                + "v.copyright_status, v.copyright_reason, v.copyright_video_id, v.original_filename "  
	                + "FROM videos v " 
	                + "JOIN channels c ON v.channel_id = c.id "
	                + "ORDER BY v.created_at DESC";
	    
//	    System.out.println("VideoRepository: getAllVideos() SQL: " + sql);
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();
	        
	        int count = 0;
	        while (rs.next()) {
	            count++;
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
	            
	            // IMPORTANT: Column name is "public" not "isPublic"
	            String isPublic = rs.getString("public");
	            video.setIsPublic(isPublic != null ? isPublic : "1");
	            
	            video.setCreatedAt(rs.getTimestamp("created_at"));
	            video.setUpdatedAt(rs.getTimestamp("updated_at"));
	            video.setChannelName(rs.getString("channel_name"));
	            video.setChannelProfilePicture(rs.getString("channel_profile_picture"));
	            video.setVideoType(rs.getString("video_type"));
	            video.setCopyrightStatus(rs.getString("copyright_status"));
	            video.setCopyrightReason(rs.getString("copyright_reason"));
	            video.setCopyrightVideoId(rs.getObject("copyright_video_id") != null ? 
	                                     rs.getInt("copyright_video_id") : null);
	            video.setOriginalFilename(rs.getString("original_filename"));
	            
	            videos.add(video);
	        }
	        
//	        System.out.println("VideoRepository: Retrieved " + count + " videos from database");
	        
	        rs.close();
	        ps.close();
	        
	    } catch (SQLException e) {
//	        System.out.println("VideoRepository Error (getAllVideos): " + e.getMessage());
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

	// Toggle video visibility (admin only)
	public int toggleVideoVisibility(int videoId, String isPublic) throws ClassNotFoundException {
	    int row = 0;
	    Connection con = DBConnection.getConnection();
	    String sql = "UPDATE videos SET public = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
	    
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, isPublic);
	        ps.setInt(2, videoId);
	        row = ps.executeUpdate();
	        
//	        System.out.println("Admin: Toggled video " + videoId + " visibility to " + isPublic);
	        
	        ps.close();
	    } catch (SQLException e) {
//	        System.out.println("Error toggling video visibility: " + e.getMessage());
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    
	    return row;
	}	}