import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/helper/route_helper.dart';
import '../../util/date_formatter.dart';
class AppStyle {
  static const double appBarHeight = 80.0;
  static const double spacingSmall = 4.0;
  static const double buttonPadding = 12.0;
}

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(AppStyle.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hoje",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppStyle.spacingSmall),
          Text(
            DateService.obterDataFormatadaAtual(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppStyle.buttonPadding / 2),
          child: IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar Tarefa',
            onPressed: () => Get.toNamed(RouteHelper.getTaskFormScreen()),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              padding: const EdgeInsets.all(AppStyle.buttonPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}