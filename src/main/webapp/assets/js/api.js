document.getElementById('buscarCliente').addEventListener('click', function () {
    // Obtener el valor del DNI ingresado por el usuario
    var dni = document.getElementById('documentoidentidad').value.trim();
    if (dni === '') {
        Swal.fire('Error', 'Ingrese un documento válido', 'error');
        return;
    }

    // Obtener el tipo de documento seleccionado por el usuario
    var tipoDocumento = document.getElementById('tipodocumento').value;

    // URL de la API para buscar cliente por DNI o Carnet de Extranjeria
    var apiUrl;
    if (tipoDocumento === 'DNI') {
        apiUrl = 'http://localhost:8080/api?action=vers3&dni=' + dni;
    } else if (tipoDocumento === 'CE') {
        apiUrl = 'http://localhost:8080/api?action=vers4&dni=' + dni;
    } else {
        Swal.fire('Error', 'Seleccione un tipo de documento válido', 'error');
        return;
    }

    // Realizar la solicitud GET a la API
    fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
            // Verificar si la solicitud fue exitosa
            if (tipoDocumento === 'DNI' && data.success) {
                // Procesar respuesta de DNI
                document.getElementById('names').value = data.data.name;
                document.getElementById('lastnames').value = data.data.fathers_lastname + ' ' + data.data.mothers_lastname;
                document.getElementById('fechanacimiento').value = data.data.birth_date ? data.data.birth_date : "";
                console.log(data.data.distric + ' ' + data.data.province + ' ' + data.data.region + ' ' + data.data.address)
                document.getElementById('address').value = data.data.region+ ' ' + data.data.province + ' ' + data.data.district+ ' ' +data.data.address;
            } else if (tipoDocumento === 'CE' && data.flag_encontrado_mpi) {
                // Procesar respuesta de CE
                document.getElementById('names').value = data.datos_paciente.nombres;
                document.getElementById('lastnames').value = data.datos_paciente.apellido_paterno + ' ' + data.datos_paciente.apellido_materno;
                // Convertir la fecha de nacimiento del formato "dd/MM/yyyy" a "yyyy-MM-dd"
                if (data.datos_paciente.fecha_nacimiento) {
                    var parts = data.datos_paciente.fecha_nacimiento.split('/');
                    var formattedDate = parts[2] + '-' + parts[1] + '-' + parts[0];
                    document.getElementById('fechanacimiento').value = formattedDate;
                } else {
                    document.getElementById('fechanacimiento').value = "";
                }
                document.getElementById('address').value = data.datos_paciente.direccion;
            } else {
                Swal.fire('Error', 'No se encontraron datos para el documento proporcionado', 'error');
            }
        })
        .catch(error => {
            Swal.fire('Error', 'Hubo un problema con la solicitud: ' + error.message, 'error');
        });
});

//! Si no funciona el anterior
//
// document.getElementById('buscarCliente').addEventListener('click', function () {
//     // Obtener el valor del DNI ingresado por el usuario
//     var dni = document.getElementById('documentoidentidad').value.trim();
//     if (dni === '') {
//         alert('Ingrese un DNI válido');
//         return;
//     }
//
//     // URL de la API de Reniec para buscar cliente por DNI
//     var apiUrl = 'http://localhost:8080/api?action=vers2&dni=' + dni;
//
//     // Realizar la solicitud GET a la API
//     fetch(apiUrl)
//         .then(response => response.json())
//         .then(data => {
//             // Verificar si la solicitud fue exitosa
//             if (data.result === 1) {
//                 // Llenar los campos del formulario con los datos obtenidos
//                 var cliente = data.data; // Acceder al objeto de datos dentro de la respuesta
//                 document.getElementById('names').value = cliente.nombres;
//                 document.getElementById('lastnames').value = cliente.apellidoMaterno + ' ' + cliente.apellidoPaterno;
//                 // Formatear la fecha de nacimiento
//                 var fechaNacimiento = new Date(cliente.fechaNacimiento);
//                 var fechaFormateada = fechaNacimiento.getFullYear() + '-' + ('0' + (fechaNacimiento.getMonth() + 1)).slice(-2) + '-' + ('0' + fechaNacimiento.getDate()).slice(-2);
//                 document.getElementById('fechanacimiento').value = fechaFormateada;
//                 document.getElementById('address').value = cliente.departamentoNac + ' ' + cliente.distrito;
//             } else {
//                 alert('No se encontraron datos para el DNI proporcionado');
//             }
//         })
//         .catch(error => {
//             console.error('Error al obtener datos de la API:', error);
//             alert('Ocurrió un error al obtener datos de la API');
//         });
// });
