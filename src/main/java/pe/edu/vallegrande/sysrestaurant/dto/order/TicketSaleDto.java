package pe.edu.vallegrande.sysrestaurant.dto.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.sql.Timestamp;

@Data @NoArgsConstructor @ToString @AllArgsConstructor
public class TicketSaleDto {
    private int idTicket;
    private Timestamp date;
    private int idUser;
    private double totalPay;
    private boolean delivery;
    private String addressDelivery;
    private String note;
    private int idTypePay;
    private int idStatus;

    public TicketSaleDto(Timestamp date, int idUser, double totalPay, String addressDelivery, String note, int idTypePay) {
        this.date = date;
        this.idUser = idUser;
        this.totalPay = totalPay;
        this.addressDelivery = addressDelivery;
        this.note = note;
        this.idTypePay = idTypePay;
    }

    public TicketSaleDto(int idTicket, double totalPay, Timestamp date, boolean delivery) {
        this.idTicket = idTicket;
        this.totalPay = totalPay;
        this.date = date;
        this.delivery = delivery;
    }
}
