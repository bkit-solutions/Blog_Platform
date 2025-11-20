import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/LikeServlet")
public class LikeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int userId = (int) request.getSession().getAttribute("userId");
        int postId = Integer.parseInt(request.getParameter("postId"));

        try (Connection conn = DBConnection.getConnection()) {
            // Check if already liked
            String checkSql = "SELECT * FROM likes WHERE user_id = ? AND post_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, userId);
            checkStmt.setInt(2, postId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Unlike
                String deleteSql = "DELETE FROM likes WHERE user_id = ? AND post_id = ?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                deleteStmt.setInt(1, userId);
                deleteStmt.setInt(2, postId);
                deleteStmt.executeUpdate();
            } else {
                // Like
                String insertSql = "INSERT INTO likes (user_id, post_id) VALUES (?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, userId);
                insertStmt.setInt(2, postId);
                insertStmt.executeUpdate();

                // Get post owner
                String ownerSql = "SELECT user_id FROM posts WHERE id = ?";
                PreparedStatement ownerStmt = conn.prepareStatement(ownerSql);
                ownerStmt.setInt(1, postId);
                ResultSet ownerRs = ownerStmt.executeQuery();

                if (ownerRs.next()) {
                    int ownerId = ownerRs.getInt("user_id");
                    if (ownerId != userId) {
                        String notifySql = "INSERT INTO notifications (user_id, source_user_id, post_id, type) VALUES (?, ?, ?, 'like')";
                        PreparedStatement notifyStmt = conn.prepareStatement(notifySql);
                        notifyStmt.setInt(1, ownerId);
                        notifyStmt.setInt(2, userId);
                        notifyStmt.setInt(3, postId);
                        notifyStmt.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("home.jsp");
    }
}
