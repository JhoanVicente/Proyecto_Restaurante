package pe.edu.vallegrande.sysrestaurant.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class UserRecentDto {
    private String nameUser;
    private String lastnames;
}
