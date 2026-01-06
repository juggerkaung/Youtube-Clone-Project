package Service;

import Repository.VideoReactionRepository;

import Repository.VideoRepository;

public class CountSyncService {
    
    /**
     * Synchronizes all reaction counts for a specific video
     */
    public static void syncVideoReactionCounts(int videoId) throws Exception {
//        System.out.println("CountSyncService: Syncing reaction counts for video " + videoId);
        
        VideoReactionRepository reactionRepo = new VideoReactionRepository();
        VideoRepository videoRepo = new VideoRepository();
        
        // Get current counts from video_reactions table
        int likesCount = reactionRepo.getLikeCount(videoId);
        int dislikesCount = reactionRepo.getDislikeCount(videoId);
        
        // Update the videos table
        videoRepo.updateVideoReactionCounts(videoId, likesCount, dislikesCount);
        
		/*
		 * System.out.println("CountSyncService: Synced video " + videoId + " - Likes: "
		 * + likesCount + ", Dislikes: " + dislikesCount);
		 */
    }
    
    /**
     * Synchronizes reaction counts for all videos (for maintenance)
     */
    public static void syncAllVideoReactionCounts() throws Exception {
 //       System.out.println("CountSyncService: Starting full sync of all video reaction counts");
        
        VideoRepository videoRepo = new VideoRepository();
        VideoReactionRepository reactionRepo = new VideoReactionRepository();
        
        // This would need a method to get all video IDs
        // For now, we'll handle this via SQL or individual syncs
 //       System.out.println("CountSyncService: Full sync completed");
    }
}