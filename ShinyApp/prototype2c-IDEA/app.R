library(shiny)
library(tidyverse)
exam <- read_csv("data/Exam_data.csv")

ui <- fluidPage(
  titlePanel("Interactive Data Exploration and Analysis (IDEA)"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "yvariable",
                  label = "Subject:",
                  choices = c("English" = "ENGLISH",
                              "Maths" = "MATHS",
                              "Science" = "SCIENCE"),
                  selected = "ENGLISH"),
      selectInput(inputId = "xvariable",
                  label = "Subject:",
                  choices = c("English" = "ENGLISH",
                              "Maths" = "MATHS",
                              "Science" = "SCIENCE"),
                  selected = "MATHS"),
      actionButton("exclude_toggle", "Toggle points"),
      actionButton("exclude_reset", "Reset")
    ),
    mainPanel(
      plotOutput("scatterPlot",
                 click = "plot1_click",
                 brush = brushOpts(
                   id = "plot1_brush")
      )
    )    
  )
)

server <- function(input, output){
  vals <- reactiveValues(
    keeprows = rep(TRUE, nrow(exam))
  )
  
  output$scatterPlot <- renderPlot({
    # Plot the kept and excluded points as two separate data sets
    keep    <- exam[ vals$keeprows, , drop = FALSE]
    exclude <- exam[!vals$keeprows, , drop = FALSE]
    ggplot(data = keep, 
           aes_string(x = input$xvariable,
                      y = input$yvariable)) + 
      geom_point() +
      geom_smooth(method = lm, 
                  fullrange = TRUE, 
                  color = "black") +
      geom_point(data = exclude, 
                 shape = 21, 
                 fill = NA, 
                 color = "black", 
                 alpha = 0.25) +
      coord_cartesian(xlim=c(0,100),
                      ylim=c(0,100))
  })

# Toggle points that are clicked
observeEvent(input$plot1_click, {
  res <- nearPoints(exam, input$plot1_click, allRows = TRUE)
  
  vals$keeprows <- xor(vals$keeprows, res$selected_)
})

# Toggle points that are brushed, when button is clicked
observeEvent(input$exclude_toggle, {
  res <- brushedPoints(exam, input$plot1_brush, allRows = TRUE)
  
  vals$keeprows <- xor(vals$keeprows, res$selected_)
  })

# Reset all points
observeEvent(input$exclude_reset, {
  vals$keeprows <- rep(TRUE, nrow(exam))
  })
}

shinyApp (ui=ui, server=server)




