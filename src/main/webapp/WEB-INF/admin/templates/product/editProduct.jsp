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

    <div class="page-banner-section section"
         style="background-image: url(../../../../assets/images/banner/dashboard.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">

                    <h1>Detalles</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/admin/product">Volver</a></li>
                    </ul>

                </div>
            </div>
        </div>
    </div>

    <div class="page-section section section-padding">
        <div class="container">
            <form action="/admin/product?action=modify&idProduct=${producto.idProducto}" enctype="multipart/form-data"
                  method="post"
                  class="checkout-form">
                <div class="row row-50 mbn-40">
                    <div class="col-lg-7">
                        <div id="billing-form" class="mb-20">
                            <h4 class="checkout-title">Datos del Cliente</h4>
                            <div class="row">
                                <div class="col-md-6 col-12 mb-5">
                                    <label>Nombre*</label>
                                    <input type="text" class="input-text" name="name" id="name"
                                           value="${producto.name}" required>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label>Categoría*</label>
                                    <select name="idCategory" id="idCategory" required>
                                        <c:forEach var="tipocategoria" items="${typeCategorys}">
                                            <c:choose>
                                                <c:when test="${tipocategoria.idCategoryProducto eq producto.idCategory}">
                                                    <option value="${tipocategoria.idCategoryProducto}"
                                                            selected>${tipocategoria.name}</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="${tipocategoria.idCategoryProducto}">${tipocategoria.name}</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label>Descripción*</label>
                                    <input type="text" class="input-text" name="note" id="note" value="${producto.note}"
                                           placeholder="Nota" required>
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label>Precio*</label>
                                    <input class="input-text" type="number" name="price" id="price" placeholder="Precio"
                                           step="0.01" value="${producto.price}" required>
                                </div>
                                <div class="col-md-6 col-12 mb-25">
                                    <label>Imagen Actual</label>
                                    <img src="../foto/${producto.image}" alt="Imagen del producto actual" width="100"
                                         height="100">
                                </div>
                                <input type="hidden" name="currentImage" value="${producto.image}">
                                <div class="col-md-6 col-12 mb-25">
                                    <label>Nueva Imagen</label>
                                    <input class="form-control" type="file" name="image" id="image" accept="image/*">
                                </div>
                                <div class="col-md-6 col-12 mb-5">
                                    <label>------------</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-5">
                        <div class="row">
                            <div class="col-12 mb-40">
                                <h4 class="checkout-title">Historal del Producto</h4>
                                <div class="checkout-cart-total">
                                    <h4>Usado <span>Total</span></h4>
                                    <ul>
                                        <li>Pedidos <span>10</span></li>
                                    </ul>
                                </div>
                                <button type="submit" class="place-order">Actualizar</button>
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