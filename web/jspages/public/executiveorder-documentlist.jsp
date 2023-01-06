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
        <title>Central COMELEC · Executive Order</title>
        <link rel="icon" href="assets/icon.png" type="image/icon type">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="css/public.css">
        <script defer src="js/node_modules/swup/dist/swup.min.js"></script>
        <script defer type="module" src="js/swup-start.js"></script>
        <script defer src="js/public.js"></script>
        <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
    </head>
    <body onload="document.body.style.opacity = '1'">
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
            String unitPage = request.getParameter("unitpage");
            String chosenUnit = request.getParameter("chosenunit");
            if (chosenUnit == null) {
                String error = "Database Error";
                request.setAttribute("Error", error);
                throw new RequestException(error);
            }
            String[] generalLinks = {"", "", ""};
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
                }
            } catch (SQLException sqle) {
                sqle.printStackTrace();
                String error = "Database Error";
                request.setAttribute("Error", error);
                throw new RequestException(error);
            }
            String embedLink = "";
            String docTitle = "";
            String docDesc = "";
            boolean match = false;
            boolean match2 = false;
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
            String[] pageArray = {"reso", "memo", "exec"};
            for (int i = 0; i < unitArray.length; i++) {
                if (chosenUnit.equals(unitArray[i])) {
                    match = true;
                }
            }
            for (int j = 0; j < pageArray.length; j++) {
                if (unitPage.equals(pageArray[j])) {
                    match2 = true;
                }
            }
            if (match == false || match2 == false) {
                String error = "Format does not match";
                request.setAttribute("Error", error);
                throw new RequestException(error);
            }
        %>
        <!-- Navbar -->
        <nav id="navbar">
            <div class="nav-wrapper">
                <!-- Navbar Logo --> 
                <div class="logo">
                    <img src="assets/central-comelec.png" alt="COMELEC">
                    <a class="home-btn" href="${pageContext.request.contextPath}/Home"><% out.print(header);%></a>
                </div>
                <!-- Navbar Links -->
                <div id="menu">
                    <a class="btn home" href="${pageContext.request.contextPath}/">HOME</a>             
                    <div class="dropdown">
                        <a class="dropbtn" href="#">UNITS<i class="material-icons">keyboard_arrow_down</i></a>
                        <div class="dropdown-content">
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_Resolution">RESOLUTIONS</a> 
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_Memorandum">MEMORANDUM</a>    
                            <a class="btn active" href="${pageContext.request.contextPath}/Unit_ExecutiveOrder">EXECUTIVE ORDER</a> 
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_Constitution">CONSTITUTION</a> 
                            <a class="btn" href="${pageContext.request.contextPath}/Units_Archive_SelectUnit">UNIT ARCHIVES</a> 
                        </div>
                    </div>
                    <a class="btn" href="${pageContext.request.contextPath}/Directory">DIRECTORY</a>
                    <a class="btn" href="${pageContext.request.contextPath}/USEC">USEC</a>
                    <a class="btn" href="${pageContext.request.contextPath}/Constitution">CONSTITUTION</a>
                    <a class="btn" href="${pageContext.request.contextPath}/Documents">DOCUMENTS</a>
                </div>
            </div>
        </nav>
        <!-- Navbar Menu Icon -->
        <div class="menuIcon">
            <span class="icon icon-bars"></span>
        </div>  
        <div class="overlay-menu">
            <ul id="menu2">
                <li><a class="over btn home" href="${pageContext.request.contextPath}/Home">HOME</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Resolution">UNITS · RESOLUTIONS</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Memorandum">UNITS · MEMORANDUM</a></li>
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Unit_ExecutiveOrder">UNITS · EXECUTIVE ORDER</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Constitution">UNITS · COLLEGE CONSTITUTION</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Units_Archive_SelectUnit">UNITS · ARCHIVES</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Directory">DIRECTORY</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/USEC">USEC</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Constitution">CONSTITUTION</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Documents">DOCUMENTS</a></li>
            </ul>
        </div>
        <!--         -->
        <!-- Content -->
        <!-- Doc     -->
        <div id="swup" class="container transition-none">
            <div class="heading-bg">
                <div class="heading">
                    <div class="square"><img src="assets/central-comelec.png" alt="COMELEC"></div>
                    <div class="content transition-top">
                        <h1>Executive Order</h1>
                        <p>Selected Unit: <%out.print(chosenUnit);%></p>
                    </div>
                </div>
            </div>
            <div class="doc-content transition-right" >
                <h2>Document List</h2>
                <div class="docu-wrapper">
                    <%
                        try {
                            if (conn != null) {
                                String query = "";
                                if (unitPage.equals("reso")) {
                                    query = "SELECT * FROM UNIT_RESOLUTIONS WHERE UNIT = ? AND STATUS = ?";
                                } else if (unitPage.equals("memo")) {
                                    query = "SELECT * FROM UNIT_MEMORANDUM WHERE UNIT = ? AND STATUS = ?";
                                } else if (unitPage.equals("exec")) {
                                    query = "SELECT * FROM UNIT_EXECUTIVE_ORDER WHERE UNIT = ? AND STATUS = ?";
                                }
                                PreparedStatement ps = conn.prepareStatement(query);
                                ps.setString(1, chosenUnit);
                                ps.setString(2, "Not Archived");
                                ResultSet rs = ps.executeQuery();
                                int counter = 1;
                                if (!rs.next()) {
                    %>
                    <div class="message-box">
                        No records yet
                    </div> 
                    <%
                    } else {
                        do {
                            embedLink = rs.getString("EMBED_LINK").trim();
                            docTitle = rs.getString("TITLE").trim();
                            docDesc = rs.getString("DESCRIPTION").trim();
                    %>
                    <form action="Unit_ExecutiveOrder_DocumentViewer" method="get" class="doc-box">

                        <input type="hidden" name="embedlink" value="<%out.print(embedLink);%>">
                        <input type="hidden" name="doctitle" value="<%out.print(docTitle);%>">
                        <input type="hidden" name="chosenunit" value="<%out.print(chosenUnit);%>">
                        <h1><%out.print(docTitle);%></h1>
                        <p><%out.print(docDesc);%></p>
                        <div class="more-button">
                            <button type="submit" id="more"><i class="material-icons">arrow_forward</i>Read More</button>
                        </div>
                    </form>
                    <%
                                        counter++;
                                    } while (rs.next());
                                }
                            }
                        } catch (SQLException sqle) {
                            sqle.printStackTrace();
                            String error = "Database Error";
                            request.setAttribute("Error", error);
                            throw new RequestException(error);
                        }
                    %>
                </div>
                <a href="${pageContext.request.contextPath}/Unit_ExecutiveOrder">Back to Units: Executive Order</a>
            </div>
        </div>
        <!--         -->
        <!-- Content -->
        <!--         -->
        <!-- Footer -->
        <footer>
            <div class="content">
                <div class="logo">
                    <img src="assets/central-comelec.png" alt="COMELEC">
                    <div class="text">
                        <h1>UST CENTRAL <span>COMELEC</span></h1>
                        <h2><span>COMMISSION ON ELECTIONS</span></h2>
                        <h3>COMMISSIONED TO SERVE, LEAD, AND STAND OUT</h3>
                    </div>
                </div>
                <div class="socmed">
                    <h3>#OneCOMELEC</h3>
                    <div class="socmed-links">
                        <a href="<%out.print(generalLinks[1]);%>" target="_blank" rel="noopener noreferrer"><img class="fb" src="assets/fb-icon.png" alt="facebook"></a>
                        <a href="<%out.print(generalLinks[2]);%>" target="_blank" rel="noopener noreferrer"><img class="tw" src="assets/tw-icon.png" alt="twitter"></a>
                        <a href="mailto:<%out.print(generalLinks[0]);%>" target="_blank" rel="noopener noreferrer"><img class="em" src="assets/em-icon.png" alt="email"></a>
                    </div>
                </div>
            </div>
            <a><% out.print(footer);%></a>
        </footer>
    </body>
</html>