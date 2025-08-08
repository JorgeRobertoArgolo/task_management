import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/helper/route_helper.dart';

class AppColors {
  static const background = Color(0xFFF7F7F7);
  static const primaryText = Color(0xFF1D2D44);
  static const secondaryText = Color(0xFF747474);
  static const cardBackground = Color(0xFFFFFFFF);
  static const accent = Color(0xFF0A84FF);
}

class AppTextStyles {
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  static const TextStyle menuLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = Get.currentRoute;

    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: Column(
        children: [
          _buildDrawerHeader(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.home_rounded,
                  title: 'Hoje',
                  routeName: RouteHelper.getInitialRoute(),
                  currentRoute: currentRoute,
                ),
                _buildMenuItem(
                  icon: Icons.calendar_month_rounded,
                  title: 'Calendário',
                  routeName: RouteHelper.getCalendarScreen(),
                  currentRoute: currentRoute,
                ),
                _buildMenuItem(
                  icon: Icons.bar_chart_rounded,
                  title: 'Relatórios',
                  routeName: RouteHelper.getReportScreen(),
                  currentRoute: currentRoute,
                ),
              ],
            ),
          ),

          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Versão 1.0.0',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 28),
          const SizedBox(width: 12.0),
          const Text(
            "Agenda de Tarefas",
            style: AppTextStyles.sectionTitle,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String routeName,
    required String currentRoute,
  }) {
    final bool isSelected = currentRoute == routeName;

    return ListTile(
      leading: Icon(
        icon,
        size: 24.0,
        color: isSelected ? AppColors.accent : AppColors.secondaryText,
      ),
      title: Text(
        title,
        style: AppTextStyles.menuLabel.copyWith(
          color: isSelected ? AppColors.accent : AppColors.primaryText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      tileColor: isSelected ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        Get.back();
        if (!isSelected) {
          Get.toNamed(routeName);
        }
      },
    );
  }
}