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
        <title>Admin · Directory</title>
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
            String[] generalLinks = {"", "", ""};
            String imgLink = "";
            String firstName = "";
            String lastName = "";
            String phoneNo = "";
            String email = "";
            try {
                if (conn != null) {
                    Statement st = conn.createStatement();
                    String query = "SELECT * FROM GENERAL_CONTACT";
                    ResultSet rs = st.executeQuery(query);
                    for (int i = 0; i < generalLinks.length; i++) {
                        if (rs.next()) {
                            generalLinks[i] = rs.getString("LINK").trim();
                        }
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
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Admin/Directory">DIRECTORY</a></li>
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
                                <a class="btn" href="${pageContext.request.contextPath}/Admin/Unit_Memorandum">Memorandum</a>
                                <a class="btn" href="${pageContext.request.contextPath}/Admin/Unit_ExecutiveOrder">Executive Order</a>
                                <a class="btn" href="${pageContext.request.contextPath}/Admin/Unit_Constitution">College Constitution</a>
                            </div>
                        </div>
                        <a class="btn active" href="${pageContext.request.contextPath}/Admin/Directory">DIRECTORY</a>
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
                <h1><u>Directory Page Contents</u></h1>  
                <!--         
                    General Contact Details; 3 links
                -->
                <div>
                    <form action="../GeneralContactServlet" method="post">
                        <p>General Contact Details</p>
                        <label for="gmlink">G Mail</label>
                        <input type="text" id="gmlink" name="gmlink" placeholder="e.g. mail@example.com" value="<%out.print(generalLinks[0]);%>" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" maxlength="50" required>
                        <br>
                        <label for="fblink">Facebook</label>
                        <input type="text" id="fblink" name="fblink" placeholder="e.g. https://www.facebook.com/example/" value="<%out.print(generalLinks[1]);%>" pattern="https?://.+" maxlength="50" required>
                        <br>
                        <label for="twlink">Twitter</label>
                        <input type="text" id="twlink" name="twlink" placeholder="e.g. https://twitter.com/example" value="<%out.print(generalLinks[2]);%>" pattern="https?://.+" maxlength="50" required>
                        <br>
                        <input type="submit" name="update_button" value="Update General Contacts" onclick="test()"/>
                    </form>
                </div> 
                <br>
                <%
                    st = conn.createStatement();
                    query = "SELECT * FROM DIRECTORY";
                    rs = st.executeQuery(query);
                    int counter = 1;
                    while (rs.next()) {
                        imgLink = rs.getString("IMAGE_LINK").trim();
                        firstName = rs.getString("FIRST_NAME").trim();
                        lastName = rs.getString("LAST_NAME").trim();
                        phoneNo = rs.getString("PHONE_NO").trim();
                        email = rs.getString("EMAIL").trim();
                %>
                <!--         
                    Existing Contact Persons
                -->
                <div>
                    <form action="#" method="post">
                        <p>Contact Person <%out.print(counter);%></p>
                        <label for="personlink">Image Link</label>
                        <input type="text" id="personlink" name="personlink" placeholder="Enter Google Drive Sharing Link" value="<%out.print(imgLink);%>" pattern="https://drive\.google\.com/file/d/.*/view\?usp=sharing" title="Google Drive Sharing Link" maxlength="500" required>
                        <br>
                        <label for="cpfname">First Name</label>
                        <input type="text" id="cpfname" name="cpfname" placeholder="Enter First Name" value="<%out.print(firstName);%>" maxlength="50" required>
                        <br>
                        <label for="cplname">Last Name</label>
                        <input type="text" id="cplname" name="cplname" placeholder="Enter Last Name" value="<%out.print(lastName);%>" maxlength="50" required>
                        <br>
                        <label for="cpdetail1">Phone Number</label>
                        <input type="hidden" name="ogcpdetail1" value="<%out.print(phoneNo);%>">
                        <input type="text" id="cpdetail1" name="cpdetail1" placeholder="e.g. 09123456789" value="<%out.print(phoneNo);%>" maxlength="50" required>
                        <br>
                        <label for="cpdetail2">E-mail Address</label>
                        <input type="text" id="cpdetail2" name="cpdetail2" placeholder="e.g. mail@example.com" value="<%out.print(email);%>" maxlength="50" required>
                        <br>
                        <input type="submit" name="update_button" formaction="../UpdateContactServlet" value="Update Contact" onclick="test()"/>
                        <input type="submit" name="delete_button" formaction="../DeleteContactServlet" value="Delete Contact" onclick="return confirm('Are you sure you want to delete this contact person?')" />
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
                    Add Contact Person
                -->
                <div>
                    <form action="../AddContactServlet" method="post">
                        <p>Add New Contact Person</p>
                        <label for="personlink">Image Link</label>
                        <input type="text" id="personlink" name="personlink" placeholder="Enter Google Drive Sharing Link" maxlength="500" pattern="https://drive\.google\.com/file/d/.*/view\?usp=sharing" title="Google Drive Sharing Link" required>
                        <br>
                        <label for="cpfname">First Name</label>
                        <input type="text" id="cpfname" name="cpfname" placeholder="Enter First Name" maxlength="50" required>
                        <br>
                        <label for="cplname">Last Name</label>
                        <input type="text" id="cplname" name="cplname" placeholder="Enter Last Name" maxlength="50" required>
                        <br>
                        <label for="cpdetail1">Phone Number</label>
                        <input type="text" id="cpdetail1" name="cpdetail1" placeholder="e.g. 09123456789" pattern="^(09)\d{9}$" maxlength="50" required>
                        <br>
                        <label for="cpdetail2">E-mail Address</label>
                        <input type="text" id="cpdetail2" name="cpdetail2" placeholder="e.g. mail@example.com" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" maxlength="50" required>
                        <br>
                        <input type="submit" name="add_button" value="Add Contact" onclick="test()"/>
                    </form>
                </div> 
            </div>
            <!--         -->
            <!-- Content -->
            <!--         -->
        </div>
    </body>
</html>