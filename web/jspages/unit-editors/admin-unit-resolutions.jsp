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
        <title>Unit Editor · Resolutions</title>
        <link rel="icon" href="../assets/icon.png" type="image/icon type">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="../css/admin.css">
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
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
            String role = (String) session.getAttribute("Role");
            if (session.getAttribute("Name") == null) {
                response.sendRedirect("../Login");
            } else {
                if (role.equals("Admin")) {
                    response.sendRedirect("../Admin/Home");
                }
            }
            String unit = (String) session.getAttribute("Unit");
            String fileLink = "";
            String docTitle = "";
            String docDesc = "";
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
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Resolutions">RESOLUTIONS</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Memorandum">MEMORANDUM</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_ExecutiveOrder">EXECUTIVE ORDER</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Constitution">COLLEGE CONSTITUTION</a></li>
                <br>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Editor/MyAccount">MY ACCOUNT</a></li>
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
                        <a class="btn active" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Resolutions">RESOLUTIONS</a>
                        <a class="btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Memorandum">MEMORANDUM</a>
                        <a class="btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_ExecutiveOrder">EXECUTIVE ORDER</a>
                        <a class="btn" href="${pageContext.request.contextPath}/Unit_Editor/Unit_Constitution">COLLEGE CONSTITUTION</a>
                        <br>
                        <a class="btn" href="${pageContext.request.contextPath}/Unit_Editor/MyAccount">MY ACCOUNT</a>
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
                <h1><u>Resolutions Page Contents</u></h1>  
                <div class="unit-dropdown-contain">
                    <div class="unit-dropdown-nav">
                        <label for="unit">Unit:</label>
                        <input type="text" id="unit" name="assigned_unit" value="<%out.print(unit);%>" readonly>
                    </div>
                    <br>
                    <div id="unit-1" class="unit-content">
                        <!--         
                            Existing Documents 
                        -->
                        <%
                            try {
                                if (conn != null) {
                                    String query = "SELECT * FROM UNIT_RESOLUTIONS WHERE UNIT = ? AND STATUS = ?";
                                    PreparedStatement ps = conn.prepareStatement(query);
                                    ps.setString(1, unit);
                                    ps.setString(2, "Not Archived");
                                    ResultSet rs = ps.executeQuery();
                                    int counter = 1;
                                    while (rs.next()) {
                                        fileLink = rs.getString("FILE_LINK").trim();
                                        docTitle = rs.getString("TITLE").trim();
                                        docDesc = rs.getString("DESCRIPTION").trim();
                        %>
                        <div>
                            <form action="#" method="post">
                                <p>Document <%out.print(counter);%></p>
                                <input type="hidden" name="role" value="<%out.print(role);%>">
                                <input type="hidden" name="unit" value="<%out.print(unit);%>">
                                <label for="doclink">File Link</label>
                                <input type="hidden" name="ogdoclink" value="<%out.print(fileLink);%>">
                                <input type="text" id="doclink" name="doclink" placeholder="Enter Google Drive Sharing Link" pattern="https://drive\.google\.com/file/d/.*/view\?usp=sharing" title="Google Drive Sharing Link" value="<%out.print(fileLink);%>" maxlength="500" required>
                                <br>
                                <label for="doctitle">Document Title</label>
                                <input type="text" id="doctitle" name="doctitle" placeholder="Enter Document Title" value="<%out.print(docTitle);%>" maxlength="100" required>
                                <br>
                                <label for="docdesc">Description</label>
                                <textarea id="docdesc" name="docdesc" placeholder="Enter Brief Description" rows="2" cols="50" style="resize:none;" maxlength="200" required><%out.print(docDesc);%></textarea>
                                <br>
                                <input type="submit" name="update_button" formaction="../AdminUpdateUnitResolutions" value="Update Document" onclick="test()"/>
                                <input type="submit" name="archive_button" formaction="../AdminArchiveUnitResolutions" value="Archive Document" onclick="return confirm('Are you sure? Archived documents will no longer be editable.')" />
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
                            Add Document
                        -->
                        <div>
                            <form action="../AdminAddUnitResolutions" method="post">
                                <input type="hidden" name="role" value="<%out.print(role);%>">
                                <p>Add New Document</p>
                                <input type="hidden" name="unit" value="<%out.print(unit);%>">
                                <label for="doclink">File Link</label>
                                <input type="text" id="doclink" name="doclink" placeholder="Enter Google Drive Sharing Link" pattern="https://drive\.google\.com/file/d/.*/view\?usp=sharing" title="Google Drive Sharing Link" maxlength="500" required>
                                <br>
                                <label for="doctitle">Document Title</label>
                                <input type="text" id="doctitle" name="doctitle" placeholder="Enter Document Title" maxlength="100" required>
                                <br>
                                <label for="docdesc">Description</label>
                                <textarea id="docdesc" name="docdesc" placeholder="Enter Brief Description" rows="2" cols="50" style="resize:none;" maxlength="200" required></textarea>
                                <br>
                                <input type="submit" name="add_button" value="Add Document" onclick="test()"/>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!--         -->
            <!-- Content -->
            <!--         -->
        </div>
    </body>
</html>