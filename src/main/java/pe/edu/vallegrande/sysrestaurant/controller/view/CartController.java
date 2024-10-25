package pe.edu.vallegrande.sysrestaurant.controller.view;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.minidev.json.JSONArray;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.ObjectMapper;
import pe.edu.vallegrande.sysrestaurant.dto.order.CartDto;
import pe.edu.vallegrande.sysrestaurant.dto.order.TicketSaleDto;
import pe.edu.vallegrande.sysrestaurant.dto.payment.BillingDetails;
import pe.edu.vallegrande.sysrestaurant.dto.payment.Customer;
import pe.edu.vallegrande.sysrestaurant.dto.payment.formToken;
import pe.edu.vallegrande.sysrestaurant.dto.payment.formulariotoken;
import pe.edu.vallegrande.sysrestaurant.dto.product.ProductDto;
import pe.edu.vallegrande.sysrestaurant.dto.user.UserDto;
import pe.edu.vallegrande.sysrestaurant.service.product.ProductService;

import javax.ws.rs.client.*;
import javax.ws.rs.core.MultivaluedHashMap;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.util.*;

@WebServlet({ "/cart" })
public class CartController extends HttpServlet {

  

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getParameter("action") != null) {
            String a = request.getParameter("action");
            ProductDto p;
            HttpSession session = request.getSession();
            int idProduct = 0;
            if (a.equals("order")) {
                idProduct = Integer.parseInt(request.getParameter("idProduct"));
                // Si no existe la sesion cart la creamos
                if (session.getAttribute("carts") == null) {
                    // Creamos la lista de cartController para guardar los productos
                    ArrayList<CartDto> cartDto = new ArrayList<>();
                    // Obtenemos el producto por el id para agregarlo al cartController
                    p = new ProductService().ConsultProduct(idProduct);
                    // Verificamos si el producto es nulo
                    if (p != null) {
                        // agregamos la ArrayList para comenzar con la lista de productos
                        cartDto.add(new CartDto(p, 1));
                        // Guardamos la lista de productos en la sesion
                        session.setAttribute("carts", cartDto);
                    }
                } else {
                    // Si ya existe la sesion obtenemos la lista de productos
                    // como session es de tipo Object debemos castearlo a ArrayList<CartDto>,
                    // Castear es convertir un tipo de dato a otro
                    ArrayList<CartDto> cartDto = (ArrayList<CartDto>) session.getAttribute("carts");
                    int index = ProductAlreadyExists(idProduct, cartDto);
                    if (index == -1) {
                        p = new ProductService().ConsultProduct(idProduct);
                        // Verificamos si el producto es nulo
                        if (p != null) {
                            // agregamos la ArrayList para comenzar con la lista de productos
                            cartDto.add(new CartDto(p, 1));
                            // Guardamos la lista de productos en la sesion
                            session.setAttribute("carts", cartDto);
                        }
                    } else {
                        int quantity = cartDto.get(index).getQuantity() + 1;
                        cartDto.get(index).setQuantity(quantity);
                    }

                    session.setAttribute("carts", cartDto);
                }
            } else if (a.equals("delete")) {
                idProduct = Integer.parseInt(request.getParameter("idProduct"));
                ArrayList<CartDto> cartDto = (ArrayList<CartDto>) session.getAttribute("carts");
                int index = ProductAlreadyExists(idProduct, cartDto);
                if (index != -1) { // Comprueba si el producto existe antes de intentar eliminarlo
                    cartDto.remove(index);
                    session.setAttribute("carts", cartDto);
                }
            } else if (a.equals("clear")) {
                ArrayList<CartDto> cartDto = (ArrayList<CartDto>) session.getAttribute("carts");
                cartDto.clear();
                session.setAttribute("carts", cartDto);
            } else if (a.equals("increment")) {
                idProduct = Integer.parseInt(request.getParameter("idProduct"));
                ArrayList<CartDto> cartDto = (ArrayList<CartDto>) session.getAttribute("carts");
                int index = ProductAlreadyExists(idProduct, cartDto);
                int quantity = cartDto.get(index).getQuantity() + 1;
                cartDto.get(index).setQuantity(quantity);
                session.setAttribute("carts", cartDto);
            } else if (a.equals("decrement")) {
                idProduct = Integer.parseInt(request.getParameter("idProduct"));
                ArrayList<CartDto> cartDto = (ArrayList<CartDto>) session.getAttribute("carts");
                int index = ProductAlreadyExists(idProduct, cartDto);
                int quantity = cartDto.get(index).getQuantity() - 1;
                if (quantity > 0) {
                    cartDto.get(index).setQuantity(quantity);
                } else {
                    cartDto.remove(index);
                }
                session.setAttribute("carts", cartDto);
            }
        }
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/WEB-INF/view/cart.jsp").forward(request, response);
    }

    // Método para verificar si el producto ya existe en el carrito
    private int ProductAlreadyExists(int idProduct, ArrayList<CartDto> cartDto) {
        // Recorremos la lista de productos
        for (int i = 0; i < cartDto.size(); i++) {
            if (cartDto.get(i).getProductDto().getIdProducto() == idProduct) {
                // Si el producto ya existe retornamos la posición en la lista
                return i;
            }
        }
        // Si no existe el producto en la lista retornamos -1
        return -1;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action.equals("pay")) {

            int idTypePay = Integer.parseInt(request.getParameter("idTypePay"));

            HttpSession session = request.getSession();
            ArrayList<CartDto> cartDto = (ArrayList<CartDto>) session.getAttribute("carts");
            UserDto logged = (UserDto) session.getAttribute("logged");
            String address = request.getParameter("address");
            Double total = Double.parseDouble(request.getParameter("total"));
            String note = request.getParameter("note");
            Timestamp datep = new Timestamp(new Date().getTime());
            int isdelivery = request.getParameter("isDelivery") == null ? 1 : 0;
            new ProductService().processPay(cartDto, isdelivery,
                    new TicketSaleDto(datep, logged.getIdUsuario(), total, address, note, idTypePay));
            cartDto.clear();
            session.setAttribute("carts", cartDto);
            session.setAttribute("totalpay", total);
            session.setAttribute("TypePayP", idTypePay);

            response.sendRedirect("/finishedOrder");

        } else {
            response.sendRedirect("cart");
        }
    }

}
