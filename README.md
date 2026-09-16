# LNE Stock

## Descripción

LNE Stock es una aplicación móvil para la gestión y consulta del inventario de Librería y Novedades Emanuel. Está pensada para el personal autorizado de la librería y permite consultar productos, categorías y existencias desde una interfaz móvil conectada a un backend mediante una API REST.

## Objetivo

Facilitar el control de productos y existencias, centralizando en una aplicación móvil la consulta del inventario, el registro de entradas y salidas, la administración de productos y el acceso a información resumida del inventario.

## Funcionalidades

- Inicio de sesión mediante correo electrónico y contraseña.
- Registro de usuarios con nombre, apellido, correo y contraseña. Los usuarios registrados desde la aplicación se crean con el rol `staff`.
- Persistencia local del token de acceso y del rol del usuario.
- Verificación de la sesión al iniciar la aplicación y renovación del token cuando una solicitud recibe una respuesta no autorizada.
- Consulta del inventario de productos.
- Búsqueda de productos por nombre, código o categoría.
- Visualización del inventario en lista o cuadrícula.
- Consulta del detalle de un producto, incluyendo nombre, código, descripción, precio, categoría y estado del stock.
- Creación, edición y eliminación de productos para usuarios con rol `admin`.
- Consulta de categorías y de los productos pertenecientes a una categoría.
- Marcado y desmarcado de productos favoritos.
- Consulta de estadísticas del inventario: cantidad de productos, productos con stock bajo, entradas y salidas acumuladas.
- Consulta de movimientos de inventario.
- Registro de entradas y salidas de inventario para usuarios con rol `admin`, con validación de cantidad y stock disponible.
- Consulta del nombre, correo y rol del perfil. El servicio de autenticación también define una operación para actualizar nombre y correo, aunque la pantalla de perfil actual no muestra un formulario para ejecutarla.
- Cierre de sesión.
- Notificación local de confirmación después del registro de un usuario, con solicitud de permiso en Android.
- Estados de carga, mensajes de error, estados vacíos y opción de reintentar en las consultas principales.

## Tecnologías utilizadas

| Tecnología | Uso dentro del proyecto |
|---|---|
| Flutter | Framework utilizado para construir la aplicación móvil y su interfaz. |
| Dart | Lenguaje de programación del proyecto. |
| Dio | Cliente HTTP utilizado para consumir la API REST. |
| `shared_preferences` | Almacenamiento local del token de acceso y del rol del usuario. |
| `cookie_jar` | Persistencia local de cookies. |
| `dio_cookie_manager` | Integración de las cookies persistentes con Dio. |
| `path_provider` | Obtención del directorio de documentos de la aplicación para almacenar cookies. |
| `flutter_local_notifications` | Inicialización, permisos y muestra de la notificación local de registro. |
| `image_picker` | Dependencia declarada en `pubspec.yaml`; no se observa uso actual en las pantallas del proyecto. |
| `cupertino_icons` | Iconos de estilo Cupertino disponibles para la interfaz. |
| Material 3 | Sistema visual utilizado mediante `ThemeData` y componentes Material de Flutter. |

El repositorio contiene el cliente móvil. Las tecnologías internas del backend, como Node.js, Express, Sequelize o MySQL, no están incluidas en este código y por ello no se documentan como parte de la implementación de este repositorio.

## Arquitectura y estructura del proyecto

La aplicación está organizada por responsabilidades:

- `lib/core/`: configuración y cliente común de la API, además del almacenamiento local.
- `lib/models/`: modelos de datos para usuarios, productos, categorías y movimientos de inventario, con conversión desde y hacia JSON.
- `lib/services/`: servicios que encapsulan las operaciones de autenticación, productos, categorías, favoritos, movimientos y notificaciones.
- `lib/screens/`: pantallas de bienvenida, autenticación, inicio, inventario, categorías, productos por categoría, detalle, perfil, estadísticas, movimientos y formulario de productos.
- `lib/widgets/`: componentes reutilizables como botones, campos de texto, tarjetas de menú, tarjetas de producto y estado del stock.
- `lib/utils/`: colores, estilos, mapeo de iconos de productos y ayuda para mostrar mensajes.
- `lib/docs/`: documentación interna sobre análisis de layouts.
- `assets/images/`: logotipos utilizados en la aplicación.

