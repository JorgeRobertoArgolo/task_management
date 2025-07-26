import 'package:get/get.dart';

import '../screens/home_screen.dart';
import '../screens/task_form_screen.dart';

class RouteHelper {
  //Rotas nomeadas
  static const String home = '/';
  static const String taskForm = '/task-form';

  //Métodos para navegação
  static String getHomeScreen() => home;
  static String getTaskFormScreen() => taskForm;

  //Lista de rotas GetX
  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: taskForm, page: () => TaskFormScreen())
  ];


}