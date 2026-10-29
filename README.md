# Data Analytics Coderhouse: Caso RetailPro

Proyecto integrador del curso de **Data Analytics de Coderhouse**. Analiza el caso **RetailPro**, una empresa que vende tecnología y quiere entender la **evolución de sus ventas y de su margen**.

El trabajo recorre el ciclo completo de un proyecto de datos: modelado y carga de una base relacional en SQL Server, consultas de negocio, JOINs, un pipeline ETL en Power Query y un modelo de datos con medidas DAX en Power BI.

**Autora:** Luciana Azar

---

## Contexto de negocio

Pregunta estratégica del proyecto (definida en el Módulo 1):

> ¿Por qué el margen bruto de RetailPro cayó en el último trimestre aunque la facturación siguió creciendo, y qué combinación de región, categoría de producto y canal de venta explica esa caída?

El proyecto usa **dos fuentes de datos distintas**:

| Fuente | Dónde se usa | Contenido |
|---|---|---|
| Base `Ventas_Tech_DB` (script de `modulo-3`) | SQL: módulos 3, 4 y 5 | Base de referencia del curso: 4 categorías, 5 clientes, 6 productos y 10 ventas, todas de marzo de 2024. |
| Excel `Pipeline_ETL_Dataset.xlsx` (dataset del curso) | Power BI: módulos 6 y 8 | 11 clientes, 12 productos y 4 categorías (después de quitar duplicados) y 50 ventas de 2023 y 2024, con canal de venta. |

Por eso los totales de las consultas SQL (6.444) no coinciden con los del dashboard: son fuentes diferentes.

---

## Herramientas utilizadas

| Herramienta | Uso en el proyecto |
|---|---|
| **SQL Server** | Motor de base de datos |
| **SQL Server Management Studio (SSMS)** | Ejecución de scripts y consultas |
| **Power BI Desktop** | ETL, modelado y visualización |
| **Power Query (lenguaje M)** | Limpieza y transformación de datos |
| **DAX** | Medidas calculadas e inteligencia de tiempo |
| **GitHub** | Control de versiones y entrega |

---

## Estructura del repositorio

```
data-analytics-coderhouse/
├── modulo-3/
│   └── ventas_tech_db.sql
├── modulo-4/
│   └── m4_consultas_negocio.sql
├── modulo-5/
│   └── m5_consultas_joins.sql
├── modulo-6/
│   └── Pipeline_ETL_Azar_Luciana.pbix
└── modulo-8/
    └── Azar_Luciana_Checkpoint2.pbix
```

| Carpeta | Archivo | Descripción |
|---|---|---|
| `modulo-3` | `ventas_tech_db.sql` | Crea la base `Ventas_Tech_DB`, las tablas `categorias`, `clientes`, `productos` y `ventas`, y carga los datos. |
| `modulo-4` | `m4_consultas_negocio.sql` | Consultas de negocio: resumen mensual, ranking de productos y clientes recurrentes. |
| `modulo-5` | `m5_consultas_joins.sql` | Consultas con `JOIN` y `UNION ALL`. |
| `modulo-6` | `Pipeline_ETL_Azar_Luciana.pbix` | Pipeline ETL en Power Query (código M). |
| `modulo-8` | `Azar_Luciana_Checkpoint2.pbix` | Modelo de datos y medidas DAX. |

---

## Modelo de datos

La base `Ventas_Tech_DB` tiene cuatro tablas:

- **categorias**: clasificación de los productos.
- **clientes**: datos de los clientes.
- **productos**: catálogo, relacionado con una categoría.
- **ventas**: transacciones, relacionadas con clientes y productos.

Las relaciones son de tipo **1:N**: una categoría tiene muchos productos, y un cliente o un producto tiene muchas ventas.

---

## Requisitos previos

- SQL Server (cualquier edición, incluida Express o Developer).
- SQL Server Management Studio (SSMS).
- Power BI Desktop (solo Windows), para abrir los archivos `.pbix`.
- Git, o descargar el repositorio como ZIP desde GitHub.

---

## Cómo ejecutar los scripts SQL

