import 'package:flutter/material.dart';
import 'package:mifact_prueba/views/widgets/dialog.dart';
import 'package:mifact_prueba/models/Tarea.dart';
import 'package:mifact_prueba/providers/TareaProvider.dart';
import 'package:provider/provider.dart';


class TareaPage extends StatefulWidget {
  final Tarea? wtarea;
  const TareaPage(this.wtarea, {super.key});

  @override
  State<TareaPage> createState() => _TareaPageState();
}

class _TareaPageState extends State<TareaPage> {

  Tarea mTarea = Tarea(id: 0, titulo: '', descripcion: '');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  bool existente = false;

  @override
  void initState() {
    if(widget.wtarea != null){
      setState(() {
        print(widget.wtarea!.id);
        mTarea = widget.wtarea!;
        _tituloController.text = mTarea.titulo;
        _descripcionController.text = mTarea.descripcion;
        existente = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tareaProvider = Provider.of<TareaProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi tarea"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Titulo',
                  ),
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'Este campo no puede estar vacío';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24,),
                TextFormField(
                  controller: _descripcionController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Descripción',
                  ),
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'Este campo no puede estar vacío';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),
                FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        mTarea.descripcion = _descripcionController.text;
                        mTarea.titulo = _tituloController.text;

                        if(existente){
                          mostrarDialogSuccess(context, !existente).then((value){
                            tareaProvider.updateTarea(mTarea);
                            Navigator.of(context).pop();
                          });

                        }else{
                          mostrarDialogSuccess(context, !existente).then((value){
                            tareaProvider.addTarea(mTarea);
                            Navigator.of(context).pop();
                          });
                        }
                      }
                    },
                    child: existente ? const Text("Actualizar tarea",) : const Text("Agregar tarea",)
                ),
                Image.asset('assets/tarea2.png', width: MediaQuery.of(context).size.width*.9,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
