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
        <title>Admin · Unit Memorandum</title>
        <link rel="icon" href="../assets/icon.png" type="image/icon type">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="../css/admin.css">
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
        <script defer src="../js/admin.js"></script>
    </head>
    <body onunload="reset()">
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
                if (role.equals("Unit Editor")) {
                    response.sendRedirect("../Unit_Editor/Unit_Resolutions");
                }
            }
            String fileLink = "";
            String docTitle = "";
            String docDesc = "";
            String[] unitArray = {
                "Central Commission on Elections",
                "UST-AMV College of Accountancy",
                "College of Architecture",
                "College of Commerce and Business Administration",
                "College of Education",
                "College of Fine Arts and Design",
                "College of Information and Computing Sciences",
                "College of Nursing",
                "College of Rehabilitation Sciences",
                "College of Science",
                "College of Tourism and Hospitality Management",
                "Conservatory of Music",
                "Faculty of Arts and Letters",
                "Faculty of Civil Law",
                "Faculty of Engineering",
                "Faculty of Medicine and Surgery",
                "Faculty of Pharmacy",
                "Ecclesiastical Faculties (Canon Law, Philosophy, and Sacred Theology)",
                "Institute of Physical Education",
                "Education High School",
                "Junior High School",
                "Senior High School"
            };
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
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Admin/Unit_Memorandum">UNITS · Memorandum</a></li>
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
                        <a class="btn" href="${pageContext.request.contextPath}/Admin/Home">HOME</a>
                        <div class="dropdown">
                            <a class="dropbtn" onclick="myFunction()" href="#">UNITS<i class="material-icons">keyboard_arrow_down</i></a>
                            <div id="dropdown" class="dropdown-content">
                                <a class="btn" href="${pageContext.request.contextPath}/Admin/Unit_Resolutions">Resolutions</a>
                                <a class="btn active" href="${pageContext.request.contextPath}/Admin/Unit_Memorandum">Memorandum</a>
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
                <h1><u>Memorandum Page Contents</u></h1>  
                <div class="unit-dropdown-contain">
                    <div class="unit-dropdown-nav">
                        <label for="unit">Unit:</label>
                        <select id="unit" name="assigned_unit">
                            <option value="1">Central Commission on Elections</option>
                            <option value="2">UST-AMV College of Accountancy</option>
                            <option value="3">College of Architecture</option>
                            <option value="4">College of Commerce and Business Administration</option>
                            <option value="5">College of Education</option>
                            <option value="6">College of Fine Arts and Design</option>
                            <option value="7">College of Information and Computing Sciences</option>
                            <option value="8">College of Nursing</option>
                            <option value="9">College of Rehabilitation Sciences</option>
                            <option value="10">College of Science</option>
                            <option value="11">College of Tourism and Hospitality Management</option>
                            <option value="12">Conservatory of Music</option>
                            <option value="13">Faculty of Arts and Letters</option>
                            <option value="14">Faculty of Civil Law</option>
                            <option value="15">Faculty of Engineering</option>
                            <option value="16">Faculty of Medicine and Surgery</option>
                            <option value="17">Faculty of Pharmacy</option>
                            <option value="18">Ecclesiastical Faculties (Canon Law, Philosophy, and Sacred Theology)</option>
                            <option value="19">Institute of Physical Education</option>
                            <option value="20">Education High School</option>
                            <option value="21">Junior High School</option>
                            <option value="22">Senior High School</option>
                        </select>
                    </div>
                    <br>
                    <%
                        for (int i = 1; i <= unitArray.length; i++) {
                    %>
                    <div id="unit-<%out.print(i);%>" class="unit-content">
                        <!--         
                            Existing Documents 
                        -->
                        <%
                            try {
                                if (conn != null) {
                                    String query = "SELECT * FROM UNIT_MEMORANDUM WHERE UNIT = ? AND STATUS = ?";
                                    PreparedStatement ps = conn.prepareStatement(query);
                                    ps.setString(1, unitArray[i - 1]);
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
                                <input type="hidden" name="unit" value="<%out.print(unitArray[i - 1]);%>">
                                <label for="doclink">File Link</label>
                                <input type="hidden" name="ogdoclink" value="<%out.print(fileLink);%>">
                                <input type="text" id="doclink" name="doclink" placeholder="Enter Google Drive Sharing Link" value="<%out.print(fileLink);%>" pattern="https://drive\.google\.com/file/d/.*/view\?usp=sharing" title="Google Drive Sharing Link" maxlength="500" required>
                                <br>
                                <label for="doctitle">Document Title</label>
                                <input type="text" id="doctitle" name="doctitle" placeholder="Enter Document Title" value="<%out.print(docTitle);%>" maxlength="100" required>
                                <br>
                                <label for="docdesc">Description</label>
                                <textarea id="docdesc" name="docdesc" placeholder="Enter Brief Description"   maxlength="200" required><%out.print(docDesc);%></textarea>
                                <br>
                                <input type="submit" name="update_button" formaction="../AdminUpdateUnitMemorandum" value="Update Document" onclick="test()"/>
                                <input type="submit" name="archive_button" formaction="../AdminArchiveUnitMemorandum" value="Archive Document" onclick="return confirm('Are you sure? Archived documents will no longer be editable.')" />
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
                            <form action="../AdminAddUnitMemorandum" method="post">
                                <p>Add New Document</p>
                                <input type="hidden" name="role" value="<%out.print(role);%>">
                                <input type="hidden" name="unit" value="<%out.print(unitArray[i - 1]);%>">
                                <label for="doclink">File Link</label>
                                <input type="text" id="doclink" name="doclink" placeholder="Enter Google Drive Sharing Link" maxlength="500" pattern="https://drive\.google\.com/file/d/.*/view\?usp=sharing" title="Google Drive Sharing Link" required>
                                <br>
                                <label for="doctitle">Document Title</label>
                                <input type="text" id="doctitle" name="doctitle" placeholder="Enter Document Title" maxlength="100" required>
                                <br>
                                <label for="docdesc">Description</label>
                                <textarea id="docdesc" name="docdesc" placeholder="Enter Brief Description"   maxlength="200" required></textarea>
                                <br>
                                <input type="submit" name="add_button" value="Add Document" onclick="test()"/>
                            </form>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
            <!--         -->
            <!-- Content -->
            <!--         -->
        </div>
    </body>
</html>