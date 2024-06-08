from app.models.Usuario import Usuario
from app.models.Curso import Curso
from google.cloud import firestore
from google.cloud.firestore_v1.base_query import FieldFilter

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


def register_student_service(db, id_usuario, id_curso):
    try:
        # Obtener el curso
        curso_ref = db.collection('curso').document(id_curso)
        curso = curso_ref.get().to_dict()

        # Verificar si el curso existe
        if not curso:
            print("Error: El curso no existe.")
            return False

        # Obtener el usuario
        usuario_ref = db.collection('usuario').document(id_usuario)
        usuario = usuario_ref.get().to_dict()

        # Verificar si el usuario es un estudiante
        if usuario['esProfesor']:
            print("Error: El usuario no es un estudiante.")
            return False

        # Verificar si el estudiante ya está matriculado en el curso
       # existing_student_ref = curso_ref.collection('matriculados').where('id_usuario', '==', id_usuario)
        existing_student_ref = db.collection('curso').document(id_curso).collection('matriculados').where(filter=FieldFilter('id_usuario', '==', id_usuario))

        existing_student = existing_student_ref.get()


        if len(existing_student)>0:
            # Devolver un mensaje indicando que el estudiante ya está matriculado en el curso
            for student in existing_student:
                print(f"Estudiante encontrado: {student.id}")
                return {'success': False, 'message': f'El estudiante ya está matriculado en el curso'}

        # Si el estudiante no está matriculado, agregarlo a la colección de matriculados del curso
        curso_ref.collection('matriculados').add({
            "id_usuario": id_usuario,
            # Añade otros campos del estudiante aquí si es necesario
        })

        return {'success': True, 'message': f'Estudiante matriculado con éxito en el curso'}

    except Exception as e:
        print(f"Error registering student: {e}")
        return False