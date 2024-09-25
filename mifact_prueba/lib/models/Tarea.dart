import 'package:mifact_prueba/DataBase/Tablas/TablaTarea.dart';

class Tarea{
  final int id;
  String titulo;
  String descripcion;
  bool isCompleted;

  Tarea({required this.id, required this.titulo, required this.descripcion, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      TablaTarea.TITULO: titulo,
      TablaTarea.DESCRIPCION: descripcion,
      TablaTarea.IS_COMPLETED: isCompleted ? 1 : 0,
    };
  }

  static Tarea fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map[TablaTarea.ID],
      titulo: map[TablaTarea.TITULO],
      descripcion: map[TablaTarea.DESCRIPCION],
      isCompleted: map[TablaTarea.IS_COMPLETED] == 1,
    );
  }
}