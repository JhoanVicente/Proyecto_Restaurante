package pe.edu.vallegrande.sysrestaurant.controller.admin.order;

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
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import pe.edu.vallegrande.sysrestaurant.dto.order.OrderDto;
import pe.edu.vallegrande.sysrestaurant.dto.order.OrderDetailDto;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.sale.OrderService;
import pe.edu.vallegrande.sysrestaurant.service.sale.StatusOrderService;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet({"/admin/order", "/admin/order/"})
public class OrderController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sesion = request.getSession();
        UserDto logged = (UserDto) sesion.getAttribute("logged");
        if (logged == null || (logged.getTypeUser() != 1 && logged.getTypeUser() != 2)) {
            response.sendRedirect("/login");
            return;
        }
        if (!logged.isStatus()) {
            response.sendRedirect("/inactiveUser");
            return;
        }
        int viewStatus = sesion.getAttribute("viewStatus") != null ? (int) sesion.getAttribute("viewStatus") : 4;

        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "status":
                    this.updateStatusOrder(request, response);
                    break;
                case "detail":
                    this.showDetailTicket(request, response);
                    break;
                case "generatePDFOrder":
                    this.generatePDFOrder(request, response);
                    break;
                case "generateXLSOrder":
                    this.generateXLSOrder(request, response);
                    break;
                case "generateCSVOrder":
                    this.generateCSVOrder(request, response);
                    break;
                default:
                    this.showOrderByStatus(request, response, viewStatus);
                    break;
            }
        } else {
            this.showOrderByStatus(request, response, viewStatus);
        }
    }
    // Mostrar por defecto los pedidos por estado
    private void showOrderByStatus(HttpServletRequest request, HttpServletResponse response, int idStatus) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String search = request.getParameter("search");
        OrderService orderService = new OrderService();
        List<OrderDto> listOrderDtoByStatuses;
        if (search != null && !search.isEmpty()) {
            listOrderDtoByStatuses = orderService.listOrderByName(search, idStatus);
        } else {
            listOrderDtoByStatuses = orderService.listOrderAllByStatus(idStatus);
        }
        session.setAttribute("viewStatus", idStatus);
        // Para mostrar el estado de los pedidos y poder cambiar su estado
        session.setAttribute("typeStatus",  new StatusOrderService().listStatusOrder());
        session.setAttribute("listOrderByStatus", listOrderDtoByStatuses);
        session.setAttribute("countStatus1", orderService.countOrderByStatus(1));
        session.setAttribute("countStatus2", orderService.countOrderByStatus(2));
        session.setAttribute("countStatus3", orderService.countOrderByStatus(3));
        session.setAttribute("countStatus4", orderService.countOrderByStatus(4));

        request.getRequestDispatcher("/WEB-INF/admin/order/saleOrder.jsp").forward(request, response);
    }

    private void showDetailTicket(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idTicket = Integer.parseInt(request.getParameter("idTicket"));
        List<OrderDetailDto> listOrderProductDetail = new OrderService().listOrderProductDetail(idTicket);
        OrderDto orderDtoTicket = new OrderService().listOrderByTicketClient(new OrderDto(idTicket));
        request.setAttribute("listOrderProductDetail", listOrderProductDetail);
        request.setAttribute("orderTicket", orderDtoTicket);
        request.getRequestDispatcher("/WEB-INF/templates/order/orderDetail.jsp").forward(request, response);
    }
    private void updateStatusOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idTicket = Integer.parseInt(request.getParameter("idTicket"));
        OrderDto orderDtoTicket = new OrderService().listOrderByTicketClient(new OrderDto(idTicket));
        int idStatusOrder = Integer.parseInt(request.getParameter("idStatusOrder"));
        int updatedOrder = new OrderService().updateStatusOrder(idStatusOrder, new OrderDto(idTicket));
        final String email = orderDtoTicket.getEmail();
        final String nombre = orderDtoTicket.getNames();
        final String apellido = orderDtoTicket.getLastnames();
        System.out.println(orderDtoTicket);
        String alert;
        final String statusOrderStr;
        final String descriptionStatus;
        final String imageStatus;
        switch (idStatusOrder) {
            case 2:
                descriptionStatus = "'felicidades!' su pedido se encuentra en estado Aceptado, Debe esperar que estamos en proceso su pedido, estar atento con el estado de su pedido, puede ser que nos pondremos nen contacto con usted";
                statusOrderStr = "Aceptado";
                imageStatus = "https://s12.gifyu.com/images/SrCOK.gif";
                break;
            case 3:
                descriptionStatus = "Lo sentimos, su pedido fue rechazado,  debe ser porque no cumple con los criterios del pedido, tendrás que contactarnos para saber el problema";
                statusOrderStr = "Rechazado";
                imageStatus = "https://s10.gifyu.com/images/SrCOE.gif";
                break;
            case 4:
                descriptionStatus = "Su pedido fue completado, gracias por su preferencia, esperamos que vuelva pronto";
                statusOrderStr = "Completado";
                imageStatus = "https://s10.gifyu.com/images/SrCOk.gif";
                break;
            default:
                descriptionStatus = "Su pedido se encuentra en verificación para hacer el paso de Aceptación";
                statusOrderStr = "Pendiente";
                imageStatus = "https://s12.gifyu.com/images/SrqYY.gif";
                break;
        }

        if (updatedOrder > 0) {
            alert = "swal('Estado del pedido Cambiado', 'Su estado del pedido fue cambiado correctamente ', 'success');";

            // Create a separate thread to handle the Google Apps Script POST request
            new Thread(() -> {
                try {
                    // Create the POST parameters
                    String urlParameters = "your-names=" + URLEncoder.encode(nombre, "UTF-8") +
                            "&your-lastnames=" + URLEncoder.encode(apellido, "UTF-8") +
                            "&your-email=" + URLEncoder.encode(email, "UTF-8") +
                            "&your-status=" + URLEncoder.encode(statusOrderStr, "UTF-8") +
                            "&your-description=" + URLEncoder.encode(descriptionStatus, "UTF-8") +
                            "&your-image=" + URLEncoder.encode(imageStatus, "UTF-8");

                    // Create the connection and POST request
                    URL url = new URL("https://script.google.com/macros/s/AKfycbzoUGUgaRIMY-le5pTi2vfp-lFTweTh4iBZ-NIP9zwFt2MosV-_SQR5UdtxmP05s0P9GA/exec");
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("POST");
                    conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                    conn.setRequestProperty("Content-Length", String.valueOf(urlParameters.getBytes().length));
                    conn.setDoOutput(true);

                    // Send the POST request
                    try (OutputStream os = conn.getOutputStream()) {
                        os.write(urlParameters.getBytes(StandardCharsets.UTF_8));
                    }

                    // Read the response
                    int responseCode = conn.getResponseCode();
                    if (responseCode == HttpURLConnection.HTTP_OK) {
                        System.out.println("La solicitud POST a Google Apps Script fue exitosa.");
                    } else {
                        System.out.println("Error: la solicitud POST a Google Apps Script falló. Código de respuesta: " + responseCode);
                    }

                    conn.disconnect();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }).start();
        } else {
            alert = "swal('¡Error!', 'Error al cambiar de estado, vuelva a intentarlo', 'error');";
        }
        request.getSession().setAttribute("alert", alert);
        this.showOrderByStatus(request, response, idStatusOrder);
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sesion = request.getSession();
        UserDto logged = (UserDto) sesion.getAttribute("logged");
        if (logged == null || (logged.getTypeUser() != 1 && logged.getTypeUser() != 2)) {
            response.sendRedirect("/login");
            return;
        }
        if (!logged.isStatus()) {
            response.sendRedirect("/inactiveUser");
            return;
        }
        int viewStatus = request.getParameter("viewStatus") != null ? Integer.parseInt(request.getParameter("viewStatus")) : 4;

        if (viewStatus >= 1 && viewStatus <= 4) {
            sesion.setAttribute("viewStatus", viewStatus);
            this.showOrderByStatus(request, response, viewStatus);
        } else {
            this.showOrderByStatus(request, response, 4);
        }
    }


    private void generateCSVOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        int status = session.getAttribute("viewStatus") != null ? (int) session.getAttribute("viewStatus") : 4;
        String search = request.getParameter("search");
        OrderService orderService = new OrderService();
        List<OrderDto> listOrderDtoByStatuses;
        if (search != null && !search.isEmpty()) {
            listOrderDtoByStatuses = orderService.listOrderByName(search, status);
        } else {
            listOrderDtoByStatuses = orderService.listOrderAllByStatus(status);
        }

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"Informes  Pedidos"+".csv\"");

        try {
            PrintWriter writer = response.getWriter();
            CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT.withHeader("ID", "Nombre y Apellidos", "Fecha de Venta","Tipo de Entrega", "Modo de Pago", "Estado"));

            for (OrderDto user : listOrderDtoByStatuses) {
                String statusOrder = "Completado";
                if( user.getIdStatusOrder() == 1){
                    statusOrder = "Pendiente";
                } else if (user.getIdStatusOrder() == 2) {
                    statusOrder = "Aceptado";
                } else if (user.getIdStatusOrder() == 3) {
                    statusOrder = "Rechazado";
                }
                String formattedIdTicket = String.format("%06d", user.getIdTicket());
                csvPrinter.printRecord(formattedIdTicket+ ", "+ user.getNames() + ", " + user.getLastnames() + ",",  new SimpleDateFormat("dd/MM/yyyy").format(user.getDate()) + ",", user.getTypeDelivery() + ",", user.getTypePay() + ",", statusOrder);
            }

            csvPrinter.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void generateXLSOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        int status = session.getAttribute("viewStatus") != null ? (int) session.getAttribute("viewStatus") : 4;
        String search = request.getParameter("search");
        OrderService orderService = new OrderService();
        List<OrderDto> listOrderDtoByStatuses;
        if (search != null && !search.isEmpty()) {
            listOrderDtoByStatuses = orderService.listOrderByName(search, status);
        } else {
            listOrderDtoByStatuses = orderService.listOrderAllByStatus(status);
        }
        String titleFile = "Informes Pedidos";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + titleFile + ".xls\"");

        try {
            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Pedidos");
            HSSFRow headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("ID");
            headerRow.createCell(1).setCellValue("Nombre y Apellidos");
            headerRow.createCell(2).setCellValue("Fecha de Venta");
            headerRow.createCell(3).setCellValue("Tipo de Entrega");
            headerRow.createCell(4).setCellValue("Modo de Pago");
            headerRow.createCell(5).setCellValue("Estado");

            for (int i = 0; i < listOrderDtoByStatuses.size(); i++) {
                OrderDto orderDto = listOrderDtoByStatuses.get(i);
                HSSFRow row = sheet.createRow(i + 1);
                row.createCell(0).setCellValue(String.format("%06d", orderDto.getIdTicket()));
                row.createCell(1).setCellValue(orderDto.getNames() + " " + orderDto.getLastnames());
                row.createCell(2).setCellValue(new SimpleDateFormat("dd/MM/yyyy").format(orderDto.getDate()));
                row.createCell(3).setCellValue(orderDto.getTypeDelivery());
                row.createCell(4).setCellValue(orderDto.getTypePay());
                String statusOrder = "Completado";
                if( orderDto.getIdStatusOrder() == 1){
                    statusOrder = "Pendiente";
                } else if (orderDto.getIdStatusOrder() == 2) {
                    statusOrder = "Aceptado";
                } else if (orderDto.getIdStatusOrder() == 3) {
                    statusOrder = "Rechazado";
                }
                row.createCell(5).setCellValue(statusOrder);
            }

            workbook.write(response.getOutputStream());
            workbook.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void generatePDFOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int status = session.getAttribute("viewStatus") != null ? (int) session.getAttribute("viewStatus") : 4;
        String search = request.getParameter("search");
        OrderService orderService = new OrderService();
        List<OrderDto> listOrderDtoByStatuses;

        if (search != null && !search.isEmpty()) {
            listOrderDtoByStatuses = orderService.listOrderByName(search, status);
        } else {
            listOrderDtoByStatuses = orderService.listOrderAllByStatus(status);
        }

        String titleFile = "Informes Pedidos";

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + titleFile + ".pdf\"");

        try {
            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

            Paragraph companyName = new Paragraph("Resturante: Lachancha.pe\nInformes de todos los Pedidos");
            companyName.setFontSize(16);
            companyName.setTextAlignment(TextAlignment.CENTER);
            document.add(companyName);

            Paragraph companyDetails = new Paragraph("RUC: 07187656001\nDirección San Vicente de Cañete, Calle A\nTeléfono: 979333493\nEmail: contacto@Lachancha.pe");
            companyDetails.setFontSize(12);
            companyDetails.setTextAlignment(TextAlignment.CENTER);
            document.add(companyDetails);

            Paragraph line = new Paragraph("--------------------------------------------------------------------------");
            line.setTextAlignment(TextAlignment.CENTER);
            document.add(line);

            Paragraph invoiceDetails = new Paragraph("Fecha: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + " " + LocalTime.now().format(DateTimeFormatter.ofPattern("hh:mm a")))
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(invoiceDetails);

            document.add(line);

            Paragraph titleDocument = new Paragraph(titleFile).setFontSize(12).setTextAlignment(TextAlignment.CENTER);
            document.add(titleDocument);

            Table table = new Table(6).setWidth(UnitValue.createPercentValue(100));
            String[] headers = {"ID", "Nombre y Apellidos", "Fecha de Venta", "Tipo de Entrega", "Modo de Pago", "Estado"};
            for (String header : headers) {
                table.addCell(new Cell().add(new Paragraph(header)).setBackgroundColor(ColorConstants.LIGHT_GRAY).setTextAlignment(TextAlignment.CENTER));
            }

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            for (OrderDto orderDto : listOrderDtoByStatuses) {
                table.addCell(new Cell().add(new Paragraph(String.format("%06d", orderDto.getIdTicket()))).setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(orderDto.getNames() + " " + orderDto.getLastnames())).setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(sdf.format(orderDto.getDate()))).setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(orderDto.getTypeDelivery())).setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(orderDto.getTypePay())).setTextAlignment(TextAlignment.CENTER));

                String statusOrder = "Completado";
                if (orderDto.getIdStatusOrder() == 1) {
                    statusOrder = "Pendiente";
                } else if (orderDto.getIdStatusOrder() == 2) {
                    statusOrder = "Aceptado";
                } else if (orderDto.getIdStatusOrder() == 3) {
                    statusOrder = "Rechazado";
                }
                table.addCell(new Cell().add(new Paragraph(statusOrder)).setTextAlignment(TextAlignment.CENTER));
            }

            document.add(table);
            document.add(line);

            Paragraph footer = new Paragraph("Este documento es una representación impresa de informes.\nResturante Lachancha.pe\nGracias por su preferencia.")
                    .setFontSize(10)
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(footer);

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
