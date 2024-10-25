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


    <div class="page-banner-section section" style="background-image: url(https://static.vecteezy.com/system/resources/previews/019/775/321/non_2x/restaurant-interior-cartoon-vector.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Cart</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/inicio">Home</a></li>
                        <li><a href="/cart">Cart</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="page-section section section-padding">
        <div class="container">

            <form action="/cart" method="post" class="checkout-form">
                <div class="row mbn-40">
                    <div class="col-12 mb-40">
                        <div class="cart-table table-responsive">
                            <table>
                                <thead>
                                <tr>
                                    <th class="pro-thumbnail">Producto</th>
                                    <th class="pro-title">Nombre</th>
                                    <th class="pro-price">Precio</th>
                                    <th class="pro-quantity">Cantidad</th>
                                    <th class="pro-subtotal">SubTotal</th>
                                    <th class="pro-remove">Eliminar</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="cart" items="${carts}">
                                    <c:set var="total" value="${total + cart.productDto.price * cart.quantity}"/>
                                    <tr>
                                        <td class="pro-thumbnail"><a href="#"><img src="foto/${cart.productDto.image}"
                                                                                   alt=""/></a></td>
                                        <td class="pro-title"><a href="#">${cart.productDto.name}</a></td>
                                        <td class="pro-price"><span class="amount"><fmt:formatNumber
                                                value="${cart.productDto.price}" type="currency"/></span></td>

                                        <td class="pro-quantity">
                                            <a style="font-size: 25px" class="cart_quantity_up"
                                               href="javascript:void(0);"
                                               onclick="changeQuantity('${cart.productDto.idProducto}', 'increment')">
                                                + </a>
                                            <input style="height: 34px;
    text-align: center;
    width: 50%;
    border: 1px solid #ddd;
    border-radius: 5px;" type="text" name="quantity" value="${cart.quantity}" autocomplete="off" size="2" readonly>
                                            <a style="font-size: 25px" class="cart_quantity_down"
                                               href="javascript:void(0);"
                                               onclick="changeQuantity('${cart.productDto.idProducto}', 'decrement')">
                                                - </a>
                                        </td>

                                        <td class="pro-subtotal"><fmt:formatNumber
                                                value="${cart.productDto.price * cart.quantity}" type="currency"/></td>
                                        <td class="pro-remove"><a
                                                href="/cart?action=delete&idProduct=${cart.productDto.idProducto}">×</a>
                                        </td>
                                    </tr>
                                </c:forEach>

                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="col-lg-7">

                        <div id="billing-form" class="mb-20">
                            <div class="cart-buttons mb-30">
                                <a class="bg-primary" href="/inicio">Seguir Comprando</a>
                                <a class="bg-danger" href="/cart?action=clear">Eliminar Carrito</a>
                            </div>
                            <h4 class="checkout-title">Detalles del Pedido</h4>
                            <div class="row">
                                <div class="col-md-6 col-12 mb-5 address-field">
                                    <label>Dirección de la Entrega*</label>
                                    <input type="text" name="address"
                                           placeholder="distrito:San vicente - calle: av. mariscal  3829 referencia"/>
                                    <span id="address-error" class="error-message" style="display: none;">No puede estar vacío y no debe superar 150 caracteres</span>
                                </div>

                                <div class="col-md-6 col-12 mb-5">
                                    <label>Requerimiento Sobre el Pedido*</label>
                                    <input type="text" name="note" placeholder="Ej: el pollo cortado en 4 partes"/>
                                    <span id="note-error" class="error-message" style="display: none;">No puede estar vacío y no debe superar 150 caracteres</span>
                                </div>


                                <div class="col-md-6 col-12 mb-5">
                                    <label>Tipo de Pago*</label>
                                    <div class="single-method">
                                        <input type="radio" id="payment_check" name="idTypePay" value="1">
                                        <label for="payment_check">Efectivo</label>
                                    </div>

                                    <div class="single-method">
                                        <input type="radio" id="payment_bank" name="idTypePay" value="2">
                                        <label for="payment_bank">Yape</label>
                                    </div>

                                    <div class="single-method">
                                        <input type="radio" id="payment_card" name="idTypePay" value="3">
                                        <label for="payment_card">Tarjeta</label>
                                    </div>

                                    <span id="payment-error" class="error-message" style="display: none;">Debe seleccionar un tipo de pago</span>
                                </div>


                                    <div class="col-md-6 col-12 mb-5">
                                        <label>Es Delivery?*</label>
                                        <div class="single-method">
                                            <input type="checkbox" id="isDelivery" name="isDelivery" value="No">
                                            <label for="isDelivery">No</label>
                                        </div>
                                    </div>


                            </div>

                        </div>


                    </div>

                    <div class="col-lg-5">
                        <div class="row">

                            <div class="col-12 mb-40">

                                <div class="checkout-cart-total">

                                    <div class="cart-total fix">
                                        <h3>Total de Pedido</h3>
                                        <table>
                                            <tbody>
                                            <tr class="cart-subtotal">
                                                <%--                                                <th>Subtotal</th>--%>
                                                <%--                                                <td><span class="amount">$306.00</span></td>--%>
                                            </tr>
                                            <tr class="order-total">
                                                <p>IGV %<span class="amount"><fmt:formatNumber value="${total * 0.18}" type="currency"/></span></p>
                                                <p>Total  <span class="amount"><fmt:formatNumber value="${total * 1.18}" type="currency"/></span></p>
                                                <td>
                                                    <input type="hidden" name="total" value="${total * 1.18}">
                                                    <input type="hidden" name="Monto" value="${total * 1.18}">
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>

                                       <div class="proceed-to-checkout section mt-30">
                                            <c:choose>
                                                <c:when test="${logged.status == false}">
                                                    <p>Tu cuenta está desactivado, por favor contacte con un
                                                        administrador</p>
                                                </c:when>
                                                <c:when test="${logged != null and carts != null and not empty carts}">
                                                    <input type="hidden" name="action" value="pay">
                                                    <button class="place-order bg-success" type="button" onclick="confirmPayment()">Procesar el Pago</button>
                                                </c:when>

                                                <c:when test="${logged != null and (carts == null or empty carts)}">
                                                    <p>Necesitas comprar algo para usar el carrito.</p>
                                                    <a href="/inicio" class="place-order bg-primary">Ir a Comprar</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <p>Debes Iniciar Sesión o registrarte</p>
                                                    <a href="/login" class="place-order bg-primary">Iniciar Sesión</a>
                                                </c:otherwise>
                                            </c:choose>

                                        </div>

                                    </div>

                                </div>

                            </div>


                        </div>
                    </div>


                </div>
            </form>

        </div>
    </div>
    <script>
        function confirmPayment() {
            Swal.fire({
                title: '¿Estás seguro?',
                text: 'Seguro que tus datos están correctos para procesar el pago',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, Procesar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Cargando...',
                        icon: 'info',
                        showConfirmButton: false,
                        allowOutsideClick: false
                    });

                    const button = document.querySelector('.place-order');
                    button.disabled = true; // Deshabilita el botón
                    document.querySelector('.checkout-form').submit(); // Envía el formulario si se confirma
                }
            });
        }
    </script>


    <jsp:include page="../templates/footer.jsp"></jsp:include>


