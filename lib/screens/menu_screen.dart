import 'package:flutter/material.dart';
import 'package:inventario_application_1/widgets/menu_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F5F0),
          appBar: AppBar(
          title: const Text("LNE Stock"),
          centerTitle: true,
          backgroundColor:  const Color(0xFF8B5E00),
          foregroundColor: Colors.white,
        ),
        body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text(
          "¡Bienvenido!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height:8),
        const Text(
        "Selecciona una opción",
          style: TextStyle(
            fontSize:18,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height:25),
        Expanded(
          child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
        MenuCard(
          titulo: "Inventario",
          icono: Icons.inventory_2,
          color: Colors.brown,
          onTap: (){

          },
        ),
        MenuCard(
          titulo: "Productos",
          icono: Icons.shopping_bag,
          color: Colors.blue,
          onTap: (){

          },
        ),
        MenuCard(
          titulo: "Categorías",
          icono: Icons.category,
          color: Colors.green,
          onTap: (){

          },
        ),
        MenuCard(
          titulo: "Agregar",
          icono: Icons.add_circle,
          color: Colors.orange,
          onTap: (){

      },
    ),

    ],

),

),

],

),

),

);

}
}