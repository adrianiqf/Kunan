from werkzeug.security import generate_password_hash, check_password_hash # para hashear la contraseña
from app.models.Usuario import Usuario
from app.models.IdentificadorCelular import IdentificadorCelular

def create_user(db, usuario, identificador_celular):
    try:
        # agregar validaciones para correo
        # Verificar si ya existe un usuario con el mismo código
        existing_user_ref = db.collection('usuario').where('codigo', '==', usuario.codigo).limit(1).stream()
        for doc in existing_user_ref:
            print("Error: Ya existe un usuario con el mismo código.")
            return False

        # Validar que los campos de identificador_celular no sean vacíos, 0 o nulos
        if not identificador_celular.imei or identificador_celular.imei == 0 or identificador_celular.ultima_conexion is None:
            print("Error: Los campos de identificador_celular no pueden ser vacíos, 0 o nulos.")
            return False

        # Añadir usuario a la colección y obtener su ID generado automáticamente
        doc_ref = db.collection('usuario').add(usuario.to_dict())

        # Obten el id generado automaticamente del usuario en firestore
        usuario_id = doc_ref[1].id

        # Añair identificador_celular a la coleccion denominada identificador_celular dentro de la coleccion usuario
        db.collection('usuario').document(usuario_id).collection('identificador_celular').add(identificador_celular.to_dict())


        # imprimir todos los campos creados del usuario incluyendo el id asignado de firestore
        print(f"Usuario creado con ID: {doc_ref[1].id}")

        usuario_id = doc_ref[1].id  # Acceder al ID del documento en la tupla devuelta por add()
        usuario.id = usuario_id
        return True
    except Exception as e:
        print(f"Error creating user: {e}")
        return False

def authenticate_user(db, correo, password):
    try:
        user_ref = db.collection('usuario').where('correo', '==', correo).limit(1).stream()
        for doc in user_ref:
            user = Usuario.from_dict(doc.to_dict())
            if user.password == password:
                return user
        return None
    except Exception as e:
        print(f"Error authenticating user: {e}")
        return None
