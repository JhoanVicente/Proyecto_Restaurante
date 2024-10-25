package pe.edu.vallegrande.sysrestaurant.controller.client.order;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.HorizontalAlignment;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.edu.vallegrande.sysrestaurant.dto.order.OrderDetailDto;
import pe.edu.vallegrande.sysrestaurant.dto.order.OrderDto;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.sale.OrderService;

import java.io.IOException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

@WebServlet({"/client", "/client/", "/client/order", "/client/order/"})
public class OrderClientController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        if (logged == null) {
            response.sendRedirect("/login");
            return;
        }
        if (!logged.isStatus()) {
            response.sendRedirect("/inactiveUser");
            return;
        }

        String action = request.getParameter("action");
        int orderStatus = session.getAttribute("viewStatusOrderClient") != null ? (int) session.getAttribute("viewStatusOrderClient") : 4;
        if (action != null) {
            switch (action) {
                case "detail":
                    this.showDetailTicket(request, response);
                    break;
                case "generatePDF":
                    this.exportPDFOrden(request, response);
                    break;
                case "generatePDFTicket":
                    this.generatePDFTicket(request, response);
                    break;
                default:
                    this.showOrderByStatus(request, response, orderStatus);
                    break;
            }
        } else {
            this.showOrderByStatus(request, response, orderStatus);
        }
    }

    private void showDetailTicket(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        int idTicket = Integer.parseInt(request.getParameter("idTicket"));
        List<OrderDetailDto> listOrderProductDetail = new OrderService().listOrderProductDetail(idTicket);
        OrderDto orderDtoTicket = new OrderService().listOrderByTicketClient(new OrderDto(idTicket));
        // Verifica si el ticket pertenece al usuario que inició sesión
        if (orderDtoTicket.getIdUser() != logged.getIdUsuario()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permiso para ver este ticket");
            return;
        }
        // Esto es una lista de detalles de la orden entonces para llamarlo en el jsp sería mediante un forEach
        request.setAttribute("listOrderProductDetail", listOrderProductDetail);
        // Esto es un objeto de la orden entonces para llamarlo en el jsp sería mediante el nombre del objeto
        request.setAttribute("orderTicket", orderDtoTicket);
        request.getRequestDispatcher("/WEB-INF/templates/order/orderDetail.jsp").forward(request, response);
    }

    private void exportPDFOrden(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDto logged = (UserDto) request.getSession().getAttribute("logged");
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"historialdPedidos(" + logged.getNames() + logged.getLastnames() + ").pdf\"");
        try {
            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

            Paragraph companyName = new Paragraph("Resturante: Lachancha.pe\n Informes de todos los Pedidos Completados");
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
            Paragraph invoiceDetails = new Paragraph("Cliente: " + logged.getNames() + " " + logged.getLastnames()
                    + "\n" + typeDocument + logged.getNumberIdentity()
                    + "\nCorreo: " + logged.getEmail()
                    + "\nTeléfono: " + logged.getPhone()
                    + "\nFecha: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + " " + LocalTime.now().format(DateTimeFormatter.ofPattern("hh:mm a")))
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(invoiceDetails);
            // Add line
            document.add(line);
            Table table = new Table(5);
            table.setWidth(UnitValue.createPercentValue(100));
            Cell cell1 = new Cell().add(new Paragraph("N° Ticket")).setBackgroundColor(ColorConstants.LIGHT_GRAY);
            Cell cell2 = new Cell().add(new Paragraph("Fecha de Venta")).setBackgroundColor(ColorConstants.LIGHT_GRAY);
            Cell cell3 = new Cell().add(new Paragraph("Tipo de Entrega")).setBackgroundColor(ColorConstants.LIGHT_GRAY);
            Cell cell4 = new Cell().add(new Paragraph("Modo de Pago")).setBackgroundColor(ColorConstants.LIGHT_GRAY);
            Cell cell5 = new Cell().add(new Paragraph("Total de pago")).setBackgroundColor(ColorConstants.LIGHT_GRAY);
            table.addCell(cell1);
            table.addCell(cell2);
            table.addCell(cell3);
            table.addCell(cell4);
            table.addCell(cell5);
            List<OrderDto> listOrdenClient = new OrderService().listOrderView(logged.getIdUsuario(), 4);
            double totalSum = 0;
            for (OrderDto listOrden : listOrdenClient) {
                // %06d: 6 dígitos, rellenar con ceros a la izquierda , % -> indica que se va a formatear un número ,0 -> indica que se rellenará con ceros, 6 -> indica la cantidad de dígitos, d -> indica que es un número
                String formattedIdTicket = String.format("%06d", listOrden.getIdTicket());
                table.addCell(formattedIdTicket);
                table.addCell(new SimpleDateFormat("dd/MM/yyyy").format(listOrden.getDate()));
                table.addCell(listOrden.getTypeDelivery());
                table.addCell(listOrden.getTypePay());
                table.addCell(NumberFormat.getCurrencyInstance(new Locale("es", "PE")).format(listOrden.getTotal()));
                totalSum += listOrden.getTotal();
            }
            document.add(table);

// Agregar el total al documento
            Paragraph total = new Paragraph("TOTAL: " + NumberFormat.getCurrencyInstance(new Locale("es", "PE")).format(totalSum))
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.RIGHT);
            document.add(total);
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

    private void generatePDFTicket(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int idTicket = Integer.parseInt(request.getParameter("idTicket"));
        OrderDto orderDtoTicket = new OrderService().listOrderByTicketClient(new OrderDto(idTicket));

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"Boleta N° Ticket: " + String.format("%06d", idTicket) + " (" + orderDtoTicket.getNames() + orderDtoTicket.getLastnames() + ").pdf\"");
        try {
            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc, new PageSize(226.77F, 425.196F)); // Tamaño tickt 80mm x 150 mm (largo aprox)
            document.setMargins(5f, 5f, 5f, 5f);


            Paragraph companyName = new Paragraph("Resturante: Lachancha.pe\n Boleta Generada \nN° Ticket: " + String.format("%06d", idTicket));
            companyName.setFontSize(10);
            companyName.setTextAlignment(TextAlignment.CENTER);
            document.add(companyName);

            // Add company details
            Paragraph companyDetails = new Paragraph("RUC: 07187656001\nDirección San Vicente de Cañete, Calle A\nTeléfono: 979333493\nEmail: contacto@Lachancha.pe");
            companyDetails.setFontSize(7);
            companyDetails.setTextAlignment(TextAlignment.CENTER);
            document.add(companyDetails);

            // Add line
            Paragraph line = new Paragraph("------------------------------------------------------");
            line.setTextAlignment(TextAlignment.CENTER);
            document.add(line);


            // Add Client details
            String typeDocument = orderDtoTicket.getTypeDocument().equals("DNI") ? "DNI: " : "CE: ";
            String deliveryAddress = orderDtoTicket.getAddressDelivery() != null ? orderDtoTicket.getAddressDelivery() : "en el restaurante";
            Paragraph invoiceDetails = new Paragraph("Cliente: " + orderDtoTicket.getNames() + " " + orderDtoTicket.getLastnames()
                    + "\n" + typeDocument + orderDtoTicket.getNumberDocument()
                    + "\nCorreo: " + orderDtoTicket.getEmail()
                    + "\nTeléfono: " + orderDtoTicket.getPhone()
                    + "\nTipo de Entrega: " + orderDtoTicket.getTypeDelivery()
                    + "\nDirección del Delivery: " + deliveryAddress
                    + "\nModo de Pago: " + orderDtoTicket.getTypePay()
                    + "\nRequerimiento Adicional: " + orderDtoTicket.getNote()
                    + "\nFecha pedido: " + new SimpleDateFormat("dd/MM/yyyy").format(orderDtoTicket.getDate()) + " " + new SimpleDateFormat("hh:mm a").format(orderDtoTicket.getDate()))
                    .setFontSize(7)
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(invoiceDetails);

            // Add table headers
            Table table = new Table(UnitValue.createPercentArray(new float[]{20, 5, 10}))
                    .setWidth(UnitValue.createPercentValue(100))
                    .setHorizontalAlignment(HorizontalAlignment.CENTER);

            Cell cell1 = new Cell().add(new Paragraph("Producto")).setBackgroundColor(ColorConstants.LIGHT_GRAY).setFontSize(7);
            Cell cell2 = new Cell().add(new Paragraph("Cantidad")).setBackgroundColor(ColorConstants.LIGHT_GRAY).setFontSize(7);
            Cell cell3 = new Cell().add(new Paragraph("Subtotal")).setBackgroundColor(ColorConstants.LIGHT_GRAY).setFontSize(7);

            table.addCell(cell1);
            table.addCell(cell2);
            table.addCell(cell3);

            // Calcular el subtotal
            double subtotal = 0;
            List<OrderDetailDto> listOrderProductDetail = new OrderService().listOrderProductDetail(idTicket);
            for (OrderDetailDto listDetail : listOrderProductDetail) {
                table.addCell(new Paragraph(listDetail.getNameProduct()).setFontSize(6));
                table.addCell(new Paragraph(String.valueOf(listDetail.getQuantity())).setFontSize(6));
                double productSubtotal = listDetail.getQuantity() * listDetail.getPrice();
                table.addCell(new Paragraph(NumberFormat.getCurrencyInstance(new Locale("es", "PE")).format(productSubtotal)).setFontSize(6));
                subtotal += productSubtotal;
            }
            document.add(table);

// Calcular el IGV
            double igv = subtotal * 0.18;

// Agregar el subtotal al documento
            Paragraph subtotalParagraph = new Paragraph("Subtotal: " + NumberFormat.getCurrencyInstance(new Locale("es", "PE")).format(subtotal))
                    .setFontSize(6) // Tamaño de fuente reducido
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(subtotalParagraph);

// Agregar el IGV al documento
            Paragraph igvParagraph = new Paragraph("IGV: " + NumberFormat.getCurrencyInstance(new Locale("es", "PE")).format(igv))
                    .setFontSize(6) // Tamaño de fuente reducido
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(igvParagraph);

// Agregar el total al documento
            Paragraph totalParagraph = new Paragraph("TOTAL A PAGAR " + NumberFormat.getCurrencyInstance(new Locale("es", "PE")).format(orderDtoTicket.getTotal()))
                    .setFontSize(6) // Tamaño de fuente reducido
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(totalParagraph);


            // Add line
            document.add(line);

            // Add terms and conditions
            Paragraph footer = new Paragraph("Este documento es una representación impresa de informes.\n Resturante Lachancha.pe\n Gracias por su preferencia.")
                    .setFontSize(5)
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(footer);

            document.close();
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void showOrderByStatus(HttpServletRequest request, HttpServletResponse response, int idStatus) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        List<OrderDto> listOrdeByStatus = new OrderService().listOrderView(logged.getIdUsuario(), idStatus);
        // Calcular la cantidad de pedidos por estado
        OrderService orderService = new OrderService();
        session.setAttribute("viewStatusOrderClient", idStatus);
        session.setAttribute("listOrdeByStatusClient", listOrdeByStatus);
        // Almacenar las cantidades en la sesión
        session.setAttribute("countOClientC", orderService.listOrderView(logged.getIdUsuario(), 4).size());
        session.setAttribute("countOClientP", orderService.listOrderView(logged.getIdUsuario(), 1).size());
        session.setAttribute("countOClientA", orderService.listOrderView(logged.getIdUsuario(), 2).size());
        session.setAttribute("countOClientR", orderService.listOrderView(logged.getIdUsuario(), 3).size());
        request.getRequestDispatcher("/WEB-INF/client/order/saleOrder.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        if (logged == null) {
            response.sendRedirect("/login");
            return;
        }
        if (!logged.isStatus()) {
            response.sendRedirect("/inactiveUser");
            return;
        }
        int orderStatus = request.getParameter("viewStatusOrderClient") != null ? Integer.parseInt(request.getParameter("viewStatusOrderClient")) : 4;
        if (orderStatus >= 1 && orderStatus <= 4) {
            session.setAttribute("viewStatusOrderClient", orderStatus);
            this.showOrderByStatus(request, response, orderStatus);
        } else {
            this.showOrderByStatus(request, response, 4);
        }
    }


}
