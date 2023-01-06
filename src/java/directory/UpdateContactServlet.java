/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package directory;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
public class UpdateContactServlet extends HttpServlet {

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
        String personLink = request.getParameter("personlink").trim();
        String cpfname = request.getParameter("cpfname").trim();
        String cplname = request.getParameter("cplname").trim();
        String ogcpdetail1 = request.getParameter("ogcpdetail1").trim();
        String cpdetail1 = request.getParameter("cpdetail1").trim();
        String cpdetail2 = request.getParameter("cpdetail2").trim();

        try {
            if (conn != null) {
                if (personLink.matches("^https://drive\\.google\\.com/file/d/(.*)/view\\?usp=sharing$")) {
                    URL url = new URL(personLink);
                    HttpURLConnection huc = (HttpURLConnection)url.openConnection(); huc.setRequestMethod("HEAD");
                    int responseCode = huc.getResponseCode();
                    if (!hasAnotherURL(personLink)) {
                        if (responseCode == 200) {
                            String query = "SELECT * FROM DIRECTORY WHERE PHONE_NO = ?";
                            PreparedStatement ps1 = conn.prepareStatement(query);
                            ps1.setString(1, cpdetail1);
                            ResultSet rs = ps1.executeQuery();

                            if (rs.next() && !ogcpdetail1.equals(cpdetail1)) {
                                String error = "Phone number already exists";
                                request.setAttribute("Error", error);
                                throw new RequestException(error);
                            }

                            String embedLink = processURL(personLink);

                            String update = "UPDATE DIRECTORY SET IMAGE_LINK=?, FIRST_NAME=?, LAST_NAME=?, PHONE_NO=?, EMAIL=?, EMBED_LINK=? WHERE PHONE_NO=?";
                            PreparedStatement ps = conn.prepareStatement(update);
                            ps.setString(1, personLink);
                            ps.setString(2, cpfname);
                            ps.setString(3, cplname);
                            ps.setString(4, cpdetail1);
                            ps.setString(5, cpdetail2);
                            ps.setString(6, embedLink);
                            ps.setString(7, ogcpdetail1);
                            ps.executeUpdate();

                            response.sendRedirect("Admin/Directory");
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
