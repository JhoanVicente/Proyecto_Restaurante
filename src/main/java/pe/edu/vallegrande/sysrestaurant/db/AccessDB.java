package pe.edu.vallegrande.sysrestaurant.db;

import java.sql.*;

public class AccessDB {

    private static final String JDBC_URL = "jdbc:sqlserver://localhost:14033;databaseName=dbLosPinos;encrypt=True;TrustServerCertificate=True";
    private static final String JDBC_USER = "sa";
    private static final String JDBC_PASSWORD = "LosPinos123";

    public static Connection getConexion() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Error al cargar el driver de SqlServer", e);
        }
    }

    public static void close(Statement stmt) {
        try {
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
    }

    public static void close(PreparedStatement stmt) {
        try {
            stmt.close();
        } catch (SQLException e) {
            // printStackTrace
            e.printStackTrace(System.out);
        }
    }

    public static void close(Connection conn) {
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
    }

    public static void close(ResultSet rs) {
        try {
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
    }

    public static void close(CallableStatement cs) {
        try {
            cs.close();
        } catch (SQLException e) {
            e.printStackTrace(System.out);
        }
    }


}