No existe una carpeta `routes/`; las rutas nombradas se declaran directamente en `lib/main.dart`.

## Conexión con el backend

El flujo de comunicación implementado es:

```text
Flutter → Dio / API REST → Backend desplegado → Base de datos del backend
```

La URL base está definida en `lib/core/api_config.dart`:

```dart
static const String baseUrl =
    'https://backendlnestock-production.up.railway.app/api';
```

`ApiClient` configura Dio con encabezados JSON y tiempos de espera para conexión, envío y recepción. Antes de cada solicitud agrega el token de acceso como `Bearer` cuando existe. También mantiene una cookie persistente en el directorio de documentos de la aplicación para apoyar la renovación de sesión mediante `/auth/refresh`.

Las respuestas se interpretan mediante `responsePayload`, que permite trabajar tanto con respuestas directas como con respuestas envueltas en una propiedad `data`. Las solicitudes fallidas se convierten en `ApiException` y se muestran en la interfaz mediante mensajes o `SnackBar`.

Para utilizar otro backend, se debe modificar `ApiConfig.baseUrl` sin incluir credenciales, tokens ni secretos en el repositorio.

## Autenticación y sesión

- El inicio de sesión envía las credenciales a `/auth/login`. Si es exitoso, guarda el token de acceso y el rol con `SharedPreferences` y dirige al usuario al inicio.
- El registro envía el nombre completo, correo, contraseña y el rol `staff` a `/auth/register`. Después de registrarse, muestra una confirmación y dirige a la pantalla de inicio de sesión.
- Al iniciar la aplicación, `SplashScreen` busca el token local y consulta `/auth/me`. Si la sesión no es válida, elimina el token y vuelve a la bienvenida.
- `ApiClient` intenta renovar el token ante una respuesta HTTP 401 en rutas protegidas. Si la renovación también responde 401, limpia la sesión local.
- El cierre de sesión llama a `/auth/logout` y elimina el token y el rol almacenados localmente.
- Las opciones de administración de productos y movimientos se muestran en la interfaz cuando el rol almacenado es `admin`.

No se incluyen en este README contraseñas, tokens ni credenciales de usuarios.

## Pantallas principales

| Pantalla | Propósito y funcionalidades principales |
|---|---|
| `SplashScreen` | Muestra el logotipo, verifica la sesión guardada y decide si dirige a bienvenida o inicio. |
| `BienvenidaScreen` | Presenta LNE Stock y permite ir al registro o al inicio de sesión. |
| `LoginScreen` | Formulario de inicio de sesión con estado de carga y mensajes de error. |
| `RegistroScreen` | Formulario de creación de usuario con validación de campos, confirmación y notificación local. |
| `HomeScreen` | Contenedor principal autenticado con menú lateral, navegación inferior y acceso al dashboard. |
| `DashboardScreen` | Muestra el resumen del inventario, el estado del stock y accesos rápidos. Su distribución se adapta al ancho disponible. |
| `InventarioScreen` | Lista o cuadrícula de productos, búsqueda, favoritos, acceso al detalle y eliminación para administradores. |
| `CategoriasScreen` | Consulta y muestra las categorías disponibles. |
| `ProductosCategoriaScreen` | Muestra los productos de una categoría y permite consultar detalles y favoritos. |
| `DetalleProductoScreen` | Presenta la información de un producto y permite editarlo si el usuario es administrador. |
| `AgregarProductoScreen` | Formulario para crear o editar productos, seleccionar categoría e icono, y validar sus datos. |
| `EstadisticasScreen` | Resume productos, stock bajo, entradas y salidas, e incluye barras de movimiento. |
| `MovimientosScreen` | Lista movimientos y permite registrar entradas o salidas para administradores. Incluye actualización y gesto de refresco. |
| `PerfilScreen` | Consulta los datos del usuario, muestra nombre, correo y rol, y permite cerrar sesión. La opción de configuración está indicada como próximamente. |

