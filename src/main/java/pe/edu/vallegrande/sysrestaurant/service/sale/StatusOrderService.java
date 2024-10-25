package pe.edu.vallegrande.sysrestaurant.service.sale;


import pe.edu.vallegrande.sysrestaurant.db.AccessDB;
import pe.edu.vallegrande.sysrestaurant.dto.order.StatusOrderDto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StatusOrderService {
    private static final String JDBC_SELECT_STATUS_ORDER = "SELECT id_type_status, name FROM type_status_order ORDER BY id_type_status";


    public List<StatusOrderDto> listStatusOrder() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        StatusOrderDto statusOrderDto = null;
        List<StatusOrderDto> statusOrderDtos = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT_STATUS_ORDER);
            rs = stmt.executeQuery();
            while (rs.next()) {
                int idTypeStatus = rs.getInt(1);
                String nameStatus = rs.getString(2);
                statusOrderDto = new StatusOrderDto(idTypeStatus, nameStatus);
                statusOrderDtos.add(statusOrderDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
            AccessDB.close(rs);
        }

        return statusOrderDtos;
    }
}
