<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
  int postId = Integer.parseInt(request.getParameter("id"));
  Connection conn = null;
  PreparedStatement stmt = null;
  ResultSet rs = null;
  String caption = "", tags = "", visibility = "";

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/insta_blog", "root", "ijustDh53@");
    String sql = "SELECT * FROM posts WHERE id = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setInt(1, postId);
    rs = stmt.executeQuery();

    if (rs.next()) {
      caption = rs.getString("caption");
      tags = rs.getString("tags");
      visibility = rs.getString("visibility");
    }
  } catch (Exception e) {
    out.println("Error loading post.");
  } finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
  }
%>

<!DOCTYPE html>
<html>
<head>
  <title>Edit Post</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="container mt-5">
  <h2>Edit Post</h2>
  <form method="post" action="EditPostServlet">
    <input type="hidden" name="id" value="<%= postId %>" />
    <div class="mb-3">
      <label>Caption</label>
      <textarea name="caption" class="form-control" rows="3"><%= caption %></textarea>
    </div>
    <div class="mb-3">
      <label>Tags</label>
      <input type="text" name="tags" class="form-control" value="<%= tags %>" />
    </div>
    <div class="mb-3">
      <label>Visibility</label>
      <select name="visibility" class="form-control">
        <option value="public" <%= "public".equals(visibility) ? "selected" : "" %>>Public</option>
        <option value="followers" <%= "followers".equals(visibility) ? "selected" : "" %>>Followers</option>
        <option value="private" <%= "private".equals(visibility) ? "selected" : "" %>>Private</option>
      </select>
    </div>
    <button class="btn btn-success">Save Changes</button>
  </form>
</body>
</html>
