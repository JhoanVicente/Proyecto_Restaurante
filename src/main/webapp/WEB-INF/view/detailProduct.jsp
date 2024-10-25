<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Los Pinos - Inicio</title>
    <jsp:include page="../templates/head.jsp"></jsp:include>
</head>
<body>


<div class="main-wrapper">

    <jsp:include page="../templates/header.jsp"></jsp:include>


    <!-- Page Section Start -->
    <div class="page-section section section-padding">
        <div class="container">
            <div class="row row-30 mbn-50">

                <div class="col-12">
                    <div style="justify-content: center; align-content: center" class="row row-20 mb-10">

                        <div class="col-lg-3 col-12 mb-40">

                            <div class="pro-large-img mb-10">
                                    <img src="./foto/${product.image}" alt="${product.name}"/>
                            </div>

                        </div>

                        <div class="col-lg-5 col-12 mb-40">
                            <div class="single-product-content">

                                <div class="head">
                                    <div class="head-left">

                                        <h3 class="title">${product.name}</h3>

                                        <div class="ratting">
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star-half-o"></i>
                                            <i class="fa fa-star-o"></i>
                                        </div>

                                    </div>

                                    <div class="head-right">
                                        <span class="price"><fmt:formatNumber value="${product.price}" type="currency"/></span>
                                    </div>
                                </div>

                                <div class="description">
                                    <p>${product.note}</p>
                                </div>

                                <span class="availability">Categoría: <span>
                                    <c:choose>
                                    <c:when test="${typeCategorys != null}">
                                        <c:forEach var="typeCategory" items="${typeCategorys}">
                                            <c:if test="${typeCategory.idCategoryProducto eq product.idCategory}">
                                               ${typeCategory.name}
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        Tipo de Category no encontrado
                                    </c:otherwise>
                                </c:choose></span>
                                </span>

                                <div class="actions">
                                    <a href="/cart?action=order&idProduct=${product.idProducto}"><button><i class="ti-shopping-cart"></i><span>AGREGAR CARRITO</span></button></a>
                                </div>


                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </div>
    </div>

    <jsp:include page="../templates/footer.jsp"></jsp:include>


</div>


</body>


</html>