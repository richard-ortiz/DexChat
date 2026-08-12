library(shiny)

# Define the UI
ui <- fluidPage(
    titlePanel("DEXCHAT: Dextran and Chitosan Solution Calculator"),
    sidebarLayout(
        sidebarPanel(
            numericInput("chitosan_weight", "Chitosan Weight (mg):", value = 100),
            numericInput("dextran_weight", "Dextran Weight (mg):", value = 50),
            actionButton("calculate", "Calculate")
        ),
        mainPanel(
            verbatimTextOutput("h2o_output"),
            verbatimTextOutput("pbs_output")
        )
    ),
    img(src = "https://pbs.twimg.com/profile_images/1367923144946823171/V87-h0o5_400x400.jpg", 
        style = "position: absolute; bottom: 10px; left: 10px; width: 20%; height: auto;")
)

# Define the server
server <- function(input, output) {
    observeEvent(input$calculate, {
        chitosan_weight_mg <- input$chitosan_weight
        dextran_weight_mg <- input$dextran_weight
        
        h2o_amount_ul <- chitosan_weight_mg / 0.05
        pbs_amount_ul <- dextran_weight_mg * 10
        
        output$h2o_output <- renderText({
            paste("Chitosan - Amount of H2O needed:", h2o_amount_ul, "μL")
        })
        
        output$pbs_output <- renderText({
            paste("Dextran - Amount of PBS needed:", pbs_amount_ul, "μL")
        })
    })
}

# Run the application
shinyApp(ui = ui, server = server)
