import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:task_management/screens/home_screen.dart';
import 'package:task_management/screens/task_form_screen.dart';



void main() async{
  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR'; // define o locale padrão (opcional, mas recomendável)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => HomeScreen()),
        GetPage(name: "/task-form", page: () => TaskFormScreen())
      ],
      title: "Agenda de Tarefas",
    );
  }
}
