import 'package:flutter/material.dart';

mostrarDialogSuccess(BuildContext context, bool nuevo) async {
  return showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black54,
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          icon: Icon(Icons.check, size: 48, color: Colors.green,),
          title: nuevo ? Text('Nueva tarea creada') : Text("Tarea actualizada"),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
  );
}

Future<bool> mostrarDialogConfirm(BuildContext context, bool terminada) async {
  return await showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black54,
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          icon: const Icon(Icons.check, size: 48, color: Colors.green,),
          title: terminada ? const Text('¿Desea activar la tarea?') : const Text('¿Se terminó la tarea?'),
          actions: [
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                Navigator.of(context).pop(true);

              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      }
  );

}

Future<bool> mostrarDialogConfirmAlert(BuildContext context) async {
  return await showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black54,
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          icon: const Icon(Icons.warning, size: 48, color: Colors.red,),
          title: const Text('¿Seguro que desea eliminar la tarea?'),
          actions: [
            TextButton(
              child: const Text('Sí', style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      }
  );

}