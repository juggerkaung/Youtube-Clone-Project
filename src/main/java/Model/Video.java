package Model;

import java.sql.Timestamp;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Video {
//	Table: videos
//	Columns:
//	id int AI PK 
//	channel_id int 
//	video_title varchar(255) 
//	video_description text 
//	video_url varchar(500) 
//	thumbnail varchar(500) 
//	duration int 
//	views_count bigint 
//	likes_count int 
//	dislike_count int 
//	public enum('1','0') 
//	created_at timestamp 
//	updated_at timestamp
	private int id;
	private int channelId;
	private String videoTitle;
	private String videoDescription;
	private String videoUrl;
	private String thumbnail;
	private int duration;
	private long viewsCount = 0;
	private int likesCount;
	private int dislikeCount;
	private String isPublic;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	// Additional fileds for display (not in database)
	private String channelName;
	private String channelProfilePicture;	
	// In Video.java, add this field with getter and setter:
	private String matchType; // "title", "description", or "none"
    private String videoType; // 'regular' or 'short'
 // In Video.java, add these fields:
    private String copyrightStatus = "none"; // "none", "claim", "strike"
    private String copyrightReason;
    private Integer copyrightVideoId; // ID of the video that caused copyright

    private String originalFilename; // NEW: Store the original uploaded filename

	// Add these getter methods for timestamps
	// In Video.java, replace the existing time formatting methods with these:

	public String getFormattedCreatedAt() {
	    if (createdAt != null) {
	        return formatTimeAgo(createdAt);
	    }
	    return "";
	}

	public String getFormattedUpdatedAt() {
	    if (updatedAt != null && !updatedAt.equals(createdAt)) {
	        return "Updated " + formatTimeAgo(updatedAt);
	    }
	    return "";
	}

	private String formatTimeAgo(java.sql.Timestamp timestamp) {
	    long diff = System.currentTimeMillis() - timestamp.getTime();
	    long diffSeconds = diff / 1000;
	    long diffMinutes = diffSeconds / 60;
	    long diffHours = diffMinutes / 60;
	    long diffDays = diffHours / 24;
	    long diffWeeks = diffDays / 7;
	    long diffMonths = diffDays / 30;
	    long diffYears = diffDays / 365;
	    
	    if (diffYears > 0) {
	        return diffYears + " year" + (diffYears > 1 ? "s" : "") + " ago";
	    } else if (diffMonths > 0) {
	        return diffMonths + " month" + (diffMonths > 1 ? "s" : "") + " ago";
	    } else if (diffWeeks > 0) {
	        return diffWeeks + " week" + (diffWeeks > 1 ? "s" : "") + " ago";
	    } else if (diffDays > 0) {
	        return diffDays + " day" + (diffDays > 1 ? "s" : "") + " ago";
	    } else if (diffHours > 0) {
	        return diffHours + " hour" + (diffHours > 1 ? "s" : "") + " ago";
	    } else if (diffMinutes > 0) {
	        return diffMinutes + " minute" + (diffMinutes > 1 ? "s" : "") + " ago";
	    } else {
	        return "Just now";
	    }
	}

	// Add view count formatting method
	public String getFormattedViews() {
	    return formatViewCount(viewsCount);
	}
	
	// Update the view count formatting method to handle long:
		private String formatViewCount(long views) {
		    if (views < 1000) {
		        return String.valueOf(views);
		    } else if (views < 1000000) {
		        double thousands = views / 1000.0;
		        if (thousands == (long) thousands) {
		            return String.format("%dK", (long) thousands);
		        } else {
		            return String.format("%.1fK", thousands);
		        }
		    } else if (views < 1000000000) {
		        double millions = views / 1000000.0;
		        if (millions == (long) millions) {
		            return String.format("%dM", (long) millions);
		        } else {
		            return String.format("%.1fM", millions);
		        }
		    } else {
		        double billions = views / 1000000000.0;
		        if (billions == (long) billions) {
		            return String.format("%dB", (long) billions);
		        } else {
		            return String.format("%.1fB", billions);
		        }
		    }}
}
