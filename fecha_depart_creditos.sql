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