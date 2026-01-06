package Model;

import java.sql.Timestamp;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Playlist {
	
//	Table: playlists
//	Columns:
//	id int AI PK 
//	channel_id int 
//	name varchar(255) 
//	description text 
//	is_public enum('1','0') 
//	created_at timestamp 
//	updated_at timestamp
	private int id;
    private int channelId;
    private String name;
    private String description;
    private String isPublic; // '1' for public, '0' for private
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display
    private String channelName;
    private String channelProfilePicture;
    private int videoCount;
    private List<Video> videos;
    
    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            long diff = System.currentTimeMillis() - createdAt.getTime();
            long diffDays = diff / (1000 * 60 * 60 * 24);
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
            } else {
                return "Today";
            }
        }
        return "";
    }
}