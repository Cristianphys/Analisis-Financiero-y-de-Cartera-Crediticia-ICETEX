# Analisis-Financiero-y-de-Cartera-Crediticia-ICETEX
Este proyecto demuestra el proceso completo de ingeniería y visualización de datos por medio de las herramientas SQL, MySQL , POWER BI y Python/R: Por medio de la base de datos Datos.gov.co, obteniendo datos brutos de la Cartera crediticia del ICETEX en el periodo 2022- 2026.

# RESUMEN
El proyecto tiene como finalidad un análisis del estado financiero del ICETEX  durante el periodo 2022-2026. A partir de los datos suministrados por la entidad en Data.gov.co, donde nos garantiza la legitimidad. Se procede a convertir los datos en Excel/csv a una base de datos SQL, donde se procedió a la limpieza, organización y modelación de tablas. Posteriormente, se implementó la herramienta Power BI que facilita una visualización dinámica de los datos a partir de la creación de Dashboards. Esto permite al publico entender de forma simplificada el estado Financiero del ICETEX. En el apartado cuantitativo, se procedió la utilización de Python y R para definir predicciones de estado financiero y crediticio del ICETEX, por lo tanto, este proyecto permite resolver preguntas fundamentales en la gerencia de la entidad.

# Arquitectura de datos y flujo de trabajo

 1. Extracción --> Datos abiertos de ICETEX (Excel / CSV) en Data.gov.co
 2. Base de Datos  --> MySQL: Modelación de los datos de Excel a Tablas de Hechos y Dimensiones (PK / FK)
 3. Transformación SQL --> Limpieza, filtros, tipado y creación de Vistas Analíticas
 4. realización --> Power BI: Medidas DAX y Dashboard en 3 Páginas (Saldos | Créditos | Cartera)

#Tratamiento de datos en MySQL


El código que mostraré a continuación presenta el tratamiento de los datos de Excel/Csv en MySQL creando una base de dato nombrada "icetxx":

```USE icetxx;

DROP TABLE IF EXISTS icetxx.comportamiento_cartera_limpio;

CREATE TABLE icetxx.comportamiento_cartera_limpio AS
SELECT 
    *,
    CAST(REPLACE(REPLACE(REPLACE(`SALDO CAPITAL`, '$', ''), ',', ''), '.', '') AS SIGNED) AS `SALDO_CAPITAL_NUMERICO`,
    CAST(REPLACE(REPLACE(REPLACE(`SALDO TOTAL`, '$', ''), ',', ''), '.', '') AS SIGNED) AS `SALDO_TOTAL_NUMERICO`,
    CAST(REPLACE(REPLACE(REPLACE(`SALDO MORA`, '$', ''), ',', ''), '.', '') AS SIGNED) AS `SALDO_MORA_LIMPIO`,
    CAST(REPLACE(REPLACE(REPLACE(`CANTIDAD CREDITOS AL DIA`, '$', ''), ',', ''), '.', '') AS SIGNED) AS `CANTIDAD_CREDITO_AL_DIA_N`,
    CAST(REPLACE(REPLACE(REPLACE(`CANTIDAD CREDITOS CON MORA MENOR A 90 DIAS`, '$', ''), ',', ''), '.', '') AS SIGNED) AS `CANTIDAD_CREDITOS_CON_MORA_MENOR_A_90_DIAS_N`,
    CAST(REPLACE(REPLACE(REPLACE(`CANTIDAD CREDITOS MORA MAYOR A 90 DIAS`, '$', ''), ',', ''), '.', '') AS SIGNED) AS `CANTIDAD_CREDITOS_MORA_MAYOR_A_90_DIAS_N`,
    CAST(REPLACE(REPLACE(REPLACE(`TOTAL CREDITOS`, '$', ''), ',', ''), '.', '') AS SIGNED) AS `TOTAL_CREDITOS_N`,
    CAST(
        REPLACE(REPLACE(REPLACE(`INDICADOR CARTERA VENCIDA`, '%', ''), ' ', ''), ',', '.') 
    AS DECIMAL(5,2)) AS `PORCENTAJE_NUMERICO`
FROM icetxx.`comportamiento_de_cartera_y_crédito._20260814`;


ALTER TABLE icetxx.comportamiento_cartera_limpio
  DROP COLUMN `SALDO CAPITAL`,
  DROP COLUMN `SALDO TOTAL`,
  DROP COLUMN `SALDO MORA`,
  DROP COLUMN `CANTIDAD CREDITOS AL DIA`,
  DROP COLUMN `CANTIDAD CREDITOS CON MORA MENOR A 90 DIAS`,
  DROP COLUMN `CANTIDAD CREDITOS MORA MAYOR A 90 DIAS`,
  DROP COLUMN `TOTAL CREDITOS`,
  DROP COLUMN `INDICADOR CARTERA VENCIDA`;


ALTER TABLE icetxx.comportamiento_cartera_limpio
  RENAME COLUMN `SALDO_CAPITAL_NUMERICO` TO `SALDO CAPITAL`,
  RENAME COLUMN `SALDO_TOTAL_NUMERICO` TO `SALDO TOTAL`,
  RENAME COLUMN `SALDO_MORA_LIMPIO` TO `SALDO MORA`,
  RENAME COLUMN `CANTIDAD_CREDITO_AL_DIA_N` TO `CANTIDAD CREDITOS AL DIA`,
  RENAME COLUMN `CANTIDAD_CREDITOS_CON_MORA_MENOR_A_90_DIAS_N` TO `CANTIDAD CREDITOS CON MORA MENOR A 90 DIAS`,
  RENAME COLUMN `CANTIDAD_CREDITOS_MORA_MAYOR_A_90_DIAS_N` TO `CANTIDAD CREDITOS MORA MAYOR A 90 DIAS`,
  RENAME COLUMN `TOTAL_CREDITOS_N` TO `TOTAL CREDITOS`,
  RENAME COLUMN `PORCENTAJE_NUMERICO` TO `INDICADOR CARTERA VENCIDA`;

SET SQL_SAFE_UPDATES = 0;


UPDATE icetxx.comportamiento_cartera_limpio
SET `DEPTORESIDENCIA` = 'DISTRITO CAPITAL'
WHERE UPPER(REPLACE(`DEPTORESIDENCIA`, ' ', '')) = 'DISTRITOCAPITAL';
UPDATE icetxx.comportamiento_cartera_limpio
SET `DEPTORESIDENCIA` = 'VALLE DEL CAUCA'
WHERE UPPER(REPLACE(`DEPTORESIDENCIA`, ' ', '')) = 'VALLEDELCAUCA';
UPDATE icetxx.comportamiento_cartera_limpio
SET `DEPTORESIDENCIA` = 'SIN INFORMACION'
WHERE UPPER(`DEPTORESIDENCIA`) IN ('SIN_INFO','SININFORMACION',  'SIN INFO', 'SININFO', 'SIN INFORMACION');
UPDATE icetxx.comportamiento_cartera_limpio
SET `DEPTORESIDENCIA` = 'LA GUAJIRA'
WHERE UPPER(REPLACE(`DEPTORESIDENCIA`, ' ', '')) = 'LAGUAJIRA';
UPDATE icetxx.comportamiento_cartera_limpio
SET `DEPTORESIDENCIA` = 'NORTE DE SANTANDER'
WHERE UPPER(REPLACE(`DEPTORESIDENCIA`, ' ', '')) = 'NORTEDESANTANDER';
UPDATE icetxx.comportamiento_cartera_limpio
SET `DEPTORESIDENCIA` = 'SAN ANDRES'
WHERE UPPER(REPLACE(`DEPTORESIDENCIA`, ' ', '')) = 'SANANDRES';

UPDATE icetxx.comportamiento_cartera_limpio
SET `DEPTORESIDENCIA` = UPPER(TRIM(`DEPTORESIDENCIA`));

UPDATE icetxx.comportamiento_cartera_limpio
SET `EPOCA CARTERA` = UPPER(TRIM(`EPOCA CARTERA`));

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM icetxx.comportamiento_cartera_limpio;
```
# Modelación de tablas dinámicas: 
Las tablas se componen principalmente por su fecha de corte y departamento correspondiente.

