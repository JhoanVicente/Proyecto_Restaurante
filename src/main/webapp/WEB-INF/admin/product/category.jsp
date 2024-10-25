<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Los Pinos - Categoría</title>
    <jsp:include page="../../templates/head.jsp"></jsp:include>
</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../assets/images/banner/dashboard.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Gestión de Categoría</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/admin/category">Categoría</a></li>
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
                        <a href="/admin/category" class="active"><i class="fa fa-bars"></i>Categorias</a>
                        </c:if>
                        <a href="/admin/order"><i class="fa fa-cart-arrow-down"></i>Pedidos</a>
                        <a href="/admin/reservation"><i class="fa fa-calendar-minus-o"></i>Reservaciones</a>
                        <a href="/logout"><i class="fa fa-sign-out"></i> Salir</a>
                    </div>
                </div>

                <div class="col-lg-10 col-12 mb-30">
                    <div class="tab-content" id="myaccountContent">
                        <div class="tab-pane fade show active" id="dashboad" role="tabpanel">
                            <div class="myaccount-content">
                                <c:choose>
                                    <c:when test="${categoryStatus eq 0}">
                                        <h3>Categorías Inactivos</h3>
                                    </c:when>
                                    <c:otherwise>
                                        <h3>Categorías Activos</h3>
                                    </c:otherwise>
                                </c:choose>

                                <div style="justify-content: center" class="row">

                                    <div class="col-lg-12 col-12">
                                        <form action="/admin/category" method="post">
                                            <div class="col-lg-12 col-md-12 col-12 mb-40">
                                                <div class="cart-buttons mb-30">

                                                    <button type="button" class="btn bg-dark text-bg-dark botonResp"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#myModal"><i class="fa fa-plus-circle"
                                                                                         aria-hidden="true"></i>
                                                        Registrar Categoría
                                                    </button>
                                                    <button class="btn bg-success text-bg-dark botonResp" type="submit"
                                                            name="categoryStatus" value="1"><i class="fa fa-eye"
                                                                                              aria-hidden="true"></i>
                                                        Categoría Activos (${countCategoryA})
                                                    </button>

                                                    <button class="btn bg-danger text-bg-dark botonResp" type="submit"
                                                            name="categoryStatus" value="0"><i class="fa fa-eye-slash"
                                                                                              aria-hidden="true"></i>
                                                        Categoría Inactivos (${countCategoryI})
                                                    </button>

                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <div class="modal" id="myModal">
                                    <div class="modal-dialog">
                                        <div class="modal-content">

                                            <div class="modal-header">
                                                <h4 class="modal-title">Registrar Categoría</h4>
                                                <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                            </div>

                                            <div class="modal-body">
                                                <div class="login-register-form-wrap">
                                                    <form action="/admin/category?action=insert" method="post"
                                                          class="was-validated">
                                                        <div class="row">

                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Nombre*</label>
                                                                <input class="form-control" type="text" name="name"
                                                                       id="name" placeholder="Ingresa el nombre"
                                                                       required>
                                                            </div>
                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Registrar*</label>
                                                                <input type="submit" value="Registrar">
                                                            </div>

                                                        </div>
                                                    </form>
                                                    <br/>
                                                    <h3>Registrar Categorías Masivamente</h3>
                                                    <form action="/admin/category?action=insertMultiple" method="post"  class="was-validated">
                                                        <div class="row">
                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Datos Generados de Google Sheet*</label>
                                                            </div>
                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Registrar*</label>
                                                                <input type="submit" value="Registrar">
                                                            </div>
                                                        </div>
                                                    </form>

                                                </div>
                                            </div>

                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-danger" data-bs-dismiss="modal">
                                                    Close
                                                </button>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                                <div class="myaccount-table table-responsive">
                                    <table id="datatable2" class="table table-striped">
                                        <thead>
                                        <tr>
                                            <th>N°</th>
                                            <th>Nombre</th>
                                            <th>Acción</th>
                                        </tr>
                                        </thead>

                                        <tbody>
                                        <c:forEach var="categoria" items="${typeCategorys}" varStatus="status">
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>${categoria.name}</td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${categoria.status eq false}">
                                                        <a onclick="confirmRestore('${categoria.idCategoryProducto}')"
                                                           class="btn btn-success btn-round">Activar</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a onclick="confirmDelete('${categoria.idCategoryProducto}')"
                                                           class="btn btn-danger btn-round">Eliminar</a>
                                                        <a href="/admin/category?action=edit&idCategory=${categoria.idCategoryProducto}"
                                                           class="btn btn-dark btn-round">Editar</a>
                                                    </c:otherwise>
                                                </c:choose>
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

    <script>
        function confirmDelete(idUsuario) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: 'Deseas eliminar esta Categoría',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, eliminarlo',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = ' /admin/category?action=delete&idCategory=' + idUsuario;
                }
            });
        }

        function confirmRestore(idUsuario) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: 'Deseas restaurar esta Categoría',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, restaurarlo',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = ' /admin/category?action=restore&idCategory=' + idUsuario;
                }
            });
        }
    </script>
    <jsp:include page="../../templates/footer.jsp"></jsp:include>


</div>


</body>


</html>