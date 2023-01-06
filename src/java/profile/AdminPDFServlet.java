/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package profile;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.ColumnText;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.ByteArrayOutputStream;
import java.io.OutputStream;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import model.RequestException;

/**
 *
 * @author user
 */
public class AdminPDFServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    public class HeaderFooterPageEvent extends PdfPageEventHelper {
        private String header;
        private String footer;
        private int total;
        private int totalFinal = 0;
        
        public HeaderFooterPageEvent(String header, String footer, int total) {
            this.header = header;
            this.footer = footer;
            this.total = total;
        }
        
        @Override
        public void onStartPage(PdfWriter writer, Document document) {
            float middle = (document.left() + document.right()) / 2;
            ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_CENTER, new Phrase(header, FontFactory.getFont(FontFactory.TIMES_BOLD, 18)), middle, document.top()+20, 0);
            total++;
        }
        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            float middle = (document.left() + document.right()) / 2;
            LocalDateTime dateTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy HH:mm");
            String footerTime = dateTime.format(formatter);
            String pageNumber = "Page " + document.getPageNumber() + " of " + totalFinal + " | ";
            ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_LEFT, new Phrase(pageNumber + footerTime, FontFactory.getFont(FontFactory.HELVETICA, 11)), document.left(), document.bottom()-20, 0);
            ColumnText.showTextAligned(writer.getDirectContent(), Element.ALIGN_RIGHT, new Phrase(footer, FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 11)), document.right(), document.bottom()-20, 0);
        }
        public int getTotal() {
            return total;
        }
        public void setTotalFinal(int num) {
            totalFinal = num;
        }
    }
    
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
        try {
            if (conn != null) {
                HttpSession session = request.getSession(false);
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                if (session.getAttribute("Name") == null) {
                    response.sendRedirect("../Login");
                }
                else {
                    String name = (String)session.getAttribute("Name");
                    String uname = (String)session.getAttribute("Username");
                    LocalDateTime dateTime = LocalDateTime.now();
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
                    String filename = dateTime.format(formatter);
                    filename = "account-list-" + filename;
                    
                    String headerText = getServletContext().getInitParameter("header");
                    String footerText = getServletContext().getInitParameter("footer");
                    
                    Paragraph username = new Paragraph("Username: " + name, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12));
                    username.setSpacingAfter(10);
                    
                    PdfPTable table = new PdfPTable(5);
                    table.setWidths(new float[] {1, 5, 2, 2, (float)1.5});
                    table.setWidthPercentage(100);
                    
                    PdfPCell rl = new PdfPCell(new Phrase("Role", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12)));
                    rl.setBackgroundColor(BaseColor.LIGHT_GRAY);
                    PdfPCell au = new PdfPCell(new Phrase("Assigned Unit", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12)));
                    au.setBackgroundColor(BaseColor.LIGHT_GRAY);
                    PdfPCell ln = new PdfPCell(new Phrase("Last Name", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12)));
                    ln.setBackgroundColor(BaseColor.LIGHT_GRAY);
                    PdfPCell fn = new PdfPCell(new Phrase("First Name", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12)));
                    fn.setBackgroundColor(BaseColor.LIGHT_GRAY);
                    PdfPCell un = new PdfPCell(new Phrase("Username", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12)));
                    un.setBackgroundColor(BaseColor.LIGHT_GRAY);
                    
                    table.addCell(rl);
                    table.addCell(au);
                    table.addCell(ln);
                    table.addCell(fn);
                    table.addCell(un);
                    
                    try {
                        Statement st = conn.createStatement();
                        String query = "SELECT * FROM USER_INFO ORDER BY ROLE, UNIT, LAST_NAME, FIRST_NAME, USERNAME";
                        ResultSet rs = st.executeQuery(query);
                        while (rs.next()) {
                            String role = rs.getString("ROLE").trim();
                            String unit = rs.getString("UNIT").trim();
                            String lastName = rs.getString("LAST_NAME").trim();
                            String firstName = rs.getString("FIRST_NAME").trim();
                            String user = rs.getString("USERNAME").trim();
                            
                            table.addCell(role);
                            table.addCell(unit);
                            table.addCell(lastName);
                            table.addCell(firstName);
                            table.addCell(user);
                        }
                    }
                    catch (SQLException sqle) {
                        sqle.printStackTrace();
                        String error = "Database Error";
                        request.setAttribute("Error", error);
                        throw new RequestException(error);
                    }
                    
                    //Dummy PDF to get total pages
                    Document dummy = new Document(PageSize.LETTER.rotate(), 40, 40, 50, 50);
                    ByteArrayOutputStream bsDummy = new ByteArrayOutputStream();
                    PdfWriter writerDummy = PdfWriter.getInstance(dummy, bsDummy);
                    HeaderFooterPageEvent eventDummy = new HeaderFooterPageEvent(headerText, footerText, 0);
                    writerDummy.setPageEvent(eventDummy);
                    dummy.open();
                    dummy.add(username);
                    dummy.add(table);
                    dummy.close();
                    
                    //PdfReader to read dummy PDF total pages
                    PdfReader reader = new PdfReader(bsDummy.toByteArray());
                    int totalPages = eventDummy.getTotal();
                    
                    Document document = new Document(PageSize.LETTER.rotate(), 40, 40, 50, 50);
                    ByteArrayOutputStream bs = new ByteArrayOutputStream();
                    PdfWriter writer = PdfWriter.getInstance(document, bs);
                    HeaderFooterPageEvent event = new HeaderFooterPageEvent(headerText, footerText, totalPages);
                    event.setTotalFinal(totalPages);
                    writer.setPageEvent(event);
                    //document.addTitle(filename);
                    document.open();
                    document.add(username);
                    document.add(table);
                    document.close();
                    
                    response.setHeader("Content-Disposition", "attachment; filename=" + filename + ".pdf");
                    response.setContentType("application/pdf");
                    response.setContentLength(bs.size());
                    OutputStream os = response.getOutputStream();
                    bs.writeTo(os);
                    os.flush();
                    os.close();
                }
            }
            else {
                String error = "No Database Connection";
                request.setAttribute("Error", error);
                throw new RequestException(error);
            }
        }
        catch (DocumentException | IOException e) {
            e.printStackTrace();
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
