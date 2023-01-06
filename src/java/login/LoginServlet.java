/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package login;

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
import javax.servlet.http.HttpSession;
import model.RequestException;
import model.Security;

/**
 *
 * @author user
 */
public class LoginServlet extends HttpServlet {

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
        
        try {
            if (conn != null) {
                String query = "SELECT * FROM USER_INFO WHERE USERNAME = ?";
                PreparedStatement ps = conn.prepareStatement(query);
                ps.setString(1, username);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    //correct username
                    String encryptedPass = Security.encrypt(password);
                    String realPass = rs.getString("PASSWORD").trim();
                    if (encryptedPass.equals(realPass)) {
                        // correct username and password
                        String firstName = rs.getString("FIRST_NAME").trim();
                        String lastName = rs.getString("LAST_NAME").trim();
                        String role = rs.getString("ROLE").trim();
                        String unit = rs.getString("UNIT").trim();
                        
                        HttpSession session = request.getSession();
                        session.setAttribute("FirstName", firstName);
                        session.setAttribute("LastName", lastName);
                        session.setAttribute("Name", firstName + " " + lastName);
                        session.setAttribute("Username", username);
                        session.setAttribute("Password", realPass);
                        session.setAttribute("Role", role);
                        session.setAttribute("Unit", unit);
                        
                        //System.out.println("hi");
                        if (role.equals("Admin")) {
                            response.sendRedirect("Admin/Home");
                        }
                        else if (role.equals("Unit Editor")) {
                            response.sendRedirect("Unit_Editor/Unit_Resolutions");
                        }
                    }
                    else {
                        //correct username but wrong password
                        String error = "Valid Username but Invalid Password";
                        request.setAttribute("Error", error);
                        throw new RequestException(error);
                    }
                }
                else {
                    //wrong username and wrong password
                    String error = "Invalid Username and Password";
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
