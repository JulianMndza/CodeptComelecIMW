<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Central COMELEC · Error</title>
        <link rel="icon" href="assets/icon.png" type="image/icon type">
        <link rel="stylesheet" href="css/error.css">
        <script defer src="js/node_modules/swup/dist/swup.min.js"></script>
        <script defer type="module" src="js/swup-start.js"></script>
    </head>
    <body>
        <%
            String header = getServletContext().getInitParameter("header");
        %>
        <div class="logo">
            <img src="assets/central-comelec.png" alt="COMELEC">
            <a class="home-btn"><% out.print(header);%></a>
        </div>
        <div class="error">
            <h1>Error 500: Internal Server Error</h1>
            <div class="error-content">
                <h2>something went wrong. <span>Don't worry, it's not your fault.</span></h2>
                <p><span>Try to refresh this page</span>  or head to the Home page instead.</p>
                <a href="javascript:history.back()">Back</a>
            </div>
            <span></span>
        </div>
    </body>
</html>
