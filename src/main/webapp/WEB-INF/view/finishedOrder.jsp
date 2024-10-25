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
                    <div class="row row-20 mb-10">

                        <div class="col-lg-5 col-12 mb-40">

                            <div class="pro-large-img mb-10 fix">
                                <c:if test="${TypePayP == 1}">
                                    <img src="/assets/images/order/efectivo.jpg" alt=""/>
                                </c:if>
                                <c:if test="${TypePayP == 2}">
                                    <img src="/assets/images/order/yape.jpg" alt=""/>
                                </c:if>
                                <c:if test="${TypePayP == 3}">
                                    <img src="/assets/images/order/tarjeta.jpg" alt=""/>
                                </c:if>
                            </div>
                        </div>

                        <div class="col-lg-7 col-12 mb-40">
                            <div class="single-product-content">

                                <div class="head">
                                    <div class="head-left">
                                        <h3 class="title">Procesando Pedido, "Pendiente"</h3>
                                        <c:if test="${TypePayP == 1}">
                                            <h4 class="title">EFECTIVO</h4>
                                        </c:if>
                                        <c:if test="${TypePayP == 2}">
                                            <h4 class="title">YAPE</h4>
                                        </c:if>
                                        <div class="ratting">
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star"></i>
                                            <i class="fa fa-star-half-o"></i>
                                            <i class="fa fa-star-o"></i>
                                        </div>

                                    </div>
                                </div>

                                <div style="text-align: center" class="description">
                                    <c:if test="${TypePayP == 1}">
                                        <p>El pedido se ha enviado correctamente al Administrador, se encuentra en
                                            estado <strong>Pendiente</strong>. </p>
                                        <p>Se le enviará los proceso de su pedido a su correo electrónico, por favor
                                            estar atento a su bandeja de entrada  puede seguir el estado de su pedido y todo el detalle en la web dando click al botón de
                                            abajo.</p>
                                        <img style="width: 40%" src="/assets/images/status/enviadoEmail.gif" alt=""/>
                                    </c:if>
                                    <c:if test="${TypePayP == 2}">
                                        <p>Se recomienda poner su nombre y apellido completos a la hora de enviar su
                                            pago</p>
                                        <p>El pedido se ha enviado correctamente al Administrador, se encuentra en
                                            estado <strong>Pendiente</strong> una vez que a yapeado se le procesara el estado. </p>
                                        <p>Se le enviará los proceso de su pedido a su correo electrónico, por favor
                                            estar atento a su bandeja de entrada  puede seguir el estado de su pedido y todo el detalle en la web dando click al botón de
                                            abajo.</p>
                                        <img style="width: 40%" src="/assets/images/status/enviadoEmail.gif" alt=""/>
                                    </c:if>
                                    <c:if test="${TypePayP == 3}">
                                        <p>El pedido se ha enviado correctamente al Administrador, se encuentra en
                                            estado <strong>Pendiente</strong> una vez que verifiquemos le mandaremos un mensaje en el correo</p>
                                        <p>Se le enviará los proceso de su pedido a su correo electrónico, por favor
                                            estar atento a su bandeja de entrada  puede seguir el estado de su pedido y todo el detalle en la web dando click al botón de
                                            abajo.</p>
                                        <img style="width: 40%" src="/assets/images/status/enviadoEmail.gif" alt=""/>
                                    </c:if>
                                </div>

                                <span class="availability">Total: <span><fmt:formatNumber value="${totalpay}"
                                                                                                  type="currency"/></span></span>

                                <div class="actions">

                                    <a href="/client/order" class="btn btn-success btn-round"><i class="ti-shopping-cart"></i><span> VER SEGUIMIENTO DEL PEDIDO</span></a>

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