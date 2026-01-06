// src/main/java/Util/ChannelStatusUtil.java
package Util;

import Repository.ChannelRepository;
import Model.Channel;

public class ChannelStatusUtil {
    
    public static boolean canUploadVideos(int channelId) throws Exception {
        ChannelRepository channelRepo = new ChannelRepository();
        Channel channel = channelRepo.getChannelById(channelId);
        
        if (channel == null) {
            return false;
        }
        
        // Channel can upload only if active (isActive = '1')
        return "1".equals(channel.getIsActive());
    }
    
    public static boolean canComment(int channelId) throws Exception {
        // Banned channels can still comment
        ChannelRepository channelRepo = new ChannelRepository();
        Channel channel = channelRepo.getChannelById(channelId);
        
        return channel != null; // Only need to be a valid channel
    }
    
    public static String getChannelStatus(int channelId) throws Exception {
        ChannelRepository channelRepo = new ChannelRepository();
        Channel channel = channelRepo.getChannelById(channelId);
        
        if (channel == null) {
            return "not_found";
        }
        
        return channel.getIsActive(); // Returns '1' or '0'
    }
}