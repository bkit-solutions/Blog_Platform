import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/FollowServlet")
public class FollowServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int followerId = (int) request.getSession().getAttribute("userId");
        int followingId = Integer.parseInt(request.getParameter("profileId"));
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("follow".equals(action)) {
                String sql = "INSERT INTO followers (follower_id, following_id) VALUES (?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, followerId);
                stmt.setInt(2, followingId);
                stmt.executeUpdate();

                // Insert notification
                if (followerId != followingId) {
                    String notifySql = "INSERT INTO notifications (user_id, source_user_id, type) VALUES (?, ?, 'follow')";
                    PreparedStatement notifyStmt = conn.prepareStatement(notifySql);
                    notifyStmt.setInt(1, followingId);
                    notifyStmt.setInt(2, followerId);
                    notifyStmt.executeUpdate();
                }
            } else if ("unfollow".equals(action)) {
                String sql = "DELETE FROM followers WHERE follower_id = ? AND following_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, followerId);
                stmt.setInt(2, followingId);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("home.jsp");
    }
}
