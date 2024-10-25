<%@ page import="pe.edu.vallegrande.sysrestaurant.dto.user.UserDto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Los Pinos - Dashboard</title>
    <jsp:include page="../../templates/head.jsp"></jsp:include>
    <link href="/assets/plugins/animate/animate.css" rel="stylesheet" type="text/css">
    <link href="/assets/plugins/c3/c3.min.css" rel="stylesheet">
    <script src="/assets/js/vendor/modernizr-3.11.2.min.js"></script>
    <link rel="stylesheet" href="/assets/plugins/chartist/css/chartist.min.css">
</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../assets/images/banner/dashboard.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Informes del Restaurante</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/admin/dashboard">dashboard</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="page-section section section-padding">
        <div class="container">
            <div class="row mbn-30">

                <div class="col-lg-2 col-12 mb-30">
                    <div class="myaccount-tab-menu nav" role="tablist">
                        <c:if test='${logged.typeUser == 1}'>
                            <a href="/admin/dashboard" class="active"><i class="fa fa-dashboard"></i>Dashboard</a>
                            <a href="/admin"><i class="fa fa-users"></i>Usuarios</a>
                            <a href="/admin/product"><i class="fa fa-cutlery"></i>Productos</a>
                            <a href="/admin/category"><i class="fa fa-bars"></i>Categorias</a>
                        </c:if>
                        <a href="/admin/order"><i class="fa fa-cart-arrow-down"></i>Pedidos</a>
                        <a href="/admin/reservation"><i class="fa fa-calendar-minus-o"></i>Reservaciones</a>
                        <a href="/logout"><i class="fa fa-sign-out"></i> Salir</a>
                    </div>
                </div>

                <div class="col-lg-10 col-12 mb-30">
                    <div class="tab-content" id="myaccountContent">
                        <div class="tab-pane fade show active" id="dashboad" role="tabpanel">
                            <h2 style="text-align: center">Panel Principal</h2>

                            <div class="box-container">

                                <form action="/admin/" method="post">
                                    <button type="submit" name="userStatus" value="1"
                                            style="background: none; border: none; ">
                                        <div class="box box3">
                                            <div class="text">
                                                <h3 class="topic-heading">${countUsersActive}</h3>
                                                <h2 class="topic">Usuarios</h2>
                                            </div>
                                            <img src=
                                                         "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                                 alt="likes">
                                        </div>
                                    </button>
                                </form>

                                <div class="box box1">
                                    <div class="text">
                                        <h3 class="topic-heading"><fmt:formatNumber value="${sumTotalPayment}"
                                                                                    type="currency"/></h3>
                                        <h2 class="topic">Ganancia de Hoy</h2>
                                    </div>
                                    <img src=
                                                 "https://cdn2.iconfinder.com/data/icons/business-concept-16/64/Global_Sale-512.png"
                                         alt="Views">
                                </div>

                                <form action="/admin/product" method="post">
                                    <button type="submit" name="productStatus" value="1"
                                            style="background: none; border: none; ">
                                        <div class="box box4">
                                            <div class="text">
                                                <h3 class="topic-heading">${countProductsActive}</h3>
                                                <h2 class="topic">Productos</h2>
                                            </div>
                                            <img src=
                                                         "https://i.pinimg.com/originals/4e/24/f5/4e24f523182e09376bfe8424d556610a.png"
                                                 alt="likes">
                                        </div>
                                    </button>
                                </form>

                                <form action="/admin/category" method="post">
                                    <button type="submit" name="categoryStatus" value="1"
                                            style="background: none; border: none; ">
                                        <div class="box box2">
                                            <div class="text">
                                                <h3 class="topic-heading">${countCategoryActive}</h3>
                                                <h2 class="topic">Categoría</h2>
                                            </div>
                                            <img src=
                                                         "https://icon-library.com/images/category-icon-png/category-icon-png-2.jpg"
                                                 alt="likes">
                                        </div>
                                    </button>
                                </form>

                            </div>

                            <h3 style="margin: 25px 0px">Resumen de estadísticas</h3>
                            <div class="row">
                                <div class="col-md-12 col-lg-12 col-xl-4">
                                    <div class="card m-b-30">
                                        <div class="card-body">
                                            <h4 class="mt-0 header-title">Productos más vendidos</h4>
                                            <div id="pie-chart"></div>
                                        </div>
                                    </div>
                                </div> <!-- end col -->
                                <div class="col-md-12 col-lg-12 col-xl-8">
                                    <div class="card m-b-30">
                                        <div class="card-body">

                                            <h4 class="mt-0 header-title">Usuarios más Pedidos completado</h4>
                                            <p class="text-muted font-14 d-inline-block text-truncate w-100">resumen
                                                detallado de los usarios más pedidos completados.</p>
                                            <canvas id="myChartUsers"></canvas>

                                            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                                            <script>
                                                var userNames = [];
                                                var userOrders = [];
                                                var backgroundColors = [];

                                                <c:forEach var="usersOrder" items="${listUserMaxOrder}">
                                                userNames.push("${usersOrder.nameUser}");
                                                userOrders.push(${usersOrder.totalCompletedOrders});
                                                backgroundColors.push('rgb(' + Math.floor(Math.random() * 256) + ',' + Math.floor(Math.random() * 256) + ',' + Math.floor(Math.random() * 256) + ')');
                                                </c:forEach>

                                                var ctx = document.getElementById('myChartUsers');
                                                var myChartUsers = new Chart(ctx, {
                                                    type: 'bar',
                                                    data: {
                                                        labels: userNames,
                                                        datasets: [{
                                                            label: 'Usuarios con más pedidos',
                                                            data: userOrders,
                                                            backgroundColor: backgroundColors,
                                                            borderColor: ['black'],
                                                            borderWidth: 1
                                                        }]
                                                    },
                                                    options: {
                                                        scales: {
                                                            y: {
                                                                beginAtZero: true
                                                            }
                                                        }
                                                    }
                                                });
                                            </script>

                                        </div>
                                    </div>
                                </div> <!-- end col -->
                            </div>


                            <h3 style="margin: 25px 0px">Registros Recientes</h3>

                            <div class="container">
                                <div style="margin: 25px 0px; justify-content: space-between" class="row row-30 mbn-40">

                                    <div class="col-xl-3 col-lg-4 col-12 order-2 order-lg-1 mb-40">

                                        <div class="sidebar">
                                            <h4 class="sidebar-title">Clientes</h4>
                                            <ul class="sidebar-list">
                                                <c:forEach var="client" items="${recentUsersByClient}">
                                                    <li><a href="#">${client.nameUser} ${client.lastnames}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>

                                    </div>

                                    <div class="col-xl-3 col-lg-4 col-12 order-2 order-lg-1 mb-40">

                                        <div class="sidebar">
                                            <h4 class="sidebar-title">Admin</h4>
                                            <ul class="sidebar-list">
                                                <c:forEach var="admin" items="${recentUsersByAdmin}">
                                                    <li><a href="#">${admin.nameUser} ${admin.lastnames}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>

                                    </div>

                                    <div class="col-xl-3 col-lg-4 col-12 order-2 order-lg-1 mb-40">

                                        <div class="sidebar">
                                            <h4 class="sidebar-title">Mesero</h4>
                                            <ul class="sidebar-list">
                                                <c:forEach var="waiters" items="${recentUsersByWaiters}">
                                                    <li><a href="#">${waiters.nameUser} ${waiters.lastnames}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>

                                    </div>


                                </div>
                            </div>


                        </div>


                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- END wrapper -->


    <!-- jQuery  -->
    <script src="/assets/js/jquery.min.js"></script>
    <script src="/assets/js/popper.min.js"></script>
    <script src="/assets/js/bootstrap-material-design.js"></script>
    <script src="/assets/js/modernizr.min.js"></script>
    <script src="/assets/js/detect.js"></script>
    <script src="/assets/js/fastclick.js"></script>
    <script src="/assets/js/jquery.slimscroll.js"></script>
    <script src="/assets/js/jquery.blockUI.js"></script>
    <script src="/assets/js/waves.js"></script>
    <script src="/assets/js/jquery.nicescroll.js"></script>
    <script src="/assets/js/jquery.scrollTo.min.js"></script>

    <!--C3 Chart-->
    <script src="/assets/plugins/d3/d3.min.js"></script>
    <script src="/assets/plugins/c3/c3.min.js"></script>
    <script>
        var productData = [];
        <c:forEach items="${listProductMaxSold}" var="product">
        productData.push(['${product.nameProduct}', ${product.totalSold}]);
        </c:forEach>

        !function ($) {
            "use strict";

            var ChartC3 = function () {
            };

            ChartC3.prototype.init = function () {
                //generating chart
                c3.generate({
                    bindto: '#chart',
                    data: {
                        columns: [
                            ['Desktop', 150, 80, 70, 152, 250, 95],
                            ['Mobile', 200, 130, 90, 240, 130, 220],
                            ['Tablet', 300, 200, 160, 400, 250, 250]
                        ],
                        type: 'bar',
                        colors: {
                            Desktop: '#2196F3',
                            Mobile: '#009688',
                            Tablet: '#3f51b5'
                        }
                    }
                });


                //Pie Chart
                c3.generate({
                    bindto: '#pie-chart',
                    data: {
                        columns: productData,
                        type: 'pie'
                    },
                    color: {
                        pattern: ['#009688', "#ff7a5a", '#3f51b5', '#2196F3', '#f68903']
                    },
                    pie: {
                        label: {
                            show: false
                        }
                    }
                });

            },
                $.ChartC3 = new ChartC3, $.ChartC3.Constructor = ChartC3

        }(window.jQuery),

//initializing
            function ($) {
                "use strict";
                $.ChartC3.init()
            }(window.jQuery);


    </script>
    <!-- App js -->
    <script src="/assets/js/app.js"></script>
    <jsp:include page="../../templates/footer.jsp"></jsp:include>


</div>


</body>


</html>