package pe.edu.vallegrande.sysrestaurant.dto.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@ToString
@AllArgsConstructor
public class OrderDto {

    private int idTicket;
    private double total;
    private Timestamp date;
    private String typeDelivery; // es tipo string porque solo devuelve el nombre del tipo de entrega
    private String typePay; // es tipo string porque solo devuelve el nombre del tipo de pago
    private String statusOrder; // es tipo string porque solo devuelve el nombre del estado
    private String names;
    private String lastnames;
  // Detalles
    private String email;
    private String phone;
    private String numberDocument;
    private String typeDocument;
    // detalles del Ticket
    private String addressDelivery;
    private String note;
    private int idStatusOrder;
    //Id de Usuario
    private int idUser;


    public OrderDto(int idTicket, double total, Timestamp date, String typeDelivery, String typePay, String statusOrder, String names, String lastnames) {
        this.idTicket = idTicket;
        this.total = total;
        this.date = date;
        this.typeDelivery = typeDelivery;
        this.typePay = typePay;
        this.statusOrder = statusOrder;
        this.names = names;
        this.lastnames = lastnames;
    }

    public OrderDto(int idTicket, double total, Timestamp date, String typeDelivery, String typePay, String statusOrder, String names, String lastnames, String email, String phone, String numberDocument, String typeDocument, String addressDelivery, String note) {
        this.idTicket = idTicket;
        this.total = total;
        this.date = date;
        this.typeDelivery = typeDelivery;
        this.typePay = typePay;
        this.statusOrder = statusOrder;
        this.names = names;
        this.lastnames = lastnames;
        this.email = email;
        this.phone = phone;
        this.numberDocument = numberDocument;
        this.typeDocument = typeDocument;
        this.addressDelivery = addressDelivery;
        this.note = note;
    }

    public OrderDto(int idTicket, double total, Timestamp date, String typeDelivery, String typePay, String statusOrder, String names, String lastnames, String email, String phone, String numberDocument, String typeDocument, String addressDelivery, String note, int idUser) {
        this.idTicket = idTicket;
        this.total = total;
        this.date = date;
        this.typeDelivery = typeDelivery;
        this.typePay = typePay;
        this.statusOrder = statusOrder;
        this.names = names;
        this.lastnames = lastnames;
        this.email = email;
        this.phone = phone;
        this.numberDocument = numberDocument;
        this.typeDocument = typeDocument;
        this.addressDelivery = addressDelivery;
        this.note = note;
        this.idUser = idUser;
    }

    public OrderDto(int idTicket) {
        this.idTicket = idTicket;
    }

    public OrderDto(int idTicket, double total, Timestamp date, String typeDelivery, String typePay, String names, String lastnames, int idStatusOrder) {
        this.idTicket = idTicket;
        this.total = total;
        this.date = date;
        this.typeDelivery = typeDelivery;
        this.typePay = typePay;
        this.names = names;
        this.lastnames = lastnames;
        this.idStatusOrder = idStatusOrder;
    }

}
