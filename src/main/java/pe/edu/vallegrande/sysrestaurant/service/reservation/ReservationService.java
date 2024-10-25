package pe.edu.vallegrande.sysrestaurant.service.reservation;

import pe.edu.vallegrande.sysrestaurant.db.AccessDB;
import pe.edu.vallegrande.sysrestaurant.dto.reservation.ReservationDto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReservationService {
    // Las sentencias Sql client reservation
    private static final String JDBC_RESERVATION_VIEW_ALL = "SELECT id_client_reservation, id_user, name_reservation, date_time, quantity_people, note, id_type_status FROM client_reservation WHERE id_type_status = ?";
    private static final String JDBC_RESERVATION_VIEW_DETAIL = "SELECT id_client_reservation, id_user, name_reservation, date_time, quantity_people, note, id_type_status FROM client_reservation WHERE id_client_reservation = ?";
    private static final String JDBC_INSERT = "INSERT INTO client_reservation (id_user, name_reservation, date_time, quantity_people, note, id_type_status) VALUES (?, ?, ?, ?, ?, ?)";
   private static final String JDBC_UPDATE_STATUS_RESERVATION = "UPDATE client_reservation SET id_type_status = ? WHERE id_client_reservation = ?";
    private static final String JDBC_SELECT_BY_CLIENT = "SELECT\n" +
            "    cr.id_client_reservation,\n" +
            "    cr.id_user,\n" +
            "    cr.name_reservation,\n" +
            "    cr.date_time,\n" +
            "    cr.quantity_people,\n" +
            "    cr.note,\n" +
            "    tso.name as status_name\n" +
            "FROM\n" +
            "    client_reservation cr\n" +
            "        JOIN\n" +
            "    type_status_order tso ON cr.id_type_status = tso.id_type_status\n" +
            "WHERE\n" +
            "    cr.id_user = ? AND cr.id_type_status = ?";
    private static final String JDBC_UPDATE = "UPDATE client_reservation SET id_user = ?, name_reservation = ?, date_time = ?, quantity_people = ?, note = ?, id_type_status = ? WHERE id_client_reservation = ?";
    private static final String JDBC_DELETE = "DELETE FROM client_reservation WHERE id_client_reservation = ?";

    public List<ReservationDto> listReservationAllByStatus(int idStatusOrder) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ReservationDto> reservationDtos = new ArrayList<>(); // Inicializar la lista
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_RESERVATION_VIEW_ALL);
            stmt.setInt(1, idStatusOrder);
            rs = stmt.executeQuery();
            while (rs.next()) {
                ReservationDto reservationDto = new ReservationDto();
                reservationDto.setIdClientReservation(rs.getInt(1));
                reservationDto.setIdUser(rs.getInt(2));
                reservationDto.setNameClient(rs.getString(3));
                reservationDto.setDate(rs.getTimestamp(4));
                reservationDto.setQuantityPeople(rs.getInt(5));
                reservationDto.setNote(rs.getString(6));
                reservationDto.setStatus(rs.getInt(7));
                reservationDtos.add(reservationDto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            AccessDB.close(rs);
            AccessDB.close(stmt);
            AccessDB.close(conn);
        }
        return reservationDtos;
    }

    public ReservationDto listReservationById(ReservationDto reservationDto){
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_RESERVATION_VIEW_DETAIL);
            stmt.setInt(1, reservationDto.getIdClientReservation());
            rs = stmt.executeQuery();
            if (rs.next()) {
                reservationDto.setIdClientReservation(rs.getInt(1));
                reservationDto.setIdUser(rs.getInt(2));
                reservationDto.setNameClient(rs.getString(3));
                reservationDto.setDate(rs.getTimestamp(4));
                reservationDto.setQuantityPeople(rs.getInt(5));
                reservationDto.setNote(rs.getString(6));
                reservationDto.setStatus(rs.getInt(7));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            AccessDB.close(rs);
            AccessDB.close(stmt);
            AccessDB.close(conn);
        }
        return reservationDto;
    }

    public List<ReservationDto> listReservationByClientStatus(int idUser, int statuseOrder){
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ReservationDto> reservationDtos = new ArrayList<>(); // Inicializar la lista
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT_BY_CLIENT);
            stmt.setInt(1, idUser);
            stmt.setInt(2, statuseOrder);
            rs = stmt.executeQuery();
            while (rs.next()) {
                ReservationDto reservationDto = new ReservationDto();
                reservationDto.setIdClientReservation(rs.getInt(1));
                reservationDto.setIdUser(rs.getInt(2));
                reservationDto.setNameClient(rs.getString(3));
                reservationDto.setDate(rs.getTimestamp(4));
                reservationDto.setQuantityPeople(rs.getInt(5));
                reservationDto.setNote(rs.getString(6));
                reservationDto.setStatusStr(rs.getString(7));
                reservationDtos.add(reservationDto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            AccessDB.close(rs);
            AccessDB.close(stmt);
            AccessDB.close(conn);
        }
        return reservationDtos;
    }

    public int insertReservation(ReservationDto reservationDto){
        Connection conn = null;
        PreparedStatement stmt = null;
        int rows = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_INSERT);
            stmt.setInt(1, reservationDto.getIdUser());
            stmt.setString(2, reservationDto.getNameClient());
            stmt.setTimestamp(3, reservationDto.getDate());
            stmt.setInt(4, reservationDto.getQuantityPeople());
            stmt.setString(5, reservationDto.getNote());
            stmt.setInt(6, reservationDto.getStatus());
            rows = stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            AccessDB.close(stmt);
            AccessDB.close(conn);
        }
        return rows;
    }

    public int updateStatusOrder(int status, ReservationDto idReservationDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        int rows = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_UPDATE_STATUS_RESERVATION);
            stmt.setInt(1, status);
            stmt.setInt(2, idReservationDto.getIdClientReservation());
            rows = stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            AccessDB.close(stmt);
            AccessDB.close(conn);
        }
        return rows;
    }










}
