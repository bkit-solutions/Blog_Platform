<%@ page contentType="text/html;charset=UTF-8" %>
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
  <title>Explore | Pydah_Blog</title>
  <style>
    body {
      display: flex;
      margin: 0;
      font-family: 'Segoe UI', sans-serif;
      background-color: #f8f9fa;
    }

    .sidebar {
      width: 240px;
      height: 100vh;
      background: linear-gradient(to bottom, #ff5f6d, #ffc371);
      padding: 30px 20px;
      color: white;
      position: fixed;
      left: 0;
      top: 0;
    }

    .sidebar h2 {
      font-size: 22px;
      margin-bottom: 30px;
      font-weight: bold;
    }

    .sidebar a {
      display: block;
      margin: 15px 0;
      font-size: 16px;
      color: white;
      text-decoration: none;
      transition: 0.2s;
    }

    .sidebar a:hover {
      background-color: rgba(255, 255, 255, 0.2);
      padding: 8px;
      border-radius: 8px;
    }

    .main {
  margin-left: 240px;
  padding: 40px 50px;
  width: calc(100% - 240px);
  box-sizing: border-box;
}

    h2 {
      margin-bottom: 25px;
    }

    .filter-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 30px;
}


    .filter-bar input, .filter-bar select {
      padding: 10px 12px;
      font-size: 15px;
      border: 1px solid #ccc;
      border-radius: 6px;
    }

    .videos-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
  padding-top: 10px;
  margin-top: 10px;
}

.video-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s ease;
  cursor: pointer;
  display: flex;
  flex-direction: column;
}


    .video-card:hover {
      transform: translateY(-3px);
    }

    .video-card a {
      text-decoration: none;
    }

    .video-card img {
      width: 100%;
      height: 180px;
      object-fit: cover;
      display: block;
    }

    .video-content {
      padding: 14px;
    }

    .video-title {
      font-size: 16px;
      font-weight: 600;
      color: #333;
      margin-bottom: 6px;
    }

    .video-meta {
      font-size: 13px;
      color: #666;
    }

    .loading {
      text-align: center;
      margin: 30px;
      font-size: 16px;
      color: #555;
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
  <h2>🌍 Trending Videos Around the World</h2>

  <div class="filter-bar">
    <input type="text" id="searchInput" placeholder="Search videos..." />
    <select id="categorySelect">
      <option value="">All Categories</option>
      <option value="10">Music</option>
      <option value="17">Sports</option>
      <option value="20">Gaming</option>
      <option value="24">Entertainment</option>
      <option value="25">News</option>
    </select>
  </div>

  <div class="videos-grid" id="videosGrid"></div>
  <div class="loading" id="loadingText" style="display:none;">Loading videos...</div>
</div>

<script>
  const apiKey = "AIzaSyDMFs5yqpXYx_Ch71yvSFiUeTJwcjocUHw"; // Your API Key
  let nextPageToken = "";
  let isLoading = false;

  const videosGrid = document.getElementById("videosGrid");
  const loadingText = document.getElementById("loadingText");

  function formatViews(views) {
    if (!views) return "N/A";
    if (views >= 1e6) return (views / 1e6).toFixed(1) + "M";
    if (views >= 1e3) return (views / 1e3).toFixed(1) + "K";
    return views;
  }

  function formatDuration(isoDuration) {
    const match = isoDuration.match(/PT(\d+H)?(\d+M)?(\d+S)?/);
    const h = (match[1] || "").replace("H", "");
    const m = (match[2] || "").replace("M", "");
    const s = (match[3] || "").replace("S", "");
    return [h, m, s].filter(Boolean).map(t => t.padStart(2, '0')).join(":");
  }

  function fetchVideos(initial = false) {
    if (isLoading) return;
    isLoading = true;
    loadingText.style.display = "block";

    const query = document.getElementById("searchInput").value.trim();
    const category = document.getElementById("categorySelect").value;

    let url = "";
    let useSearch = !!query;

    if (useSearch) {
      url = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=10&regionCode=IN&q=" 
        + encodeURIComponent(query) 
        + "&key=" + apiKey;
    } else {
      url = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics,contentDetails&chart=mostPopular&regionCode=IN&maxResults=10&key=" + apiKey;
      if (category) url += "&videoCategoryId=" + category;
    }

    if (nextPageToken) url += "&pageToken=" + nextPageToken;

    fetch(url)
      .then(res => res.json())
      .then(async data => {
        const items = data.items;
        nextPageToken = data.nextPageToken || "";

        let videoData = [];

        if (useSearch) {
          const videoIds = items.map(i => i.id.videoId).join(",");
          const statsUrl = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics,contentDetails&id=" 
            + videoIds + "&key=" + apiKey;
          const statsRes = await fetch(statsUrl);
          const statsData = await statsRes.json();
          videoData = statsData.items;
        } else {
          videoData = items;
        }

        videoData.forEach(video => {
          const snippet = video.snippet;
          const stats = video.statistics || {};
          const duration = video.contentDetails ? formatDuration(video.contentDetails.duration) : "–";
          const videoId = video.id.videoId || video.id;

          const card = document.createElement("div");
          card.className = "video-card";
          card.innerHTML = `
            <a href="https://www.youtube.com/watch?v=` + videoId + `" target="_blank">
              <img src="` + snippet.thumbnails.medium.url + `" alt="Thumbnail">
              <div class="video-content">
                <div class="video-title">` + snippet.title + `</div>
                <div class="video-meta">By ` + snippet.channelTitle + `</div>
                <div class="video-meta">Views: ` + formatViews(stats.viewCount) + ` | Duration: ` + duration + `</div>
              </div>
            </a>
          `;

          videosGrid.appendChild(card);
        });

        isLoading = false;
        loadingText.style.display = "none";
      })
      .catch(err => {
        console.error("YouTube API Error:", err);
        loadingText.innerText = "Failed to load videos.";
        isLoading = false;
      });
  }

  // Initial load
  fetchVideos(true);

  // Infinite scroll
  window.addEventListener("scroll", () => {
    if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 200) {
      fetchVideos();
    }
  });

  // Filters
  document.getElementById("searchInput").addEventListener("keypress", e => {
    if (e.key === "Enter") {
      videosGrid.innerHTML = "";
      nextPageToken = "";
      fetchVideos(true);
    }
  });

  document.getElementById("categorySelect").addEventListener("change", () => {
    videosGrid.innerHTML = "";
    nextPageToken = "";
    fetchVideos(true);
  });
</script>

</body>
</html>
