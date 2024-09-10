# Verificación Inventario Bienes Devolutivos

## Objetivo de la Herramienta
La herramienta **Inventario Bienes Devolutivos** es una aplicación de gestión diseñada para facilitar el control de inventarios de una litoteca. Utilizando la interfaz gráfica de usuario (GUI) de **Tkinter** y con la capacidad de conectarse a una base de datos **PostgreSQL**, permite realizar operaciones clave como la búsqueda, inserción y actualización de registros de inventario.

Su objetivo es optimizar el manejo de datos del inventario, asegurando una administración eficiente de los elementos almacenados, incluyendo su estado, ubicación, y responsables de su uso e inventario. Esta herramienta proporciona una experiencia de usuario amigable, donde los operadores pueden interactuar con los datos sin necesidad de conocimientos avanzados en bases de datos.

## Requisitos del Sistema
- **Python 3.x** o superior.
- **Bibliotecas de Python**:
  - `tkinter`
  - `psycopg2`
  - `openpyxl`
- **PostgreSQL** (Configurado para la base de datos de inventario).

## Conexión a Base de Datos PostgreSQL
La herramienta utiliza la biblioteca `psycopg2` para conectarse a una base de datos PostgreSQL. Asegúrate de tener la base de datos correctamente configurada y con las credenciales adecuadas.

### Configuración de la Conexión
En la sección del código, encontrarás la función para conectar a la base de datos. Asegúrate de reemplazar las credenciales con los valores correctos para tu entorno:

```python
def conectar_bd():
    try:
        conn = psycopg2.connect(
            dbname="inventario",    # Nombre de la base de datos
            user="postgres",        # Usuario de la base de datos
            password="postgres",    # Contraseña del usuario
            host="localhost",       # Dirección del servidor de base de datos
            port="5432"             # Puerto del servidor
        )
        print("Conexión exitosa a la base de datos")
        return conn
    except Exception as e:
        print(f"Error de conexión: {e}")
        messagebox.showerror("Error de Conexión", f"No se pudo conectar a la base de datos: {e}")
        return None
```

## Importante
Antes de ejecutar la herramienta, asegúrate de:
- Tener acceso a la base de datos `inventario`.
- Que el servidor de PostgreSQL esté activo y acepte conexiones en el puerto configurado.
- Que la base de datos contenga las tablas necesarias como `inventario_verificado`, `ubicaciones_litoteca`, `personal_litoteca`, etc.

## Funcionalidades

### Búsqueda por Código de Barras
- Realiza búsquedas automáticas tras escribir un código de barras.
- Actualización automática del campo de verificación del inventario al encontrar un código.
- Limpieza automática del campo de entrada tras la búsqueda.

### Inserción de Nuevos Registros
- Inserta nuevos registros en la base de datos, incluyendo campos como Centro de Operación, Código de Barras, Placa, Descripción, Ubicación, etc.
- Generación automática de código de barras para nuevos elementos.

### Actualización de Registros
- Modifica registros existentes, actualizando campos como Estado del Elemento, Responsable de Inventario, Cédula Responsable, y Ubicación.
- Validación de campos clave para asegurar consistencia.

### Búsqueda Interactiva en Campos Desplegables
- Filtros interactivos para Cédula Responsable, Responsable de Inventario, Ubicación Litoteca y Responsable de Uso.
- A medida que se escribe, las opciones se filtran dinámicamente, facilitando la selección.

### Registro de Búsquedas
- Cada búsqueda se registra automáticamente en una tabla con barra de desplazamiento.

### Exportación a Excel (.xlsx)
- Exporta los resultados de las búsquedas a un archivo Excel.
- Incluye información detallada como Código de Barras, Secuencia, Serie, Placa, Descripción, Estado, Ubicación, y Responsable de Uso.

### Campos de Formulario con Ancho Ajustable
- Los campos de entrada tienen un ancho ajustable para mejorar la visualización de grandes volúmenes de información.

### Limpieza de Campos
- Opción para limpiar todos los campos de entrada con un solo clic.

### Validación de Campos Clave
- Asegura que los campos como Ubicación, Estado del Elemento y Responsable de Uso tengan valores válidos antes de proceder con cualquier operación.

## Ventajas del Manejo de Datos a través de esta Herramienta
- **Eficiencia en la Gestión del Inventario**: Facilita la gestión de grandes volúmenes de datos, simplificando las búsquedas, actualizaciones y registros.
- **Interfaz Amigable**: Proporciona una GUI intuitiva para que los usuarios interactúen fácilmente con los datos.
- **Confiabilidad en la Información**: Utiliza una base de datos robusta como PostgreSQL para asegurar la seguridad y consistencia de los datos.
- **Facilidad de Exportación**: La capacidad de exportar registros a Excel permite la creación de informes detallados.
- **Automatización de Tareas**: Automatiza tareas como la limpieza de campos y la actualización de estados, reduciendo el error humano.

## Cómo Ejecutar la Herramienta

1. Instala las dependencias necesarias usando `pip`:

   ```bash
   pip install psycopg2 xlwt
   ```

2. Configura la conexión a la base de datos en la función conectar_bd() con tus credenciales de PostgreSQL.

3. Ejecuta la aplicación:

```bash
   python inventario_litoteca.py
```

## Contribuciones

Si deseas contribuir a este proyecto o hacer un fork del proyecto para añadir nuevas funcionalidades.

¡Gracias por utilizar **Inventario Bienes Devolutivos**!



