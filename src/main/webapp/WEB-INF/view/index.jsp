<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Los Pinos - Inicio</title>
    <jsp:include page="../templates/head.jsp"></jsp:include>
    <style>
        .btn-page {
            font-family: "Dosis", sans-serif;
            color: #008000; /* Cambiado a verde */
            font-size: 18px;
            border-radius: 50px;
            font-weight: 700;
            background-color: #00FF00; /* Fondo cambiado a verde */
            line-height: 24px;
            padding: 13px 30px;
            display: -webkit-inline-box;
            display: -ms-inline-flexbox;
            display: inline-flex;
            -webkit-box-shadow: 0 2px 1px #008000; /* Sombra también verde */
            box-shadow: 0 2px 1px #008000; /* Sombra también verde */
        }

        .nameClient-error, .noteReservation-error {
            display: none;
        }
    </style>
</head>
<body>


<div class="main-wrapper">

    <jsp:include page="../templates/header.jsp"></jsp:include>

    <div class="hero-section section">

        <div class="hero-slider hero-slider-one fix">

            <div class="hero-item"
                 style="background-image: url(https://www.dogadanilac.com.tr/images/dogadanshop/dogadanshop.png)">
                <div class="hero-content">
                    <h1>BIENVENIDOS AL<br>RESTAURANTE LOS PINOS</h1>
                    <a href="/catalogo">ver catálogo</a>
                </div>
            </div>

            <div class="hero-item"
                 style="background-image: url(https://static.vecteezy.com/system/resources/previews/021/855/948/non_2x/restaurant-interior-cartoon-vector.jpg)">
                <div class="hero-content">
                    <h1>Cocina que inspira<br> Sabores que enamoran </h1>
                    <a href="#section-reservation">Reservar</a>
                </div>
            </div>

        </div>

    </div>

    <div class="blog-section section mt-40 section-padding ">
        <div class="container">
            <div class="row mbn-40">

                <div class="col-xl-6 col-lg-5 col-12 mb-40">

                    <div class="row">
                        <div class="section-title text-start col mb-30">
                            <h1>Los Pinos</h1>
                            <p>Restaurante tradiconal Cañetano</p>
                        </div>
                    </div>

                    <div class="row mbn-40">

                        <div class="col-12 mb-40">
                            <div class="testimonial-item">
                                <p>Tenemos el mejor pollo a la brasa de Cañete y una amplia variedad de comidas; el
                                    ceviche peruano, mostrito, parrillas, aguadito, así como nuestras bebidas y postres
                                    emblema.
                                    Ven y disfruta del rico pollo a la brasa al estilo peruano, comida tradicional de
                                    siempre.</p>
                            </div>
                        </div>

                        <div class="col-12 mb-40">
                            <div class="blog-item">
                                <div class="image-wrap">
                                    <a class="image" href="#"><img src="/assets/images/restaurant/chef.jpg"
                                                                   alt="Image"></a>
                                </div>
                                <div class="content">
                                    <h4 class="title"><a href="#">Cocineros expertos</a></h4>
                                    <div class="desc">
                                        <p> Nuestros cocineros son expertos en la preparación de los platos más
                                            deliciosos de la gastronomía peruana.</p>
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>

                </div>

                <div class="col-xl-6 col-lg-7 col-12 mb-40">

                    <div class="row">
                        <div class="section-title text-start col mb-30">
                            <h1>Disfruta una experiencia nueva cada día</h1>
                        </div>
                    </div>

                    <div class="row mbn-40">

                        <div class="col-12 mb-40">
                            <div class="blog-item">
                                <div class="image-wrap">
                                    <a class="image" href="#"><img src="/assets/images/restaurant/restaurant.jpg"
                                                                   alt="Image"></a>
                                </div>
                                <div class="content">
                                    <h4 class="title"><a href="#">Local de la chancha</a></h4>
                                    <div class="desc">
                                        <p>con la mejor atención y ambiente para disfrutar de una buena comida en
                                            familia o con amigos.</p>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="col-12 mb-40">
                            <div class="blog-item">
                                <div class="image-wrap">
                                    <a class="image" href="#"><img src="/assets/images/restaurant/client.jpg"
                                                                   alt="Image"></a>
                                </div>
                                <div class="content">
                                    <h4 class="title"><a href="#">Clientes satisfechos</a></h4>
                                    <div class="desc">
                                        <p>nuestros clientes siempre satisfechos con la calidad de nuestros productos y
                                            servicios.</p>
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </div>
    </div>

    <div class="product-section section section-padding">
        <div class="container">

            <div class="row">
                <div class="section-title text-center col mb-30">
                    <h1>Productos Destacados</h1>
                    <p>Top 8 de nuestras recientes Productos</p>
                </div>
            </div>

            <div class="row mbn-50 text-center">
                <c:forEach var="product" items="${productsViews}">
                    <div class="col-xl-3 col-lg-4 col-md-4 col-6 mb-40">

                        <div class="product-item">
                            <div class="product-inner">

                                <div class="image">
                                    <img src="./foto/${product.image}" alt="${product.name}">
                                    <div class="image-overlay">
                                        <div class="action-buttons">
                                            <a href="/cart?action=order&idProduct=${product.idProducto}">Agregar
                                                Carrito</a>
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
                                        <span class="price"><fmt:formatNumber value="${product.price}"
                                                                              type="currency"/></span>
                                    </div>

                                </div>

                            </div>
                        </div>

                    </div>

                </c:forEach>
                <div class="col-xl-12 col-lg-12 col-md-12 col-12">

                    <div class="product-item">
                        <div class="product-inner">

                            <a class="btn-page" href="/catalogo">Ver catálogo</a>

                        </div>
                    </div>

                </div>


            </div>

        </div>
    </div>

    <div  id="section-reservation" class="feature-section bg-theme-two section section-padding fix"
         style="background-image: url(/assets/images/pattern/pattern-dot.png);">
        <div class="container">
            <div class="feature-wrap row justify-content-between mbn-30">

                <div class="col-md-4 col-12 mb-30">
                    <div class="feature-item text-center">

                        <div class="icon"><img src="assets/images/feature/feature-1.png" alt="Image"></div>
                        <div class="content">
                            <h3>Delivery</h3>
                            <p>San vicente - Imperial</p>
                        </div>

                    </div>
                </div>

                <div class="col-md-4 col-12 mb-30">
                    <div class="feature-item text-center">

                        <div class="icon"><img src="assets/images/feature/feature-2.png" alt="Image"></div>
                        <div class="content">
                            <h3>Garantía de devolución de dinero</h3>
                            <p>devolución en 24horas</p>
                        </div>

                    </div>
                </div>

                <div class="col-md-4 col-12 mb-30">
                    <div class="feature-item text-center">

                        <div class="icon"><img src="assets/images/feature/feature-3.png" alt="Image"></div>
                        <div class="content">
                            <h3>Pago seguro</h3>
                            <p>Seguridad en los pagos</p>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>


    <div class="page-section section section-padding">
        <div class="container">
            <div class="row">
                <div class="section-title text-center col mb-30">
                    <h1>Reserva aquí </h1>
                    <p>Puedes reservas con anticipación</p>
                </div>
            </div>
            <div class="row row-30 mbn-40">

                <div class="contact-info-wrap col-md-6 col-12 mb-40">
                    <h3>!Importante!</h3>
                    <p>Antes de solicitar una reserva debes tener en cuenta los siguientes términos y condiciones</p>
                    <ul class="contact-info">
                        <li>
                            <p><strong>1</strong> La tolerancia de tiempo de la mesa reservada es de 15 minutos, si no
                                se presenta en ese lapso de tiempo, automáticamente pierde la reserva. </p>
                        </li>
                        <li>
                            <p><strong>2</strong> Máximo de Personas son 8</p>
                        </li>
                    </ul>

                </div>

                <div class="contact-form-wrap col-md-6 col-12 mb-40">
                    <h3>Reserva</h3>
                    <form id="reservation-form" action="/client/reservation" method="post" novalidate>
                        <input type="hidden" name="action" value="add">
                        <div class="contact-form">
                            <div class="row">
                                <div class="col-lg-6 col-12 mb-30">
                                    <label for="nameClient">Nombre de la Persona *</label>
                                    <input type="text" name="nameClient" id="nameClient"
                                           placeholder="Nombre de la persona">
                                    <span id="nameClient-error"
                                          class="error-message">No puede estar vacío y solo letras</span>
                                </div>
                                <div class="col-lg-6 col-12 mb-30">
                                    <label for="noteReservation">Nota Especial *</label>
                                    <input type="text" name="noteReservation" id="noteReservation"
                                           placeholder="un requerimiento">
                                    <span id="noteReservation-error" class="error-message">menos de 100 palabras</span>
                                </div>
                                <div class="col-lg-6 col-12 mb-30">
                                    <label for="dateReservation">Fecha y hora *</label>
                                    <input type="datetime-local" class="form-control" id="dateReservation"
                                           name="dateReservation" required>
                                </div>
                                <div class="col-lg-6 col-12 mb-30">
                                    <label for="quantityPerson">Cantidad de Personas *</label>
                                    <input type="number" class="form-control" id="quantityPerson" name="quantityPerson"
                                           placeholder="cantidad de personas" required min="1" max="8">
                                </div>
                                <div class="col-12">
                                    <c:if test="${logged != null}">
                                        <c:choose>
                                            <c:when test="${logged.status eq false}">
                                                <p>Tu cuenta está desactivado, por favor contacte con un administrador</p>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="submit" value="Reservar">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    <c:if test="${logged == null}">
                                        <p>Debes Iniciar Sesión o registrarte</p>
                                        <a href="/login" class="place-order bg-primary">Iniciar Sesión</a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>


            </div>
        </div>
    </div>


    <jsp:include page="../templates/footer.jsp"></jsp:include>


</div>


</body>


</html>