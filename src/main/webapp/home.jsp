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
  <title>Pydah_Blog | Home</title>
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
      color: white; text-decoration: none; margin: 15px 0;
      font-size: 16px; font-weight: 500;
    }
    .sidebar a:hover {
      background-color: rgba(255, 255, 255, 0.2); padding: 8px 10px; border-radius: 8px;
    }
    .main { margin-left: 260px; padding: 40px; width: 100%; }
    .feed-header { margin-bottom: 20px; }
    .feed-header h3 { font-size: 22px; margin-bottom: 6px; }

    .user-boxes {
      display: flex;
      flex-wrap: wrap;
      gap: 25px;
      margin-bottom: 40px;
    }
    .user-box {
      background: white;
      padding: 20px;
      border-radius: 12px;
      width: 220px;
      text-align: center;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .user-box img {
      width: 90px; height: 90px; border-radius: 50%;
      object-fit: cover; border: 2px solid #f3706c; margin-bottom: 12px;
    }
    .user-box h5 { margin-bottom: 8px; font-weight: 600; color: #333; }
    .user-box form button {
      padding: 8px 16px;
      border: none;
      border-radius: 20px;
      cursor: pointer;
      color: white;
    }
    .user-box form button.follow { background-color: #ff5f6d; }
    .user-box form button.unfollow { background-color: #aaa; }

    .posts {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 25px;
    }
    .card {
      background: white;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .card img {
      width: 100%;
      height: 300px;
      object-fit: cover;
    }
    .card-body { padding: 15px; }
    .card-body h6 { margin: 0 0 6px; color: #555; }
    .card-body p { margin: 0; }

    .interaction {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 0 15px 10px;
    }
    .like-btn {
      background: none;
      border: none;
      font-size: 18px;
      cursor: pointer;
      color: #e74c3c;
    }

    .comments {
      padding: 0 15px 10px;
    }

    .comments form {
      display: flex;
      gap: 8px;
      margin-top: 10px;
    }

    .comments input {
      flex: 1;
      padding: 8px;
      border: 1px solid #ccc;
      border-radius: 6px;
    }

    .comments button {
      padding: 8px 12px;
      background-color: #007bff;
      border: none;
      color: white;
      border-radius: 6px;
      cursor: pointer;
    }

    .comment-item {
      margin: 6px 0;
      font-size: 14px;
      color: #444;
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
    <div class="feed-header">
      <h3>Welcome, <%= session.getAttribute("username") %> 👋</h3>
      <p class="text-muted">Here’s your feed from users you follow.</p>
    </div>

    <!-- Suggested Users -->
    <div class="user-boxes">
    <%
      Connection conn2 = null;
      PreparedStatement stmt2 = null;
      ResultSet rs2 = null;
      try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/insta_blog", "root", "ijustDh53@");

          String sql = "SELECT u.id, u.username, u.profile_pic, " +
                       "EXISTS (SELECT 1 FROM followers f WHERE f.follower_id = ? AND f.following_id = u.id) AS is_following " +
                       "FROM users u WHERE u.id != ?";
          stmt2 = conn2.prepareStatement(sql);
          stmt2.setInt(1, userId);
          stmt2.setInt(2, userId);
          rs2 = stmt2.executeQuery();

          while (rs2.next()) {
              boolean isFollowing = rs2.getBoolean("is_following");
    %>
      <div class="user-box">
        <img src="uploads/<%= rs2.getString("profile_pic") %>" />
        <h5>@<%= rs2.getString("username") %></h5>
        <form action="FollowServlet" method="post">
          <input type="hidden" name="profileId" value="<%= rs2.getInt("id") %>" />
          <input type="hidden" name="action" value="<%= isFollowing ? "unfollow" : "follow" %>" />
          <button type="submit" class="<%= isFollowing ? "unfollow" : "follow" %>">
            <%= isFollowing ? "Unfollow" : "Follow" %>
          </button>
        </form>
      </div>
    <%
          }
      } catch (Exception e) {
          out.println("<p>Error loading users: " + e.getMessage() + "</p>");
      } finally {
          if (rs2 != null) rs2.close();
          if (stmt2 != null) stmt2.close();
          if (conn2 != null) conn2.close();
      }
    %>
    </div>

    <!-- Posts Feed -->
    <div class="posts">
    <%
      Connection conn = null;
      PreparedStatement stmt = null;
      ResultSet rs = null;
      try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/insta_blog", "root", "ijustDh53@");

          String sql = "SELECT p.*, u.username, " +
                       "(SELECT COUNT(*) FROM likes l WHERE l.post_id = p.id) AS like_count, " +
                       "(SELECT COUNT(*) FROM likes l WHERE l.post_id = p.id AND l.user_id = ?) AS liked " +
                       "FROM posts p " +
                       "JOIN followers f ON p.user_id = f.following_id " +
                       "JOIN users u ON p.user_id = u.id " +
                       "WHERE f.follower_id = ? " +
                       "ORDER BY p.created_at DESC";

          stmt = conn.prepareStatement(sql);
          stmt.setInt(1, userId);
          stmt.setInt(2, userId);
          rs = stmt.executeQuery();

          while (rs.next()) {
            int postId = rs.getInt("id");
    %>
      <div class="card">
        <img src="uploads/<%= rs.getString("image_url") %>" />
        <div class="card-body">
          <h6>@<%= rs.getString("username") %></h6>
          <p><%= rs.getString("caption") %></p>
        </div>

        <div class="interaction">
          <form action="LikeServlet" method="post">
            <input type="hidden" name="postId" value="<%= postId %>" />
            <button class="like-btn" type="submit">
              ❤️ <%= rs.getInt("like_count") %>
            </button>
          </form>
        </div>

        <div class="comments">
          <%
            PreparedStatement cStmt = conn.prepareStatement(
              "SELECT c.comment, u.username FROM comments c JOIN users u ON c.user_id = u.id WHERE c.post_id = ? ORDER BY c.commented_at DESC LIMIT 3"
            );
            cStmt.setInt(1, postId);
            ResultSet cRs = cStmt.executeQuery();
            while (cRs.next()) {
          %>
            <div class="comment-item"><b>@<%= cRs.getString("username") %></b>: <%= cRs.getString("comment") %></div>
          <%
            }
            cRs.close(); cStmt.close();
          %>

          <form action="CommentServlet" method="post">
            <input type="hidden" name="postId" value="<%= postId %>" />
            <input type="text" name="comment" placeholder="Write a comment..." required />
            <button type="submit">Post</button>
          </form>
        </div>
      </div>
    <%
          }
      } catch (Exception e) {
          out.println("<p>Error loading feed: " + e.getMessage() + "</p>");
      } finally {
          if (rs != null) rs.close();
          if (stmt != null) stmt.close();
          if (conn != null) conn.close();
      }
    %>
    </div>
  </div>
</body>
</html>
