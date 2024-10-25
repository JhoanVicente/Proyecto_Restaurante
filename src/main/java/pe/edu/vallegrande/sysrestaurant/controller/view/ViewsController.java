package pe.edu.vallegrande.sysrestaurant.controller.view;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.edu.vallegrande.sysrestaurant.dto.product.CategoryProductDto;
import pe.edu.vallegrande.sysrestaurant.dto.product.ProductDto;
import pe.edu.vallegrande.sysrestaurant.service.product.CategoryProductService;
import pe.edu.vallegrande.sysrestaurant.service.product.ProductService;

import java.io.IOException;
import java.util.List;

@WebServlet({"/inicio", "/login", "/finishedOrder", "/detalle-producto", "/inactiveUser", "/catalogo", "/pagar"})
public class ViewsController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String views = request.getServletPath();
        HttpSession session = request.getSession();
        switch (views) {
            case "/inicio":
                this.showDefaultIndex(request, response);
                break;
            case "/login":
                request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
                break;
            case "/finishedOrder":
                if (session.getAttribute("TypePayP") != null) {
                    request.getRequestDispatcher("/WEB-INF/view/finishedOrder.jsp").forward(request, response);
                } else {
                    response.sendRedirect("/inicio");
                }
                break;
            case "/detalle-producto":
                this.showDetailProduct(request, response);
                break;
            case "/inactiveUser":
                request.getRequestDispatcher("/WEB-INF/view/inactiveUser.jsp").forward(request, response);
                break;
            case "/catalogo":
                this.showCatalog(request, response);
                break;
            default:
                request.getRequestDispatcher("/WEB-INF/view/index.jsp").forward(request, response);
                break;
        }
    }

    private void showDefaultIndex(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String searchProduct = request.getParameter("search");
        ProductService productService = new ProductService();
        List<ProductDto> listProductsByStatuses;
        if (searchProduct != null && !searchProduct.isEmpty()) {
            listProductsByStatuses = productService.searchProduct(searchProduct, 1);
        } else {
            listProductsByStatuses = productService.listProductTop8ByStatus(1);
        }

        List<CategoryProductDto> typeCategorys = new CategoryProductService().listCategoryAllByStatus(1);
        session.setAttribute("typeCategorys", typeCategorys);
        session.setAttribute("productsViews", listProductsByStatuses);
        request.getRequestDispatcher("/WEB-INF/view/index.jsp").forward(request, response);

    }

    private void showCatalog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String searchProduct = request.getParameter("search");
        ProductService productService = new ProductService();
        List<ProductDto> listProductsByStatuses;
        if (searchProduct != null && !searchProduct.isEmpty()) {
            listProductsByStatuses = productService.searchProduct(searchProduct, 1);
        } else {
            listProductsByStatuses = productService.listProductAllByStatus(1);
        }

        List<CategoryProductDto> typeCategorys = new CategoryProductService().listCategoryAllByStatus(1);
        session.setAttribute("typeCategorys", typeCategorys);
        session.setAttribute("productsViews", listProductsByStatuses);
        request.getRequestDispatcher("/WEB-INF/view/catalog.jsp").forward(request, response);
    }

    private void showDetailProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int idProduct = Integer.parseInt(request.getParameter("idProduct"));
        ProductDto productDto = new ProductService().ConsultProduct(idProduct);
        if (request.getParameter("idProduct") == null || productDto == null) {
            response.sendRedirect("/inicio");
            return;
        }
        List<CategoryProductDto> typeCategorys = new CategoryProductService().listCategoryAllByStatus(1);
        session.setAttribute("typeCategorys", typeCategorys);
        request.setAttribute("product", productDto);
        request.getRequestDispatcher("/WEB-INF/view/detailProduct.jsp").forward(request, response);

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }


}
