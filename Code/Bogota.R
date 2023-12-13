# Laura Rios
# Luis Gonzalez
# Fernando Castrillón

# Taller 2 Economía Urbana
# Importación y limpieza de Datos

rm(list=ls())
library(pacman)
p_load(
  tidyverse,  # 'tidyverse': una colecci?n de paquetes dise?ados para ciencia de datos que incluye ggplot2, dplyr, tidyr, readr, etc.
  rio,        # 'rio': permite importar y exportar datos en m?ltiples formatos (como csv, excel, spss, etc) de manera f?cil.
  here,       # 'here': simplifica la construcci?n de rutas de archivos relativos al directorio de un proyecto R.
  sf,         # 'sf': provee clases y m?todos para datos espaciales (simple features) en R, reemplaza y mejora al paquete 'sp'.      
  DeclareDesign,
  DesignLibrary,
  randomizr,
  estimatr,
  fabricatr,
  broom
)

load("./Data/Data.RData")
rm(Cali, Medellin, secciones)

# PASO 0: CALIBRATION ==========================================================

# Capital Elasticity at Prodution Function
alpha <- 0.6
# Change in Product per worker due to time effects
tiempo <- 0.03
# Naive difference between treatment and control group
tratamiento <- 0.06
# Causal Effect of treatment to Product per worker
efecto <- 0.041
# PTF Parameter 
A <- 0.73
# Sampling
n_sample <- 10000

# PASO 1: DECLARE POPULATION ===================================================
N_secciones <- nrow(Bogota)
N_empresas <- ceiling(400286/(N_secciones*2))
Bogota_df <- fabricate(
  # Add sección (i) level variables
  seccion_level = add_level(N = N_secciones,
                            seccion_fe = runif(N, -.1, .1),
                            ID = seq(1:N_secciones),
                            migrantes = scale(rchisq(n = N, df = 5),
                                              center = min(rchisq(n = N, df = 5)),
                                              scale = max(rchisq(n = N, df = 5)) - min(rchisq(n = N, df = 5))),
                            elegible = ifelse(migrantes>0.3, 1, 0),
                            nest = TRUE),
  # Add time (t) level variables
  year_level = add_level(N = 2,
                         year_fe = runif(N, 1, 10),
                         year = rep(2020:2021),
                         Year = rep(0:1),
                         nest=TRUE),
  # Add Individual (j) level variables
  firm_level = add_level(N = 72,
                         firm_fe = runif(N, 1, 10),
                         K = rchisq(N, 5, 9),
                         L = sample(1:50, N, replace = TRUE),
                         Sector_industrial = sample(1:3, N, replace = TRUE, prob = c(0.0017, 0.12537, 0.87293)),
                         U = rnorm(N, sd=25),
                         E = seccion_fe + year_fe + firm_fe + U,
                         nest=TRUE)) %>%
  left_join(Bogota, by = 'ID') %>%
  dplyr::select(-ID, -year_level, -SECU_CCDGO, -MPIO_CDPMP) %>%
  mutate(firm = row_number()) %>%
  st_as_sf(sf_column_name = 'geometry')

population <- declare_population(
  Bogota_df
)

# PASO 2: DECLARE SUBSETTING ===============================
sampling <- declare_sampling(
  S = draw_rs(N=N, n= n_sample)
)

# PASO 3: DECLARE ASSIGNMENT ==============================
assignment_elegible <- declare_assignment(
  Z = ifelse(elegible==1 & S==1, rbinom(n=N, size=1, prob=0.9),0),
  Year = ifelse(year==2021, 1, 0)
)

# PASO 4: DECLARE OUTCOMES =====================================================
potencial_outcomes <- declare_potential_outcomes(
  formula = Y ~ tiempo * (Year) +
    tratamiento * (Z) +
    efecto * (Year) * Z +
    alpha * log(K/L) +
    #(1-alpha)*log(L) +
    -1,211 * (Sector_industrial==1) +
    0,99456 * (Sector_industrial==2) +
    0,495 * (Sector_industrial==3) +
    E,
  conditions = list(Z = 0:1)
)

# PASO 5: DECLARE INQUIRY ======================================================
inquiry <- declare_inquiries(
  DiD = mean(Y_Z_1[Year==1] - Y_Z_0[Year==1]) - mean(Y_Z_1[Year==0] - Y_Z_0[Year==0]),
)

# PASO 6: REVEAL Y =============================================================
reveal_Y <- declare_measurement(Y = reveal_outcomes(Y ~ Z))

# PASO 7: DECLARE ESTIMATOR ====================================================

estimator_did <- declare_estimator(
  Y ~ Z + Year + Z * Year + log(L) + factor(Sector_industrial), .method = lm_robust, term= "Z:Year", label='Diff-in-Diff', inquiry='DiD'
)

design_Bogota <- population +
  sampling + 
  assignment_elegible +
  potencial_outcomes +
  inquiry +
  reveal_Y +
  estimator_did

data <- draw_data(design_Bogota)
#View(data)
# PASO FINAL: DIAGNOSIS ========================================================
diagnosis <- diagnose_design(design_Bogota, sims = 40)
diagnosis

library(nominatimlite)
nominatim_polygon <- nominatimlite::geo_lite_sf(address = "Bogota, Colombia", points_only = FALSE)
bog_bbox <- sf::st_bbox(nominatim_polygon)

para_mapa <- data %>%
  filter(Year==1) %>%
  group_by(geometry, ) %>%
  summarize(
    Y_Mean = mean(Y),
    L_Mean = mean(L),
  ) %>%
  right_join(Bogota, by = "geometry") %>%
  st_as_sf(sf_column_name = 'geometry')


ggplot(para_mapa) +
  geom_sf(aes(fill = Y_Mean)) +
  scale_fill_gradient(low="thistle2", high="darkred", 
                         guide="colorbar",na.value="white")
  coord_sf(xlim = c(-74.25, -74), ylim = c(4.45, 4.9)) +
  theme_minimal()
    