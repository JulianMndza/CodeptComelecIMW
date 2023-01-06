<%@page import="java.sql.Statement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="model.RequestException;"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin · Home</title>
        <link rel="icon" href="../assets/icon.png" type="image/icon type">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="../css/admin.css">
        <script defer src="../js/admin.js"></script>
    </head>
    <body>
        <%! Connection conn;%>
        <%
            try {
                Class.forName(getServletContext().getInitParameter("jdbcClassName"));
                String username = getServletContext().getInitParameter("jdbcUserName");
                String password = getServletContext().getInitParameter("jdbcPassword");
                String url = getServletContext().getInitParameter("jdbcDriverURL") + getServletContext().getInitParameter("databaseName");
                conn = DriverManager.getConnection(url, username, password);
            } catch (SQLException sqle) {
                System.out.print("SQLException error occured - " + sqle.getMessage());
            } catch (ClassNotFoundException cnfe) {
                System.out.print("ClassNotFoundException error occured - " + cnfe.getMessage());
            }
        %>
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
            String annLink = "";
            String annTitle = "";
            String annSubtitle = "";
            String annContent = "";
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
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Admin/Home">HOME</a></li>
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
                <li><a class="over btn" href="${pageContext.request.contextPath}/Admin/Account">EDIT ACCOUNT</a></li>
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
                        <a class="btn active" href="${pageContext.request.contextPath}/Admin/Home">HOME</a>
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
                        <a class="btn" href="${pageContext.request.contextPath}/Admin/Account">EDIT ACCOUNT</a>
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
                <h1><u>Home Page Contents</u></h1>  
                <!--         
                    Existing Announcements
                -->
                <%
                    try {
                        if (conn != null) {
                            String query = "SELECT * FROM ANNOUNCEMENTS WHERE STATUS = ?";
                            PreparedStatement ps = conn.prepareStatement(query);
                            ps.setString(1, "Not Archived");
                            ResultSet rs = ps.executeQuery();
                            int counter = 1;
                            while (rs.next()) {
                                annLink = rs.getString("IMAGE_LINK").trim();
                                annTitle = rs.getString("ANNOUNCEMENT_TITLE").trim();
                                annSubtitle = rs.getString("ANNOUNCEMENT_SUBTITLE").trim();
                                annContent = rs.getString("ANNOUNCEMENT_CONTENT").trim();
                %>
                <div>
                    <form action="#" method="post">
                        <p>Announcement <%out.print(counter);%></p>
                        <label for="annlink">Image Link/s (separate with a space)</label>
                        <input type="hidden" name="ogannlink" value="<%out.print(annLink);%>">
                        <textarea id="annlink" name="annlink" placeholder="Enter Google Drive Sharing Link" pattern="https://drive\.google\.com/file/d/.*/view\?usp=sharing" title="Google Drive Sharing Link"   maxlength="1000" required><%out.print(annLink);%></textarea>
                        <br>
                        <label for="anntitle">Announcement Title</label>
                        <input type="text" id="anntitle" name="anntitle" placeholder="Enter Title" value="<%out.print(annTitle);%>" maxlength="100" required>
                        <br>
                        <label for="annsubtitle">Announcement Subtitle</label>
                        <input type="text" id="annsubtitle" name="annsubtitle" placeholder="Enter Subtitle" value="<%out.print(annSubtitle);%>" maxlength="100" required>
                        <br>
                        <label for="anncontent">Announcement Content</label>
                        <textarea id="anncontent" name="anncontent" placeholder="Enter Brief Description"   maxlength="1000" required><%out.print(annContent);%></textarea>
                        <br>
                        <input type="submit" name="update_button" formaction="../UpdateAnnouncementServlet" value="Update Announcement" onclick="test()"/>
                        <input type="submit" name="archive_button" formaction="../ArchiveAnnouncementServlet" value="Archive Announcement" onclick="return confirm('Are you sure? Archived documents will no longer be editable.')" />
                    </form>
                </div> 
                <br>
                <%
                                counter++;
                            }
                        }
                    } catch (SQLException sqle) {
                        sqle.printStackTrace();
                        String error = "Database Error";
                        request.setAttribute("Error", error);
                        throw new RequestException(error);
                    }
                %>
                <!--         
                    Add Announcement
                -->
                <div>
                    <form action="../AddAnnouncementServlet" method="post">
                        <p>Add New Announcement</p>
                        <label for="annlink">Image Link/s (separate with a space)</label>
                        <textarea id="annlink" name="annlink" placeholder="Enter Google Drive Sharing Link"   pattern="https://drive\.google\.com/file/d/.*/view\?usp=sharing" title="Google Drive Sharing Link" maxlength="1000" required></textarea>
                        <br>
                        <label for="anntitle">Announcement Title</label>
                        <input type="text" id="anntitle" name="anntitle" placeholder="Enter Title" maxlength="100" required>
                        <br>
                        <label for="annsubtitle">Announcement Subtitle</label>
                        <input type="text" id="annsubtitle" name="annsubtitle" placeholder="Enter Subtitle" maxlength="100" required>
                        <br>
                        <label for="anncontent">Announcement Content</label>
                        <textarea id="anncontent" name="anncontent" placeholder="Enter Brief Description"   maxlength="1000" required></textarea>
                        <br>
                        <input type="submit" name="add_button" value="Add Announcement" onclick="test()"/>
                    </form>
                </div> 
            </div>
            <!--         -->
            <!-- Content -->
            <!--         -->
        </div>
    </body>
</html>