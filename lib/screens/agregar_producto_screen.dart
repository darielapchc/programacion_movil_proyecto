import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../models/categorias.dart';
import '../models/producto.dart';
import '../services/categoria_service.dart';
import '../services/producto_service.dart';
import '../utils/app_colors.dart';
import '../utils/product_icon_mapper.dart';
import '../widgets/boton_principal.dart';
import '../widgets/campo_texto.dart';

class AgregarProductoScreen extends StatefulWidget {
  final Producto? producto;

  const AgregarProductoScreen({
    super.key,
    this.producto,
  });

  @override
  State<AgregarProductoScreen> createState() =>
      _AgregarProductoScreenState();
}

class _AgregarProductoScreenState
    extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final codigoController = TextEditingController();
  final precioController = TextEditingController();
  final cantidadController = TextEditingController();

  String? categoriaSeleccionada;
  String _iconoSeleccionado = 'inventory_2';

  List<Categorias> categoriasApi = [];

  bool _cargandoCategorias = true;
  bool _guardando = false;

  final CategoriaService _categoriaService =
      CategoriaService();

  final ProductoService _productoService =
      ProductoService();

  bool get _modoEdicion => widget.producto != null;

  @override
  void initState() {
    super.initState();

    _precargarProducto();
    _cargarCategorias();
  }

  void _precargarProducto() {
    final producto = widget.producto;

    if (producto == null) return;

    nombreController.text = producto.nombre;
    descripcionController.text = producto.descripcion;
    codigoController.text = producto.codigo;
    precioController.text = producto.precio.toString();

    categoriaSeleccionada =
        producto.categoriaId?.toString();

    if (producto.imagen.isNotEmpty) {
      _iconoSeleccionado = producto.imagen;
    }

    cantidadController.text =
        producto.stock.toString();
  }

  Future<void> _cargarCategorias() async {
    try {
      final result =
          await _categoriaService.listarCategorias();

      if (!mounted) return;

      setState(() {
        categoriasApi = result;
        _cargandoCategorias = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _cargandoCategorias = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
        ),
      );
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    codigoController.dispose();
    precioController.dispose();
    cantidadController.dispose();

    super.dispose();
  }

  void _mostrarSelectorIconos() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFF8F5F0),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Selecciona un icono',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Elige el icono que representa tu producto.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  itemCount:
                      ProductIconMapper.icons.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final entry =
                        ProductIconMapper.icons.entries
                            .elementAt(index);

                    final seleccionado =
                        entry.key == _iconoSeleccionado;

                    return InkWell(
                      borderRadius:
                          BorderRadius.circular(15),
                      onTap: () {
                        setState(() {
                          _iconoSeleccionado = entry.key;
                        });

                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: seleccionado
                              ? AppColors.primary
                                  .withValues(alpha: 0.15)
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(15),
                          border: Border.all(
                            color: seleccionado
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              entry.value,
                              size: 32,
                              color: AppColors.primary,
                            ),

                            const SizedBox(height: 6),

                            Text(
                              _nombreIcono(entry.key),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _nombreIcono(String clave) {
    const nombres = {
      'menu_book': 'Cuaderno',
      'edit': 'Lápiz',
      'description': 'Papel',
      'palette': 'Arte',
      'business_center': 'Oficina',
      'school': 'Escolar',
      'create': 'Lapicero',
      'brush': 'Marcador',
      'backspace': 'Borrador',
      'straighten': 'Regla',
      'content_cut': 'Tijeras',
      'inventory_2': 'Producto',
      'folder': 'Carpeta',
      'print': 'Impresión',
      'computer': 'Computadora',
      'calculate': 'Calculadora',
      'auto_stories': 'Libro',
      'sticky_note_2': 'Notas',
      'construction': 'Herramientas',
    };

    return nombres[clave] ?? 'Producto';
  }

  Future<void> _guardarProductoCrear() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Seleccione una categoría',
          ),
        ),
      );
      return;
    }

    if (_guardando) return;

    setState(() {
      _guardando = true;
    });

    try {
      final producto = Producto(
        id: 0,
        nombre: nombreController.text.trim(),
        descripcion:
            descripcionController.text.trim(),
        codigo: codigoController.text.trim(),
        precio:
            double.tryParse(
              precioController.text.trim(),
            ) ??
            0,
        stock:
            int.tryParse(
              cantidadController.text.trim(),
            ) ??
            0,
        imagen: _iconoSeleccionado,
        categoriaId:
            int.tryParse(
              categoriaSeleccionada!,
            ),
      );

      final creado =
          await _productoService.crearProducto(
        producto,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Producto agregado correctamente',
          ),
        ),
      );

      Navigator.pop(context, creado);
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Seleccione una categoría',
          ),
        ),
      );
      return;
    }

    if (_guardando) return;

    setState(() {
      _guardando = true;
    });

    try {
      final datos = <String, dynamic>{
        'nombre': nombreController.text.trim(),
        'descripcion':
            descripcionController.text.trim(),
        'codigo': codigoController.text.trim(),
        'precio':
            double.parse(
              precioController.text.trim(),
            ),
        'categoriaId':
            int.parse(
              categoriaSeleccionada!,
            ),
        'imagen': _iconoSeleccionado,
      };

      final actualizado =
          await _productoService.actualizarProducto(
        widget.producto!.id,
        datos,
      );

      if (!mounted) return;

      Navigator.pop(
        context,
        actualizado,
      );
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F5F0),

      appBar: AppBar(
        title: Text(
          _modoEdicion
              ? 'Editar producto'
              : 'Agregar producto',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),

          padding:
              const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,

              children: [
                // =========================
                // ICONO DEL PRODUCTO
                // =========================

                Center(
                  child: GestureDetector(
                    onTap: _mostrarSelectorIconos,

                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFEADBC8,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              AppColors.primary
                                  .withValues(
                                    alpha: 0.25,
                                  ),
                          width: 2,
                        ),
                      ),

                      child: Icon(
                        ProductIconMapper
                            .getIcon(
                          _iconoSeleccionado,
                        ),
                        size: 58,
                        color:
                            AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton.icon(
                  onPressed:
                      _mostrarSelectorIconos,

                  icon: const Icon(
                    Icons.edit,
                    size: 18,
                  ),

                  label: const Text(
                    'Elegir icono',
                  ),

                  style:
                      TextButton.styleFrom(
                    foregroundColor:
                        AppColors.primary,
                  ),
                ),

                const SizedBox(height: 15),

                // =========================
                // DESCRIPCIÓN
                // =========================

                CampoTexto(
                  label: 'Descripción',
                  icono:
                      Icons.description_outlined,
                  controlador:
                      descripcionController,
                ),

                const SizedBox(height: 15),

                // =========================
                // NOMBRE
                // =========================

                CampoTexto(
                  label: 'Nombre',
                  icono: Icons.inventory,
                  controlador:
                      nombreController,

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Ingrese el nombre';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // =========================
                // CÓDIGO
                // =========================

                CampoTexto(
                  label: 'Código',
                  icono: Icons.qr_code,
                  controlador:
                      codigoController,

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Ingrese el código';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // =========================
                // CATEGORÍA
                // =========================

                DropdownButtonFormField<String>(
                  initialValue:
                      categoriaSeleccionada,

                  decoration:
                      InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon:
                        const Icon(
                      Icons.category,
                    ),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Seleccione una categoría';
                    }

                    return null;
                  },

                  items: categoriasApi
                      .map(
                        (categoria) {
                          return DropdownMenuItem<
                              String>(
                            value:
                                categoria.id
                                    .toString(),
                            child: Text(
                              categoria.nombre,
                            ),
                          );
                        },
                      )
                      .toList(),

                  onChanged:
                      _cargandoCategorias
                          ? null
                          : (valor) {
                              setState(() {
                                categoriaSeleccionada =
                                    valor;
                              });
                            },
                ),

                const SizedBox(height: 15),

                // =========================
                // PRECIO
                // =========================

                CampoTexto(
                  label: 'Precio',
                  icono:
                      Icons.attach_money,
                  controlador:
                      precioController,

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Ingrese el precio';
                    }

                    if (double.tryParse(
                          value.trim(),
                        ) ==
                        null) {
                      return 'Ingrese un precio válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // =========================
                // CANTIDAD
                // =========================

                if (!_modoEdicion)
                  CampoTexto(
                    label: 'Cantidad',
                    icono: Icons.numbers,
                    controlador:
                        cantidadController,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Ingrese la cantidad';
                      }

                      if (int.tryParse(
                            value.trim(),
                          ) ==
                          null) {
                        return 'Ingrese una cantidad válida';
                      }

                      return null;
                    },
                  ),

                const SizedBox(height: 30),

                // =========================
                // GUARDAR
                // =========================

                BotonPrincipal(
                  texto: _guardando
                      ? 'Guardando...'
                      : _modoEdicion
                          ? 'Actualizar Producto'
                          : 'Guardar Producto',

                  onPressed:
                      _guardando ||
                              _cargandoCategorias
                          ? () {}
                          : _modoEdicion
                              ? _guardarProducto
                              : _guardarProductoCrear,
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