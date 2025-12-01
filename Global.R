library(readxl)
library(dplyr)
library(ggplot2)
library(forcats)
library(lubridate)
library(rstatix)
library(shiny)
library(bslib)
library(plotly)
library(DT)

# ==== IMPORT ====
Contrats  <- read_excel("Data/RH_Contrats.xlsx")
Salaries  <- read_excel("Data/RH_Salaries.xlsx")

# ==== PREPARATION ====
data <- Salaries %>%
  left_join(Contrats, by = "id_salarié") %>%
  filter(!is.na(Contrat))

# Outliers
q3_sal  <- quantile(data$Salaire, 0.75, na.rm = TRUE)
iqr_sal <- IQR(data$Salaire, na.rm = TRUE)
seuil_sup <- q3_sal + 3 * iqr_sal

q3_enf  <- quantile(data$Enfants, 0.75, na.rm = TRUE)
iqr_enf <- IQR(data$Enfants, na.rm = TRUE)
seuil_sup_enf <- q3_enf + 3 * iqr_enf

data <- data %>%
  distinct(id_salarié, .keep_all = TRUE) %>%
  filter(Salaire <= seuil_sup) %>%
  filter(Enfants <= seuil_sup_enf)

# Tranches d'âge
data <- data %>%
  mutate(
    tranche_age = cut(
      Age,
      breaks = c(20, 30, 40, 50, 60),
      labels = c("20-29", "30-39", "40-49", "50-59"),
      right = FALSE,
      include.lowest = TRUE
    ),
    Etat_Civil = if_else(is.na(Etat_Civil), "Non renseigné", Etat_Civil),
    Contrat    = if_else(is.na(Contrat), "Non renseigné", Contrat),
    Sexe       = if_else(is.na(Sexe), "Non renseigné", Sexe)
  )

data$tranche_age <- factor(
  data$tranche_age,
  levels = c("20-29", "30-39", "40-49", "50-59"),
  ordered = TRUE
)
