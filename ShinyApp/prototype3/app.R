

library(shiny)
library(tidyverse)
library(tools)
library(plotly)

exam <- read_csv("data/Exam_data.csv")
ui <- fluidPage(
  titlePanel("Subject Correlation Analysis"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "yvariable",
                  label = "y Variable:",
                  choices = c("English" = "ENGLISH",
                              "Maths" = "MATHS",
                              "Science" = "SCIENCE"),
                  selected = "MATHS"),
      selectInput(inputId = "xvariable",
                  label = "x Variable:",
                  choices = c("English" = "ENGLISH",
                              "Maths" = "MATHS",
                              "Science" = "SCIENCE"),
                  selected = "SCIENCE")
    ),
    mainPanel(
      plotlyOutput("scatterPlot")
    )
  )
)
    
server <- function(input, output, session){
  output$scatterPlot <- renderPlotly({
    p <- ggplot(data=exam,
           aes_string(x = input$xvariable,
                      y = input$yvariable)) +
      geom_point(color = "grey 10",
                 size = 1)
    ggplotly(p)
  })
}
   
shinyApp(ui = ui, server = server)
