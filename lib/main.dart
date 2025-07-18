import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:task_management/screens/home_screen.dart';



void main() async{
  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR'; // define o locale padrão (opcional, mas recomendável)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agenda de Tarefas",
      home: HomeScreen(),
    );
  }
}
