-- Motor utilizado: SQL Server (SSMS)
-- ============================================================
-- Pre-entrega Módulo 4: Consultas SQL de negocio
-- Título: Extrayendo métricas clave con SQL
-- Base: Ventas_Tech_DB (creada en M3) — tabla ventas
-- Autora: Luciana Azar
-- Total de cada venta = cantidad * precio_unitario
-- ============================================================

USE Ventas_Tech_DB;
GO


-- ============================================================
-- CONSULTA 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes.
-- Se agrupa también por año para no mezclar el mismo mes de
-- años distintos.
-- ============================================================

SELECT
    YEAR(fecha_venta)                                      AS anio,
    MONTH(fecha_venta)                                     AS mes,
    SUM(cantidad * precio_unitario)                        AS total_facturado,
    COUNT(*)                                               AS cantidad_pedidos,
    CAST(AVG(cantidad * precio_unitario) AS DECIMAL(10,2)) AS ticket_promedio
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY anio, mes;


-- ============================================================
-- CONSULTA 2 — Ranking de productos
-- Top 5 de id_producto por total facturado, con unidades vendidas.
-- ============================================================

SELECT TOP 5
    id_producto,
    SUM(cantidad)                   AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- ============================================================
-- CONSULTA 3 — Clientes recurrentes
-- id_cliente con más de un pedido, cantidad de pedidos y total gastado.
-- ============================================================

SELECT
    id_cliente,
    COUNT(*)                        AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- ============================================================
-- CONSULTA 4 — Meses por encima / por debajo del promedio
-- Primero se calcula el total facturado de cada mes (ventas_mes)
-- y después se compara cada mes con el promedio mensual general.
-- ============================================================

WITH ventas_mes AS (
    SELECT
        YEAR(fecha_venta)               AS anio,
        MONTH(fecha_venta)              AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
)
SELECT
    anio,
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM ventas_mes) THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM ventas_mes) THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM ventas_mes
ORDER BY anio, mes;


-- ============================================================
-- HALLAZGOS
-- ============================================================
-- 1. El producto 1 concentra el 55,9% de la facturación (3.600 de
--    6.444) con solo 3 unidades vendidas. Junto con el producto 3
--    (1.350) suman el 76,8% del total: la facturación depende de
--    pocos productos de alto precio.
--
-- 2. El producto 2 es el que más unidades vende (13), pero aporta
--    solo 364 (5,6% del total) y queda 5° en el ranking: mucho
--    volumen no implica mucha facturación.
--
-- 3. Los 5 clientes son recurrentes (2 pedidos cada uno), pero el
--    gasto está concentrado: los clientes 1 (2.640) y 5 (2.100)
--    explican el 73,6% de la facturación.
--
-- Nota: todas las ventas cargadas son de marzo de 2024, por lo que
-- las consultas 1 y 4 devuelven un solo mes (6.444 facturados,
-- 10 pedidos, ticket promedio 644,40). Con un único mes, ese mes
-- coincide con el promedio mensual; la comparación entre meses va a
-- tener sentido cuando la base tenga más de un mes de ventas.
