// JavaScript para manejar el inicio de sesión (login.js)
document.getElementById('loginForm').addEventListener('submit', async (event) => {
    event.preventDefault(); // Prevenir el envío por defecto

    const correo = document.getElementById('correo').value;
    const password = document.getElementById('password').value;

    // Implementar la llamada a la API real aquí
    const response = await login(correo, password); // Usar la función de login real
    console.log('Respuesta de la API:', response);
    if (response.esAdmin && response.esAdmin == true) {
        console.log('Inicio de sesión exitoso:', response);
        // Redirigir a la página o funcionalidad de administración
         window.location.href = 'menu.html'
    } else {
        alert('Acceso denegado. Debes ser administrador para acceder.');
    }
});

// Función real de llamada a la API para iniciar sesión
async function login(correo, password) {
    try {
        const response = await fetch('https://kunan.onrender.com/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ correo, password }),
        });

        if (!response.ok) {
            throw new Error('Error en la solicitud');
        }

        const data = await response.json();
        return data; // Devuelve la respuesta de la API
    } catch (error) {
        console.error('Error al iniciar sesión:', error);
        alert('Error al procesar la solicitud de inicio de sesión.');
        return null; // En caso de error, devuelve null
    }
}