from app.models.Usuario import Usuario
from app.models.Curso import Curso
from google.cloud import firestore
from google.cloud.firestore_v1.base_query import FieldFilter


def get_info_courses(db, id_usuario):
    try:
        # Obtener el usuario
        usuario_ref = db.collection('usuario').document(id_usuario)
        usuario = usuario_ref.get().to_dict()

        # Verificar si el usuario existe
        if not usuario:
            print("Error: El usuario no existe.")
            return False

        # Verificar si el usuario es un profesor
        if usuario['esProfesor']:
            cursos_profesor_ids = filter_cursos_profesor(db, id_usuario)
            
            if len(cursos_profesor_ids) == 0:
                return {'success': False, 'message': 'No se encontraron cursos en los que el usuario sea profesor.'}
            return {'success': True, 'message': 'Cursos en los que el usuario es profesor obtenidos exitosamente.', 'cursos': cursos_profesor_ids}
        
        else:
            cursos_matriculados_ids = filter_cursos_matriculados(db, id_usuario)
            
            if len(cursos_matriculados_ids) == 0:
                return {'success': False, 'message': 'No se encontraron cursos matriculados.'}
            return {'success': True, 'message': 'Cursos matriculados obtenidos exitosamente.', 'cursos': cursos_matriculados_ids}
        
    except Exception as e:
        return {'success': False, 'message': f'Error obteniendo los cursos: {e}'}

def filter_cursos_profesor(db, id_usuario):
    cursos_ref = db.collection('curso').stream()
    cursos_profesor = []
    for curso in cursos_ref:
        curso_dict = curso.to_dict()
        if curso_dict['id_profesor'] == id_usuario:
            cursos_profesor.append({
                'id': curso.id,
                'nombre': curso_dict['nombre'],
                'hora_inicio': curso_dict['hora_inicio'],
                'hora_fin': curso_dict['hora_fin'],
                'dia': curso_dict['dia'],
                'duracion': curso_dict['duracion'],
            })
    return cursos_profesor

def filter_cursos_matriculados(db, id_usuario):
    cursos_ref = db.collection('curso').stream()
    cursos_matriculados = []
    for curso in cursos_ref:
        curso_dict = curso.to_dict()
        matriculados_ref = curso.reference.collection('matriculados').where('id_usuario', '==', id_usuario).stream()
        if len(list(matriculados_ref)) > 0:
            cursos_matriculados.append({
                'id': curso.id,
                'nombre': curso_dict['nombre'],
                'hora_inicio': curso_dict['hora_inicio'],
                'hora_fin': curso_dict['hora_fin'],
                'dia': curso_dict['dia'],
                'duracion': curso_dict['duracion'],
            })
    return cursos_matriculados

def get_info_user(db, id_usuario):
    try:
        usuario_ref = db.collection('usuario').document(id_usuario)
        usuario = usuario_ref.get().to_dict()
        if not usuario:
            return {'success': False, 'message': 'El usuario no existe.'}
        return {'success': True, 'message': 'Usuario obtenido exitosamente.', 'usuario': usuario}
    except Exception as e:
        return {'success': False, 'message': f'Error obteniendo el usuario: {e}'}