package pe.edu.vallegrande.sysrestaurant.controller.client.reservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.edu.vallegrande.sysrestaurant.dto.reservation.ReservationDto;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.reservation.ReservationService;
import pe.edu.vallegrande.sysrestaurant.service.user.UserService;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet({"/client/reservation", "/client/reservation/"})
public class ReservationClientController extends HttpServlet {
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
        int reservationStatus = session.getAttribute("viewStatusReservationClient") != null ? (int) session.getAttribute("viewStatusReservationClient") : 4;
        if (action != null) {
            switch (action) {
                case "detail":
                    this.showDetailReservation(request, response);
                    break;
                default:
                    this.showDefaultReservations(request, response, reservationStatus);
                    break;
            }
        } else {
            this.showDefaultReservations(request, response, reservationStatus);
        }
    }


    private void showDetailReservation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        int idReservation = Integer.parseInt(request.getParameter("idReservation"));
        ReservationDto reservationDtoDetail = new ReservationService().listReservationById(new ReservationDto(idReservation));
        UserDto userDto = new UserService().searchUser(new UserDto(reservationDtoDetail.getIdUser()));
        if (reservationDtoDetail.getIdUser() != logged.getIdUsuario()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "No tienes permiso para ver este ticket");
            return;
        }
        request.setAttribute("reservationDetail", reservationDtoDetail);
        request.setAttribute("user", userDto);
        request.getRequestDispatcher("/WEB-INF/templates/reservation/reservationDetail.jsp").forward(request, response);
    }

    private void showDefaultReservations(HttpServletRequest request, HttpServletResponse response, int idStatus) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        ReservationService reservationService = new ReservationService();
        List<ReservationDto> listReservationDto = reservationService.listReservationByClientStatus(logged.getIdUsuario(), idStatus);
        session.setAttribute("viewStatusReservationClient", idStatus);
        session.setAttribute("listReservation", listReservationDto);
        session.setAttribute("countRClientC", reservationService.listReservationByClientStatus(logged.getIdUsuario(), 4).size());
        session.setAttribute("countRClientP", reservationService.listReservationByClientStatus(logged.getIdUsuario(), 1).size());
        session.setAttribute("countRClientA", reservationService.listReservationByClientStatus(logged.getIdUsuario(), 2).size());
        session.setAttribute("countRClientR", reservationService.listReservationByClientStatus(logged.getIdUsuario(), 3).size());
        request.getRequestDispatcher("/WEB-INF/client/reservation/reservas.jsp").forward(request, response);

    }

    @Override
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

        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "add":
                    this.addReservation(request, response);
                    return; // Ensure no further processing
                default:
                    this.showDefaultReservations(request, response, 1);
                    return; // Ensure no further processing
            }
        }
        int reservationStatus = request.getParameter("viewStatusReservationClient") != null ? Integer.parseInt(request.getParameter("viewStatusReservationClient")) : 4;
        if (reservationStatus >= 1 && reservationStatus <= 4) {
            session.setAttribute("viewStatusReservationClient", reservationStatus);
            this.showDefaultReservations(request, response, reservationStatus);
        } else {
            this.showDefaultReservations(request, response, 4);
        }
    }



    public void addReservation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto logged = (UserDto) session.getAttribute("logged");
        String name = request.getParameter("nameClient");
        String note = request.getParameter("noteReservation");
        String dateTimeString = request.getParameter("dateReservation");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        LocalDateTime localDateTime = LocalDateTime.parse(dateTimeString, formatter);
        Timestamp datetime = Timestamp.valueOf(localDateTime);
        int quantity = Integer.parseInt(request.getParameter("quantityPerson"));
        int idUser = logged.getIdUsuario();
        int insertUpdate = new ReservationService().insertReservation(new ReservationDto(idUser, name, datetime, quantity, note, 1));
        String alert;
        if (insertUpdate > 0) {
            alert = "swal('Reserva Realizada', 'Su reserva fue realizada correctamente ', 'success');";
        } else {
            alert = "swal('¡Error!', 'Error al realizar la reserva, vuelva a intentarlo', 'error');";
        }
        session.setAttribute("alert", alert);
        response.sendRedirect(request.getContextPath() + "/client/reservation");
        return; // Ensure no further processing
    }


}
