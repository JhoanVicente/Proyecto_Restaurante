<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="es_PE"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Los Pinos - Productos</title>
    <jsp:include page="../../templates/head.jsp"></jsp:include>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>

</head>
<body>

<div class="main-wrapper">

    <jsp:include page="../../templates/header.jsp"></jsp:include>

    <div class="page-banner-section section" style="background-image: url(../../../assets/images/banner/dashboard.jpg)">
        <div class="container">
            <div class="row">
                <div class="page-banner-content col">
                    <h1>Gestión de Productos</h1>
                    <ul class="page-breadcrumb">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/admin/product">Productos</a></li>
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
                        <a href="/admin/dashboard"><i class="fa fa-dashboard"></i>Dashboard</a>
                        <a href="/admin"><i class="fa fa-users"></i>Usuarios</a>
                        <a href="/admin/product" class="active"><i class="fa fa-cutlery"></i>Productos</a>
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
                            <div class="myaccount-content">
                                <c:choose>
                                    <c:when test="${productStatus eq 0}">
                                        <h3>Productos Inactivos</h3>
                                    </c:when>
                                    <c:otherwise>
                                        <h3>Productos Activos</h3>
                                    </c:otherwise>
                                </c:choose>


                                <div style="justify-content: center" class="row">

                                    <form action="/admin/product" method="get">
                                        <div class="product-short col-lg-4 col-md-12 col-12">
                                            <h4>Exportar:</h4>
                                            <select class="nice-select" id="exportOption"
                                                    onchange="exportData(this.value)">
                                                <option value="">formato</option>
                                                <option value="PDF">PDF</option>
                                                <option value="Excel">Excel</option>
                                                <option value="CSV">CSV</option>
                                            </select>

                                            <script>
                                                function exportData(option) {
                                                    switch (option) {
                                                        case 'PDF':
                                                            exportToPDF();
                                                            break;
                                                        case 'Excel':
                                                            exportToExcel();
                                                            break;
                                                        case 'CSV':
                                                            exportToCSV();
                                                            break;
                                                        default:
                                                            console.log('No se seleccionó una opción válida');
                                                    }
                                                }
                                            </script>
                                        </div>
                                        <div class="product-short col-lg-4 col-md-12 col-12">
                                            <h4>Categoría:</h4>
                                            <select class="nice-select" id="typeOption"
                                                    onchange="redirectToSearch(this.value)">
                                                <option value="">Seleccionar</option>
                                                <c:forEach var="tipocategoria"
                                                           items="${typeCategorys}">
                                                    <option value="${tipocategoria.name}">${tipocategoria.name}</option>
                                                </c:forEach>
                                            </select>
                                            <script>
                                                function redirectToSearch(option) {
                                                    if (option) {
                                                        window.location.href = '/admin/product?search=' + option;
                                                    }
                                                }
                                            </script>
                                        </div>
                                        <div class="product-short col-lg-4 col-md-12 col-12">
                                            <input class="inputResp" type="text" name="search"
                                                   value="${param.search}"
                                                   placeholder="nombres, categoría">
                                            <button type="submit" style="border: none; background: none"><img
                                                    src="/assets/images/icons/search.png" alt="Search"></button>
                                        </div>
                                    </form>

                                    <div class="col-lg-12 col-12">
                                        <form action="/admin/product" method="post">
                                            <div class="col-lg-12 col-md-12 col-12 mb-40">
                                                <div class="cart-buttons mb-30">

                                                    <button type="button" class="btn bg-dark text-bg-dark botonResp"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#myModal"><i class="fa fa-plus-circle"
                                                                                         aria-hidden="true"></i>
                                                        Registrar Producto
                                                    </button>
                                                    <button class="btn bg-success text-bg-dark botonResp" type="submit"
                                                            name="productStatus" value="1"><i class="fa fa-eye"
                                                                                              aria-hidden="true"></i>
                                                        Productos Activos (${countProductsA})
                                                    </button>

                                                    <button class="btn bg-danger text-bg-dark botonResp" type="submit"
                                                            name="productStatus" value="0"><i class="fa fa-eye-slash"
                                                                                              aria-hidden="true"></i>
                                                        Productos Inactivos (${countProductsI})
                                                    </button>

                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <div class="modal" id="myModal">
                                    <div class="modal-dialog">
                                        <div class="modal-content">

                                            <div class="modal-header">
                                                <h4 class="modal-title">Registrar Producto</h4>
                                                <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                            </div>

                                            <div class="modal-body">
                                                <div class="login-register-form-wrap">
                                                    <form action="/admin/product?action=insert"
                                                          enctype="multipart/form-data" method="post"
                                                          class="was-validated">
                                                        <div class="row">
                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Categoria*</label>
                                                                <select name="idCategory" id="idCategory" required>
                                                                    <c:forEach var="tipocategoria" items="${typeCategorys}">
                                                                            <option value="${tipocategoria.idCategoryProducto}">${tipocategoria.name}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Imagen del Producto*</label>
                                                                <input class="form-control" type="file" name="image"
                                                                       id="image" value="Selecionar Imagen"
                                                                       accept="image/*">
                                                            </div>
                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Nombre*</label>
                                                                <input type="text" name="name" id="name"
                                                                       placeholder="Nombre del Producto" required>
                                                            </div>
                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Descripción*</label>
                                                                <input type="text" name="note" id="note"
                                                                       placeholder="Nota" required>
                                                            </div>
                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Precio*</label>
                                                                <input type="number" name="price" id="price"
                                                                       placeholder="Precio" step="0.01" required>
                                                            </div>

                                                            <div class="col-md-6 col-12 mb-15">
                                                                <label>Registrar*</label>

                                                                <input type="submit" value="Registrar">
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>

                                            <!-- Modal footer -->
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-danger" data-bs-dismiss="modal">
                                                    Close
                                                </button>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                                <div class="myaccount-table table-responsive">
                                    <table id="datatable2" class="table table-striped">
                                        <thead>
                                        <tr>
                                            <th>N°</th>
                                            <th>Nombre</th>
                                            <th>Categoría</th>
                                            <th>Precio</th>
                                            <th>Acción</th>
                                        </tr>
                                        </thead>

                                        <tbody>
                                        <c:forEach var="producto" items="${products}" varStatus="status">
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>${producto.name}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${typeCategorys != null}">
                                                            <c:forEach var="typeCategory" items="${typeCategorys}">
                                                                <c:if test="${typeCategory.idCategoryProducto eq producto.idCategory}">
                                                                    ${typeCategory.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            Tipo de categoría no encontrado
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>


                                                <td><fmt:formatNumber value="${producto.price}" type="currency"/></td>


                                                <td>
                                                    <c:choose>
                                                        <c:when test="${producto.status eq false}">
                                                            <a onclick="confirmRestore('${producto.idProducto}')"
                                                               class="btn btn-success btn-round">Activar</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a onclick="confirmDelete('${producto.idProducto}')"
                                                               class="btn btn-danger btn-round">Eliminar</a>
                                                            <a href="/admin/product?action=edit&idProduct=${producto.idProducto}"
                                                               class="btn btn-dark btn-round">Editar</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>


                    </div>
                </div>

            </div>
        </div>
    </div>

    <script>
        function confirmDelete(idUsuario) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: 'Deseas eliminar este producto',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, eliminarlo',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = ' /admin/product?action=delete&idProduct=' + idUsuario;
                }
            });
        }

        function confirmRestore(idUsuario) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: 'Deseas restaurar este producto',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, restaurarlo',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = ' /admin/product?action=restore&idProduct=' + idUsuario;
                }
            });
        }
    </script>
    <jsp:include page="../../templates/footer.jsp"></jsp:include>

    <button onclick="exportToPDF()">Exportar a PDF</button>
    <button onclick="exportToExcel()">Exportar a Excel</button>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>
