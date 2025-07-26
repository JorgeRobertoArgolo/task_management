import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/helper/route_helper.dart';
import '../../util/date_formatter.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hoje",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
          ),
          const SizedBox(height: 2),
          Text(
            DateService.obterDataFormatadaAtual(),
            style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Get.toNamed(RouteHelper.getTaskFormScreen());
          },
          style: IconButton.styleFrom(
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
          ),
        )
      ],
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
}
