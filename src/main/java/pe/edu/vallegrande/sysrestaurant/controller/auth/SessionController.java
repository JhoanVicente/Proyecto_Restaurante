package pe.edu.vallegrande.sysrestaurant.controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.commons.codec.digest.DigestUtils;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.user.UserService;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

@WebServlet({"/auth", "/logout"})
public class SessionController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String session = request.getServletPath(); // auth o logout
        String action = request.getParameter("action");
        switch (session) {
            case "/logout":
                logout(request, response);
                break;
            case "/auth":
                if(action != null){
                    switch (action){
                        default:
                            response.sendRedirect("/login");
                            break;
                    }
                }else {
                    response.sendRedirect("/login");
                }
                break;
            default:
                response.sendRedirect("/login");
                break;
        }
    }


    public void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("logged");
            session.invalidate();
        }
        response.sendRedirect("/login");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String Path = request.getServletPath();
        String action = request.getParameter("action");
        switch (Path) {
            case "/auth":
                if (action != null) {
                    switch (action) {
                        case "login":
                            loginUser(request, response);
                            break;
                        case "register":
                            registerUser(request, response);
                            break;
                        default:
                            response.sendRedirect("/login");
                            break;
                    }
                } else {
                    response.sendRedirect("/login");
                }
                break;
            default:
                response.sendRedirect("/login");
                break;
        }

    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = DigestUtils.md5Hex(request.getParameter("password"));
        HttpSession session = request.getSession();
        UserDto logged = new UserService().loginUser(new UserDto(username, password));
        if (logged != null) {
            System.out.println(logged);
            if (!logged.isEmailVerified()) {
                String alert = "swal('¡Error!', 'Su cuenta no esta verificada, revise su correo si no le aparece revise en la bandeja de spam', 'warning');";
                request.getSession().setAttribute("alert", alert);
                response.sendRedirect("/login");
            } else {
                session.setAttribute("logged", logged);
                String alert = "swal('¡Éxito!', 'Iniciado sesión correctamente', 'success');";
                if (logged.getTypeUser() == 1){
                    request.getSession().setAttribute("alert", alert);
                    response.sendRedirect("/admin/dashboard");
                } else if (logged.getTypeUser() == 3) {
                    request.getSession().setAttribute("alert", alert);
                    response.sendRedirect("/client");
                }else if (logged.getTypeUser() == 2) {
                    request.getSession().setAttribute("alert", alert);
                    response.sendRedirect("/admin/order");
                }
            }
        } else {
            String alert = "swal('¡Error!', 'Usuario o contraseña incorrectos', 'error');";
            request.getSession().setAttribute("alert", alert);
            response.sendRedirect("/login");
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = DigestUtils.md5Hex(request.getParameter("password"));
        String tipodocumento = request.getParameter("tipodocumento");
        String documentoidentidad = request.getParameter("documentoidentidad");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String fechaNacimientoStr = request.getParameter("fechanacimiento");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date fechaNacimiento = null;

        try {
            fechaNacimiento = dateFormat.parse(fechaNacimientoStr);
        } catch (ParseException e) {
            e.printStackTrace();
            throw new ServletException("Error al convertir la fecha de nacimiento.", e);
        }

        UserDto userDto = new UserDto(username, password, nombre, apellido, fechaNacimiento, direccion, telefono, email, documentoidentidad, tipodocumento, 3);

        // Insertar usuario y obtener el ID del usuario recién registrado
        int idUser = new UserService().insertUser(userDto);

        String alert;

        if (idUser > 0) {
            alert = "swal('Registrado con Exito', 'Puede inicar a login', 'info');";
           

        } else {
            alert = "swal('¡Error!', 'Error al registrar el usuario, deben ser campos únicos', 'error');";
        }

        request.getSession().setAttribute("alert", alert);
        response.sendRedirect("/login");
    }


}
