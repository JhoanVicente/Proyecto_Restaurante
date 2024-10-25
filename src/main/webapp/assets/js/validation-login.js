document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('myForm');
    const usernameField = document.getElementById('username1');
    const passwordField = document.getElementById('password1');
    const formularioError = document.getElementById('formulario-error1');

    const usernameError = document.getElementById('username-error1');
    const passwordError = document.getElementById('password-error1');

    function validateNotEmptyAndLength(field, errorElement) {
        if (field.value.trim() !== '' && field.value.trim().length <= 150) {
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

    usernameField.addEventListener('input', () => validateNotEmptyAndLength(usernameField, usernameError));
    passwordField.addEventListener('input', () => validateNotEmptyAndLength(passwordField, passwordError));

    form.addEventListener('submit', function (event) {
        const isUsernameValid = validateNotEmptyAndLength(usernameField, usernameError);
        const isPasswordValid = validateNotEmptyAndLength(passwordField, passwordError);

        if (!isUsernameValid || !isPasswordValid) {
            event.preventDefault(); // Evitar el envío del formulario
            formularioError.classList.add('active');
        } else {
            formularioError.classList.remove('active');
        }
    });
});