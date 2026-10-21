-- Motor utilizado: SQL Server (SSMS)
-- ============================================================
-- Pre-entrega Módulo 5: Consultas con JOINs para el proyecto
-- Título: Cruzando tablas para enriquecer el análisis
-- Base: Ventas_Tech_DB (creada en M3)
-- Autora: Luciana Azar
-- Esquema: categorias (1) ── (N) productos (1) ── (N) ventas (N) ── (1) clientes
-- Dimensión geográfica: clientes.ciudad | Segmentación: categorias.nombre_categoria
-- ============================================================

USE Ventas_Tech_DB;
GO


-- ============================================================
-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: tener en una sola fila cada venta con su cliente,
-- ciudad, producto y categoría. Es la fuente principal para
-- Power BI: ciudad y categoría sirven para agrupar y filtrar.
-- ============================================================

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre                            AS cliente,
    c.ciudad,
    p.nombre_producto                   AS producto,
    cat.nombre_categoria                AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario      AS total_venta
FROM ventas AS v
INNER JOIN clientes   AS c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  AS p   ON v.id_producto  = p.id_producto
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;

-- Hallazgo: las 10 ventas cruzan con su cliente, producto y categoría (no hay
-- ventas huérfanas). Computación explica 4.950 de los 6.444 facturados (76,8%)
-- y Buenos Aires es la ciudad que más compra (2.640, 41,0%).


-- ============================================================
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: detectar clientes registrados que nunca compraron,
-- para que CRM los contacte.
-- ============================================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;

-- Hallazgo: la consulta devuelve 0 registros: los 5 clientes registrados
-- compraron al menos una vez. CRM no tiene hoy clientes inactivos para
-- reactivar; la consulta queda como control para cuando se sumen altas nuevas.


-- ============================================================
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: identificar artículos del catálogo sin movimiento,
-- para que el área de producto revise su surtido.
-- ============================================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas     AS v   ON p.id_producto  = v.id_producto
LEFT JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL
ORDER BY p.precio DESC;

-- Hallazgo: la consulta devuelve 0 registros: los 6 productos del catálogo
-- tienen al menos una venta. Producto no tiene artículos sin rotación que
-- discontinuar; el foco pasa a los de menor facturación, como Auriculares BT Pro (360).


-- ============================================================
-- Consulta 4: Consolidado por origen (UNION ALL)
-- Propósito: comparar la facturación de dos períodos de marzo 2024.
-- La columna origen no existe en las tablas: se crea como texto
-- fijo en cada SELECT para identificar de qué período viene la venta.
-- Se usa UNION ALL para que cada venta se cuente una sola vez,
-- aunque coincida con otra en todos sus valores.
-- ============================================================

SELECT
    origen,
    COUNT(*)   AS cantidad_ventas,
    SUM(total) AS total_origen
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Semana 1 (05 al 10 de marzo)' AS origen
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-01' AND '2024-03-10'
    UNION ALL
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Semana 2 (11 al 15 de marzo)' AS origen
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-11' AND '2024-03-31'
) AS consolidado
GROUP BY origen
ORDER BY origen;

-- Hallazgo: la semana 1 facturó 3.620 y la semana 2, 2.824 (-22,0%), con
-- 5 ventas cada una. Las dos suman 6.444, igual que el total de M4, así que
-- no se perdió ni se duplicó ninguna venta.
