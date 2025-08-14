import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/features/task/controller/task_controller.dart';
import '../features/task/domain/models/task_enum.dart';
import '../features/task/domain/models/task_model.dart';
import '../util/theme.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TaskController taskController = Get.find<TaskController>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  Frequency _selectedFrequency = Frequency.once;
  final List<String> _weekDays = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"];
  final List<String> _selectedWeekDays = [];

  Task? _editingTask;
  bool get _isEditing => _editingTask != null;

  @override
  void initState() {
    super.initState();
    final arg = Get.arguments;
    if (arg is Task) {
      _editingTask = arg;
      _titleController.text = arg.title;
      _descriptionController.text = arg.description;
      _selectedFrequency = arg.frequency;
      _selectedDate = arg.date;
      if (arg.specificWeekDays != null) {
        _selectedWeekDays.addAll(arg.specificWeekDays!);
      }
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFrequency == Frequency.specificDays && _selectedWeekDays.isEmpty) {
      Get.snackbar("Atenção", "Selecione ao menos um dia da semana.",
          backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }
    if (_selectedFrequency == Frequency.once && _selectedDate == null) {
      Get.snackbar("Atenção", "Por favor, selecione uma data.",
          backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }

    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (_selectedFrequency == Frequency.once && _selectedDate != null) {
      final selected = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
      if (selected.isBefore(today)) {
        Get.snackbar("Data inválida", "Não é possível criar tarefas para dias passados.",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
    }

    DateTime? adjustedStartDate;
    if (_selectedFrequency == Frequency.daily) {
      if (_isEditing && _editingTask != null && _editingTask!.startDate != null) {
        if (_editingTask!.startDate!.isBefore(today)) {
          adjustedStartDate = today;
        } else {
          adjustedStartDate = _editingTask!.startDate!;
        }
      } else {
        adjustedStartDate = today;
      }
    } else {
      adjustedStartDate = null;
    }

    final task = Task(
      id: _editingTask?.id ?? UniqueKey().toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      frequency: _selectedFrequency,
      status: _editingTask?.status ?? false,
      specificWeekDays: _selectedFrequency == Frequency.specificDays ? _selectedWeekDays : null,
      date: _selectedFrequency == Frequency.once ? _selectedDate : null,
      startDate: adjustedStartDate,
    );

    if (_isEditing) {
      await taskController.updateTask(task);
    } else {
      await taskController.addTask(task);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondaryText),
          onPressed: () => Get.back(),
        ),
        title: Text(
          _isEditing ? 'Editar Tarefa' : 'Nova Tarefa',
          style: const TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text(
              'Salvar',
              style: AppTextStyles.buttonLabel.copyWith(color: AppColors.accent),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('TAREFA'),
              _buildTextField(
                controller: _titleController,
                hint: 'Ex: Estudar Flutter',
                validator: (value) => value == null || value.isEmpty ? 'O título é obrigatório.' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _descriptionController,
                hint: 'Adicionar uma descrição...',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('FREQUÊNCIA'),
              _buildFrequencySelector(),
              const SizedBox(height: 24),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: SizeTransition(sizeFactor: animation, child: child)),
                child: _buildConditionalFields(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: AppTextStyles.sectionHeader),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.secondaryText),
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildFrequencySelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: Frequency.values.map((freq) {
          final isSelected = _selectedFrequency == freq;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFrequency = freq),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatFrequency(freq),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.secondaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConditionalFields() {
    if (_selectedFrequency == Frequency.once) {
      return Column(
        key: const ValueKey('date_picker'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('DATA'),
          _buildDatePicker(),
        ],
      );
    } else if (_selectedFrequency == Frequency.specificDays) {
      return Column(
        key: const ValueKey('day_selector'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('DIAS DA SEMANA'),
          _buildWeekDaySelector(),
        ],
      );
    }
    return Container(key: const ValueKey('empty'));
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                _selectedDate != null ? DateFormat.yMMMMd('pt_BR').format(_selectedDate!) : 'Selecione uma data',
                style: AppTextStyles.bodyText.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _selectedDate != null ? AppColors.primaryText : AppColors.secondaryText)
            ),
            const Icon(CupertinoIcons.calendar, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }


  Widget _buildWeekDaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDays.map((day) {
        final isSelected = _selectedWeekDays.contains(day);
        return GestureDetector(
          onTap: () {
            setState(() {
              isSelected ? _selectedWeekDays.remove(day) : _selectedWeekDays.add(day);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent : AppColors.cardBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day.substring(0, 1),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.secondaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatFrequency(Frequency frequency) {
    switch (frequency) {
      case Frequency.once: return 'Uma vez';
      case Frequency.daily: return 'Diário';
      case Frequency.specificDays: return 'Semanal';
    }
  }
}