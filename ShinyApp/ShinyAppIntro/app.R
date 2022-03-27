library(shiny)
library(tidyverse)

exam <- read_csv("data/Exam_data.csv")

ui <- fluidPage(
  titlePanel("Pupils Examination Results Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "variable",
                  label = "Subject:",
                  choices = c("English" = "ENGLISH",
                              "Math" = "MATHS",
                              "Science" = "SCIENCE"),
                  selected = "ENGLISH"),
      sliderInput(inputId = "bin",
                  label = "Name of Bins",
                  min = 5,
                  max = 20,
                  value = 10)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output){
  output$distPlot <- renderPlot({
    ggplot(exam, 
           aes_string(x = input$variable)) +
      geom_histogram(bins = input$bin,
                     color = "black",
                     fill = "light blue")
  })
}

shinyApp(ui = ui, server = server)

