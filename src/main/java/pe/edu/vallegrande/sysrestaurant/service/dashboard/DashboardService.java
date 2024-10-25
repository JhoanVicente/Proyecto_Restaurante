package pe.edu.vallegrande.sysrestaurant.service.dashboard;

import pe.edu.vallegrande.sysrestaurant.db.AccessDB;
import pe.edu.vallegrande.sysrestaurant.dto.dashboard.ProductMaxSoldDto;
import pe.edu.vallegrande.sysrestaurant.dto.dashboard.UserMaxOrderDto;
import pe.edu.vallegrande.sysrestaurant.dto.dashboard.UserRecentDto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DashboardService {
    private static final String COUNT_ORDERS_PENDING = "SELECT COUNT(*) AS PendingOrders " +
            " FROM ticket_sale " +
            " WHERE id_type_status = 1";


    private static final String COUNT_USERS_ACTIVE = "SELECT COUNT(*) AS ActiveUsers\n" +
            "FROM users.user_restaurant\n" +
            "WHERE status = 1";

    private static final String COUNT_PRODUCTS_ACTIVE = "SELECT COUNT(*) AS ActiveProducts\n" +
            "FROM product.product\n" +
            "WHERE status = 1";

    private static final String LIST_PRODUCTS_MAX_SOLD = "SELECT TOP 5 p.name, SUM(dp.quantity) AS TotalSold\n" +
            "FROM product.product p\n" +
            "JOIN product.detail_product dp ON p.id_product = dp.id_product\n" +
            "JOIN ticket_sale ts ON dp.id_ticket = ts.id_ticket\n" +
            "WHERE ts.id_type_status = 4\n" +
            "GROUP BY p.name\n" +
            "ORDER BY TotalSold DESC";

    private static final String LIST_USERS_MAX_ORDERS = "SELECT TOP 5 u.names, COUNT(ts.id_ticket) AS TotalCompletedOrders\n" +
            "FROM users.user_restaurant u\n" +
            "JOIN ticket_sale ts ON u.id_user = ts.id_user\n" +
            "WHERE ts.id_type_status = 4\n" +
            "GROUP BY u.names\n" +
            "ORDER BY TotalCompletedOrders DESC";

    public List<UserMaxOrderDto> listUserAllMaxOrder() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<UserMaxOrderDto> listUserMaxOrderDto = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(LIST_USERS_MAX_ORDERS);
            rs = stmt.executeQuery();
            while (rs.next()) {
                String nameUser = rs.getString(1);
                int totalCompletedOrders = rs.getInt(2);
                UserMaxOrderDto userMaxOrderDto = new UserMaxOrderDto(nameUser, totalCompletedOrders);
                listUserMaxOrderDto.add(userMaxOrderDto);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
            AccessDB.close(rs);
        }

        return listUserMaxOrderDto;
    }

    public List<ProductMaxSoldDto> listProductAllMaxSold() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ProductMaxSoldDto> lisProductMaxSoldDto = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(LIST_PRODUCTS_MAX_SOLD);
            rs = stmt.executeQuery();
            while (rs.next()) {
                String nameProduct = rs.getString(1);
                int totalSold = rs.getInt(2);
                ProductMaxSoldDto productMaxSoldDto = new ProductMaxSoldDto(nameProduct, totalSold);
                lisProductMaxSoldDto.add(productMaxSoldDto);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
            AccessDB.close(rs);
        }
        return lisProductMaxSoldDto;
    }

    public int countOrdersPending() {
        int count = 0;
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(COUNT_ORDERS_PENDING);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt("PendingOrders");
            }
            return count;
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return count;
    }

    private static final String SUM_TOTALPAYMENT_BY_DAY = "\n" +
            "SELECT SUM(total_pay) AS TotalCompletedOrders\n" +
            "FROM ticket_sale\n" +
            "WHERE id_type_status = 4 AND CAST(date_time AS DATE) =?";

    public double sumTotalPaymentByDay(String date) {
        double total = 0;
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(SUM_TOTALPAYMENT_BY_DAY);
            stmt.setString(1, date);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                total = rs.getDouble("TotalCompletedOrders");
            }
            return total;
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return total;
    }


    private static final String LIST_USERS_RECENTS = "SELECT TOP 5 names, lastnames\n" +
            "                FROM users.user_restaurant\n" +
            "                WHERE id_type_user = ?\n" +
            "                ORDER BY id_user  DESC";

    public List<UserRecentDto> listUserAllRecent(int typeUser){
        Connection conn = null;
        PreparedStatement stmt =null;
        ResultSet rs = null;
        List<UserRecentDto> listUserRecentDto = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(LIST_USERS_RECENTS);
            stmt.setInt(1, typeUser);
            rs = stmt.executeQuery();
            while (rs.next()) {
                String nameUser = rs.getString(1);
                String lastNameUser = rs.getString(2);
                UserRecentDto userRecentDto = new UserRecentDto(nameUser, lastNameUser);
                listUserRecentDto.add(userRecentDto);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
            AccessDB.close(rs);
        }
        return listUserRecentDto;
    }

}
