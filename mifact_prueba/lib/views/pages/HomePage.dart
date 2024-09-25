import 'package:flutter/material.dart';
import 'package:mifact_prueba/DataBase/SQLite.dart';
import 'package:mifact_prueba/views/pages/TareaPage.dart';
import 'package:mifact_prueba/views/widgets/dialog.dart';
import 'package:mifact_prueba/models/Tarea.dart';
import 'package:mifact_prueba/providers/TareaProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Tarea> mTareas = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  Widget sinDatos(){
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_task, size: 48, color: Colors.grey,),
          Text("Sin registro de tareas")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tareaProvider = Provider.of<TareaProvider>(context);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mis tareas"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.done),
                text: "Pendientes",
              ),
              Tab(
                icon: Icon(Icons.done_all),
                text: "Terminados",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            tareaProvider.tareas.isNotEmpty ?  Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListView.builder(
                itemCount: tareaProvider.tareas.length,
                itemBuilder: (context, index) {
                  final t = tareaProvider.tareas[index];
                  return ExpansionTile(
                    tilePadding:  EdgeInsets.zero,
                    title: Text(
                      t.titulo,
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF3A3A3A),
                        decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: IconButton(
                        onPressed: (){
                          mostrarDialogConfirm(context, t.isCompleted).then((value){
                            if(value){
                              tareaProvider.updateTareaCompletado(t.id);
                            }
                          });
                        },
                        icon: t.isCompleted ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank)
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(t.descripcion),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TareaPage(t),
                                  ),
                                );

                              },
                              color: Colors.blue,
                              icon: const Icon(Icons.edit)
                          ),
                          const IconButton(
                              onPressed: null,
                              color: Colors.red,
                              icon: Icon(Icons.delete)
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ): sinDatos(),
            tareaProvider.tareasTerminadas.isNotEmpty ?  Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListView.builder(
                itemCount: tareaProvider.tareasTerminadas.length,
                itemBuilder: (context, index) {
                  final t = tareaProvider.tareasTerminadas[index];
                  return ExpansionTile(
                    tilePadding:  EdgeInsets.zero,
                    title: Text(
                      t.titulo,
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF3A3A3A),
                        decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: IconButton(
                        onPressed: (){
                          mostrarDialogConfirm(context, t.isCompleted).then((value){
                            if(value){
                              tareaProvider.updateTareaCompletadoReverse(t.id);
                            }

                          });
                        },
                        icon: t.isCompleted ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank)
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(t.descripcion),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const IconButton(
                              onPressed: null,
                              color: Colors.blue,
                              icon: Icon(Icons.edit)
                          ),
                          IconButton(
                              onPressed: () async {
                                await mostrarDialogConfirmAlert(context).then((value) {
                                  if(value){
                                    tareaProvider.eliminarTarea(t);
                                  }
                                },);

                              },
                              color: Colors.red,
                              icon: const Icon(Icons.delete)
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ): sinDatos(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TareaPage(null),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
