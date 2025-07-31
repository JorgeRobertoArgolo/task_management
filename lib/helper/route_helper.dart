import 'package:get/get.dart';
import 'package:task_management/screens/report_screen.dart';

import '../screens/home_screen.dart';
import '../screens/task_form_screen.dart';

class RouteHelper {
  //Rotas nomeadas
  static const String home = '/';
  static const String taskForm = '/task-form';
  static const String report = '/report';

  //Métodos para navegação
  static String getHomeScreen() => home;
  static String getTaskFormScreen() => taskForm;
  static String getReportScreen() => report;

  //Lista de rotas GetX
  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: taskForm, page: () => TaskFormScreen()),
    GetPage(name: report, page: () => ReportScreen())
  ];


}