package Service;

import javax.servlet.http.HttpSession;
import java.util.HashSet;
import java.util.Set;

public class ViewTrackingService {
    
    // Store viewed video IDs in session
    private static final String VIEWED_VIDEOS_KEY = "viewedVideos";
    
    /**
     * Check if the current session has already viewed this video
     */
    public static boolean hasViewedVideo(HttpSession session, int videoId) {
        if (session == null) return false;
        
        Set<Integer> viewedVideos = (Set<Integer>) session.getAttribute(VIEWED_VIDEOS_KEY);
        return viewedVideos != null && viewedVideos.contains(videoId);
    }
    
    /**
     * Mark a video as viewed in the current session
     */
    public static void markVideoAsViewed(HttpSession session, int videoId) {
        if (session == null) return;
        
        Set<Integer> viewedVideos = (Set<Integer>) session.getAttribute(VIEWED_VIDEOS_KEY);
        if (viewedVideos == null) {
            viewedVideos = new HashSet<>();
        }
        
        viewedVideos.add(videoId);
        session.setAttribute(VIEWED_VIDEOS_KEY, viewedVideos);
    }
    
    /**
     * Clear all viewed videos (for testing or session reset)
     */
    public static void clearViewedVideos(HttpSession session) {
        if (session != null) {
            session.removeAttribute(VIEWED_VIDEOS_KEY);
        }
    }
}