<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Admin - Usuarios</title>
    <jsp:include page="../../../templates/head.jsp"></jsp:include>

</head>
<body>


<div class="main-wrapper">

    <jsp:include page="../../../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../../assets/images/hero/hero-1.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">

                    <h1>Detalles</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/category">Volver</a></li>
                    </ul>

                </div>
            </div>
        </div>
    </div>

    <div class="page-section section section-padding">
        <div class="container">

            <form action="/admin/category?action=modify&idCategory=${categoria.idCategoryProducto}"   method="post" class="checkout-form">

                <div class="row row-50 mbn-40">

                    <div class="col-lg-7">

                        <div id="billing-form" class="mb-20">
                            <h4 class="checkout-title">Datos de la Categoria</h4>

                            <div class="row">

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Nombre*</label>
                                    <input type="text" class="input-text"  name="name" id="name"
                                           value="${categoria.name}" required>
                                </div>


                            </div>

                        </div>


                    </div>

                    <div class="col-lg-5">
                        <div class="row">

                            <div class="col-12 mb-40">

                                <h4 class="checkout-title">Acción</h4>


                                <button type="submit" class="place-order text-center">Actualizar</button>

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