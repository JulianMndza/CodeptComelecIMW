/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package profile;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.RequestException;
import model.Security;

/**
 *
 * @author user
 */
public class UnitEditorChangePasswordServlet extends HttpServlet {

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
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String oldPassword = request.getParameter("oldpassword").trim();
        oldPassword = Security.encrypt(oldPassword);
        String newPassword = request.getParameter("newpassword").trim();
        String conPassword = request.getParameter("conpassword").trim();
        
        try {
            if (conn != null) {
                
                if (oldPassword.equals("") || newPassword.equals("") || conPassword.equals("")) {
                    String error = "One Of The Fields Is Blank";
                    request.setAttribute("Error", error);
                    throw new RequestException(error);
                }
                
                if (oldPassword.equals(password)) {
                    if (newPassword.equals(conPassword)) {
                        String encryptedNewPass = Security.encrypt(conPassword);
                        String update = "UPDATE USER_INFO SET PASSWORD=? WHERE USERNAME=?";
                        PreparedStatement ps = conn.prepareStatement(update);
                        ps.setString(1, encryptedNewPass);
                        ps.setString(2, username);
                        ps.executeUpdate();
                        HttpSession session = request.getSession(false);
                        session.setAttribute("Password", encryptedNewPass);
                        response.sendRedirect("Unit_Editor/MyAccount");
                    }
                    else {
                        String error = "New Passwords Do Not Match";
                        request.setAttribute("Error", error);
                        throw new RequestException(error);
                    }
                }
                else {
                    String error = "Old Password Is Incorrect";
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
