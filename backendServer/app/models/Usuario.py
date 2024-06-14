#from .IdentificadorCelular import IdentificadorCelular


class Usuario():
    def __init__(self, nombres, apellidos, codigo, correo, esProfesor, id_escuela, password):
        self.nombres = nombres
        self.apellidos = apellidos
        self.codigo = codigo
        self.correo = correo
        self.esProfesor = esProfesor
        self.id_escuela = id_escuela
        self.password = password
        #self.identificador_celular = identificador_celular if identificador_celular else []

    def to_dict(self):
        return {
            'nombres': self.nombres,
            'apellidos': self.apellidos,
            'codigo': self.codigo,
            'correo': self.correo,
            'esProfesor': self.esProfesor,
            'id_escuela': self.id_escuela,
            'password': self.password,
            #'identificador_celular': [ic.to_dict() for ic in self.identificador_celular]
        }

    @staticmethod
    def from_dict(source):
        return Usuario(
            nombres=source.get('nombres'),
            apellidos=source.get('apellidos'),
            codigo=source.get('codigo'),
            correo=source.get('correo'),
            esProfesor=source.get('esProfesor'),
            id_escuela=source.get('id_escuela'),
            password=source.get('password'),
            #identificador_celular=[IdentificadorCelular.from_dict(ic) for ic in source.get('identificador_celular', [])]
        )