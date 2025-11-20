<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
  if (session == null || session.getAttribute("userId") == null) {
      response.sendRedirect("login.jsp");
      return;
  }

  int userId = (Integer) session.getAttribute("userId");
  String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Pydah_Blog | My Profile</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
    body { display: flex; background: #f8f9fa; }
    .sidebar {
      width: 240px; height: 100vh;
      background: linear-gradient(to bottom, #ff5f6d, #ffc371);
      color: white; padding: 30px 20px; position: fixed;
    }
    .sidebar h2 { font-size: 22px; margin-bottom: 30px; font-weight: bold; }
    .sidebar a {
      display: flex; align-items: center; gap: 10px;
      color: white; text-decoration: none;
      margin: 15px 0; font-size: 16px; font-weight: 500;
      transition: all 0.2s ease;
    }
    .sidebar a:hover {
      background-color: rgba(255, 255, 255, 0.2);
      padding: 8px 10px; border-radius: 8px;
    }

    .main { margin-left: 240px; padding: 40px; width: 100%; }
    .profile-info {
      display: flex; align-items: center; gap: 25px;
      margin-bottom: 40px;
    }
    .profile-info img {
      width: 120px; height: 120px;
      border-radius: 50%; object-fit: cover;
      border: 3px solid #ff5f6d;
    }
    .profile-info .bio h3 { margin-bottom: 5px; }
    .profile-info .bio p { color: #555; }

    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 25px;
    }
    .card {
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      overflow: hidden;
    }
    .card img {
      width: 100%;
      height: 280px;
      object-fit: cover;
    }
    .card-body {
      padding: 15px;
    }
    .card-body small {
      display: block;
      color: #888;
      margin-top: 5px;
    }
    .tag-line {
      font-size: 14px;
      color: #555;
      margin-top: 6px;
    }
    .btn-sm {
      display: inline-block;
      margin-right: 10px;
      padding: 6px 14px;
      font-size: 14px;
      border-radius: 6px;
      border: 1px solid transparent;
      cursor: pointer;
      text-decoration: none;
    }
    .btn-outline-primary {
      background: transparent;
      color: #007bff;
      border-color: #007bff;
    }
    .btn-outline-primary:hover {
      background: #007bff;
      color: white;
    }
    .btn-outline-danger {
      background: transparent;
      color: #dc3545;
      border-color: #dc3545;
    }
    .btn-outline-danger:hover {
      background: #dc3545;
      color: white;
    }
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
    <%-- Load user profile info --%>
    <%
      Connection conn = null;
      PreparedStatement stmt = null;
      ResultSet userRs = null;
      String profilePic = "default.jpg";
      String bio = "";

      try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/insta_blog", "root", "ijustDh53@");

          String userSql = "SELECT profile_pic, bio FROM users WHERE id = ?";
          stmt = conn.prepareStatement(userSql);
          stmt.setInt(1, userId);
          userRs = stmt.executeQuery();
          if (userRs.next()) {
              profilePic = userRs.getString("profile_pic") != null ? userRs.getString("profile_pic") : "default.jpg";
              bio = userRs.getString("bio") != null ? userRs.getString("bio") : "";
          }
          userRs.close();
          stmt.close();
    %>

    <!-- Profile Info -->
    <div class="profile-info">
      <img src="uploads/<%= profilePic %>" alt="Profile Pic">
      <div class="bio">
        <h3>@<%= username %></h3>
        <p><%= bio %></p>
      </div>
    </div>

    <%-- Posts Grid --%>
    <div class="grid">
      <%
          String postSql = "SELECT * FROM posts WHERE user_id = ? ORDER BY created_at DESC";
          stmt = conn.prepareStatement(postSql);
          stmt.setInt(1, userId);
          ResultSet rs = stmt.executeQuery();

          while (rs.next()) {
      %>
        <div class="card">
          <img src="uploads/<%= rs.getString("image_url") %>" alt="Post">
          <div class="card-body">
            <p><%= rs.getString("caption") %></p>
            <small>Visibility: <%= rs.getString("visibility") %></small>
            <div class="tag-line">#<%= rs.getString("tags") != null ? rs.getString("tags").replaceAll(",", " #") : "" %></div>

            <div style="margin-top: 10px;">
              <a href="editPost.jsp?id=<%= rs.getInt("id") %>" class="btn-sm btn-outline-primary">Edit</a>
              <a href="DeletePostServlet?id=<%= rs.getInt("id") %>" class="btn-sm btn-outline-danger" onclick="return confirm('Delete this post?')">Delete</a>
            </div>
          </div>
        </div>
      <%
          }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (userRs != null) userRs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
      %>
    </div>
  </div>

</body>
</html>
