# Verificación de Inventario – Bienes Devolutivos
Aplicación de escritorio (Tkinter + PostgreSQL)

## 🧭 Descripción
**Inventario Bienes Devolutivos** es una aplicación GUI construida con **Tkinter** que permite **consultar, actualizar e insertar** registros del inventario de una litoteca sobre **PostgreSQL**.  
Incluye búsqueda por **código de barras** y por **secuencia**, control de **no duplicación** en el reporte, exportación a **Excel (.xlsx)** y validaciones de negocio (estado, responsable, formatos).

---

## ✨ Funcionalidades clave
- **Búsqueda por código de barras**  
  - Escáner con Enter o digitación manual con *debounce* (≈180 ms).  
  - Autolimpieza y foco para el siguiente escaneo.
- **Búsqueda por secuencia**  
  - Lista interactiva de resultados y carga del registro seleccionado.
- **Edición/Inserción en BD**  
  - Actualiza o inserta respetando tipos y **ENUM** `estado_enum` (`BUENO` / `INSERVIBLE`).  
  - Convierte costo a entero o `NULL` de forma segura.
- **Reporte sin duplicados**  
  - Una fila por `codigo_barras` en el **Treeview** (si llega de nuevo, **se actualiza**).
- **Exportación a Excel**  
  - Archivo `consulta_YYYYMMDD_HHMMSS.xlsx`.  
  - El **código de barras** se preserva como **texto** (sin pérdida de ceros a la izquierda).
- **Campos y combos**  
  - “**Parte**” visible junto a “**Descripción**”.  
  - “**Almacén (Tipo)**” en **solo lectura**.  
  - Carga de listas para **Cédula**, **Responsable** y **Ubicación**.
- **Atajos**  
  - F1 buscar código · F2 por secuencia · F5 guardar · F9/Esc limpiar · F12 exportar.

---

## 🧩 Requisitos
- **Python 3.8+**
- Bibliotecas:
  - `psycopg2` *(o `psycopg2-binary` en entornos locales)*  
  - `openpyxl`
  - `tkinter` *(viene con la instalación estándar de Python en la mayoría de OS)*
- **PostgreSQL 12+**

### Instalación rápida (recomendado con entorno virtual)
```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# Linux/macOS
source .venv/bin/activate

pip install psycopg2-binary openpyxl
```

---

## 🔧 Configuración
La app lee variables de entorno para la conexión:

```bash
# .env de ejemplo (o variables del sistema)
PG_DB=inventario
PG_USER=postgres
PG_PASS=postgres
PG_HOST=localhost
PG_PORT=5432
```

> Si no existen, usa por defecto esos mismos valores.

### Tema visual (opcional)
Si colocas `azure.tcl` junto al script, se aplicará el tema **azure-dark**; si no está, usará **clam**.

---

## 🗄️ Esquema mínimo de BD (columnas que usa la app)
> Ajusta tipos/tamaños a tu realidad. Este es un **mínimo funcional**.

```sql
-- ENUM de estado
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_enum') THEN
    CREATE TYPE estado_enum AS ENUM ('BUENO', 'INSERVIBLE');
  END IF;
END $$;

-- Tabla principal
CREATE TABLE IF NOT EXISTS public.inventario_verificado (
  centro_operacion         text,
  secuencia                integer,
  codigo_barras            varchar(64) PRIMARY KEY,
  codigo_elemento          text,
  serie                    text,
  placa                    text,
  descripcion_elemento     text,
  tipo_parte               text,
  tipo_almacenamiento      text,
  fecha_ingreso            date,
  costo                    integer,
  cedula_resp              integer,
  responsable_inventario   text,
  estado_elemento          estado_enum,
  ubicacion_2025           text,
  verificado               boolean DEFAULT false
);

-- Catálogos usados por los combos
CREATE TABLE IF NOT EXISTS public.personal_litoteca (
  cedula  integer PRIMARY KEY,
  nombre  text NOT NULL
);

CREATE TABLE IF NOT EXISTS public.ubicaciones_litoteca (
  ubicaciones text PRIMARY KEY
);
```

---

## ▶️ Ejecución
```bash
python inventario_litoteca.py
```

**Atajos de teclado**

| Tecla | Acción |
|------:|:------|
| **Enter** en “Buscar Código” | Buscar por código (modo escáner) |
| **F1** | Buscar por código |
| **F2** | Buscar por secuencia |
| **F5** | Guardar cambios (insert/update) |
| **F9** / **Esc** | Limpiar formulario |
| **F12** | Exportar a Excel |

