<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Los Pinos - Catálogo</title>
    <jsp:include page="../templates/head.jsp"></jsp:include>
</head>
<body>


<div class="main-wrapper">

    <jsp:include page="../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(https://static.vecteezy.com/system/resources/previews/019/775/321/non_2x/restaurant-interior-cartoon-vector.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">

                    <h1>Catálogo</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/inicio">Inicio</a></li>
                        <li><a href="/catalogo">Catálogo</a></li>
                    </ul>

                </div>
            </div>
        </div>
    </div>
   
    <div class="product-section section section-padding">
        <div class="container">

            <div class="row">
                <div class="section-title text-center col mb-30">
                    <h1>Productos Destacados</h1>
                    <p>Todos nuestros Productos</p>
                </div>
            </div>

            <div style="justify-content: center" class="row">

                <form action="/catalogo" method="get">
                    <div class="product-short col-lg-4 col-md-12 col-12">
                        <h4>Categoría:</h4>
                        <select class="nice-select" id="typeOption"
                                onchange="redirectToSearch(this.value)">
                            <option value="">Seleccionar</option>
                            <c:forEach var="tipocategoria"
                                       items="${typeCategorys}">
                                <option value="${tipocategoria.name}">${tipocategoria.name}</option>
                            </c:forEach>
                        </select>
                        <script>
                            function redirectToSearch(option) {
                                if (option) {
                                    window.location.href = '/catalogo?search=' + option;
                                }
                            }
                        </script>
                    </div>
                    <div class="product-short col-lg-4 col-md-12 col-12">
                        <input class="inputResp" type="text" name="search"
                               value="${param.search}"
                               placeholder="nombres, categoría">
                        <button type="submit" style="border: none; background: none"><img
                                src="/assets/images/icons/search.png" alt="Search"></button>
                    </div>
                </form>

            </div>


            <div class="row mbn-40">
                <c:forEach var="product" items="${productsViews}">
                    <div class="col-xl-3 col-lg-4 col-md-4 col-6 mb-40">

                        <div class="product-item">
                            <div class="product-inner">

                                <div class="image">
                                    <img src="./foto/${product.image}" alt="${product.name}">
                                    <div class="image-overlay">
                                        <div class="action-buttons">
                                            <a href="/cart?action=order&idProduct=${product.idProducto}">Agregar Carrito</a>
                                            <a href="/detalle-producto?idProduct=${product.idProducto}">Ver Detalle</a>
                                        </div>
                                    </div>

                                </div>

                                <div class="content">

                                    <div class="content-left">

                                        <h4 class="title"><a href="#">${product.name}</a></h4>

                                        <div class="ratting">
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star-half-o"></i>
                                            <i class="fa fa-star-o"></i>
                                        </div>
                                        <h5 class="size">
                                        <c:choose>
                                            <c:when test="${typeCategorys != null}">
                                                <c:forEach var="typeCategory" items="${typeCategorys}">
                                                    <c:if test="${typeCategory.idCategoryProducto eq product.idCategory}">
                                                        Categoría: ${typeCategory.name}
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                Tipo de Category no encontrado
                                            </c:otherwise>
                                        </c:choose>
                                        </h5>

                                    </div>

                                    <div class="content-right">
                                        <span class="price"><fmt:formatNumber value="${product.price}" type="currency"/></span>
                                    </div>

                                </div>

                            </div>
                        </div>

                    </div>

                </c:forEach>



            </div>

        </div>
    </div>

    <jsp:include page="../templates/footer.jsp"></jsp:include>

</div>


</body>


</html>