# 📝 Blogging Platform (J2EE – JSP, Servlets, JDBC)

<p align="center">
A full-featured blogging web application built using <b>JSP</b>, <b>Servlets</b>, and <b>JDBC</b>.  
Users can create posts, like content, comment, follow authors, and enjoy infinite scrolling.
</p>

<p align="center">
<img src="https://cdn-icons-png.flaticon.com/512/3209/3209993.png" width="130">
</p>

---

## 📌 Overview
This **Blogging Platform** is a complete J2EE application designed to simulate a modern social blogging system with:

- User authentication  
- Post creation & management  
- Likes and comments  
- Follower system  
- Infinite scrolling  
- YouTube API-based video embedding  

It is ideal for learning full-stack Java, academic submissions, or as a foundation for real-world blogging applications.

---

## ⚡ Core Features

### ✍️ Posts
- Create, edit, delete posts  
- Add images (optional)  
- Attach YouTube videos using API key  

### 👍 Likes
- Like/unlike posts  
- Unique like enforcement  

### 💬 Comments
- Add comments  
- Delete own comments  
- Threaded comment UI  

### 👥 Follow System
- Follow/unfollow users  
- Personalized feed from followed authors  

### 📜 Infinite Scrolling
- Dynamic content loading  
- Minimal page reloads  
- Smooth UX  

---

## 🏗 Tech Stack

### **Backend**
- Java (J2EE)  
- JSP  
- Servlets  
- JDBC  
- MySQL  

### **Frontend**
- HTML / CSS  
- JavaScript  
- JSP Views  

### **Additional APIs**
- Google YouTube Data API v3  

---

## 📁 Project Structure

```
BlogPlatform/
│
├── .project
├── .classpath
├── blog_sql.sql            <-- Database initialization
│
├── src/main/java           <-- Servlets, JDBC, models
├── src/main/webapp         <-- JSP, CSS, JS
│
└── build/classes           <-- Compiled classes
```

---

## 🗄 Database Setup

Import the included SQL file:

```
blog_sql.sql
```

### Steps:
```sql
CREATE DATABASE blog;
```

Then import the SQL file using:
- MySQL Workbench  
- phpMyAdmin  
- or terminal  

Tables created include:
- users  
- posts  
- comments  
- likes  
- followers  

---

## 🔌 JDBC Configuration (IMPORTANT)

Inside:

```
src/main/java/
```

update:

```java
String url = "jdbc:mysql://localhost:3306/blog";
String username = "your_mysql_username";
String password = "your_mysql_password";  // REQUIRED
Class.forName("com.mysql.cj.jdbc.Driver");
Connection conn = DriverManager.getConnection(url, username, password);
```

⚠️ Application will not run without valid DB credentials.

---

## 🎥 YouTube API Setup (IMPORTANT)

For video embedding in posts:

### 1️⃣ Open Google Cloud Console  
https://console.cloud.google.com/

### 2️⃣ Create a New Project  

### 3️⃣ Enable:
✔ YouTube Data API v3

### 4️⃣ Generate API Key:
API & Services → Credentials → Create API Key

### 5️⃣ Update inside backend:

```java
String YOUTUBE_API_KEY = "your_api_key_here";
```

Without this, video embedding will not work.

---

## 🚀 Setup & Execution

### 1️⃣ Install Requirements
- JDK 8+  
- Apache Tomcat 8.5 / 9 / 10  
- MySQL  
- MySQL Connector/J  

---

### 2️⃣ Import into Eclipse/IntelliJ
File → Import → Existing Projects → Select folder

---

### 3️⃣ Add MySQL Connector
Right-click project →  
**Build Path → Configure Build Path → Add External JAR**

---

### 4️⃣ Configure Tomcat
- Add project to Tomcat  
- Start server  

---

### 5️⃣ Run
Open browser:

```
http://localhost:8080/Blog/
```

---

## 👥 Project Maintainers
<h3 align="center">BKIT</h3>

<p align="center">
Building scalable, modern J2EE applications with social features.
</p>
