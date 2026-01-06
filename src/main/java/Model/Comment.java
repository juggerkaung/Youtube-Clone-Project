package Model;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Comment {
	// Table: comments
	// Columns:
	// id int AI PK 
	// user_id int 
	// video_id int 
	// comment_text text 
	// created_at timestamp 
	// updated_at timestamp
	private int id;
	private int userId;
	private int videoId;
	private String commentText;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	// Additional fields for display
	private String userDisplayName;
	private String userProfilePicture;
    private String isPinned = "0"; // '1' for pinned, '0' for not pinned
}