## Navegación

La navegación se implementa con rutas nombradas declaradas en `MaterialApp` y con navegación directa para la pantalla de productos por categoría. Las rutas declaradas son:

```text
/                  SplashScreen
/bienvenida        BienvenidaScreen
/login             LoginScreen
/registro          RegistroScreen
/home              HomeScreen
/inventario        InventarioScreen
/categorias        CategoriasScreen
/agregar-producto  AgregarProductoScreen
/detalle           DetalleProductoScreen
/perfil            PerfilScreen
/estadisticas      EstadisticasScreen
/movimientos       MovimientosScreen
```

Dentro de `HomeScreen` se utiliza un `BottomNavigationBar` para Inicio, Inventario, Categorías y, cuando corresponde, Agregar producto. También existe un `Drawer` con accesos a Inicio, Inventario, Categorías, Agregar producto, Estadísticas, Movimientos y cierre de sesión. Las opciones de administración dependen del rol `admin`.

## Diseño de interfaz

La interfaz utiliza componentes Material 3, fondos claros y tarjetas con bordes redondeados y elevación. Los colores definidos en `AppColors` incluyen:

- Principal: marrón `#8B5E00`.
- Secundario: beige dorado `#D9B26F`.
- Fondo general: `#F8F6F2`.
- Texto principal: marrón oscuro `#3E2723`.
- Estados: verde para éxito, naranja para advertencia y rojo para error.

Se utilizan tarjetas de menú, tarjetas de producto, botones y campos de texto reutilizables. El dashboard y algunos formularios ajustan tamaños, márgenes, columnas y proporciones según el ancho disponible. Los productos muestran estados de stock como disponible, stock bajo o agotado.

## Manejo de errores y estados

- Las operaciones asíncronas muestran indicadores de carga, deshabilitan acciones durante el envío cuando corresponde y actualizan la vista al finalizar.
- Los errores HTTP se traducen a mensajes para casos como solicitud inválida, sesión no autorizada, falta de permisos, recurso no encontrado, conflicto y error del servidor.
- Los errores de conexión y de tiempo de espera tienen mensajes específicos.
- Las pantallas de inventario, categorías, productos por categoría, perfil, estadísticas y movimientos muestran mensajes de error y controles para reintentar cuando aplica.
- Las respuestas sin elementos muestran mensajes como “No hay productos...” o “No hay categorías registradas”.
- Los formularios validan campos obligatorios. El registro valida formato de correo, contraseña de mínimo ocho caracteres con al menos un número y coincidencia de confirmación. Los formularios de productos y movimientos validan sus datos y el movimiento de salida comprueba que exista stock suficiente.

## Instalación y configuración

1. Clonar el repositorio:

   ```bash
   git clone https://github.com/darielapchc/programacion_movil_proyecto.git
   ```

2. Entrar al directorio del proyecto:

   ```bash
   cd programacion_movil_proyecto
   ```

3. Instalar las dependencias:

   ```bash
   flutter pub get
   ```

4. Revisar o configurar la URL del backend en `lib/core/api_config.dart` si se utilizará una instancia diferente.

5. Ejecutar la aplicación:

   ```bash
   flutter run
   ```

## Requisitos

- Flutter instalado y configurado en el equipo.
- Dart SDK compatible con `^3.12.2`, según `pubspec.yaml`.
- Un dispositivo Android, un emulador Android o un dispositivo iOS configurado para Flutter.
- Acceso de red al backend configurado. En Android se declara el permiso de Internet.
- En Android 13 o superior, la aplicación puede solicitar permiso para mostrar notificaciones locales.

El proyecto usa Flutter en el canal `stable`, según `.metadata`, pero el repositorio no fija una versión numérica de Flutter.

## Ejecución

Para comprobar los dispositivos disponibles:

```bash
flutter devices
```

En un emulador Android iniciado:

```bash
flutter run
```

En un dispositivo físico conectado y reconocido por Flutter:

```bash
flutter run -d <id-del-dispositivo>
```

