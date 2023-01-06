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
        <title>Central COMELEC · Documents</title>
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
            String schoolYear = "";
            String embedLink = "";
            String docTitle = "";
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
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_Memorandum">MEMO</a>    
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_ExecutiveOrder">EXECUTIVE ORDER</a> 
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_Constitution">CONSTITUTION</a>
                            <a class="btn" href="${pageContext.request.contextPath}/Units_Archive_SelectUnit">UNIT ARCHIVES</a>  
                        </div>
                    </div>
                    <a class="btn" href="${pageContext.request.contextPath}/Directory">DIRECTORY</a>
                    <a class="btn" href="${pageContext.request.contextPath}/USEC">USEC</a>
                    <a class="btn" href="${pageContext.request.contextPath}/Constitution">CONSTITUTION</a>
                    <a class="btn active" href="${pageContext.request.contextPath}/Documents">DOCUMENTS</a>
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
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_ExecutiveOrder">UNITS · EXECUTIVE ORDER</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Constitution">UNITS · COLLEGE CONSTITUTION</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Units_Archive_SelectUnit">UNITS · ARCHIVES</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Directory">DIRECTORY</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/USEC">USEC</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Constitution">CONSTITUTION</a></li>
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Documents">DOCUMENTS</a></li>
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
                        <h1>Document Archive</h1>
                        <p>Archived documents from previous school years</p>
                    </div>
                </div>
            </div>
            <div class="docu-arc-content transition-right" >
                <h2>Documents published from the following A.Y.:</h2>
                <div class="tabs">
                    <%
                        try {
                            if (conn != null) {
                                Statement st = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                String query1 = "SELECT * FROM SCHOOL_YEARS";
                                ResultSet rs1 = st.executeQuery(query1);
                                int counter = 1;
                                rs1.afterLast();
                                while (rs1.previous()) {
                                    schoolYear = rs1.getString("SCHOOL_YEAR").trim();
                    %>
                    <div class="tab">
                        <input type="checkbox" id="chck<%out.print(counter);%>">
                        <label class="tab-label" for="chck<%out.print(counter);%>"><%out.print(schoolYear);%></label>
                        <%
                            embedLink = "";
                            docTitle = "";
                            String query2 = "SELECT * FROM DOCUMENTS WHERE SCHOOL_YEAR = ? AND STATUS = ? ORDER BY TIMESTAMP DESC";
                            PreparedStatement ps = conn.prepareStatement(query2);
                            ps.setString(1, schoolYear);
                            ps.setString(2, "Archived");
                            ResultSet rs2 = ps.executeQuery();

                            if (!rs2.next()) {
                        %>
                        <div class="tab-content">
                            No records yet
                        </div> 
                        <%
                        } else {

                            do {
                                embedLink = rs2.getString("EMBED_LINK").trim();
                                docTitle = rs2.getString("TITLE").trim();
                        %>
                        <div class="tab-content">
                            <a href="<%out.print(embedLink);%>"  target="_blank"><u><%out.print(docTitle);%></u></a>
                        </div>
                        <%
                                } while (rs2.next());
                            }
                        %>
                    </div>
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
                </div>
                <a href="${pageContext.request.contextPath}/Documents">Back to Documents</a>
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