---

## 🔒 Reglas de negocio y validaciones
- **Estado**: solo `BUENO` o `INSERVIBLE` (se mapea a `estado_enum`).
- **Costo**: entero o `NULL` (valores como `''`, `N/A` → `NULL`).
- **Responsable**: obligatorio para guardar.
- **Almacén (Tipo)**: mostrado en **readonly** (se trae desde BD).
- **Reporte único**: si el mismo `codigo_barras` vuelve a consultarse o guardarse, la fila del informe se **reemplaza**, evitando duplicados.

---

## 🛠️ Detalles técnicos relevantes del código
- **Inserciones seguras en Entry**: helper `_set_entry_text` convierte cualquier valor a cadena y respeta `readonly`, evitando el error de Tk *“wrong # args: … insert index text”*.  
- **Debounce** de búsqueda manual: `_debounced_keyrelease` espera ~180 ms para reducir consultas innecesarias.  
- **No duplicación en reporte**: `_actualizar_tree_unique` mantiene un dict `{codigo_barras: iid}`.  
- **Consultas parametrizadas**: uso de `psycopg2` con parámetros para prevenir SQL injection.  
- **Exportación a Excel**: primera columna en texto explícito (prefijo `'`) para preservar ceros a la izquierda.

---

## 📤 Exportación a Excel
- Hoja **Resultados** con los encabezados:  
  `Código Barras, Secuencia, Serie, Placa, Descripción, Parte, Estado, Ubicación 2025, Responsable, Almacén`.
- Ajuste automático de ancho y formato **texto** en columna del código de barras.

---

## 🧪 Ejemplos de uso
1. **Escanear un elemento**  
   - Enfoca “Buscar Código”, escanea y presiona **Enter**.  
   - La ficha se llena; el informe inferior muestra/actualiza la fila.
2. **Buscar por secuencia**  
   - Escribe la secuencia y presiona **Enter** o **F2**.  
   - Selecciona “Cargar este registro”.
3. **Guardar cambios**  
   - Ajusta **Estado**, **Responsable**, **Ubicación** y presiona **F5**.

---

## 🩺 Solución de problemas
- **“wrong # args: should be ‘… entry insert index text’”**  
  Ocurre si se intenta insertar algo que no es texto en un `Entry`.  
  → Ya está mitigado con `_set_entry_text`. Si reaparece, revisa logs `inventario_app.log`.
- **“no existe el tipo «estado_enum»”**  
  → Crea el tipo con el bloque SQL anterior.  
- **“la sintaxis de entrada no es válida para tipo integer: «N/A»”**  
  → La app ya convierte `N/A`/vacío a `NULL`. Verifica que el campo `costo` sea `integer`.
- **No se ve “Almacén (Tipo)”**  
  → Es de solo lectura y se carga desde `tipo_almacenamiento`. Asegura que la columna tenga datos.
- **Duplicados en el informe**  
  → El control `rows_by_barcode` evita duplicados; si exportaste antes de una actualización, vuelve a exportar tras la última consulta/guardado.

---

## 🔐 Seguridad
- Credenciales vía variables de entorno (evita hardcode).  
- Consultas parametrizadas.  
- Registra errores en `inventario_app.log` (sin credenciales).

---

## 🗂️ Estructura (alto nivel)
- **InventarioApp**  
  - `_setup_ui`, `_setup_estilos`, `_setup_eventos_teclado`  
  - `_buscar_codigo`, `_buscar_por_secuencia`, `_cargar_desde_secuencia`  
  - `_guardar_bd`, `_exportar_excel`, `_limpiar_campos`  
  - `_actualizar_tree_unique`, `_set_entry_text`  
  - `_cargar_datos_combo`, `_conectar_bd`

---

## 🤝 Contribuciones
Los *issues* y *pull requests* son bienvenidos.  
Sugerencias típicas: cache de combos, internacionalización, empaquetado con PyInstaller, validaciones adicionales.

---

## 📄 Licencia
Indica aquí la licencia elegida (p. ej., MIT). Si omites este bloque, el código queda con “todos los derechos reservados”.

---

### Notas de versión (cambio reciente)
- Se agregó `_set_entry_text` para evitar errores al insertar en `Entry`.  
- Se aseguró la visualización de **“Parte”** junto a **“Descripción”** en el reporte.  
- Control robusto de duplicados por `codigo_barras`.
