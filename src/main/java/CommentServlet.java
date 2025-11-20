import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        int userId = (int) request.getSession().getAttribute("userId");
        int postId = Integer.parseInt(request.getParameter("postId"));
        String comment = request.getParameter("comment");

        try (Connection conn = DBConnection.getConnection()) {
            // Insert comment
            String insert = "INSERT INTO comments (user_id, post_id, comment) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(insert);
            stmt.setInt(1, userId);
            stmt.setInt(2, postId);
            stmt.setString(3, comment);
            stmt.executeUpdate();

            // Notify post owner
            String getOwnerSql = "SELECT user_id FROM posts WHERE id = ?";
            PreparedStatement ownerStmt = conn.prepareStatement(getOwnerSql);
            ownerStmt.setInt(1, postId);
            ResultSet ownerRs = ownerStmt.executeQuery();

            if (ownerRs.next()) {
                int ownerId = ownerRs.getInt("user_id");
                if (ownerId != userId) {
                    String notifySql = "INSERT INTO notifications (user_id, source_user_id, post_id, type) VALUES (?, ?, ?, 'comment')";
                    PreparedStatement notifyStmt = conn.prepareStatement(notifySql);
                    notifyStmt.setInt(1, ownerId);
                    notifyStmt.setInt(2, userId);
                    notifyStmt.setInt(3, postId);
                    notifyStmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("home.jsp");
    }
}
