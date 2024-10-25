<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Cliente - Reservaciones</title>
    <jsp:include page="../../templates/head.jsp"></jsp:include>
</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../assets/images/banner/dashboardClient.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Gestión de Reservaciones</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/client/reservation">Reservas</a></li>
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
                        <a href="/client/order"><i class="fa fa-dashboard"></i>
                            Pedidos</a>
                        <a href="/client/reservation" class="active" ><i class="fa fa-cart-arrow-down"></i> Reservas</a>
                        <a href="/logout"><i class="fa fa-sign-out"></i> Salir</a>
                    </div>
                </div>

                <div class="col-lg-10 col-12 mb-30">
                    <div class="tab-content" id="myaccountContent">
                        <div class="tab-pane fade show active" id="dashboad" role="tabpanel">
                            <div class="myaccount-content">
                                <c:choose>
                                    <c:when test="${viewStatusReservationClient eq 1}">
                                        <h3>Reservaciones Pendientes</h3>
                                    </c:when>
                                    <c:when test="${viewStatusReservationClient eq 2}">
                                        <h3>Reservaciones Aceptados</h3>
                                    </c:when>
                                    <c:when test="${viewStatusReservationClient eq 3}">
                                        <h3>Reservaciones Rechazados</h3>
                                    </c:when>
                                    <c:otherwise>
                                        <h3>Reservaciones Completados</h3>
                                    </c:otherwise>
                                </c:choose>

                                <div style="justify-content: center" class="row">

                                    <div class="col-lg-12 col-12">
                                        <form action="/client/reservation" method="post">
                                            <div class="col-lg-12 col-md-12 col-12 mb-40">
                                                <div class="cart-buttons mb-30">

                                                    <button class="btn bg-success text-bg-dark botonResp" type="submit"
                                                            name="viewStatusReservationClient"
                                                            value="4"><i class="fa fa-check-circle" aria-hidden="true"></i>
                                                        Completado (${countRClientC})
                                                    </button>
                                                    <button class="btn bg-gradient text-bg-dark botonResp" type="submit"
                                                            name="viewStatusReservationClient"
                                                            value="1"><i class="fa fa-hourglass-half" aria-hidden="true"></i>
                                                        Pendiente (${countRClientP})
                                                    </button>
                                                    <button class="btn bg-primary text-bg-dark botonResp" type="submit"
                                                            name="viewStatusReservationClient"
                                                            value="2"><i class="fa fa-star-half-o" aria-hidden="true"></i>
                                                        Aceptado (${countRClientA})
                                                    </button>
                                                    <button class="btn bg-danger text-bg-dark botonResp" type="submit"
                                                            name="viewStatusReservationClient"
                                                            value="3"><i class="fa fa-ban" aria-hidden="true"></i>
                                                        Rechazado (${countRClientR})
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
                                            <th>Nombre</th>
                                            <th>Fecha y Hora</th>
                                            <th>Personas</th>
                                            <th>Nota</th>
                                            <th>Estado de la Reserva</th>
                                            <th>Detalle</th>
                                        </tr>
                                        </thead>

                                        <tbody>
                                        <c:forEach var="orderClient" items="${listReservation}" varStatus="status">
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>${orderClient.nameClient}</td>
                                                <td>
                                                    <fmt:formatDate value="${orderClient.date}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td>${orderClient.quantityPeople}</td>
                                                <td>${orderClient.note}</td>
                                                <td>${orderClient.statusStr}</td>
                                                <td><a href="/client/reservation?action=detail&idReservation=${orderClient.idClientReservation}"
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