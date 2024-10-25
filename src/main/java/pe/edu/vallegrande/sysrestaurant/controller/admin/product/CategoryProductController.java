package pe.edu.vallegrande.sysrestaurant.controller.admin.product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;
import pe.edu.vallegrande.sysrestaurant.dto.product.CategoryProductDto;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.product.CategoryProductService;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

@WebServlet({"/admin/category", "/admin/category/"})
public class CategoryProductController extends HttpServlet {
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
        int viewStatus = sesion.getAttribute("categoryStatus") != null ? (int) sesion.getAttribute("categoryStatus") : 1;
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "edit":
                    this.editCategory(request, response);
                    break;
                case "delete":
                case "restore":
                    this.updateCategoryStatus(request, response, action);
                    break;
                default:
                    this.showDefaultCategory(request, response, viewStatus);
                    break;
            }
        } else {
            this.showDefaultCategory(request, response, viewStatus);
        }

    }
    private void showDefaultCategory(HttpServletRequest request, HttpServletResponse response, int idStatus) throws ServletException, IOException {
        HttpSession session = request.getSession();
        CategoryProductService categoryProductService = new CategoryProductService();
        List<CategoryProductDto> listCategory = categoryProductService.listCategoryAllByStatus(idStatus);
        session.setAttribute("typeCategorys", listCategory);
        session.setAttribute("categoryStatus", idStatus);
        session.setAttribute("countCategoryA",categoryProductService.listCategoryAllByStatus(1).size() );
        session.setAttribute("countCategoryI",categoryProductService.listCategoryAllByStatus(0).size() );
        request.getRequestDispatcher("/WEB-INF/admin/product/category.jsp").forward(request, response);
    }
    /*     For Category         */
    private void editCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idCategoria = Integer.parseInt(request.getParameter("idCategory"));
        CategoryProductDto categorias = new CategoryProductService().buscar(new CategoryProductDto(idCategoria));
        request.setAttribute("categoria", categorias);
        request.getRequestDispatcher("/WEB-INF/admin/templates/product/editCategory.jsp").forward(request, response);
    }

    private void updateCategoryStatus(HttpServletRequest request, HttpServletResponse response, String action) throws ServletException, IOException {
        int idCategoria = Integer.parseInt(request.getParameter("idCategory"));
        int status;
        String successMessage;
        String errorMessage;
        if(action.equals("delete")){
            status = 0;
            successMessage = "Categoría eliminada correctamente";
            errorMessage = "Error al eliminar la categoría";
        }else if (action.equals("restore")){
            status = 1;
            successMessage = "Categoría restaurada correctamente";
            errorMessage = "Error al restaurar la categoría";
        }else{
            throw new IllegalArgumentException("Acción no válida");
        }

        int update = new CategoryProductService().updateUserStatus(status, new CategoryProductDto(idCategoria));

        this.showDefaultCategory(request, response, status);
    }



    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException  {
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
                case "insert":
                    this.insertCategory(request, response);
                    break;
                case "modify":
                    this.modifyCategory(request, response);
                    break;
                case "insertMultiple":
                    this.insertMultipleCategories(request, response);
                    break;
                default:
                    this.showDefaultCategory(request, response,1);
                    break;
            }
        } else {
            String categoryStatusStr = request.getParameter("categoryStatus");
            int categoryStatus = categoryStatusStr != null ? Integer.parseInt(categoryStatusStr) : 1;
            this.showDefaultCategory(request, response, categoryStatus);
        }
    }

    /*     For Category         */
    private void modifyCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idCategory = Integer.parseInt(request.getParameter("idCategory"));
        String name = request.getParameter("name");
        int modificado = new CategoryProductService().actualizar(new CategoryProductDto(idCategory, name));
        response.sendRedirect("/admin/category");

    }
    protected void insertMultipleCategories(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idSheet = "1JR8enNuNv4E9Iv4ACuCKTFOvtlklIP1w5ZhE1FLC5i8";
        String urlString = "https://sheets.googleapis.com/v4/spreadsheets/"+idSheet+"/values/categorias?key=AIzaSyBWhxr8HL9SOQ7W3NEdBHZ28uhUSakYTi0";
        try {
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.connect();

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                throw new RuntimeException("HttpResponseCode: " + responseCode);
            } else {
                StringBuilder informationString = new StringBuilder();
                Scanner scanner = new Scanner(url.openStream());

                while (scanner.hasNext()) {
                    informationString.append(scanner.nextLine());
                }
                scanner.close();

                JSONObject obj = new JSONObject(informationString.toString());
                JSONArray categories = obj.getJSONArray("values");
                CategoryProductService service = new CategoryProductService();
                boolean allInserted = true;

                for (int i = 0; i < categories.length(); i++) {
                    JSONArray category = categories.getJSONArray(i);
                    String name = category.getString(0);
                    int insertResult = service.insertar(new CategoryProductDto(name));
                    if (insertResult != 1) {
                        allInserted = false;
                        break; // Sale del bucle si alguna inserción falla
                    }
                }

                if (allInserted) {
                    request.getSession().setAttribute("alert", "swal('¡Éxito!', 'Categorías registradas correctamente', 'success');");
                } else {
                    request.getSession().setAttribute("alert", "swal('¡Error!', 'Error al registrar algunas categorías', 'error');");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("alert", "swal('¡Error!', 'Error al registrar las categorías', 'error');");
        }
        response.sendRedirect("/admin/category");
    }
    private void insertCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        int insertCategory = new CategoryProductService().insertar(new CategoryProductDto(name));
        String alert;
        if (insertCategory == 1) {
            alert = "swal('¡Éxito!', 'Fue registrado correctamente', 'success');";
        } else {
            alert = "swal('¡Error!', 'Error al registrar', 'error');";
        }
        request.getSession().setAttribute("alert", alert);
        response.sendRedirect("/admin/category");
    }

}
