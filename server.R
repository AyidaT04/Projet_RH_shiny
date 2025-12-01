server <- function(input, output, session) {
  
  # ====== TABLEAU ======
  output$table_data <- renderDT({
    datatable(
      data,
      filter = "top",
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })
  
  # ====== RÉSUMÉ GLOBAL ======
  output$resume_global <- renderTable({
    data.frame(
      Effectif = nrow(data),
      Salaire_moyen  = round(mean(data$Salaire), 1),
      Salaire_médian = round(median(data$Salaire), 1),
      Salaire_min    = round(min(data$Salaire), 1),
      Salaire_max    = round(max(data$Salaire), 1)
    )
  })
  
  # ====== PIE SEXE ======
  output$prop_sexe <- renderPlotly({
    df <- data %>% filter(Sexe != "Non renseigné") %>% count(Sexe)
    plot_ly(df, labels = ~Sexe, values = ~n, type = "pie") %>%
      layout(title = "Sexe")
  })
  
  # ====== PIE CONTRAT ======
  output$prop_contrat <- renderPlotly({
    df <- data %>% filter(Contrat != "Non renseigné") %>% count(Contrat)
    plot_ly(df, labels = ~Contrat, values = ~n, type = "pie") %>%
      layout(title = "Contrat")
  })
  
  # ====== PIE ETAT CIVIL ======
  output$prop_etat <- renderPlotly({
    df <- data %>% filter(Etat_Civil != "Non renseigné") %>% count(Etat_Civil)
    plot_ly(df, labels = ~Etat_Civil, values = ~n, type = "pie") %>%
      layout(title = "État civil")
  })
  
  # ====== FILTRE ======
  data_filtre <- reactive({
    df <- data
    
    if (input$filtre_sexe != "Tous") df <- df %>% filter(Sexe == input$filtre_sexe)
    if (input$filtre_contrat != "Tous") df <- df %>% filter(Contrat == input$filtre_contrat)
    if (input$filtre_age != "Tous") df <- df %>% filter(tranche_age == input$filtre_age)
    
    df
  })
  
  # ====== RESUME ======
  output$resume <- renderTable({
    crit <- input$critere
    
    data_filtre() %>%
      filter(.data[[crit]] != "Non renseigné") %>%
      group_by(.data[[crit]]) %>%
      summarise(
        Effectif = n(),
        Salaire_moyen  = round(mean(Salaire), 1),
        Salaire_médian = round(median(Salaire), 1)
      )
  })
  
  # ====== BOXPLOT ======
  output$boxplot <- renderPlotly({
    df <- data_filtre()
    crit <- input$critere
    df <- df[df[[crit]] != "Non renseigné", ]
    
    p <- ggplot(df, aes(x = .data[[crit]], y = Salaire, fill = .data[[crit]])) +
      geom_boxplot(alpha = 0.7) +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # =======================================================
  # ====== TEST STATISTIQUE (VERSION 100% FONCTIONNELLE) ==
  # =======================================================
  
  output$test <- renderTable({
    df <- data_filtre()
    crit <- input$critere
    
    # Filtrage base R -> évite l'erreur .data
    df <- df[!is.na(df[[crit]]) & df[[crit]] != "Non renseigné" & !is.na(df$Salaire), ]
    
    # Comptes par groupe (pour vérifier que test possible)
    groups_tab <- as.data.frame(table(df[[crit]]))
    colnames(groups_tab) <- c("Groupe", "Effectif")
    n_groups <- nrow(groups_tab)
    
    # Si pas assez de groupes → on affiche info
    if (n_groups < 2) {
      return(data.frame(
        Information = "Pas assez de groupes pour réaliser un test",
        Groupes = paste0(groups_tab$Groupe, "(", groups_tab$Effectif, ")", collapse = ", ")
      ))
    }
    
    # Formule dynamique
    f <- as.formula(paste("Salaire ~", crit))
    
    # Exécution + gestion erreurs
    res <- tryCatch({
      if (n_groups == 2) {
        t <- wilcox_test(df, f)
        data.frame(
          Test = "Wilcoxon",
          p_value = round(t$p, 6),
          Conclusion = ifelse(t$p < 0.05, "Différence significative", "Pas de différence significative"),
          Groupes = paste0(groups_tab$Groupe, "(", groups_tab$Effectif, ")", collapse = ", ")
        )
      } else {
        t <- kruskal_test(df, f)
        data.frame(
          Test = "Kruskal-Wallis",
          p_value = round(t$p, 6),
          Conclusion = ifelse(t$p < 0.05, "Différence significative", "Pas de différence significative"),
          Groupes = paste0(groups_tab$Groupe, "(", groups_tab$Effectif, ")", collapse = ", ")
        )
      }
    }, error = function(e) {
      data.frame(
        Test = NA,
        p_value = NA,
        Conclusion = paste("Erreur :", e$message),
        Groupes = paste0(groups_tab$Groupe, "(", groups_tab$Effectif, ")", collapse = ", ")
      )
    })
    
    res
  })
}
