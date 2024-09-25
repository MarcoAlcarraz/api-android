import 'package:flutter/material.dart';
import 'package:mifact_prueba/DataBase/SQLite.dart';
import 'package:mifact_prueba/models/Tarea.dart';

class TareaProvider with ChangeNotifier {

  List<Tarea> _tareasDisponibles = [];
  List<Tarea> _tareasTermindas = [];

  List<Tarea> get tareas => _tareasDisponibles;
  List<Tarea> get tareasTerminadas => _tareasTermindas;

  TareaProvider() {
    cargarTareas();
    cargarTareasTerminadas();
  }

  void cargarTareas() async {
    _tareasDisponibles = await BD.leerTareasPendientes();
    notifyListeners();
  }

  void cargarTareasTerminadas() async {
    _tareasTermindas = await BD.leerTareasTermindas();
    notifyListeners();
  }

  void addTarea(Tarea tarea) async{
    await BD.insertarTarea(tarea);
    _tareasDisponibles.add(tarea);
    notifyListeners();
  }

  void editarTarea(Tarea _tarea) async {
    Tarea tarea = _tareasDisponibles.firstWhere((t) => t.id == _tarea.id);
    tarea.titulo = _tarea.titulo;
    tarea.descripcion = _tarea.titulo;
    tarea.isCompleted = !_tarea.isCompleted;
    await BD.actualizarTarea(tarea);
    notifyListeners();
  }

  void updateTareaCompletado(int id) async {
    Tarea tarea = _tareasDisponibles.firstWhere((t) => t.id == id);
    tarea.isCompleted = !tarea.isCompleted;

    await BD.actualizarTarea(tarea);

    _tareasDisponibles.removeWhere((t) => t.id == id);
    _tareasTermindas.add(tarea);
    notifyListeners();
  }

  void updateTareaCompletadoReverse(int id) async {
    Tarea tarea = _tareasTermindas.firstWhere((t) => t.id == id);
    tarea.isCompleted = !tarea.isCompleted;

    await BD.actualizarTarea(tarea);

    _tareasTermindas.removeWhere((t) => t.id == id);
    _tareasDisponibles.add(tarea);
    notifyListeners();
  }

  void eliminarTarea(Tarea tarea) async {
    _tareasTermindas.removeWhere((t) => t.id == tarea.id);

    await BD.elimnarTareaPermanente(tarea);
    notifyListeners();
  }

  void updateTarea(Tarea mtarea) async {
    Tarea tarea = _tareasDisponibles.firstWhere((t) => t.id == mtarea.id);
    tarea = mtarea;

    await BD.actualizarTarea(tarea);

    notifyListeners();
  }
}
