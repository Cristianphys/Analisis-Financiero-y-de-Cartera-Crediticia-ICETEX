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