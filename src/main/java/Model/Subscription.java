package Model;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Subscription {
//	Table: subscriptions
//	Columns:
//	id int AI PK 
//	subscriber_id int 
//	channel_id int 
//	created_at timestamp
    private int id;
    private int subscriberId;
    private int channelId;
    private Timestamp createdAt;
}