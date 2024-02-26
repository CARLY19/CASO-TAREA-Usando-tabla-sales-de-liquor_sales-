/** 1) 	Tendencia mensual: ¿Cuál ha sido la tendencia de
 ventas mes a mes
 durante el último año registrado? Se espera un resumen mensual. **/
SELECT
  DATE_TRUNC(DATE, MONTH) AS Mes,
  SUM(quantity_sold * price) AS Ventas_totales
FROM
  `bigquery-public-data.iowa_liquor_sales.sales`
WHERE
  DATE BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) AND CURRENT_DATE()
GROUP BY
  Mes
ORDER BY
  Mes ASC;
/** 2) 2.	Tiendas destacadas: Identifica las tres tiendas con las mayores ventas en el último año.
 Además, para estas tiendas, proporciona el producto más vendido (en términos de cantidad de botellas) 
 y su categoría 
de volumen (Bajo, Medio, Alto según las reglas dadas anteriormente).. **/
SELECT
  store_name,
  SUM(quantity_sold * price) AS Ventas_totales,
  product_name,
  CASE
    WHEN volume_ml BETWEEN 0 AND 375 THEN 'Bajo'
    WHEN VOLUME_ML BETWEEN 376 AND 750 THEN 'Medio'
    ELSE 'Alto'
  END AS Categoria_volumen
FROM
  `bigquery-public-data.iowa_liquor_sales.sales`
WHERE
  DATE BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) AND CURRENT_DATE()
GROUP BY
  store_name,
  product_name
ORDER BY
  Ventas_totales DESC
LIMIT
  3;


/** 3) 3.	Productos populares: Encuentra los cinco productos más vendidos en 
términos monetarios en el último año y muestra
 su descripción con la primera letra de cada palabra en mayúscula.**/


SELECT
  product_name,
  SUM(quantity_sold * price) AS Ventas_totales,
  CONCAT(UPPER(LEFT(description, 1)), LOWER(SUBSTR(description, 2))) AS Descripcion
FROM
  `bigquery-public-data.iowa_liquor_sales.sales`
WHERE
  DATE BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) AND CURRENT_DATE()
GROUP BY
  product_name,
  Descripcion
ORDER BY
  Ventas_totales DESC
LIMIT
  5;

/** 4) 4.	Análisis de categorías de licor: Basándose en 
el precio promedio por litro de cada producto, categorízalos como "Económico" si el precio es menor a 100 por litro, 
"Premium" si es mayor o igual a 100 por litro. Proporciona un resumen de cuántos productos hay en 
cada categoría y cuál es el producto más caro de la categoría **/
SELECT
  CASE
    WHEN AVG(price / volume_ml * 1000) < 100 THEN 'Económico'
    ELSE 'Premium'
  END AS Categoria,
  COUNT(DISTINCT product_name) AS Cantidad_productos,
  MAX(price / volume_ml * 1000) AS Precio_maximo
FROM
  `bigquery-public-data.iowa_liquor_sales.sales`
WHERE
  DATE BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) AND CURRENT_DATE()
GROUP BY
  Categoria
ORDER BY
  Categoria ASC;
