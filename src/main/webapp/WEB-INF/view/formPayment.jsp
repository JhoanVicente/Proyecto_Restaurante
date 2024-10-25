<%@page import="java.util.List" %>
<%@ page import="pe.edu.vallegrande.sysrestaurant.dto.payment.formulariotoken" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>La chancha - Inicio</title>
    <jsp:include page="../templates/head.jsp"></jsp:include>
    <style>
        /*
    Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
    Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/CascadeStyleSheet.css to edit this template
    */
        /*
            Created on : 27 feb. 2024, 21:24:06
            Author     : junio
        */

        /*** div para controlar el formulario ***/
        .formulario {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            width: 100vw;
            height: 100vh;
        }

        .kr-embedded {
            /*border: 1px solid #b3b6b5;
            border-radius: 5px;
            padding: 25px;
            */
        }


        .kr-field-wrapper {
            margin-top: 6px !important;
            margin-left: 10px !important;
        }

        .Contains-form {
            display: flex;
            justify-content: center;
            border-radius: 5px;
            background: #ffffff;
            background-repeat: no-repeat;
            background-position: center top 15px;
            background-size: 160px;
            background-image: url("https://github.com/izipay-pe/Imagenes/blob/main/logos_izipay/logo-izipay-sinFondo-250x102.png?raw=true") !important;
            border-radius: 6px;
            box-shadow: 0px 10px 25px rgba(92, 99, 105, .2);
            border: 1px solid #b3b6b5 !important;
            margin-bottom: 25px;
            padding: 20px !important;
            width: 360px;
            padding: 25px !important;
        }


        .kr-embedded {
            background-color: #fff !important;
            border-radius: 6px;
            border: 1px solid #b3b6b5 !important;
            box-shadow: 0px 10px 25px rgba(92, 99, 105, .2);
            padding: 20px !important;
            width: 100% !important;
            max-width: 300px !important;
        }

        .content-security-expiry {
            display: flex !important;
            flex-direction: row !important;
            justify-content: space-around !important;
        }


        /*** Número de tarjeta ***/
        .kr-pan {
            margin-top: 14px !important;
            height: 45px !important;
            border-radius: 4px !important;
        }


        .kr-expiry {
            height: 45px !important;
            border-radius: 4px !important;
            max-width: 49% !important;
        }

        .kr-security-code {
            height: 45px !important;
            border-radius: 4px !important;
            max-width: 49% !important;
        }

        .kr-installment-number {
            border-radius: 4px !important;
            height: 45px !important;
        }

        .kr-first-installment-delay {
            border-radius: 4px !important;
            height: 45px !important;
        }

        .kr-embedded .kr-payment-button {
            color: #ffffff !important;
            background-color: #00A09D !important;
            border-radius: 4px !important;
            height: 55px !important;
            margin-bottom: 0px !important;
        }

        .kr-embedded .kr-payment-button span:hover {
            transition-duration: 0.2s;
            font-size: large;
            text-shadow: -0.5px -0.5px 0.5px #000, 0.5px 0.5px 0.5px #000, -0.5px 0.5px 0.5px #000, 0.5px -0.5px 0.5px #000;
        }

        .kr-embedded .kr-payment-button:hover {
            background-color: #3DD2CE !important;
            border-radius: 4px !important;
            color: #ffffff !important;
        }
    </style>
    <script
            src="https://api.micuentaweb.pe/static/js/krypton-client/V4.0/stable/kr-payment-form.min.js"
            kr-public-key="93939955:testpublickey_xOmJOxs3lmuEf8f8MUsv8Kxka7fnsKf8sl3sTyVfVHfxF"
            kr-post-url-success="/finishedOrder">
    </script>
    <link type="text/css" rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://api.micuentaweb.pe/static/js/krypton-client/V4.0/ext/classic-reset.css">
    <script
            src="https://api.micuentaweb.pe/static/js/krypton-client/V4.0/ext/classic.js">
    </script>
</head>
<body>


<div class="main-wrapper">

    <jsp:include page="../templates/header.jsp"></jsp:include>

    <!-- Page Section Start -->
    <div class="page-section section section-padding">
        <div class="container">
            <div class="row row-30 mbn-50">

                <div class="col-12">
                    <div class="row">
                        <div class="section-title text-center col">
                            <h1>Configura tu tarjeta de crédito o débito</h1>
                            <p>Seguro para su tranquilidad. Cancela fácilmente en línea.</p>
                            <img width="250px" src="/assets/images/cards.png" alt=""/>
                        </div>
                    </div>
                    <div class="row row-20 mb-10" style="justify-content: center; padding-top: 5px; padding-bottom: 15px">
                            <%
                                //String monto = request.getParameter("Monto");
                                List<formulariotoken> listaFormulario = (List) request.getSession().getAttribute("tokenmostrar");
                                for (formulariotoken token : listaFormulario) {
                            %>
                            <!-- payment form -->

                            <div class="kr-embedded" kr-form-token=<%=token.getTokenFormulario()%>>

                                <!-- payment form fields -->
                                <div class="kr-pan"></div>
                                <div class="kr-expiry"></div>
                                <div class="kr-security-code"></div>

                                <!-- payment form submit button -->
                                <button class="kr-payment-button"></button>

                                <!-- error zone -->
                                <div class="kr-form-error"></div>
                            </div>
                            <%
                                }
                            %>

                    </div>


                </div>

            </div>
        </div>
    </div>

    <jsp:include page="../templates/footer.jsp"></jsp:include>


</div>

</body>
</html>
