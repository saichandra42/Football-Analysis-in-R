library(shiny)
library(reactable)
library(shinyfilter)

# Read files
games <- read.csv('./data/all_merged.csv',stringsAsFactors = FALSE, header = TRUE, encoding = "UTF-8")


# UI of the Application
ui <- fluidPage(
  theme = "custom.css",
  titlePanel("EAS 509 - Visualization and Analysis of European football"),
  sidebarLayout(
    sidebarPanel(
      width = 2,
      selectizeInput(inputId = "game_id", label = "Game ID",
                     multiple = TRUE, options = list(onChange = event("ev_click")),
                     choices = sort(unique(games$gameID))),
      
      selectizeInput(inputId = "league_id",label = "League ID",
                     multiple = TRUE, options = list(onChange = event("ev_click")),
                     choices = sort(unique(games$leagueID))),
      
      selectizeInput(inputId = "season",label = "Season",
                     multiple = TRUE, options = list(onChange = event("ev_click")),
                     choices = sort(unique(games$season))),
      
      selectizeInput(inputId = "homeTeamID",label = "Home Team ID",
                     multiple = TRUE, options = list(onChange = event("ev_click")),
                     choices = sort(unique(games$homeTeamID))),
      
      selectizeInput(inputId = "awayTeamID",label = "Away Team ID",
                     multiple = TRUE, options = list(onChange = event("ev_click")),
                     choices = sort(unique(games$awayTeamID)))
    ),
    mainPanel(
      width = 10,
      reactableOutput(outputId = "tbl_games")
    )
  )
)

# Logic of the application
server <- function(input, output, session) {
  
  r <- reactiveValues(games_table = games)
  
  define_filters(input,
                 "tbl_games",
                 c(game_id = "gameID", 
                   league_id= "leagueID",
                   season="season",
                   date="date",
                   homeTeamID = "homeTeamID",
                   awayTeamID = "awayTeamID",
                   homeGoals = "Home Goals",
                   awayGoals = "Away Goals",
                   homeProbability = "Home Probability",
                   drawProbability = "Draw Probability")
                 ,games)
  
  observeEvent(input$ev_click, {
    r$games_table <- update_filters(input, session, "tbl_games")
  })
  
  output$tbl_games <- renderReactable({
    reactable(data = r$games_table,
              filterable = TRUE,
              rownames = FALSE,
              selection = "multiple",
              showPageSizeOptions = TRUE,
              paginationType = "jump",
              showSortable = TRUE,
              highlight = TRUE,
              resizable = TRUE,
              rowStyle = list(cursor = "pointer"),
              onClick = "select"
    )
  })
  
}

shinyApp(ui = ui, server = server)