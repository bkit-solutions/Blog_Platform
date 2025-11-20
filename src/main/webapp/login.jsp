<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login | Pydah_Blog</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background: linear-gradient(to right, #ff5f6d, #ffc371);
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .login-box {
      background: white;
      padding: 40px;
      border-radius: 12px;
      box-shadow: 0 5px 25px rgba(0, 0, 0, 0.2);
      width: 100%;
      max-width: 400px;
    }
    .login-box h2 {
      font-weight: 600;
      text-align: center;
      margin-bottom: 25px;
    }
  </style>
</head>
<body>
  <div class="login-box">
    <h2>Login to Pydah_Blog</h2>
    <form action="AuthServlet" method="post">
      <input type="hidden" name="action" value="login" />

      <div class="mb-3">
        <input type="email" name="email" class="form-control" placeholder="Email" required />
      </div>
      <div class="mb-3">
        <input type="password" name="password" class="form-control" placeholder="Password" required />
      </div>
      <button type="submit" class="btn btn-success w-100">Login</button>
    </form>
    <p class="mt-3 text-center">Don't have an account? <a href="register.jsp">Register</a></p>
  </div>
</body>
</html>
