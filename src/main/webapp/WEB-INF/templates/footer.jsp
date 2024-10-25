<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="footer-top-section section bg-theme-two-light section-padding">
    <div class="container">
        <div class="row mbn-40">

            <div class="footer-widget col-lg-3 col-md-6 col-12 mb-40">
                <h4 class="title">Contactanos</h4>
                <p> Restaurante <br> Los Pinos</p>
                <p>+51 973182822</p>
                <p>contact@lospinos.pe</p>
            </div>

            <div class="footer-widget col-lg-3 col-md-6 col-12 mb-40">
                <h4 class="title">Información</h4>
                <ul>
                    <li><a href="#">Acerca de</a></li>
                    <li><a href="#">Servicios</a></li>
                    <li><a href="#">Terminos y condiciones</a></li>
                </ul>
            </div>


            <div class="footer-widget col-lg-3 col-md-6 col-12 mb-40">
                <h4 class="title">Síguenos</h4>
                    <p class="footer-social"><a href="#">Facebook</a> - <a href="#">Twitter</a> - <a href="#">Google+</a></p>
            </div>
            

            <div class="footer-widget col-lg-3 col-md-6 col-12 mb-40">
                <h4 class="title">Nuestra Carta</h4>
                <ul>
                    <li><a href="#">Carta 1</a></li>
                    <li><a href="#">Carta 2</a></li>
                </ul>
            </div>

        </div>
    </div>
</div>

<div class="footer-bottom-section section bg-theme-two pt-15 pb-15">
    <div class="container">
        <div class="row">
            <div class="col text-center">
                <p class="footer-copyright">© 2024 Valle Grande - Los Pinos</p>
            </div>
        </div>
    </div>
</div>

<%-- Validaciones --%>


<script src="/assets/js/vendor/jquery-3.6.0.min.js"></script>
<script src="/assets/js/vendor/jquery-migrate-3.3.2.min.js"></script>
<script src="/assets/js/bootstrap.bundle.min.js"></script>
<script src="/assets/js/plugins.js"></script>
<script src="/assets/js/main.js"></script>


<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
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

<script src="/assets/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="/assets/plugins/datatables/dataTables.bootstrap4.min.js"></script>

<script src="/assets/plugins/datatables/dataTables.responsive.min.js"></script>
<script src="/assets/plugins/datatables/responsive.bootstrap4.min.js"></script>

<script src="/assets/js/pages/datatables.init.js"></script>


<script>
    <c:if test="${sessionScope.alert != null}">
    ${sessionScope.alert}
    <%
        session.removeAttribute("alert");
    %>
    </c:if>
    <c:if test="${requestScope.alert != null}">
    ${requestScope.alert}
    <%
        request.removeAttribute("alert");
    %>
    </c:if>
</script>