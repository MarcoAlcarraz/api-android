import 'package:mifact_prueba/DataBase/Tablas/TablaTarea.dart';
import 'package:mifact_prueba/models/Tarea.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void onCreate(Database db) {
  String tablaTarea = 'CREATE TABLE ${TablaTarea.NOMBRE} ( '
      '${TablaTarea.ID} INTEGER PRIMARY KEY, '
      '${TablaTarea.TITULO} TEXT, '
      '${TablaTarea.DESCRIPCION} TEXT, '
      '${TablaTarea.IS_COMPLETED} INTEGER '
      ')';
  db.execute(tablaTarea);
}

void onUpgrade(Database db){
  db.execute('DROP TABLE IF EXISTS ${TablaTarea.NOMBRE}');
  onCreate(db);
}

class BD{
  static Future<Database> _openBD() async {
    return openDatabase(
        p.join(await getDatabasesPath(), 'app.db'),
        onUpgrade: (db, versionAnt, versionNue) => onUpgrade(db),
        onCreate: (db, version) => onCreate(db),
        version: 1
    );
  }

  static Future<List<Tarea>> leerTareasPendientes() async {
    List<Tarea> listTareas = [];

    Database database = await _openBD();
    final List<Map<String, dynamic>> listTabla;

    listTabla = await database.query(TablaTarea.NOMBRE, where: '${TablaTarea.IS_COMPLETED} = 0');

    if(listTabla.isNotEmpty){
      for(var e in listTabla){
        listTareas.add(Tarea.fromMap(e));
      }
    }
    return listTareas;
  }

  static Future<List<Tarea>> leerTareasTermindas() async {
    List<Tarea> listTareas = [];

    Database database = await _openBD();
    final List<Map<String, dynamic>> listTabla;

    listTabla = await database.query(TablaTarea.NOMBRE, where: '${TablaTarea.IS_COMPLETED} = 1');

    if(listTabla.isNotEmpty){
      for(var e in listTabla){
        listTareas.add(Tarea.fromMap(e));
      }
    }
    return listTareas;
  }

  static Future insertarTarea(Tarea tarea) async {
    Database database = await _openBD();
    return database.insert(TablaTarea.NOMBRE, tarea.toMap());
  }

  static Future elimnarTarea(Tarea tarea) async {
    tarea.isCompleted = !tarea.isCompleted;
    Database database = await _openBD();
    return database.update(TablaTarea.NOMBRE, tarea.toMap(), where: "${TablaTarea.ID} = ${tarea.id}");
  }

  static Future actualizarTarea(Tarea tarea) async {
    Database database = await _openBD();
    return database.update(TablaTarea.NOMBRE, tarea.toMap(), where: "${TablaTarea.ID} = ${tarea.id}");
  }

  static Future elimnarTareaPermanente(Tarea tarea) async {
    Database database = await _openBD();
    return database.delete(TablaTarea.NOMBRE, where: "${TablaTarea.ID} = ${tarea.id}");
  }



}