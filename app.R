library(shiny)
library(reactable)
library(shinyfilter)

# Read files
games <- read.csv('./data/all_merged.csv', header = TRUE, encoding = "UTF-8")


# UI of the Application
ui <- fluidPage(
  theme = "custom.css",
  titlePanel("EAS 509 - Visualization and Analysis of European football"),
  sidebarLayout(
    sidebarPanel(
      width = 2,
      selectizeInput(inputId = "league_name", label = "League Name",
                     multiple = TRUE, options = list(onChange = event("ev_click")),
                     choices = sort(unique(games$leagueName))),
      selectizeInput(inputId = "hometeam_name", label = "Home Team Name",
                     multiple = TRUE, options = list(onChange = event("ev_click")),
                     choices = sort(unique(games$hometeam_name))),
      selectizeInput(inputId = "awayteam_name", label = "Away Team Name",
                     multiple = TRUE, options = list(onChange = event("ev_click")),
                     choices = sort(unique(games$awayteam_name))),
      selectizeInput(inputId = "player_name", label = "Player Name",
                     multiple = TRUE, options = list(onChange = event("ev_click")),
                     choices = sort(unique(games$player_name)))
    ),
    mainPanel(
      width = 10,
      reactableOutput(outputId = "tbl_games")
    )
  ),
  fluidRow(
    column(
      6,tags$img(src="1.jpeg",width="600px",height="400px")
    ),
    column(
      6,tags$img(src="2.jpeg",width="600px",height="400px")
    )
  ),
  fluidRow(
    column(
      6,tags$img(src="3.jpeg",width="600px",height="400px")
    ),
    column(
      6,tags$img(src="4.jpeg",width="600px",height="400px")
    )
  ),
  fluidRow(
    column(
      6,tags$img(src="5.jpeg",width="600px",height="400px")
    ),
    column(
      6,tags$img(src="6.jpeg",width="600px",height="400px")
    )
  ),
  fluidRow(
    column(
      6,tags$img(src="7.jpeg",width="600px",height="400px")
    ),
    column(
      6,tags$img(src="8.jpeg",width="600px",height="400px")
    )
  )
)


# Logic of the application
server <- function(input, output, session) {
  
  r <- reactiveValues(games_table = games)
  
  define_filters(input,
                 "tbl_games",
                 c(league_name = "leagueName",
                   hometeam_name = "hometeam_name",
                   awayteam_name = "awayteam_name",
                   player_name = "player_name"
                 ), 
                 games)
  
  observeEvent(input$ev_click, {
    r$games_table <- update_filters(input, session, "tbl_games")
  })
  
  
  output$tbl_games <- renderReactable({
    reactable(data = r$games_table,
              filterable = TRUE,
              rownames = FALSE,
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