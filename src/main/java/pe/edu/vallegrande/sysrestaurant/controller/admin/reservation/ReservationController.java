package pe.edu.vallegrande.sysrestaurant.controller.admin.reservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.edu.vallegrande.sysrestaurant.dto.reservation.ReservationDto;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.reservation.ReservationService;
import pe.edu.vallegrande.sysrestaurant.service.sale.StatusOrderService;
import pe.edu.vallegrande.sysrestaurant.service.user.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reservation")
public class ReservationController extends HttpServlet {
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
        int viewStatus = sesion.getAttribute("reservationStatus") != null ? (int) sesion.getAttribute("reservationStatus") : 4;

        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "status":
                    this.updateStatusOrder(request, response);
                    break;
                case "detail":
                    this.showDetailReservation(request, response);
                    break;
                default:
                    this.showReservationByStatus(request, response, viewStatus);
                    break;
            }
        } else {
            this.showReservationByStatus(request, response, viewStatus);
        }
    }

    private void updateStatusOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idReservation = Integer.parseInt(request.getParameter("idReservation"));
        int idStatusOrder = Integer.parseInt(request.getParameter("idStatusOrder"));
        int updatedOrder = new ReservationService().updateStatusOrder(idStatusOrder, new ReservationDto(idReservation));
        String alert;
        if (updatedOrder > 0) {
            alert = "swal('Estado de la Reserva Cambiado', 'Su estado de la Reserva fue cambiado correctamente ', 'success');";
        } else {
            alert = "swal('¡Error!', 'Error al cambiar de estado, vuelva a intentarlo', 'error');";
        }
        request.getSession().setAttribute("alert", alert);
        this.showReservationByStatus(request, response, idStatusOrder);
    }

    private void showDetailReservation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idReservation = Integer.parseInt(request.getParameter("idReservation"));
        ReservationDto reservationDtoDetail = new ReservationService().listReservationById(new ReservationDto(idReservation));
        UserDto userDto = new UserService().searchUser(new UserDto(reservationDtoDetail.getIdUser()));
        request.setAttribute("reservationDetail", reservationDtoDetail);
        request.setAttribute("user", userDto);
        request.getRequestDispatcher("/WEB-INF/templates/reservation/reservationDetail.jsp").forward(request, response);
    }

    private void showReservationByStatus(HttpServletRequest request, HttpServletResponse response, int idStatus) throws ServletException, IOException {
        HttpSession session = request.getSession();
        ReservationService reservationService = new ReservationService();
        List<ReservationDto> listReservationDtoAllByStatuses = reservationService.listReservationAllByStatus(idStatus);
        session.setAttribute("reservationStatus", idStatus);
        // Para mostrar el estado de los pedidos y poder cambiar su estado
        session.setAttribute("typeStatus",  new StatusOrderService().listStatusOrder());
        session.setAttribute("listReservationByStatus", listReservationDtoAllByStatuses);
        session.setAttribute("countReservationC", reservationService.listReservationAllByStatus(4).size());
        session.setAttribute("countReservationP", reservationService.listReservationAllByStatus(1).size());
        session.setAttribute("countReservationA", reservationService.listReservationAllByStatus(2).size());
        session.setAttribute("countReservationR", reservationService.listReservationAllByStatus(3).size());
        request.getRequestDispatcher("/WEB-INF/admin/reservation/reservation.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        if (logged == null || (logged.getTypeUser() != 1 && logged.getTypeUser() != 2)) {
            response.sendRedirect("/login");
            return;
        }
        if (!logged.isStatus()) {
            response.sendRedirect("/inactiveUser");
            return;
        }
        int viewStatus = request.getParameter("reservationStatus") != null ? Integer.parseInt(request.getParameter("reservationStatus")) : 4;

        if (viewStatus >= 1 && viewStatus <= 4) {
            session.setAttribute("reservationStatus", viewStatus);
            this.showReservationByStatus(request, response, viewStatus);
        } else {
            this.showReservationByStatus(request, response, 4);
        }
    }

}
