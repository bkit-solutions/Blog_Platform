<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%
  if (session == null || session.getAttribute("userId") == null) {
      response.sendRedirect("login.jsp");
      return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Pydah_Blog | Upload Post</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Segoe UI', sans-serif;
    }

    body {
      display: flex;
      background: #f8f9fa;
    }

    .sidebar {
      width: 240px;
      height: 100vh;
      background: linear-gradient(to bottom, #ff5f6d, #ffc371);
      color: white;
      padding: 30px 20px;
      position: fixed;
      top: 0;
      left: 0;
    }

    .sidebar h2 {
      font-size: 22px;
      margin-bottom: 30px;
      font-weight: bold;
    }

    .sidebar a {
      display: flex;
      align-items: center;
      gap: 10px;
      color: white;
      text-decoration: none;
      margin: 15px 0;
      font-size: 16px;
      font-weight: 500;
      transition: all 0.2s ease;
    }

    .sidebar a:hover {
      background-color: rgba(255, 255, 255, 0.2);
      padding: 8px 10px;
      border-radius: 8px;
    }

    .main {
      margin-left: 240px;
      padding: 40px;
      width: 100%;
    }

    .form-container {
      max-width: 600px;
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    input, textarea, select {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      border-radius: 8px;
      border: 1px solid #ccc;
      font-size: 15px;
    }

    textarea {
      resize: vertical;
    }

    button {
      background-color: #007bff;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 16px;
    }

    button:hover {
      background-color: #0056b3;
    }

    .image-preview {
      max-width: 100%;
      margin-top: 15px;
      display: none;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    .emoji-toolbar {
      display: flex;
      gap: 10px;
      margin: 5px 0;
    }

    .emoji-toolbar span {
      cursor: pointer;
      font-size: 20px;
    }

    .section-label {
      font-weight: bold;
      margin-top: 15px;
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
    <h2>Upload a New Post</h2>
    <form action="UploadPostServlet" method="post" enctype="multipart/form-data" class="form-container">
      
      <label class="section-label">Choose Image</label>
      <input type="file" name="image" accept="image/*" id="imageInput" required>
      <img id="preview" class="image-preview" alt="Image preview" />

      <label class="section-label">Write a Caption</label>
      <div class="emoji-toolbar">
        <span onclick="insertEmoji('😊')">😊</span>
        <span onclick="insertEmoji('🔥')">🔥</span>
        <span onclick="insertEmoji('💯')">💯</span>
        <span onclick="insertEmoji('🎉')">🎉</span>
      </div>
      <textarea id="caption" name="caption" placeholder="Write a caption..." rows="3" maxlength="300" required></textarea>

      <label class="section-label">Tags (comma-separated)</label>
      <input type="text" name="tags" placeholder="e.g. coding,java,blogging" />

      <label class="section-label">Visibility</label>
      <select name="visibility" required>
        <option value="public">🌍 Public</option>
        <option value="followers">👥 Followers Only</option>
        <option value="private">🔒 Private</option>
      </select>

      <button type="submit">Upload</button>
    </form>
  </div>

  <script>
    const input = document.getElementById("imageInput");
    const preview = document.getElementById("preview");

    input.addEventListener("change", function () {
      const file = this.files[0];
      if (file) {
        preview.src = URL.createObjectURL(file);
        preview.style.display = "block";
      }
    });

    function insertEmoji(emoji) {
      const caption = document.getElementById("caption");
      caption.value += emoji;
      caption.focus();
    }
  </script>

</body>
</html>
