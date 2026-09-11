# CEUTEC — CCC218 Programación Móvil

## Actividad 4.2 — Análisis de Problemas 2

### Implementación de Layouts y Navegación Completa del Proyecto

**Estudiante:** Lia Jael  
**Proyecto:** LNE Stock — Sistema de Control de Inventario  
**Curso:** CCC218 — Programación Móvil  
**Docente:** Ing. Reynaldo Cruz  
**Semana:** 4  
**Fecha de entrega:** 16/08/2026  
**Modalidad:** Grupal  

---

## 4.1 Inventario de pantallas

LNE Stock cuenta con nueve pantallas o secciones principales. Dependiendo de la cantidad y tipo de información que presenta cada una, se utilizan diferentes layouts de Flutter.

| # | Pantalla              | Layout principal                | Justificación |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 1 | **Bienvenida**        | `Center` + `Padding` + `Column` | Es una pantalla sencilla de presentación, por lo que los elementos se organizan verticalmente y se mantienen centrados.
| 2 | **Inicio de sesión**  | `SingleChildScrollView` + `Form` + `Column` | El formulario puede necesitar desplazamiento en pantallas pequeñas. `SingleChildScrollView` ayuda a evitar problemas cuando el espacio vertical es reducido.
| 3 | **Home / Dashboard** | `Scaffold` + `IndexedStack` + `Column` / `GridView.count` | Es la pantalla principal de la aplicación. `IndexedStack` permite cambiar entre las diferentes secciones del Home y conservar su estado. 
| 4 | **Inventario** | `Column` + `Expanded` + `ListView.builder` / `GridView.builder` | Se necesita mostrar una cantidad de productos que puede crecer. `Expanded` permite que el área de resultados utilice el espacio disponible y pueda desplazarse. 
| 5 | **Categorías** | `Column` + `Expanded` + `ListView.builder` + `Card` + `ListTile` | Las categorías se presentan como elementos verticales desplazables. Las tarjetas permiten organizar cada categoría de manera visual. 
| 6 | **Agregar producto** | `SingleChildScrollView` + `Form` + `Column` | El formulario contiene varios campos, por lo que debe poder desplazarse en dispositivos con poca altura disponible. 
| 7 | **Detalle del producto** | `SingleChildScrollView` + `Column` | El detalle contiene información del producto y diferentes acciones. El contenido puede superar el tamaño de la pantalla. 
| 8 | **Perfil** | `SingleChildScrollView` + `Column` + `Card` + `ListTile` | La información y opciones del usuario se organizan mediante tarjetas y `ListTile`, facilitando la lectura y navegación. 
| 9 | **Estadísticas** | `SingleChildScrollView` + `Column` + `Row` + `Card` | Permite mostrar diferentes indicadores del inventario y organizar la información en tarjetas y filas. 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Layouts obligatorios

#### ListView.builder

La pantalla de Inventario utiliza `ListView.builder` para mostrar los productos en formato de lista.

Actualmente se utilizan 10 productos ficticios representativos de una librería, por ejemplo:

- Cuaderno Amigo
- Lápiz BIC
- Marcadores Sharpie
- Resma de papel
- Colores Maped
- Block Liso
- Block Rayado
- Marcadores BIC
- Cuaderno de Dibujo
- Cuaderno de Caligrafía

El listado utiliza desplazamiento y `padding` para mantener una separación adecuada entre el contenido y los límites de la pantalla.

#### GridView.builder

La pantalla de Inventario también permite mostrar los productos en formato de cuadrícula utilizando `GridView.builder`.

Cada producto puede ser seleccionado para abrir su pantalla de detalle. Además, la cantidad de columnas cambia dependiendo del ancho de la pantalla.

La configuración utilizada es de dos columnas en pantallas pequeñas y tres columnas cuando existe mayor espacio disponible.

> Nota: actualmente la tarjeta utiliza un icono como representación visual del producto. Si se desea cumplir de forma estricta con el requisito de la rúbrica que solicita "imagen + texto", se puede sustituir el icono por una imagen de producto.

#### Card + ListTile

La pantalla de Categorías utiliza `Card` junto con `ListTile`.

Cada elemento contiene:

- `leading`
- `title`
- `subtitle`
- `trailing`

Actualmente se presentan seis categorías, por lo que se supera el mínimo de cinco elementos solicitado.

#### Column + Expanded

La pantalla de Inventario utiliza una estructura `Column` con un `Expanded` que contiene el área de resultados.

Esto permite mantener el buscador y los controles superiores fuera del área que se desplaza, mientras que la lista o cuadrícula ocupa el espacio disponible.

La actividad describe este layout como contenido desplazable y un elemento fijo debajo. Por esta razón, antes de realizar la entrega final se debe verificar que el botón o elemento fijo inferior esté presente si se desea cumplir literalmente con ese requisito.

---

## 4.2 Mapa de navegación

El flujo principal de navegación de LNE Stock es el siguiente:

