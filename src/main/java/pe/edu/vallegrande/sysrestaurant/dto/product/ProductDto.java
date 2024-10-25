package pe.edu.vallegrande.sysrestaurant.dto.product;

import lombok.*;

import java.sql.Timestamp;

@Data @NoArgsConstructor @ToString
public class ProductDto {
    private int idProducto;
    private int idCategory;
    private String image;
    private String name;
    private String note;
    private double price;
    private Timestamp datep;
    private int idUser;
    private boolean status;

    public ProductDto(int idProducto) {
        this.idProducto = idProducto;
    }

    public ProductDto(int idCategory, String image, String name, String note, double price, Timestamp datep, int idUser, boolean status) {
        this.idCategory = idCategory;
        this.image = image;
        this.name = name;
        this.note = note;
        this.price = price;
        this.datep = datep;
        this.idUser = idUser;
        this.status = status;
    }


    public ProductDto(int idCategory, String image, String name, String note, double price, Timestamp datep, int idUser) {
        this.idCategory = idCategory;
        this.image = image;
        this.name = name;
        this.note = note;
        this.price = price;
        this.datep = datep;
        this.idUser = idUser;
        this.status = status;
    }

    public ProductDto(int idProducto, int idCategory, String image, String name, String note, double price, Timestamp datep, int idUser, boolean status) {
        this.idProducto = idProducto;
        this.idCategory = idCategory;
        this.image = image;
        this.name = name;
        this.note = note;
        this.price = price;
        this.datep = datep;
        this.idUser = idUser;
        this.status = status;
    }

    public ProductDto(int idProducto, int idCategory, String image, String name, String note, double price, boolean status) {
        this.idProducto = idProducto;
        this.idCategory = idCategory;
        this.image = image;
        this.name = name;
        this.note = note;
        this.price = price;
        this.status = status;
    }

    public ProductDto(int idProducto, int idCategory, String image, String name, String note, double price) {
        this.idProducto = idProducto;
        this.idCategory = idCategory;
        this.image = image;
        this.name = name;
        this.note = note;
        this.price = price;
    }



}
