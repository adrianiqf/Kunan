from flask import Blueprint, request, jsonify, current_app
from app.services.usuario_service import get_info_courses, get_info_user

usuario_bp = Blueprint('usuario_bp', __name__)

@usuario_bp.route('/user/<id_usuario>', methods=['GET'])
def get_courses(id_usuario):
    db = current_app.config['db']
    result = get_info_courses(db, id_usuario)
    if result['success']:
        return jsonify(result), 200
    else:
        return jsonify(result), 400

@usuario_bp.route('/info/<id_usuario>', methods=['GET'])
def usuario_info(id_usuario):
    db = current_app.config['db']
    result = get_info_user(db, id_usuario)
    if result['success']:
        return jsonify(result['usuario']), 200
    else:
        return jsonify({"error": result['message']}), 400
        