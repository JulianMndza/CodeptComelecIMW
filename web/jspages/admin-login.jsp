<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Central COMELEC · Log In</title>
        <link rel="icon" href="assets/icon.png" type="image/icon type">
        <link rel="stylesheet" href="css/login.css">
        <script defer src="js/login.js"></script>
    </head>
    <body>
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

            String role = (String) session.getAttribute("Role");
            if (session.getAttribute("Role") != null) {
                if (role.equals("Admin")) {
                    response.sendRedirect("Admin/Home");
                } else if (role.equals("Unit Editor")) {
                    response.sendRedirect("Unit_Editor/Unit_Resolutions");
                }
            }
            String header = getServletContext().getInitParameter("header");
            String footer = getServletContext().getInitParameter("footer");
        %>
        <!-- Login -->
        <div class="login-wrapper">
            <div class="logo">
                <img src="assets/central-comelec.png" alt="COMELEC">
                <!-- Header -->
                <a href="${pageContext.request.contextPath}/Home"><% out.print(header);%></a>
            </div>
            <!-- Login Form -->
            <form action="LoginServlet" method="post">
                <div class="login">
                    <h1>Login</h1>
                    <label for="uname">Username</label>
                    <input type="text" name="username" maxlength="50" required>
                    <label for="psw">Password</label>
                    <input type="password"  name="password" maxlength="50" required>
                    <div class="btn-container">
                        <button type="button" class="cancelbtn"><a href="${pageContext.request.contextPath}/Home">Back</a></button>
                        <button type="submit" class="loginbtn">Log in</button>
                    </div>  
                </div>
            </form>
            <div class="filler"></div>
        </div>
        <!-- Image Carousel -->
        <div class="image-car">
            <div class="tint"></div>
            <div class="slideshow-container">
                <div class="carSlides slide">
                    <img src="assets/fill-1.png">
                </div>
                <div class="carSlides slide">
                    <img src="assets/fill-2.png">
                </div>
                <div class="carSlides slide">
                    <img src="assets/fill-3.png">
                </div>
            </div>
            <div class="dots">
                <span class="dot"></span> 
                <span class="dot"></span>
                <span class="dot"></span>  
            </div>
        </div>
    </body>
</html>