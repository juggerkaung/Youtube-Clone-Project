package Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.Video;
import Model.Channel;
import Repository.VideoRepository;
import Repository.ChannelRepository;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Calendar;

/**
 * Servlet implementation class SearchServlet
 */
@WebServlet("/search")
public class SearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SearchServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	/*
	 * String query = request.getParameter("query");
	 * 
	 * System.out.println("SearchServlet: Received search query: " + query);
	 * 
	 * // Get filter parameters String uploadDate =
	 * request.getParameter("uploadDate"); String type =
	 * request.getParameter("type"); String sortBy = request.getParameter("sortBy");
	 * 
	 * System.out .println("SearchServlet: Filters - uploadDate=" + uploadDate +
	 * ", type=" + type + ", sortBy=" + sortBy);
	 * 
	 * if (query == null || query.trim().isEmpty()) { response.sendRedirect("home");
	 * return; }
	 * 
	 * try { VideoRepository videoRepo = new VideoRepository(); ChannelRepository
	 * channelRepo = new ChannelRepository();
	 * 
	 * // Get all videos and channels List<Video> allVideos =
	 * videoRepo.getAllPublicVideos(); List<Channel> allChannels =
	 * channelRepo.getAllActiveChannels();
	 * 
	 * List<Video> searchResults = new ArrayList<>(); List<Video> titleMatches = new
	 * ArrayList<>(); List<Video> descriptionMatches = new ArrayList<>();
	 * List<Channel> channelMatches = new ArrayList<>();
	 * 
	 * // Map to track match types for each video Map<Integer, String> matchTypeMap
	 * = new HashMap<>();
	 * 
	 * String searchTerm = query.toLowerCase().trim();
	 * 
	 * System.out.println("SearchServlet: Processing " + allVideos.size() +
	 * " videos and " + allChannels.size() + " channels");
	 * 
	 * // Search in videos (title and description) for (Video video : allVideos) {
	 * boolean titleMatch =
	 * video.getVideoTitle().toLowerCase().contains(searchTerm); boolean
	 * descriptionMatch = video.getVideoDescription() != null &&
	 * video.getVideoDescription().toLowerCase().contains(searchTerm);
	 * 
	 * if (titleMatch) { titleMatches.add(video); matchTypeMap.put(video.getId(),
	 * "title"); System.out.println("SearchServlet: Title match: " +
	 * video.getVideoTitle()); } else if (descriptionMatch) {
	 * descriptionMatches.add(video); matchTypeMap.put(video.getId(),
	 * "description"); System.out.println("SearchServlet: Description match: " +
	 * video.getVideoTitle()); } }
	 * 
	 * // Search in channels (display name and description) for (Channel channel :
	 * allChannels) { boolean channelNameMatch =
	 * channel.getDisplayName().toLowerCase().contains(searchTerm); boolean
	 * channelDescMatch = channel.getDescription() != null &&
	 * channel.getDescription().toLowerCase().contains(searchTerm);
	 * 
	 * if (channelNameMatch || channelDescMatch) { channelMatches.add(channel);
	 * System.out.println("SearchServlet: Channel match: " +
	 * channel.getDisplayName()); } }
	 * 
	 * // Combine video results searchResults.addAll(titleMatches);
	 * searchResults.addAll(descriptionMatches);
	 * 
	 * // Apply upload date filter if (uploadDate != null &&
	 * !uploadDate.equals("any")) { searchResults =
	 * filterByUploadDate(searchResults, uploadDate);
	 * System.out.println("SearchServlet: After date filter - " +
	 * searchResults.size() + " videos"); }
	 * 
	 * // Initialize video type lists early List<Video> regularVideos = new
	 * ArrayList<>(); List<Video> shortVideos = new ArrayList<>();
	 * 
	 * // Apply type filter if (type != null && !type.isEmpty()) { if
	 * (type.equals("channel")) { // Only show channel results - clear video results
	 * searchResults.clear(); regularVideos.clear(); shortVideos.clear();
	 * System.out.println("SearchServlet: Showing only channel results"); } else if
	 * (type.equals("video")) { // Only show video results - clear channel results
	 * channelMatches.clear();
	 * System.out.println("SearchServlet: Showing only video results"); } else { //
	 * Show all (videos and channels) - "all" or default
	 * System.out.println("SearchServlet: Showing all results (videos and channels)"
	 * ); } } else { // Default: show all type = "all"; }
	 * 
	 * // Apply sorting only to videos if (sortBy != null &&
	 * !searchResults.isEmpty()) { switch (sortBy) { case "uploadDate":
	 * Collections.sort(searchResults, new Comparator<Video>() {
	 * 
	 * @Override public int compare(Video v1, Video v2) { return
	 * v2.getCreatedAt().compareTo(v1.getCreatedAt()); // Newest first } });
	 * System.out.println("SearchServlet: Sorted by upload date"); break; case
	 * "viewCount": Collections.sort(searchResults, new Comparator<Video>() {
	 * 
	 * @Override public int compare(Video v1, Video v2) { return
	 * Long.compare(v2.getViewsCount(), v1.getViewsCount()); // Highest views first
	 * } }); System.out.println("SearchServlet: Sorted by view count"); break; case
	 * "relevance": default: // Keep relevance order (title matches first, then
	 * description) System.out.println("SearchServlet: Sorted by relevance"); break;
	 * } }
	 * 
	 * // Separate videos by type after all filtering and sorting for (Video video :
	 * searchResults) { if ("short".equals(video.getVideoType())) {
	 * shortVideos.add(video); } else { regularVideos.add(video); } }
	 * 
	 * // Shuffle both lists for random display within categories
	 * Collections.shuffle(regularVideos); Collections.shuffle(shortVideos);
	 * 
	 * System.out.println("SearchServlet: Found " + titleMatches.size() +
	 * " title matches and " + descriptionMatches.size() + " description matches");
	 * System.out.println("SearchServlet: Found " + channelMatches.size() +
	 * " channel matches"); System.out.println("SearchServlet: Regular videos: " +
	 * regularVideos.size()); System.out.println("SearchServlet: Short videos: " +
	 * shortVideos.size());
	 * 
	 * // Calculate total results int totalResults = searchResults.size() +
	 * channelMatches.size();
	 * 
	 * // Set flag for search page request.setAttribute("isSearchPage", true);
	 * 
	 * // Set attributes for JSP request.setAttribute("searchQuery", query);
	 * request.setAttribute("searchResults", searchResults);
	 * request.setAttribute("regularVideos", regularVideos);
	 * request.setAttribute("shortVideos", shortVideos);
	 * request.setAttribute("channelMatches", channelMatches);
	 * request.setAttribute("titleMatchCount", titleMatches.size());
	 * request.setAttribute("descriptionMatchCount", descriptionMatches.size());
	 * request.setAttribute("channelMatchCount", channelMatches.size());
	 * request.setAttribute("matchTypeMap", matchTypeMap);
	 * request.setAttribute("totalResults", totalResults);
	 * 
	 * // Pass filter parameters back to JSP request.setAttribute("uploadDate",
	 * uploadDate != null ? uploadDate : "any"); request.setAttribute("type", type);
	 * request.setAttribute("sortBy", sortBy != null ? sortBy : "relevance");
	 * 
	 * request.getRequestDispatcher("searchResults.jsp").forward(request, response);
	 * 
	 * } catch (Exception e) { System.out.println("SearchServlet Error: " +
	 * e.getMessage()); e.printStackTrace();
	 * response.sendRedirect("home?error=Search failed: " + e.getMessage()); } }
	 * 
	 * private List<Video> filterByUploadDate(List<Video> videos, String uploadDate)
	 * { List<Video> filtered = new ArrayList<>(); Calendar cal =
	 * Calendar.getInstance(); Date now = new Date();
	 * 
	 * // Calculate cutoff date based on filter Date cutoffDate = null; switch
	 * (uploadDate) { case "hour": cal.setTime(now); cal.add(Calendar.HOUR_OF_DAY,
	 * -1); cutoffDate = cal.getTime(); break; case "today": cal.setTime(now);
	 * cal.set(Calendar.HOUR_OF_DAY, 0); cal.set(Calendar.MINUTE, 0);
	 * cal.set(Calendar.SECOND, 0); cal.set(Calendar.MILLISECOND, 0); cutoffDate =
	 * cal.getTime(); break; case "week": cal.setTime(now);
	 * cal.add(Calendar.DAY_OF_YEAR, -7); cutoffDate = cal.getTime(); break; case
	 * "month": cal.setTime(now); cal.add(Calendar.MONTH, -1); cutoffDate =
	 * cal.getTime(); break; case "year": cal.setTime(now); cal.add(Calendar.YEAR,
	 * -1); cutoffDate = cal.getTime(); break; }
	 * 
	 * if (cutoffDate != null) { for (Video video : videos) { if
	 * (video.getCreatedAt() != null && !video.getCreatedAt().before(cutoffDate)) {
	 * filtered.add(video); } } return filtered; }
	 * 
	 * return videos; }
	 */
