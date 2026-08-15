import 'package:flutter/material.dart';
import '../widgets/campo_texto.dart';
import '../widgets/boton_principal.dart';

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final codigoController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();

  String? categoriaSeleccionada;

  final List<String> categorias = [
    "Cuadernos",
    "Papelería",
    "Lápices",
    "Arte",
    "Oficina",
    "Tecnología",
  ];

  @override
  void dispose() {
    nombreController.dispose();
    codigoController.dispose();
    precioController.dispose();
    cantidadController.dispose();
    super.dispose();
  }

  void guardarProducto() {
    if (_formKey.currentState!.validate()) {
      if (categoriaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Seleccione una categoría"),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Producto agregado correctamente"),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: const Text("Agregar Producto"),
        backgroundColor: const Color(0xFF8B5E3C),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFEADBC8),
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 45,
                      color: Color(0xFF8B5E3C),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                CampoTexto(
                  label: "Nombre",
                  icono: Icons.inventory,
                  controlador: nombreController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese el nombre";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CampoTexto(
                  label: "Código",
                  icono: Icons.qr_code,
                  controlador: codigoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese el código";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: categoriaSeleccionada,
                  decoration: InputDecoration(
                    labelText: "Categoría",
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: categorias.map((categoria) {
                    return DropdownMenuItem(
                      value: categoria,
                      child: Text(categoria),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      categoriaSeleccionada = valor;
                    });
                  },
                ),
                const SizedBox(height: 15),
                CampoTexto(
                  label: "Precio",
                  icono: Icons.attach_money,
                  controlador: precioController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese el precio";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CampoTexto(
                  label: "Cantidad",
                  icono: Icons.numbers,
                  controlador: cantidadController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese la cantidad";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                BotonPrincipal(
                  texto: "Guardar Producto",
                  onPressed: guardarProducto,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}