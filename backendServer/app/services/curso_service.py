from app.models.Usuario import Usuario
from app.models.Curso import Curso
from google.cloud import firestore

def create_course_service(db,  curso):
    try:
        # el id del usuario se obtiene del curso
        usuario_id = curso.id_profesor

        # Obtener el usuario
        usuario_ref = db.collection('usuario').document(usuario_id)
        usuario = usuario_ref.get().to_dict()

        # Verificar si el usuario es un profesor
        if not usuario['esProfesor']:
            print("Error: Solo los profesores pueden crear cursos.")
            return False

        # Crear el curso
        curso_ref = db.collection('curso').add(curso.to_dict())

        # Imprimir el ID del curso creado
        print(f"Curso creado con ID: {curso_ref[1].id}")

        return True
    except Exception as e:
        print(f"Error creating course: {e}")
        return False