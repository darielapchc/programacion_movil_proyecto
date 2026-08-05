import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[ 
              //Logo 
              Image.asset(
                'assets/images/logo.png',
                width:150,
                height:100,
              ),
              SizedBox(height: 25),

              Text(
                "LNE Stock", 
                style: TextStyle(
                  fontSize: 36, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5E00),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Control de Inventario",
                style: TextStyle(
                  fontSize:22,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 35),

              Text(
                "Inventario de Libreria Y Novedades Emanuel", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height:50, 
                child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B5E00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Ingresar", 
                    style: TextStyle(
                      fontSize:18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user,
                  color: Colors.blueGrey
                  ),
                  SizedBox(width: 8), 

                  Text(
                    "Solo personal autorizado",
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}