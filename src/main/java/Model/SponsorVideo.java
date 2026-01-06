package Model;

import java.sql.Timestamp;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SponsorVideo {
//	Table: sponsor_videos
//	Columns:
//	id int AI PK 
//	title varchar(255) 
//	description text 
//	video_url varchar(500) 
//	thumbnail varchar(500) 
//	duration int 
//	is_active enum('1','0') 
//	created_at timestamp 
//	updated_at timestamp
	
    private int id;
    private String title;
    private String description;
    private String videoUrl;
    private String thumbnail;
    private int duration;
    private String isActive; // '1' for active, '0' for inactive
    private Timestamp createdAt;
    private Timestamp updatedAt;
}