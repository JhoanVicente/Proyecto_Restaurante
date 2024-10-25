<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Los Pinos - Login / Registro</title>
    <jsp:include page="../templates/head.jsp"></jsp:include>
</head>

<body>

<div class="main-wrapper">

    <jsp:include page="../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(/assets/images/banner/dashboardClient.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Login y Registrar</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/login">Login</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="page-section section section-padding">
        <div class="container">
            <div class="row mbn-40">

                <div class="col-lg-4 col-12 mb-40">
                    <div class="login-register-form-wrap">
                        <h3>Login</h3>
                        <c:if test="${mensaje !=null}">
                            <div class="alert alert-danger" role="alert">
                                    ${mensaje}
                            </div>
                        </c:if>
                        <form action="/auth" method="post" id="myForm" class="mb-30 was-validated">
                            <div class="row">

                                <input type="hidden" name="action" value="login">
                                <div class="col-12 mb-15">
                                    <label for="username">Usuario o Correo*</label>
                                    <input type="text" class="input-text" name="username" id="username1"
                                           placeholder="Username o Email">
                                    <span id="username-error1" class="error-message">No puede estar vacío</span>
                                </div>
                                <div class="col-12 mb-15">
                                    <label for="password">Contraseña*</label>
                                    <input type="password" class="input-text" name="password" id="password1">
                                    <span id="password-error1" class="error-message">No puede estar vacío</span>
                                </div>

                                <div class="col-12"><input type="submit" value="Login">
                                    <span id="formulario-error1" class="error-message">Error: contiene campos vacíos o demasiado largos</span>

                                </div>

                            </div>
                        </form>
                    </div>
                </div>

                <div class="col-lg-2 col-12 mb-40 text-center d-none d-lg-block">
                    <span class="login-register-separator"></span>
                </div>

                <div class="col-lg-6 col-12 mb-40 ms-auto">
                    <div class="login-register-form-wrap">
                        <h3>Register</h3>
                        <c:if test="${mensajer !=null}">
                            <div class="alert alert-info" role="alert">
                                    ${mensajer}
                            </div>
                        </c:if>
                        <form action="/auth" method="post" id="form2" novalidate>
                            <div class="row">

                                <input type="hidden" name="action" value="register">

                                <div class="col-md-6 col-12 mb-5">
                                    <label for="username">Nombre de Usuario*</label>
                                    <input type="text" class="input-text" name="username" id="username"
                                           placeholder="Ej: PepeJavier" required>
                                    <span id="username-error" class="error-message">No puede estar vacío y menos de 30 Caracteres</span>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label for="password">Contraseña*</label>
                                    <input type="password" class="input-text" name="password" id="password" required>
                                    <span id="password-error" class="error-message">No puede estar vacío y menos de 80 Caracteres</span>
                                </div>

                                <div class="col-md-6 col-12 mb-15">
                                    <label for="tipodocumento">Tipo De Documento*</label>
                                    <select name="tipodocumento" id="tipodocumento" required>
                                        <option value="" selected disabled>Seleccione</option>
                                        <option value="DNI">DNI</option>
                                        <option value="CE">Carnet de Extranjeria</option>
                                    </select>
                                </div>

                                <div class="col-md-6 col-12 mb-15">
                                    <label for="documentoidentidad">Número Documento*</label>
                                    <div style="display: flex">
                                        <input style="width: 70%" type="text" class="form-control"
                                               id="documentoidentidad" name="documentoidentidad"
                                               placeholder="Ej: 72088888" required>
                                        <div class="input-group-append">
                                        </div>
                                    </div>
                                    <span id="documentoidentidad-error" class="error-message"> </span>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label for="names">Nombres*</label>
                                    <input type="text" class="input-text" name="nombre" id="names">
                                    <span id="names-error" class="error-message">No puede estar vacío, solo letras</span>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label for="lastnames">Apellidos*</label>
                                    <input type="text" class="input-text" name="apellido" id="lastnames">
                                    <span id="lastnames-error" class="error-message">No puede estar vacío, solo letras</span>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label for="fechanacimiento">Fecha Nacimiento*</label>
                                    <input type="date" class="input-text" name="fechanacimiento" id="fechanacimiento"
                                           >
                                    <span id="fechanacimiento-error" class="error-message">La fecha de nacimiento no puede estar vacía</span>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label for="address">Dirección*</label>
                                    <input type="text" class="input-text" name="direccion" id="address"
                                           placeholder="av. 727 san vicente" required>
                                    <span id="address-error" class="error-message">No puede estar vacío y debe tener menos de 100 caracteres</span>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label for="phone">Celular*</label>
                                    <input type="text" class="input-text" name="telefono" id="phone"
                                           placeholder="Ej: 98598595">
                                    <span id="phone-error" class="error-message">debe tener 9 digitos de números y comenzar con 9</span>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label for="email">Email*</label>
                                    <input type="email" class="input-text" name="email" id="email" required>
                                    <span id="email-error"
                                          class="error-message">Ingrese un correo electrónico válido</span>
                                </div>

                                <div class="col-md-6 col-12">
                                    <br>
                                    <input type="submit" value="Registrarse">
                                    <span id="formulario-error" class="error-message">Error: contiene campos vacíos o demasiado largos</span>
                                </div>
                            </div>
                        </form>

                    </div>
                </div>

            </div>
        </div>
    </div>


    <jsp:include page="../templates/footer.jsp"></jsp:include>

</div>


</body>

</html>