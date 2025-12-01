# Projet_RH_shiny - Analyse des Rémunérations

## Présentation

Cette application Shiny permet d’explorer et d’analyser les rémunérations des salariés d’une **entreprise fictive**.  
Elle a été conçue pour être intuitive, pédagogique et adaptée aux études statistiques descriptives et comparatives.

Elle propose deux grands modules :

1. **Exploration des données**  
   - Tableau des données 
   - Visualisation des caractéristiques de la population :  
     proportions hommes/femmes, types de contrat (CDI/CDD), état civil…  
   - Résumé global des salaires (moyenne, médiane, min, max)
   - Tableau interactif des salariés (filtre par colonnes)

2. **Analyse comparative des salaires**  
   - Filtrage par sexe, contrat ou tranche d’âge
   - Comparaison des niveaux de rémunération selon un critère choisi : Sexe, Contrat, Âge ou État civil  
   - Résumés statistiques par groupe
   - Boxplots comparatifs interactifs
   - Tests statistiques (Wilcoxon ou Kruskal–Wallis) sélectionnés automatiquement selon le nombre de groupes

---

## Objectifs de l’application

Cette application permet :

- d’explorer la base de données déjà nettoyée 
- de comprendre la structure de la population étudiée 
- de comparer les salaires selon différents critères 
- de savoir s'il y a une différence significative entre les groupes de salariés 


Elle sert donc à la fois d’outil **d’exploration** et **d’analyse statistique**.

---

## Structure de l’application

### **1. Accueil**
- Présentation générale de l’application
- Bouton pour accéder au README du projet
- Accès aux différents modules

### **2. Exploration**
- Résumé global des salaires
- Graphiques en secteurs :
  - proportion hommes/femmes ;
  - types de contrats ;
  - état civil
- Tableau de données des salariés

### **3. Analyse**
- Filtres : Sexe, Contrat, Tranche d’âge, Etat civil
- Résumés statistiques par groupe selon le critère choisi
- Boxplot interactif des salaires
- Test statistique automatique :
  - **Wilcoxon** si 2 groupes
  - **Kruskal–Wallis** si >2 groupes

---

## Méthodologie des tests statistiques

Les salaires ne sont pas normalement distriués entre les groupes donc nous avons opté pour les tests non paramétriques.

### **Test de Wilcoxon**
Utilisé lorsqu’on compare **deux groupes**  
(ex : Hommes vs Femmes, CDI vs CDD)

**Hypothèses :**
- H0 : les distributions des deux groupes sont identiques  
- H1 : les distributions des deux groupes sont différentes

### **Test de Kruskal–Wallis**
Utilisé lorsqu’il y a **plus de deux groupes**  
(ex : tranches d’âge 20–29, 30–39, 40–49, 50–59)

**Hypothèses :**
- H0 : toutes les distributions de salaires sont identiques entre les groupes  
- H1 : au moins un groupe présente une distribution différente


---

## Principales technologies utilisées

- **R** — langage d’analyse  
- **Shiny** — interface web  
- **tidyverse** — manipulation et préparation des données  
- **DT** — tableaux interactifs  
- **Plotly** — graphiques interactifs  
- **rstatix** — tests statistiques  
- **ggplot2** — visualisation graphique  

