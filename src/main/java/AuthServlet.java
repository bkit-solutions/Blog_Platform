import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/AuthServlet")
@MultipartConfig
public class AuthServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            handleRegister(request, response);
        } else if ("login".equals(action)) {
            handleLogin(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String bio = request.getParameter("bio");

        // Upload profile picture
        String fileName = "default.jpg"; // fallback
        try {
            Part profilePic = request.getPart("profile_pic");
            if (profilePic != null && profilePic.getSize() > 0) {
                fileName = Paths.get(profilePic.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + "uploads" + File.separator + fileName;

                File uploadDir = new File(uploadPath).getParentFile();
                if (!uploadDir.exists()) uploadDir.mkdirs();

                try (InputStream is = profilePic.getInputStream()) {
                    Files.copy(is, new File(uploadPath).toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=fileupload");
            return;
        }

        // Password encryption
        String hashedPwd = BCrypt.hashpw(password, BCrypt.gensalt());

        // Save to DB
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (username, email, password, profile_pic, bio) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, hashedPwd);
            stmt.setString(4, fileName);
            stmt.setString(5, bio);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("login.jsp?success=registered");
            } else {
                response.sendRedirect("register.jsp?error=failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=exception");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
    throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String hashedPwd = rs.getString("password");
                if (BCrypt.checkpw(password, hashedPwd)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("username", rs.getString("username"));
                    response.sendRedirect("home.jsp");
                } else {
                    response.sendRedirect("login.jsp?error=invalid");
                }
            } else {
                response.sendRedirect("login.jsp?error=notfound");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=exception");
        }
    }
}
