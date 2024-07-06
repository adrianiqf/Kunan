function getQueryParam(name) {
    //loader.style.display = 'flex';
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// Obtener el id del parámetro de consulta
const id = getQueryParam('id');

if (!id) {
    alert('Tiene que seleccionar un curso');
    goBack()
} else {
    //loader.style.display = 'none';
    console.log('ID del curso:', id);
}

function goBack() {
    history.back();
}

async function fetchAlumnosMatriculados() {
    try {
        const response = await fetch('https://kunan.onrender.com/curso/alumnosMatriculados', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id_curso: id}) // Ajusta el cuerpo de la solicitud según sea necesario
        });
        const data = await response.json();
        const alumnos = data.alumnos_matriculados;
        const tbody = document.getElementById('alumnos-tbody');

        alumnos.forEach((alumno, index) => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${index + 1}</td>
                <td>${alumno.nombres}</td>
                <td>${alumno.apellidos}</td>
                <td>${alumno.codigo}</td>
                <td>${alumno.facultad}</td>
                <td>${alumno.escuela}</td>
                <td>${alumno.correo}</td>
                
            `;
            tbody.appendChild(row);
        });
    } catch (error) {
        console.error('Error fetching data:', error);
    }
}

document.addEventListener('DOMContentLoaded', fetchAlumnosMatriculados);