String query = request.getParameter("query");
        
        System.out.println("SearchServlet: Received search query: " + query);
        
        // Get filter parameters
        String uploadDate = request.getParameter("uploadDate");
        String type = request.getParameter("type");
        String sortBy = request.getParameter("sortBy");
        
        System.out.println("SearchServlet: Filters - uploadDate=" + uploadDate + ", type=" + type + ", sortBy=" + sortBy);
        
        if (query == null || query.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }
        
        try {
            VideoRepository videoRepo = new VideoRepository();
            ChannelRepository channelRepo = new ChannelRepository();
            
            // Get all videos and channels
            List<Video> allVideos = videoRepo.getAllPublicVideos();
            List<Channel> allChannels = channelRepo.getAllActiveChannels();
            
            List<Video> searchResults = new ArrayList<>();
            List<Video> titleMatches = new ArrayList<>();
            List<Video> descriptionMatches = new ArrayList<>();
            List<Channel> channelMatches = new ArrayList<>();
            
            // Map to track match types for each video
            Map<Integer, String> matchTypeMap = new HashMap<>();
            
            String searchTerm = query.toLowerCase().trim();
            
            System.out.println("SearchServlet: Processing " + allVideos.size() + " videos and " + allChannels.size() + " channels");
            
            // Search in videos (title and description)
            for (Video video : allVideos) {
                boolean titleMatch = video.getVideoTitle().toLowerCase().contains(searchTerm);
                boolean descriptionMatch = video.getVideoDescription() != null && 
                                         video.getVideoDescription().toLowerCase().contains(searchTerm);
                
                if (titleMatch) {
                    titleMatches.add(video);
                    matchTypeMap.put(video.getId(), "title");
                    System.out.println("SearchServlet: Title match: " + video.getVideoTitle());
                } else if (descriptionMatch) {
                    descriptionMatches.add(video);
                    matchTypeMap.put(video.getId(), "description");
                    System.out.println("SearchServlet: Description match: " + video.getVideoTitle());
                }
            }
            
            // Search in channels (display name and description)
            for (Channel channel : allChannels) {
                boolean channelNameMatch = channel.getDisplayName().toLowerCase().contains(searchTerm);
                boolean channelDescMatch = channel.getDescription() != null && 
                                         channel.getDescription().toLowerCase().contains(searchTerm);
                
                if (channelNameMatch || channelDescMatch) {
                    channelMatches.add(channel);
                    System.out.println("SearchServlet: Channel match: " + channel.getDisplayName());
                }
            }
            
            // Combine video results
            searchResults.addAll(titleMatches);
            searchResults.addAll(descriptionMatches);
            
            // Apply upload date filter
            if (uploadDate != null && !uploadDate.equals("any")) {
                searchResults = filterByUploadDate(searchResults, uploadDate);
                System.out.println("SearchServlet: After date filter - " + searchResults.size() + " videos");
            }
            
            // Separate videos by type BEFORE sorting
            List<Video> regularVideos = new ArrayList<>();
            List<Video> shortVideos = new ArrayList<>();
            
            for (Video video : searchResults) {
                if ("short".equals(video.getVideoType())) {
                    shortVideos.add(video);
                } else {
                    regularVideos.add(video);
                }
            }
            
            // Apply type filter
            if (type != null && !type.isEmpty()) {
                if (type.equals("channel")) {
                    // Only show channel results - clear video results
                    searchResults.clear();
                    regularVideos.clear();
                    shortVideos.clear();
                    System.out.println("SearchServlet: Showing only channel results");
                } else if (type.equals("video")) {
                    // Only show video results - clear channel results
                    channelMatches.clear();
                    System.out.println("SearchServlet: Showing only video results");
                } else {
                    // Show all (videos and channels) - "all" or default
                    System.out.println("SearchServlet: Showing all results (videos and channels)");
                }
            } else {
                // Default: show all
                type = "all";
            }
            
            // Apply sorting to EACH list separately
            if (sortBy != null) {
                Comparator<Video> comparator = null;
                
                switch (sortBy) {
                    case "uploadDate":
                        comparator = new Comparator<Video>() {
                            @Override
                            public int compare(Video v1, Video v2) {
                                return v2.getCreatedAt().compareTo(v1.getCreatedAt()); // Newest first
                            }
                        };
                        System.out.println("SearchServlet: Sorting by upload date");
                        break;
                    case "viewCount":
                        comparator = new Comparator<Video>() {
                            @Override
                            public int compare(Video v1, Video v2) {
                                return Long.compare(v2.getViewsCount(), v1.getViewsCount()); // Highest views first
                            }
                        };
                        System.out.println("SearchServlet: Sorting by view count");
                        break;
                    case "relevance":
                    default:
                        // For relevance, we want title matches first, then description matches
                        // But we already separated them earlier
                        System.out.println("SearchServlet: Sorting by relevance");
                        // For relevance, we don't need to sort within categories
                        break;
                }
                
                // Sort each list with the comparator if it exists
                if (comparator != null) {
                    if (!regularVideos.isEmpty()) {
                        Collections.sort(regularVideos, comparator);
                    }
                    if (!shortVideos.isEmpty()) {
                        Collections.sort(shortVideos, comparator);
                    }
                }
            }
            
            // ONLY shuffle if we're sorting by relevance
            if (sortBy == null || sortBy.equals("relevance")) {
                // Shuffle both lists for random display within categories (only for relevance)
                Collections.shuffle(regularVideos);
                Collections.shuffle(shortVideos);
                System.out.println("SearchServlet: Shuffled videos for relevance display");
            }
            
            // Recreate searchResults from sorted lists for display consistency
            searchResults.clear();
            searchResults.addAll(regularVideos);
            searchResults.addAll(shortVideos);
            
            System.out.println("SearchServlet: Found " + titleMatches.size() + " title matches and " + 
                             descriptionMatches.size() + " description matches");
            System.out.println("SearchServlet: Found " + channelMatches.size() + " channel matches");
            System.out.println("SearchServlet: Regular videos: " + regularVideos.size());
            System.out.println("SearchServlet: Short videos: " + shortVideos.size());
            
            // Calculate total results
            int totalResults = searchResults.size() + channelMatches.size();
            
            // Set flag for search page
            request.setAttribute("isSearchPage", true);
            
            // Set attributes for JSP
            request.setAttribute("searchQuery", query);
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("regularVideos", regularVideos);
            request.setAttribute("shortVideos", shortVideos);
            request.setAttribute("channelMatches", channelMatches);
            request.setAttribute("titleMatchCount", titleMatches.size());
            request.setAttribute("descriptionMatchCount", descriptionMatches.size());
            request.setAttribute("channelMatchCount", channelMatches.size());
            request.setAttribute("matchTypeMap", matchTypeMap);
            request.setAttribute("totalResults", totalResults);
            
            // Pass filter parameters back to JSP
            request.setAttribute("uploadDate", uploadDate != null ? uploadDate : "any");
            request.setAttribute("type", type);
            request.setAttribute("sortBy", sortBy != null ? sortBy : "relevance");
            
            request.getRequestDispatcher("searchResults.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("SearchServlet Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("home?error=Search failed: " + e.getMessage());
        }
    }
    
    private List<Video> filterByUploadDate(List<Video> videos, String uploadDate) {
        List<Video> filtered = new ArrayList<>();
        Calendar cal = Calendar.getInstance();
        Date now = new Date();
        
        // Calculate cutoff date based on filter
        Date cutoffDate = null;
        switch (uploadDate) {
            case "hour":
                cal.setTime(now);
                cal.add(Calendar.HOUR_OF_DAY, -1);
                cutoffDate = cal.getTime();
                break;
            case "today":
                cal.setTime(now);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                cal.set(Calendar.MILLISECOND, 0);
                cutoffDate = cal.getTime();
                break;
            case "week":
                cal.setTime(now);
                cal.add(Calendar.DAY_OF_YEAR, -7);
                cutoffDate = cal.getTime();
                break;
            case "month":
                cal.setTime(now);
                cal.add(Calendar.MONTH, -1);
                cutoffDate = cal.getTime();
                break;
            case "year":
                cal.setTime(now);
                cal.add(Calendar.YEAR, -1);
                cutoffDate = cal.getTime();
                break;
        }
        
        if (cutoffDate != null) {
            for (Video video : videos) {
                if (video.getCreatedAt() != null && !video.getCreatedAt().before(cutoffDate)) {
                    filtered.add(video);
                }
            }
            return filtered;
        }
        
        return videos;
    }		
		
		

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}