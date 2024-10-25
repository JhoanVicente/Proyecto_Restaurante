package pe.edu.vallegrande.sysrestaurant.service.user;

import pe.edu.vallegrande.sysrestaurant.db.AccessDB;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

public class UserService {

    private static final String JDBC_SELECT = "SELECT id_user, username, names, lastnames, phone, email, number_identification, type_document, id_type_user, status, email_verified FROM users.user_restaurant WHERE status = ?";
    private static final String JDBC_SELECT_BY_ID = "SELECT id_user, username, password, names, lastnames, date_birth, address, phone, email, number_identification, type_document, id_type_user, status FROM users.user_restaurant WHERE id_user = ?";
    private static final String JDBC_UPDATE = "UPDATE users.user_restaurant SET username = ?, password = ?, names = ?, lastnames = ?, date_birth = ?, address = ?, phone = ?, email = ?, number_identification = ?, type_document = ?,  id_type_user = ? WHERE id_user = ?";
    private static final String JDBC_UPDATE_STATUS = "UPDATE users.user_restaurant SET status = ? WHERE id_user = ?";
    private static final String JDBC_LOGIN = "SELECT id_user, username, names, lastnames, phone, email, number_identification, type_document, id_type_user, status, email_verified FROM users.user_restaurant WHERE (username = ? OR email = ?) AND password = ?";
   private static final String JDBC_COUNT_ORDER_BY_CLIENT  = "SELECT COUNT(*) AS NumeroPedidos FROM ticket_sale WHERE id_user = ?";

