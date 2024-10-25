package pe.edu.vallegrande.sysrestaurant.dto.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data @AllArgsConstructor @NoArgsConstructor @ToString
public class OrderDetailDto {
    private int idOrderDetail;
    private int idTicket;
    private  String nameProduct;
    private int quantity;
    private double price;

    public OrderDetailDto(String nameProduct, int quantity, double price) {
        this.nameProduct = nameProduct;
        this.quantity = quantity;
        this.price = price;
    }
}
