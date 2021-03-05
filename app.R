
library(shiny)

ui <- fluidPage(
  h1("ola mundo")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)