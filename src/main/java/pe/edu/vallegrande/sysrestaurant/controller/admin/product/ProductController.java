package pe.edu.vallegrande.sysrestaurant.controller.admin.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import pe.edu.vallegrande.sysrestaurant.dto.product.CategoryProductDto;
import pe.edu.vallegrande.sysrestaurant.dto.product.ProductDto;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.product.CategoryProductService;
import pe.edu.vallegrande.sysrestaurant.service.product.ProductService;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

@WebServlet("/admin/product")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 5,   // 5 MB
        maxRequestSize = 1024 * 1024 * 10) // 10 MB
public class ProductController extends HttpServlet {

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
        int viewStatus = sesion.getAttribute("productStatus") != null ? (int) sesion.getAttribute("productStatus") : 1;
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "edit":
                    this.showDetailProduct(request, response);
                    break;
                case "delete":
                case "restore":
                    this.updateProductStatus(request, response, action);
                    break;
                default:
                    this.showDefaultProduct(request, response, viewStatus);
                    break;
            }
        } else {
            this.showDefaultProduct(request, response, viewStatus);
        }

    }

    /*     For ProductDto         */
    private void showDefaultProduct(HttpServletRequest request, HttpServletResponse response, int idStatus) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String searchProduct= request.getParameter("search");
        ProductService productService = new ProductService();
        List<ProductDto> listProductsByStatuses;
        if(searchProduct != null && !searchProduct.isEmpty()){
            listProductsByStatuses = productService.searchProduct(searchProduct, idStatus);
        }else{
            listProductsByStatuses = productService.listProductAllByStatus(idStatus);
        }
        List<CategoryProductDto> typeCategorys = new CategoryProductService().listCategoryAllByStatus(1);

        session.setAttribute("productStatus", idStatus);
        session.setAttribute("typeCategorys", typeCategorys);
        session.setAttribute("products", listProductsByStatuses);
        session.setAttribute("countProductsA", productService.listProductAllByStatus(1).size());
        session.setAttribute("countProductsI", productService.listProductAllByStatus(0).size());

        request.getRequestDispatcher("/WEB-INF/admin/product/product.jsp").forward(request, response);
    }
    private void showDetailProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idProducto = Integer.parseInt(request.getParameter("idProduct"));
        ProductDto productDto = new ProductService().buscar(new ProductDto(idProducto));
        request.setAttribute("producto", productDto);
        request.getRequestDispatcher("/WEB-INF/admin/templates/product/editProduct.jsp").forward(request, response);
    }
    private void updateProductStatus(HttpServletRequest request, HttpServletResponse response, String action) throws ServletException, IOException {
        int idProducto = Integer.parseInt(request.getParameter("idProduct"));
        int status;
        String successMessage;
        String errorMessage;
        if (action.equals("delete")) {
            status = 0;
            successMessage = "Producto eliminado correctamente";
            errorMessage = "Error al eliminar el producto";
        } else if (action.equals("restore")) {
            status = 1;
            successMessage = "Producto restaurado correctamente";
            errorMessage = "Error al restaurar el producto";
        } else {
            throw new IllegalArgumentException("Acción no válida");
        }

        int updated = new ProductService().updateUserStatus(status, new ProductDto(idProducto));
        String alert;
        if (updated == 1) {
            alert = "swal('¡Éxito!', '" + successMessage + "', 'success');";
        } else {
            alert = "swal('¡Error!', '" + errorMessage + "', 'error');";
        }
        request.setAttribute("alert", alert);
        this.showDefaultProduct(request, response, status);
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
                    this.modifyProduct(request, response);
                    break;
                case "insert":
                    this.insertProduct(request, response);
                    break;
                default:
                    this.showDefaultProduct(request, response, 1);
                    break;
            }
        } else {
            String productStatusStr = request.getParameter("productStatus");
            int productStatus = productStatusStr != null ? Integer.parseInt(productStatusStr) : 1;
            this.showDefaultProduct(request, response, productStatus);
        }
    }

    /*     For ProductDto         */
    private void modifyProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int idProducto = Integer.parseInt(request.getParameter("idProduct"));
        int idCategory = Integer.parseInt(request.getParameter("idCategory"));
        String name = request.getParameter("name");
        String note = request.getParameter("note");
        double price = Double.parseDouble(request.getParameter("price"));
        Part filePart = request.getPart("image"); // Obtiene el input de tipo file
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // Obtiene el nombre del archivo
        String image;
        // Verifica si el input de tipo file contiene un nuevo archivo
        if (fileName != null && !fileName.isEmpty()) {
            // Si contiene un nuevo archivo, reemplaza la imagen actual con el nuevo archivo
            image = subirImagen(request);
        } else {
            // Si no contiene un nuevo archivo, mantiene la imagen actual
            image = request.getParameter("currentImage");
        }
        ProductDto productDto = new ProductDto(idProducto, idCategory, image, name, note, price);
        int registrosModificados = new ProductService().actualizar(productDto);
        String alert;
        if (registrosModificados == 1) {
            alert = "swal('¡Éxito!', 'Fue modificado correctamente', 'success');";
        } else {
            alert = "swal('¡Error!', 'Error al modificar', 'error');";
        }
        session.setAttribute("alert", alert);
        response.sendRedirect("/admin/product");
    }
    private void insertProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idCategory = Integer.parseInt(request.getParameter("idCategory"));
        String image = subirImagen(request);
        String name = request.getParameter("name");
        String note = request.getParameter("note");
        double price = Double.parseDouble(request.getParameter("price"));
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        int idUser = logged.getIdUsuario();
        Timestamp datep = new Timestamp(new Date().getTime());
        int registrosModificados = new ProductService().insertar(new ProductDto(idCategory, image, name, note, price, datep, idUser));
        String alert;
        if (registrosModificados == 1) {
            alert = "swal('¡Éxito!', 'Fue registrado correctamente', 'success');";
        } else {
            alert = "swal('¡Error!', 'Error al registrar', 'error');";
        }
        session.setAttribute("alert", alert);
        response.sendRedirect("/admin/product");
    }
    private String subirImagen(HttpServletRequest request) {
        try {
            // Obtener la ruta base del contexto de la aplicación
            String baseDir = getServletContext().getRealPath("/");
            SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyyhhmmss");
            String fecha = sdf.format(new Date());
            Random random = new Random();
            long randomNumber = random.nextLong();
            // Generar la ruta para la carpeta "foto" en el contexto de la aplicación
            Part filePart = request.getPart("image");
            // If filePart is null or empty, return null
            if (filePart == null || filePart.getSize() == 0) {
                return "default.jpg";
            }

            String contentType = filePart.getContentType();

            if (contentType != null && contentType.contains("image")) { // Verificar si el contenido es una imagen
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String rutaFoto = baseDir + "foto\\" + fecha + randomNumber + fileName;
                System.out.println(rutaFoto);
                // Guardar una copia en la ruta obtenida mediante getServletContext().getRealPath("/")
                try (InputStream inputStream = filePart.getInputStream()) {
                    Files.copy(inputStream, Paths.get(rutaFoto));
                }
                // Guardar una copia en la ruta especificada -- de manera local
                String copiaimg = "C:\\Users\\Matichelo\\Documents\\jakartaEE-appweb-restaurant\\src\\main\\webapp\\foto\\";
                String rutaCopia = copiaimg + fecha + randomNumber + fileName;
                try (InputStream inputStream = filePart.getInputStream()) {
                    Files.copy(inputStream, Paths.get(rutaCopia));
                }
                request.setAttribute("subida", true);
                String contextPath = fecha + randomNumber + fileName;
                return contextPath;
            } else {
                request.setAttribute("subida", false);
            }
        } catch (IOException | ServletException e) {
            request.setAttribute("subida", false);
        }
        return "";
    }

}