</div>

<script>
    function changeQuantity(idProduct, action) {
        window.location.href = '/cart?action=' + action + '&idProduct=' + idProduct;
    }
</script>

<script>
    document.querySelector('.checkout-form').addEventListener('submit', function (event) {
        var note = document.querySelector('input[name="note"]');
        var address = document.querySelector('input[name="address"]');
        var paymentType = document.querySelector('input[name="idTypePay"]:checked');
        var deliveryCheckbox = document.querySelector('input[name="isDelivery"]');

        if (!note.value || note.value.length > 150) {
            event.preventDefault();
            document.getElementById('note-error').style.display = 'block';
        } else {
            document.getElementById('note-error').style.display = 'none';
        }

        if (!paymentType) {
            event.preventDefault();
            document.getElementById('payment-error').style.display = 'block';
        } else {
            document.getElementById('payment-error').style.display = 'none';
        }

        if (!deliveryCheckbox.checked && (!address.value || address.value.length > 150)) {
            event.preventDefault();
            document.getElementById('address-error').style.display = 'block';
        } else {
            document.getElementById('address-error').style.display = 'none';
        }
    });

    document.querySelector('input[name="isDelivery"]').addEventListener('change', function () {
        var addressField = document.querySelector('.address-field');
        if (this.checked) {
            addressField.style.display = 'none';
        } else {
            addressField.style.display = 'block';
        }
    });
</script>


</body>


</html>