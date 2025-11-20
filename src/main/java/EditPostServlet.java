import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/EditPostServlet")
public class EditPostServlet extends HttpServlet {
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
    int postId = Integer.parseInt(request.getParameter("id"));
    String caption = request.getParameter("caption");
    String tags = request.getParameter("tags");
    String visibility = request.getParameter("visibility");

    try (Connection conn = DBConnection.getConnection()) {
      String sql = "UPDATE posts SET caption = ?, tags = ?, visibility = ? WHERE id = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, caption);
      stmt.setString(2, tags);
      stmt.setString(3, visibility);
      stmt.setInt(4, postId);
      stmt.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    }

    response.sendRedirect("profile.jsp");
  }
}
