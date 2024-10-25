package pe.edu.vallegrande.sysrestaurant.dto.user;

import lombok.*;
import java.util.Date;

@Data @NoArgsConstructor @ToString
public class UserDto {
    private int idUsuario;
    private String username;
    private String password;
    private String names;
    private String lastnames;
    private Date date_birth;
    private String address;
    private String phone;
    private String email;
    private String numberIdentity;
    private String typeDocument;
    private int typeUser;
    private boolean status;
    private boolean emailVerified;
    public UserDto(int idUsuario) {
        this.idUsuario = idUsuario;
    }

     // for list all users and yes login true
    public UserDto(int idUsuario, String username, String names, String lastnames, String phone, String email, String numberIdentity, String typeDocument, int typeUser, boolean status, boolean emailVerified) {
        this.idUsuario = idUsuario;
        this.username = username;
        this.names = names;
        this.lastnames = lastnames;
        this.phone = phone;
        this.email = email;
        this.numberIdentity = numberIdentity;
        this.typeDocument = typeDocument;
        this.typeUser = typeUser;
        this.status = status;
        this.emailVerified = emailVerified;
    }

    // Constructor for Register
    public UserDto(String username, String password, String names, String lastnames, Date date_birth, String address, String phone, String email, String numberIdentity, String typeDocument, int typeUser) {
        this.username = username;
        this.password = password;
        this.names = names;
        this.lastnames = lastnames;
        this.date_birth = date_birth;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.numberIdentity = numberIdentity;
        this.typeDocument = typeDocument;
        this.typeUser = typeUser;
    }

    public UserDto(int idUsuario, String username, String password, String names, String lastnames, Date date_birth, String address, String phone, String email, String numberIdentity, String typeDocument, int typeUser, boolean status) {
        this.idUsuario = idUsuario;
        this.username = username;
        this.password = password;
        this.names = names;
        this.lastnames = lastnames;
        this.date_birth = date_birth;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.numberIdentity = numberIdentity;
        this.typeDocument = typeDocument;
        this.typeUser = typeUser;
        this.status = status;
    }

    // Constructor for login
    public UserDto(String username, String password) {
        this.username = username;
        this.password = password;
    }

    // Constructor for Update
    public UserDto(int idUsuario, String username, String password, String names, String lastnames, Date date_birth, String address, String phone, String email, String numberIdentity, String typeDocument, int typeUser) {
        this.idUsuario = idUsuario;
        this.username = username;
        this.password = password;
        this.names = names;
        this.lastnames = lastnames;
        this.date_birth = date_birth;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.numberIdentity = numberIdentity;
        this.typeDocument = typeDocument;
        this.typeUser = typeUser;
    }

    public UserDto(String username, String lastnames, String names) {
        this.username = username;
        this.names = names;
        this.lastnames = lastnames;
    }


}
