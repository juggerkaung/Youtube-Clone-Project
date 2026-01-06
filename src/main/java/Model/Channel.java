package Model;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Channel {
	
	
//	Table: channels
//  Columns:
//	id int AI PK 
//	email varchar(255) 
//	password varchar(255) 
//	display_name varchar(200) 
//	profile_picture varchar(500) 
//	description text 
//	role_id int 
//	is_active enum('1','0') 
//	created_at timestamp 
//	updated_at timestamp
//  subscriber_count int
//	is_premium enum('1','0') 
//	premium_since timestamp 
//	theme_preference varchar(20)
	
	
	private int id;
	private String email;
	private String password;
	private String displayName;
	private String profilePicture;
	private String description;
	private int roleId;
	private String isActive;
	private Timestamp createdAt;
	private Timestamp updatedAt;
    private int subscriberCount; 
    
    // Add these new fields
    private String isPremium; // '1' for premium, '0' for regular
    private Timestamp premiumSince;
    private String themePreference; // 'light', 'dark', 'gold'
    
    // Add getter method to check if channel can access gold theme
    public boolean canAccessGoldTheme() {
        return "1".equals(isPremium);
    }   
}
