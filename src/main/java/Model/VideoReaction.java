package Model;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VideoReaction {
//	Table: video_reactions
//	Columns:
//	id int AI PK 
//	user_id int 
//	video_id int 
//	reaction_type enum('like','dislike') 
//	created_at timestamp
    private int id;
    private int userId;
    private int videoId;
    private String reactionType; // 'like' or 'dislike'
    private Timestamp createdAt;
}