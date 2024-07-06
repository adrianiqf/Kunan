async function fetchUserData() {
    const loader = document.getElementById('loader');
    try {
        loader.style.display = 'flex';
        const response = await fetch('https://kunan.onrender.com/usuario_info/all');
        const data = await response.json();
        populateTable(data);
    } catch (error) {
        console.error('Error fetching user data:', error);
    }finally {
        // Ocultar el loader y mostrar la tabla
        loader.style.display = 'none';
    }
}

function populateTable(users) {
    const tableBody = document.querySelector('#userTable tbody');
    tableBody.innerHTML = ''; // Clear existing rows

    users.forEach((user, index) => {
        const row = document.createElement('tr');
        row.dataset.userId = user.id; // Asignar ID del usuario al dataset de la fila

        row.innerHTML = `
            <th scope="row">${index + 1}</th>
            <td>${user.nombres}</td>
            <td>${user.apellidos}</td>
            <td>${user.codigo}</td>
            <td>${user.escuela}</td>
            <td>${user.facultad}</td>
            <td>${user.esProfesor ? 'Profesor' : 'Estudiante'}</td>
            <td>${user.correo}</td>
            <td>${user.password}</td>
            <td>
                <button class="btn btn-warning btn-sm me-2 m-2" onclick="editRow(this)">
                    <i class="bi bi-pencil"></i> Editar
                </button>
                <button class="btn btn-danger btn-sm" onclick="deleteRow(this)">
                    <i class="bi bi-trash"></i> Eliminar
                </button>
            </td>
        `;

        tableBody.appendChild(row);
    });
}

function editRow(button) {
    const row = button.closest('tr');
    const userId = row.dataset.userId;

    // Lógica para editar la fila, por ejemplo, mostrar un formulario con los datos actuales
    console.log('Editar fila con ID:', userId);
    
    // Ejemplo: convertir las celdas en campos editables
    row.querySelectorAll('td').forEach((cell, index) => {
        if (index < 8) { // Ignorar la columna de acciones
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
        saveRow(row, userId);
    };
}

function saveRow(row, userId) {
    const updatedUser = {};
    const cells = row.querySelectorAll('td');

    // Recoger los valores actualizados
    updatedUser.nombres = cells[0].querySelector('input').value;
    updatedUser.apellidos = cells[1].querySelector('input').value;
    updatedUser.codigo = cells[2].querySelector('input').value;
    updatedUser.escuela = cells[3].querySelector('input').value;
    updatedUser.facultad = cells[4].querySelector('input').value;
    updatedUser.rol = cells[5].querySelector('input').value;
    updatedUser.correo = cells[6].querySelector('input').value;
    updatedUser.password = cells[7].querySelector('input').value;

    // Actualizar el backend con la nueva información del usuario
    fetch(`https://kunan.onrender.com/usuario_info/edit/${userId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(updatedUser)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Actualizar la fila con los nuevos datos
            cells[0].innerText = updatedUser.nombres;
            cells[1].innerText = updatedUser.apellidos;
            cells[2].innerText = updatedUser.codigo;
            cells[3].innerText = updatedUser.escuela;
            cells[4].innerText = updatedUser.facultad;
            cells[5].innerText = updatedUser.rol === 'Profesor' ? 'Profesor' : 'Estudiante';
            cells[6].innerText = updatedUser.correo;
            cells[7].innerText = updatedUser.password;

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
            }
        }
    })
    .catch(error => {
        console.error('Error updating user:', error);
    });
}

function deleteRow(button) {
    const row = button.closest('tr');
    const userId = row.dataset.userId;

    // Confirmación antes de eliminar
    if (confirm('¿Estás seguro de que deseas eliminar este usuario?')) {
        // Eliminar del backend
        fetch(`https://kunan.onrender.com/usuario_info/delte/${userId}`, {
            method: 'DELETE'
        })
        .then(response => {
            if (response.ok) {
                // Eliminar la fila del DOM
                row.remove();
            } else {
                console.error('Error eliminando usuario');
            }
        })
        .catch(error => {
            console.error('Error eliminando usuario:', error);
        });
    }
}

document.getElementById('searchButton').addEventListener('click', function() {
    const searchCode = document.getElementById('searchCode').value.trim();
    const filterRole = document.getElementById('filterRole').value;

    // Obtener todas las filas de la tabla
    const rows = document.querySelectorAll('#userTable tbody tr');
    
    rows.forEach(row => {
        const code = row.querySelector('td:nth-child(4)').innerText;
        const role = row.querySelector('td:nth-child(7)').innerText;

        // Inicialmente, mostrar todas las filas
        let showRow = true;

        // Filtrar por código
        if (searchCode && code !== searchCode) {
            showRow = false;
        }

        // Filtrar por rol
        if (filterRole && role !== filterRole) {
            showRow = false;
        }

        // Mostrar u ocultar la fila según los filtros
        row.style.display = showRow ? '' : 'none';
    });
});

// Llama a la función fetchUserData para cargar los datos iniciales
fetchUserData();
