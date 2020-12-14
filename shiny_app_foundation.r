### SHiny App Template

library(shiny)


ui <- fluidPage(
  sliderInput(inputId = "num",   ## input ID is the name for the input, which can be referred to as later
              label = "Choose a number", ## this labels the input so the user knows what to do
              value = 25, min = 1, max = 1000), #Then there are arguments for each input, these are specific to each input
  
  ## Other ones I want to use, buttons, checkbox groups, select box, radio buttons, there are lots
  #Outputs
  
  #can place, table,s image plots, txt, UI elements, 
  
  plotOutput(outputId = "HIST",  # this dedicates space for the output object which is defined coded in the server function
             )
)

server <- function(input, output, session) {  ## this assembles the inputs and outputs
  # 3 rules for server function
  #1 - saving an output object 'output$hist <- code
  #2 - outputs need to use a render function, renders include plots, tables, text, UI
  #3 - Use the input values to create outputs, they are referenced bytheir nname input$num references the one above
  output$HIST <- renderPlot({ ## within the {} is a code block that will produce the plot or other output
    hist(rnorm(input$num))
    })  
    
  
}

shinyApp(ui, server)


