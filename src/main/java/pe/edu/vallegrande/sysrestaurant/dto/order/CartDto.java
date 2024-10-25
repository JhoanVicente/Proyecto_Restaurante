package pe.edu.vallegrande.sysrestaurant.dto.order;

import lombok.*;
import pe.edu.vallegrande.sysrestaurant.dto.product.ProductDto;

@Data @NoArgsConstructor @ToString @AllArgsConstructor
public class CartDto {
//    El modelo que estás describiendo se llama "Composición
    private ProductDto productDto;
    private int quantity;
}
