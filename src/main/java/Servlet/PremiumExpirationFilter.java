package Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Model.Channel;
import Repository.ChannelRepository;

@WebServlet("/checkPremiumExpiration")
public class PremiumExpirationFilter extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public PremiumExpirationFilter() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            Channel channel = (Channel) session.getAttribute("channel");
            
            if (channel != null && "1".equals(channel.getIsPremium())) {
                try {
                    ChannelRepository channelRepo = new ChannelRepository();
                    
                    // Check if premium has expired
                    boolean isExpired = channelRepo.isPremiumExpired(channel.getId());
                    
                    if (isExpired) {
                        // Update the channel status
                        channelRepo.checkAndUpdatePremiumExpiration(channel.getId());
                        
                        // Get fresh channel data
                        Channel updatedChannel = channelRepo.getChannelById(channel.getId());
                        session.setAttribute("channel", updatedChannel);
                        
                        response.getWriter().write("PREMIUM_EXPIRED");
                    } else {
                        response.getWriter().write("PREMIUM_ACTIVE");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.getWriter().write("ERROR");
                }
            } else {
                response.getWriter().write("NOT_PREMIUM");
            }
        } else {
            response.getWriter().write("NO_SESSION");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
