package pe.edu.vallegrande.sysrestaurant.dto.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data @NoArgsConstructor @ToString @AllArgsConstructor
public class StatusOrderDto {

    private int idStatusOrder;
    private String name;

    public StatusOrderDto(String name) {
        this.name = name;
    }
}
