import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_box_outlined, color: Colors.blue,),
              SizedBox(width: 5.0,),
              Text(
                "Agenda de Tarefas",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.calendar_today, size: 20.0,
                color: Colors.black),
            label: Text("Hoje", style: TextStyle(
                fontSize: 20.0,
                color: Colors.black
            ),),
          ),
          SizedBox(height: 20.0,),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.calendar_month, size: 20.0,
                color: Colors.black),
            label: Text("Calendário", style: TextStyle(
                fontSize: 20.0,
                color: Colors.black
            ),),
          ),
          SizedBox(height: 20.0,),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.bar_chart, size: 20.0,
                color: Colors.black),
            label: Text("Relatórios", style: TextStyle(
                fontSize: 20.0,
                color: Colors.black
            ),),
          ),
        ],
      ),
    );
  }
}
