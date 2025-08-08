import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:task_management/helper/route_helper.dart';

import 'firebase_options.dart';
import 'helper/get_di.dart' as di;

class AppColors {
  static const background = Color(0xFFF7F7F7);
  static const accent = Color(0xFF0A84FF);
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR';
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Agenda de Tarefas",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: RouteHelper.getInitialRoute(),
      getPages: RouteHelper.routes,
    );
  }
}