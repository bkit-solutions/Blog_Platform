import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.nio.file.*;

@WebServlet("/UploadPostServlet")
@MultipartConfig
public class UploadPostServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Part filePart = request.getPart("image");
        String caption = request.getParameter("caption");
        String tags = request.getParameter("tags");
        String visibility = request.getParameter("visibility");

        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String savePath = getServletContext().getRealPath("") + "uploads" + File.separator + fileName;

        // Save image to uploads/ directory
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, new File(savePath).toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        // Save post data to database
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO posts (user_id, image_url, caption, tags, visibility) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, fileName);
            stmt.setString(3, caption);
            stmt.setString(4, tags);
            stmt.setString(5, visibility);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("profile.jsp");
    }
}