El dispositivo debe tener habilitada la depuración correspondiente y contar con acceso al backend configurado.

## Estructura resumida

```text
lib/
├── core/
│   ├── api_client.dart
│   ├── api_config.dart
│   └── storage_service.dart
├── docs/
│   └── analisis_layouts.md
├── models/
│   ├── categorias.dart
│   ├── movimiento_inventario.dart
│   ├── producto.dart
│   └── usuario.dart
├── screens/
│   ├── agregar_producto_screen.dart
│   ├── bienvenida_screen.dart
│   ├── categoria_screen.dart
│   ├── dashboard_screen.dart
│   ├── detalle_producto_screen.dart
│   ├── estadisticas_screen.dart
│   ├── home_screen.dart
│   ├── inventario_screen.dart
│   ├── login_screen.dart
│   ├── movimientos_screen.dart
│   ├── perfil_screen.dart
│   ├── productos_categoria_screen.dart
│   ├── registro_screen.dart
│   └── splash_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── categoria_service.dart
│   ├── favorite_service.dart
│   ├── movimiento_service.dart
│   ├── notificacion_service.dart
│   └── producto_service.dart
├── utils/
│   ├── app_colors.dart
│   ├── app_styles.dart
│   ├── product_icon_mapper.dart
│   └── snackbar_helper.dart
├── widgets/
│   ├── boton_principal.dart
│   ├── campo_texto.dart
│   ├── menu_card.dart
│   ├── producto_card.dart
│   └── stock_status.dart
└── main.dart
assets/
└── images/
    ├── logo.png
    └── logoApp.png
test/
└── widget_test.dart
pubspec.yaml
```

## API utilizada

Todos los endpoints se concatenan con la URL base configurada en `ApiConfig`.

| Método | Endpoint | Función |
|---|---|---|
| `POST` | `/auth/login` | Iniciar sesión. |
| `POST` | `/auth/register` | Registrar un usuario con rol `staff`. |
| `GET` | `/auth/me` | Consultar el usuario autenticado. |
| `PUT` | `/auth/me` | Actualizar nombre completo y correo del usuario autenticado. |
| `POST` | `/auth/logout` | Cerrar sesión en el backend. |
| `POST` | `/auth/refresh` | Renovar el token de acceso mediante la cookie de sesión. |
| `GET` | `/productos` | Listar productos. |
| `GET` | `/productos/{id}` | Obtener un producto por su identificador. |
| `POST` | `/productos` | Crear un producto. |
| `PUT` | `/productos/{id}` | Actualizar un producto. |
| `DELETE` | `/productos/{id}` | Eliminar un producto. |
| `GET` | `/categorias` | Listar categorías. |
| `GET` | `/favoritos` | Listar los identificadores de productos favoritos. |
| `POST` | `/favoritos/{productoId}` | Agregar un producto a favoritos. |
| `DELETE` | `/favoritos/{productoId}` | Eliminar un producto de favoritos. |
| `GET` | `/movimientos` | Listar movimientos de inventario. |
| `POST` | `/movimientos` | Registrar una entrada o salida con tipo, cantidad y producto. |

## Equipo

Proyecto académico de Ingeniería en Informática.

**LNE Stock — Librería y Novedades Emanuel.**

Integrantes:

- Completar nombre del integrante.
- Completar nombre del integrante.

## Notas

- La aplicación depende de que el backend de la URL configurada esté disponible y acepte los endpoints documentados.
- La URL actual apunta a una instancia desplegada en Railway. Si cambia el backend, actualiza `lib/core/api_config.dart`.
- Las funciones visibles para administración dependen del rol guardado como `admin`; además, el backend debe aplicar sus propias reglas de autorización.
- La opción de configuración del perfil está presente en la interfaz, pero actualmente muestra el mensaje “Configuración próximamente”.
- `image_picker` aparece declarado en `pubspec.yaml`; la documentación funcional de la selección de imágenes debe ampliarse cuando esa capacidad se integre en una pantalla.

## Licencia

Este proyecto fue desarrollado con fines académicos.
