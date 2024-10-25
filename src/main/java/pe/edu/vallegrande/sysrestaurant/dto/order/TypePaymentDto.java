package pe.edu.vallegrande.sysrestaurant.dto.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@ToString
@AllArgsConstructor
public class TypePaymentDto {

        private int idTypePayment;
        private String name;

    public TypePaymentDto(String name) {
        this.name = name;
    }
}
