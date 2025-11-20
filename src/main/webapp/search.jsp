<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<%
  if (session == null || session.getAttribute("userId") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
  int userId = (int) session.getAttribute("userId");
  String query = request.getParameter("q");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Search | Pydah_Blog</title>
  <style>
    body {
      display: flex;
      font-family: 'Segoe UI', sans-serif;
      background: #f8f9fa;
      margin: 0;
    }

    .sidebar {
      width: 240px;
      height: 100vh;
      background: linear-gradient(to bottom, #ff5f6d, #ffc371);
      color: white;
      padding: 30px 20px;
      position: fixed;
    }

    .sidebar h2 {
      font-size: 22px;
      margin-bottom: 30px;
      font-weight: bold;
    }

    .sidebar a {
      display: block;
      color: white;
      text-decoration: none;
      margin: 15px 0;
      font-size: 16px;
      transition: 0.2s;
    }

    .sidebar a:hover {
      background-color: rgba(255, 255, 255, 0.2);
      padding: 8px;
      border-radius: 8px;
    }

    .main {
      margin-left: 240px;
      padding: 50px 80px;
      width: 100%;
    }

    .search-box {
      margin-bottom: 40px;
      text-align: center;
    }

    .search-box input[type="text"] {
      width: 100%;
      max-width: 500px;
      padding: 14px 20px;
      font-size: 16px;
      border: 1px solid #ccc;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .user-result, .video-result {
      background: white;
      padding: 20px;
      border-radius: 12px;
      margin: 20px auto;
      display: flex;
      align-items: center;
      justify-content: space-between;
      box-shadow: 0 4px 10px rgba(0,0,0,0.07);
      max-width: 550px;
    }

    .user-result img, .video-result img {
      height: 60px;
      width: 60px;
      border-radius: 50%;
      object-fit: cover;
      margin-right: 15px;
    }

    .user-info, .video-info {
      display: flex;
      align-items: center;
    }

    .user-info span, .video-info span {
      font-size: 18px;
      font-weight: 600;
      color: #333;
    }

    .follow-btn {
      padding: 8px 18px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 6px;
      font-weight: 500;
      cursor: pointer;
    }

    .follow-btn:disabled {
      background-color: #aaa;
      cursor: not-allowed;
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
    <form method="get" action="search.jsp" class="search-box">
      <input type="text" name="q" value="<%= query != null ? query : "" %>" placeholder="Search users by name or email..." />
    </form>

    <h3>🔍 Search Results</h3>
    <%
      if (query != null && !query.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/insta_blog", "root", "ijustDh53@");

          String sql = "SELECT id, username, profile_pic FROM users WHERE (username LIKE ? OR email LIKE ?) AND id != ?";
          stmt = conn.prepareStatement(sql);
          stmt.setString(1, "%" + query + "%");
          stmt.setString(2, "%" + query + "%");
          stmt.setInt(3, userId);
          rs = stmt.executeQuery();

          while (rs.next()) {
    %>
      <div class="user-result">
        <div class="user-info">
          <img src="uploads/<%= rs.getString("profile_pic") %>" alt="pic" />
          <span>@<%= rs.getString("username") %></span>
        </div>
        <form action="FollowServlet" method="post">
          <input type="hidden" name="followId" value="<%= rs.getInt("id") %>" />
          <button class="follow-btn" type="submit">Follow</button>
        </form>
      </div>
    <%
          }
        } catch (Exception e) {
          out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
          if (rs != null) rs.close();
          if (stmt != null) stmt.close();
          if (conn != null) conn.close();
        }

        // YouTube API Results
        try {
          String apiKey = "AIzaSyDMFs5yqpXYx_Ch71yvSFiUeTJwcjocUHw";
          String encodedQuery = URLEncoder.encode(query, "UTF-8");
          String apiURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=" + encodedQuery + "&maxResults=3&type=video&key=" + apiKey;

          URL url = new URL(apiURL);
          HttpURLConnection con = (HttpURLConnection) url.openConnection();
          con.setRequestMethod("GET");

          BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
          String inputLine;
          StringBuffer content = new StringBuffer();
          while ((inputLine = in.readLine()) != null) {
              content.append(inputLine);
          }
          in.close();

          JSONObject json = new JSONObject(content.toString());
          JSONArray items = json.getJSONArray("items");

          for (int i = 0; i < items.length(); i++) {
            JSONObject video = items.getJSONObject(i);
            JSONObject snippet = video.getJSONObject("snippet");
            String title = snippet.getString("title");
            String thumbnail = snippet.getJSONObject("thumbnails").getJSONObject("default").getString("url");
            String videoId = video.getJSONObject("id").getString("videoId");
    %>
      <div class="video-result">
        <div class="video-info">
          <img src="<%= thumbnail %>" />
          <span><a href="https://www.youtube.com/watch?v=<%= videoId %>" target="_blank"><%= title %></a></span>
        </div>
      </div>
    <%
          }
        } catch (Exception e) {
          out.println("<p style='color:red;'>YouTube API Error: " + e.getMessage() + "</p>");
        }
      }
    %>
  </div>
</body>
</html>
