# Laura Rios
# Luis Gonzalez
# Fernando Castrillón

# Taller 2 Economía Urbana
# Importación y limpieza de Datos

rm(list=ls())
library(pacman)
p_load(tidyverse,  # 'tidyverse': una colecci?n de paquetes dise?ados para ciencia de datos que incluye ggplot2, dplyr, tidyr, readr, etc.
       rio,        # 'rio': permite importar y exportar datos en m?ltiples formatos (como csv, excel, spss, etc) de manera f?cil.
       here,       # 'here': simplifica la construcci?n de rutas de archivos relativos al directorio de un proyecto R.
       sf,         # 'sf': provee clases y m?todos para datos espaciales (simple features) en R, reemplaza y mejora al paquete 'sp'.      
)

# Import city data
secciones <- st_read("./Data/SHP_MGN2018_INTGRD_SECCU/MGN_ANM_SECCION_URBANA.shp")
secciones <- secciones[c("SECU_CCDGO", "MPIO_CDPMP")]

Bogota <- secciones %>%
  filter(MPIO_CDPMP == "11001") %>%
  st_transform(crs = 4326) %>%
  mutate(ID = row_number()) # This will help add geometry to fabricate

Medellin <- secciones %>%
  filter(MPIO_CDPMP == "05001") %>%
  st_transform(crs = 4326) %>%
  mutate(ID = row_number()) # This will help add geometry to fabricate

Cali <- secciones %>%
  filter(MPIO_CDPMP == "76001") %>%
  st_transform(crs = 4326) %>%
  mutate(ID = row_number()) # This will help add geometry to fabricate

# Save Data from Script
save.image(file = "./Data/Data.RData")