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
    
