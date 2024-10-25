document.addEventListener('DOMContentLoaded', function () {
    event.preventDefault(); // Evitar el envío del formulario al inicio
    const form = document.querySelector('#form2');
    const usernameField = document.getElementById('username');
    const passwordField = document.getElementById('password');
    const documentIdField = document.getElementById('documentoidentidad');
    const nameField = document.getElementById('names');
    const lastnameField = document.getElementById('lastnames');
    const addressField = document.getElementById('address');
    const phoneField = document.getElementById('phone');
    const emailField = document.getElementById('email');
    const formularioError = document.getElementById('formulario-error');

    const usernameError = document.getElementById('username-error');
    const passwordError = document.getElementById('password-error');
    const nameError = document.getElementById('names-error');
    const lastnameError = document.getElementById('lastnames-error');
    const addressError = document.getElementById('address-error');
    const phoneError = document.getElementById('phone-error');
    const emailError = document.getElementById('email-error');

    function validateDocumentId(field, errorElement, documentType) {
        let regex;
        if (documentType === 'DNI') {
            regex = new RegExp(`^\\d{8}$`);
        } else if (documentType === 'CE') {
            regex = new RegExp(`^\\d{9,20}$`);
        }
        if (regex && regex.test(field.value.trim())) {
            field.classList.add('valid');
            field.classList.remove('invalid');
            errorElement.classList.remove('active');
            return true;
        } else {
            field.classList.add('invalid');
            field.classList.remove('valid');
            errorElement.classList.add('active');
            return false;
        }
    }

    function validateNotEmptyAndLength(field, errorElement, maxLength) {
        if (field.value.trim() !== '' && field.value.trim().length <= maxLength) {
            field.classList.add('valid');
            field.classList.remove('invalid');
            errorElement.classList.remove('active');
            return true;
        } else {
            field.classList.add('invalid');
            field.classList.remove('valid');
            errorElement.classList.add('active');
            return false;
        }
    }

    function validateNoSymbolsOrNumbers(field, errorElement) {
        const regex = /^[A-Za-zÑñÁáÉéÍíÓóÚúÜü\s]+$/;
        if (regex.test(field.value.trim())) {
            field.classList.add('valid');
            field.classList.remove('invalid');
            errorElement.classList.remove('active');
            return true;
        } else {
            field.classList.add('invalid');
            field.classList.remove('valid');
            errorElement.classList.add('active');
            return false;
        }
    }

    function validatePhone(field, errorElement) {
        const regex = /^9\d{8}$/;
        if (regex.test(field.value.trim())) {
            field.classList.add('valid');
            field.classList.remove('invalid');
            errorElement.classList.remove('active');
            return true;
        } else {
            field.classList.add('invalid');
            field.classList.remove('valid');
            errorElement.classList.add('active');
            return false;
        }
    }

    function validateEmail(field, errorElement) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (regex.test(field.value.trim())) {
            field.classList.add('valid');
            field.classList.remove('invalid');
            errorElement.classList.remove('active');
            return true;
        } else {
            field.classList.add('invalid');
            field.classList.remove('valid');
            errorElement.classList.add('active');
            return false;
        }
    }

    const documentTypeField = document.getElementById('tipodocumento');
    const documentIdError = document.getElementById('documentoidentidad-error');

    documentTypeField.addEventListener('change', function () {
        if (this.value === 'DNI') {
            documentIdError.textContent = 'No puede estar vacío y debe tener 8 digitos';
        } else if (this.value === 'CE') {
            documentIdError.textContent = 'No puede estar vacío y debe ser entre 9 o 20 digitos';
        }
        // Ejecutar la validación del campo documentoidentidad cuando se cambie el tipo de documento
        validateDocumentId(documentIdField, documentIdError, this.value);
    });

    usernameField.addEventListener('input', () => validateNotEmptyAndLength(usernameField, usernameError, 30));
    passwordField.addEventListener('input', () => validateNotEmptyAndLength(passwordField, passwordError, 80));
    documentIdField.addEventListener('input', () => validateDocumentId(documentIdField, documentIdError, documentTypeField.value));
    nameField.addEventListener('input', () => validateNoSymbolsOrNumbers(nameField, nameError));
    lastnameField.addEventListener('input', () => validateNoSymbolsOrNumbers(lastnameField, lastnameError));
    addressField.addEventListener('input', () => validateNotEmptyAndLength(addressField, addressError, 150));
    phoneField.addEventListener('input', () => validatePhone(phoneField, phoneError));
    emailField.addEventListener('input', () => validateEmail(emailField, emailError));

    form.addEventListener('submit', function (event) {
        const isUsernameValid = validateNotEmptyAndLength(usernameField, usernameError, 30);
        const isPasswordValid = validateNotEmptyAndLength(passwordField, passwordError, 80);
        const isDocumentIdValid = validateDocumentId(documentIdField, documentIdError, documentTypeField.value);
        const isNameValid = validateNoSymbolsOrNumbers(nameField, nameError);
        const isLastnameValid = validateNoSymbolsOrNumbers(lastnameField, lastnameError);
        const isAddressValid = validateNotEmptyAndLength(addressField, addressError, 100);
        const isPhoneValid = validatePhone(phoneField, phoneError);
        const isEmailValid = validateEmail(emailField, emailError);

        if (!isUsernameValid || !isPasswordValid || !isDocumentIdValid || !isNameValid || !isLastnameValid || !isAddressValid || !isPhoneValid || !isEmailValid) {
            event.preventDefault(); // Evitar el envío del formulario
            formularioError.classList.add('active');
        } else if (!isSubmitting) {
            // Deshabilitar el botón de envío
            isSubmitting = true;
            submitButton.disabled = true;
            formularioError.classList.remove('active');
        } else {
            event.preventDefault(); // Evitar el envío del formulario si ya se está enviando
        }
    });
});
