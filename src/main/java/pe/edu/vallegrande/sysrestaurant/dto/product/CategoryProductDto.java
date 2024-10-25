package pe.edu.vallegrande.sysrestaurant.dto.product;


import lombok.*;

@Data
@NoArgsConstructor
@ToString
public class CategoryProductDto {
    private int idCategoryProducto;
    private String name;
    private boolean status;

    public CategoryProductDto(int idCategoryProducto, String name) {
        this.idCategoryProducto = idCategoryProducto;
        this.name = name;
    }

    public CategoryProductDto(int idCategoryProducto, String name, boolean status) {
        this.idCategoryProducto = idCategoryProducto;
        this.name = name;
        this.status = status;
    }

    public CategoryProductDto(String name) {
        this.name = name;
    }

    public CategoryProductDto(int idCategoryProducto) {
        this.idCategoryProducto = idCategoryProducto;
    }

}
