// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/api_client.dart';
import '../models/categorias.dart';
import '../models/producto.dart';
import '../services/categoria_service.dart';
import '../services/producto_service.dart';
import '../utils/app_colors.dart';
import '../widgets/boton_principal.dart';
import '../widgets/campo_texto.dart';

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
  List<Categorias> categoriasApi = [];
  bool _cargandoCategorias = true;
  bool _guardando = false;
  final CategoriaService _categoriaService = CategoriaService();
  final ProductoService _productoService = ProductoService();

  // 2. Variable para guardar la imagen seleccionada
  File? _imagenSeleccionada; 
  final ImagePicker _picker = ImagePicker(); // Instancia del selector

  final List<String> categorias = [
    "Cuadernos",
    "Papelería",
    "Lápices",
    "Arte",
    "Oficina",
    "Tecnología",
  ];

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    try {
      final result = await _categoriaService.listarCategorias();
      if (mounted) {
        setState(() {
          categoriasApi = result;
          _cargandoCategorias = false;
        });
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() => _cargandoCategorias = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    codigoController.dispose();
    precioController.dispose();
    cantidadController.dispose();
    super.dispose();
  }

  // 3. Función para seleccionar la imagen
  Future<void> _seleccionarImagen() async {
    // Muestra un diálogo para elegir entre Cámara o Galería
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galería'),
                  onTap: () async {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _imagenSeleccionada = File(image.path);
                      });
                    }
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _imagenSeleccionada = File(image.path);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> guardarProducto() async {
    if (_formKey.currentState!.validate() && categoriaSeleccionada != null && !_guardando) {
      if (categoriaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Seleccione una categoría")),
        );
        return;
      }
      
      // VALIDACIÓN: Verificar si seleccionó imagen (si el inge lo pide obligatorio)
      // if (_imagenSeleccionada == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Por favor, seleccione una imagen")),
      //   );
      //   return;
      // }

      setState(() => _guardando = true);
      try {
        await _productoService.crearProducto(
          Producto(
            id: 0,
            nombre: nombreController.text.trim(),
            codigo: codigoController.text.trim(),
            precio: double.tryParse(precioController.text.trim()) ?? 0,
            stock: int.tryParse(cantidadController.text.trim()) ?? 0,
            imagen: _imagenSeleccionada?.path ?? '',
            categoriaId: int.tryParse(categoriaSeleccionada!),
          ),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Producto agregado correctamente")),
        );
        Navigator.pop(context);
      } on ApiException catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message)),
          );
        }
      } finally {
        if (mounted) setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: const Text("Agregar Producto"),
        backgroundColor: AppColors.primary,
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
                // 4. Adaptamos el CircleAvatar para que sea clickeable y muestre la imagen
                Center(
                  child: GestureDetector(
                    onTap: _seleccionarImagen, // Llamamos a la función al tocar
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFEADBC8),
                      // LÓGICA AQUÍ: Si hay imagen, la muestra. Si no, muestra el icono.
                      backgroundImage: _imagenSeleccionada != null 
                          ? FileImage(_imagenSeleccionada!) 
                          : null,
                      child: _imagenSeleccionada == null
                          ? const Icon(
                              Icons.add_photo_alternate,
                              size: 45,
                              color: AppColors.primary,
                            )
                          : null, // Si hay fondo, no mostramos el icono encima
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Toca para seleccionar imagen",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 25),
                // Resto de tus campos igual...
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
                  value: categoriaSeleccionada,
                  decoration: InputDecoration(
                    labelText: "Categoría",
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: categoriasApi.map((categoria) {
                    return DropdownMenuItem(
                      value: categoria.id.toString(),
                      child: Text(categoria.nombre),
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
                  onPressed: _guardando || _cargandoCategorias
                      ? () {}
                      : guardarProducto,
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
