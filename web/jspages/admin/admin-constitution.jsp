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
        <title>Admin · Constitution</title>
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
            String title = "";
            String docLink = "";
            try {
                if (conn != null) {
                    Statement st = conn.createStatement();
                    String query = "SELECT * FROM CONSTITUTION";
                    ResultSet rs = st.executeQuery(query);

                    if (rs.next()) {
                        title = rs.getString("TITLE").trim();
                        docLink = rs.getString("FILE_LINK").trim();
                    }
                }
            } catch (SQLException sqle) {
                sqle.printStackTrace();
                String error = "Database Error";
                request.setAttribute("Error", error);
                throw new RequestException(error);
            }
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
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Admin/Constitution">CONSTITUTION</a></li>
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
                        <a class="btn active" href="${pageContext.request.contextPath}/Admin/Constitution">CONSTITUTION</a>
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
                <h1><u>Student Council Constitution Page Contents</u></h1> 
                <!--         
                    Current Document
                -->
                <div>
                    <form action="../UpdateConstitutionServlet" method="post">
                        <p>Current Document</p>
                        <label for="doclink">File Link</label>
                        <input type="text" id="doclink" name="doclink" placeholder="Enter Google Drive Sharing Link" value="<%out.print(docLink);%>" pattern="https://drive\.google\.com/file/d/.*/view\?usp=sharing" title="Google Drive Sharing Link" maxlength="500" required>
                        <br>
                        <label for="title">Document Title</label>
                        <input type="text" id="title" name="title" placeholder="Enter Document Title" value="<%out.print(title);%>" maxlength="100" required>
                        <br>
                        <input type="submit" value="Update Current Document" onclick="test()">
                    </form>
                </div> 
            </div>
            <!--         -->
            <!-- Content -->
            <!--         -->
        </div>
    </body>
</html>