// Obtener los elementos del formulario
var nameClientInput = document.getElementById('nameClient');
var noteReservationInput = document.getElementById('noteReservation');
var fechaReservaInput = document.getElementById('dateReservation');
var quantityPersonInput = document.getElementById('quantityPerson');
var submitButton = document.querySelector('#reservation-form input[type="submit"]');

// Validación del nombre del cliente
nameClientInput.addEventListener('input', function () {
    if (this.value.trim() === "" || !/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]*$/.test(this.value)) {
        document.getElementById('nameClient-error').style.display = 'block';
    } else {
        document.getElementById('nameClient-error').style.display = 'none';
    }
});

// Validación de la nota especial
noteReservationInput.addEventListener('input', function () {
    if (this.value.trim() === "" || this.value.split(' ').length > 100) {
        document.getElementById('noteReservation-error').style.display = 'block';
    } else {
        document.getElementById('noteReservation-error').style.display = 'none';
    }
});

// Validación de la fecha y hora
var fechaActual = new Date().toISOString().slice(0, 16);
fechaReservaInput.setAttribute('min', fechaActual);
fechaReservaInput.addEventListener('change', function () {
    var seleccionada = new Date(this.value);
    var ahora = new Date();
    if (seleccionada < ahora) {
        Swal.fire({
            icon: 'error',
            title: 'Fecha inválida',
            text: 'Debe seleccionar una fecha y hora futura.',
        });
        this.value = ''; // Limpiar el valor del input si es inválido
    }
});

// Validación de la cantidad de personas
quantityPersonInput.addEventListener('input', function () {
    var valor = parseInt(this.value, 10);
    if (valor < 1 || valor > 8) {
        this.value = Math.min(Math.max(valor, 1), 8);
        Swal.fire({
            icon: 'error',
            title: 'Valor inválido',
            text: 'El número de personas debe estar entre 1 y 8.',
        });
    }
});

// Validación del formulario antes de enviarlo
document.getElementById('reservation-form').addEventListener('submit', function (event) {
    var isValid = true;

    if (nameClientInput.value.trim() === "" || !/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]*$/.test(nameClientInput.value)) {
        document.getElementById('nameClient-error').style.display = 'block';
        isValid = false;
    } else {
        document.getElementById('nameClient-error').style.display = 'none';
    }

    if (noteReservationInput.value.trim() === "" || noteReservationInput.value.split(' ').length > 100) {
        document.getElementById('noteReservation-error').style.display = 'block';
        isValid = false;
    } else {
        document.getElementById('noteReservation-error').style.display = 'none';
    }

    if (fechaReservaInput.value.trim() === "") {
        Swal.fire({
            icon: 'error',
            title: 'Fecha inválida',
            text: 'Debe seleccionar una fecha y hora futura.',
        });
        isValid = false;
    } else {
        var seleccionada = new Date(fechaReservaInput.value);
        var ahora = new Date();
        if (seleccionada < ahora) {
            Swal.fire({
                icon: 'error',
                title: 'Fecha inválida',
                text: 'Debe seleccionar una fecha y hora futura.',
            });
            isValid = false;
        }
    }

    var valor = parseInt(quantityPersonInput.value, 10);
    if (isNaN(valor) || valor < 1 || valor > 8) {
        Swal.fire({
            icon: 'error',
            title: 'Valor inválido',
            text: 'El número de personas debe estar entre 1 y 8.',
        });
        isValid = false;
    }

    if (!isValid) {
        event.preventDefault(); // Prevenir el envío del formulario si hay errores
    }
});