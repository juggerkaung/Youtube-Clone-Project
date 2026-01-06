package Servlet;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import Model.Channel;
import Repository.ChannelRepository;

@WebServlet("/editChannelProfile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class EditChannelProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";
       
    public EditChannelProfileServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Channel channel = (Channel) session.getAttribute("channel");
        
        if (channel == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.getRequestDispatcher("editChannelProfile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Channel channel = (Channel) session.getAttribute("channel");
        
        if (channel == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Debug: Print all parameters
            System.out.println("=== DEBUG: Form Parameters ===");
            String displayName = request.getParameter("displayName");
            String description = request.getParameter("description");
            
            System.out.println("displayName parameter: " + displayName);
            System.out.println("description parameter: " + description);
            System.out.println("Current channel ID: " + channel.getId());
            System.out.println("Current displayName: " + channel.getDisplayName());
            
            // Check if parameters are null and use current values as fallback
            if (displayName == null || displayName.trim().isEmpty()) {
                displayName = channel.getDisplayName();
                System.out.println("Using current displayName: " + displayName);
            }
            
         // Add this after getting the displayName parameter
            String newDisplayName = displayName.trim();
          
         // Check if display name is being changed
            if (!newDisplayName.equals(channel.getDisplayName())) {
                ChannelRepository channelRepo = new ChannelRepository();
                if (channelRepo.isDisplayNameExists(newDisplayName)) {
                    response.sendRedirect("editChannelProfile?error=Channel name '" + newDisplayName + "' is already taken. Please choose a different name.");
                    return;
                }
            }
            
            
            if (description == null) {
                description = channel.getDescription();
                System.out.println("Using current description: " + description);
            }
            
            // Handle profile picture upload
            String profilePicturePath = channel.getProfilePicture(); // Keep current if not changed
            
            Part profilePicturePart = request.getPart("profilePicture");
            if (profilePicturePart != null && profilePicturePart.getSize() > 0) {
                System.out.println("Profile picture file detected, size: " + profilePicturePart.getSize());
                
                // Get application path
                String appPath = request.getServletContext().getRealPath("");
                String uploadPath = appPath + File.separator + UPLOAD_DIR;
                
                // Create uploads directory if it doesn't exist
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                    System.out.println("Created upload directory: " + uploadPath);
                }
                
                // Create avatars subdirectory
                File avatarsDir = new File(uploadPath + File.separator + "avatars");
                if (!avatarsDir.exists()) {
                    avatarsDir.mkdirs();
                    System.out.println("Created avatars directory: " + avatarsDir.getAbsolutePath());
                }
                
                String originalFileName = getFileName(profilePicturePart);
                String cleanFileName = cleanFileName(originalFileName);
                String fileName = "avatar_" + System.currentTimeMillis() + "_" + cleanFileName;
                profilePicturePath = UPLOAD_DIR + "/avatars/" + fileName;
                String fullPath = uploadPath + File.separator + "avatars" + File.separator + fileName;
                profilePicturePart.write(fullPath);
                
                System.out.println("Profile picture saved to: " + fullPath);
            } else {
                System.out.println("No profile picture uploaded, keeping current one");
            }
            
            // Update channel in database
            channel.setDisplayName(displayName);
            channel.setDescription(description);
            channel.setProfilePicture(profilePicturePath);
            
            System.out.println("Updating channel with:");
            System.out.println(" - displayName: " + channel.getDisplayName());
            System.out.println(" - description: " + channel.getDescription());
            System.out.println(" - profilePicture: " + channel.getProfilePicture());
            
            ChannelRepository channelRepo = new ChannelRepository();
            int result = channelRepo.updateChannel(channel);
            
            if (result > 0) {
                System.out.println("Channel updated successfully in database");
                // Update the channel in session
                session.setAttribute("channel", channel);
               // response.sendRedirect("editChannelProfile?success=true");
                response.sendRedirect("editChannelProfile?success=Profile updated successfully");
            } else {
                System.out.println("Channel update failed in database");
                response.sendRedirect("editChannelProfile?error=Update failed");
            }
            
        } catch (Exception e) {
            System.out.println("Error in EditChannelProfileServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("editChannelProfile?error=Server error: " + e.getMessage());
        }
    }
    
    private String cleanFileName(String fileName) {
        String cleanName = new File(fileName).getName();
        cleanName = cleanName.replaceAll("\\s+", "_");
        cleanName = cleanName.replaceAll("[^a-zA-Z0-9._-]", "");
        return cleanName;
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}