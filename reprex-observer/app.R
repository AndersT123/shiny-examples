library(shiny)
library(purrr)
ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            numericInput("num_buttons", label = "Number of buttons:", value = 0),
            actionButton("update_buttons", "Update Buttons")
        ),
        mainPanel(
           uiOutput("buttons"),
           verbatimTextOutput("print_buttons")
        )
    )
)

server <- function(input, output) {
  vals <- reactiveValues(data = NULL,
                         button_counter = NULL)
  
  observeEvent(input$update_buttons, {
      vals$button_counter <- rep(1, num_buttons)
  })
  
  output$buttons <- renderUI({
    map(seq_along(1:input$num_buttons), function(i){
        actionButton(input[[paste0("button_", i)]])
        
        observeEvent(input[[paste0("button_",i)]], {
            vals$button_counter[i] <- vals$button_counter[i] + 1
        })
    })
  })
  output$print_buttons <- renderPrint({
      vals$button_counter
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
