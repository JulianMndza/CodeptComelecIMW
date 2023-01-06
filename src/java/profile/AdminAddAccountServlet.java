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
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.RequestException;
import model.Security;

/**
 *
 * @author user
 */
public class AdminAddAccountServlet extends HttpServlet {

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
        String firstName = request.getParameter("firstname").trim();
        String lastName = request.getParameter("lastname").trim();
        String username = request.getParameter("username").trim();
        String role = request.getParameter("role").trim();
        String unit = request.getParameter("assigned_unit").trim();
        String password = "defaultPassword";
        
        try {
            if (conn != null) {
                
                if (firstName.equals("") || lastName.equals("") || username.equals("") || unit.equals("")) {
                    String error = "One Of The Fields Is Blank";
                    request.setAttribute("Error", error);
                    throw new RequestException(error);
                }
                
                String query = "SELECT * FROM USER_INFO WHERE USERNAME = ?";
                PreparedStatement ps1 = conn.prepareStatement(query);
                ps1.setString(1, username);
                ResultSet rs = ps1.executeQuery();
                
                if (rs.next()) {
                    String error = "User Already Exists";
                    request.setAttribute("Error", error);
                    throw new RequestException(error);
                }
                
                if (role.equals("Admin") && !unit.equals("N/A")) {
                    String error = "Admin accounts cannot have a specific unit";
                    request.setAttribute("Error", error);
                    throw new RequestException(error);
                }
                
                if (role.equals("Unit Editor") && unit.equals("N/A")) {
                    String error = "Unit Editor accounts must have a unit";
                    request.setAttribute("Error", error);
                    throw new RequestException(error);
                }
                
                else {
                    String encryptedNewPass = Security.encrypt(password);
                    String insertQuery = "INSERT INTO USER_INFO (FIRST_NAME, LAST_NAME, USERNAME, PASSWORD, ROLE, UNIT) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement ps2 = conn.prepareStatement(insertQuery);
                    ps2.setString(1, firstName);
                    ps2.setString(2, lastName);
                    ps2.setString(3, username);
                    ps2.setString(4, encryptedNewPass);
                    ps2.setString(5, role);
                    ps2.setString(6, unit);
                    ps2.executeUpdate();

                    response.sendRedirect("Admin/Account");
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
