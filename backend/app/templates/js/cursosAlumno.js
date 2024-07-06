function getQueryParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// Obtener el id del parámetro de consulta
const id = getQueryParam('id');
console.log('ID del alumno:', id);

getQueryParam()

document.addEventListener('DOMContentLoaded', function () {
    const apiUrl = `https://kunan.onrender.com/usuario_info/user/${id}`;

    fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const cursos = data.cursos;
                const cursosAlumno = document.getElementById('cursosAlumno');
                cursos.forEach((curso, index) => {
                    const row = document.createElement('tr');

                    const cellIndex = document.createElement('td');
                    cellIndex.textContent = index + 1;
                    row.appendChild(cellIndex);

                    const cellNombre = document.createElement('td');
                    cellNombre.textContent = curso.nombre;
                    row.appendChild(cellNombre);

                    const cellDia = document.createElement('td');
                    cellDia.textContent = curso.dia;
                    row.appendChild(cellDia);

                    const cellHoraInicio = document.createElement('td');
                    cellHoraInicio.textContent = curso.hora_inicio;
                    row.appendChild(cellHoraInicio);

                    const cellHoraFin = document.createElement('td');
                    cellHoraFin.textContent = curso.hora_fin;
                    row.appendChild(cellHoraFin);

                    const cellDuracion = document.createElement('td');
                    cellDuracion.textContent = curso.duracion;
                    row.appendChild(cellDuracion);

                    const cellSeccion = document.createElement('td');
                    cellSeccion.textContent = curso.seccion;
                    row.appendChild(cellSeccion);

                    cursosAlumno.appendChild(row);
                });
            } else {
                console.error('Error al obtener los cursos: ', data.message);
            }
        })
        .catch(error => {
            console.error('Error al realizar la solicitud: ', error);
        });
});
