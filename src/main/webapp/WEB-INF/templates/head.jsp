<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<meta name="description" content="">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="shortcut icon" type="image/x-icon" href="/assets/images/logo2.png">
<link rel="stylesheet" href="/assets/css/bootstrap.min.css">
<link rel="stylesheet" href="/assets/css/icon-font.min.css">
<link rel="stylesheet" href="/assets/css/plugins.css">
<link rel="stylesheet" href="/assets/css/helper.css">
<link rel="stylesheet" href="/assets/css/style.css">

<!-- DataTables -->
<link href="/assets/plugins/datatables/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css"/>
<link href="/assets/plugins/datatables/buttons.bootstrap4.min.css" rel="stylesheet" type="text/css"/>
<!-- Responsive datatable examples -->
<link href="/assets/plugins/datatables/responsive.bootstrap4.min.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
<style>
    select {
        width: 100%;
        border: 1px solid #333333;
        background-color: transparent;
        border-radius: 50px;
        height: 44px;
        line-height: 22px;
        padding: 10px 20px;
        font-size: 14px;
    }

    .valid {
        border-color: green;
    }

    .invalid {
        border-color: red;
    }

    .error-message {
        color: red;
        font-size: 0.9em;
        display: none;
    }

    .error-message.active {
        display: block;
    }

    #names, #lastnames, #fechanacimiento, #fechaa {
        background: #dddddd;
    }

    .invalid-feedback {
        display: none;
        color: red;
        font-size: 0.875em;
    }

    .valid-feedback {
        display: none;
        color: green;
        font-size: 0.875em;
    }

    .is-invalid {
        border-color: red;
        animation: shake 0.3s;
    }

    .is-valid {
        border-color: green;
    }

    @keyframes shake {
        0% {
            transform: translateX(0);
        }
        25% {
            transform: translateX(-5px);
        }
        50% {
            transform: translateX(5px);
        }
        75% {
            transform: translateX(-5px);
        }
        100% {
            transform: translateX(0);
        }
    }

    .invalid-feedback {
        display: none;
        color: red;
        font-size: 0.875em;
    }

    .valid-feedback {
        display: none;
        color: green;
        font-size: 0.875em;
    }

    .is-invalid {
        border-color: red;
        animation: shake 0.3s;
    }

    .is-valid {
        border-color: green;
    }

    @keyframes shake {
        0% {
            transform: translateX(0);
        }
        25% {
            transform: translateX(-5px);
        }
        50% {
            transform: translateX(5px);
        }
        75% {
            transform: translateX(-5px);
        }
        100% {
            transform: translateX(0);
        }
    }

    .botonResp {
        border: medium none;
        border-radius: 50px;
        color: #ffffff;
        display: block;
        float: left;
        font-size: 13px;
        font-weight: 600;
        height: 40px;
        line-height: 24px;
        margin-bottom: 10px;
        margin-right: 15px;
        padding: 8px 25px;
        text-transform: uppercase;
    }

    .inputResp {
        border: 1px solid #333333;
        border-radius: 50px;
        height: 40px;
        width: 200px;
        color: #333333;
        padding: 5px 15px;
        background-color: transparent;
    }


    .box-container {
        display: flex;
        justify-content: center;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
    }

    .box {
        height: 115px;
        width: 220px;
        border-radius: 20px;
        box-shadow: 2px 3px 10px rgb(255 141 0);
        padding: 20px;
        display: flex;
        align-items: center;
        justify-content: space-around;
        cursor: pointer;
        transition: transform 0.3s ease-in-out;
    }

    .box:hover {
        transform: scale(1.08);
    }

    .box:nth-child(1) {
        background-color: var(--one-use-color);
    }

    .box:nth-child(2) {
        background-color: var(--two-use-color);
    }

    .box:nth-child(3) {
        background-color: var(--one-use-color);
    }

    .box:nth-child(4) {
        background-color: var(--two-use-color);
    }

    .box img {
        height: 50px;
    }

    .box .text {
        color: white;
    }

    .topic {
        font-size: 13px;
        font-weight: 400;
        letter-spacing: 1px;
    }

    .topic-heading {
        font-size: 30px;
        letter-spacing: 3px;
    }
</style>