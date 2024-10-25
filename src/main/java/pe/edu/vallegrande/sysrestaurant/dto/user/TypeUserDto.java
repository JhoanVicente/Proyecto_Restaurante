package pe.edu.vallegrande.sysrestaurant.dto.user;

import lombok.*;

@Data @NoArgsConstructor @ToString
public class TypeUserDto {

    private int idTypeUser;
    private String nameUser;


    public TypeUserDto(int idTypeUser, String nameUser){
        this.idTypeUser = idTypeUser;
        this.nameUser = nameUser;
    }


}