```text
                    ┌─────────────────┐
                    │   BIENVENIDA    │
                    │   /bienvenida   │
                    └────────┬────────┘
                             │
                        pushNamed
                             ↓
                    ┌─────────────────┐
                    │      LOGIN      │
                    │     /login      │
                    └────────┬────────┘
                             │
                 pushNamedAndRemoveUntil
                             │
                             ↓
                    ┌─────────────────┐
                    │      HOME       │
                    │     /home      │
                    └────────┬────────┘
                             │
             ┌───────────────┼────────────────┐
             │               │                │
             ↓               ↓                ↓
        INVENTARIO       CATEGORÍAS       AGREGAR
             │
             │ pushNamed + arguments
             ↓
        ┌───────────────┐
        │    DETALLE    │
        │    /detalle   │
        └───────┬───────┘
                │
             pop()
                │
                ↓
           INVENTARIO
```

Además, desde el Home se puede acceder a:

```text
HOME
 ├── Perfil
 └── Estadísticas
```

Estas pantallas utilizan rutas con nombre.

### Descripción del flujo

1. La aplicación inicia en la pantalla **Bienvenida**, utilizando la ruta `/bienvenida`.
2. Desde Bienvenida, el usuario selecciona la opción para ingresar y se utiliza:

```dart
Navigator.pushNamed(context, '/login');
```

3. Después de completar correctamente el inicio de sesión, se utiliza:

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/home',
  (route) => false,
);
```

Esto elimina las rutas anteriores de la pila de navegación y establece Home como la pantalla principal después del inicio de sesión.

4. Dentro de `HomeScreen`, las secciones principales se administran mediante `IndexedStack` y `BottomNavigationBar`. Estas secciones son Inicio, Inventario, Categorías y Agregar producto.

5. Desde el Home también se puede acceder a Perfil y Estadísticas mediante rutas con nombre.

6. Desde Inventario, al seleccionar un producto, se navega hacia la pantalla de detalle utilizando la ruta `/detalle`.

7. El producto seleccionado se envía como argumento:

```dart
Navigator.pushNamed(
  context,
  '/detalle',
  arguments: productoModelo,
);
```

8. En la pantalla de detalle se recupera el producto mediante:

```dart
final producto =
    ModalRoute.of(context)!.settings.arguments as Producto;
```

9. Para regresar desde el detalle se utiliza `Navigator.pop(context)`.

10. Al cerrar sesión se utiliza nuevamente `pushNamedAndRemoveUntil`, esta vez hacia `/bienvenida`, para limpiar las pantallas internas de la aplicación.

### Rutas centralizadas

Las rutas principales se encuentran declaradas en `lib/main.dart`:

```text
/bienvenida
/login
/home
/inventario
/categorias
/agregar-producto
/detalle
/perfil
/estadisticas
```

De esta manera, las rutas se mantienen centralizadas y es más sencillo controlar la navegación de la aplicación.

---

## 4.3 Decisiones de diseño

### Decisión 1: Utilizar ListView.builder y GridView.builder en Inventario

**Justificación técnica:**

La pantalla de Inventario necesita mostrar una colección de productos que puede aumentar con el tiempo.

`ListView.builder` permite mostrar los productos en una lista vertical, mientras que `GridView.builder` permite una presentación más visual y compacta.

También se permite cambiar entre las dos formas de visualizar el inventario.

### Decisión 2: Implementar diseño responsive utilizando MediaQuery

**Justificación técnica:**

La cantidad de columnas de la cuadrícula se determina según el ancho disponible de la pantalla.

La lógica utilizada es:

```dart
final int columnas = ancho > 600 ? 3 : 2;
```

De esta forma, las pantallas pequeñas utilizan dos columnas y las pantallas con mayor ancho utilizan tres.

Esto permite aprovechar mejor el espacio disponible y adaptar la interfaz a diferentes tamaños de pantalla.

### Decisión 3: Centralizar las rutas de navegación en main.dart

**Justificación técnica:**

Las rutas se encuentran centralizadas dentro de `MaterialApp` en `main.dart`.

Esto evita tener las rutas definidas de manera diferente en cada pantalla y facilita el mantenimiento del proyecto.

También permite utilizar `Navigator.pushNamed` para navegar entre las diferentes pantallas.

### Decisión 4: Utilizar pushNamedAndRemoveUntil después del inicio de sesión

**Justificación técnica:**

Después de que el usuario inicia sesión correctamente, no es necesario conservar la pantalla de login en la pila de navegación.

Por esta razón se utiliza:

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/home',
  (route) => false,
);
```

Esto evita que el usuario pueda regresar al formulario de inicio de sesión utilizando el botón Back.

La misma idea se utiliza al cerrar sesión para regresar a la pantalla de Bienvenida y limpiar las pantallas internas.

### Decisión 5: Utilizar IndexedStack en el Home

**Justificación técnica:**

Las secciones principales de la aplicación forman parte del mismo `HomeScreen`.

Se utiliza `IndexedStack` para cambiar entre las secciones sin crear una nueva ruta cada vez que el usuario cambia de pestaña.

Una ventaja de esta estructura es que permite conservar el estado de las diferentes secciones mientras el usuario navega entre ellas.

---

## Conclusión

La estructura actual de LNE Stock utiliza diferentes layouts dependiendo del tipo de información que presenta cada pantalla.

La aplicación cuenta con listas, cuadrículas, tarjetas, formularios y diferentes secciones de navegación. También se implementaron rutas con nombre, paso de argumentos para mostrar el detalle de un producto, búsqueda de productos y un ajuste responsive para la vista de inventario.

Con esta estructura, la interfaz queda preparada para la siguiente etapa del proyecto, en la cual los datos ficticios podrán ser reemplazados por información obtenida desde una API.

---