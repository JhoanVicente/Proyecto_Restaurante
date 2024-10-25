<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Cliente - Pedidos</title>
    <jsp:include page="../../templates/head.jsp"></jsp:include>
</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../assets/images/banner/dashboardClient.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Gestión de Pedidos</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/client/order">Pedidos</a></li>
                    </ul>

                </div>
            </div>
        </div>
    </div>

    <div class="page-section section section-padding">
        <div class="container">
            <div class="row mbn-30">


                <div class="col-lg-2 col-12 mb-30">
                    <div class="myaccount-tab-menu nav" role="tablist">
                        <a href="/client/order" class="active"><i class="fa fa-dashboard"></i>
                             Pedidos</a>
                        <a href="/client/reservation"  ><i class="fa fa-cart-arrow-down"></i> Reservas</a>
                        <a href="/logout"><i class="fa fa-sign-out"></i> Salir</a>
                    </div>
                </div>

                <div class="col-lg-10 col-12 mb-30">
                    <div class="tab-content" id="myaccountContent">
                        <div class="tab-pane fade show active" id="dashboad" role="tabpanel">
                            <div class="myaccount-content">
                                <c:choose>
                                    <c:when test="${viewStatusOrderClient eq 1}">
                                        <h3>Pedidos Pendientes</h3>
                                    </c:when>
                                    <c:when test="${viewStatusOrderClient eq 2}">
                                        <h3>Pedidos Aceptados</h3>
                                    </c:when>
                                    <c:when test="${viewStatusOrderClient eq 3}">
                                        <h3>Pedidos Rechazados</h3>
                                    </c:when>
                                    <c:otherwise>
                                        <h3>Pedidos Completados</h3>
                                    </c:otherwise>
                                </c:choose>

                                <div style="justify-content: center" class="row">

                                    <div class="col-lg-12 col-12">
                                        <form action="/client/order" method="post">
                                            <div class="col-lg-12 col-md-12 col-12 mb-40">
                                                <div class="cart-buttons mb-30">

                                                    <button class="btn bg-success text-bg-dark botonResp" type="submit"
                                                            name="viewStatusOrderClient"
                                                            value="4"><i class="fa fa-check-circle" aria-hidden="true"></i>
                                                        Completado (${countOClientC})
                                                    </button>
                                                    <button class="btn bg-gradient text-bg-dark botonResp" type="submit"
                                                            name="viewStatusOrderClient"
                                                            value="1"><i class="fa fa-hourglass-half" aria-hidden="true"></i>
                                                        Pendiente (${countOClientP})
                                                    </button>
                                                    <button class="btn bg-primary text-bg-dark botonResp" type="submit"
                                                            name="viewStatusOrderClient"
                                                            value="2"><i class="fa fa-star-half-o" aria-hidden="true"></i>
                                                        Aceptado (${countOClientA})
                                                    </button>
                                                    <button class="btn bg-danger text-bg-dark botonResp" type="submit"
                                                            name="viewStatusOrderClient"
                                                            value="3"><i class="fa fa-ban" aria-hidden="true"></i>
                                                        Rechazado (${countOClientR})
                                                    </button>

                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <div class="myaccount-table table-responsive">
                                    <table id="datatable2" class="table table-striped">
                                        <thead>
                                        <tr>
                                            <th>N°</th>
                                            <th>Total de pago</th>
                                            <th>Fecha De Venta</th>
                                            <th>Tipo de Entrega</th>
                                            <th>Modo de Pago</th>
                                            <th>Estado Pedido</th>
                                            <th>Detalle</th>
                                        </tr>
                                        </thead>

                                        <tbody>
                                        <c:forEach var="orderClient" items="${listOrdeByStatusClient}" varStatus="status">
                                            <tr>
                                                <td>${status.count}</td>
                                                <td><fmt:formatNumber value="${orderClient.total}" type="currency"/></td>
                                                <td><fmt:formatDate value="${orderClient.date}" pattern="dd/MMM/yyyy  HH:mm:ss"/></td>
                                                <td>${orderClient.typeDelivery}</td>
                                                <td>${orderClient.typePay}</td>
                                                <td>${orderClient.statusOrder}</td>
                                                <td><a href="/client/order?action=detail&idTicket=${orderClient.idTicket}"
                                                       class="btn btn-success btn-round">Detalles</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>

                                    </table>
                                </div>

                            </div>
                        </div>


                    </div>
                </div>

            </div>
        </div>
    </div>


    <jsp:include page="../../templates/footer.jsp"></jsp:include>


</div>


</body>


</html>