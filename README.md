# Migración y aglomeración: Efectos de olas migratorias sobre las aglomeraciones empresariales en el tejido urbano
---
### por Laura Rios, Luis Gonzalez, Fernando Castrillón

El proyecto consiste en la ciumalción de un expermiento social que busca responder responder las siguientes preguntas:

> ¿Comunidades de migrantes forman sus propias economías de aglomeración?
> ¿Las aglomeraciones de origen migrante tienen impacto sobre aglomeraciones nativas?

Para ello se simulo una población hipótetica de Firmas para las ciudades de Bogotá Cali y Medellín. a su vez se generó una asignación de tratamiento y más datos hipotéticos basados en datos reales del 2021. Para evaluar el impacto del tratamiento se utilizo una métodología de Diferencias en Diferencias. Se encontró una alta dependencia del poder estadístico al tamaño de la muetra ya que el efecto objetivo, según literatura relacionada, es bastante pequeño.

Este repositorio contiene los códigos para el proyecto titulado **"Migración y aglomeración: Efectos de olas migratorias sobre las aglomeraciones empresariales en el tejido urbano"** incluyendo los datos y resultados.

El repositorio contiene las siguientes carpetas:

- **Code**: Carpeta que contiene los códigos que replican el experimento propuesto. Incluye 2 *Scripts* los cuales son: *Import_Data.R* para  importar los datos y guardar la imagen del sistema. Luego está *Bogotá.R* En donde se encuentra el código del experimento. Este se divide en 7 pasos y el paso 0. Esta es la calibración del experimento, donde es establecen parámetros como el tamaño del sampleo, la cantidad de Firmas según datos de oficiales de 2021. Finalmente, algunos efectos teóricos para el planteamiento de los resultados potenciales. Después de claibrar el experimento, se sigue el diseño del experimento según el marco MIDA:

1. DECLARE POPULATION
2. DECLARE SAMPLING
3. DECLARE ASSIGNMENT
4. DECLARE OUTCOMES
5. DECLARE INQUIRY
6. REVEAL Y
7. DECLARE ESTIMATOR

- **Data**: La carpeta data contiene la información geoespacial de cada ciudad. Especificamente, contiene las secciones urbanas de todo colombia, extraida del Marco Geográfico Nacional del DANE.

- **Results**: La carpeta results contiene las imagenes de los mapas que fueron creadas utlizando los códigos de la carpeta **Code**
