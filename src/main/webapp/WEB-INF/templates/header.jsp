
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="header-section section">
    <div class="header-bottom header-bottom-one header-sticky">
        <div class="container-fluid">
            <div class="row menu-center align-items-center justify-content-between">

                <div class="col mt-15 mb-15">
                    <div class="header-logo">
                        <a href="/">
                            <img style="height: 50px" src="/assets/images/logo.png" alt="Jadusona">
                        </a>
                    </div>
                </div>

                <div class="col order-2 order-lg-3">

                    <div class="header-shop-links">

                        <div class="header-mini-cart" style="margin-right: 20px;">
                            <a href="/cart"><img src="/assets/images/icons/cart.png" alt="Wishlist"> <span>Carrito</span></a>
                        </div>
                        <c:if test="${logged == null}">
                            <div class="header-wishlist">
                                <a href="/login"><img src="/assets/images/icons/user.png" alt="Wishlist"> <span>Iniciar Sesión</span></a>
                            </div>
                        </c:if>
                        <c:if test="${logged != null}">
                            <div class="header-search">
                                <button class="search-toggle"><img src="/assets/images/icons/user.png" alt="Search Toggle"><img class="toggle-close" src="../assets/images/icons/close.png" alt="Search Toggle"></button>
                                <div class="header-search-wrap">
                                    <p>Hola! ${logged.names}</p>
                                    <a href="/logout"><img src="/assets/images/icons/logout.png" alt="Wishlist"> <span>Salir</span></a>
                                </div>
                            </div>
                        </c:if>

                    </div>
                </div>

                <div class="col order-3 order-lg-2">
                    <div class="main-menu">
                        <nav>
                            <ul>
                                <li><a href="/inicio">Inicio</a></li>
                                <li><a href="/catalogo">Catálogo</a></li>

                                <c:if test="${logged !=null}">

                                    <li><a href="#">Dashboard</a>
                                        <ul class="sub-menu">
                                            <li><a href="/client/reservation">Reservas</a></li>
                                            <li><a href="/client/order">Pedidos</a></li>
                                        </ul>
                                    </li>

                                    <c:if test="${logged.typeUser == 1 ||logged.typeUser == 2}">
                                        <li><a href="#">Administrativo</a>
                                            <ul class="sub-menu">
                                               <c:if test="${logged.typeUser == 1}">
                                                   <li><a href="/admin/dashboard">Dashboard</a></li>
                                                   <li><a href="/admin">Usuarios</a></li>
                                                   <li><a href="/admin/product">Productos</a></li>
                                                   <li><a href="/admin/category">Categorias</a></li>
                                               </c:if>
                                                <li><a href="/admin/reservation">Reservas</a></li>
                                                <li><a href="/admin/order">Pedidos</a></li>
                                            </ul>
                                        </li>
                                    </c:if>
                                </c:if>

                            </ul>
                        </nav>
                    </div>
                </div>
                <div class="mobile-menu order-4 d-block d-lg-none col"></div>
            </div>
        </div>
    </div>
</div>