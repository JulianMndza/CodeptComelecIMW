/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package usec;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
public class UpdateUSECServlet extends HttpServlet {

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
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title").trim();
        String docLink = request.getParameter("doclink").trim();
        
        try {
            if (conn != null) {
                if (docLink.matches("^https://drive\\.google\\.com/file/d/(.*)/view\\?usp=sharing$")) {
                    URL url = new URL(docLink);
                    HttpURLConnection huc = (HttpURLConnection)url.openConnection(); huc.setRequestMethod("HEAD");
                    int responseCode = huc.getResponseCode();
                    if (!hasAnotherURL(docLink)) {
                        if (responseCode == 200) {
                            String embedLink = processURL(docLink);
                            
                            Statement st = conn.createStatement();
                            String query = "SELECT * FROM USEC";
                            ResultSet rs = st.executeQuery(query);

                            if (rs.next()) {
                                String update = "UPDATE USEC SET TITLE=?, FILE_LINK=?, EMBED_LINK=? WHERE LABEL=?";
                                PreparedStatement ps = conn.prepareStatement(update);
                                ps.setString(1, title);
                                ps.setString(2, docLink);
                                ps.setString(3, embedLink);
                                ps.setString(4, "USEC");
                                ps.executeUpdate();
                            }
                            else {
                                String insertQuery = "INSERT INTO USEC (TITLE, FILE_LINK, EMBED_LINK, LABEL) VALUES (?, ?, ?, ?)";
                                PreparedStatement ps2 = conn.prepareStatement(insertQuery);
                                ps2.setString(1, title);
                                ps2.setString(2, docLink);
                                ps2.setString(3, embedLink);
                                ps2.setString(4, "USEC");
                                ps2.executeUpdate();
                            }

                            response.sendRedirect("Admin/USEC");
                        }
                        else {
                            String error = "Invalid URL";
                            request.setAttribute("Error", error);
                            throw new RequestException(error);
                        }
                    }
                    else {
                        String error = "More than one URL was entered";
                        request.setAttribute("Error", error);
                        throw new RequestException(error);
                    }
                }
                else {
                    String error = "Please enter a Google Drive file sharing URL";
                    request.setAttribute("Error", error);
                    throw new RequestException(error);
                }
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
