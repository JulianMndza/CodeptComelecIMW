/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package announcement;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.RequestException;

/**
 *
 * @author user
 */
public class AddAnnouncementServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    Connection conn;
    
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try {
            Class.forName(config.getInitParameter("jdbcClassName"));
            String username = config.getInitParameter("jdbcUserName");
            String password = config.getInitParameter("jdbcPassword");
            String url = config.getInitParameter("jdbcDriverURL") + config.getInitParameter("databaseName");
            conn = DriverManager.getConnection(url, username, password);
        }
        catch (SQLException sqle) {
            System.out.println("SQLException error occured - " + sqle.getMessage());
        }
        catch (ClassNotFoundException cnfe) {
            System.out.println("ClassNotFoundException error occured - " + cnfe.getMessage());
        }
    }
    
    public String processURL(String url) {
        url = url.substring(32, url.length() - 17);
        url = "https://drive.google.com/file/d/" + url + "/preview";
        return url;
    }
    
    public boolean hasAnotherURL(String url) {
        url = url.substring(8);
        return url.contains("https://");
    }
    
    public int checkURL(String link, int counter) {
        try {
            if (link.matches("^https://drive\\.google\\.com/file/d/(.*)/view\\?usp=sharing$")) {
                URL url = new URL(link);
                HttpURLConnection huc = (HttpURLConnection)url.openConnection(); huc.setRequestMethod("HEAD");
                int responseCode = huc.getResponseCode();
                if (!hasAnotherURL(link)) {
                    if (responseCode == 200) {
                        return -1;
                    }
                    else {
                        return counter + 1;
                    }
                }
                else {
                    return counter + 1;
                }
            }
            else {
                return counter + 1;
            }
        }
        catch (Exception e) {
            return counter + 1;
        }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String annLink = request.getParameter("annlink").trim();
        String annTitle = request.getParameter("anntitle").trim();
        String annSubtitle = request.getParameter("annsubtitle").trim();
        String annContent = request.getParameter("anncontent").trim();
        
        String[] linkArray = annLink.split("\\s+");
        String embedLink = "";
        
        String schoolYear = "";
        
        LocalDateTime dt = LocalDateTime.now();
        Timestamp ts = Timestamp.valueOf(dt);
        
        int month = dt.getMonthValue();
        int year = dt.getYear();
        
        if (month < 8) {
            schoolYear = (year - 1) + "-" + year;
        }
        else {
            schoolYear = year + "-" + (year + 1);
        }
        
        try {
            if (conn != null) {
                for (int i = 0; i < linkArray.length; i++) {
                    int result = checkURL(linkArray[i], i);
                    if (result != -1) {
                        String error = "Something went wrong at URL number " + result;
                        request.setAttribute("Error", error);
                        throw new RequestException(error);
                    }
                    else {
                        embedLink = embedLink + " " + processURL(linkArray[i]);
                    }
                }
                
                String query = "SELECT * FROM ANNOUNCEMENTS WHERE IMAGE_LINK = ?";
                PreparedStatement ps1 = conn.prepareStatement(query);
                ps1.setString(1, annLink);
                ResultSet rs = ps1.executeQuery();

                if (rs.next()) {
                    String error = "Announcement Already Exists";
                    request.setAttribute("Error", error);
                    throw new RequestException(error);
                }

                String insertQuery = "INSERT INTO ANNOUNCEMENTS (IMAGE_LINK, ANNOUNCEMENT_TITLE, ANNOUNCEMENT_SUBTITLE, ANNOUNCEMENT_CONTENT, EMBED_LINK, STATUS, SCHOOL_YEAR, TIMESTAMP) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps2 = conn.prepareStatement(insertQuery);
                ps2.setString(1, annLink);
                ps2.setString(2, annTitle);
                ps2.setString(3, annSubtitle);
                ps2.setString(4, annContent);
                ps2.setString(5, embedLink);
                ps2.setString(6, "Not Archived");
                ps2.setString(7, schoolYear);
                ps2.setTimestamp(8, ts);
                ps2.executeUpdate();
                
                query = "SELECT * FROM SCHOOL_YEARS WHERE SCHOOL_YEAR = ?";
                ps1 = conn.prepareStatement(query);
                ps1.setString(1, schoolYear);
                rs = ps1.executeQuery();
                
                if (!rs.next()) {
                    insertQuery = "INSERT INTO SCHOOL_YEARS (SCHOOL_YEAR) VALUES (?)";
                    ps2 = conn.prepareStatement(insertQuery);
                    ps2.setString(1, schoolYear);
                    ps2.executeUpdate();
                }

                response.sendRedirect("Admin/Home");
            }
            else {
                String error = "No Database Connection";
                request.setAttribute("Error", error);
                throw new RequestException(error);
            }
        }
        catch (SQLException sqle) {
            sqle.printStackTrace();
            String error = "Database Error";
            request.setAttribute("Error", error);
            throw new RequestException(error);
        }
        catch (MalformedURLException e) {
            String error = "Invalid URL";
            request.setAttribute("Error", error);
            throw new RequestException(error);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
