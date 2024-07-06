const loader = document.getElementById('loader');

function getQueryParam(name) {
    loader.style.display = 'flex';
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// Obtener el id del parámetro de consulta
const id = getQueryParam('id');

if (!id) {
    alert('Necesita loguearse');
    window.location.href = 'menu.html'
} else {
    loader.style.display = 'none';
    console.log('ID del profesor:', id);
}

document.getElementById('AgregarCurso_form').addEventListener('submit', function(event) {
    event.preventDefault(); // Evita que el formulario se envíe de la manera tradicional
    
    const form = event.target;
    const formData = new FormData(form);
    const data = {};

    formData.forEach((value, key) => {
        data[key] = value;
    });

    // Convertir horas a formato HHMM
    const horaInicio = data['hora_inicio'].replace(':', '');
    const horaFin = data['hora_fin'].replace(':', '');
    
    data['hora_inicio'] = parseInt(horaInicio);
    data['hora_fin'] = parseInt(horaFin);
    data['id_profesor']=id;

    fetch('https://kunan.onrender.com/curso/create', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
    })
    .then(response => response.json())
    .then(result => {
        if (result.message) {
            alert(result.message); // Mostrar mensaje de éxito o error
            fetchCourseData()
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Ocurrió un error al registrar el curso.');
    });
});



async function fetchCourseData() {
    const loader = document.getElementById('loader');
    try {
        loader.style.display = 'flex';
        const response = await fetch(`https://kunan.onrender.com/usuario_info/user/${id}`);
        const { cursos } = await response.json(); // Desestructurar cursos del JSON
        populateTable(cursos);
    } catch (error) {
        console.error('Error fetching course data:', error);
    } finally {
        // Ocultar el loader y mostrar la tabla
        loader.style.display = 'none';
    }
}

function populateTable(courses) {
    const tableBody = document.querySelector('#courseTable tbody');
    tableBody.innerHTML = ''; // Clear existing rows

    courses.forEach((course) => {
        const row = document.createElement('tr');
        row.dataset.courseId = course.id; // Asignar ID del curso al dataset de la fila

        row.innerHTML = `
            <td>${course.nombre}</td>
            <td>${course.dia}</td>
            <td>${course.hora_inicio}</td> <!-- Cambiar horaInicio por hora_inicio -->
            <td>${course.hora_fin}</td> <!-- Cambiar horaFin por hora_fin -->
            <td>${course.duracion}</td>
            <td>${course.seccion}</td>
            <td>
                <button class="btn btn-warning btn-sm me-2 m-2" onclick="editRow(this)">
                    <i class="bi bi-pencil"></i> Editar
                </button>
                <button class="btn btn-danger btn-sm" onclick="deleteRow(this)">
                    <i class="bi bi-trash"></i> Eliminar
                </button>
                <button class="btn btn-info btn-sm" onclick="verMatriculados(this)">
                    <i class="bi bi-info"></i> VerMatriculados
                </button>
            </td>
        `;

        tableBody.appendChild(row);
    });
}

function verMatriculados(button){
    const row = button.closest('tr');
    const courseId = row.dataset.courseId;
    window.location.href = `alumnosMatriculados.html?id=${courseId}`;
}

function editRow(button) {
    const row = button.closest('tr');
    const courseId = row.dataset.courseId;

    // Lógica para editar la fila, por ejemplo, mostrar un formulario con los datos actuales
    console.log('Editar fila con ID:', courseId);
    
    // Ejemplo: convertir las celdas en campos editables
    row.querySelectorAll('td').forEach((cell, index) => {
        if (index < 6) { // Ignorar la columna de acciones
            const input = document.createElement('input');
            input.type = 'text';
            input.value = cell.innerText;
            cell.innerText = '';
            cell.appendChild(input);
        }
    });

    // Cambiar el botón de editar a guardar
    button.innerHTML = '<i class="bi bi-save"></i> Guardar';
    button.classList.remove('btn-warning');
    button.classList.add('btn-success');
    button.onclick = function() {
        saveRow(row, courseId);
    };
}

function saveRow(row, courseId) {
    const updatedCourse = {};
    const cells = row.querySelectorAll('td');

    // Recoger los valores actualizados
    updatedCourse.nombre = cells[0].querySelector('input').value;
    updatedCourse.dia = cells[1].querySelector('input').value;
    updatedCourse.hora_inicio = cells[2].querySelector('input').value;
    updatedCourse.hora_fin = cells[3].querySelector('input').value;
    updatedCourse.duracion = cells[4].querySelector('input').value;
    updatedCourse.seccion = cells[5].querySelector('input').value;

    // Actualizar el backend con la nueva información del curso
    fetch('https://kunan.onrender.com/curso/edit', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ id_curso: courseId, new_data: updatedCourse })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Actualizar la fila con los nuevos datos
            cells[0].innerText = updatedCourse.nombre;
            cells[1].innerText = updatedCourse.dia;
            cells[2].innerText = updatedCourse.horaInicio;
            cells[3].innerText = updatedCourse.horaFin;
            cells[4].innerText = updatedCourse.duracion;
            cells[5].innerText = updatedCourse.seccion;

            // Cambiar el botón de guardar a editar
            const button = row.querySelector('.btn-success');
            button.innerHTML = '<i class="bi bi-pencil"></i> Editar';
            button.classList.remove('btn-success');
            button.classList.add('btn-warning');
            button.onclick = function() {
                editRow(button);
            };
        } else {
            if(data.error!=undefined){
                alert(data.error)
            }else{
                alert('Editado correctamente')
                fetchCourseData()
            }
        }
    })
    .catch(error => {
        console.error('Error updating course:', error);
    });
}


function deleteRow(button) {
    const row = button.closest('tr');
    const courseId = row.dataset.courseId;

    // Confirmación antes de eliminar
    if (confirm('¿Estás seguro de que deseas eliminar este curso?')) {
        // Eliminar del backend
        fetch('https://kunan.onrender.com/curso/delete', {
            method: 'POST', // Cambiado a POST
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id_curso: courseId }) // Enviar el ID del curso
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            } else {
                throw new Error('Error eliminando curso');
            }
        })
        .then(data => {
            if (data.message === "Curso eliminado exitosamente") {
                // Eliminar la fila del DOM
                row.remove();
            } else {
                console.error('Error eliminando curso:', data.message);
            }
        })
        .catch(error => {
            console.error('Error eliminando curso:', error);
        });
    }
}



// Llama a la función fetchCourseData para cargar los datos iniciales
fetchCourseData();
