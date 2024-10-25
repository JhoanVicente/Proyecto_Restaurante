package pe.edu.vallegrande.sysrestaurant.dto.reservation;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.sql.Timestamp;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class ReservationDto {
    private int idClientReservation;
    private int idUser;
    private String nameClient;
    private Timestamp date;
    private int quantityPeople;
    private String note;
    private int status;
    private String statusStr;

    public ReservationDto(int idClientReservation) {
        this.idClientReservation = idClientReservation;
    }

    public ReservationDto(int idClientReservation, int idUser, String nameClient, Timestamp date, int quantityPeople, String note, int status) {
        this.idClientReservation = idClientReservation;
        this.idUser = idUser;
        this.nameClient = nameClient;
        this.date = date;
        this.quantityPeople = quantityPeople;
        this.note = note;
        this.status = status;
    }

    public ReservationDto(int idUser, String name, Timestamp date, int quantityPeople, String note, int status) {
        this.idUser = idUser;
        this.nameClient = name;
        this.date = date;
        this.quantityPeople = quantityPeople;
        this.note = note;
        this.status = status;
    }


}
