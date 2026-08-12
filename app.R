# app.R -------------------------------------------------------------------
#
# DEXCHAT: Dextran and Chitosan Solution Calculator
#
# Entry point for the Shiny application. Run locally with:
#   shiny::runApp()
#
# This file is deliberately thin. All arithmetic lives in R/calculations.R
# and all figure code lives in R/plots.R so both can be tested without
# launching the app.

library(shiny)
library(ggplot2)

# Load helpers. Files in R/ are sourced in alphabetical order.
for (f in list.files("R", pattern = "\\.R$", full.names = TRUE)) source(f)

# Shown only if you drop a logo into www/ (see www/README.md).
LOGO_FILE <- "logo.png"


# UI ----------------------------------------------------------------------

ui <- fluidPage(
  title = "DEXCHAT",
  titlePanel("DEXCHAT: Dextran and Chitosan Solution Calculator"),

  sidebarLayout(
    sidebarPanel(
      width = 3,
      numericInput(
        "chitosan_weight", "Chitosan weight (mg)",
        value = 100, min = 0, step = 10
      ),
      numericInput(
        "dextran_weight", "Dextran weight (mg)",
        value = 50, min = 0, step = 10
      ),
      actionButton("calculate", "Calculate", class = "btn-primary"),
      tags$hr(),
      helpText(
        sprintf(
          "Targets: chitosan at %g mg/mL in H2O, dextran at %g mg/mL in PBS.",
          CHITOSAN_CONC_MG_PER_UL * 1000,
          DEXTRAN_CONC_MG_PER_UL * 1000
        )
      ),
      if (file.exists(file.path("www", LOGO_FILE))) {
        tags$img(src = LOGO_FILE, style = "width: 60%; margin-top: 1.5rem;")
      }
    ),

    mainPanel(
      width = 9,
      uiOutput("summary"),
      tableOutput("results_table"),
      plotOutput("results_plot", height = "360px")
    )
  )
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {

  # eventReactive, not observeEvent: compute once, consume in several
  # outputs. Assigning outputs inside an observer (as an earlier version of
  # this app did) re-registers them on every click and leaks observers.
  results <- eventReactive(input$calculate, ignoreNULL = FALSE, {
    validate(
      need(isTruthy(input$chitosan_weight) && input$chitosan_weight >= 0,
           "Enter a chitosan weight of 0 mg or more."),
      need(isTruthy(input$dextran_weight) && input$dextran_weight >= 0,
           "Enter a dextran weight of 0 mg or more.")
    )
    solution_table(input$chitosan_weight, input$dextran_weight)
  })

  output$summary <- renderUI({
    df <- results()
    tags$ul(
      lapply(seq_len(nrow(df)), function(i) {
        tags$li(sprintf(
          "%s — add %.1f µL of %s to %g mg.",
          df$component[i], df$volume_ul[i], df$solvent[i], df$mass_mg[i]
        ))
      })
    )
  })

  output$results_table <- renderTable(
    {
      df <- results()
      data.frame(
        Component     = df$component,
        `Mass (mg)`   = df$mass_mg,
        Solvent       = df$solvent,
        `Volume (µL)` = round(df$volume_ul, 1),
        check.names   = FALSE
      )
    },
    striped = TRUE,
    width = "100%"
  )

  output$results_plot <- renderPlot(plot_solvent_volumes(results()))
}


shinyApp(ui = ui, server = server)
