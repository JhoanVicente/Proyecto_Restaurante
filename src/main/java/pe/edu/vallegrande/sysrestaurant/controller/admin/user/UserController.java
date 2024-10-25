package pe.edu.vallegrande.sysrestaurant.controller.admin.user;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.sf.jasperreports.engine.*;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import pe.edu.vallegrande.sysrestaurant.db.AccessDB;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.user.TypeUserService;
import pe.edu.vallegrande.sysrestaurant.service.user.UserService;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet({"/admin", "/admin/"})
public class UserController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sesion = request.getSession();
        UserDto logged = (UserDto) sesion.getAttribute("logged");
        if (logged == null || (logged.getTypeUser() != 1)) {
            response.sendRedirect("/login");
            return;
        }
        if (!logged.isStatus()) {
            response.sendRedirect("/inactiveUser");
            return;
        }

        int viewStatus = sesion.getAttribute("userStatus") != null ? (int) sesion.getAttribute("userStatus") : 1;
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "edit":
                    this.showDetailUser(request, response);
                    break;
                case "delete":
                case "restore":
                    this.updateUserStatus(request, response, action);
                    break;
                case "generatePDFUsers":
                    this.generatePDFUsers(request, response);
                    break;
                case "generateXLSUsers":
                    this.generateXLSUsers(request, response);
                    break;
                case "generateCSVUsers":
                    this.generateCSVUsers(request, response);
                    break;
                case "generatePDFUsersJasperA":
                    this.generatePDFUsersJasperA(request, response);
                    break;
                case "generatePDFUsersJasperI":
                    this.generatePDFUsersJasperI(request, response);
                    break;
                default:
                    this.showDefault(request, response, viewStatus);
                    break;
            }
        } else {
            this.showDefault(request, response, viewStatus);
        }

    }
    public void generatePDFUsersJasperA(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection connection = null;
        try {
            // Establecer la conexión a la base de datos
            connection = AccessDB.getConexion();
            // Compilar el archivo .jrxml
            InputStream reportStream = getClass().getClassLoader().getResourceAsStream("reports/UsersActive.jrxml");
            if (reportStream == null) {
                throw new FileNotFoundException("El archivo tra.jrxml no se encuentra en el classpath.");
            }
            JasperReport jasperReport = JasperCompileManager.compileReport(reportStream);

            // Llenar el reporte
            Map<String, Object> parameters = new HashMap<>();
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

            // Configurar la respuesta HTTP para la exportación del PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=UsersActive.pdf");

            // Exportar el reporte a PDF
            JasperExportManager.exportReportToPdfStream(jasperPrint, response.getOutputStream());

            System.out.println("Reporte generado correctamente!");

        } catch (JRException | IOException e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    public void generatePDFUsersJasperI(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection connection = null;
        try {
            // Establecer la conexión a la base de datos
            connection = AccessDB.getConexion();
            // Compilar el archivo .jrxml
            InputStream reportStream = getClass().getClassLoader().getResourceAsStream("reports/UsersInactive.jrxml");
            if (reportStream == null) {
                throw new FileNotFoundException("El archivo tra.jrxml no se encuentra en el classpath.");
            }
            JasperReport jasperReport = JasperCompileManager.compileReport(reportStream);

            // Llenar el reporte
            Map<String, Object> parameters = new HashMap<>();
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

            // Configurar la respuesta HTTP para la exportación del PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=UsersInactive.pdf");

            // Exportar el reporte a PDF
            JasperExportManager.exportReportToPdfStream(jasperPrint, response.getOutputStream());

            System.out.println("Reporte generado correctamente!");

        } catch (JRException | IOException e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    private void showDefault(HttpServletRequest request, HttpServletResponse response, int idStatus) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String searchUser = request.getParameter("search");
        UserService userService = new UserService();
        List<UserDto> listUsersByStatuses;
        if (searchUser != null && !searchUser.isEmpty()) {
            listUsersByStatuses = userService.searchUsers(searchUser, idStatus);
        } else {
            listUsersByStatuses = userService.listUserAllForStatus(idStatus);
        }
        session.setAttribute("userStatus", idStatus);
        session.setAttribute("typeUser", new TypeUserService().listTypeUser());
        session.setAttribute("listUsersByStatus", listUsersByStatuses);
        session.setAttribute("countStatusA", userService.countUsersByStatus(1));
        session.setAttribute("countStatusI", userService.countUsersByStatus(0));
        request.getRequestDispatcher("/WEB-INF/admin/user/user.jsp").forward(request, response);
    }
    private void showDetailUser(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        int idUsuario = Integer.parseInt(request.getParameter("idUser"));
        UserDto userDto = new UserService().searchUser(new UserDto(idUsuario));
        int countOrdersByClient = new UserService().countOrdersByClient(idUsuario);
        request.setAttribute("countOrdersByClient", countOrdersByClient);
        request.setAttribute("user", userDto);
        request.getRequestDispatcher("/WEB-INF/admin/templates/user/editUser.jsp").forward(request, response);
    }
    private void updateUserStatus(HttpServletRequest request, HttpServletResponse response, String action) throws
            ServletException, IOException {
        int idUser = Integer.parseInt(request.getParameter("idUser"));
        int status;
        String successMessage,errorMessage, alert;
        if (action.equals("delete")) {
            status = 0;
            successMessage = "Usuario eliminado correctamente";
            errorMessage = "Error al eliminar el usuario";
        } else if (action.equals("restore")) {
            status = 1;
            successMessage = "Usuario restaurado correctamente";
            errorMessage = "Error al restaurar el usuario";
        } else {
            throw new IllegalArgumentException("Acción no válida");
        }
        int updated = new UserService().updateUserStatus(status, new UserDto(idUser));
        alert = (updated == 1) ? "swal('¡Éxito!', '" + successMessage + "', 'success');" : "swal('¡Error!', '" + errorMessage + "', 'error');";
        request.setAttribute("alert", alert);
        this.showDefault(request, response, status);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sesion = request.getSession();
        UserDto logged = (UserDto) sesion.getAttribute("logged");
        if (logged == null || (logged.getTypeUser() != 1)) {
            response.sendRedirect("/login");
            return;
        }
        if (!logged.isStatus()) {
            response.sendRedirect("/inactiveUser");
            return;
        }

        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
             
                case "modify":
                    this.modifyUser(request, response);
                    break;
                default:
                    this.showDefault(request, response, 1);
                    break;
            }
        } else {
            String userStatusStr = request.getParameter("userStatus");
            int userStatus = userStatusStr != null ? Integer.parseInt(userStatusStr) : 1;
            this.showDefault(request, response, userStatus);
        }
    }
    private void modifyUser(HttpServletRequest request, HttpServletResponse response) throws
            ServletException, IOException {
        HttpSession session = request.getSession();
        int idUsuario = Integer.parseInt(request.getParameter("idUser"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String originalPassword = request.getParameter("originalPassword");
        if (!password.equals(originalPassword)) {
            password = DigestUtils.md5Hex(password);
        }
        String tipodocumento = request.getParameter("tipodocumento");
        String documentoidentidad = request.getParameter("documentoidentidad");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String fechaNacimientoStr = request.getParameter("fechanacimiento");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        int tipousuario = Integer.parseInt(request.getParameter("tipousuario"));
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date fechaNacimiento = null;
        try {
            fechaNacimiento = dateFormat.parse(fechaNacimientoStr);
        } catch (ParseException e) {
            e.printStackTrace();
            throw new ServletException("Error al convertir la fecha de nacimiento.", e);
        }
        int actualizado = new UserService().updateUser(new UserDto(idUsuario, username, password, nombre, apellido, fechaNacimiento, direccion, telefono, email, documentoidentidad, tipodocumento, tipousuario));
        String alert;
        if (actualizado == 1) {
            alert = "swal('¡Éxito!', 'Fue modificado correctamente', 'success');";
        } else {
            alert = "swal('¡Error!', 'Error al modificar', 'error');";
        }
        session.setAttribute("alert", alert);
        response.sendRedirect("/admin");
    }
 
    private void generateCSVUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        int status = session.getAttribute("userStatus") != null ? (int) session.getAttribute("userStatus") : 1;
        String searchUser = request.getParameter("search");
        UserService userService = new UserService();
        List<UserDto> userDtos;
        String titleFile;

        if (searchUser != null && !searchUser.isEmpty()) {
            userDtos = userService.searchUsers(searchUser, status);
        } else {
            userDtos = userService.listUserAllForStatus(status);
        }
        titleFile = status == 1 ? "Usuarios Activos" : "Usuarios Inactivos";

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"Informes " + titleFile + ".csv\"");

        try {
            PrintWriter writer = response.getWriter();
            CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT.withHeader("ID", "Username", "Nombre y Apellidos", "Tipo", "Email"));

            for (UserDto userDto : userDtos) {
                String userType = "Cliente";
                if (userDto.getTypeUser() == 1) {
                    userType = "Administrador";
                } else if (userDto.getTypeUser() == 2) {
                    userType = "Mesero";
                }
                csvPrinter.printRecord(userDto.getIdUsuario(), userDto.getUsername(), userDto.getNames() + " " + userDto.getLastnames(), userType, userDto.getEmail());
            }

            csvPrinter.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void generateXLSUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        int status = session.getAttribute("userStatus") != null ? (int) session.getAttribute("userStatus") : 1;
        String searchUser = request.getParameter("search");
        UserService userService = new UserService();
        List<UserDto> userDtos;
        boolean isSearch = false;
        String titleFile;

        if (searchUser != null && !searchUser.isEmpty()) {
            userDtos = userService.searchUsers(searchUser, status);
            isSearch = true;
        } else {
            userDtos = userService.listUserAllForStatus(status);
        }
        titleFile = status == 1 ? "Usuarios Activos" : "Usuarios Inactivos";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=\"Informes " + titleFile + ".xls\"");

        try {
            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Usuarios");
            HSSFRow headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("ID");
            headerRow.createCell(1).setCellValue("Username");
            headerRow.createCell(2).setCellValue("Nombre y Apellidos");
            headerRow.createCell(3).setCellValue("Tipo");
            headerRow.createCell(4).setCellValue("Email");

            for (int i = 0; i < userDtos.size(); i++) {
                UserDto userDto = userDtos.get(i);
                HSSFRow row = sheet.createRow(i + 1);
                row.createCell(0).setCellValue(userDto.getIdUsuario());
                row.createCell(1).setCellValue(userDto.getUsername());
                row.createCell(2).setCellValue(userDto.getNames() + " " + userDto.getLastnames());
                String userType = "Cliente";
                if (userDto.getTypeUser() == 1) {
                    userType = "Administrador";
                } else if (userDto.getTypeUser() == 2) {
                    userType = "Mesero";
                }
                row.createCell(3).setCellValue(userType);
                row.createCell(4).setCellValue(userDto.getEmail());
            }

            workbook.write(response.getOutputStream());
            workbook.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void generatePDFUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        int status = session.getAttribute("userStatus") != null ? (int) session.getAttribute("userStatus") : 1;
        String searchUser = request.getParameter("search");
        UserService userService = new UserService();
        List<UserDto> userDtos;
        boolean isSearch = false;
        // Condición para buscar usuarios por nombre o listar todos los usuarios por estado
        String titleFile;
        if (searchUser != null && !searchUser.isEmpty()) {
            userDtos = userService.searchUsers(searchUser, status);
            isSearch = true;

        } else {
            userDtos = userService.listUserAllForStatus(status);
        }
        titleFile = status == 1 ? "Usuarios Activos" : "Usuarios Inactivos";

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"Informes " + titleFile + ".pdf\"");
        try {
            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);
            Paragraph companyName = new Paragraph("Resturante: Lachancha.pe\n Informes de todos los Usuarios");
            companyName.setFontSize(16);
            companyName.setTextAlignment(TextAlignment.CENTER);
            document.add(companyName);
            // Add company details
            Paragraph companyDetails = new Paragraph("RUC: 07187656001\nDirección San Vicente de Cañete, Calle A\nTeléfono: 979333493\nEmail: contacto@Lachancha.pe");
            companyDetails.setFontSize(12);
            companyDetails.setTextAlignment(TextAlignment.CENTER);
            document.add(companyDetails);
            // Add line
            Paragraph line = new Paragraph("--------------------------------------------------------------------------");
            line.setTextAlignment(TextAlignment.CENTER);
            document.add(line);
            // Add Client details
            String typeDocument = logged.getTypeDocument().equals("DNI") ? "DNI: " : "CE: ";
            Paragraph invoiceDetails = new Paragraph("Administrador: " + logged.getNames() + " " + logged.getLastnames()
                    + "\n" + typeDocument + logged.getNumberIdentity()
                    + "\nCorreo: " + logged.getEmail()
                    + "\nTeléfono: " + logged.getPhone()
                    + "\nFecha: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + " " + LocalTime.now().format(DateTimeFormatter.ofPattern("hh:mm a")))
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(invoiceDetails);
            // Add line
            document.add(line);
            Paragraph titleDocument = new Paragraph(titleFile).setFontSize(12).setTextAlignment(TextAlignment.CENTER);
            document.add(titleDocument);

            Table table = new Table(5).setWidth(UnitValue.createPercentValue(100));
            String[] headers = {"ID", "Username", "Nombre y Apellidos", "Tipo", "Email"};
            for (String header : headers) {
                table.addCell(new Cell().add(new Paragraph(header)).setBackgroundColor(ColorConstants.LIGHT_GRAY).setTextAlignment(TextAlignment.CENTER));
            }

            for (UserDto listUserDto : userDtos) {
                table.addCell(new Cell().add(new Paragraph(String.valueOf(listUserDto.getIdUsuario()))).setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(listUserDto.getUsername())).setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(listUserDto.getNames() + " " + listUserDto.getLastnames())).setTextAlignment(TextAlignment.CENTER));
                String userType = "Cliente";
                if (listUserDto.getTypeUser() == 1) {
                    userType = "Administrador";
                } else if (listUserDto.getTypeUser() == 2) {
                    userType = "Mesero";
                }
                table.addCell(new Cell().add(new Paragraph(userType)).setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(listUserDto.getEmail())).setTextAlignment(TextAlignment.CENTER));
            }
            document.add(table);
            // Add line
            document.add(line);

            // Add footer
            Paragraph footer = new Paragraph("Este documento es una representación impresa de informes.\n Resturante Lachancha.pe\n Gracias por su preferencia.")
                    .setFontSize(10)
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(footer);
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}