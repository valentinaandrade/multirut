# Code 2: Identification --------------------------------------------------

# 1. Load packages --------------------------------------------------------
pacman::p_load(haven, tidyverse)
# 2. Load data ------------------------------------------------------------
data <- read_dta("~/Library/CloudStorage/Dropbox/Research/multirut_shared/02_data/tmp/base_3.dta")


# 3. Prepare data ---------------------------------------------------------
data <- data %>% 
  mutate(year = as.integer(year),
         id = as.factor(id),
         id_emp = as.factor(id_emp)) %>% 
  filter(year %in% c(2013,2014))


# 4. Employee moving identification ---------------------------------------
movimientos <- data %>%
  arrange(id, month) %>%
  group_by(id) %>%
  mutate(firma_anterior = lag(id_emp)) %>%
  filter(!is.na(firma_anterior), firma_anterior != id_emp)

# Identificar posibles fusiones
fusiones_potenciales <- movimientos %>%
  group_by(month, id_emp) %>%
  summarise(num_empleados = n_distinct(id),
            firmas_origen = list(unique(firma_anterior))) %>%
  filter(num_empleados > 1) # Ajusta este número según lo que consideres significativo

# Ver los resultados
print(fusiones_potenciales)