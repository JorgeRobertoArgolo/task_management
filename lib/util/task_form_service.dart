import 'package:flutter/material.dart';

/// Serviço de utilitários para formulários de tarefas.
class TaskFormService {
  /// Exibe o seletor de horário.
  static Future<TimeOfDay?> selecionarHorario(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  /// Exibe o seletor de data.
  static Future<DateTime?> selecionarData(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }
}
