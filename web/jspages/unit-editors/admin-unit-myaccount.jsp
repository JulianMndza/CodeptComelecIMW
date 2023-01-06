<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Unit Editor · My Account</title>
        <link rel="icon" href="../assets/icon.png" type="image/icon type">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="../css/admin.css">
        <script defer src="../js/admin.js"></script>
    </head>
    <body>
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            String header = getServletContext().getInitParameter("header");
            String footer = getServletContext().getInitParameter("footer");
            if (session.getAttribute("Name") == null) {
                response.sendRedirect("../Login");
            } else {
                String role = (String) session.getAttribute("Role");
                if (role.equals("Admin")) {
                    response.sendRedirect("../Admin/Home");
                }
            }
            String firstName = (String) session.getAttribute("FirstName");
            String lastName = (String) session.getAttribute("LastName");
            String username = (String) session.getAttribute("Username");
            String password = (String) session.getAttribute("Password");
            String unit = (String) session.getAttribute("Unit");
        %>
        <!-- Header -->
        <nav id="header">
            <!-- Logo -->
            <div class="logo">
                <img src="../assets/central-comelec.png" alt="COMELEC">
                <a href="#"><% out.print(header);%></a>
            </div>
        </nav>
        <!-- Navbar Menu Icon -->
        <div class="menuIcon">
            <span class="icon icon-bars"></span>
        </div>  
        <div class="overlay-menu">
            <ul id="menu2">
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Resolutions">RESOLUTIONS</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Memorandum">MEMORANDUM</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_ExecutiveOrder">EXECUTIVE ORDER</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Constitution">COLLEGE CONSTITUTION</a></li>
                <br>
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Unit_Editor/MyAccount">MY ACCOUNT</a></li>
                <br>
                <li class="logout-button">
                    <form action="../LogoutServlet" method="post">
                        <input type="submit" id="logout" value="LOG OUT">
                    </form>
                </li>
            </ul>
        </div>
        <div class="wrapper">
            <!-- Sidebar -->
            <nav id="sidenav">
                <div class="nav-wrapper">
                    <!-- Navbar Links --> 
                    <div id="menu">
                        <a class="btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Resolutions">RESOLUTIONS</a>
                        <a class="btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Memorandum">MEMORANDUM</a>
                        <a class="btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_ExecutiveOrder">EXECUTIVE ORDER</a>
                        <a class="btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Constitution">COLLEGE CONSTITUTION</a>
                        <br>
                        <a class="btn active" href="${pageContext.request.contextPath}/Unit_Editor/MyAccount">MY ACCOUNT</a>
                    </div>
                    <!-- Logout Button -->
                    <div class="logout-button">
                        <form action="../LogoutServlet" method="post">
                            <input type="submit" id="logout" value="LOG OUT">
                        </form>
                    </div>
                </div>
            </nav>
            <!--         -->
            <!-- Content -->
            <!--         -->
            <div id="swup" class="container transition-fade">
                <h1><u>My Account</u></h1>  
                <!--         
                    Account Information
                -->
                <div>
                    <form action="#" class="form-accountinformation">
                        <p>Account Information</p>  
                        <div class="pair">
                            <label for="firstname">First Name</label>
                            <input type="text" id="firstname" name="firstname" value="<% out.print(firstName); %>" readonly>
                        </div>
                        <div class="pair">
                            <label for="lastname">Last Name</label>
                            <input type="text" id="lastname" name="lastname" value="<% out.print(lastName); %>" readonly>
                        </div>
                        <div class="pair">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" value="<% out.print(username); %>" readonly>
                        </div>
                        <div class="pair">
                            <label for="unit">Unit Assigned</label>
                            <input type="text" id="unit" name="unit" value="<% out.print(unit); %>" readonly>
                        </div>
                    </form>
                </div> 
                <br>
                <!--         
                    Change Password
                -->
                <div>
                    <form action="../UnitEditorChangePasswordServlet" class="form-changepassword">
                        <p>Change Password</p>
                        <input type="hidden" name="username" value="<% out.print(username); %>">
                        <input type="hidden" name="password" value="<% out.print(password);%>">
                        <label for="oldpassword">Old Password</label>
                        <input type="password" id="oldpassword" name="oldpassword" placeholder="Enter Old Password" maxlength="50" required>
                        <br>
                        <label for="newpassword">New Password</label>
                        <input type="password" id="newpassword" name="newpassword" placeholder="Enter New Password" maxlength="50" required>
                        <br>
                        <label for="conpassword">Confirm New Password</label>
                        <input type="password" id="conpassword" name="conpassword" placeholder="Re-enter New Password" maxlength="50" required>
                        <br>
                        <input type="submit" name="Change_button" value="Change Password" onclick="test()"/>
                    </form>
                </div> 
                <br>
                <!--         -->
                <!-- Content -->
                <!--         -->
            </div>
        </div>
    </body>
</html>