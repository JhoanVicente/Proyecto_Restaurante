package pe.edu.vallegrande.sysrestaurant.service.sale;

import pe.edu.vallegrande.sysrestaurant.db.AccessDB;
import pe.edu.vallegrande.sysrestaurant.dto.order.OrderDto;
import pe.edu.vallegrande.sysrestaurant.dto.order.OrderDetailDto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderService {
    // consulta de almacenamiento procesado para el cliente
    private static final String JDBC_CLIENT_ORDER_VIEW = "{CALL sp_OrderViewForUser(?, ?)}";
    private static final String JDBC_CLIENT_ORDER_DETAIL = "{CALL sp_OrderProductDetail(?)}";
    private static final String JDBC_CLIENT_ORDEN_BY_TICKET_CLIENT = "{CALL sp_OrderByTicketClient(?)}";

    //Admins
    private static final String JDBC_CLIENT_ORDER_VIEW_ALL = "{CALL sp_OrderViewAll(?)}";
    private static final String JDBC_CLIENT_ORDER_VIEW_ALL_FOR_PAGINATION = "{CALL sp_OrderViewAllForPagination(?,?, ?)}";
    private static final String JDBC_UPDATE_STATUS_ORDER = " UPDATE ticket_sale SET id_type_status = ? WHERE id_ticket = ?";


    public List<OrderDto> listOrderView(int idUser, int StatusOrder) {
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;
        List<OrderDto> OrdenUsers = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            cs = conn.prepareCall(JDBC_CLIENT_ORDER_VIEW);
            cs.setInt(1, idUser);
            cs.setInt(2, StatusOrder);
            rs = cs.executeQuery();
            while (rs.next()) {
                int idTicket = rs.getInt(1);
                Double total = rs.getDouble(2);
                Timestamp date = rs.getTimestamp(3);
                String typeDelivery = rs.getString(4);
                String typePay = rs.getString(5);
                String statusOrder = rs.getString(6);
                String names = rs.getString(7);
                String lastnames = rs.getString(8);
                OrderDto orderDto = new OrderDto(idTicket, total, date, typeDelivery, typePay, statusOrder, names, lastnames);
                OrdenUsers.add(orderDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(cs);
        }
        return OrdenUsers;
    }

    public List<OrderDetailDto> listOrderProductDetail(int idTicket) {
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;
        List<OrderDetailDto> ordenDetail = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            cs = conn.prepareCall(JDBC_CLIENT_ORDER_DETAIL);
            cs.setInt(1, idTicket);
            rs = cs.executeQuery();
            while (rs.next()) {
                int quantity = rs.getInt(1);
                String name = rs.getString(2);
                Double price = rs.getDouble(3);
                OrderDetailDto orderDetailDto = new OrderDetailDto(name, quantity, price);
                ordenDetail.add(orderDetailDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(cs);
        }
        return ordenDetail;
    }

    public OrderDto listOrderByTicketClient(OrderDto orderDto) {
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;
        try {
            conn = AccessDB.getConexion();
            cs = conn.prepareCall(JDBC_CLIENT_ORDEN_BY_TICKET_CLIENT);
            cs.setInt(1, orderDto.getIdTicket());
            rs = cs.executeQuery();
            if (rs.next()) {
                int ticket = rs.getInt(1);
                Double total = rs.getDouble(2);
                Timestamp date = rs.getTimestamp(3);
                String typeDelivery = rs.getString(4);
                String typePay = rs.getString(5);
                String statusOrder = rs.getString(6);
                String names = rs.getString(7);
                String lastnames = rs.getString(8);
                String email = rs.getString(9);
                String phone = rs.getString(10);
                String numberDocument = rs.getString(11);
                String typeDocument = rs.getString(12);
                String address = rs.getString(13);
                String nota = rs.getString(14);
                int idUser = rs.getInt(15);
                orderDto = new OrderDto(ticket, total, date, typeDelivery, typePay, statusOrder, names, lastnames, email, phone, numberDocument, typeDocument, address, nota, idUser);
            } else {
                orderDto = null;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(cs);
        }
        return orderDto;
    }

    public List<OrderDto> listOrderAllByStatus(int StatusOrder) {
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;
        List<OrderDto> OrdenUsers = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            cs = conn.prepareCall(JDBC_CLIENT_ORDER_VIEW_ALL);
            cs.setInt(1, StatusOrder);
            rs = cs.executeQuery();
            while (rs.next()) {
                int idTicket = rs.getInt(1);
                Double total = rs.getDouble(2);
                Timestamp date = rs.getTimestamp(3);
                String typeDelivery = rs.getString(4);
                String typePay = rs.getString(5);
                int idStatusOrder = rs.getInt(6);
                String names = rs.getString(7);
                String lastnames = rs.getString(8);
                OrderDto orderDto = new OrderDto(idTicket, total, date, typeDelivery, typePay, names, lastnames, idStatusOrder);
                OrdenUsers.add(orderDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(cs);
        }
        return OrdenUsers;
    }

    private static final String JDBC_CLIENT_ORDER_VIEW_BY_NAME = "{CALL sp_OrderViewByName(?)}";

    public List<OrderDto> listOrderByName(String query, int status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<OrderDto> orderDtos = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            String[] words = query.split("\\s+");
            String sql = "SELECT ts.id_ticket AS 'Id de ticket', ts.total_pay AS 'Total de pago', ts.date_time AS 'Fecha de la venta', "
                    + "CASE WHEN ts.is_delivery = 1 THEN 'Entrega a domicilio' ELSE 'Entrega en el Restaurante' END AS 'Metodo de entrega', "
                    + "tp.name AS 'Tipo de pago', tso.id_type_status AS 'Estado', u.names AS 'Nombres', u.lastnames AS 'Apellidos' "
                    + "FROM ticket_sale ts "
                    + "JOIN users.user_restaurant u ON ts.id_user = u.id_user "
                    + "JOIN type_payment tp ON ts.id_type_payment = tp.id_type_payment "
                    + "JOIN type_status_order tso ON ts.id_type_status = tso.id_type_status "
                    + "WHERE tso.id_type_status = ? AND (";
            for (int i = 0; i < words.length; i++) {
                if (i != 0) {
                    sql += " OR ";
                }
                sql += "u.names LIKE ? OR u.lastnames LIKE ? OR (ts.is_delivery = 1 AND 'domicilio' LIKE ?) "
                        + "OR (ts.is_delivery = 0 AND 'restaurante' LIKE ?) ";
            }
            sql += ")";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, status);
            int paramIndex = 2;
            for (int i = 0; i < words.length; i++) {
                String word = "%" + words[i] + "%";
                stmt.setString(paramIndex++, word);
                stmt.setString(paramIndex++, word);
                stmt.setString(paramIndex++, word);
                stmt.setString(paramIndex++, word);
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                int idTicket = rs.getInt("Id de ticket");
                double totalPay = rs.getDouble("Total de pago");
                Timestamp dateTime = rs.getTimestamp("Fecha de la venta");
                String methodDelivery = rs.getString("Metodo de entrega");
                String typePayment = rs.getString("Tipo de pago");
                int statusOrder = rs.getInt("Estado");
                String names = rs.getString("Nombres");
                String lastnames = rs.getString("Apellidos");
                OrderDto orderDto = new OrderDto(idTicket, totalPay, dateTime, methodDelivery, typePayment, names, lastnames, statusOrder);
                orderDtos.add(orderDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }
        return orderDtos;
    }

    public int countOrderByStatus(int StatusOrder) {
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;
        int totalRows = 0;
        try {
            conn = AccessDB.getConexion();
            cs = conn.prepareCall("{CALL sp_GetTotalRows(?)}");
            cs.setInt(1, StatusOrder);
            rs = cs.executeQuery();
            if (rs.next()) {
                totalRows = rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(cs);
        }
        return totalRows;
    }

    // OrderService.java
    public List<OrderDto> listOrderAllForPagination(int StatusOrder, int pageNumber, int rowsPerPage) {
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;
        List<OrderDto> OrdenUsers = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            cs = conn.prepareCall(JDBC_CLIENT_ORDER_VIEW_ALL_FOR_PAGINATION);
            cs.setInt(1, StatusOrder);
            cs.setInt(2, pageNumber);
            cs.setInt(3, rowsPerPage);
            rs = cs.executeQuery();
            while (rs.next()) {
                int idTicket = rs.getInt(1);
                Double total = rs.getDouble(2);
                Timestamp date = rs.getTimestamp(3);
                String typeDelivery = rs.getString(4);
                String typePay = rs.getString(5);
                int idStatusOrder = rs.getInt(6);
                String names = rs.getString(7);
                String lastnames = rs.getString(8);
                OrderDto orderDto = new OrderDto(idTicket, total, date, typeDelivery, typePay, names, lastnames, idStatusOrder);
                OrdenUsers.add(orderDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            if (rs != null) {
                AccessDB.close(rs);
            }
            if (cs != null) {
                AccessDB.close(cs);
            }
            if (conn != null) {
                AccessDB.close(conn);
            }
        }
        return OrdenUsers;
    }


    public int updateStatusOrder(int status, OrderDto orderDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        int row = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_UPDATE_STATUS_ORDER);
            stmt.setInt(1, status);
            stmt.setInt(2, orderDto.getIdTicket());
            row = stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(stmt);
            AccessDB.close(conn);
        }
        return row;
    }
}
