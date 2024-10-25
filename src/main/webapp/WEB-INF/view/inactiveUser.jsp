<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>La chancha - 404</title>
    <jsp:include page="../templates/head.jsp"></jsp:include>
</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../templates/header.jsp"></jsp:include>

    <div class="page-section section section-padding">
        <div class="container">
            <div class="row">

                <div class="col-lg-6 col-md-8 col-12 mx-auto">
                    <div class="error-404">
                        <h1>forbidden</h1>
                        <h2>¡OPPS! PÁGINA BLOQUEADA
                        </h2>
                        <p>Lo sentimos, eres usuario inactivo. Por favor, contacta con el administrador para activar tu cuenta.
                        </p>
                        <form action="#" class="searchform mb-30">
                        <a href="/" class="back-btn">Ir a la página principal</a>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <jsp:include page="../templates/footer.jsp"></jsp:include>

</div>
</body>
</html>