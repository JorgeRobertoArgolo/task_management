import 'package:flutter/material.dart';
import 'package:task_management/services/date_formatter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Agenda de Tarefas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              )
            ),
            Text(
                DateService.obterDataFormatadaAtual(),
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18.0,
              )
            ),
          ],
        ),
      ),
    );
  }
}
