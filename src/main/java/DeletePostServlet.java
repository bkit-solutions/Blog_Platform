import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DeletePostServlet")
public class DeletePostServlet extends HttpServlet {
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
    int postId = Integer.parseInt(request.getParameter("id"));

    try (Connection conn = DBConnection.getConnection()) {
      String sql = "DELETE FROM posts WHERE id = ?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, postId);
      stmt.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    }

    response.sendRedirect("profile.jsp");
  }
}
