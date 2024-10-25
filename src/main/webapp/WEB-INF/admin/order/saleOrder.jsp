<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Los Pinos - Pedidos</title>
    <jsp:include page="../../templates/head.jsp"></jsp:include>
</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../assets/images/banner/dashboard.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Gestión de Pedidos</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/admin/order">Pedidos</a></li>
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
                        <c:if test='${logged.typeUser == 1}'>
                        <a href="/admin/dashboard"><i class="fa fa-dashboard"></i>Dashboard</a>
                        <a href="/admin"><i class="fa fa-users"></i>Usuarios</a>
                        <a href="/admin/product"><i class="fa fa-cutlery"></i>Productos</a>
                        <a href="/admin/category"><i class="fa fa-bars"></i>Categorias</a>
                        </c:if>
                        <a href="/admin/order" class="active"><i class="fa fa-cart-arrow-down"></i>Pedidos</a>
                        <a href="/admin/reservation"><i class="fa fa-calendar-minus-o"></i>Reservaciones</a>
                        <a href="/logout"><i class="fa fa-sign-out"></i> Salir</a>
                    </div>
                </div>

                <div class="col-lg-10 col-12 mb-30">
                    <div class="tab-content" id="myaccountContent">
                        <div class="tab-pane fade show active" id="dashboad" role="tabpanel">
                            <div class="myaccount-content">
                                <c:choose>
                                    <c:when test="${viewStatus eq 1}">
                                        <h3>Pedidos Pendientes</h3>
                                    </c:when>
                                    <c:when test="${viewStatus eq 2}">
                                        <h3>Pedidos Aceptados</h3>
                                    </c:when>
                                    <c:when test="${viewStatus eq 3}">
                                        <h3>Pedidos Rechazados</h3>
                                    </c:when>
                                    <c:otherwise>
                                        <h3>Pedidos Completados</h3>
                                    </c:otherwise>
                                </c:choose>

                                <div style="justify-content: center" class="row">

                                    <form action="/admin/order" method="get">
                                        <div class="product-short col-lg-4 col-md-12 col-12">
                                            <h4>Exportar:</h4>
                                            <select class="nice-select" id="exportOption"
                                                    onchange="exportReport(this.value)">
                                                <option value="">Tipo formato</option>
                                                <option value="generatePDFOrder">PDF</option>
                                                <option value="generateXLSOrder">EXCEL</option>
                                                <option value="generateCSVOrder">CSV</option>
                                            </select>
                                            <script>
                                                function exportReport(action) {
                                                    if (action) {
                                                        var searchUser = document.querySelector('input[name="search"]').value;
                                                        var url = "/admin/order?action=" + action;
                                                        if (searchUser) {
                                                            url += "&search=" + searchUser;
                                                        }
                                                        window.location.href = url;
                                                    }
                                                }
                                            </script>
                                        </div>
                                        <div class="product-short col-lg-4 col-md-12 col-12">
                                            <h4>Tipo:</h4>

                                            <select class="nice-select" id="typeOption"
                                                    onchange="redirectToSearch(this.value)">
                                                <option value="">Seleccionar</option>
                                                <option value="domicilio">Domicilio</option>
                                                <option value="restaurante">Restaurante</option>
                                            </select>
                                            <script>
                                                function redirectToSearch(option) {
                                                    if (option) {
                                                        window.location.href = '/admin/order?search=' + option;
                                                    }
                                                }
                                            </script>
                                        </div>
                                        <div class="product-short col-lg-4 col-md-12 col-12">
                                            <input class="inputResp" type="text" name="search" value="${param.search}"
                                                   placeholder="Buscar: Nombres">
                                            <button type="submit" style="border: none; background: none"><img
                                                    src="/assets/images/icons/search.png" alt="Search"></button>
                                        </div>
                                    </form>
                                    <div class="col-lg-12 col-12">
                                        <form action="/admin/order" method="post">
                                            <div class="col-lg-12 col-md-12 col-12 mb-40">
                                                <div class="cart-buttons mb-30">

                                                    <button class="btn bg-success text-bg-dark botonResp" type="submit"
                                                            name="viewStatus"
                                                            value="4"><i class="fa fa-check-circle" aria-hidden="true"></i>
                                                         Completado (${countStatus4})
                                                    </button>
                                                    <button class="btn bg-gradient text-bg-dark botonResp" type="submit"
                                                            name="viewStatus"
                                                            value="1"><i class="fa fa-hourglass-half" aria-hidden="true"></i>
                                                         Pendiente (${countStatus1})
                                                    </button>
                                                    <button class="btn bg-primary text-bg-dark botonResp" type="submit"
                                                            name="viewStatus"
                                                            value="2"><i class="fa fa-star-half-o" aria-hidden="true"></i>
                                                         Aceptado (${countStatus2})
                                                    </button>
                                                    <button class="btn bg-danger text-bg-dark botonResp" type="submit"
                                                            name="viewStatus"
                                                            value="3"><i class="fa fa-ban" aria-hidden="true"></i>
                                                         Rechazado (${countStatus3})
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
                                            <th>Cliente</th>
                                            <th>Total de pago</th>
                                            <th>Fecha De Venta</th>
                                            <th>Tipo de Entrega</th>
                                            <th>Modo de Pago</th>
                                            <th>Estado del Pedido</th>
                                            <th>Detalle</th>
                                        </tr>
                                        </thead>

                                        <tbody>
                                        <c:forEach var="orderClient" items="${listOrderByStatus}" varStatus="status">
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>${orderClient.names} ${orderClient.lastnames}</td>
                                                <td><fmt:formatNumber value="${orderClient.total}"
                                                                      type="currency"/></td>
                                                <td><fmt:formatDate value="${orderClient.date}"
                                                                    pattern="dd/MMM/yyyy  HH:mm:ss"/></td>
                                                <td>${orderClient.typeDelivery}</td>
                                                <td>${orderClient.typePay}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${orderClient.idStatusOrder eq 3 or orderClient.idStatusOrder eq 4}">
                                                            <c:forEach var="tipoEstado" items="${typeStatus}">
                                                                <c:if test="${tipoEstado.idStatusOrder eq orderClient.idStatusOrder}">
                                                                    ${tipoEstado.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <select name="typeStatus" class="typeStatus"
                                                                    data-id-ticket="${orderClient.idTicket}" required>
                                                                <c:forEach var="tipoEstado" items="${typeStatus}">
                                                                    <c:choose>
                                                                        <c:when test="${tipoEstado.idStatusOrder eq orderClient.idStatusOrder}">
                                                                            <option value="${tipoEstado.idStatusOrder}"
                                                                                    selected>${tipoEstado.name}</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <option value="${tipoEstado.idStatusOrder}">${tipoEstado.name}</option>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </select>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <a href="/admin/order?action=detail&idTicket=${orderClient.idTicket}"
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

<script>
    document.querySelectorAll('.typeStatus').forEach(function (selectElement) {
        selectElement.addEventListener('change', function () {
            var idTicket = this.getAttribute('data-id-ticket');
            changeStatusOrder(this.value, 'status', idTicket);
        });
    });

    function changeStatusOrder(idStatusOrder, action, idTicket) {
        window.location.href = '/admin/order?action=' + action + '&idStatusOrder=' + idStatusOrder + '&idTicket=' + idTicket;
    }
</script>

</body>


</html>