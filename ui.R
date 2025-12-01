ui <- navbarPage(
  title = "💼 Application RH – Analyse des rémunérations",
  theme = bs_theme(version = 5, bootswatch = "flatly",
                   primary = "#2C3E50", secondary = "#18BC9C"),
  
  # --- ACCUEIL ---
  tabPanel(
    "🏠 Accueil",
    fluidPage(
      h2("Bienvenue dans l'application RH"),
      p("Cette application permet de suivre et comparer les rémunérations des salariés d'une entreprise fictive."),
      p("Dans un premier temps, vous pouvez explorer les données nettoyées. 
         Dans un second temps, vous pouvez réaliser des analyses statistiques 
         pour comparer les niveaux de rémunération selon différents critères."),
      br(),
      actionButton(
        "go_readme",
        "En savoir plus",
        onclick = "window.open('https://github.com/AyidaT04/Projet_RH_shiny/blob/main/README.md', '_blank')"
      )
    )
  ),
  
  # --- EXPLORATION ---
  tabPanel(
    "🔍 Exploration",
    fluidPage(
      h3("Données"),
      DTOutput("table_data"),
      
      br(),
      h3("Résumé statistique global"),
      tableOutput("resume_global"),
      
      br(),
      h3("Répartition des salariés"),
      fluidRow(
        column(4, plotlyOutput("prop_sexe")),
        column(4, plotlyOutput("prop_contrat")),
        column(4, plotlyOutput("prop_etat"))
      )
    )
  ),
  
  # --- ANALYSE ---
  tabPanel(
    "📊 Analyse",
    sidebarLayout(
      
      sidebarPanel(
        selectInput(
          "critere", "Critère de comparaison :",
          choices = c(
            "Tranche d'âge" = "tranche_age",
            "Sexe" = "Sexe",
            "État civil" = "Etat_Civil",
            "Type de contrat" = "Contrat"
          )
        ),
        
        selectInput("filtre_sexe", "Filtrer par sexe :",
                    c("Tous", sort(unique(data$Sexe)))),
        selectInput("filtre_contrat", "Filtrer par contrat :",
                    c("Tous", sort(unique(data$Contrat)))),
        selectInput("filtre_age", "Filtrer par tranche d'âge :",
                    c("Tous", as.character(levels(data$tranche_age))))
      ),
      
      mainPanel(
        tabsetPanel(
          tabPanel("Résumé statistique", br(), tableOutput("resume")),
          tabPanel("Graphique interactif", br(), plotlyOutput("boxplot")),
          tabPanel("Test statistique", br(), tableOutput("test"))
        )
      )
    )
  )
)
