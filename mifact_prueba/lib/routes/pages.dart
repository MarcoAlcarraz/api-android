import 'package:flutter/material.dart';
import 'package:mifact_prueba/routes/routes.dart';
import 'package:mifact_prueba/views/pages/HomePage.dart';
import 'package:mifact_prueba/views/pages/TareaPage.dart';

Map<String, Widget Function(BuildContext)> appRoutes(){
  return{
    Routes.HOME:(_) => const HomePage(),
    Routes.TAREA:(_) => const TareaPage(null),
  };
}