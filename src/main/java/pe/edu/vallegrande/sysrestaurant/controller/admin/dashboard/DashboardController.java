package pe.edu.vallegrande.sysrestaurant.controller.admin.dashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.dashboard.DashboardService;
import pe.edu.vallegrande.sysrestaurant.service.product.CategoryProductService;
import pe.edu.vallegrande.sysrestaurant.service.product.ProductService;
import pe.edu.vallegrande.sysrestaurant.service.user.UserService;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/admin/dashboard")
public class DashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException  {
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
                case "edit":
//                    this.editUser(request, response);
                    break;

                default:
                    this.showDefault(request, response);
                    break;
            }
        } else {
            this.showDefault(request, response);
        }

    }

    private void showDefault(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Instanciar DashboardService
        DashboardService dashboardService = new DashboardService();
        // Saber la fecha actual de la maquina
        // obtener la fecha actual de la maquina
        Date date = new Date(); // que esta aqui es Wed Jun 26 00:26:53 PET 2024
        SimpleDateFormat formatter = new SimpleDateFormat(("yyyy-MM-dd"));
        String strDate = formatter.format(date);

        session.setAttribute("sumTotalPayment", dashboardService.sumTotalPaymentByDay(strDate));
        session.setAttribute("countUsersActive", new UserService().listUserAllForStatus(1).size());
        session.setAttribute("countProductsActive", new ProductService().listProductAllByStatus(1).size());
        session.setAttribute("countCategoryActive", new CategoryProductService().listCategoryAllByStatus(1).size());
        session.setAttribute("listProductMaxSold", dashboardService.listProductAllMaxSold());
        session.setAttribute("listUserMaxOrder", dashboardService.listUserAllMaxOrder());
        session.setAttribute("recentUsersByClient", dashboardService.listUserAllRecent(3));
        session.setAttribute("recentUsersByAdmin", dashboardService.listUserAllRecent(1));
        session.setAttribute("recentUsersByWaiters", dashboardService.listUserAllRecent(2));

        request.getRequestDispatcher("/WEB-INF/admin/dashboard/dashboard.jsp").forward(request, response);
    }






}
