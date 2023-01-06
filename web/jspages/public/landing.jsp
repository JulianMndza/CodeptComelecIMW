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
        <title>Central COMELEC · Home</title>
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
            String embedLink = "";
            String annTitle = "";
            String annSubtitle = "";
            String annContent = "";
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
                    <a class="btn active home" href="${pageContext.request.contextPath}/Home">HOME</a>             
                    <div class="dropdown">
                        <a class="dropbtn" href="#">UNITS<i class="material-icons">keyboard_arrow_down</i></a>
                        <div class="dropdown-content">
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_Resolution">RESOLUTIONS</a> 
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_Memorandum">MEMORANDUM</a>    
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_ExecutiveOrder">EXECUTIVE ORDER</a> 
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
                <li><a class="over btn home active" href="${pageContext.request.contextPath}/Home">HOME</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Resolution">UNITS · RESOLUTIONS</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_Memorandum">UNITS · MEMORANDUM</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_ExecutiveOrder">UNITS · EXECUTIVE ORDER</a></li>
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
        <!-- Home    -->
        <div id="swup" class="container transition-none">
            <div class="heading-bg home">
                <div class="heading">
                    <div class="square"><img src="assets/central-comelec.png" alt="COMELEC"></div>
                    <div class="content transition-top">
                        <h1>Central COMELEC</h1>
                        <p>Supreme governing body of all college-based COMELEC units and the regulatory body of all recognized political parties in UST</p>
                    </div>
                </div>
            </div>
            <div class="home-content transition-right">
                <div class="latest-ann">
                    <h2>Latest Announcements</h2>
                    <%
                        try {
                            if (conn != null) {
                                String query = "SELECT * FROM ANNOUNCEMENTS WHERE STATUS = ?";
                                PreparedStatement ps = conn.prepareStatement(query);
                                ps.setString(1, "Not Archived");
                                ResultSet rs = ps.executeQuery();
                                int counter = 1;
                                if (!rs.next()) {
                    %>
                    <div class="message-box">
                        No announcements yet
                    </div> 
                    <%
                    } else {
                        do {
                            embedLink = rs.getString("EMBED_LINK").trim();
                            annTitle = rs.getString("ANNOUNCEMENT_TITLE").trim();
                            annSubtitle = rs.getString("ANNOUNCEMENT_SUBTITLE").trim();
                            annContent = rs.getString("ANNOUNCEMENT_CONTENT").trim();
                    %>
                    <div class="ann-box">
                        <div class="ann-text">
                            <h1><%out.print(annTitle);%></h1>
                            <p><b><%out.print(annSubtitle);%></b></p>
                            <p><%out.print(annContent);%></p>
                        </div>
                        <div class="ann-images">
                            <div class="car-wrapper">
                                <div class="prev p-<%out.print(counter);%>"><i class="material-icons">keyboard_arrow_left</i></div>
                                <div class="img-container ic-<%out.print(counter);%>">
                                    <%
                                        String[] linkArray = embedLink.split("\\s+");
                                        for (int i = 0; i < linkArray.length; i++) {
                                    %>
                                    <div id="<%out.print(i + 1);%>" class="ann-img">
                                        <embed src="<%out.print(linkArray[i]);%>" allow="autoplay" style="pointer-events: none;">
                                    </div>
                                    <%
                                        }
                                    %>
                                </div>
                                <div class="next n-<%out.print(counter);%>"><i class="material-icons">keyboard_arrow_right</i></div>
                            </div>
                        </div>
                    </div>
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
                <div class="socmed-ann">
                    <div class="fb-box">
                        <h1 class="fb-head">Facebook</h1>
                        <iframe src="https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2FUSTCentralCOMELEC%2F&tabs=timeline&width=500&height=500&small_header=true&adapt_container_width=true&hide_cover=true&show_facepile=false&appId" width="500" height="500" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe>
                        <br>
                    </div>
                    <div class="fb-box2">
                        <h1 class="fb-head">Facebook</h1>
                        <iframe src="https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2FUSTCentralCOMELEC%2F&tabs=timeline&width=300&height=400&small_header=true&adapt_container_width=true&hide_cover=true&show_facepile=false&appId" width="300" height="400" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe>
                        <br>
                    </div>
                    <div class="tw-box">
                        <h1 class="tw-head">Twitter</h1>
                        <a class="twitter-timeline" data-width="500" data-height="500" href="https://twitter.com/USTCComelec?ref_src=twsrc%5Etfw"><strong>Tweets by USTCComelec</strong><br><br><em>click here</em> or <em>refresh the page</em><br>if the tweets are not showing.</a>
                        <br>
                    </div>    
                    <div class="tw-box2">
                        <h1 class="tw-head">Twitter</h1>
                        <a class="twitter-timeline" data-width="300" data-height="400" href="https://twitter.com/USTCComelec?ref_src=twsrc%5Etfw"><strong>Tweets by USTCComelec</strong><br><br><em>click here</em> or <em>refresh the page</em><br>if the tweets are not showing.</a> 
                        <br>
                    </div>                  
                </div>
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