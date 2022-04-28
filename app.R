library(shiny)
library(shinythemes)

# Read files
games <- read.csv('./data/games.csv')
leagues <- read.csv('./data/leagues.csv')
teams <- read.csv('./data/teams.csv')
players <- read.csv('./data/players.csv')

#Define server function
server <- function(input,output,session) {
  output$gamesTable <- renderTable(games)
  observe({
    updateSelectInput(session,"leagueName",choices = leagues$name)
    updateSelectInput(session,"matchName",choices = games$gameID)
    updateSelectInput(session,"teamName",choices = teams$name)
    updateSelectInput(session,"playerName",choices = players$name)
  })
}

#UI
ui = fluidPage(
  theme = "custom.css",
  h1("EAS 509 - Visualization and Analysis of European football"),
  fluidRow(
    column(width = 3,
           selectInput("leagueName","Select League Name","Premier League","Names")
    ),
    column(3,
           selectInput("matchName","Select Match Name","Names")
    ),
    column(3,
           selectInput("teamName","Select Team Name","Names")
    ),
    column(3,
           selectInput("playerName","Select Player Name","Names")
    )
  ),
  fluidRow(
    column(width=12,
           tableOutput('gamesTable')
    )
  )
)

# Creating shiny object
shinyApp(ui=ui,server=server)
