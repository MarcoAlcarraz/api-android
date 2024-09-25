import 'package:flutter/material.dart';
import 'package:mifact_prueba/providers/TareaProvider.dart';
import 'package:mifact_prueba/routes/pages.dart';
import 'package:mifact_prueba/routes/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TareaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: Routes.HOME,
      routes: appRoutes(),
    );
  }
}