    public int countOrdersByClient(int idUser) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_COUNT_ORDER_BY_CLIENT);
            stmt.setInt(1, idUser);
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }
        return count;
    }
    public List<UserDto> listUserAllForStatus(int status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<UserDto> userDtos = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT);
            stmt.setInt(1, status);
            rs = stmt.executeQuery();
            while (rs.next()) {
                UserDto userDto = userFromResultSet(rs);
                userDtos.add(userDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }
        return userDtos;
    }

    public List<UserDto> listUsers(int status, int limit, int offset) {
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;
        List<UserDto> userDtos = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            cs = conn.prepareCall("{CALL sp_UsersViewAllForPagination(?, ?, ?)}");
            cs.setInt(1, status);
            cs.setInt(2, offset);
            cs.setInt(3, limit);
            rs = cs.executeQuery();
            while (rs.next()) {
                UserDto userDto = userFromResultSet(rs);
                userDtos.add(userDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(cs);
        }
        return userDtos;
    }

    public int countUsersByStatus(int status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement("SELECT COUNT(*) FROM users.user_restaurant WHERE status = ?");
            stmt.setInt(1, status);
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }
        return count;
    }
    public UserDto searchUser(UserDto userDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT_BY_ID);
            stmt.setInt(1, userDto.getIdUsuario());
            rs = stmt.executeQuery();

            if (rs.next()) {
                int idCliente = rs.getInt(1);
                String usernameDB = rs.getString(2);
                String passwordDB = rs.getString(3);
                String names = rs.getString(4);
                String lastnames = rs.getString(5);
                Date date_birth = rs.getDate(6); // Obtener como cadena
                String address = rs.getString(7);
                String phone = rs.getString(8);
                String email = rs.getString(9);
                String numberIdentity = rs.getString(10);
                String typeDocument = rs.getString(11);
                int typeUser = rs.getInt(12); // Convertir a entero
                boolean status = rs.getBoolean(13);
                userDto = new UserDto(idCliente, usernameDB, passwordDB, names, lastnames, date_birth, address, phone, email, numberIdentity, typeDocument, typeUser, status);
            } else {
                userDto = null; // O lógica adicional según el caso
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            // Cerrar recursos en el bloque finally
            AccessDB.close(conn);
            AccessDB.close(stmt);
            AccessDB.close(rs);
        }
        return userDto;
    }
    private static final String JDBC_INSERT = "INSERT INTO users.user_restaurant (username, password, names, lastnames, date_birth, address, phone, email, number_identification, type_document, id_type_user, email_verified) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";

    public int insertUser(UserDto userDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        int idUser = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_INSERT, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, userDto.getUsername());
            stmt.setString(2, userDto.getPassword());
            stmt.setString(3, userDto.getNames());
            stmt.setString(4, userDto.getLastnames());
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String dateOfBirthStr = dateFormat.format(userDto.getDate_birth());
            stmt.setString(5, dateOfBirthStr);
            stmt.setString(6, userDto.getAddress());
            stmt.setString(7, userDto.getPhone());
            stmt.setString(8, userDto.getEmail());
            stmt.setString(9, userDto.getNumberIdentity());
            stmt.setString(10, userDto.getTypeDocument());
            stmt.setInt(11, userDto.getTypeUser());
            stmt.execute();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                idUser = rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return idUser;
    }
    public int updateUser(UserDto userDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        int row = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_UPDATE);
            stmt.setString(1, userDto.getUsername());
            stmt.setString(2, userDto.getPassword());
            stmt.setString(3, userDto.getNames());
            stmt.setString(4, userDto.getLastnames());
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String dateOfBirthStr = dateFormat.format(userDto.getDate_birth());
            stmt.setString(5, dateOfBirthStr);
            stmt.setString(6, userDto.getAddress());
            stmt.setString(7, userDto.getPhone());
            stmt.setString(8, userDto.getEmail());
            stmt.setString(9, userDto.getNumberIdentity());
            stmt.setString(10, userDto.getTypeDocument());
            stmt.setInt(11, userDto.getTypeUser());
            stmt.setInt(12, userDto.getIdUsuario());
            row = stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return row;
    }

    public int updateUserStatus(int status, UserDto userDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        int row = 0;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_UPDATE_STATUS);
            stmt.setInt(1, status);
            stmt.setInt(2, userDto.getIdUsuario());
            row = stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(stmt);
            AccessDB.close(conn);
        }
        return row;
    }

    public UserDto loginUser(UserDto userDto) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_LOGIN);
            stmt.setString(1, userDto.getUsername());
            stmt.setString(2, userDto.getUsername());
            stmt.setString(3, userDto.getPassword());
            rs = stmt.executeQuery();
            if (rs.next()) {
                userDto = userFromResultSet(rs);
            }else {
                userDto = null;
            }

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            // Cerrar recursos en el bloque finally
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }
        return userDto;
    }
    public UserDto userFromResultSet(ResultSet rs) throws SQLException {
        int idClient = rs.getInt(1);
        String username = rs.getString(2);
        String names = rs.getString(3);
        String lastnames = rs.getString(4);
        String phone = rs.getString(5);
        String email = rs.getString(6);
        String numberIdentity = rs.getString(7);
        String typeDocument = rs.getString(8);
        int typeUser = rs.getInt(9);
        boolean status = rs.getBoolean(10);
        boolean verifyEmail = rs.getBoolean(11);
        return new UserDto(idClient, username, names, lastnames, phone, email, numberIdentity, typeDocument, typeUser, status,verifyEmail);
    }
    // busqueda de usuario
    public List<UserDto> searchUsers(String query, int status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<UserDto> userDtos = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            String[] words = query.split("\\s+");
            String sql = "SELECT ur.id_user, ur.username, ur.names, ur.lastnames, ur.phone, ur.email, ur.number_identification, ur.type_document, ur.id_type_user, ur.status, ur.email_verified "
                    + "FROM users.user_restaurant ur "
                    + "JOIN users.type_user tu ON ur.id_type_user = tu.id_type_user "
                    + "WHERE ur.status = ? AND (";
            for (int i = 0; i < words.length; i++) {
                if (i != 0) {
                    sql += " OR ";
                }
                sql += "ur.username LIKE ? OR ur.names LIKE ? OR ur.number_identification LIKE ? OR ur.lastnames LIKE ? OR tu.name LIKE ?";
            }
            sql += ")";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, status);
            for (int i = 0; i < words.length; i++) {
                String word = "%" + words[i] + "%";
                stmt.setString(i * 5 + 2, word);
                stmt.setString(i * 5 + 3, word);
                stmt.setString(i * 5 + 4, word);
                stmt.setString(i * 5 + 5, word);
                stmt.setString(i * 5 + 6, word);
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                UserDto userDto = userFromResultSet(rs);
                userDtos.add(userDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(rs);
            AccessDB.close(stmt);
        }
        return userDtos;
    }


    private static final String JDBC_VERIFY_EMAIL = "UPDATE users.user_restaurant SET email_verified =1  WHERE id_user = ?";

    public boolean verifyEmail(int idUser) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_VERIFY_EMAIL);
            stmt.setInt(1, idUser);
            success = stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
        }
        return success;
    }

}
