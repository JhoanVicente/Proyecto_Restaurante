package pe.edu.vallegrande.sysrestaurant.service.user;

import pe.edu.vallegrande.sysrestaurant.db.AccessDB;
import pe.edu.vallegrande.sysrestaurant.dto.user.TypeUserDto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TypeUserService {

    private static final String JDBC_SELECT = "SELECT id_type_user, name FROM users.type_user";

    public List<TypeUserDto> listTypeUser() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        TypeUserDto typeUserDto = null;
        List<TypeUserDto> tiposUsuarios = new ArrayList<>();
        try {
            conn = AccessDB.getConexion();
            stmt = conn.prepareStatement(JDBC_SELECT);
            rs = stmt.executeQuery();
            while (rs.next()) {
                int idTypeUser = rs.getInt(1);
                String nameType = rs.getString(2);
                typeUserDto = new TypeUserDto(idTypeUser, nameType);
                tiposUsuarios.add(typeUserDto);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        } finally {
            AccessDB.close(conn);
            AccessDB.close(stmt);
            AccessDB.close(rs);
        }

        return tiposUsuarios;
    }
}
