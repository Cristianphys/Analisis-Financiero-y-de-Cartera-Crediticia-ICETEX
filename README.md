# Analisis-Financiero-y-de-Cartera-Crediticia-ICETEX
Este proyecto demuestra el proceso completo de ingeniería y visualización de datos por medio de las herramientas SQL, MySQL , POWER BI y Python/R: Por medio de la base de datos Datos.gov.co, obteniendo datos brutos de la Cartera crediticia del ICETEX en el periodo 2022- 2026.

# RESUMEN
El proyecto tiene como finalidad un análisis del estado financiero del ICETEX  durante el periodo 2022-2026. A partir de los datos suministrados por la entidad en Data.gov.co, donde nos garantiza la legitimidad. Se procede a convertir los datos en Excel/csv a una base de datos SQL, donde se procedió a la limpieza, organización y modelación de tablas. Posteriormente, se implementó la herramienta Power BI que facilita una visualización dinámica de los datos a partir de la creación de Dashboards. Esto permite al publico entender de forma simplificada el estado Financiero del ICETEX. En el apartado cuantitativo, se procedió la utilización de Python y R para definir predicciones de estado financiero y crediticio del ICETEX, por lo tanto, este proyecto permite resolver preguntas fundamentales en la gerencia de la entidad.

# Arquitectura de datos y flujo de trabajo
┌─────────────────┐      ┌─────────────────┐      ┌──────────────────┐      ┌─────────────────┐
│   Datos.gov.co  │ ───► │  MySQL (RDBMS)  │ ───► │ Transformación   │ ───► │   Power BI      │
│  (Excel / CSV)  │      │                 │      │SQL & Data Cleaning│     │  Dashboard      │
└─────────────────┘      └─────────────────┘      └──────────────────┘      └─────────────────┘

#porceso de limpieza de datos, organización y creación de los Tablas dinámicas en MySQL
