<%@ page import="pe.edu.vallegrande.sysrestaurant.dto.user.UserDto" %>
<%@ page import="pe.edu.vallegrande.sysrestaurant.dto.order.OrderDto" %>
<%@ page import="pe.edu.vallegrande.sysrestaurant.dto.order.OrderDto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Detalles de la Orden</title>
    <jsp:include page="../head.jsp"></jsp:include>
</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../assets/images/banner/dashboard.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Detalles</h1>
                    <ul class="page-breadcrumb">
                      <c:choose>
                          <c:when test="${logged.typeUser == 1 || logged.typeUser == 2}">
                              <li>
                                  <a href="/admin/order">Volver</a>
                              </li>
                          </c:when>
                          <c:otherwise>
                                <li>
                                    <a href="/client/order">Volver</a>
                                </li>
                          </c:otherwise>
                      </c:choose>
                    </ul>

                </div>
            </div>
        </div>
    </div>

    <!-- Page Section Start -->
    <div class="page-section section section-padding">
        <div class="container">

            <!-- Checkout Form s-->
            <form action="#" class="checkout-form">
                <div class="row row-50 mbn-40">


                    <div class="col-lg-7">

                        <!-- Billing Address -->
                        <div id="billing-form" class="mb-20">
                            <h4 class="checkout-title">Detalles Personales</h4>
                            <div class="row">
                                <div class="col-md-6 col-12 mb-5">
                                    <label>Nombres*</label>
                                    <input type="text" value="${orderTicket.names}" readonly>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Apellidos*</label>
                                    <input type="text" value="${orderTicket.lastnames}" readonly>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Email*</label>
                                    <input type="text" value="${orderTicket.email}" readonly>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Teléfono*</label>
                                    <input type="text" value="${orderTicket.phone}" readonly>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Tipo de Documento*</label>
                                    <input type="text" value="${orderTicket.typeDocument}" readonly>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Número Documento*</label>
                                    <input type="text" value="${orderTicket.numberDocument}" readonly>
                                </div>

                                <h4 class="checkout-title">Detalles De la Entrega</h4>

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Fecha de la Venta*</label>
                                    <input type="text"
                                           value="<fmt:formatDate value="${orderTicket.date}" pattern="dd/MMM/yyyy  HH:mm:ss"/>"
                                           readonly>
                                </div>

                                <%
                                    OrderDto orderTicket = (OrderDto) request.getAttribute("orderTicket");
                                    String formattedIdTicket = "";
                                    if (orderTicket != null) {
                                        int idTicket = orderTicket.getIdTicket();
                                        formattedIdTicket = String.format("%06d", idTicket);
                                    }
                                %>
                                <div class="col-md-6 col-12 mb-5">
                                    <label>Número de Boleta*</label>
                                    <input type="text" value="<%= formattedIdTicket %>" readonly>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Tipo de pago *</label>
                                    <input type="text" value="${orderTicket.typePay}" readonly>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label>Estado de Pedido*</label>
                                    <input type="text" value="${orderTicket.statusOrder}" readonly>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Tipo de Entrega*</label>
                                    <input type="text" value="${orderTicket.typeDelivery}" readonly>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label>Requerimiento Especial*</label>
                                    <input type="text" value="${orderTicket.note}" readonly>
                                </div>
                                <c:if test="${orderTicket.addressDelivery  != null and not empty orderTicket.addressDelivery}">
                                    <div class="col-12 mb-5">
                                        <label>Dirección de Entrega*</label>
                                        <input type="text" value="${orderTicket.addressDelivery}" readonly>
                                    </div>
                                </c:if>

                            </div>

                        </div>


                    </div>

                    <div class="col-lg-5">
                        <div class="row">

                            <!-- Cart Total -->
                            <div class="col-12 mb-40">

                                <h4 class="checkout-title">Detalle de los Productos</h4>

                                <div class="checkout-cart-total">

                                    <h4>Producto <span>SubTotal</span></h4>

                                    <ul>
                                        <c:forEach var="product" items="${listOrderProductDetail}">
                                            <li>${product.nameProduct} x  ${product.quantity} <span><fmt:formatNumber value="${product.price * product.quantity}" type="currency"/> </span></li>
                                        </c:forEach>
                                    </ul>
                                    <c:set var="subtotal" value="${orderTicket.total / 1.18}" />
                                    <c:set var="igv" value="${subtotal * 0.18}" />

                                    <h4>Subtotal <span><fmt:formatNumber value="${subtotal}" type="currency"/></span></h4>
                                    <h4>IGV <span><fmt:formatNumber value="${igv}" type="currency"/></span></h4>
                                    <h4>Total <span><fmt:formatNumber value="${orderTicket.total}" type="currency"/></span></h4>

                                </div>

                            </div>

                            <c:if test="${orderTicket.statusOrder == 'Completado'}">
                            <div class="col-12 mb-40">
                                <a class="place-order bg-danger" href="/client/order?action=generatePDFTicket&idTicket=${orderTicket.idTicket}">Generar Boleta</a>
                            </div>
                            </c:if>


                        </div>
                    </div>

                </div>
            </form>

        </div>
    </div><!-- Page Section End -->


    <jsp:include page="../footer.jsp"></jsp:include>


</div>

</body>


</html>