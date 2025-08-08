import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/helper/route_helper.dart';
import 'package:task_management/util/theme.dart';
import '../../util/date_formatter.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      toolbarHeight: 70.0,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hoje",
            style: AppTextStyles.screenTitle.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 4.0),
          Text(
            DateService.obterDataFormatadaAtual(),
            style: AppTextStyles.secondaryBodyText,
          ),
        ],
      ),
      actions: [

        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () => Get.toNamed(RouteHelper.getTaskFormScreen()),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}