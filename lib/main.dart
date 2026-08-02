import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'LNE Stock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title: const Text('LNE Stock'),
      ),
      body: const Center(
        child: Text(
          "Bienvenido al sistema de inventario de Libreria y Novedades Emanuel",
          textAlign: TextAlign.center,
          style:TextStyle(
            fontSize:20,
          )
        )
      )
    );
  }
}