1. Saldos:

```
USE icetxx;

DROP TABLE IF EXISTS Departamento_Saldos;

CREATE TABLE Departamento_Saldos AS 
SELECT
    `FECHA CORTE` AS fecha_corte,
    `DEPTORESIDENCIA` AS departamento,
    `SALDO CAPITAL` AS saldo_capital,
    `SALDO TOTAL` AS saldo_total,
    `SALDO MORA` AS saldo_mora
FROM icetxx.comportamiento_cartera_limpio
WHERE `DEPTORESIDENCIA` IS NOT NULL;

SELECT * FROM Departamento_Saldos;
```

2. Creditos:

```
USE icetxx;
DROP TABLE IF EXISTS icetxx.resumen_creditos_departamento;

CREATE TABLE icetxx.resumen_creditos_departamento AS
SELECT 
    `FECHA CORTE` AS fecha_corte,
    `DEPTORESIDENCIA` AS departamento,
    SUM(`TOTAL CREDITOS`) AS numero_de_creditos, 
    SUM(`CANTIDAD CREDITOS AL DIA`) AS numero_creditos_al_dia,
    SUM(`CANTIDAD CREDITOS CON MORA MENOR A 90 DIAS`) AS numero_creditos_mora_menor,
    SUM(`CANTIDAD CREDITOS MORA MAYOR A 90 DIAS`) AS numero_creditos_mora_mayor
FROM icetxx.comportamiento_cartera_limpio
WHERE `DEPTORESIDENCIA` IS NOT NULL
GROUP BY `FECHA CORTE`, `DEPTORESIDENCIA`;

SELECT * FROM icetxx.resumen_creditos_departamento;
```
3. Cartera:

```
USE icetxx;

DROP TABLE IF EXISTS Cartera_vencida;

CREATE TABLE Cartera_vencida AS 
SELECT
    `FECHA CORTE` AS fecha_corte,
    `DEPTORESIDENCIA` AS Departamento,
    `EPOCA CARTERA` AS Epoca_Cartera,
    `INDICADOR CARTERA VENCIDA` AS Cartera_Vencida
FROM icetxx.comportamiento_cartera_limpio
WHERE `DEPTORESIDENCIA` IS NOT NULL;

-- Visualizar los resultados
SELECT * FROM Departamento_Saldos;
```
# DASHBOARD




https://github.com/user-attachments/assets/922b7694-db99-46f4-9b48-58ce98833e3a





