import 'package:flutter/material.dart';
import 'package:task_management/screens/components/task_list.dart';
import 'components/empty_placeholder.dart';
import 'components/header_app_bar_home.dart';
import 'components/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasTasks = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderAppBar(),
      drawer: const Menu(),
      backgroundColor: const Color(0xFFF9FAFB),
      body: TaskList(),
    );
  }
}
