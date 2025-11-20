<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Register | Pydah_Blog</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background: linear-gradient(to right, #ff5f6d, #ffc371);
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .register-box {
      background: white;
      padding: 40px;
      border-radius: 12px;
      box-shadow: 0 5px 25px rgba(0, 0, 0, 0.2);
      width: 100%;
      max-width: 450px;
    }
    .register-box h2 {
      font-weight: 600;
      text-align: center;
      margin-bottom: 25px;
    }
  </style>
</head>
<body>
  <div class="register-box">
    <h2>Create Account</h2>
    <form action="AuthServlet" method="post" enctype="multipart/form-data">
      <input type="hidden" name="action" value="register" />

      <div class="mb-3">
        <input type="text" name="username" class="form-control" placeholder="Username" required />
      </div>
      <div class="mb-3">
        <input type="email" name="email" class="form-control" placeholder="Email" required />
      </div>
      <div class="mb-3">
        <input type="password" name="password" class="form-control" placeholder="Password" required />
      </div>
      <div class="mb-3">
        <label class="form-label">Upload Profile Picture</label>
        <input type="file" name="profile_pic" class="form-control" accept="image/*" required />
      </div>
      <div class="mb-3">
        <textarea name="bio" class="form-control" rows="3" placeholder="Write a short bio... (optional)"></textarea>
      </div>
      <button type="submit" class="btn btn-primary w-100">Register</button>
    </form>
    <p class="mt-3 text-center">Already have an account? <a href="login.jsp">Login</a></p>
  </div>
</body>
</html>
