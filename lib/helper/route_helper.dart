import 'package:get/get.dart';
import 'package:task_management/screens/calendar_screen.dart';
import 'package:task_management/screens/report_screen.dart';
import '../screens/home_screen.dart';
import '../screens/task_form_screen.dart';

class RouteHelper {
  // Rotas nomeadas
  static const String home = '/';
  static const String taskForm = '/task-form';
  static const String report = '/report';
  static const String calendar = '/calendar';

  // Métodos para navegação
  static String getInitialRoute() => home;
  static String getTaskFormScreen() => taskForm;
  static String getReportScreen() => report;
  static String getCalendarScreen() => calendar;

  // Lista de rotas GetX
  static List<GetPage> routes = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: taskForm, page: () => const TaskFormScreen()),
    GetPage(name: report, page: () => const ReportScreen()),
    GetPage(name: calendar, page: () => const CalendarScreen()),
  ];
}