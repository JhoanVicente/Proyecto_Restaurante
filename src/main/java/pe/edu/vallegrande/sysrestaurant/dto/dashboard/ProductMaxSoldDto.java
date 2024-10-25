package pe.edu.vallegrande.sysrestaurant.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ProductMaxSoldDto {
    private String nameProduct;
    private int totalSold;

}
