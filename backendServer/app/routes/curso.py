from flask import Blueprint, request, jsonify, current_app
from app.models.Usuario import Usuario
from app.models.Curso import Curso

from app.services.curso_service import create_course_service

curso_bp = Blueprint('curso', __name__)

@curso_bp.route('/create', methods=['POST'])
def create():
    data = request.json
    db = current_app.config['db']

    curso = Curso(
        nombre=data['nombre'],
        hora_fin=data['hora_fin'],
        hora_inicio=data['hora_inicio'],
        dia=data['dia'],
        ciclo=data['ciclo'],
        id_profesor = data['id_profesor']
    )

    

    if create_course_service(db, curso):
        return jsonify({"message": "Curso creado exitosamente"}), 201
    else:
        return jsonify({"message": "Error al crear el curso"}), 400