<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Los Pinos - Usuarios</title>
    <jsp:include page="../../templates/head.jsp"></jsp:include>
</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../assets/images/banner/dashboard.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Dashboard</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/admin">Usuarios</a></li>
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
                        <a href="/admin" class="active"><i class="fa fa-users"></i>Usuarios</a>
                        <a href="/admin/product"><i class="fa fa-cutlery"></i>Productos</a>
                        <a href="/admin/category"><i class="fa fa-bars"></i>Categorias</a>
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
                                    <c:when test="${userStatus eq 0}">
                                        <h3>Usuarios Inactivos</h3>
                                    </c:when>
                                    <c:otherwise>
                                        <h3>Usuarios Activos</h3>
                                    </c:otherwise>
                                </c:choose>

                                <div style="justify-content: center" class="row">
                                    <form action="/admin" method="get">
                                        <div class="product-short col-lg-4 col-md-12 col-12">
                                            <h4>Exportar:</h4>
                                            <select class="nice-select" id="exportOption"
                                                    onchange="exportReport(this.value)">
                                                <option value="">Tipo formato</option>
                                                <option value="generatePDFUsers">PDF</option>
                                                <option value="generateXLSUsers">EXCEL</option>
                                                <option value="generateCSVUsers">CSV</option>
                                                <option value="generatePDFUsersJasperA">PDF REPORT ACTIVO</option>
                                                <option value="generatePDFUsersJasperI">PDF REPORT INACTIVO</option>
                                            </select>
                                            <script>
                                                function exportReport(action) {
                                                    if (action) {
                                                        var searchUser = document.querySelector('input[name="search"]').value;
                                                        var url = "/admin?action=" + action;
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
                                                <c:forEach var="tipousuario"
                                                           items="${typeUser}">
                                                    <option value="${tipousuario.nameUser}">${tipousuario.nameUser}</option>
                                                </c:forEach>
                                            </select>
                                            <script>
                                                function redirectToSearch(option) {
                                                    if (option) {
                                                        window.location.href = '/admin?search=' + option;
                                                    }
                                                }
                                            </script>
                                        </div>
                                        <div class="product-short col-lg-4 col-md-12 col-12">
                                            <input class="inputResp" type="text" name="search"
                                                   value="${param.search}"
                                                   placeholder="Buscar: usuario">
                                            <button type="submit" style="border: none; background: none"><img
                                                    src="/assets/images/icons/search.png" alt="Search"></button>
                                        </div>
                                    </form>
                                    <div class="col-lg-12 col-12">
                                        <form action="/admin" method="post">
                                            <div class="col-lg-12 col-md-12 col-12 mb-40">
                                                <div class="cart-buttons mb-30">

                                               
                                                    <button class="btn bg-success text-bg-dark botonResp" type="submit"
                                                            name="userStatus" value="1"><i class="fa fa-user"
                                                                                           aria-hidden="true"></i>
                                                        Usuarios Activos (${countStatusA})
                                                    </button>

                                                    <button class="btn bg-danger text-bg-dark botonResp" type="submit"
                                                            name="userStatus" value="0"><i class="fa fa-user-times"
                                                                                           aria-hidden="true"></i>
                                                        Usuarios Inactivos (${countStatusI})
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
                                                <h4 class="modal-title">Registrar Usuario</h4>
                                                <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                            </div>

                                            <div class="modal-body">
                                                <div class="login-register-form-wrap">
                                                    <c:if test="${mensajer !=null}">
                                                        <div class="alert alert-info" role="alert">
                                                                ${mensajer}
                                                        </div>
                                                    </c:if>
                                                    <form action="/admin?action=insert"
                                                          method="post" id="form2" novalidate>
                                                        <div class="row">
                                                            <div class="col-md-6 col-12 mb-5">
                                                                <label for="username">Nombre de Usuario*</label>
                                                                <input type="text" class="input-text" name="username"
                                                                       id="username"
                                                                       placeholder="Ej: PepeJavier" required>
                                                                <span id="username-error" class="error-message">No puede estar vacío y menos de 30 Caracteres</span>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-5">
                                                                <label for="password">Contraseña*</label>
                                                                <input type="password" class="input-text"
                                                                       name="password" id="password" required>
                                                                <span id="password-error" class="error-message">No puede estar vacío y menos de 80 Caracteres</span>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label for="tipodocumento">Tipo De Documento*</label>
                                                                <select name="tipodocumento" id="tipodocumento"
                                                                        required>
                                                                    <option value="" selected disabled>Seleccione
                                                                    </option>
                                                                    <option value="DNI">DNI</option>
                                                                    <option value="CE">Carnet de Extranjeria</option>
                                                                </select>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label for="documentoidentidad">Número
                                                                    Documento*</label>
                                                                <div style="display: flex">
                                                                    <input style="width: 70%" type="text"
                                                                           class="form-control"
                                                                           id="documentoidentidad"
                                                                           name="documentoidentidad"
                                                                           placeholder="Ej: 72088888" required>
                                                                    <div class="input-group-append">
                                                                        <button class="btn btn-primary" type="button"
                                                                                id="buscarCliente">Validar
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                                <span id="documentoidentidad-error"
                                                                      class="error-message"> </span>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-5">
                                                                <label for="names">Nombres*</label>
                                                                <input type="text" class="input-text" name="nombre"
                                                                       id="names" readonly>
                                                                <span id="names-error" class="error-message">No puede estar vacío, solo letras</span>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-5">
                                                                <label for="lastnames">Apellidos*</label>
                                                                <input type="text" class="input-text" name="apellido"
                                                                       id="lastnames" readonly>
                                                                <span id="lastnames-error" class="error-message">No puede estar vacío, solo letras</span>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-5">
                                                                <label for="fechanacimiento">Fecha Nacimiento*</label>
                                                                <input type="date" class="input-text"
                                                                       name="fechanacimiento" id="fechanacimiento"
                                                                       readonly>
                                                                <span id="fechanacimiento-error" class="error-message">La fecha de nacimiento no puede estar vacía</span>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-5">
                                                                <label for="address">Dirección*</label>
                                                                <input type="text" class="input-text" name="direccion"
                                                                       id="address"
                                                                       placeholder="av. 727 san vicente" required>
                                                                <span id="address-error" class="error-message">No puede estar vacío y debe tener menos de 100 caracteres</span>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-5">
                                                                <label for="phone">Celular*</label>
                                                                <input type="text" class="input-text" name="telefono"
                                                                       id="phone"
                                                                       placeholder="Ej: 98598595">
                                                                <span id="phone-error" class="error-message">debe tener 9 digitos de números y comenzar con 9</span>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-5">
                                                                <label for="email">Email*</label>
                                                                <input type="email" class="input-text" name="email"
                                                                       id="email" required>
                                                                <span id="email-error"
                                                                      class="error-message">Ingrese un correo electrónico válido</span>
                                                            </div>

                                                            <c:if test="${logged.typeUser eq 1}">
                                                                <div class="col-md-6 col-12 mb-15">
                                                                    <label>Tipo de Usuario*</label>
                                                                    <select name="tipousuario" id="tipousuario"
                                                                            required>
                                                                        <c:forEach var="tipousuario"
                                                                                   items="${typeUser}">
                                                                            <option value="${tipousuario.idTypeUser}">${tipousuario.nameUser}</option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                            </c:if>

                                                            <div class="col-md-6 col-12">
                                                                <br>
                                                                <input type="submit" value="Registrarse">
                                                                <span id="formulario-error" class="error-message">Error: contiene campos vacíos o demasiado largos</span>
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
                                            <th>Usuario</th>
                                            <th>Nombre y Apellidos</th>
                                            <th>DNI / CE</th>
                                            <th>Tipo</th>
                                            <th>Acción</th>
                                        </tr>
                                        </thead>

                                        <tbody>
                                        <c:forEach var="usuario" items="${listUsersByStatus}"
                                                   varStatus="status">
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>${usuario.username}</td>
                                                <td>${usuario.names} ${usuario.lastnames}</td>
                                                <td>${usuario.numberIdentity}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${typeUser != null}">
                                                            <c:forEach var="tipousuario"
                                                                       items="${typeUser}">
                                                                <c:if test="${tipousuario.idTypeUser eq usuario.typeUser}">
                                                                    ${tipousuario.nameUser}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            Tipo de Usuario no fue encontrado
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${usuario.status eq false}">
                                                            <a onclick="confirmRestore('${usuario.idUsuario}')"
                                                               class="btn btn-success btn-round">Activar</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a onclick="confirmDelete('${usuario.idUsuario}')"
                                                               class="btn btn-danger btn-round">Eliminar</a>
                                                            <a href="/admin?action=edit&idUser=${usuario.idUsuario}"
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
                text: 'Deseas eliminar este usuario',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, eliminarlo',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '/admin?action=delete&idUser=' + idUsuario;
                }
            });
        }

        function confirmRestore(idUsuario) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: 'Deseas restaurar este usuario',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, restaurarlo',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '/admin?action=restore&idUser=' + idUsuario;
                }
            });
        }
    </script>
    <jsp:include page="../../templates/footer.jsp"></jsp:include>


</div>


</body>


</html>