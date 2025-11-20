<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Notifications | Pydah_Blog</title>
  <style>
    body {
      display: flex; background: #f8f9fa; margin: 0; font-family: 'Segoe UI', sans-serif;
    }
    .sidebar {
      width: 240px; height: 100vh;
      background: linear-gradient(to bottom, #ff5f6d, #ffc371);
      color: white; padding: 30px 20px; position: fixed;
    }
    .sidebar a {
      display: block; margin: 15px 0;
      color: white; text-decoration: none;
    }
    .main {
      margin-left: 260px; padding: 40px; width: 100%;
    }
    .notification {
      background: white; padding: 16px;
      margin-bottom: 20px; border-radius: 10px;
      box-shadow: 0 3px 10px rgba(0,0,0,0.05);
    }
    .notification p { margin: 0; font-size: 16px; }
    .notification time { font-size: 13px; color: #888; margin-top: 4px; display: block; }
  </style>
</head>
<body>

<div class="sidebar">
  <h2>Pydah_Blog</h2>
  <a href="home.jsp">🏠 Home</a>
  <a href="search.jsp">🔍 Search</a>
  <a href="explore.jsp">🌍 Explore</a>
  <a href="notifications.jsp">🔔 Notifications</a>
  <a href="post.jsp">➕ Create Post</a>
  <a href="profile.jsp">👤 My Profile</a>
  <a href="logout.jsp">🚪 Logout</a>
</div>

<div class="main">
  <h2>🔔 Your Notifications</h2>
  <%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/insta_blog", "root", "ijustDh53@");

        String sql = "SELECT n.*, u.username FROM notifications n " +
                     "JOIN users u ON n.source_user_id = u.id " +
                     "WHERE n.user_id = ? ORDER BY n.created_at DESC";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();

        while (rs.next()) {
            String type = rs.getString("type");
            String actor = rs.getString("username");
            Timestamp ts = rs.getTimestamp("created_at");
  %>
    <div class="notification">
      <p>
        <%
          if ("like".equals(type)) {
            out.print("❤️ @" + actor + " liked your post.");
          } else if ("comment".equals(type)) {
            out.print("💬 @" + actor + " commented on your post.");
          } else if ("follow".equals(type)) {
            out.print("➕ @" + actor + " started following you.");
          }
        %>
      </p>
      <time><%= ts.toString() %></time>
    </div>
  <%
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error loading notifications: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
  %>
</div>
</body>
</html>
