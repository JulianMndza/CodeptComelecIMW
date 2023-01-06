<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin · Account</title>
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
                if (role.equals("Unit Editor")) {
                    response.sendRedirect("../Unit_Editor/Unit_Resolutions");
                }
            }
            String realUsername = (String) session.getAttribute("Username");
            String realPassword = (String) session.getAttribute("Password");
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
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/Home">HOME</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/Unit_Resolutions">UNITS · Resolutions</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/Unit_Memorandum">UNITS · Memorandum</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/Unit_ExecutiveOrder">UNITS · Executive Order</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/Unit_Constitution">UNITS · College Constitution</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/Directory">DIRECTORY</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/USEC">USEC</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/Constitution">CONSTITUTION</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/Documents">DOCUMENTS</a></li>
                <br>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/MyAccount">MY ACCOUNT</a></li>
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Admin/Account">EDIT ACCOUNT</a></li>
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
                        <a class="btn" href="${pageContext.request.contextPath}/Admin/Home">HOME</a>
                        <div class="dropdown">
                            <a class="dropbtn" onclick="myFunction()" href="#">UNITS<i class="material-icons">keyboard_arrow_down</i></a>
                            <div id="dropdown" class="dropdown-content">
                                <a class="btn" href="${pageContext.request.contextPath}/Admin/Unit_Resolutions">Resolutions</a>
                                <a class="btn" href="${pageContext.request.contextPath}/Admin/Unit_Memorandum">Memorandum</a>
                                <a class="btn" href="${pageContext.request.contextPath}/Admin/Unit_ExecutiveOrder">Executive Order</a>
                                <a class="btn" href="${pageContext.request.contextPath}/Admin/Unit_Constitution">College Constitution</a>
                            </div>
                        </div>
                        <a class="btn" href="${pageContext.request.contextPath}/Admin/Directory">DIRECTORY</a>
                        <a class="btn" href="${pageContext.request.contextPath}/Admin/USEC">USEC</a>
                        <a class="btn" href="${pageContext.request.contextPath}/Admin/Constitution">CONSTITUTION</a>
                        <a class="btn" href="${pageContext.request.contextPath}/Admin/Documents">DOCUMENTS</a>
                        <br>
                        <a class="btn" href="${pageContext.request.contextPath}/Admin/MyAccount">MY ACCOUNT</a>
                        <a class="btn active" href="${pageContext.request.contextPath}/Admin/Account">EDIT ACCOUNT</a>
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
                <h1><u>Edit Account</u></h1>  
                <!--         
                    Add Account
                -->
                <div>
                    <form action="../AdminAddAccountServlet" method="post" class="form-addaccount">
                        <p>Add Account</p>
                        <div class="pair">
                            <label for="firstname">First Name</label>
                            <input type="text" id="firstname" name="firstname" placeholder="Enter First Name" maxlength="50" required>
                        </div>
                        <div class="pair">
                            <label for="lastname">Last Name</label>
                            <input type="text" id="lastname" name="lastname" placeholder="Enter Last Name" maxlength="50" required>
                        </div>
                        <div class="pair">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" placeholder="Enter Username" maxlength="50" required>
                        </div>
                        <div class="pair">
                            <label for="owo">Role</label>
                            <select id="owo" name="role">
                                <option value="Admin">Admin</option>
                                <option value="Unit Editor">Unit Editor</option>
                            </select>
                        </div>
                        <label for="owo">Assigned Unit</label>
                        <select id="owo" name="assigned_unit" required>
                            <option value="">-- Select Assigned Unit --</option>
                            <option value="N/A">N/A (for Admin Accounts only)</option>
                            <option value="Central Commission on Elections">Central Commission on Elections</option>
                            <option value="UST-AMV College of Accountancy">UST-AMV College of Accountancy</option>
                            <option value="College of Architecture">College of Architecture</option>
                            <option value="College of Commerce and Business Administration">College of Commerce and Business Administration</option>
                            <option value="College of Education">College of Education</option>
                            <option value="College of Fine Arts and Design">College of Fine Arts and Design</option>
                            <option value="College of Information and Computing Sciences">College of Information and Computing Sciences</option>
                            <option value="College of Nursing">College of Nursing</option>
                            <option value="College of Rehabilitation Sciences">College of Rehabilitation Sciences</option>
                            <option value="College of Science">College of Science</option>
                            <option value="College of Tourism and Hospitality Management">College of Tourism and Hospitality Management</option>
                            <option value="Conservatory of Music">Conservatory of Music</option>
                            <option value="Faculty of Arts and Letters">Faculty of Arts and Letters</option>
                            <option value="Faculty of Civil Law">Faculty of Civil Law</option>
                            <option value="Faculty of Engineering">Faculty of Engineering</option>
                            <option value="Faculty of Medicine and Surgery">Faculty of Medicine and Surgery</option>
                            <option value="Faculty of Pharmacy">Faculty of Pharmacy</option>
                            <option value="Ecclesiastical Faculties (Canon Law, Philosophy, and Sacred Theology)">Ecclesiastical Faculties (Canon Law, Philosophy, and Sacred Theology)</option>
                            <option value="Institute of Physical Education">Institute of Physical Education</option>
                            <option value="Education High School">Education High School</option>
                            <option value="Junior High School">Junior High School</option>
                            <option value="Senior High School">Senior High School</option>
                        </select>
                        <br>
                        <input type="submit" value="Add Account" onclick="test()">
                    </form>
                </div>
                <br>
                <!--         
                    Edit Account
                -->
                <div>
                    <br>
                    <form action="../AdminResetPasswordServlet" method="post" class="form-editaccount">
                        <p>Reset Account Password</p>
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" placeholder="Enter Username" maxlength="50" required>
                        <br>
                        <input type="submit" value="Reset Password" onclick="test()">
                    </form>
                </div>
                <br>
                <!--         
                    Remove Account
                -->
                <div>
                    <form action="../AdminRemoveAccountServlet" method="post" class="form-removeaccount">
                        <p>Remove Account</p>
                        <input type="hidden" name="realusername" value="<% out.print(realUsername); %>">
                        <input type="hidden" name="realpassword" value="<% out.print(realPassword);%>">
                        <label for="username">Account Username</label>
                        <input type="text" id="username" name="username" placeholder="Enter Username" maxlength="50" required>
                        <br>
                        <label for="password">Your Password</label>
                        <input type="password" id="password" name="password" placeholder="Enter Your(Admin) Password" maxlength="50" required>
                        <br>
                        <input type="submit" value="Delete Existing Account" onclick="test()">
                    </form>
                </div>
                <br>
                <!--         
                    View Account List
                -->
                <div>
                    <form action="../AdminPDFServlet" method="post" class="form-viewaccountlist">
                        <p>View Account List</p>
                        <input type="submit" value="Download Account List" onclick="test()">
                    </form>
                </div>
            </div>
            <!--         -->
            <!-- Content -->
            <!--         -->
        </div>
    </body>
</html>