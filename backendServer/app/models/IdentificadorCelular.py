class IdentificadorCelular():
    def __init__(self, imei, ultima_conexion):
        self.imei = imei
        self.ultima_conexion = ultima_conexion

    def to_dict(self):
        return {
            'imei': self.imei,
            'ultima_conexion': self.ultima_conexion
        }

    @staticmethod
    def from_dict(source):
        return IdentificadorCelular(
            imei=source.get('imei'),
            ultima_conexion=source.get('ultima_conexion')
        )