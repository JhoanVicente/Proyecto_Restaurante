package pe.edu.vallegrande.sysrestaurant.service.product;

import pe.edu.vallegrande.sysrestaurant.db.AccessDB;
import pe.edu.vallegrande.sysrestaurant.dto.order.CartDto;
import pe.edu.vallegrande.sysrestaurant.dto.product.ProductDto;
import pe.edu.vallegrande.sysrestaurant.dto.order.TicketSaleDto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductService {
    private static final String JDBC_SELECT = "SELECT id_product, id_category, image, name, note, price, date_p, id_user, status FROM product.product WHERE status = ?";
    private static final String JDBC_SELECT_TOP8 = "SELECT TOP 8 id_product, id_category, image, name, note, price, date_p, id_user, status FROM product.product WHERE status = ? ORDER BY id_product DESC";
    private static final String JDBC_SELECT_BY_ID = "SELECT id_product, id_category, image, name, note, price, date_p, id_user, status FROM product.product WHERE id_product = ?";
    private static final String JDBC_INSERT = "INSERT INTO product.product (id_category, image, name, note, price, date_p, id_user) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String JDBC_UPDATE = "UPDATE product.product SET id_category = ?, image = ?, name = ?, note = ?, price = ? WHERE id_product = ?";
    private static final String JDBC_UPDATE_STATUS= "UPDATE product.product SET status = ? WHERE id_product = ?";

    private static final String JDBC_CONSULT_PRODUCT = "SELECT * FROM product.product p INNER JOIN product.category c ON  c.id_category = p.id_category WHERE p.[status] = 1  AND c.[status] = 1 AND p.id_product = ?";

    public List<ProductDto> searchProduct(String query, int idstatus) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ProductDto> productDtos = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            String[] words = query.split("\\s+");
            String sql = "SELECT p.id_product, p.id_category, p.image, p.name, p.note, p.price, p.date_p, p.id_user, p.status "
                    + "FROM product.product p "
                    + "JOIN product.category c ON p.id_category = c.id_category "
                    + "WHERE p.status = ? AND (";
            for (int i = 0; i < words.length; i++) {
                if (i != 0) {
                    sql += " OR ";
                }
                sql += "c.name LIKE ? OR p.name LIKE ?";
            }
            sql += ")";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idstatus);
            for (int i = 0; i < words.length; i++) {
                String word = "%" + words[i] + "%";
                stmt.setString(i * 2 + 2, word);
                stmt.setString(i * 2 + 3, word);
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                int idProduct = rs.getInt("id_product");
                int idCategory = rs.getInt("id_category");
                String image = rs.getString("image");
                String name = rs.getString("name");
                String note = rs.getString("note");
                double price = rs.getDouble("price");
                Timestamp date_p = rs.getTimestamp("date_p");
                int idUser = rs.getInt("id_user");
                boolean status = rs.getBoolean("status");
                ProductDto productDto = new ProductDto(idProduct, idCategory, image, name, note, price, date_p, idUser, status);
                productDtos.add(productDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }
        return productDtos;
    }


    public List<ProductDto> listProductAllByStatus(int idStatus) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ProductDto> productDtos = new ArrayList<>();

        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT);
            stmt.setInt(1, idStatus);
            rs = stmt.executeQuery();

            while (rs.next()) {
                int idProduct = rs.getInt("id_product");
                int idCategory = rs.getInt("id_category");
                String image = rs.getString("image");
                String name = rs.getString("name");
                String note = rs.getString("note");
                double price = rs.getDouble("price");
                Timestamp date_p = rs.getTimestamp("date_p"); // Obtener directamente como Timestamp
                int idUser = rs.getInt("id_user");
                boolean status = rs.getBoolean("status");
                // Crear un objeto Producto con los datos obtenidos
                ProductDto productDto = new ProductDto(idProduct, idCategory, image, name, note, price, date_p, idUser, status);
                productDtos.add(productDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            // Cerrar recursos en el bloque finally
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }

        return productDtos;
    }

    public List<ProductDto> listProductTop8ByStatus(int idStatus) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ProductDto> productDtos = new ArrayList<>();

        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT_TOP8);
            stmt.setInt(1, idStatus);
            rs = stmt.executeQuery();

            while (rs.next()) {
                int idProduct = rs.getInt("id_product");
                int idCategory = rs.getInt("id_category");
                String image = rs.getString("image");
                String name = rs.getString("name");
                String note = rs.getString("note");
                double price = rs.getDouble("price");
                Timestamp date_p = rs.getTimestamp("date_p"); // Obtener directamente como Timestamp
                int idUser = rs.getInt("id_user");
                boolean status = rs.getBoolean("status");
                // Crear un objeto Producto con los datos obtenidos
                ProductDto productDto = new ProductDto(idProduct, idCategory, image, name, note, price, date_p, idUser, status);
                productDtos.add(productDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            // Cerrar recursos en el bloque finally
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }

        return productDtos;
    }

    public ProductDto buscar(ProductDto productDto){
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        ProductDto productDtoEncontrado = null;

        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT_BY_ID);
            stmt.setInt(1, productDto.getIdProducto());
            rs = stmt.executeQuery();

            if (rs.next()) {
                int idProduct = rs.getInt("id_product");
                int idCategory = rs.getInt("id_category");
                String image = rs.getString("image");
                String name = rs.getString("name");
                String note = rs.getString("note");
                double price = rs.getDouble("price");
                Timestamp date_p = rs.getTimestamp("date_p"); // Obtener directamente como Timestamp
                int idUser = rs.getInt("id_user");
                boolean status = rs.getBoolean("status");
                // Crear un objeto Producto con los datos obtenidos
                productDtoEncontrado = new ProductDto(idProduct, idCategory, image, name, note, price, date_p, idUser, status);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            // Cerrar recursos en el bloque finally
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }

        return productDtoEncontrado;
    }

    public int insertar(ProductDto productDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        int row = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_INSERT);

            stmt.setInt(1, productDto.getIdCategory());
            stmt.setString(2, productDto.getImage());
            stmt.setString(3, productDto.getName());
            stmt.setString(4, productDto.getNote());
            stmt.setDouble(5, productDto.getPrice());

            // Convertir la fecha al formato adecuado para la base de datos (Timestamp)
            Timestamp datep = new Timestamp(productDto.getDatep().getTime());
            stmt.setTimestamp(6, datep);

            stmt.setInt(7, productDto.getIdUser());

            row = stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return row;
    }

    public int actualizar(ProductDto productDto){
        Connection conn = null;
        PreparedStatement stmt = null;
        int row = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_UPDATE);

            stmt.setInt(1, productDto.getIdCategory());
            stmt.setString(2, productDto.getImage());
            stmt.setString(3, productDto.getName());
            stmt.setString(4, productDto.getNote());
            stmt.setDouble(5, productDto.getPrice());
            stmt.setInt(6, productDto.getIdProducto());

            row = stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return row;
    }

    public int updateUserStatus(int status, ProductDto productDto){
        Connection conn = null;
        PreparedStatement stmt = null;
        int row = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_UPDATE_STATUS);
            stmt.setInt(1, status);
            stmt.setInt(2, productDto.getIdProducto());
            row = stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return row;
    }


    public void processPay(ArrayList<CartDto> cartDto, int status, TicketSaleDto ticketSaleDto) {
        String sqlVenta = "INSERT INTO ticket_sale(date_time, id_user, total_pay, is_delivery,address_delivery, note, id_type_payment) VALUES (?, ?, ?, ?, ?, ?,?)";
        String sqlDetalle = "INSERT INTO product.detail_product(id_ticket, id_product, quantity, price_sale) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = AccessDB.getConexion();
            conn.setAutoCommit(false); // Deshabilitar auto commit
            PreparedStatement pstmtVenta = conn.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS); // Obtener ID generado
            pstmtVenta.setTimestamp(1, ticketSaleDto.getDate());
            pstmtVenta.setInt(2, ticketSaleDto.getIdUser());
            pstmtVenta.setDouble(3, ticketSaleDto.getTotalPay());
            pstmtVenta.setInt(4, status);
            pstmtVenta.setString(5, ticketSaleDto.getAddressDelivery());
            pstmtVenta.setString(6, ticketSaleDto.getNote());
            pstmtVenta.setInt(7, ticketSaleDto.getIdTypePay());
            pstmtVenta.executeUpdate();
            // Obtener el ID del ticket
            ResultSet rs = pstmtVenta.getGeneratedKeys();
            rs.next();
            int idTicket = rs.getInt(1);
            // Insertar en detail_product para cada producto
            PreparedStatement pstmtDetalle = conn.prepareStatement(sqlDetalle);
            for (CartDto item : cartDto) {
                pstmtDetalle.setInt(1, idTicket);
                pstmtDetalle.setInt(2, item.getProductDto().getIdProducto());
                pstmtDetalle.setInt(3, item.getQuantity());
                pstmtDetalle.setDouble(4, item.getProductDto().getPrice());
                pstmtDetalle.executeUpdate();
            }
            conn.commit(); // Finalizar transacción
        } catch (SQLException e) {
            try {
                conn.rollback(); // Deshacer cambios en caso de error
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                conn.setAutoCommit(true); // Restaurar auto commit
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public ProductDto ConsultProduct(int idProduct) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        ProductDto productDto = null;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_CONSULT_PRODUCT);
            stmt.setInt(1, idProduct);
            rs = stmt.executeQuery();
            if (rs.next()) {
                int idProduct_ = rs.getInt("id_product");
                int idCategory = rs.getInt("id_category");
                String image = rs.getString("image");
                String name = rs.getString("name");
                String note = rs.getString("note");
                double price = rs.getDouble("price");
                Timestamp date_p = rs.getTimestamp("date_p");
                int idUser = rs.getInt("id_user");
                boolean status = rs.getBoolean("status");
                productDto = new ProductDto(idProduct_, idCategory, image, name, note, price, date_p, idUser, status);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }
        return productDto;
    }


}