Los scripts dependen unos de otros, así que hay que respetar el orden.

### 1. Clonar el repositorio

```bash
git clone https://github.com/lucianaazar/data-analytics-coderhouse.git
cd data-analytics-coderhouse
```

### 2. Crear la base y cargar los datos (Módulo 3)

1. Abrí **SSMS** y conectate a tu instancia de SQL Server.
2. Andá a **Archivo > Abrir > Archivo** y elegí `modulo-3/ventas_tech_db.sql`.
3. Presioná **Ejecutar** (o `F5`).

El script crea `Ventas_Tech_DB`, las cuatro tablas y carga los datos.

### 3. Ejecutar las consultas de negocio (Módulo 4)

1. Abrí `modulo-4/m4_consultas_negocio.sql`.
2. Verificá que la base activa sea `Ventas_Tech_DB`. Podés seleccionarla en el desplegable de SSMS o ejecutar `USE Ventas_Tech_DB;` al inicio.
3. Ejecutá cada consulta por separado: seleccioná el bloque y presioná `F5`.

### 4. Ejecutar las consultas con JOINs (Módulo 5)

Repetí el mismo procedimiento con `modulo-5/m5_consultas_joins.sql`.

> **Importante:** el Módulo 3 siempre debe correrse primero. Los módulos 4 y 5 leen las tablas que ese script crea.

---

## Cómo abrir los archivos de Power BI

1. Abrí **Power BI Desktop**.
2. Elegí **Archivo > Abrir** y seleccioná el `.pbix` correspondiente.
3. Los `.pbix` **no se conectan a SQL Server**: su origen es el Excel `Pipeline_ETL_Dataset.xlsx`. Como la ruta del archivo es local, al actualizar vas a ver un error de origen. Para corregirlo: **Home > Transform data > Data source settings > Change Source** y elegí la ubicación del Excel en tu computadora (los menús están en inglés, como en la versión de Power BI usada en el proyecto).

### Módulo 6: Pipeline ETL

`Pipeline_ETL_Azar_Luciana.pbix` contiene el proceso de extracción, limpieza y transformación en **Power Query**. Para revisar los pasos, abrí **Transform data** y mirá los *Applied Steps* de cada consulta. El código M (con comentarios `//`) se ve en el **Advanced Editor**.

### Módulo 8: Modelo y DAX

`Azar_Luciana_Checkpoint2.pbix` contiene el modelo de datos con sus relaciones y las medidas DAX. Para verlo, usá la **Vista de modelo** (relaciones) y la **Vista de informe** o de datos (medidas).

---

## Guía para continuar el proyecto

Si te sumás al proyecto como analista, esta es una ruta sugerida:

1. Ejecutá `ventas_tech_db.sql` y explorá las tablas.
2. Leé las consultas de los módulos 4 y 5 para entender la lógica de negocio.
3. Revisá el ETL del módulo 6 para ver cómo se limpian y preparan los datos.
4. Abrí el modelo del módulo 8 y repasá las medidas DAX.
5. Para extender el trabajo, algunas ideas son:
   - Agregar nuevas medidas (margen porcentual, variación interanual).
   - Construir el dashboard final con storytelling.
   - Documentar nuevas consultas en una carpeta `modulo-N/` siguiendo las convenciones de abajo.

---

## Convenciones

- Una carpeta por módulo (`modulo-N/`), con su propio `README.md`.
- Los scripts `.sql` se guardan en UTF-8 con BOM (para que los acentos se vean bien en SSMS) y su primera línea indica el motor: `-- Motor utilizado: SQL Server (SSMS)`.
- Cada consulta tiene un comentario con su propósito y, debajo, el hallazgo de negocio que se obtuvo.
- Los nombres de archivo siguen lo que pidió cada consigna del curso (por ejemplo `ventas_tech_db.sql` en el módulo 3 y `m4_consultas_negocio.sql` en el módulo 4), por eso no hay un único patrón.

---

## Autora

**Luciana Azar**
Curso de Data Analytics, Coderhouse.


> Este README se generó con asistencia de IA (Claude) a partir de la estructura del repositorio y fue revisado y corregido por la autora.
