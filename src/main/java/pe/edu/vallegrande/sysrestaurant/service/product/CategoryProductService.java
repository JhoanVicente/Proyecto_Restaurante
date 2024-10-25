package pe.edu.vallegrande.sysrestaurant.service.product;
import pe.edu.vallegrande.sysrestaurant.db.AccessDB;
import pe.edu.vallegrande.sysrestaurant.dto.product.CategoryProductDto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryProductService {
    //Las sentencias Sql  // mejorar la base de datos de category para que tenga eliminado lógico y entre otras cosas
    private static final String JDBC_SELECT = "SELECT id_category, name, status FROM product.category";
    private static final String JDBC_SELECT_BY_STATUS = "SELECT id_category, name, status FROM product.category WHERE status = ?";
    private static final  String JDBC_INSERT = "INSERT INTO product.category (name) VALUES (?)";
    private  static  final  String JDBC_UPDATE_STATUS = "UPDATE product.category SET status = ? WHERE id_category = ?";
    private static final String JDBC_SELECT_ID = "SELECT id_category, name, status FROM product.category WHERE id_category = ?";
    private static  final  String JDBC_UPDATE = "UPDATE product.category SET name = ? WHERE id_category = ?";

    public List<CategoryProductDto> listCategoryAll() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        CategoryProductDto tipoCategoria = null;
        List<CategoryProductDto> tipoCategorias = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT);
            rs = stmt.executeQuery();
            while (rs.next()) {
                int idTypeUser = rs.getInt(1);
                String nameType = rs.getString(2);
                boolean status = rs.getBoolean(3);
                tipoCategoria = new CategoryProductDto(idTypeUser, nameType, status);
                tipoCategorias.add(tipoCategoria);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
            AccessDB.close(rs);
        }

        return tipoCategorias;
    }

    public List<CategoryProductDto> listCategoryAllByStatus(int idstatus) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        CategoryProductDto tipoCategoria = null;
        List<CategoryProductDto> tipoCategorias = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT_BY_STATUS);
            stmt.setInt(1, idstatus);
            rs = stmt.executeQuery();
            while (rs.next()) {
                int idTypeUser = rs.getInt(1);
                String nameType = rs.getString(2);
                boolean status = rs.getBoolean(3);
                tipoCategoria = new CategoryProductDto(idTypeUser, nameType, status);
                tipoCategorias.add(tipoCategoria);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
            AccessDB.close(rs);
        }

        return tipoCategorias;
    }

    public int insertar(CategoryProductDto categoryProductDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        int row = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_INSERT);
            stmt.setString(1, categoryProductDto.getName());
            row = stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return row;
    }

    public int updateUserStatus(int status, CategoryProductDto categoryProductDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        int row = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_UPDATE_STATUS);
            stmt.setInt(1, status);
            stmt.setInt(2, categoryProductDto.getIdCategoryProducto());
            row = stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(stmt);
            AccessDB.close(conn);
        }
        return row;
    }

    public CategoryProductDto buscar(CategoryProductDto categoryProductDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT_ID);
            stmt.setInt(1, categoryProductDto.getIdCategoryProducto());
            rs = stmt.executeQuery();

            if (rs.next()) {
                String name = rs.getString("name");
                categoryProductDto.setName(name);
            } else {
                // Manejar el caso cuando no se encuentra ningún cliente con el id proporcionado
                categoryProductDto = null; // O lógica adicional según el caso
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            // Cerrar recursos en el bloque finally
            AccessDB.close(conn);
            AccessDB.close(stmt);
            AccessDB.close(rs);
        }
        return categoryProductDto;
    }
    public int actualizar(CategoryProductDto categoryProductDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        int row = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_UPDATE);
            stmt.setString(1, categoryProductDto.getName());
            stmt.setInt(2, categoryProductDto.getIdCategoryProducto());


            row = stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return row;
    }














}

