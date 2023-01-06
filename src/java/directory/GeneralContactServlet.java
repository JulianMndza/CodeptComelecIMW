/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package directory;

import java.io.IOException;
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
public class GeneralContactServlet extends HttpServlet {

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
    
    public boolean hasAnotherURL(String url) {
        url = url.substring(8);
        return url.contains("https://");
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String gmLink = request.getParameter("gmlink").trim();
        String fbLink = request.getParameter("fblink").trim();
        String twLink = request.getParameter("twlink").trim();
        
        try {
            if (conn != null) {
                
                Statement st = conn.createStatement();
                String query = "SELECT * FROM GENERAL_CONTACT";
                ResultSet rs = st.executeQuery(query);

                if (rs.next()) {
                    String update = "UPDATE GENERAL_CONTACT SET LINK=? WHERE CONTACT=?";
                    PreparedStatement ps = conn.prepareStatement(update);
                    ps.setString(1, gmLink);
                    ps.setString(2, "GMAIL");
                    ps.executeUpdate();

                    update = "UPDATE GENERAL_CONTACT SET LINK=? WHERE CONTACT=?";
                    ps = conn.prepareStatement(update);
                    ps.setString(1, fbLink);
                    ps.setString(2, "FACEBOOK");
                    ps.executeUpdate();

                    update = "UPDATE GENERAL_CONTACT SET LINK=? WHERE CONTACT=?";
                    ps = conn.prepareStatement(update);
                    ps.setString(1, twLink);
                    ps.setString(2, "TWITTER");
                    ps.executeUpdate();
                }
                else {
                    String insertQuery = "INSERT INTO GENERAL_CONTACT (CONTACT, LINK) VALUES (?, ?), (?, ?), (?, ?)";
                    PreparedStatement ps2 = conn.prepareStatement(insertQuery);
                    ps2.setString(1, "GMAIL");
                    ps2.setString(2, gmLink);
                    ps2.setString(3, "FACEBOOK");
                    ps2.setString(4, fbLink);
                    ps2.setString(5, "TWITTER");
                    ps2.setString(6, twLink);
                    ps2.executeUpdate();
                }
                
                response.sendRedirect("Admin/Directory");
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
