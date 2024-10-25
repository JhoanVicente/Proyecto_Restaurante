package pe.edu.vallegrande.sysrestaurant.test;

import pe.edu.vallegrande.sysrestaurant.dto.order.OrderDto;
import pe.edu.vallegrande.sysrestaurant.service.sale.OrderService;

import java.util.List;

public class test01 {
    public static void main(String[] args) {
//        List<ReservationDto> listReservation = new ReservationService().listReservationByClientStatus(1,1);
//        for (ReservationDto order : listReservation) {
//            System.out.println(order);
//        }

//        ReservationDto reservation = new ReservationService().listReservationById(new ReservationDto(2));
//        System.out.println(reservation);
        List<OrderDto> listOrderDto = new OrderService().listOrderAllByStatus(1);
        for (OrderDto orderDto : listOrderDto) {
            System.out.println(orderDto);
        }
    }
}
