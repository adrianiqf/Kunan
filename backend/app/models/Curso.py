class Curso():
    def __init__(self, ciclo, dia, hora_inicio, hora_fin, nombre, id_profesor):
        self.ciclo = ciclo
        self.dia = dia
        self.hora_inicio = hora_inicio
        self.hora_fin = hora_fin
        self.nombre = nombre
        self.id_profesor = id_profesor

    def to_dict(self):
        return {
            'ciclo': self.ciclo,
            'dia': self.dia,
            'hora_inicio': self.hora_inicio,
            'hora_fin': self.hora_fin,
            'nombre': self.nombre,
            'id_profesor': self.id_profesor
        }

    @staticmethod
    def from_dict(source):
        return Curso(
            ciclo=source.get('ciclo'),
            dia=source.get('dia'),
            hora_inicio=source.get('hora_inicio'),
            hora_fin=source.get('hora_fin'),
            nombre=source.get('nombre'),
            id_profesor=source.get('id_profesor')
        )