import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:task_management/helper/route_helper.dart';
import 'package:task_management/screens/home_screen.dart';
import 'package:task_management/screens/task_form_screen.dart';

import 'firebase_options.dart';
import 'helper/get_di.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR'; // define o locale padrão (opcional, mas recomendável)
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Agenda de Tarefas",
      initialRoute: RouteHelper.getHomeScreen(),
      getPages: RouteHelper.routes,
    );
  }
}
