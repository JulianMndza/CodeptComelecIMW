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
            String error = (String) request.getAttribute("Error");
            String code = "401: Unauthorized";
            String subt = "", subt2 = "";
            if (error.equals("No Database Connection") || error.equals("Database Error")) {
                code = "500: Server Database Error";
                error = "something went wrong.";
                subt = "Don't worry, it's not your fault.";
                subt2 = "Please contact your system administrator if the problem persists.";
            } else if (error.equals("Valid Username but Invalid Password")) {
                error = "the password you entered is incorrect.";
                subt = "Please try again";
                subt2 = " (or contact your system administrator for a password reset).";
            } else if (error.equals("Invalid Username and Password")) {
                error = "we don't recognize these credentials.";
                subt = "Please enter your username and password properly.";
                subt2 = "Please contact your system administrator if the problem persists.";
            } else if (error.equals("Format does not match")) {
                code = "404: Not Found";
                error = "the link is either invalid or has been tampered with.";
                subt = "Lost? Click the button";
                subt2 = "to go back.";
            }
        %>
        <div class="logo">
            <img src="assets/central-comelec.png" alt="COMELEC">
            <a class="home-btn"><% out.print(header); %></a>
        </div>
        <div class="error">
            <h1>Error <% out.print(code); %></h1>
            <div class="error-content">
                <h2>Sorry, <span><% out.print(error); %></span></h2>
                <p><span><% out.print(subt); %></span> <% out.print(subt2);%></p>
                <a href="javascript:history.back()">Back</a>
            </div>
            <span></span>
        </div>
    </body>
</html>
