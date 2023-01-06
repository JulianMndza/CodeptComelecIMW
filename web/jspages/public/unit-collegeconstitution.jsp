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
        <title>Central COMELEC · College Constitutions</title>
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
                            <a class="btn" href="${pageContext.request.contextPath}/Unit_ExecutiveOrder">EXECUTIVE ORDER</a> 
                            <a class="btn active" href="${pageContext.request.contextPath}/Unit_Constitution">CONSTITUTION</a>
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
                <li><a class="over btn" href="${pageContext.request.contextPath}/Unit_ExecutiveOrder">UNITS · EXECUTIVE ORDER</a></li>
                <li><a class="over btn active" href="${pageContext.request.contextPath}/Unit_Constitution">UNITS · COLLEGE CONSTITUTION</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Units_Archive_SelectUnit">UNITS · ARCHIVES</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Directory">DIRECTORY</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/USEC">USEC</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Constitution">CONSTITUTION</a></li>
                <li><a class="over btn" href="${pageContext.request.contextPath}/Documents">DOCUMENTS</a></li>
            </ul>
        </div>
        <!--         -->
        <!-- Content -->
        <!--         -->
        <div id="swup" class="container transition-none">
            <div class="heading-bg">
                <div class="heading">
                    <div class="square"><img src="assets/central-comelec.png" alt="COMELEC"></div>
                    <div class="content transition-top">
                        <h1>College Constitution</h1>
                        <p>Student Council Constitution of all COMELEC units</p>
                    </div>
                </div>
            </div>
            <div class="unit-content transition-right" >
                <h2>List of COMELEC Units</h2>
                <div class="form-box">
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Central Commission on Elections">
                            <h3>Central Commission on Elections</h3>
                            <img src="comelec-logos/logo-CENTRAL.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="UST-AMV College of Accountancy">
                            <h3>UST-AMV College of Accountancy</h3>
                            <img src="comelec-logos/logo-AMV.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="College of Architecture">
                            <h3>College of Architecture</h3>
                            <img src="comelec-logos/logo-ARCHI.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="College of Commerce and Business Administration">
                            <h3>College of Commerce and Business Administration</h3>
                            <img src="comelec-logos/logo-COMMERCE.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="College of Education">
                            <h3>College of Education</h3>
                            <img src="comelec-logos/logo-EDUC.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="College of Fine Arts and Design">
                            <h3>College of Fine Arts and Design</h3>
                            <img src="comelec-logos/logo-CFAD.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="College of Information and Computing Sciences">
                            <h3>College of Information and Computing Sciences</h3>
                            <img src="comelec-logos/logo-IICS.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="College of Nursing">
                            <h3>College of Nursing</h3>
                            <img src="comelec-logos/logo-NURSING.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="College of Rehabilitation Sciences">
                            <h3>College of Rehabilitation Sciences</h3>
                            <img src="comelec-logos/logo-CRS.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="College of Science">
                            <h3>College of Science</h3>
                            <img src="comelec-logos/logo-SCI.png" alt="COMELEC">
                        </button> 
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="College of Tourism and Hospitality Management">
                            <h3>College of Tourism and Hospitality Management</h3>
                            <img src="comelec-logos/logo-CTHM.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Conservatory of Music">
                            <h3>Conservatory of Music</h3>
                            <img src="comelec-logos/logo-MUSIC.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Faculty of Arts and Letters">
                            <h3>Faculty of Arts and Letters</h3>
                            <img src="comelec-logos/logo-AB.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Faculty of Civil Law">
                            <h3>Faculty of Civil Law</h3>
                            <img src="comelec-logos/logo-CIVIL.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Faculty of Engineering">
                            <h3>Faculty of Engineering</h3>
                            <img src="comelec-logos/logo-ENGG.png" alt="COMELEC">
                        </button> 
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Faculty of Medicine and Surgery">
                            <h3>Faculty of Medicine and Surgery</h3>
                            <img src="comelec-logos/logo-MED.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Faculty of Pharmacy">
                            <h3>Faculty of Pharmacy</h3>
                            <img src="comelec-logos/logo-PHARMA.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Ecclesiastical Faculties (Canon Law, Philosophy, and Sacred Theology)">
                            <h3>Ecclesiastical Faculties</h3>
                            <img src="comelec-logos/logo-EHS.png" alt="COMELEC"><!--may be wrong?-->
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Institute of Physical Education">
                            <h3>Institute of Physical Education</h3>
                            <img src="comelec-logos/logo-IPEA.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Education High School">
                            <h3>Education High School</h3>
                            <img src="comelec-logos/logo-EHS2.png" alt="COMELEC">
                        </button> 
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Junior High School">
                            <h3>Junior High School</h3>
                            <img src="comelec-logos/logo-JHS.png" alt="COMELEC">
                        </button>  
                    </form>
                    <form action="Unit_Constitution_DocumentViewer" method="get" class="logo-wrapper">
                        <button type="submit" class="logo-content" >  
                            <input type="hidden" name="chosenunit" value="Senior High School">
                            <h3>Senior High School</h3>
                            <img src="comelec-logos/logo-SHS.png" alt="COMELEC">
                        </button> 
                    </form>
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