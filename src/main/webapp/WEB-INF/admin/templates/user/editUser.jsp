<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Admin - Editar Usuario</title>
    <jsp:include page="../../../templates/head.jsp"></jsp:include>
</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../../../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../../assets/images/banner/dashboard.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Detalles</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/admin">Volver</a></li>
                    </ul>

                </div>
            </div>
        </div>
    </div>

    <div class="page-section section section-padding">
        <div class="container">
            <form action="/admin?action=modify&idUser=${user.idUsuario}" method="post" class="checkout-form"
                  id="form2" novalidate>
                <div class="row row-50 mbn-40">
                    <div class="col-lg-7">
                        <div id="billing-form" class="mb-20">
                            <h4 class="checkout-title">Datos del Cliente</h4>
                            <div class="row">
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="username">Nombre de Usuario*</label>
                                    <input type="text" class="input-text" name="username" id="username"
                                           placeholder="Ej: PepeJavier" value="${user.username}" required>
                                    <span id="username-error" class="error-message">No puede estar vacío y menos de 30 Caracteres</span>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="password">Contraseña*</label>
                                    <input type="password" class="input-text" name="password" id="password" value="${user.password}" required>
                                    <span id="password-error" class="error-message">No puede estar vacío y menos de 80 Caracteres</span>
                                </div>
                                <input type="hidden" name="originalPassword" value="${user.password}">
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="username">Tipo de Documento*</label>
                                    <input style="background: #dddddd;" type="text" class="input-text" name="tipodocumento" id="tipodocumento"
                                           value="${user.typeDocument}" readonly required>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="username">Número de Documento*</label>
                                    <input style="background: #dddddd;" type="text" class="input-text" name="documentoidentidad"
                                           id="documentoidentidad"
                                           value="${user.numberIdentity}" readonly required>
                                    <span id="documentoidentidad-error" class="error-message">No puede estar vacío y debe ser entre 8 o 9</span>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="names">Nombres*</label>
                                    <input type="text" class="input-text" name="nombre" id="names" value="${user.names}" readonly>
                                    <span id="names-error" class="error-message">No puede estar vacío, solo letras y menos de 20 Caracteres</span>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="lastnames">Apellidos*</label>
                                    <input type="text" class="input-text" name="apellido" id="lastnames" value="${user.lastnames}" readonly>
                                    <span id="lastnames-error" class="error-message">No puede estar vacío, solo letras y menos de 20 Caracteres</span>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="fechanacimiento">Fecha Nacimiento*</label>
                                    <input type="text" class="input-text" id="fechaa"
                                           value="<fmt:formatDate value='${user.date_birth}' pattern='dd/MMM/yyyy' />"
                                           readonly>
                                    <input type="hidden" class="input-text" name="fechanacimiento" id="fechanacimiento"
                                           value="<fmt:formatDate value='${user.date_birth}' pattern='yyyy-MM-dd' />"
                                           readonly>
                                    <span id="fechanacimiento-error" class="error-message">La fecha de nacimiento no puede estar vacía</span>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="address">Dirección*</label>
                                    <input type="text" class="input-text" name="direccion" id="address"
                                           placeholder="av. 727 san vicente" value="${user.address}" required>
                                    <span id="address-error" class="error-message">No puede estar vacío y debe tener menos de 150 caracteres</span>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="phone">Celular*</label>
                                    <input type="text" class="input-text" name="telefono" id="phone"
                                           placeholder="Ej: 98598595" value="${user.phone}">
                                    <span id="phone-error" class="error-message">debe tener 9 digitos de números y comenzar con 9</span>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label for="email">Email*</label>
                                    <input type="email" class="input-text" name="email" id="email"
                                           value="${user.email}" required>
                                    <span id="email-error"
                                          class="error-message">Ingrese un correo electrónico válido</span>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label>Tipo de Usuario*</label>
                                    <select class="nice-select" name="tipousuario" id="tipousuario" required>
                                        <c:forEach var="tipousuario" items="${typeUser}">
                                            <c:choose>
                                                <c:when test="${tipousuario.idTypeUser eq user.typeUser}">
                                                    <option value="${tipousuario.idTypeUser}"
                                                            selected>${tipousuario.nameUser}</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="${tipousuario.idTypeUser}">${tipousuario.nameUser}</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-5">
                        <div class="row">
                            <div class="col-12 mb-40">
                                <h4 class="checkout-title">Historal del Cliente</h4>
                                <div class="checkout-cart-total">
                                    <h4>Usado <span>Total</span></h4>
                                    <ul>
                                        <li>Pedidos <span>${countOrdersByClient}</span></li>
                                        <li>Reservas <span>6</span></li>
                                    </ul>
                                </div>
                                <button type="submit" class="place-order">Actualizar</button>
                                <span id="formulario-error" class="error-message">Error: contiene campos vacíos o demasiado largos</span>
                            </div>
                        </div>
                    </div>

                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../../../templates/footer.jsp"></jsp:include>

</div>
</body>
</html>