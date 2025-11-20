<%@ page import="java.sql.*,jakarta.servlet.http.*,jakarta.servlet.*" %>
<%
    int currentUserId = (int) session.getAttribute("userId");
    int profileId = Integer.parseInt(request.getParameter("id")); // user being viewed

    boolean isFollowing = false;
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/insta_blog", "root", "ijustDh53@");

        // Check if current user follows this profile
        String followCheck = "SELECT * FROM followers WHERE follower_id = ? AND following_id = ?";
        stmt = conn.prepareStatement(followCheck);
        stmt.setInt(1, currentUserId);
        stmt.setInt(2, profileId);
        rs = stmt.executeQuery();
        isFollowing = rs.next();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
  <title>User Profile</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">
  <h2>Viewing User ID: <%= profileId %></h2>
  <form action="FollowServlet" method="post">
    <input type="hidden" name="profileId" value="<%= profileId %>" />
    <button class="btn btn-<%= isFollowing ? "danger" : "primary" %>" name="action" value="<%= isFollowing ? "unfollow" : "follow" %>">
      <%= isFollowing ? "Unfollow" : "Follow" %>
    </button>
  </form>
</body>
</html>
