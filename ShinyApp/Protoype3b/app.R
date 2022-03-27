library(shiny)
library(tidyverse)
library(tools)
library(plotly)

exam <- read_csv("data/Exam_data.csv")

ui <- fluidPage(
  titlePanel("Drill-down Bar Chart"),
  mainPanel(
      plotlyOutput("race"),
      plotlyOutput("gender"),
      verbatimTextOutput("info")
    )
  )

server <- function(input, output) {
  output$race <- renderPlotly({
    p <- exam %>%
      plot_ly(x = ~RACE)
  })
  output$gender <- renderPlotly({
    d <- event_data("plotly_click")
    if (is.null(d)) return(NULL)
    p <- exam %>% 
      filter(RACE %in% d$x) %>% 
      ggplot(aes(x=GENDER)) +
      geom_bar() 
    ggplotly(p) %>%
      layout(xaxis = list(title = d$x))
  })
  output$info <- renderPrint({
    event_data("plotly_click")
  })    
}

shinyApp(ui = ui, server = server)
