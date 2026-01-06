
package Util;

import java.io.File;

public class VideoMetadataUtil {
    
    public static int getVideoDuration(File videoFile) {
        System.out.println("VideoMetadataUtil: Getting duration for: " + videoFile.getAbsolutePath());
        
        long fileSizeInBytes = videoFile.length();
        long fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        
        System.out.println("VideoMetadataUtil: File size: " + fileSizeInMB + " MB");
        
        // More accurate estimation for short videos
        // Based on typical bitrates for common video formats
        
        if (fileSizeInMB < 0.5) {
            return 5;   // 0-0.5MB: 5 seconds (very short)
        } else if (fileSizeInMB < 1) {
            return 10;  // 0.5-1MB: 10 seconds
        } else if (fileSizeInMB < 2) {
            return 15;  // 1-2MB: 15 seconds
        } else if (fileSizeInMB < 3) {
            return 20;  // 2-3MB: 20 seconds
        } else if (fileSizeInMB < 4) {
            return 25;  // 3-4MB: 25 seconds
        } else if (fileSizeInMB < 5) {
            return 30;  // 4-5MB: 30 seconds
        } else if (fileSizeInMB < 7) {
            return 45;  // 5-7MB: 45 seconds
        } else if (fileSizeInMB < 10) {
            return 60;  // 7-10MB: 60 seconds (1 minute)
        } else if (fileSizeInMB < 15) {
            return 90;  // 10-15MB: 90 seconds (1.5 minutes)
        } else if (fileSizeInMB < 25) {
            return 120; // 15-25MB: 120 seconds (2 minutes)
        } else if (fileSizeInMB < 40) {
            return 180; // 25-40MB: 180 seconds (3 minutes)
        } else if (fileSizeInMB < 60) {
            return 240; // 40-60MB: 240 seconds (4 minutes)
        } else if (fileSizeInMB < 80) {
            return 300; // 60-80MB: 300 seconds (5 minutes)
        } else if (fileSizeInMB < 120) {
            return 420; // 80-120MB: 420 seconds (7 minutes)
        } else if (fileSizeInMB < 200) {
            return 600; // 120-200MB: 600 seconds (10 minutes)
        } else {
            return 900; // 200+ MB: 900 seconds (15 minutes)
        }   }}