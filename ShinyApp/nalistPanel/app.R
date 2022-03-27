library(shiny)
library(tidyverse)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(bootswatch = "cyborg"),
  titlePanel("Multi-pages Layout"),
  tabsetPanel(
    tabPanel("Import data", 
             fileInput("file", "Data", buttonLabel = "Upload..."),
             textInput("delim", "Delimiter (leave blank to guess)", ""),
             numericInput("skip", "Rows to skip", 0, min = 0),
             numericInput("rows", "Rows to preview", 10, min = 1)
    ),
    tabPanel("Variable selection"),
    tabPanel("Model calibration"),
    tabPanel("Model evaluation")
  )
)

server <- function(input, output){}

shinyApp(ui = ui, server = server)