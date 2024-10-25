package pe.edu.vallegrande.sysrestaurant.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class UserMaxOrderDto {
    private String nameUser;
    private int totalCompletedOrders;
}
