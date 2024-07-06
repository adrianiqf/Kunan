document.getElementById('toggleForm').addEventListener('click', function() {
    const isRegistroFormVisible = document.getElementById('Registro_form').classList.contains('active');
    
    if (isRegistroFormVisible) {
        document.getElementById('title_form').textContent = 'Inicio Sesión';
        document.getElementById('Registro_form').classList.remove('active');
        document.getElementById('form_login').classList.add('active');
        this.textContent = 'Cambiar a Registro';
    } else {
        document.getElementById('title_form').textContent = 'Registro';
        document.getElementById('form_login').classList.remove('active');
        document.getElementById('Registro_form').classList.add('active');
        this.textContent = 'Cambiar a Inicio de Sesión';
    }
});

// login envio
document.getElementById('form_login').addEventListener('submit', function(event) {
    event.preventDefault(); // Evitar el envío del formulario tradicional

    const correo = document.getElementById('inputCorreoLogin').value;
    const password = document.getElementById('exampleInputPasswordLogin').value;

    fetch('https://kunan.onrender.com/auth/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ correo: correo, password: password })
    })
    .then(response => response.json())
    .then(data => {
        if (data.id) {
            // Manejar el éxito del inicio de sesión
            alert('Inicio de sesión exitoso');
            console.log(data);
            if (data.esProfesor) {
                // Redirigir a cursosProfesor.html y pasar el id como parámetro de consulta
                window.location.href = `cursosProfesor.html?id=${data.id}`;
            } else {
                // Redirigir a otra página o manejar el caso cuando no es profesor
                window.location.href = `cursosAlumnos.html?id=${data.id}`; // Cambia esto según sea necesario
            }
            // Redirigir o realizar alguna acción adicional
        } else {
            // Manejar el error del inicio de sesión
            alert(data.error);
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
});

//registre envio
document.getElementById('Registro_form').addEventListener('submit', function(event) {
    event.preventDefault(); // Evitar el envío del formulario tradicional

    const nombre = document.getElementById('inputNombre').value;
    const apellido = document.getElementById('inputApellido').value;
    const codigo = document.getElementById('inputCodigo').value;
    const escuela = document.getElementById('inputEscuela').value;
    const facultad = document.getElementById('inputFacultad').value;
    const correo = document.getElementById('inputCorreo').value;
    const correo2 = document.getElementById('inputCorreo2').value;
    const password = document.getElementById('exampleInputPassword1').value;
    const rolElement = document.querySelector('input[name="rol"]:checked');

    // Validar que los correos sean iguales
    if (correo !== correo2) {
        alert('Los correos no coinciden');
        return;
    }

    // Validar que se seleccione un rol
    if (!rolElement) {
        alert('Debe seleccionar un rol');
        return;
    }

    // Validar el formato del correo institucional
            const correoRegex = /^[a-zA-Z0-9._%+-]+@unmsm\.edu\.pe$/;
            if (!correoRegex.test(correo)) {
                alert('El correo debe de ser de san marcos');
                return;
            }

    const rol = rolElement.value;

    fetch('https://kunan.onrender.com/auth/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            nombres: nombre,
            apellidos: apellido,
            codigo: codigo,
            escuela: escuela,
            facultad: facultad,
            correo: correo,
            password: password,
            esProfesor: rol === 'profesor'
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.id) {
            // Manejar el éxito del registro
            alert('Registro exitoso');
            console.log(data);
            // Redirigir o realizar alguna acción adicional
        } else {
            // Manejar el error del registro
            alert(data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
});