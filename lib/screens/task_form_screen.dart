import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/features/task/controller/task_controller.dart';
import '../features/task/domain/models/task_enum.dart';
import '../features/task/domain/models/task_model.dart';
import '../util/task_form_service.dart';

/// Tela de formulário para criação de nova tarefa.
class TaskFormScreen extends StatefulWidget {
  final void Function(Task)? onSubmit;

  const TaskFormScreen({super.key, this.onSubmit});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  //Controller
  final TaskController taskController = Get.find<TaskController>();
  //Validar formulários
  final _formKey = GlobalKey<FormState>();
  //controllers dos campos de texto
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  Frequency _selectedFrequency = Frequency.once;

  /*
  * Permite selecionar a hora, e atualiza para a hora especificada
  * */
  void _pickTime() async {
    final picked = await TaskFormService.selecionarHorario(context);
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  /*
  * Permite selecionar a data, e atualiza para a data especificada
  * */
  void _pickDate() async {
    final picked = await TaskFormService.selecionarData(context);
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /*
  * Valida o formulário
  * */
  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: UniqueKey().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        frequency: _selectedFrequency,
      );

      await taskController.addTask(task);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Tarefa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nome da Tarefa *"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Digite o nome da tarefa",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              const Text("Descrição"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Descrição opcional",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Horário (opcional)"),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _selectedTime != null
                              ? _selectedTime!.format(context)
                              : "--:-- --",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.access_time),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Frequência"),
              ListTile(
                title: const Text("Uma vez"),
                leading: Radio<Frequency>(
                  value: Frequency.once,
                  groupValue: _selectedFrequency,
                  onChanged: (value) {
                    setState(() {
                      _selectedFrequency = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Todos os dias"),
                leading: Radio<Frequency>(
                  value: Frequency.daily,
                  groupValue: _selectedFrequency,
                  onChanged: (value) {
                    setState(() {
                      _selectedFrequency = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Dias específicos da semana"),
                leading: Radio<Frequency>(
                  value: Frequency.specificDays,
                  groupValue: _selectedFrequency,
                  onChanged: (value) {
                    setState(() {
                      _selectedFrequency = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text("Data"),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? "${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}"
                            : "Selecione a data",
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                      ),
                      child: const Text("Criar"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