<script>
    function exportToPDF() {
        // Crear un nuevo objeto jsPDF
        const { jsPDF } = window.jspdf;
        var doc = new jsPDF();

        // Definir la posición inicial para escribir en el PDF
        var y = 20; // Aumentar el margen superior para un mejor diseño

        var table = document.querySelector('.table');

        // Obtener todas las filas de la tabla
        var rows = Array.from(table.querySelectorAll('tbody tr'));

        // Iterar sobre las filas y obtener los datos de las celdas
        rows.forEach(function (row, rowIndex) {
            var x = 20; // Aumentar el margen izquierdo para un mejor diseño
            var cells = Array.from(row.querySelectorAll("td"));

            // Limitar a las primeras 4 columnas
            cells.slice(0, 4).forEach(function (cell, cellIndex) {
                // Agregar el contenido de la celda al PDF
                var cellText = String(cell.innerText);

                // Si es la segunda columna y el texto es largo, dividirlo en varias líneas
                if (cellIndex === 1 && cellText.length > 30) {
                    var splitText = doc.splitTextToSize(cellText, 60); // Ajustar el tamaño según sea necesario
                    doc.text(splitText, x, y);
                    y += splitText.length * 7; // Ajustar el espacio entre líneas según sea necesario
                } else {
                    doc.text(cellText, x, y);
                    if (cellIndex === 3) { // Si es la última columna, agregar espacio para la siguiente fila
                        y += 10;
                    }
                }

                // Ajustar el espacio entre celdas para un mejor diseño
                // Si es la primera columna, hacerla más delgada
                if (cellIndex === 0) {
                    x += 10; // Espacio más pequeño para la primera columna
                } else if (cellIndex === 1) {
                    x += 90; // Espacio más grande para la segunda columna
                } else {
                    x += 20; // Espacio más pequeño para la tercera y cuarta columna
                }
            });
        });

        // Guardar el PDF con el nombre "productos.pdf"
        var blob = doc.output('blob');
        saveAs(blob, "productos.pdf");
    }
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.2/xlsx.full.min.js"></script>
<script>
    function exportToExcel() {
        // Obtener la tabla y sus filas
        var table = document.querySelector('.table');

        // Obtener todas las filas de la tabla
        var rows = Array.from(table.querySelectorAll('tbody tr'));

        // Crear una matriz para almacenar los datos
        var data = [];

        // Iterar sobre las filas y obtener los datos de las celdas
        rows.forEach(function (row) {
            var rowData = [];
            row.querySelectorAll("td").forEach(function (cell) {
                rowData.push(cell.innerText);
            });
            data.push(rowData);
        });

        // Crear un libro de Excel y una hoja de trabajo
        var wb = XLSX.utils.book_new();
        var ws = XLSX.utils.aoa_to_sheet(data);

        // Agregar la hoja de trabajo al libro de Excel
        XLSX.utils.book_append_sheet(wb, ws, "Productos");

        // Generar el archivo de Excel y descargarlo
        XLSX.writeFile(wb, "productos.xlsx");
    }
</script>
<script>
    function exportToCSV() {
        // Obtener la referencia a la tabla
        var table = document.querySelector('.table');

        // Obtener todas las filas de la tabla
        var rows = Array.from(table.querySelectorAll('tbody tr'));

        // Crear una matriz para almacenar los datos del CSV
        var csvData = [];

        // Iterar sobre cada fila y obtener los datos de las celdas
        rows.forEach(function (row) {
            var rowData = [];
            var cells = Array.from(row.querySelectorAll('td'));

            // Obtener el texto de cada celda y agregarlo a la matriz de datos
            cells.forEach(function (cell) {
                rowData.push(cell.textContent.trim());
            });

            // Agregar la fila de datos al CSV
            csvData.push(rowData.join(','));
        });

        // Crear el contenido del archivo CSV
        var csvContent = csvData.join('\n');

        // Crear un enlace temporal para descargar el archivo CSV
        var link = document.createElement('a');
        link.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvContent);
        link.target = '_blank';
        link.download = 'Activos.csv';

        // Simular el clic en el enlace para descargar el archivo CSV
        link.click();
    }
</script>

</body>


</html>